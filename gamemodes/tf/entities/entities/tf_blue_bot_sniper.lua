if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "sniper"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = false
ENT.PrintName		= "Blue Sniper"
ENT.Category		= "TFBots"
ENT.Team = "BLU" 

list.Set( "NPC", "tf_blue_bot_sniper", {
	Name = ENT.PrintName,
	Class = "tf_blue_bot_sniper",
	Category = ENT.Category,
	AdminOnly = true
} ) 