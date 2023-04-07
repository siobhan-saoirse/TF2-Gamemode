if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Slot				= 1
if CLIENT then
	SWEP.PrintName			= "SMG"
end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_sniper_arms_empty.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_smg/c_smg.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.MuzzleEffect = "muzzle_smg"
SWEP.MuzzleOffset = Vector(20, 4, -2)

SWEP.ShootSound = Sound("Weapon_SMG.Single")
SWEP.ShootCritSound = Sound("Weapon_SMG.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_SMG.WorldReload")

SWEP.TracerEffect = "bullet_pistol_tracer01"
PrecacheParticleSystem("muzzle_smg")
PrecacheParticleSystem("bullet_pistol_tracer01_red")
PrecacheParticleSystem("bullet_pistol_tracer01_red_crit")
PrecacheParticleSystem("bullet_pistol_tracer01_blue")
PrecacheParticleSystem("bullet_pistol_tracer01_blue_crit")

SWEP.BaseDamage = 8
SWEP.DamageRandomize = 0
SWEP.MaxDamageRampUp = 0.5
SWEP.MaxDamageFalloff = 0.5

SWEP.BulletsPerShot = 1
SWEP.BulletSpread = 0.025

SWEP.Primary.ClipSize		= 25
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_SECONDARY
SWEP.Primary.Delay          = 0.1
SWEP.ReloadTime = 1.4

SWEP.HoldType = "SECONDARY"

SWEP.HoldTypeHL2 = "smg"

SWEP.AutoReloadTime = 0.10

SWEP.IsRapidFire = true