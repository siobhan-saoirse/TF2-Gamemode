if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "heavyweightchamp"
ENT.Spawnable = false 
ENT.AdminOnly = false
ENT.IsBoss = false
ENT.Items = {"Gloves of Running Urgently MvM"} 
ENT.PrintName		= "Heavyweight Champ (Fast)"
ENT.Category		= "TFBots - MVM"
ENT.PreferredIcon = "hud/leaderboard_class_heavy_gru"

list.Set( "NPC", "mvm_bot_heavyweightchampfast", {
	Name = ENT.PrintName,
	Class = "mvm_bot_heavyweightchampfast",
	Category = ENT.Category,
	AdminOnly = true
} )