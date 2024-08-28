if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Neon Sign"
SWEP.Slot				= 2
end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/v_models/v_fireaxe_pyro.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_fireaxe.mdl"
SWEP.Crosshair = "tf_crosshair2"

SWEP.Swing = Sound("Weapon_FireAxe.Miss")
SWEP.SwingCrit = Sound("Weapon_FireAxe.MissCrit")
SWEP.HitFlesh = Sound("Neon_Sign.ImpactFlesh")
SWEP.HitWorld = Sound("Neon_Sign.ImpactWorld")

SWEP.BaseDamage = 95
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8

SWEP.HoldType = "MELEE"
SWEP.HoldTypeHL2 = "MELEE2"

SWEP.DamageType = DMG_DISSOLVE
SWEP.CritDamageType = DMG_DISSOLVE

function SWEP:Critical(ent,dmginfo)
	if self.Owner:WaterLevel() >= 2 then
		return true
	end
	
	return self:CallBaseFunction("Critical", ent, dmginfo)
end