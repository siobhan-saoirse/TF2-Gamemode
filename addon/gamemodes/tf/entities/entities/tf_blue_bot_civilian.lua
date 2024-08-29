if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end
if (!file.Exists("models/player/civilian.mdl","WORKSHOP")) then return end

ENT.Base = "tf_red_bot"
ENT.PZClass = "civilian_"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.IsBoss = false
ENT.PrintName		= "Blue Civilian"
ENT.Category		= "TFBots"
ENT.Team = "BLU"

list.Set( "NPC", "tf_blue_bot_civilian", {
	Name = ENT.PrintName,
	Class = "tf_blue_bot_civilian",
	Category = ENT.Category,
	AdminOnly = true
} )