if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "scout"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.IsBoss = false
ENT.Category		= "TFBots"
ENT.Team = "BLU"
ENT.PrintName		= "Blue Scout"

list.Set( "NPC", "tf_blue_bot", {
	Name = ENT.PrintName,
	Class = "tf_blue_bot",
	Category = ENT.Category,
	AdminOnly = true
} ) 