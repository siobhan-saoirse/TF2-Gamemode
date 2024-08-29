if (!IsMounted("left4dead2")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "boomer"
ENT.PZClass = "hunter"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.PrintName		= "Hunter"
ENT.Category		= "Left 4 Dead 2 Bots"

list.Set( "NPC", "tf_hunter", {
	Name = ENT.PrintName,
	Class = "hunter",
	Category = ENT.Category,
	AdminOnly = true
} )
