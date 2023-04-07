if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "melee_scout"
ENT.Spawnable = false
ENT.AdminOnly = false		
ENT.IsBoss = false
ENT.Difficulty = 2
ENT.PrintName		= "Minor League Scout"
ENT.Items = {"Batter's Helmet","Sandman"}
ENT.Category		= "TF2: MVM Bots"

list.Set( "NPC", "mvm_bot_scout_minor_league", {
	Name = ENT.PrintName,
	Class = "mvm_bot_scout_minor_league",
	Category = ENT.Category
} )