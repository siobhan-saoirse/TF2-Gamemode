if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantdemoknight"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.Items = {"Prince Tavish's Crown","Chargin' Targe","Eyelander","Ali Baba's Wee Booties"}	
ENT.PrintName		= "Giant Demoknight"
ENT.Category		= "TFBots: MVM"
ENT.PreferredIcon = "hud/leaderboard_class_demoknight_giant"

list.Set( "NPC", "mvm_bot_giantdemoknight", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantdemoknight",
	Category = ENT.Category,
	AdminOnly = true
} )