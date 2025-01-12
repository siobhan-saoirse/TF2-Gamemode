if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "pyro"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = false
ENT.PrintName		= "Blue Pyro"
ENT.Category		= "TFBots"
ENT.Team = "BLU"

list.Set( "NPC", "tf_blue_bot_pyro", {
	Name = ENT.PrintName,
	Class = "tf_blue_bot_pyro",
	Category = ENT.Category,
	AdminOnly = true
} ) 