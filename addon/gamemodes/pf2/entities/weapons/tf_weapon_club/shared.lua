if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Slot				= 2
if CLIENT then
	SWEP.PrintName			= "Kukri"
end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/v_models/v_club.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_club.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.Swing = Sound("Weapon_Club.Miss")
SWEP.SwingCrit = Sound("Weapon_Club.MissCrit")
SWEP.HitFlesh = Sound("Weapon_Club.HitFlesh")
SWEP.HitWorld = Sound("Weapon_Club.HitWorld")

SWEP.BaseDamage = 65
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8

-- fixes having to wait for a long time before being able to swing it
SWEP.m_WeaponDeploySpeed = 2

SWEP.HoldType = "MELEE"
SWEP.HoldTypeHL2 = "melee2"

SWEP.VM_DRAW = ACT_MELEE_VM_DRAW
SWEP.VM_IDLE = ACT_MELEE_VM_IDLE
SWEP.VM_HITCENTER = ACT_MELEE_VM_HITCENTER
SWEP.VM_SWINGHARD = ACT_MELEE_VM_SWINGHARD
SWEP.VM_RELOAD = ACT_PRIMARY_VM_RELOAD
SWEP.VM_RELOAD_START = ACT_PRIMARY_RELOAD_START
SWEP.VM_RELOAD_FINISH = ACT_PRIMARY_RELOAD_FINISH