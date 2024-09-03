if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "bowman_rapid_fire"
ENT.Spawnable = false
ENT.AdminOnly = true		
ENT.IsBoss = false
ENT.Difficulty = 2
ENT.PrintName		= "Bowman Rapid Fire"
ENT.Category		= "TFBots - MVM"
list.Set( "NPC", "mvm_bot_bowman_rapid_fire", {
	Name = ENT.PrintName,
	Class = "mvm_bot_bowman_rapid_fire",
	Category = ENT.Category,
	AdminOnly = true
} )