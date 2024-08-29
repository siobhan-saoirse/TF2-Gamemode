if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "sniper"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.IsBoss = false
ENT.PrintName		= "Red Sniper"
ENT.Category		= "TFBots"

list.Set( "NPC", "tf_red_bot_sniper", {
	Name = ENT.PrintName,
	Class = "tf_red_bot_sniper",
	Category = ENT.Category,
	AdminOnly = true
} )