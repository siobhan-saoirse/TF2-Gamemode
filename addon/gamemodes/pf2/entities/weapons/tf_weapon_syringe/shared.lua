if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Syringe"
end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.Slot				= 2
SWEP.ViewModel			= "models/weapons/v_models/v_syringe_medic.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_syringe.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.Swing = Sound("Weapon_Bonesaw.Miss")
SWEP.SwingCrit = Sound("Weapon_Bonesaw.MissCrit")
SWEP.HitFlesh = Sound("Weapon_Bonesaw.HitFlesh")
SWEP.HitWorld = Sound("Weapon_Bonesaw.HitWorld")
SWEP.CustomSound1 = Sound("Weapon_Ubersaw.HitFlesh")

SWEP.BaseDamage = 65
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8

SWEP.HoldType = "ITEM1"
SWEP.HoldTypeHL2 = "melee"

if CLIENT then

function SWEP:ViewModelDrawn()
	if IsValid(self.CModel) then
		self.CModel:SetPoseParameter("syringe_charge_level", self.Owner:GetNWInt("Ubercharge") * 0.01)
	end
	
	self:CallBaseFunction("ViewModelDrawn")
end

function SWEP:DrawWorldModel(from_postplayerdraw)
	if IsValid(self.WModel2) then
		--self.WModel2:SetPoseParameter("syringe_charge_level", self.Owner:GetNWInt("Ubercharge") * 0.01)
	end
	
	self:CallBaseFunction("DrawWorldModel", from_postplayerdraw)
end

end

function SWEP:MeleeHitSound(tr)
	if (tr.Entity:IsTFPlayer()) then
		if (tr.Entity:IsFriendly(self.Owner)) then
			if SERVER then
				GAMEMODE:HealPlayer(self.Owner, tr.Entity, tr.Entity:GetMaxHealth() * 0.4, true, false)
			end
		else
			if SERVER then
				GAMEMODE:EntityStartBleeding(tr.Entity, self, self.Owner, 600)
			end
		end
	end
	self:BaseCall(tr)
end