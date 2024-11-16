if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "pyro"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.IsBoss = false
ENT.PrintName		= "Red Pyro"
ENT.Category		= "TFBots"

list.Set( "NPC", "tf_red_bot_pyro", {
	Name = ENT.PrintName,
	Class = "tf_red_bot_pyro",
	Category = ENT.Category,
	AdminOnly = true
} ) 