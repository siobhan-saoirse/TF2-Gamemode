if (!IsMounted("left4dead2")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "boomer"
ENT.PZClass = "jockey"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.PrintName		= "Jockey"
ENT.Category		= "Left 4 Dead 2 Bots"

list.Set( "NPC", "tf_jockey", {
	Name = ENT.PrintName,
	Class = "jockey",
	Category = ENT.Category
} )
