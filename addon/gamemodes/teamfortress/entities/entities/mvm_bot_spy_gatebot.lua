if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "spy"
ENT.Spawnable = false
ENT.AdminOnly = false		
ENT.IsBoss = false
ENT.PrintName		= "Spy"
ENT.Items = {"MvM GateBot Light Spy","Revolver","Sapper","Knife","Disguise Kit"}
ENT.Category		= "TF2: MVM GateBots"

list.Set( "NPC", "mvm_bot_spy_gatebot", {
	Name = ENT.PrintName,
	Class = "mvm_bot_spy_gatebot",
	Category = ENT.Category
} )