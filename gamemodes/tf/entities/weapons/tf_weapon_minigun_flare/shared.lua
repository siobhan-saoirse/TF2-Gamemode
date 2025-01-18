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

SWEP.PrintName			= "L4D Minigun"
SWEP.Slot				= 0
SWEP.RenderGroup		= RENDERGROUP_BOTH

function SWEP:SetMinigunEffect(i)
	if self.LastEffect==i then return end
	
	local effect
	
	if i==1 then
		effect = "muzzle_minigun_constant"
	end
	
	if self.Owner==LocalPlayer() and IsValid(self.Owner:GetViewModel()) and self.DrawingViewModel then
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


SWEP.MinigunMaxSpinSpeed = 0
SWEP.MinigunSpinAcceleration = 0

local function MinigunBuildBoneW(ent)
	if IsValid(ent.MinigunEntity) and ent.MinigunEntity==ent.MinigunEntity.Owner:GetActiveWeapon() then
		local bone = ent:LookupBone("barrel")
		
		local mat = ent:GetBoneMatrix(bone)
		
		if mat then
			mat:Rotate(Angle(0, ent.MinigunEntity.BarrelAngle or 0, 0))
			ent:SetBoneMatrix(bone, mat)
		end
	end
end

local function MinigunBuildBoneV(ent)
	if IsValid(ent.MinigunEntity) and ent.MinigunEntity==ent.MinigunEntity.Owner:GetActiveWeapon() then
		local bone = ent:LookupBone("v_minigun_barrel")
		
		local mat = ent:GetBoneMatrix(bone)
		
		if mat then
			mat:Rotate(Angle(0, 0, ent.MinigunEntity.BarrelAngle or 0))
			ent:SetBoneMatrix(bone, mat)
		end
	end
end

function SWEP:InitializeCModel()
	self:CallBaseFunction("InitializeCModel")
	
	if IsValid(self.CModel) then
		self.CModel.MinigunEntity = self
		self.CModel:AddBuildBoneHook("MinigunBarrel", MinigunBuildBoneW)
	end
end

function SWEP:InitializeWModel2()
	self:CallBaseFunction("InitializeWModel2")
	
	if IsValid(self.WModel2) then
		self.WModel2.MinigunEntity = self
		--self.WModel2:AddBuildBoneHook("MinigunBarrel", MinigunBuildBoneW)
	end
end

function SWEP:ViewModelDrawn()
	if not self.ViewmodelInitialized then
		self:MinigunViewmodelSpin()
	end
	
	self:CallBaseFunction("ViewModelDrawn")
end

--[[
function SWEP:BuildBonePositions()
	local bone = self:LookupBone("barrel")
	
	local mat = self:GetBoneMatrix(bone)
	mat:Rotate(Angle(0, self.BarrelAngle or 0, 0))
	self:SetBoneMatrix(bone, mat)
end]]

function SWEP:MinigunViewmodelSpin()
	--Msg("MinigunViewmodelSpin\n")
	if self.Owner==LocalPlayer() then
		if self:GetItemData().attach_to_hands == 1 then
			return
		end
		
		local vm = self.Owner:GetViewModel()
		if vm and vm:IsValid() then
			vm.MinigunEntity = self
			vm:AddBuildBoneHook("MinigunBarrel", MinigunBuildBoneV)
			
			vm:InvalidateBoneCache()
			vm:SetupBones()
			self.ViewmodelInitialized = true
		end
	end
end

function SWEP:MinigunViewmodelReset()
	if self.Owner==LocalPlayer() then
		self:GetViewModelEntity():RemoveBuildBoneHook("MinigunSpin")
	end
end

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_heavy_arms.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_minigun.mdl"
SWEP.Crosshair = "tf_crosshair4"

SWEP.MuzzleEffect = "muzzle_minigun_constant"
SWEP.MuzzleOffset = Vector(20, 3, -10)
SWEP.TracerEffect = "bullet_tracer01"

SWEP.BaseDamage = 8
SWEP.DamageRandomize = 0
SWEP.MaxDamageRampUp = 0.9
SWEP.MaxDamageFalloff = 0.2

SWEP.BulletsPerShot = 4
SWEP.BulletSpread = 0.08

SWEP.Primary.ClipSize		= -1
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 0.07

SWEP.Secondary.Delay          = 0.1

SWEP.IsRapidFire = true

SWEP.HoldType = "PRIMARY"

SWEP.ReloadSound = Sound("Weapon_Minigun.Reload")
SWEP.EmptySound = Sound("Weapon_Minigun.ClipEmpty")
SWEP.ShootSound2 = Sound("weapons/minigun/gunfire/minigun_fire.wav")
SWEP.SpecialSound1 = Sound("weapons/minigun/gunother/minigun_wind_up.wav")
SWEP.SpecialSound2 = Sound("weapons/minigun/gunother/minigun_wind_down.wav")
SWEP.SpecialSound3 = Sound("Weapon_Minigun.Spin")
SWEP.ShootCritSound = Sound("weapons/minigun/gunfire/minigun_fire.wav")

function SWEP:CreateSounds()
	self.SpinUpSound = CreateSound(self.Owner, self.SpecialSound1)
	self.SpinDownSound = CreateSound(self.Owner, self.SpecialSound2)
	self.SpinSound = CreateSound(self.Owner, self.SpecialSound3)
	self.ShootSoundLoop = CreateSound(self.Owner, self.ShootSound2)
	self.ShootCritSoundLoop = CreateSound(self.Owner, self.ShootCritSound)
	
	self.SoundsCreated = true
end

function SWEP:SpinUp()
	if SERVER then
		self.Owner.minigunfiretime = 0
		self.Owner:Speak("TLK_WINDMINIGUN", true)
	end
	
	--self.Owner:SetAnimation(10004)
	
	if SERVER then
		self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_PREFIRE, true)
	end
	
	self:SendWeaponAnim(self.VM_PREFIRE)
	
	self:SetNetworkedBool("Spinning", true)
	
	self.Spinning = true
	
	self.NextEndSpinUp = CurTime() + 0.87 * (self.MinigunSpinupMultiplier or 1)
	self.NextEndSpinUpSound = CurTime() + 0.87
	self.NextEndSpinDown = nil
	self.NextIdle = nil
	
	self.SpinDownSound:Stop()
	self.SpinSound:Stop()
	self.SpinUpSound:Play()
end

function SWEP:SpinDown()
	--self.Owner:SetAnimation(10005)
	self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_POSTFIRE, true)
	self:SendWeaponAnim(self.VM_POSTFIRE)
	
	self.Ready = false
	self.NextEndSpinUp = nil
	self.NextEndSpinUpSound = nil
	self.NextEndSpinDown = CurTime() + self:SequenceDuration()
	self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
	
	self.Owner:SetNWBool("MinigunReady", false)
	--self.Owner:DoAnimationEvent(ACT_MP_STAND_PRIMARY, true)
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
		self.Owner.minigunfiretime = 0
		self.StartTime = nil
	end
	
	self.ShootSoundLoop:Stop()
	self.ShootCritSoundLoop:Stop()
	self.Firing = false
end

function SWEP:CanPrimaryAttack()
	if self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
	
		self:EmitSound("weapons/shotgun_empty.wav", 80, 100)
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		self:Reload()
		return false
		
	end

	return true
end

function SWEP:PrimaryAttack(vampire)
	if not self.IsDeployed then return false end
	if self.Owner:IsBot() and GetConVar("tf_bot_melee_only"):GetBool() then
		self.Owner:SelectWeapon(self.Owner:GetWeapons()[3])
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
			self.Owner:Speak("TLK_FIREMINIGUN", true)
		end
		
		self.Owner.minigunfiretime = CurTime() - self.StartTime
		
		if not self.NextPlayerTalk or CurTime()>self.NextPlayerTalk then
			self.Owner:Speak("TLK_FIREMINIGUN")
			self.NextPlayerTalk = CurTime() + 1
		end
	end
	
	if self:RollCritical() then
		if not self.Critting or not self.Firing then
			self:SetMinigunEffect(1)
			self.ShootSoundLoop:Stop()
			self.ShootCritSoundLoop:Play()
			self.Firing = true
		end
		self.Critting = true
	else
		if self.Critting or not self.Firing then
			self:SetMinigunEffect(1)
			self.ShootCritSoundLoop:Stop()
			self.ShootSoundLoop:Play()
			self.Firing = true
		end
		self.Critting = false
	end
	
	self:SendWeaponAnim(self.VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	self:ShootProjectile(self.BulletsPerShot, self.BulletSpread)
	self:TakePrimaryAmmo(1)
end

function SWEP:SecondaryAttack()
	if self.AltFireMode == 1 then
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
	if SERVER and self.NextReplayDeployAnim then
		if CurTime() > self.NextReplayDeployAnim then
			--MsgFN("Replaying deploy animation %d", self.VM_DRAW)
			timer.Simple(0.1, function() self:SendWeaponAnim(self.VM_DRAW) end)
			self.NextReplayDeployAnim = nil
		end
	end
	
	if CLIENT and self.Owner==LocalPlayer() then
		if not self.BarrelAngle then self.BarrelAngle = 0 end
		
		if not self.SpinSpeed then self.SpinSpeed = 0 end
		
		self.BarrelAngle = self.BarrelAngle + self.SpinSpeed
		while self.BarrelAngle>360 do
			self.BarrelAngle = self.BarrelAngle - 360
		end
		
		local Spinning = self:GetNetworkedBool("Spinning")
		
		if Spinning and self.SpinSpeed<self.MinigunMaxSpinSpeed then
			self.SpinSpeed = self.SpinSpeed + self.MinigunSpinAcceleration
		elseif not Spinning and self.SpinSpeed>0 then
			self.SpinSpeed = self.SpinSpeed - self.MinigunSpinAcceleration
			if self.SpinSpeed<0 then self.SpinSpeed = 0 end
		end
		
		--[[self.BarrelAngle = self.BarrelAngle + 1
		while self.BarrelAngle>360 do
			self.BarrelAngle = self.BarrelAngle - 360
		end]]
	end
	
	if not self.IsDeployed and self.NextDeployed and CurTime()>=self.NextDeployed then
		self.IsDeployed = true
	end
	
	if SERVER then
		if self.Spinning then
			if self.Owner:GetInfoNum("tf_giant_robot",0) != 1 then
			self.Owner:SetClassSpeed(3 * 37 * (self.DeployMoveSpeedMultiplier or 1))
			self.Owner:SetCrouchedWalkSpeed(0)
			end
		else
			if self.Owner:GetInfoNum("tf_giant_robot",0) != 1 then
			self.Owner:ResetClassSpeed()
			end
		end
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
		self.Owner:SetNWBool("MinigunReady", true)
		----self.Owner:DoAnimationEvent(ACT_MP_DEPLOYED, true)
		self.NextEndSpinUp = nil
	end
	
	if self.NextEndSpinDown and CurTime()>=self.NextEndSpinDown then
		self.SpinDownSound:Stop()
		self.NextEndSpinDown = nil
	end
	
	if self.Firing and not self.Owner:KeyDown(IN_ATTACK) and (self.AltFireMode ~= 1 or not self.Owner:KeyDown(IN_ATTACK2)) then
		self:StopFiring()
		self:SendWeaponAnim(self.VM_SECONDARYATTACK)
	end
	
	if self.Spinning and not self.NextEndSpinDown and not self.Owner:KeyDown(IN_ATTACK) and not self.Owner:KeyDown(IN_ATTACK2) then
		if not self.NextEndSpinUp or CurTime() > self.NextEndSpinUp then
			self:SpinDown()
		end
	end
end

function SWEP:Holster()
	if IsValid(self.Owner) and self:GetNetworkedBool("Spinning") then
		self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_POSTFIRE, true)
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
	
	if SERVER and IsValid(self.Owner) then
		self.Owner:SetNWBool("MinigunReady", false)
		--self.Owner:DoAnimationEvent(ACT_MP_STAND_PRIMARY, true)
		self.Owner:ResetClassSpeed()
	end
	
	if CLIENT then
		if self.Owner==LocalPlayer() then
			self.ViewmodelInitialized = false
			self:MinigunViewmodelReset()
		end
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
