if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "medic"
ENT.Spawnable = false
ENT.AdminOnly = false		
ENT.IsBoss = false
ENT.PrintName		= "Medic"
ENT.Items = {"MvM GateBot Light Medic","Syringe Gun","Medi Gun","Bonesaw"}
ENT.Category		= "TF2: MVM GateBots"

list.Set( "NPC", "mvm_bot_medic_gatebot", {
	Name = ENT.PrintName,
	Class = "mvm_bot_medic_gatebot",
	Category = ENT.Category
} )