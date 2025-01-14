if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantheavy"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.PrintName		= "Giant Natascha Heavy"
ENT.Items = {"Natascha"}
ENT.Category		= "TFBots - MVM"

list.Set( "NPC", "mvm_bot_giantheavy_natascha", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantheavy_natascha",
	Category = ENT.Category,
	AdminOnly = true
} )