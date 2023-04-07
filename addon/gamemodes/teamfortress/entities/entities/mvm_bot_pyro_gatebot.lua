if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "pyro"
ENT.Spawnable = false
ENT.AdminOnly = false		
ENT.IsBoss = false
ENT.PrintName		= "Pyro"
ENT.Items = {"MvM GateBot Light Pyro","Flame Thrower","Fire Axe"}
ENT.Category		= "TF2: MVM GateBots"

list.Set( "NPC", "mvm_bot_pyro_gatebot", {
	Name = ENT.PrintName,
	Class = "mvm_bot_pyro_gatebot",
	Category = ENT.Category
} )