if SERVER then
AddCSLuaFile( "shared.lua" )
include("sv_airblast.lua")

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
	if not IsValid(self.Owner) then return end
	
	local effect
	local t = GAMEMODE:EntityTeam(self.Owner)
	if GetConVar("tf_pyrovision"):GetBool() then
		if i==1 then
			effect = "flamethrower_rainbow"
		elseif i>1 then
			if t==2 then
				effect = "flamethrower_rainbow"
			else
				effect = "flamethrower_rainbow"
			end
		end	
	else
		if (self.Owner:WaterLevel() > 1) then
		
			effect = "flamethrower_underwater"
				
		else
			if i==1 then
				effect = "flamethrower"
			elseif i>1 then
				if t==2 then
					effect = "flamethrower_crit_blue"
				else
					effect = "flamethrower_crit_red"
				end
			end
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

usermessage.Hook("TFAirblastImpact", function(msg)
	LocalPlayer():EmitSound("TFPlayer.AirBlastImpact")
end)

end

PrecacheParticleSystem("flamethrower_fire_1")
PrecacheParticleSystem("flamethrower_crit_red")
PrecacheParticleSystem("flamethrower")
PrecacheParticleSystem("flamethrower_crit_blue")
PrecacheParticleSystem("flamethrower_underwater")
PrecacheParticleSystem("pyro_blast")
PrecacheParticleSystem("pyro_blast_flash")
PrecacheParticleSystem("pyro_blast_lines")
PrecacheParticleSystem("pyro_blast_warp")
PrecacheParticleSystem("pyro_blast_warp2")

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_pyro_arms_empty.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_flamethrower/c_flamethrower.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

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
SWEP.Secondary.Delay		= 0.8
SWEP.AirblastRadius = 80

SWEP.BulletSpread = 0.1

SWEP.IsRapidFire = true
SWEP.ReloadSingle = false

SWEP.HoldType = "PRIMARY"
SWEP.HoldTypeHL2 = "crossbow"

SWEP.ProjectileShootOffset = Vector(3, 8, -5)

function SWEP:CreateSounds(owner)
	if not IsValid(owner) then return end
	
	if (IsValid(self.Owner) and string.find(self.Owner:GetModel(),"_boss.mdl")) then
				
		self.ShootSound = Sound("MVM.GiantPyro_FlameStart")
		self.SpecialSound1 = Sound("MVM.GiantPyro_FlameLoop")
		self.ShootCritSound = Sound("MVM.GiantPyro_FlameLoop") 
		
	end
	
	self.SpinUpSound = CreateSound(owner, self.ShootSound)
	self.SpinDownSound = CreateSound(owner, self.ShootSoundEnd)
	self.FireSound = CreateSound(owner, self.SpecialSound1)
	self.FireCritSound = CreateSound(owner, self.ShootCritSound)
	self.PilotSound = CreateSound(owner, self.PilotLoop)
	
	self.SoundsCreated = true 
end

function SWEP:PrimaryAttack()
	if not self.IsDeployed then return false end
	
	if self.Owner:GetMaterial() == "models/shadertest/predator" then return false end
	if self:Ammo1()<=0 then
		return
	end
	
	local Delay = self.Delay or -1
	if Delay>=0 and CurTime()<Delay then return end
	self.Delay = CurTime() + self.Primary.Delay
	
	if not self.Firing then
		self.Firing = true
		self:SetFlamethrowerEffect(1)
		self.SpinDownSound:Stop()
		self.SpinUpSound:Play()
		
		if SERVER then
			--self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_PREFIRE, true)
		end
	
		if self.Primary.Delay == 0.015 then
			self.SpinUpSound:ChangePitch(120)
		end
		if (string.find(self.Owner:GetModel(),"_boss.mdl")) then
			self.NextEndSpinUp = CurTime() + 1.5
		else
			self.NextEndSpinUp = CurTime() + 3
		end
	end
	
	if self.NextEndSpinUp and CurTime()>self.NextEndSpinUp then
		self.SpinUpSound:Stop()
		self.FireSound:Play()
		if self.Primary.Delay == 0.015 then
			self.FireSound:ChangePitch(120)
		end
		self.NextEndSpinUp = nil
	end
	
	if self:RollCritical() and not self.NextEndSpinUp then
		if not self.Critting or not self.Firing then
			self.NextEndSpinUp = nil
			self:SetFlamethrowerEffect(2)
			self.FireSound:Stop()
			self.FireCritSound:Play()
			if self.Primary.Delay == 0.015 then
				self.FireCritSound:ChangePitch(120)
			end
			self.Firing = true
		end
		self.Critting = true
	elseif not self.NextEndSpinUp then
		if self.Critting or not self.Firing then
			self:SetFlamethrowerEffect(1)
			self.FireCritSound:Stop()
			self.FireSound:Play()
			if self.Primary.Delay == 0.015 then
				self.FireSound:ChangePitch(120)
			end
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
		if (self.Owner:WaterLevel() > 1) then
			return
		end
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
		
		local d = self:GetItemData()
		if d.item_iconname then
			flame.NameOverride = d.item_iconname
		end
		
		flame:Spawn()
		
		flame:SetVelocity(self.Owner:GetVelocity())
	end
end

function SWEP:SecondaryAttack()
	if not self.IsDeployed then return false end
	
	if self.NoAirblast then return false end
	
	if self:Ammo1()<20 then
		return
	end
	
	local Delay = self.Delay or -1
	if Delay>=0 and CurTime()<Delay then return end
	self.Delay = CurTime() + self.Secondary.Delay
	
	self:StopFiring()
	
	--self.Owner:DoAnimationEvent(self.Owner:SelectWeightedSequence(self.Owner:LookupSequence("SECONDARYAttackStand_PRIMARY")),true) 
	self:EmitSound(self.AirblastSound)
	
	if SERVER then
		umsg.Start("DoMuzzleFlash")
			umsg.Entity(self)
		umsg.End()
	end
	
	
	// This is the VM airblast animation. It's broken.
	--self.SendWeaponAnim(self.VM_SECONDARYATTACK) // old implementation, doesn't work
	self:SendWeaponAnim(ACT_PRIMARY_VM_SECONDARYATTACK) // new implementation, works? VM glitches, community primary weapons fail?
	self.NextIdle = CurTime() + self:SequenceDuration() - 0.2 // culprit?
	
	if SERVER then
		--self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_SECONDARYFIRE, true)
	end
	self:TakePrimaryAmmo(20)
	if SERVER then
		self:DoAirblast()
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
	if SERVER then
		--self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_POSTFIRE, true)
	end
	self.NextIdle = CurTime() + 0.04
end

function SWEP:Think()
	self:TFViewModelFOV()
	
	if (IsValid(self.Owner) and string.find(self.Owner:GetModel(),"_boss.mdl")) then
				
		self.ShootSound = Sound("MVM.GiantPyro_FlameStart")
		self.SpecialSound1 = Sound("MVM.GiantPyro_FlameLoop")
		self.ShootCritSound = Sound("MVM.GiantPyro_FlameLoop") 
		
	end
	if SERVER and self.NextReplayDeployAnim then
		if CurTime() > self.NextReplayDeployAnim then
			--MsgFN("Replaying deploy animation %d", self.VM_DRAW)
			timer.Simple(0.1, function() self:SendWeaponAnim(self.VM_DRAW) end)
			self.NextReplayDeployAnim = nil
		end
	end
	
	if not self.IsDeployed and self.NextDeployed and CurTime()>=self.NextDeployed then
		self.IsDeployed = true
	end
	
	if not self.SoundsCreated then
		self:CreateSounds(self.Owner)
	end
	
	if self.NextIdle and CurTime()>=self.NextIdle then
		self:SendWeaponAnim(self.VM_IDLE)
		self.NextIdle = nil
	end
	
	if self.Firing and (not self.Owner:KeyDown(IN_ATTACK) or self:Ammo1()<=0) then
		self:StopFiring()
	end
	
	self:Inspect()
end

function SWEP:Deploy()
	if not self.SoundsCreated then
		self:CreateSounds(self.Owner)
	end
	
	if self.SoundsCreated then
		self.PilotSound:Play()
	end
	
	--MsgN(Format("Flamethrower Deploy %s",tostring(self)))
	return self:CallBaseFunction("Deploy")
end

function SWEP:Holster()
	if self.SoundsCreated then
		self.SpinUpSound:Stop()
		self.SpinDownSound:Stop()
		self.FireSound:Stop()
		self.FireCritSound:Stop()
		self.PilotSound:Stop()
	end
	
	self.Firing = false
	self.Critting = false
	self:SetFlamethrowerEffect(0)
	
	--self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_POSTFIRE, true)
	
	return self:CallBaseFunction("Holster")
end

function SWEP:OnRemove()
	self:Holster()
end
