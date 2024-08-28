if (!IsMounted("left4dead2")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "boomer"
ENT.PZClass = "charger"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.PrintName		= "Charger"
ENT.Category		= "Left 4 Dead 2 Bots"

list.Set( "NPC", "tf_charger", {
	Name = ENT.PrintName,
	Class = "charger",
	Category = ENT.Category
} )
