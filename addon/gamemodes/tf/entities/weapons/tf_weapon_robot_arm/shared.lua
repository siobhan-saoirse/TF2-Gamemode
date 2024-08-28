if SERVER then
	AddCSLuaFile( "shared.lua" )
end

	SWEP.Slot				= 2
if CLIENT then
	SWEP.PrintName			= "The Gunslinger"
	SWEP.GlobalCustomHUD = {HudAccountPanel = true}
end

SWEP.Base				= "tf_weapon_wrench"

SWEP.ViewModel			= "models/weapons/c_models/c_engineer_gunslinger.mdl"
SWEP.WorldModel			= "models/empty.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.DropPrimaryWeaponInstead = true

SWEP.Swing = Sound("Weapon_Wrench.Miss")
SWEP.SwingCrit = Sound("Weapon_Wrench.MissCrit")
SWEP.HitFlesh = Sound("Weapon_Wrench.HitFlesh")
SWEP.HitWorld = Sound("Weapon_Wrench.HitWorld")
SWEP.HitBuildingSuccess = Sound("Weapon_Wrench.HitBuilding_Success")
SWEP.HitBuildingFailure = Sound("Weapon_Wrench.HitBuilding_Failure")

SWEP.BaseDamage = 65
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0
SWEP.IsRoboArm = true

SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8

SWEP.HoldType = "ITEM2"

SWEP.NoHitSound = true
SWEP.UpgradeSpeed = 25

SWEP.AltIdleAnimationProbability = 0.1

function SWEP:Initialize()
	timer.Simple(0.1, function()
		if (IsValid(self.Owner)) then

			self.Owner:GetHands():SetModel("models/weapons/c_models/c_engineer_gunslinger.mdl")
			
		end
	end)
end