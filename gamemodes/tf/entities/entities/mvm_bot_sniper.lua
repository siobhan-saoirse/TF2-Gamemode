if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "sniper"
ENT.Spawnable = false
ENT.AdminOnly = true		
ENT.IsBoss = false
ENT.PrintName		= "Sniper"
ENT.Category		= "TFBots: MVM"

list.Set( "NPC", "mvm_bot_sniper", {
	Name = ENT.PrintName,
	Class = "mvm_bot_sniper",
	Category = ENT.Category,
	AdminOnly = true
} )