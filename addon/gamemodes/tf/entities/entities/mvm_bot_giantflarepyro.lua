if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantflarepyro"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Giant Flare Pyro"
ENT.Category		= "TFBots - MVM"
ENT.Items = {"Detonator","Old Guadalajara"}
ENT.PreferredIcon = "hud/leaderboard_class_pyro_flare_giant"

list.Set( "NPC", "mvm_bot_giantflarepyro", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantflarepyro",
	Category = ENT.Category,
	--AdminOnly = true
	AdminOnly = false
} ) 