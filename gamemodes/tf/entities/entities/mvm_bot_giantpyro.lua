if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantpyro"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true	
ENT.Difficulty = 3
ENT.PrintName		= "Giant Pyro"
ENT.Category		= "TFBots - MVM"
ENT.Items = {"TF_WEAPON_FLAMETHROWER","TF_WEAPON_FIREAXE"}
ENT.PreferredIcon = "hud/leaderboard_class_pyro"

list.Set( "NPC", "mvm_bot_giantpyro", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantpyro",
	Category = ENT.Category,
	AdminOnly = true
} ) 