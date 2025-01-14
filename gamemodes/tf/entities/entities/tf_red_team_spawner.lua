if SERVER then AddCSLuaFile() end
ENT.Type = "anim"
ENT.Base = "tf_blue_team_spawner"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true
ENT.PrintName		= "RED Spawner"
ENT.Category		= "TFBots"
ENT.Team = TEAM_RED

list.Set( "NPC", "tf_red_team_spawner", {
	Name = ENT.PrintName,
	Class = "tf_red_team_spawner",
	Category = ENT.Category,
	AdminOnly = true,
	AdminOnly = true
} )