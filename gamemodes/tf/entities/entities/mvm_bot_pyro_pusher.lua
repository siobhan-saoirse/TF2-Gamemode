if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "pyro_flare"
ENT.Spawnable = false
ENT.AdminOnly = true		
ENT.IsBoss = false
ENT.PrintName		= "Pyro Pusher"
ENT.Items = {"Scorch Shot"}
ENT.Category		= "TFBots: MVM"
ENT.PreferredIcon = "hud/leaderboard_class_pyro_flare"

list.Set( "NPC", "mvm_bot_pyro_pusher", {
	Name = ENT.PrintName,
	Class = "mvm_bot_pyro_pusher",
	Category = ENT.Category,
	AdminOnly = true
} )