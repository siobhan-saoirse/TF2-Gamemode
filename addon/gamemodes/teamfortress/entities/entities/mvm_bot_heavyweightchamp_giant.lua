if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "superheavyweightchamp"
ENT.Spawnable = false 
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.Items = {"Pugilist's Protector","Killing Gloves of Boxing"}
ENT.PrintName		= "Super Heavyweight Champ"
ENT.Category		= "TF2: MVM Bots"

list.Set( "NPC", "mvm_bot_heavyweightchamp_giant", {
	Name = ENT.PrintName,
	Class = "mvm_bot_heavyweightchamp_giant",
	Category = ENT.Category,
	--AdminOnly = true
	AdminOnly = false
} )