if SERVER then
	AddCSLuaFile( "shared.lua" )
	
function SWEP:SetMinigunEffect(i)
	if self.LastEffect==i then return end
	
	umsg.Start("SetMinigunEffect")
		umsg.Entity(self)
		umsg.Char(i)
	umsg.End()
	
	self.LastEffect = i
end

end

if CLIENT then

SWEP.PrintName			= "Gatling Gun"
SWEP.Slot				= 4
SWEP.barrelRotation 		= 0
SWEP.barrelSpeed 			= 0
SWEP.barrelValue1 			= 0
SWEP.RenderGroup		= RENDERGROUP_BOTH

function SWEP:SetMinigunEffect(i)
	if self.LastEffect==i then return end
	
	local effect
	
	if i==1 then
		effect = "muzzle_minigun_constant"
	end
	
	if self:GetOwner()==LocalPlayer() and IsValid(self:GetOwner():GetViewModel()) and self.DrawingViewModel then
		local vm = self:GetViewModelEntity()
		vm:StopParticles()
		if effect then
			ParticleEffectAttach(effect, PATTACH_POINT_FOLLOW, vm, vm:LookupAttachment("muzzle"))
		end
	else
		local ent = self:GetWorldModelEntity()
		ent:StopParticles()
		if effect then
			ParticleEffectAttach(effect, PATTACH_POINT_FOLLOW, ent, ent:LookupAttachment("muzzle"))
		end
	end
	
	self.LastEffect = i
end

usermessage.Hook("SetMinigunEffect", function(msg)
	local w = msg:ReadEntity()
	local i = msg:ReadChar()
	if IsValid(w) and w.SetMinigunEffect then
		w:SetMinigunEffect(i)
	end
end)


SWEP.MinigunMaxSpinSpeed = 10
SWEP.MinigunSpinAcceleration = 0.07

function SWEP:InitializeCModel()
	self:CallBaseFunction("InitializeCModel")
	
	if IsValid(self.CModel) then
		if string.lower(self.CModel:GetModel()) == "models/weapons/c_models/c_leviathan/c_leviathan.mdl" then
			self.CModel.LeviathanBarrelFix = true
		end
	end
end

function SWEP:InitializeWModel2()
	self:CallBaseFunction("InitializeWModel2")
end

function SWEP:MinigunViewmodelReset()
	if self:GetOwner()==LocalPlayer() then
		self:GetViewModelEntity():RemoveBuildBoneHook("MinigunSpin")
	end
end

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/v_models/v_minigun_dm.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_minigun_dm.mdl"
SWEP.Crosshair = "tf_crosshair4"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.MuzzleEffect = "muzzle_minigun_constant"
SWEP.MuzzleOffset = Vector(20, 3, -10)
SWEP.TracerEffect = "bullet_tracer01"
PrecacheParticleSystem("muzzle_minigun_constant")
PrecacheParticleSystem("bullet_tracer01_red")
PrecacheParticleSystem("bullet_tracer01_red_crit")
PrecacheParticleSystem("bullet_tracer01_blue")
PrecacheParticleSystem("bullet_tracer01_blue_crit")

SWEP.BaseDamage = 4
SWEP.DamageRandomize = 0
SWEP.MaxDamageRampUp = 0.5
SWEP.MaxDamageFalloff = 0.2

SWEP.BulletsPerShot = 4
SWEP.BulletSpread = 0.08

SWEP.Primary.ClipSize		= -1
SWEP.Primary.Ammo			= TF_SECONDARY
SWEP.Primary.Delay          = 0.08

SWEP.Secondary.Delay          = 0.1

SWEP.IsRapidFire = true

SWEP.HoldType = "PRIMARY"
SWEP.HoldTypeHL2 = "crossbow"

SWEP.ReloadSound = Sound("Weapon_Minigun.Reload")
SWEP.EmptySound = Sound("Weapon_Minigun.ClipEmpty")
SWEP.ShootSound2 = Sound("weapons/chaingun_fire.wav")
SWEP.SpecialSound1 = Sound("weapons/chaingun_windup.wav")
SWEP.SpecialSound2 = Sound("weapons/chaingun_winddown.wav")
SWEP.SpecialSound3 = Sound("Weapon_Minigun.Spin")
SWEP.ShootCritSound = Sound("weapons/chaingun_fire_crit.wav")
SWEP.DeploySound = Sound("weapons/draw_default.wav")

function SWEP:CreateSounds()
	self.SpinUpSound = CreateSound(self:GetOwner(), self.SpecialSound1)
	self.SpinDownSound = CreateSound(self:GetOwner(), self.SpecialSound2)
	self.SpinSound = CreateSound(self:GetOwner(), self.SpecialSound3)
	self.ShootSoundLoop = CreateSound(self:GetOwner(), self.ShootSound2)
	self.ShootCritSoundLoop = CreateSound(self:GetOwner(), self.ShootCritSound)
	
	self.SoundsCreated = true
end

function SWEP:SpinUp()
	if SERVER then
		self:GetOwner().minigunfiretime = 0
		self:GetOwner():Speak("TLK_WINDMINIGUN", true)
	end
	
	--self:GetOwner():SetAnimation(10004)
	
	if self:GetOwner():GetPlayerClass() != "merc_dm" then
		self:GetOwner():DoAnimationEvent(ACT_MP_ATTACK_STAND_PREFIRE, true)
		self:SendWeaponAnim(ACT_MP_ATTACK_STAND_PREFIRE)
	end
	
	self:SendWeaponAnim(ACT_MP_ATTACK_STAND_PREFIRE)
	
	self:SetNetworkedBool("Spinning", true)
	
	self.Spinning = true
	
	self.NextEndSpinUp = CurTime() + 0.5 * (self.MinigunSpinupMultiplier or 1)
	self.NextEndSpinUpSound = CurTime() + 0.5
	self.NextEndSpinDown = nil
	self.NextIdle = nil
	
	self.SpinDownSound:Stop()
	self.SpinSound:Stop()
	self.SpinUpSound:Play()
end

function SWEP:SpinDown()
	--self:GetOwner():SetAnimation(10005)
	if self:GetOwner():GetPlayerClass() != "merc_dm" then
		self:GetOwner():DoAnimationEvent(ACT_MP_ATTACK_STAND_POSTFIRE, true)
	end
	
		self:SendWeaponAnim(ACT_MP_ATTACK_STAND_POSTFIRE)
	self.Ready = false
	self.NextEndSpinUp = nil
	self.NextEndSpinUpSound = nil
	self.NextEndSpinDown = CurTime() + self:SequenceDuration()
	self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
	

	--self:GetOwner():DoAnimationEvent(ACT_MP_STAND_PRIMARY, true)
	self:SetNetworkedBool("Spinning", false)
	self.Spinning = false
	
	self.SpinUpSound:Stop()
	self.SpinSound:Stop()
	self.SpinDownSound:Play()
end

function SWEP:ShootEffects()
end

function SWEP:StopFiring()
	if SERVER then
		self:SetMinigunEffect(0)
		self:GetOwner().minigunfiretime = 0
		self.StartTime = nil
		self:GetOwner():SetAnimation(PLAYER_IDLE)
	end
	
	self.SpinSound:Play()
	self.ShootSoundLoop:Stop()
	self.ShootCritSoundLoop:Stop()
	self.Firing = false
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():GetAmmoCount(self.Primary.Ammo) <= 0 then
	
		self:EmitSound("weapons/shotgun_empty.wav", 80, 100)
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		self:Reload()
		return false
		
	end

	return true
end

function SWEP:PrimaryAttack(vampire)
	if not self.IsDeployed then return false end
	if self:GetOwner():IsBot() and GetConVar("tf_bot_melee_only"):GetBool() then
		self:GetOwner():SelectWeapon(self:GetOwner():GetWeapons()[3])
		return
	end
	
	if not self.Spinning then
		self.IsVampire = vampire
		self:SpinUp()
	end
	
	if not self.Ready then return end
	
	if not self:CanPrimaryAttack() then
		if self.Firing then self:StopFiring() end
		return
	end
	
	local Delay = self.Delay or -1
	
	if Delay>=0 and CurTime()<Delay then return end
	self.Delay = CurTime() + self.Primary.Delay
	
	if SERVER then
		if not self.StartTime then
			self.StartTime = CurTime()
			self:GetOwner():Speak("TLK_FIREMINIGUN", true)
		end
		
		self:GetOwner().minigunfiretime = CurTime() - self.StartTime
		
		if not self.NextPlayerTalk or CurTime()>self.NextPlayerTalk then
			self:GetOwner():Speak("TLK_FIREMINIGUN")
			self.NextPlayerTalk = CurTime() + 1
		end
	end
	
	if self:RollCritical() then
		if not self.Critting or not self.Firing then
			self:SetMinigunEffect(1)
			self.SpinSound:Stop()
			self.ShootSoundLoop:Stop()
			self.ShootCritSoundLoop:Play()
			self.Firing = true
		end
		self.Critting = true
	else
		if self.Critting or not self.Firing then
			self:SetMinigunEffect(1)
			self.SpinSound:Stop()
			self.ShootCritSoundLoop:Stop()
			self.ShootSoundLoop:Play()
			self.Firing = true
		end
		self.Critting = false
	end
	
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	
	self:ShootProjectile(self.BulletsPerShot, self.BulletSpread)
	self:TakePrimaryAmmo(1)
	self:RustyBulletHole()
end

function SWEP:SecondaryAttack()
	if self.AltFireMode == 0 then
		return self:PrimaryAttack(true)
	end
	
	if not self.IsDeployed then return false end
	
	if not self.Spinning then
		self:SpinUp()
	end
end

function SWEP:Reload()
end

function SWEP:Think()
	self:TFViewModelFOV()

	if SERVER and self.NextReplayDeployAnim then
		if CurTime() > self.NextReplayDeployAnim then
			--MsgFN("Replaying deploy animation %d", self.VM_DRAW)
			timer.Simple(0.1, function() self:SendWeaponAnim(self.VM_DRAW) end)
			self.NextReplayDeployAnim = nil
		end
	end
	
	if self:GetOwner():GetPlayerClass() == "merc_dm" then
		self.Primary.Ammo			= TF_SECONDARY
		self:SetHoldType("ITEM2")
	else
		self.Primary.Ammo			= TF_PRIMARY
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
	
	if self.NextEndSpinUpSound and CurTime()>=self.NextEndSpinUpSound then
		self.SpinUpSound:Stop()
		self.SpinSound:Play()
		self.NextEndSpinUpSound = nil
	end
	
	if self.NextEndSpinUp and CurTime()>=self.NextEndSpinUp then
		self.Ready = true
		----self:GetOwner():DoAnimationEvent(ACT_MP_DEPLOYED, true)
		self.NextEndSpinUp = nil
	end
	
	if self.NextEndSpinDown and CurTime()>=self.NextEndSpinDown then
		self.NextEndSpinDown = nil
	end
	
	if self.Firing and not self:GetOwner():KeyDown(IN_ATTACK) and (self.AltFireMode ~= 1 or not self:GetOwner():KeyDown(IN_ATTACK2)) then
		self:StopFiring()
		self:SendWeaponAnim(self.VM_SECONDARYATTACK)
	end
	
	if self.Spinning and not self.NextEndSpinDown and not self:GetOwner():KeyDown(IN_ATTACK) and not self:GetOwner():KeyDown(IN_ATTACK2) then
		if not self.NextEndSpinUp or CurTime() > self.NextEndSpinUp then
			self:SpinDown()
		end
	end
	
	if CLIENT then
	
		if self:GetNetworkedBool("Spinning") then
			--[[if self:GetItemData().attach_to_hands == 1 then
				return
			end]]
			
			if self.barrelSpeed <= 12 then
			
				self.barrelRotation = self.barrelRotation + self.barrelSpeed
				self.barrelSpeed = self.barrelSpeed + ( CurTime() - self.barrelValue1 ) * 22
					
			end
				
			if self.barrelSpeed > 12 then
				
				self.barrelSpeed = 2
					
			end
				
			if self.barrelRotation > 360 then
				
				self.barrelRotation = self.barrelRotation - 360
					
			end
				
		end
		
		if not self:GetNetworkedBool("Spinning") then
		
			if self.barrelSpeed > 0 then
			
				self.barrelRotation = self.barrelRotation + self.barrelSpeed
				self.barrelSpeed = self.barrelSpeed - ( CurTime() - self.barrelValue1 ) * 30
				
			end
			
			if self.barrelSpeed < 0 then
			
				self.barrelSpeed = 0
				
			end
			
		end
		
	end
	
	if self.barrelSpeed == 0 then
		if self:GetItemData().attach_to_hands == 1 then
			if CLIENT and self:GetOwner():GetViewModel():LookupBone("v_minigun_barrel") then
				self:StopSound(self.SpecialSound2)
			end
		else
			self:GetOwner():GetViewModel():ManipulateBoneAngles( self:GetOwner():GetViewModel():LookupBone("v_minigun_barrel"), Angle(0,0,0) )
		end
	end
	
	if ( CLIENT ) then
		if self:GetOwner():GetViewModel():LookupBone("v_minigun_barrel") then
			self:GetOwner():GetViewModel():ManipulateBoneAngles( self:GetOwner():GetViewModel():LookupBone("v_minigun_barrel"), Angle(0,0,0) )
			self:GetOwner():GetViewModel():ManipulateBoneAngles( self:GetOwner():GetViewModel():LookupBone("v_minigun_barrel"), Angle(0,0,0) )
		else
			return
		end
	else
		//:ManipulateBoneAngles( self:GetOwner():GetViewModel():LookupBone("v_minigun_barrel"), Angle(0,0,0) )
	end

	self.barrelValue1 = CurTime()
	
	self:Inspect()
	
end

function SWEP:Holster()
	if IsValid(self:GetOwner()) and self:GetNetworkedBool("Spinning") then
		self:GetOwner():DoAnimationEvent(ACT_MP_ATTACK_STAND_POSTFIRE, true)
	end
	
	if not self.Removed and (self.Spinning or (self.NextEndSpinDown and CurTime() < self.NextEndSpinDown)) then
		return false
	end
	
	if self.SoundsCreated then
		self.SpinUpSound:Stop()
		self.SpinDownSound:Stop()
		self.SpinSound:Stop()
		self.ShootSoundLoop:Stop()
		self.ShootCritSoundLoop:Stop()
	end
	
	self.Spinning = nil
	self.Ready = nil
	self.NextEndSpinUp = nil
	self.NextEndSpinDown = nil
	
	if SERVER and IsValid(self:GetOwner()) then
		--self:GetOwner():DoAnimationEvent(ACT_MP_STAND_PRIMARY, true)
		self:GetOwner():ResetClassSpeed()
	end
	
	if CLIENT then
		if self:GetOwner()==LocalPlayer() then
			self.ViewmodelInitialized = false
			self:MinigunViewmodelReset()
		end
	end
	
	if self:GetItemData().attach_to_hands == 1 then

	elseif self:GetOwner() and IsValid(self:GetOwner():GetViewModel()) then
		self:GetOwner():GetViewModel():ManipulateBoneAngles( 2, Angle(0,0,0) )
	end
	
	return self:CallBaseFunction("Holster")
end

function SWEP:OnRemove()
	self.Owner = self.CurrentOwner
	self.Removed = true
	self:Holster()
end

if SERVER then

hook.Add("PreScaleDamage", "MinigunVampirePreDamage", function(ent, hitgroup, dmginfo)
	local inf = dmginfo:GetInflictor()
	local att = dmginfo:GetAttacker()
	
	if inf.IsVampire and ent ~= att and ent:IsTFPlayer() and ent:Health()>0 and not ent:IsBuilding() then
		if not att.LastHealthBuffTime or CurTime() ~= att.LastHealthBuffTime then
			GAMEMODE:HealPlayer(att, att, 3, true, false)
			att.LastHealthBuffTime = CurTime()
		end
	end
end)

hook.Add("PostScaleDamage", "MinigunVampirePostDamage", function(ent, hitgroup, dmginfo)
	local inf = dmginfo:GetInflictor()
	
	if inf.IsVampire then
		dmginfo:ScaleDamage(0.25)
	end
end)

end
