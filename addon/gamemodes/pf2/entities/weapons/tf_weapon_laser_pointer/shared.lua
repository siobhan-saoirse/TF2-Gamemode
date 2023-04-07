if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Pistol"
SWEP.Slot				= 1
end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/v_models/v_pistol_engineer.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_pistol.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.MuzzleEffect = "muzzle_pistol"
SWEP.MuzzleOffset = Vector(20, 4, -2)

SWEP.ShootSound = Sound("weapons/pistol_shoot.wav")
SWEP.ShootCritSound = Sound("Weapon_Pistol.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_Pistol.WorldReloadEngineer")

SWEP.TracerEffect = "bullet_pistol_tracer01"
PrecacheParticleSystem("bullet_pistol_tracer01_red")
PrecacheParticleSystem("bullet_pistol_tracer01_red_crit")
PrecacheParticleSystem("bullet_pistol_tracer01_blue")
PrecacheParticleSystem("bullet_pistol_tracer01_blue_crit")
PrecacheParticleSystem("muzzle_pistol")

SWEP.BaseDamage = 0
SWEP.DamageRandomize = 0
SWEP.MaxDamageRampUp = 0.5
SWEP.MaxDamageFalloff = 0.5

SWEP.BulletsPerShot = 1
SWEP.BulletSpread = 0.04

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			= TF_METAL
SWEP.Primary.Delay          = 0.225

SWEP.HoldType = "ITEM1"

SWEP.IsRapidFire = true

function SWEP:InspectAnimCheck()
self:CallBaseFunction("InspectAnimCheck")
self.VM_DRAW = ACT_ITEM1_VM_DRAW
self.VM_IDLE = ACT_ITEM1_VM_IDLE

self.VM_INSPECT_START = ACT_ITEM1_VM_INSPECT_START
self.VM_INSPECT_IDLE = ACT_ITEM1_VM_INSPECT_IDLE
self.VM_INSPECT_END = ACT_ITEM1_VM_INSPECT_END
end

function SWEP:CanPrimaryAttack()
	return false
end

function SWEP:PrimaryAttack()
	self:StopTimers()

	if not self:CallBaseFunction("PrimaryAttack") then return false end

	return true
end

function SWEP:Think()
	self.BaseClass.Think(self)

	if self.Owner:KeyDown(IN_ATTACK) then
		print("Fire!")
	end
end