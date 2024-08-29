if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantheavy"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Giant Heavy"
ENT.Category		= "TFBots - MVM"
list.Set( "NPC", "mvm_bot_giantheavy", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantheavy",
	Category = ENT.Category,
	AdminOnly = true,
	--AdminOnly = true
	AdminOnly = false
} )