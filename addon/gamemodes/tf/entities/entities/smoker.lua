if (!IsMounted("left4dead2")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "boomer"
ENT.PZClass = "smoker"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.PrintName		= "Smoker"
ENT.Category		= "Left 4 Dead 2 Bots"

list.Set( "NPC", "tf_smoker", {
	Name = ENT.PrintName,
	Class = "smoker",
	Category = ENT.Category,
	AdminOnly = true
} )
