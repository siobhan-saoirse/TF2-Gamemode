if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "soldier"
ENT.Spawnable = false
ENT.AdminOnly = false		
ENT.IsBoss = false
ENT.PrintName		= "Soldier"
ENT.Items = {"MvM GateBot Light Soldier","Rocket Launcher","Shovel"}
ENT.Category		= "TF2: MVM GateBots"

list.Set( "NPC", "mvm_bot_soldier_gatebot", {
	Name = ENT.PrintName,
	Class = "mvm_bot_soldier_gatebot",
	Category = ENT.Category
} )