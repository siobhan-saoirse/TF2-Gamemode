if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot" 
ENT.PZClass = "samuraidemo"
ENT.Spawnable = false
ENT.AdminOnly = false		
ENT.IsBoss = false
ENT.Difficulty = 3
ENT.PrintName		= "Samurai Demo"
ENT.Category		= "TF2: MVM Bots"
ENT.Items = {"Half-Zatoichi","Splendid Screen","Samur-Eye"}
ENT.PreferredIcon = "hud/leaderboard_class_demoknight_samurai"

list.Set( "NPC", "mvm_bot_samurai_demo", {
	Name = ENT.PrintName,
	Class = "mvm_bot_samurai_demo",
	Category = ENT.Category
} )