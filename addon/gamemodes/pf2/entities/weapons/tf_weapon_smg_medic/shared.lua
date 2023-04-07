if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Slot				= 0
if CLIENT then
	SWEP.PrintName			= "Super SMG"
end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/v_models/v_smg_medic.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_smg_medic.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.MuzzleEffect = "muzzle_smg"
SWEP.MuzzleOffset = Vector(20, 4, -2)

SWEP.ShootSound = Sound("Weapon_SMG_Medic.Single")
SWEP.ShootCritSound = Sound("Weapon_SMG_Medic.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_SMG.WorldReload")

SWEP.TracerEffect = "bullet_pistol_tracer01"
PrecacheParticleSystem("muzzle_smg")
PrecacheParticleSystem("bullet_pistol_tracer01_red")
PrecacheParticleSystem("bullet_pistol_tracer01_red_crit")
PrecacheParticleSystem("bullet_pistol_tracer01_blue")
PrecacheParticleSystem("bullet_pistol_tracer01_blue_crit")

SWEP.BaseDamage = 7
SWEP.DamageRandomize = 1
SWEP.MaxDamageRampUp = 0.5
SWEP.MaxDamageFalloff = 0.5

SWEP.BulletsPerShot = 1
SWEP.BulletSpread = 0.025

SWEP.Primary.ClipSize		= 25
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_SECONDARY
SWEP.Primary.Delay          = 0.1
SWEP.ReloadTime = 1.4

SWEP.HoldType = "ITEM2"

SWEP.HoldTypeHL2 = "smg"

SWEP.AutoReloadTime = 0.10

SWEP.IsRapidFire = true