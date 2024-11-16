if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "soldier"
ENT.Spawnable = false 
ENT.AdminOnly = false
ENT.IsBoss = false 
ENT.PrintName		= "Blue Soldier"
ENT.Category		= "TFBots"
ENT.Team = "BLU"

list.Set( "NPC", "tf_blue_bot_soldier", {
	Name = ENT.PrintName,
	Class = "tf_blue_bot_soldier",
	Category = ENT.Category,
	AdminOnly = true
} ) 