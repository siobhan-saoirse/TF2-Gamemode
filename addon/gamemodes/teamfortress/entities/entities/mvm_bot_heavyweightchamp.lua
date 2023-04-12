if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "heavyweightchamp"
ENT.Spawnable = false 
ENT.AdminOnly = false
ENT.IsBoss = false
ENT.PrintName		= "Heavyweight Champ"
ENT.Category		= "TF2: MVM Bots"
ENT.Items = {"Killing Gloves of Boxing","Pugilist's Protector"}
ENT.PreferredIcon = "hud/leaderboard_class_heavy_champ"

list.Set( "NPC", "mvm_bot_heavyweightchamp", {
	Name = ENT.PrintName,
	Class = "mvm_bot_heavyweightchamp",
	Category = ENT.Category
} )