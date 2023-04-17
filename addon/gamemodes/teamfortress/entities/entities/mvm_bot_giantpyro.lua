if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantpyro"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Giant Pyro"
ENT.Category		= "TF2: MVM Bots"
ENT.Items = {"Flame Thrower","Fire Axe"}

list.Set( "NPC", "mvm_bot_giantpyro", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantpyro",
	Category = ENT.Category,
	--AdminOnly = true
	AdminOnly = false
} ) 