if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "demoman"
ENT.Spawnable = false
ENT.AdminOnly = false		
ENT.IsBoss = false
ENT.PrintName		= "Demoman"
ENT.Difficulty = 2
ENT.Items = {"MvM GateBot Light Demoman","Grenade Launcher","Stickybomb Launcher","Bottle"}
ENT.Category		= "TF2: MVM GateBots"


list.Set( "NPC", "mvm_bot_demo_gatebot", {
	Name = ENT.PrintName,
	Class = "mvm_bot_demo_gatebot",
	Category = ENT.Category
} )