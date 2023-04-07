if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "medic"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.PrintName		= "Medic"
ENT.Category		= "TF2: MVM Bots"

list.Set( "NPC", "mvm_bot_medic", {
	Name = ENT.PrintName,
	Class = "mvm_bot_medic",
	Category = ENT.Category
} )