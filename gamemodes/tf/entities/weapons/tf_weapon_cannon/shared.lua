if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

SWEP.PrintName			= "Loose Cannon"
SWEP.Slot				= 0
SWEP.CustomHUD = {HudBowCharge = true}

function SWEP:ClientStartCharge()
	self.ClientCharging = true
	self.ClientChargeStart = CurTime()
end

function SWEP:ClientEndCharge()
	self.ClientCharging = false
end


function SWEP:InitializeCModel()
	self:CallBaseFunction("InitializeCModel")
	
	if IsValid(self.CModel) then
		self.CModel:SetBodygroup(1, 1)
	end
end

function SWEP:InitializeWModel2()
	self:CallBaseFunction("InitializeWModel2")
	
	--[[if IsValid(self.WModel2) then
		--self.WModel2:SetBodygroup(1, 1)
	end]]
end

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_demo_arms.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_grenadelauncher.mdl"
SWEP.Crosshair = "tf_crosshair3"

--[[ --Viewmodel Settings Override (left-over from testing; works well)
SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
]]

SWEP.MuzzleEffect = "muzzle_grenadelauncher"
PrecacheParticleSystem("muzzle_grenadelauncher")

SWEP.ChargeSound = Sound("weapons/loose_cannon_charge.wav")
SWEP.ShootSound = Sound("Weapon_LooseCannon.Shoot")
SWEP.ShootCritSound = Sound("Weapon_LooseCannon.ShootCrit")
SWEP.ReloadSound = Sound("Weapon_GrenadeLauncher.WorldReload")

SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 0.6
SWEP.ReloadTime = 0.7

SWEP.IsRapidFire = false
SWEP.ReloadSingle = true

SWEP.HoldType = "SECONDARY"

SWEP.ProjectileShootOffset = Vector(0, 7, -6)
SWEP.Force = 1100
SWEP.AddPitch = -4

SWEP.MinForce = 1.1
SWEP.MaxForce = 0.02

SWEP.PunchView = Angle( -2, 0, 0 )

SWEP.Properties = {}

SWEP.SpinSound = true

function SWEP:OnEquipAttribute(a, owner)
	if a.attribute_class == "mult_clipsize" then
		self.SpinSound = false
	end
end

function SWEP:InspectAnimCheck()
	self.VM_INSPECT_START = ACT_PRIMARY_VM_INSPECT_START
	self.VM_INSPECT_IDLE = ACT_PRIMARY_VM_INSPECT_IDLE
	self.VM_INSPECT_END = ACT_PRIMARY_VM_INSPECT_END
	if ( self:GetOwner():KeyPressed( IN_SPEED ) and inspecting == false and GetConVar("tf_caninspect"):GetBool() and self.Owner:GetInfoNum("tf_sprintinspect", 1) == 1 ) then
		timer.Create("StartInspection", self:SequenceDuration(), 1,function()
			if self:GetOwner():KeyDown( IN_SPEED ) then 
				inspecting_idle = true
			else
				if CLIENT then
					timer.Create("PlaySpin", 1.07, 1, function() surface.PlaySound( "player/taunt_clip_spin_long.wav" ) end)
				end
				inspecting_idle = false
			end
		end )
	end

	if ( self:GetOwner():KeyReleased( IN_SPEED ) and inspecting_idle == true and GetConVar("tf_caninspect"):GetBool() and self.Owner:GetInfoNum("tf_sprintinspect", 1) == 1 ) then
		if CLIENT then
			timer.Create("PlaySpin", 1.07, 1, function() surface.PlaySound( "player/taunt_clip_spin_long.wav" ) end)
		end
	end

	if ( self:GetOwner():KeyPressed( IN_RELOAD ) and self:Clip1() == self:GetMaxClip1() and inspecting == false and GetConVar("tf_caninspect"):GetBool() and self.Owner:GetInfoNum("tf_reloadinspect", 1) == 1 ) then
		timer.Create("StartInspection", self:SequenceDuration(), 1,function()
			if self:GetOwner():KeyDown( IN_RELOAD ) then 
				inspecting_idle = true
			else
				if CLIENT then
					timer.Create("PlaySpin", 1.07, 1, function() surface.PlaySound( "player/taunt_clip_spin_long.wav" ) end)
				end
				inspecting_idle = false
			end
		end )
	end

	if ( self:GetOwner():KeyReleased( IN_RELOAD ) and self:Clip1() == self:GetMaxClip1() and inspecting_idle == true and GetConVar("tf_caninspect"):GetBool() and self.Owner:GetInfoNum("tf_reloadinspect", 1) == 1 ) then
		if CLIENT then
			timer.Create("PlaySpin", 1.07, 1, function() surface.PlaySound( "player/taunt_clip_spin_long.wav" ) end)
		end
	end
	
	--[[	if ( self:GetOwner():GetNWString("inspect") == "inspecting_released" and inspecting_post == false and GetConVar("tf_caninspect"):GetBool() and self.SpinSound == true and !(self.Owner:GetMoveType()==MOVETYPE_NOCLIP) ) then
		if CLIENT then
			timer.Create("PlaySpin", 2.06, 1, function() surface.PlaySound( "player/taunt_clip_spin_long.wav" ) end)
		end
	end]]
end

function SWEP:StopTimers()
	self:CallBaseFunction("StopTimers")
	timer.Remove("PlaySpin")
end

function SWEP:CreateSounds()
	self.ChargeUpSound = CreateSound(self, self.ChargeSound)
	
	self.SoundsCreated = true
end

function SWEP:PrimaryAttack()
	if not self.IsDeployed then return false end
	if self.Reloading then return false end
	
	self.NextDeployed = nil
	
	-- Already charging
	if self.Charging then return end
	
	local Delay = self.Delay or -1
	local QuickDelay = self.QuickDelay or -1
	
	if (not(self.Primary.QuickDelay>=0 and self.Owner:KeyPressed(IN_ATTACK)) and Delay>=0 and CurTime()<Delay)
	or (self.Primary.QuickDelay>=0 and self.Owner:KeyPressed(IN_ATTACK) and QuickDelay>=0 and CurTime()<QuickDelay) then
		return
	end
	
	self.Delay =  CurTime() + self.Primary.Delay
	self.QuickDelay =  CurTime() + self.Primary.QuickDelay
	
	if not self:CanPrimaryAttack() then
		return
	end
	
	if self.NextReload or self.NextReloadStart then
		self.NextReload = nil
		self.NextReloadStart = nil
	end
	
	-- Start charging
	self.Charging = true
	self:SendWeaponAnim(self.VM_PULLBACK)
	
	if SERVER then
		self:CallOnClient("ClientStartCharge", "")
	end
	
	self.NextIdle2 = CurTime()+self:SequenceDuration()
	self.ChargeStartTime = CurTime()
end

function SWEP:Think()
	local BASESPEED = 3 --this is really bad if anyone has a better way of doing this please tell me
	local sp = 100
	
	
	if self.Charging then
		if (not self.Owner:KeyDown(IN_ATTACK) or CurTime() - self.ChargeStartTime > 0.9) then
			self.Charging = false
			
			self:SendWeaponAnim(self.VM_PRIMARYATTACK)
			self.Owner:DoAttackEvent()
			
			self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
			
			self:ShootProjectile()
			self:TakePrimaryAmmo(1)
			
			self.Delay =  CurTime() + self.Primary.Delay
			self.QuickDelay =  CurTime() + self.Primary.QuickDelay
			
			if SERVER then
				self:CallOnClient("ClientEndCharge", "")
			end
			
			if self:Clip1() <= 0 then
				self:Reload()
			end
			
			if SERVER and not self.Primary.NoFiringScene then
				self.Owner:Speak("TLK_FIREWEAPON")
			end
			
			self:RollCritical() -- Roll and check for criticals first
			
			if (game.SinglePlayer() or CLIENT) and self.ChargeUpSound then
				self.ChargeUpSound:Stop()
				self.ChargeUpSound = nil
			end
		else
			if (game.SinglePlayer() or CLIENT) and not self.ChargeUpSound then
				self.ChargeUpSound = CreateSound(self, self.ChargeSound)
				self.ChargeUpSound:Play()
			end
		end
	end
	self:CallBaseFunction("Think")
	self.Owner:SetWalkSpeed(BASESPEED * sp)
	
	if CLIENT then
		if self.ClientCharging and self.ClientChargeStart then
			HudBowCharge:SetProgress((CurTime()-self.ClientChargeStart) / 0.9)
		else
			HudBowCharge:SetProgress(0)
		end
	end
	
	
end

function SWEP:ShootProjectile()
	if SERVER then
		if auto_reload then
			timer.Create("AutoReload", (self:SequenceDuration() + self.AutoReloadTime), 1, function() self:Reload() end)
		end
		
		local grenade = ents.Create("tf_projectile_cannonball")
		grenade:SetPos(self:ProjectileShootPos())
		grenade:SetAngles(self.Owner:EyeAngles())
		
		if self:Critical() then
			grenade.critical = true
		end
		grenade:SetOwner(self.Owner)
		
		self:InitProjectileAttributes(grenade)
		
		grenade:Spawn()
		if self.Safe == true then
			grenade:SetModel("models/weapons/w_models/w_stickybomb2.mdl")
		end

		if self:GetItemData().model_player == "models/workshop/weapons/c_models/c_kingmaker_sticky/c_kingmaker_sticky.mdl" then
			grenade:SetModel("models/workshop/weapons/c_models/c_kingmaker_sticky/w_kingmaker_stickybomb.mdl")
			grenade.ExplosionSound = Sound("Weapon_TackyGrendadier.Explode")
		end
		local force = Lerp((CurTime() - self.ChargeStartTime) / 0.8, self.MinForce, self.MaxForce)
		
		local vel = self.Owner:GetAimVector():Angle()
		vel.p = vel.p + self.AddPitch
		vel = vel:Forward() * 1100 * (grenade.Mass or 10)
		
		grenade:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(-2000,2000)))
		grenade:GetPhysicsObject():ApplyForceCenter(vel)
		grenade.NextExplode = CurTime() + force
		if (force < 0.03) then
			timer.Simple(0.01, function()
			
				grenade:DoExplosion()
			
			end)
		end
	end
	self:ShootEffects()
	self.Owner:ViewPunch( self.PunchView )
end