if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "engineer"
ENT.Spawnable = false
ENT.AdminOnly = false		
ENT.IsBoss = false
ENT.PrintName		= "Engineer"
ENT.Category		= "TF2: MVM Bots"
ENT.PreferredIcon 	= "hud/leaderboard_class_teleporter"

list.Set( "NPC", "mvm_bot_engineer", {
	Name = ENT.PrintName,
	Class = "mvm_bot_engineer",
	Category = ENT.Category
} )