if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Slot				= 2
if CLIENT then
	SWEP.PrintName			= "Bat"
end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/v_models/v_bat_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_bat.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.Swing = Sound("Weapon_Bat.Miss")
SWEP.SwingCrit = Sound("Weapon_Bat.MissCrit")
SWEP.HitFlesh = Sound("Weapon_Bat.HitFlesh")
SWEP.HitWorld = Sound("Weapon_Bat.HitWorld")

SWEP.BaseDamage = 35
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay          = 0.5

SWEP.HoldType = "MELEE"
SWEP.HoldTypeHL2 = "melee2"

function SWEP:Deploy()
	if self:GetItemData().model_player == "models/workshop/weapons/c_models/c_invasion_bat/c_invasion_bat.mdl" then
		if SERVER then
			self:EmitSound("Weapon_BatSaber.Draw")
		end
		
		self.Swing = Sound("Weapon_BatSaber.Swing")
		self.SwingCrit = Sound("Weapon_BatSaber.SwingCrit")
	end
	return self.BaseClass.Deploy(self)
end
