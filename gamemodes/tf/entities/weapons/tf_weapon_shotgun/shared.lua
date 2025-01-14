if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Slot				= 1
SWEP.PrintName			= "Shotgun"

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_engineer_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_shotgun/c_shotgun.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"
 
SWEP.MuzzleEffect = "muzzle_shotgun"
SWEP.MuzzleOffset = Vector(20, 4, -3)

SWEP.ShootSound = Sound("Weapon_Shotgun.TF_Single")
SWEP.ShootCritSound = Sound("Weapon_Shotgun.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_Shotgun.WorldReload")

SWEP.TracerEffect = "bullet_shotgun_tracer01"
PrecacheParticleSystem("bullet_shotgun_tracer01_red")
PrecacheParticleSystem("bullet_shotgun_tracer01_red_crit")
PrecacheParticleSystem("bullet_shotgun_tracer01_blue")
PrecacheParticleSystem("bullet_shotgun_tracer01_blue_crit")
PrecacheParticleSystem("muzzle_shotgun")

SWEP.BaseDamage = 6
SWEP.DamageRandomize = 4
SWEP.MaxDamageRampUp = 0.5
SWEP.MaxDamageFalloff = 0.5


SWEP.HoldType = "PRIMARY"

SWEP.HoldTypeHL2 = "shotgun"
SWEP.BulletsPerShot = 10
SWEP.BulletSpread = 0.0675
SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 0.625
SWEP.ReloadTime = 0.5

SWEP.PunchView = Angle( -2, 0, 0 )

SWEP.ReloadSingle = true

function SWEP:InspectAnimCheck()
	if (IsValid(self.Owner)) then
		if (self.Owner:GetPlayerClass() == "heavyshotgun") then
			self.Primary.Delay          = 0.6 * 2.5
			self.ReloadTime = 0.5 * 0.1
			self.BulletsPerShot = 10 + 3
			self.HoldType = "SECONDARY"
			self.Primary.Ammo			= TF_SECONDARY
			self:SetHoldType("SECONDARY")
		end
		if (self.Owner:GetPlayerClass() == "soldier"
		|| self.Owner:GetPlayerClass() == "heavy"
		|| self.Owner:GetPlayerClass() == "heavyshotgun"
		|| self.Owner:GetPlayerClass() == "giantheavyshotgun"
		|| self.Owner:GetPlayerClass() == "pyro") then
			self.item_slot = "SECONDARY"
			self.VM_DRAW = ACT_SECONDARY_VM_DRAW	
			self.VM_IDLE = ACT_SECONDARY_VM_IDLE
			self.VM_PRIMARYATTACK = ACT_SECONDARY_VM_PRIMARYATTACK
			self.VM_RELOAD_START = ACT_SECONDARY_RELOAD_START
			self.VM_RELOAD = ACT_SECONDARY_VM_RELOAD
			self.VM_RELOAD_FINISH = ACT_SECONDARY_RELOAD_FINISH
			self.Slot				= 1
			self.HoldType = "SECONDARY"
			self.Primary.Ammo			= TF_SECONDARY
			self:SetHoldType("SECONDARY")
		elseif (self.Owner:GetPlayerClass() == "scout"
		|| self.Owner:GetPlayerClass() == "engineer") then
			self.VM_DRAW = ACT_PRIMARY_VM_DRAW	
			self.VM_IDLE = ACT_PRIMARY_VM_IDLE
			self.VM_PRIMARYATTACK = ACT_PRIMARY_VM_PRIMARYATTACK
			self.VM_RELOAD_START = ACT_PRIMARY_RELOAD_START
			self.VM_RELOAD = ACT_PRIMARY_VM_RELOAD
			self.VM_RELOAD_FINISH = ACT_PRIMARY_RELOAD_FINISH
			self.Slot				= 0
			self.Primary.Ammo			= TF_PRIMARY
			self.HoldType = "PRIMARY"
			self:SetHoldType("PRIMARY")
		else
			self.VM_DRAW = ACT_SECONDARY_VM_DRAW	
			self.VM_IDLE = ACT_SECONDARY_VM_IDLE
			self.VM_PRIMARYATTACK = ACT_SECONDARY_VM_PRIMARYATTACK
			self.VM_RELOAD_START = ACT_SECONDARY_RELOAD_START
			self.VM_RELOAD = ACT_SECONDARY_VM_RELOAD
			self.VM_RELOAD_FINISH = ACT_SECONDARY_RELOAD_FINISH
			self.Slot				= 1
			self.Primary.Ammo			= TF_SECONDARY
			self.HoldType = "PRIMARY"
			self:SetHoldType("PRIMARY")
		end
	end
	return self.BaseClass.InspectAnimCheck(self)
end