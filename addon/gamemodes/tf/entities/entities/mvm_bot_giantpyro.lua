if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantpyro"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true	
ENT.Difficulty = 3
ENT.PrintName		= "Giant Pyro"
ENT.Category		= "TFBots - MVM"
ENT.Items = {"Flame Thrower","Fire Axe"}
ENT.PreferredIcon = "hud/leaderboard_class_pyro"

list.Set( "NPC", "mvm_bot_giantpyro", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantpyro",
	Category = ENT.Category,
	--AdminOnly = true
	AdminOnly = false
} ) 