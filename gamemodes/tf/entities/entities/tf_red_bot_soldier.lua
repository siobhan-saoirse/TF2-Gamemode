if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "soldier"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = false
ENT.PrintName		= "Red Soldier"
ENT.Category		= "TFBots"

list.Set( "NPC", "tf_red_bot_soldier", {
	Name = ENT.PrintName,
	Class = "tf_red_bot_soldier",
	Category = ENT.Category,
	AdminOnly = true
} ) 