if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "superscoutfan"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Force-A-Nature Super Scout"
ENT.Items = {"MvM GateBot Light Scout","Force-A-Nature"}
ENT.Category		= "TF2: MVM GateBots"

list.Set( "NPC", "mvm_bot_superscoutfan_gatebot", {
	Name = ENT.PrintName,
	Class = "mvm_bot_superscoutfan_gatebot",
	Category = ENT.Category,
	AdminOnly = true
} )