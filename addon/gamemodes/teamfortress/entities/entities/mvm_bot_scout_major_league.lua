if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "superscout"
ENT.Spawnable = false
ENT.AdminOnly = true		
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Major League Scout"
ENT.Items = {"Batter's Helmet","Essential Accessories","Sandman"}
ENT.Category		= "TF2: MVM Bots"

list.Set( "NPC", "mvm_bot_scout_major_league", {
	Name = ENT.PrintName,
	Class = "mvm_bot_scout_major_league",
	Category = ENT.Category,
	--AdminOnly = true
	AdminOnly = false
} )