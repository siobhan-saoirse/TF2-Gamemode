if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "chiefscout"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Chief Scout"
ENT.Category		= "TF2: Community MVM"

list.Set( "NPC", "mvm_bot_chiefscout", {
	Name = ENT.PrintName,
	Class = "mvm_bot_chiefscout",
	Category = ENT.Category,
	--AdminOnly = true
	AdminOnly = false
} )