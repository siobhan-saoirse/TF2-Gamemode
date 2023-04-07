if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Bonesaw"
end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.Slot				= 2
SWEP.ViewModel			= "models/weapons/c_models/c_medic_arms_empty.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_bonesaw.mdl"
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

SWEP.HoldType = "MELEE"
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
	if self:GetItemData().model_player == "models/weapons/c_models/c_ubersaw/c_ubersaw.mdl" and tr.Entity:IsTFPlayer() and not tr.Entity:IsBuilding() then
		self:EmitSound(self.CustomSound1)
	elseif self:GetItemData().model_player == "models/weapons/c_models/c_uberneedle/c_uberneedle.mdl" and tr.Entity:IsTFPlayer() and not tr.Entity:IsBuilding() then
		self:EmitSound(self.CustomSound1)
	else
		self:BaseCall(tr)
	end
end