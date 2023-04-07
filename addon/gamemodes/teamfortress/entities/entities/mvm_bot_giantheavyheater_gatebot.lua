if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantheavyheater"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Giant Heater Heavy"
ENT.Items = {"MvM GateBot Light Heavy","Huo-Long Heater"}
ENT.Category		= "TF2: MVM GateBots"
ENT.PreferredIcon = "hud/leaderboard_class_heavy_heater"

list.Set( "NPC", "mvm_bot_giantheavyheater_gatebot", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantheavyheater_gatebot",
	Category = ENT.Category,
	AdminOnly = true
} )