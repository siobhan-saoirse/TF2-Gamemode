if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "chieftavish"
ENT.Spawnable = false 
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Chief Tavish"
ENT.Category		= "TFBots"
ENT.OverrideModelScale = 1.9 
ENT.PreferredIcon = "hud/leaderboard_class_demoknight_giant"

list.Set( "NPC", "mvm_bot_chief_tavish", {
	Name = ENT.PrintName,
	Class = "mvm_bot_chief_tavish"	,
	Category = ENT.Category,
	--AdminOnly = true
	AdminOnly = false
} )