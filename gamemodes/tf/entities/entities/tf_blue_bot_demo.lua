if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "demoman"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = false
ENT.PrintName		= "Blue Demoman"
ENT.Category		= "TFBots"
ENT.Team = "BLU"

list.Set( "NPC", "tf_blue_bot_demo", {
	Name = ENT.PrintName,
	Class = "tf_blue_bot_demo",
	Category = ENT.Category,
	AdminOnly = true
} ) 