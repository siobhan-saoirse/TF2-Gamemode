if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantsoldier"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Giant Soldier"
ENT.Category		= "TFBots - MVM"

list.Set( "NPC", "mvm_bot_giantsoldier", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantsoldier",
	Category = ENT.Category,
	AdminOnly = true
} ) 