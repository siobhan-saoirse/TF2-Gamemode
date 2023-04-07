if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "heavyshotgun"
ENT.Spawnable = false 
ENT.AdminOnly = false
ENT.IsBoss = false
ENT.Difficulty = 2
ENT.Items = {"Shotgun"}
ENT.PrintName		= "Heavy Shotgun"
ENT.Category		= "TF2: MVM Bots"
ENT.PreferredIcon = "hud/leaderboard_class_heavy_shotgun"

list.Set( "NPC", "mvm_bot_heavyshotgun", {
	Name = ENT.PrintName,
	Class = "mvm_bot_heavyshotgun",
	Category = ENT.Category
} )