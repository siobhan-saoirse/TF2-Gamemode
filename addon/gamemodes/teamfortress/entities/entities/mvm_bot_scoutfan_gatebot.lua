if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "scoutfan"
ENT.Spawnable = false
ENT.AdminOnly = false		
ENT.IsBoss = false
ENT.PrintName		= "Force-A-Nature Scout"
ENT.Items = {"MvM GateBot Light Scout","Force-A-Nature"}
ENT.Category		= "TF2: MVM GateBots"

list.Set( "NPC", "mvm_bot_scoutfan_gatebot", {
	Name = ENT.PrintName,
	Class = "mvm_bot_scoutfan_gatebot",
	Category = ENT.Category
} )