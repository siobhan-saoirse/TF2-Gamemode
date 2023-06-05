if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "melee_scout"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.PrintName		= "Wrap Assassin"
ENT.Category		= "TF2: MVM Bots"
ENT.PreferredIcon = "hud/leaderboard_class_scout"
ENT.Items = {"Wrap Assassin"}

list.Set( "NPC", "mvm_bot_scout_wrap_assassin", {
	Name = ENT.PrintName,
	Class = "mvm_bot_scout_wrap_assassin",
	Category = ENT.Category
} )