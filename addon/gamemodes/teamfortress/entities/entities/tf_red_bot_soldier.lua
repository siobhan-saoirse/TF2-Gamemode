if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "soldier"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.IsBoss = false
ENT.PrintName		= "Soldier"
ENT.Category		= "TFBots"

list.Set( "NPC", "tf_red_bot_soldier", {
	Name = ENT.PrintName,
	Class = "tf_red_bot_soldier",
	Category = ENT.Category
} )