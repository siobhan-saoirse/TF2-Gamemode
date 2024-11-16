if SERVER then
AddCSLuaFile( "shared.lua" )
	
function SWEP:SetFlamethrowerEffect(i)
	if self.LastEffect==i then return end
	
	umsg.Start("SetFlamethrowerEffect")
		umsg.Entity(self)
		umsg.Char(i)
	umsg.End()
	
	self.LastEffect = i
end

end

if CLIENT then

SWEP.PrintName			= "Flamethrower"
SWEP.Slot				= 0

function SWEP:SetFlamethrowerEffect(i)
	if self.LastEffect==i then return end
	
	local effect
	local t = GAMEMODE:EntityTeam(self.Owner)
	
	if i==1 then
		effect = "flamethrower"
	elseif i>1 then
		if t==2 then
			effect = "flamethrower_crit_blue"
		else
			effect = "flamethrower_crit_red"
		end
	end
	
	if self.Owner==LocalPlayer() and IsValid(self.Owner:GetViewModel()) and self.DrawingViewModel then
		local vm = self.Owner:GetViewModel()
		if IsValid(self.CModel) then
			vm = self.CModel
		end
		
		vm:StopParticles()
		if effect then
			ParticleEffectAttach(effect, PATTACH_POINT_FOLLOW, vm, vm:LookupAttachment("muzzle"))
		end
	else
		self:StopParticles()
		if effect then
			ParticleEffectAttach(effect, PATTACH_POINT_FOLLOW, self, self:LookupAttachment("muzzle"))
		end
	end
	
	self.LastEffect = i
end

usermessage.Hook("SetFlamethrowerEffect", function(msg)
	local w = msg:ReadEntity()
	local i = msg:ReadChar()
	if IsValid(w) and w.SetFlamethrowerEffect then
		w:SetFlamethrowerEffect(i)
	end
end)


end

PrecacheParticleSystem("flamethrower_fire_1")
PrecacheParticleSystem("flamethrower_crit_red")
PrecacheParticleSystem("flamethrower")
PrecacheParticleSystem("flamethrower_crit_blue")

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/v_models/v_flamethrower_pyro.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_flamethrower.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.MuzzleEffect = "pyro_blast"

SWEP.ShootSound = Sound("Weapon_FlameThrower.FireStart")
SWEP.SpecialSound1 = Sound("Weapon_FlameThrower.FireLoop")
SWEP.ShootCritSound = Sound("Weapon_FlameThrower.FireLoopCrit")
SWEP.ShootSoundEnd = Sound("Weapon_FlameThrower.FireEnd")
SWEP.FireHit = Sound("Weapon_FlameThrower.FireHit")
SWEP.PilotLoop = Sound("Weapon_FlameThrower.PilotLoop")

SWEP.AirblastSound = Sound("Weapon_FlameThrower.AirBurstAttack")
SWEP.AirblastDeflectSound = Sound("Weapon_FlameThrower.AirBurstAttackDeflect")

SWEP.Primary.ClipSize		= -1
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 0.04

SWEP.Secondary.Automatic	= true
SWEP.Secondary.Delay		= 0.5
SWEP.AirblastRadius = 80

SWEP.BulletSpread = 0.06

SWEP.IsRapidFire = true
SWEP.ReloadSingle = false

SWEP.HoldType = "PRIMARY"

SWEP.ProjectileShootOffset = Vector(3, 8, -5)

function SWEP:CreateSounds()
	self.SpinUpSound = CreateSound(self, self.ShootSound)
	self.SpinDownSound = CreateSound(self, self.ShootSoundEnd)
	self.FireSound = CreateSound(self, self.SpecialSound1)
	self.FireCritSound = CreateSound(self, self.ShootCritSound)
	self.PilotSound = CreateSound(self, self.PilotLoop)
	
	self.SoundsCreated = true
end

function SWEP:PrimaryAttack()
	if not self.IsDeployed then return false end
	
	if self:Ammo1()<=200 then
		return
	end
	
	local Delay = self.Delay or -1
	if Delay>=0 and CurTime()<Delay then return end
	self.Delay = CurTime() + self.Primary.Delay
	
	if not self.Firing then
		self.Firing = true
		self:SetFlamethrowerEffect(1)
		--self.Owner:SetAnimation(PLAYER_PREFIRE)
		self.SpinDownSound:Stop()
		self.SpinUpSound:Play()
		self.NextEndSpinUp = CurTime() + 3
	end
	
	if self.NextEndSpinUp and CurTime()>self.NextEndSpinUp then
		self.SpinUpSound:Stop()
		self.FireSound:Play()
		self.NextEndSpinUp = nil
	end
	
	if self:RollCritical() then
		if not self.Critting or not self.Firing then
			self.NextEndSpinUp = nil
			self:SetFlamethrowerEffect(2)
			self.FireSound:Stop()
			self.FireCritSound:Play()
			self.Firing = true
		end
		self.Critting = true
	elseif not self.NextEndSpinUp then
		if self.Critting or not self.Firing then
			self:SetFlamethrowerEffect(1)
			self.FireCritSound:Stop()
			self.FireSound:Play()
			self.Firing = true
		end
		self.Critting = false
	end
	
	self:SendWeaponAnim(self.VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	-- Take one ammo every 2 projectiles fired
	if not self.ParticleCounter then self.ParticleCounter = 1 end
	self.ParticleCounter = self.ParticleCounter + 1
	if self.ParticleCounter>2 then
		self.ParticleCounter = 1
		self:TakePrimaryAmmo(1)
	end
	
	self:ShootProjectile()
end

function SWEP:ShootProjectile()
	if SERVER then
		local flame = ents.Create("tf_flame")
		local ang = self.Owner:EyeAngles()
		local vec = ang:Forward() + math.Rand(-self.BulletSpread,self.BulletSpread) * ang:Right() + math.Rand(-self.BulletSpread,self.BulletSpread) * ang:Up()
		
		flame:SetPos(self:ProjectileShootPos())
		flame:SetAngles(vec:Angle())
		if self:Critical() then
			flame.critical = true
		end
		if self.Force then
			flame.Force = self.Force
		end
		flame:SetOwner(self.Owner)
		self:InitProjectileAttributes(flame)
		
		flame:Spawn()
		
		flame:SetVelocity(self.Owner:GetVelocity())
	end
end

function SWEP:SecondaryAttack()
	if not self.IsDeployed then return false end
	
	if self.NoAirblast then return false end
	
	if self:Ammo1()<0 then
		return
	end
	
	local Delay = self.Delay or -1
	if Delay>=0 and CurTime()<Delay then return end
	self.Delay = CurTime() + self.Secondary.Delay
	
	self:StopFiring()
	
	self:EmitSound(self.AirblastSound)
	
	if SERVER then
		umsg.Start("DoMuzzleFlash")
			umsg.Entity(self)
		umsg.End()
	end
	
	self:SendWeaponAnim(self.VM_SECONDARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
	
	self:TakePrimaryAmmo(0)
	if SERVER then
		self:DoAirblast()
	end
end

function SWEP:DoAirblast()
	local r = self.AirblastRadius
	local dir = self.Owner:GetAimVector()
	local dir2 = dir:Angle()
	dir2.p = math.Clamp(dir2.p - 45,-90,90)
	dir2 = dir2:Forward()
	
	local pos = self.Owner:GetShootPos() + r * 0.1 * dir
	local reflect
	
	for _,v in pairs(ents.FindInBox(pos-Vector(r,r,r),pos+Vector(r,r,r))) do
		c = v:GetClass()
		--print(v)
		if v:GetOwner()~=self.Owner then
			if v:IsTFPlayer() and self.Owner:IsValidEnemy(v) and v:ShouldReceiveDamageForce() then
				if v:GetMoveType()==MOVETYPE_VPHYSICS then
					for i=0,v:GetPhysicsObjectCount()-1 do
						v:GetPhysicsObjectNum(i):ApplyForceCenter(40000*dir)
					end
				else
					v:SetGroundEntity(NULL)
					v:SetLocalVelocity(dir2 * 550)
				end
			elseif v.Reflect then
				v:Reflect(self.Owner, self, dir)
				reflect = true
			elseif c=="grenade_spit" then
				v:SetLocalVelocity(dir * v:GetVelocity():Length())
				v:SetOwner(self.Owner)
				v.AttackerOverride = self.Owner
				v.NameOverride = "grenade_spit_deflect"
				reflect = true
			elseif c=="npc_grenade_frag" then
				local vel = v:GetPhysicsObject():GetVelocity()
				v:GetPhysicsObject():AddVelocity(dir * math.Clamp(vel:Length(),500,100000) - vel)
				
				v:SetOwner(self.Owner)
				v:SetPhysicsAttacker(self.Owner)
				v.AttackerOverride = self.Owner
				v.NameOverride = "npc_grenade_frag_deflect"
				reflect = true
			elseif c=="prop_combine_ball" then
				local phys = v:GetPhysicsObject()
				local vel = phys:GetVelocity()
				phys:AddVelocity(dir * math.Clamp(vel:Length(),500,100000) - vel)
				
				--v:GetPhysicsObject():ApplyForceCenter(200000*dir)
				v:SetOwner(self.Owner)
				v:SetPhysicsAttacker(self.Owner)
				v.AttackerOverride = self.Owner
				v.NameOverride = "prop_combine_ball_deflect"
				
				if phys:HasGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG) then
					-- The combine ball was fired by a NPC, and simply dissolves stuff without damaging them
					-- Convert it into a player combine ball when it is airblasted
					phys:ClearGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
					phys:AddGameFlag(FVPHYSICS_DMG_DISSOLVE)
					phys:AddGameFlag(FVPHYSICS_HEAVY_OBJECT)
				end
				
				reflect = true
			elseif c=="rpg_missile" then
				v:SetLocalVelocity(dir * 2000)
				local dmginfo = DamageInfo()
				dmginfo:SetDamage(1000)
				dmginfo:SetDamageType(DMG_AIRBOAT)
				v:TakeDamageInfo(dmginfo)
				v:SetOwner(self.Owner)
				v.AttackerOverride = self.Owner
				v.NameOverride = "rpg_missile_deflect"
				reflect = true
			end
		end
	end
	
	if reflect then
		self:EmitSound(self.AirblastDeflectSound)
	end
end

function SWEP:Reload()
end

function SWEP:StopFiring()
	self.Firing = false
	self.Critting = false
	self:SetFlamethrowerEffect(0)
	self.SpinUpSound:Stop()
	self.SpinDownSound:Play()
	if self.Primary.Delay == 0.06 then
		self.SpinDownSound:ChangePitch(120)
	end
	self.FireSound:Stop()
	self.FireCritSound:Stop()
	self.Owner:SetAnimation(PLAYER_POSTFIRE)
	self.NextIdle = CurTime() + 0.04
end

function SWEP:Think()
	if SERVER and self.ForceReplayDeployAnim then
		self:SendWeaponAnim(self.VM_DRAW)
		self.ForceReplayDeployAnim = false
	end
	
	if not self.IsDeployed and self.NextDeployed and CurTime()>=self.NextDeployed then
		self.IsDeployed = true
	end
	
	if not self.SoundsCreated then
		self:CreateSounds()
	end
	
	if self.NextIdle and CurTime()>=self.NextIdle then
		self:SendWeaponAnim(self.VM_IDLE)
		self.NextIdle = nil
	end
	
	if self.Firing and (not self.Owner:KeyDown(IN_ATTACK) or self:Ammo1()<=0) then
		self:StopFiring()
	end
end

function SWEP:Deploy()
	if not self.SoundsCreated then
		self:CreateSounds()
	end
	self.PilotSound:Play()
	
	--MsgN(Format("Flamethrower Deploy %s",tostring(self)))
	return self:CallBaseFunction("Deploy")
end

function SWEP:Holster()
	if SERVER then
		self.SpinUpSound:Stop()
		self.SpinDownSound:Stop()
		self.FireSound:Stop()
		self.FireCritSound:Stop()
		self.PilotSound:Stop()
	end
	
	self.Firing = false
	self.Critting = false
	self:SetFlamethrowerEffect(0)
	
	return self:CallBaseFunction("Holster")
end

function SWEP:OnRemove()
	self:Holster()
end
