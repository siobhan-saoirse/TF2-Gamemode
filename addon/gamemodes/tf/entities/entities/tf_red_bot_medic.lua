if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "medic"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.IsBoss = false
ENT.PrintName		= "Red Medic"
ENT.Category		= "TFBots"

list.Set( "NPC", "tf_red_bot_medic", {
	Name = ENT.PrintName,
	Class = "tf_red_bot_medic",
	Category = ENT.Category,
	AdminOnly = true
} )