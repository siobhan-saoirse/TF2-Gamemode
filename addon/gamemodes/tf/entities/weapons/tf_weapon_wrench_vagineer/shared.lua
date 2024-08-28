if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Wrench"
SWEP.Slot				= 0
SWEP.GlobalCustomHUD = {HudAccountPanel = true}
SWEP.RenderGroup 		= RENDERGROUP_BOTH
end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/v_stunbaton.mdl"
SWEP.WorldModel			= "models/weapons/w_stunbaton.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Swing = Sound("Weapon_StunStick.Melee_Miss")
SWEP.SwingCrit = Sound("Weapon_StunStick.Melee_Miss")
SWEP.HitFlesh = Sound("Weapon_StunStick.Melee_Hit")
SWEP.HitWorld = Sound("Weapon_StunStick.Melee_HitWorld")

SWEP.BaseDamage = 65
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Delay = 0.7
SWEP.ReloadTime = 0.7

SWEP.HoldType = "MELEE"
SWEP.HoldTypeHL2 = "melee"
SWEP.UseHands = true
function SWEP:OnMeleeAttack()
	self.Owner:DoAnimationEvent(ACT_MELEE_ATTACK_SWING_GESTURE)
end