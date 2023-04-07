if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Karate"
SWEP.Slot				= 2
end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/v_models/v_karatae_sniper.mdl"
--SWEP.WorldModel			= "models/weapons/w_models/w_null.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Swing = Sound("Weapon_Fist.Miss")
SWEP.SwingCrit = Sound("Weapon_Fist.MissCrit")
SWEP.HitFlesh = Sound("Weapon_Fist.HitFlesh")
SWEP.HitWorld = Sound("Weapon_Fist.HitWorld")

SWEP.BaseDamage = 65
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay          = 0.3

-- fixes having to wait for a long time before being able to swing it
SWEP.m_WeaponDeploySpeed = 2

SWEP.HoldType = "MELEE"
SWEP.HoldTypeHL2 = "fist"
