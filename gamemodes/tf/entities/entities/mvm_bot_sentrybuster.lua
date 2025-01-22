if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "sentrybuster"
ENT.Spawnable = false
ENT.AdminOnly = true		
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Sentry Buster"
ENT.Category		= "TFBots: MVM"
ENT.PreferredIcon = "hud/leaderboard_class_sentry_buster"

list.Set( "NPC", "mvm_bot_sentrybuster", {
	Name = ENT.PrintName,
	Class = "mvm_bot_sentrybuster",
	Category = ENT.Category,
	AdminOnly = true
} )