if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantpyro"
ENT.Spawnable = false
ENT.AdminOnly = true		
ENT.IsBoss = true
ENT.PrintName		= "Giant Pyro"
ENT.Items = {"MvM GateBot Light Pyro","Flame Thrower","Fire Axe"}
ENT.Category		= "TF2: MVM GateBots"

list.Set( "NPC", "mvm_bot_giantpyro_gatebot", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantpyro_gatebot",
	Category = ENT.Category,
	AdminOnly = true
} )