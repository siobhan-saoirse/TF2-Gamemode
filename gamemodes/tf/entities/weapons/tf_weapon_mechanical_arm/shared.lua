if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Short Circuit"
SWEP.Slot				= 1
SWEP.RenderGroup		= RENDERGROUP_BOTH
end

SWEP.Base				= "tf_weapon_pistol"

SWEP.ViewModel			= "models/weapons/c_models/c_engineer_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_dex_arm/c_dex_arm.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.MuzzleEffect = "muzzle_pistol"
SWEP.MuzzleOffset = Vector(20, 4, -2)

SWEP.ShootSound = Sound("Weapon_BarretsArm.Zap")
SWEP.SecondaryShootSound = Sound("Weapon_BarretsArm.Shot")
SWEP.ShootCritSound = Sound("Weapon_BarretsArm.Zap")
SWEP.ReloadSound = Sound("Weapon_Pistol.WorldReloadEngineer")

SWEP.TracerEffect = "bullet_pistol_tracer01"
PrecacheParticleSystem("bullet_pistol_tracer01_red")
PrecacheParticleSystem("bullet_pistol_tracer01_red_crit")
PrecacheParticleSystem("bullet_pistol_tracer01_blue")
PrecacheParticleSystem("bullet_pistol_tracer01_blue_crit")
PrecacheParticleSystem("muzzle_pistol")

SWEP.BaseDamage = 65
SWEP.DamageRandomize = 1
SWEP.MaxDamageRampUp = 2
SWEP.MaxDamageFalloff = 0.5

SWEP.BulletsPerShot = 1
SWEP.BulletSpread = 0.04

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			= TF_METAL
SWEP.Primary.Delay          = 0.15
SWEP.Secondary.Delay          = 0.7
SWEP.ReloadTime = 1.2

SWEP.HoldType = "SECONDARY"

SWEP.HoldTypeHL2 = "pistol"

SWEP.IsRapidFire = true
SWEP.ProjectileShootOffset = Vector(0, 13, -12)

-- thanks lead

function SWEP:Think()
	self:CallBaseFunction("Think")
end

function SWEP:CanPrimaryAttack(ent)
	if self.Owner:KeyDown(IN_ATTACK2) then 
		return false
	end
	return self:Ammo1() > 0
end

function SWEP:PreDrawViewModel(vm, vpn, ply)
	self.Owner:GetHands():SetBodygroup(1, 1)
end

function SWEP:Deploy()
	self.BaseClass.Deploy(self)
	if IsValid(self.Owner) then
		self.Owner:SetBodygroup(2, 2)
	end
end

function SWEP:Holster()
	if IsValid(self.Owner) then
		self.Owner:SetBodygroup(2, 0)
		if self.Owner:HasWeapon("tf_weapon_robot_arm") then
			self.Owner:SetBodygroup(2, 1)
		end
	end
	
	self.Owner:GetHands():SetBodygroup(1, 0)
	return self.BaseClass.Holster(self)
end

function SWEP:OnRemove()
	self:Holster()
	
	return self.BaseClass.OnRemove(self)
end 

function SWEP:InspectAnimCheck()
	self.VM_INSPECT_START = ACT_SECONDARY_ALT2_VM_INSPECT_START
	self.VM_INSPECT_IDLE = ACT_SECONDARY_ALT2_VM_INSPECT_IDLE
	self.VM_INSPECT_END = ACT_SECONDARY_ALT2_VM_INSPECT_END
end

function SWEP:SecondaryShootEffects()

	if self.Owner:GetMaterial() == "models/shadertest/predator" then return end
	if self:GetVisuals() and self:GetVisuals()["sound_single_shot"] then
		self.ShootSound = self:GetVisuals()["sound_single_shot"]
		self.ShootCritSound = self:GetVisuals()["sound_burst"]
	end
	if self:Critical() then
		self:EmitSound(self.SecondaryShootSound)
	else
		self:EmitSound(self.SecondaryShootSound, self.ShootSoundLevel, self.ShootSoundPitch)
	end
	
	if SERVER then
		if self.MuzzleEffect and self.MuzzleEffect~="" then
			umsg.Start("DoMuzzleFlash")
				umsg.Entity(self)
			umsg.End()
		end
	end 
end

function SWEP:CanSecondaryAttack()
	if (self:Ammo2() > 0) then
		return true
	end
	
	return false
end
function SWEP:SecondaryAttack()
	self:StopTimers()
	if self:Ammo1() < 1 then if SERVER then self.Owner:EmitSoundEx("Weapon_BarretsArm.Fizzle") self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay) end return end 
	if self.Owner:GetMaterial() == "models/shadertest/predator" then return end
	
	auto_reload = self.Owner:GetInfoNum("tf_righthand", 1)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	self:SendWeaponAnim(self.VM_PRIMARYATTACK)
	self.Owner:DoAttackEvent()
	if SERVER then
	self.Owner:RemoveAmmo(65, self.Primary.Ammo, false)
	umsg.Start("PlayerMetalBonus", self.Owner)
		umsg.Short(-65) 
	umsg.End()
	end
	
	self.NextIdle = CurTime() + self:SequenceDuration() 
	if self then
		if self.Owner:GetInfoNum("tf_autoreload", 1) == 1 then
			if auto_reload then
				timer.Create("AutoReload", (self:SequenceDuration() + self.AutoReloadTime), 1, function() if IsValid(self) and IsValid(self.Owner) and isfunction(self:Reload()) then self:Reload() end end)
			end
		end
	end
	self:ShootProjectile2(self.BulletsPerShot, self.BulletSpread)
	
	if self:Clip1() <= 0 then
		self:Reload()
	end
	
	if self.Owner:GetPlayerClass() == "spy" then
		if self.Owner:GetModel() == "models/player/scout.mdl" or  self.Owner:GetModel() == "models/player/soldier.mdl" or  self.Owner:GetModel() == "models/player/pyro.mdl" or  self.Owner:GetModel() == "models/player/demo.mdl" or  self.Owner:GetModel() == "models/player/heavy.mdl" or  self.Owner:GetModel() == "models/player/engineer.mdl" or  self.Owner:GetModel() == "models/player/medic.mdl" or  self.Owner:GetModel() == "models/player/sniper.mdl" or  self.Owner:GetModel() == "models/player/hwm/spy.mdl"	 or self.Owner:GetModel() == "models/player/kleiner.mdl" then
			if self.Owner:KeyDown( IN_ATTACK ) then
				if self.Owner:GetInfoNum("tf_robot", 0) == 0 then
					self.Owner:SetModel("models/player/spy.mdl") 
				else
					self.Owner:SetModel("models/bots/spy/bot_spy.mdl")
				end
				if IsValid( button) then 
					button:Remove() 
				end
				for _,v in pairs(ents.GetAll()) do
					if v:IsNPC() and not v:IsFriendly(self.Owner) then
						v:AddEntityRelationship(self.Owner, D_HT, 99)
					end
				end
				if self.Owner:Team() == TEAM_BLU then 
					self.Owner:SetSkin(1) 
				elseif self.Owner:Team() == TF_TEAM_PVE_INVADERS then 
					self.Owner:SetSkin(1) 
				else 
					self.Owner:SetSkin(0) 
				end 
				self.Owner:EmitSoundEx("player/spy_disguise.wav", 65, 100) 
			end
		end
	end
	
	self:RollCritical() -- Roll and check for criticals first
	
	self.Owner:ViewPunch( self.PunchView )
	
	self.NextReloadStart = nil
	self.NextReload = nil
	self.Reloading = false
	
	return true
end

function SWEP:ShootProjectile2()
	if SERVER then
		local rocket = ents.Create("tf_projectile_shortcircuit")
		rocket:SetPos(self:ProjectileShootPos())
		local ang = self.Owner:EyeAngles()
		
		rocket:SetAngles(ang)
		
		if self:Critical() then
			rocket.critical = true
		end
		
		rocket:SetOwner(self.Owner)
		self:InitProjectileAttributes(rocket)
		
		rocket:Spawn()
		rocket:Activate()
	end
	
	self:SecondaryShootEffects()
end
