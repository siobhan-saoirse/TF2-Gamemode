if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "sniper"
ENT.Spawnable = false
ENT.AdminOnly = false		
ENT.IsBoss = false
ENT.PrintName		= "Sniper"
ENT.Items = {"MvM GateBot Light Sniper","Sniper Rifle","SMG","Kukri"}
ENT.Category		= "TF2: MVM GateBots"

list.Set( "NPC", "mvm_bot_sniper_gatebot", {
	Name = ENT.PrintName,
	Class = "mvm_bot_sniper_gatebot",
	Category = ENT.Category
} )