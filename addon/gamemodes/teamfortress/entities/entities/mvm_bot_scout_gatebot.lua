if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "scout"
ENT.Spawnable = false
ENT.AdminOnly = false		
ENT.IsBoss = false
ENT.PrintName		= "Scout"
ENT.Items = {"MvM GateBot Light Scout","Scattergun","Pistol","Bat"}
ENT.Category		= "TF2: MVM GateBots"

list.Set( "NPC", "mvm_bot_scout_gatebot", {
	Name = ENT.PrintName,
	Class = "mvm_bot_scout_gatebot",
	Category = ENT.Category
} )