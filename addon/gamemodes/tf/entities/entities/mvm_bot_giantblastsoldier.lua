if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantblastsoldier"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true 
ENT.Difficulty = 3
ENT.PrintName		= "Giant Blast Soldier"
ENT.Category		= "TFBots - MVM"
ENT.PreferredIcon = "hud/leaderboard_class_soldier_libertylauncher_giant"

list.Set( "NPC", "mvm_bot_giantblastsoldier", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantblastsoldier",
	Category = ENT.Category,
	AdminOnly = true,
	--AdminOnly = true
	AdminOnly = false
} )