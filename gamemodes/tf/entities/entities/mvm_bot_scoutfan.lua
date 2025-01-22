if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "scout"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.Difficulty = 3
ENT.PrintName		= "Force-A-Nature Scout"
ENT.Category		= "TFBots: MVM"
ENT.Items = {"Force-A-Nature","Bolt Boy","Fed-Fightin' Fedora"}
ENT.VisionLimits = 500

list.Set( "NPC", "mvm_bot_scoutfan", {
	Name = ENT.PrintName,
	Class = "mvm_bot_scoutfan",
	Category = ENT.Category,
	AdminOnly = true
} )