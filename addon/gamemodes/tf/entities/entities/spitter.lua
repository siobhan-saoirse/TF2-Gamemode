if (!IsMounted("left4dead2")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "boomer"
ENT.PZClass = "spitter"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.PrintName		= "Spitter"
ENT.Category		= "Left 4 Dead 2 Bots"

list.Set( "NPC", "tf_spitter", {
	Name = ENT.PrintName,
	Class = "spitter",
	Category = ENT.Category,
	AdminOnly = true
} )
