if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "superheavyweightchamp"
ENT.Spawnable = false 
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.Items = {"Pugilist's Protector","Killing Gloves of Boxing"}
ENT.PrintName		= "Super Heavyweight Champ"
ENT.Category		= "TFBots - MVM"

list.Set( "NPC", "mvm_bot_heavyweightchamp_giant", {
	Name = ENT.PrintName,
	Class = "mvm_bot_heavyweightchamp_giant",
	Category = ENT.Category,
	AdminOnly = true,
	--AdminOnly = true
	AdminOnly = false
} )