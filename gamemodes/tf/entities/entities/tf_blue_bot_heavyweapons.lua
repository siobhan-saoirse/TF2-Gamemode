if SERVER then AddCSLuaFile() end

ENT.Base = "tf_red_bot"
ENT.PZClass = "heavy"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = false
ENT.PrintName		= "Blue Heavy"
ENT.Category		= "TFBots"
ENT.Team = "BLU"

list.Set( "NPC", "tf_blue_bot_heavyweapons", {
	Name = ENT.PrintName,
	Class = "tf_blue_bot_heavyweapons",
	Category = ENT.Category,
	AdminOnly = true
} ) 