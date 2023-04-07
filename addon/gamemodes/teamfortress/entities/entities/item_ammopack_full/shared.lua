ENT.PrintName		= "Ammo Pack (large)"
ENT.Author			= "_Kilburn"
ENT.Information		= "A large TF2 ammo pack. Completely refills ammo for all weapons."
ENT.Category		= "Team Fortress 2"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Type = "anim"  
ENT.Base = "item_ammopack_base"    

ENT.Model = "models/items/ammopack_large.mdl"
ENT.AmmoPercentage = 100

if SERVER then
	AddCSLuaFile("shared.lua")
end