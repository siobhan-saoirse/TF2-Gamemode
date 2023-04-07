if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "heavy"
ENT.Spawnable = false
ENT.AdminOnly = false		
ENT.IsBoss = false
ENT.PrintName		= "Heavyweapons"
ENT.Items = {"MvM GateBot Light Heavy","Minigun","Fists"}
ENT.Category		= "TF2: MVM GateBots"

list.Set( "NPC", "mvm_bot_heavy_gatebot", {
	Name = ENT.PrintName,
	Class = "mvm_bot_heavy_gatebot",
	Category = ENT.Category
} )