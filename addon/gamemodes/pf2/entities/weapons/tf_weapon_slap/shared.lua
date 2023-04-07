if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Hot Hand"
SWEP.Slot				= 2
end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/v_models/v_bat_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_bat.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Swing = Sound("weapons/slap_swing.wav") -- Sound("Weapon_Slap.Swing")
SWEP.SwingCrit = Sound("weapons/slap_swing_crit.wav") -- Sound("Weapon_Slap.Swing")
SWEP.HitFlesh = Sound("weapons/slap_hit1.wav") -- Sound("Weapon_Slap.Swing")
SWEP.HitWorld = Sound("weapons/slap_hit_world1.wav") -- Sound("Weapon_Slap.Swing")

SWEP.BaseDamage = 35
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay          = 0.5

SWEP.HoldType = "ITEM3"

SWEP.Special_HumiliationCount = "#Humiliation_Count"
SWEP.Special_HumiliationKill = "#Humiliation_Kill"

function SWEP:InspectAnimCheck()
self:CallBaseFunction("InspectAnimCheck")
self.VM_DRAW = ACT_ITEM3_VM_DRAW
self.VM_IDLE = ACT_ITEM3_VM_IDLE
self.VM_HITCENTER = ACT_ITEM3_VM_PRIMARYATTACK
self.VM_SWINGHARD = ACT_ITEM3_VM_PRIMARYATTACK
self.VM_INSPECT_START = ACT_ITEM3_VM_INSPECT_START
self.VM_INSPECT_IDLE = ACT_ITEM3_VM_INSPECT_IDLE
self.VM_INSPECT_END = ACT_ITEM3_VM_INSPECT_END
end

function SWEP:OnMeleeHit(tr)
	if CLIENT then return end
	
	local ent = tr.Entity
	if not (ent:IsTFPlayer() and self.Owner:CanDamage(ent) and not ent:IsBuilding()) then return end
	
	local InflictorClass = gamemode.Call("GetInflictorClass", ent, self.Owner, self)
	
	umsg.Start("Notice_EntityHumiliationCounter")
		umsg.String(GAMEMODE:EntityName(ent))
		umsg.Short(GAMEMODE:EntityTeam(ent))
		umsg.Short(GAMEMODE:EntityID(ent))
		
		umsg.String(InflictorClass)
		
		umsg.String(GAMEMODE:EntityName(self.Owner))
		umsg.Short(GAMEMODE:EntityTeam(self.Owner))
		umsg.Short(GAMEMODE:EntityID(self.Owner))
		
		--[[
		umsg.String(GAMEMODE:EntityName(cooperator))
		umsg.Short(GAMEMODE:EntityTeam(cooperator))
		umsg.Short(GAMEMODE:EntityID(cooperator))]]
		
		umsg.Bool(self.CurrentShotIsCrit)
	umsg.End()
end
