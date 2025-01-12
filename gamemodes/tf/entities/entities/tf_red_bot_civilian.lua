if (!IsMounted("tf")) then return end
if (!file.Exists("models/player/civilian.mdl","WORKSHOP")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "civilian_"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = false
ENT.PrintName		= "Red Civilian"
ENT.Category		= "TFBots"

list.Set( "NPC", "tf_red_bot_civilian", {
	Name = ENT.PrintName,
	Class = "tf_red_bot_civilian",
	Category = ENT.Category,
	AdminOnly = true
} )