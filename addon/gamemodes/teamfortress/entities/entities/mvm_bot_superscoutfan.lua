if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "superscoutfan"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Force-A-Nature Super Scout"
ENT.Category		= "TFBots"
ENT.PreferredIcon = "hud/leaderboard_class_scout_fan"

list.Set( "NPC", "mvm_bot_superscoutfan", {
	Name = ENT.PrintName,
	Class = "mvm_bot_superscoutfan",
	Category = ENT.Category,
	--AdminOnly = true
	AdminOnly = false
} )