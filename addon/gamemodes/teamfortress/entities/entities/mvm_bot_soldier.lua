if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "soldier"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.PrintName		= "Soldier"
ENT.Category		= "TF2: MVM Bots"

list.Set( "NPC", "mvm_bot_soldier", {
	Name = ENT.PrintName,
	Class = "mvm_bot_soldier",
	Category = ENT.Category
} )