if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantburstfiresoldier2"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true 
ENT.Difficulty = 3
ENT.PreferredName = "Giant Burst Fire Soldier"
ENT.PrintName		= "Giant Burst Fire Soldier (Type 2)"
ENT.Category		= "TFBots"  
ENT.PreferredIcon = "hud/leaderboard_class_soldier_burstfire"

list.Set( "NPC", "mvm_bot_giantburstfiresoldier2", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantburstfiresoldier2",
	Category = ENT.Category,
	--AdminOnly = true
	AdminOnly = false
} )