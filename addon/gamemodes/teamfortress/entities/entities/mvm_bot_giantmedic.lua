if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantmedic"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.PrintName		= "Giant Medic"
ENT.Items = {"Syringe Gun","Quick-Fix","Bonesaw"}
ENT.Category		= "TF2: MVM Bots"

list.Set( "NPC", "mvm_bot_giantmedic", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantmedic",
	Category = ENT.Category,
	--AdminOnly = true
	AdminOnly = false
} )