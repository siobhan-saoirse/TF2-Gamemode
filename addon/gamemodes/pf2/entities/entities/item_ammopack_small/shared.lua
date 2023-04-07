ENT.PrintName		= "Ammo Pack (small)"
ENT.Author			= "_Kilburn"
ENT.Information		= "A small TF2 ammo pack. Gives 20.5% ammo for all weapons."
ENT.Category		= "Team Fortress 2"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Type = "anim"  
ENT.Base = "item_ammopack_base"    

ENT.Model = "models/items/ammopack_small.mdl"
ENT.AmmoPercentage = 20.5

if SERVER then
	AddCSLuaFile("shared.lua")
end