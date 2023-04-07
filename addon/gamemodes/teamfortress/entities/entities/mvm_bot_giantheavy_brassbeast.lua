if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantheavy"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.PrintName		= "Giant Brass Beast Heavy"
ENT.Items = {"Brass Beast"}
ENT.Category		= "TF2: MVM Bots"

list.Set( "NPC", "mvm_bot_giantheavy_brassbeast", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantheavy_brassbeast",
	Category = ENT.Category,
	AdminOnly = true
} )