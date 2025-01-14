if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantsoldierrapidfire"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Giant Rapid Fire Soldier"
ENT.Category		= "TFBots - MVM"

list.Set( "NPC", "mvm_bot_giantrapidfiresoldier", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantrapidfiresoldier",
	Category = ENT.Category,
	AdminOnly = true
} )