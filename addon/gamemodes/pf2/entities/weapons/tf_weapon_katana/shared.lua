if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then

SWEP.PrintName			= "The Katana"
SWEP.HasCModel = true

SWEP.RenderGroup 		= RENDERGROUP_BOTH

function SWEP:InitializeCModel()
	self:CallBaseFunction("InitializeCModel")
	
	for _,v in pairs(self.Owner:GetTFItems()) do
		if v:GetClass() == "tf_wearable_item_demoshield" then
			self.ShieldEntity = v
			v:InitializeCModel(self)
		end
	end
	for _,v in pairs(self.Owner:GetTFItems()) do
		if v:GetClass() == "tf_wearable_item_tideturnr" then
			self.ShieldEntity = v
			v:InitializeCModel(self)
		end
	end
end

function SWEP:ViewModelDrawn()
	self:CallBaseFunction("ViewModelDrawn")
	
	if IsValid(self.ShieldEntity) and IsValid(self.ShieldEntity.CModel) then
		self.ShieldEntity:StartVisualOverrides()
		self.ShieldEntity.CModel:DrawModel()
		self.ShieldEntity:EndVisualOverrides()
	end
end

end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.Slot				= 2
SWEP.ViewModel			= "models/weapons/c_models/c_demo_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_shogun_katana/c_shogun_katana.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Swing = Sound("Weapon_Katana.Miss")
SWEP.SwingCrit = Sound("Weapon_Katana.MissCrit")
SWEP.HitFlesh = Sound("Weapon_Katana.HitFlesh")
SWEP.HitRobot = Sound("MVM_Weapon_Sword.HitFlesh")
SWEP.HitWorld = Sound("Weapon_Katana.HitWorld")

SWEP.WhisperKillProbabilityPlayer = 0.5
SWEP.WhisperKillProbabilityNPC = 0.2

SWEP.WhisperIdleMinDelay = 10
SWEP.WhisperIdleMaxDelay = 60
SWEP.WhisperKillMinDelay = 2
SWEP.WhisperKillMaxDelay = 4

SWEP.MeleeRange = 100
SWEP.HealthBonus = 15

SWEP.BaseDamage = 65
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

--SWEP.CriticalChance = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8

SWEP.HoldType = "ITEM1"


--[[
SWEP.VM_DRAW = "cm_draw"
SWEP.VM_IDLE = "cm_idle"
SWEP.VM_HITCENTER = "cm_swing_a,cm_swing_b"
SWEP.VM_SWINGHARD = "cm_swing_c"]]


function SWEP:Think()
	self.Swing = Sound("Weapon_Katana.Miss")
	self.SwingCrit = Sound("Weapon_Katana.MissCrit")
	self.HitFlesh = Sound("Weapon_Katana.HitFlesh")
	self.HitRobot = Sound("MVM_Weapon_Sword.HitFlesh")
	self.HitWorld = Sound("Weapon_Katana.HitWorld") 
	if self.Owner:GetPlayerClass() == "demoman" or self.Owner:GetPlayerClass() == "demoknight" or self.Owner:GetPlayerClass() == "samuraidemo" or self.Owner:GetPlayerClass() == "giantdemoknight" then
	self.VM_DRAW = ACT_VM_DRAW_SPECIAL
	self.VM_IDLE = ACT_VM_IDLE_SPECIAL
	self.VM_HITCENTER = ACT_VM_HITCENTER_SPECIAL
	self.VM_SWINGHARD = ACT_VM_SWINGHARD_SPECIAL
	else
	self.VM_DRAW = ACT_VM_DRAW
	self.VM_IDLE = ACT_VM_IDLE
	self.VM_HITCENTER = ACT_VM_HITCENTER
	self.VM_SWINGHARD = ACT_VM_SWINGHARD
	self.HoldType = "MELEE"
	end
	if self.Owner:GetPlayerClass() == "demoman" then
		self:SetHoldType("ITEM1")
	else
		self:SetHoldType("MELEE")
	end
	return self.BaseClass.Think(self)
end

function SWEP:OnPlayerKilled(ent)
	--ent:SetNWBool("ShouldDropDecapitatedRagdoll", true)
	ent:AddDeathFlag(DF_DECAP)
end

function SWEP:Deploy()
	self:CallBaseFunction("Deploy")
	if self.Owner:GetPlayerClass() == "demoman" then
		self:SetHoldType("ITEM1")
	else
		self:SetHoldType("MELEE")
	end
end