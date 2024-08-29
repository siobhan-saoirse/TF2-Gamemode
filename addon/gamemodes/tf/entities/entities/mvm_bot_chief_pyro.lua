if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "chiefpyro"
ENT.Spawnable = false 
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Chief Pyro"
ENT.Category		= "TFBots - MVM"
ENT.OverrideModelScale = 1.9 

list.Set( "NPC", "mvm_bot_chief_pyro", {
	Name = ENT.PrintName,
	Class = "mvm_bot_chief_pyro",
	Category = ENT.Category,
	AdminOnly = true,
	--AdminOnly = true
	AdminOnly = false
} )