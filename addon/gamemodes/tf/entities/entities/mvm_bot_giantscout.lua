if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantscout"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Giant Scout"
ENT.Category		= "TFBots - MVM"
ENT.PreferredIcon = "hud/leaderboard_class_scout"

list.Set( "NPC", "mvm_bot_giantscout", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantscout",
	Category = ENT.Category,
	--AdminOnly = true
	AdminOnly = false
} )