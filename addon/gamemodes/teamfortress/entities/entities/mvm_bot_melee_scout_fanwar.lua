if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "melee_scout"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.PrintName		= "Fan O' War Scout"
ENT.Category		= "TF2: MVM Bots"
ENT.PreferredName = "Scout"
ENT.PreferredIcon = "hud/leaderboard_class_scout"
ENT.Items = {"Fan O'War"}

list.Set( "NPC", "mvm_bot_melee_scout_fanwar", {
	Name = ENT.PrintName,
	Class = "mvm_bot_melee_scout_fanwar",
	Category = ENT.Category
} )