if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "medic"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = false
ENT.PrintName		= "Blue Medic"
ENT.Category		= "TFBots"
ENT.Team = "BLU"

list.Set( "NPC", "tf_blue_bot_medic", {
	Name = ENT.PrintName,
	Class = "tf_blue_bot_medic",
	Category = ENT.Category,
	AdminOnly = true
} ) 