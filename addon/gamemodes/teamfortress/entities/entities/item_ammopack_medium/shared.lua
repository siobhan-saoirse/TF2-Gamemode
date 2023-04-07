ENT.PrintName		= "Ammo Pack (medium)"
ENT.Author			= "_Kilburn"
ENT.Information		= "A medium TF2 ammo pack. Gives 50% ammo for all weapons."
ENT.Category		= "Team Fortress 2"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Type = "anim"  
ENT.Base = "item_ammopack_base"    

ENT.Model = "models/items/ammopack_medium.mdl"
ENT.AmmoPercentage = 50

if SERVER then
	AddCSLuaFile("shared.lua")
end