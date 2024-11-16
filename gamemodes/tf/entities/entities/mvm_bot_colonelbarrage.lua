if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "colonelbarrage"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true 
ENT.Difficulty = 3
ENT.PrintName		= "Colonel Barrage"
ENT.Category		= "TFBots - MVM"
ENT.PreferredIcon = "hud/leaderboard_class_soldier_barrage"

list.Set( "NPC", "mvm_bot_colonelbarrage", {
	Name = ENT.PrintName,
	Class = "mvm_bot_colonelbarrage",
	Category = ENT.Category,
	AdminOnly = true,
	--AdminOnly = true
	AdminOnly = false
} )