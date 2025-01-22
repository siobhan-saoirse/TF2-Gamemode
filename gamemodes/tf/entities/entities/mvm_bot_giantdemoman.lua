if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantdemoman"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.PrintName		= "Giant Demoman"
ENT.Category		= "TFBots: MVM"
list.Set( "NPC", "mvm_bot_giantdemoman", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantdemoman",
	Category = ENT.Category,
	AdminOnly = true
} )