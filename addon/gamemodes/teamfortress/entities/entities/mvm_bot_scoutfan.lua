if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "scoutfan"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.Difficulty = 3
ENT.PrintName		= "Force-A-Nature Scout"
ENT.Category		= "TF2: MVM Bots"

list.Set( "NPC", "mvm_bot_scoutfan", {
	Name = ENT.PrintName,
	Class = "mvm_bot_scoutfan",
	Category = ENT.Category
} )