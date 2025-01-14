if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantburstfiresoldier"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true 
ENT.Difficulty = 3
ENT.PrintName		= "Giant Burst Fire Soldier"
ENT.Category		= "TFBots - MVM"
ENT.PreferredIcon = "hud/leaderboard_class_soldier_burstfire"

list.Set( "NPC", "mvm_bot_giantburstfiresoldier", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantburstfiresoldier",
	Category = ENT.Category,
	AdminOnly = true
} )