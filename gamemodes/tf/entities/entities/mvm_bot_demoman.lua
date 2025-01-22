if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "demoman"
ENT.Spawnable = false
ENT.AdminOnly = true		
ENT.IsBoss = false
ENT.PrintName		= "Demoman"
ENT.Category		= "TFBots: MVM"

list.Set( "NPC", "mvm_bot_demoman", {
	Name = ENT.PrintName,
	Class = "mvm_bot_demoman",
	Category = ENT.Category,
	AdminOnly = true
} )