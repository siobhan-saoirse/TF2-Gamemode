if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "spy"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.IsBoss = false
ENT.PrintName		= "Blue Spy"
ENT.Category		= "TFBots"
ENT.Team = "BLU"

list.Set( "NPC", "tf_blue_bot_spy", {
	Name = ENT.PrintName,
	Class = "tf_blue_bot_spy",
	Category = ENT.Category,
	AdminOnly = true
} )