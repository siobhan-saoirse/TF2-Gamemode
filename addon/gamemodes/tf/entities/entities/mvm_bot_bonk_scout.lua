if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "bonk_scout"
ENT.Spawnable = false
ENT.AdminOnly = false 
ENT.Difficulty = 3
ENT.PrintName		= "Bonk Scout"
ENT.Category		= "TFBots - MVM"
ENT.PreferredIcon = "hud/leaderboard_class_scout_bonk"

list.Set( "NPC", "mvm_bot_bonk_scout", {
	Name = ENT.PrintName,
	Class = "mvm_bot_bonk_scout",
	Category = ENT.Category
} )