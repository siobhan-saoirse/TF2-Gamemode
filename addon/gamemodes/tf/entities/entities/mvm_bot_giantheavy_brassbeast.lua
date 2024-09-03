if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantheavy"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.PrintName		= "Giant Brass Beast Heavy"
ENT.Items = {"Brass Beast"}
ENT.Category		= "TFBots - MVM"

list.Set( "NPC", "mvm_bot_giantheavy_brassbeast", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantheavy_brassbeast",
	Category = ENT.Category,
	AdminOnly = true,
	--AdminOnly = true
	AdminOnly = false
} )