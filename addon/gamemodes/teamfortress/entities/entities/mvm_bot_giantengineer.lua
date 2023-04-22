if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantengineer"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.PrintName		= "Giant Engineer"
ENT.Category		= "TF2: MVM Bots"
list.Set( "NPC", "mvm_bot_giantengineer", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantengineer",
	Category = ENT.Category,
	--AdminOnly = true
	AdminOnly = false
} )