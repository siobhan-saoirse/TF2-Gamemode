if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "steelgauntletpusher"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.IsBoss = false
ENT.Difficulty = 3
ENT.PrintName		= "Steel Gauntlet Pusher"
ENT.Category		= "TF2: MVM Bots"

list.Set( "NPC", "mvm_bot_steelgauntletpusher", {
	Name = ENT.PrintName,
	Class = "mvm_bot_steelgauntletpusher",
	Category = ENT.Category
} )