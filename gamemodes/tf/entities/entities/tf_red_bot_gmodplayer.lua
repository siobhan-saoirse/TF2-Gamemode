if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "gmodplayer"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.IsBoss = false
ENT.PrintName		= "Red GMOD Player"
ENT.Category		= "TFBots"

list.Set( "NPC", "tf_red_bot_gmodplayer", {
	Name = ENT.PrintName,
	Class = "tf_red_bot_gmodplayer",
	Category = ENT.Category,
	AdminOnly = true
} ) 