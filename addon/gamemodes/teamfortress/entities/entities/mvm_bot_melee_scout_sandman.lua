if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "melee_scout_sandman"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.PrintName		= "Sandman Scout"
ENT.Category		= "TFBots"
ENT.PreferredName = "Scout"
ENT.PreferredIcon = "hud/leaderboard_class_scout_stun"

list.Set( "NPC", "mvm_bot_melee_scout_sandman", {
	Name = ENT.PrintName,
	Class = "mvm_bot_melee_scout_sandman",
	Category = ENT.Category
} )