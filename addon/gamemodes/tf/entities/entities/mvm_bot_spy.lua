if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "spy"
ENT.Spawnable = false
ENT.AdminOnly = false		
ENT.IsBoss = false
ENT.PrintName		= "Spy"
ENT.Category		= "TFBots - MVM"

list.Set( "NPC", "mvm_bot_spy", {
	Name = ENT.PrintName,
	Class = "mvm_bot_spy",
	Category = ENT.Category,
	AdminOnly = true
} )