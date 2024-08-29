if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "superscout"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Super Scout"
ENT.Category		= "TFBots - MVM"

list.Set( "NPC", "mvm_bot_superscout", {
	Name = ENT.PrintName,
	Class = "mvm_bot_superscout",
	Category = ENT.Category,
	AdminOnly = true,
	--AdminOnly = true
	AdminOnly = false
} )