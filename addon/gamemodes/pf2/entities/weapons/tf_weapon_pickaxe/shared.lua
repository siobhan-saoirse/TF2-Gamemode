if SERVER then

AddCSLuaFile("shared.lua")

end

if CLIENT then

SWEP.PrintName			= "Knife"

function SWEP:ResetBackstabState()
	self.NextBackstabIdle = nil
	self.BackstabState = false
	self.NextAllowBackstabAnim = CurTime() + 0.8
end

end

SWEP.Slot				= 2
SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/v_models/v_shovel_soldier.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_pickaxe/c_pickaxe.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Swing = Sound("Weapon_PickAxe.Swing")
SWEP.SwingCrit = Sound("Weapon_PickAxe.SwingCrit")
SWEP.HitFlesh = Sound("Weapon_PickAxe.HitFlesh")
SWEP.HitWorld = Sound("Weapon_Shovel.HitWorld")

SWEP.BaseDamage = 80
SWEP.DamageRandomize = 1.35
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.CriticalChance = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8

SWEP.HoldType = "MELEE"

function SWEP:Deploy()
	if SERVER then
		timer.Create("SetFasterSpeed2", 0.001, 0, function()
			if self.Owner:GetClassSpeed() == 110 then
				self.Owner:SetClassSpeed(3 * 32 * 5)
			else
				self.Owner:SetClassSpeed(3 * 32 * 3.8)
			end
		end)
	end
	
	if CLIENT then
		self.Owner:EmitSound("weapons/samurai/tf_marked_for_death_indicator.wav")
	elseif SERVER then
		self.Owner:EmitSound("weapons/samurai/tf_marked_for_death_impact_0"..math.random(1,3)..".wav")
	end

	return self:CallBaseFunction("Deploy")
end
function SWEP:Holster()
	if SERVER then
		timer.Stop("SetFasterSpeed2")
	end

	return self:CallBaseFunction("Holster")
end