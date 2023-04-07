if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "sniper"
ENT.Spawnable = false
ENT.AdminOnly = false		
ENT.IsBoss = false
ENT.PrintName		= "Sniper"
ENT.Category		= "TF2: MVM Bots"

list.Set( "NPC", "mvm_bot_sniper", {
	Name = ENT.PrintName,
	Class = "mvm_bot_sniper",
	Category = ENT.Category
} )