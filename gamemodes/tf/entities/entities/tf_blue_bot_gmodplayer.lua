if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "gmodplayer"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = false
ENT.PrintName		= "Blue GMOD Player"
ENT.Category		= "TFBots: Extras"
ENT.Team = "BLU"

list.Set( "NPC", "tf_blue_bot_gmodplayer", {
	Name = ENT.PrintName,
	Class = "tf_blue_bot_gmodplayer",
	Category = ENT.Category,
	AdminOnly = true
} ) 