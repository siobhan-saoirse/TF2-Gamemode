if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "bowman"
ENT.Spawnable = false
ENT.AdminOnly = true		
ENT.IsBoss = false
ENT.PrintName		= "Bowman"
ENT.Category		= "TFBots: MVM"

list.Set( "NPC", "mvm_bot_bowman", {
	Name = ENT.PrintName,
	Class = "mvm_bot_bowman",
	Category = ENT.Category,
	AdminOnly = true
} )