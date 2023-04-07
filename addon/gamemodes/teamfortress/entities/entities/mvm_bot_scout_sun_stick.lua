if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "melee_scout"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.PrintName		= "Scout (Sun-on-a-Stick)"
ENT.Category		= "TF2: MVM Bots"
ENT.Items = {"Sun-on-a-Stick","Bolt Boy"}
ENT.PreferredIcon = "hud/leaderboard_class_scout_bat"

list.Set( "NPC", "mvm_bot_scout_sun_stick", {
	Name = ENT.PrintName,
	Class = "mvm_bot_scout_sun_stick",
	Category = ENT.Category
} )