if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "steelgauntlet"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = false
ENT.PrintName		= "Steel Gauntlet"
ENT.Category		= "TFBots: MVM"
ENT.PreferredIcon = "hud/leaderboard_class_heavy_steelfist"

list.Set( "NPC", "mvm_bot_steelgauntlet", {
	Name = ENT.PrintName,
	Class = "mvm_bot_steelgauntlet",
	Category = ENT.Category,
	AdminOnly = true
} )