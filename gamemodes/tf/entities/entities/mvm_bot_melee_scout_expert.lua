if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "melee_scout_expert"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.Difficulty = 3
ENT.PrintName		= "Melee Scout (Expert)"
ENT.Category		= "TFBots: MVM"
ENT.PreferredName = "Scout"
ENT.PreferredIcon = "hud/leaderboard_class_scout"


list.Set( "NPC", "mvm_bot_melee_scout_expert", {
	Name = ENT.PrintName,
	Class = "mvm_bot_melee_scout_expert",
	Category = ENT.Category,
	AdminOnly = true
} )