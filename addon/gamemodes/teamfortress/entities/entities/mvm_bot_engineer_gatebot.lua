if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "engineer"
ENT.Spawnable = false
ENT.AdminOnly = false		
ENT.IsBoss = false
ENT.PrintName		= "Engineer"
ENT.Items = {"MvM GateBot Light Engineer","Shotgun","Pistol","Wrench","Construction PDA","Destruction PDA"}
ENT.Category		= "TF2: MVM GateBots"

list.Set( "NPC", "mvm_bot_engineer_gatebot", {
	Name = ENT.PrintName,
	Class = "mvm_bot_engineer_gatebot",
	Category = ENT.Category
} )