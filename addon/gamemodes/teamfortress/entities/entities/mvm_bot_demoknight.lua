if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "demoknight"
ENT.Spawnable = false
ENT.AdminOnly = false		
ENT.IsBoss = false
ENT.Difficulty = 2
ENT.PrintName		= "Demoknight"
ENT.Category		= "TFBots"
ENT.Items = {"Chargin' Targe","Eyelander"}	
ENT.PreferredIcon = "hud/leaderboard_class_demoknight"

list.Set( "NPC", "mvm_bot_demoknight", {
	Name = ENT.PrintName,
	Class = "mvm_bot_demoknight",
	Category = ENT.Category
} )