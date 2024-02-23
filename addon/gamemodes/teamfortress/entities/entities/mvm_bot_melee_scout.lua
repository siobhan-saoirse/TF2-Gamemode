if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "melee_scout"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.PrintName		= "Scout (Melee)"
ENT.Category		= "TFBots"
ENT.PreferredName = "Scout"
ENT.PreferredIcon = "hud/leaderboard_class_scout"

list.Set( "NPC", "mvm_bot_melee_scout", {
	Name = ENT.PrintName,
	Class = "mvm_bot_melee_scout",
	Category = ENT.Category
} )