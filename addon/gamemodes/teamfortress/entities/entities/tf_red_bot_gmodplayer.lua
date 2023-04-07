if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "gmodplayer"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.IsBoss = false
ENT.PrintName		= "GMOD Player"
ENT.Category		= "TF2: RED Bots"

list.Set( "NPC", "tf_red_bot_gmodplayer", {
	Name = ENT.PrintName,
	Class = "tf_red_bot_gmodplayer",
	Category = ENT.Category
} )