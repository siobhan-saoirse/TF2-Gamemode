if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "steelgauntletpusher"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = false
ENT.Difficulty = 3
ENT.PrintName		= "Steel Gauntlet Pusher"
ENT.Category		= "TFBots - MVM"

list.Set( "NPC", "mvm_bot_steelgauntletpusher", {
	Name = ENT.PrintName,
	Class = "mvm_bot_steelgauntletpusher",
	Category = ENT.Category,
	AdminOnly = true
} )