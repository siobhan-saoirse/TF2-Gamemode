if (!IsMounted("left4dead2")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "boomer"
ENT.PZClass = "tank_l4d"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.PrintName		= "Tank"
ENT.Category		= "Left 4 Dead 2 Bots"

list.Set( "NPC", "tf_tank", {
	Name = ENT.PrintName,
	Class = "tank",
	Category = ENT.Category,
	AdminOnly = true
} )
