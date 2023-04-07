ENT.PrintName		= "Health Kit (small)"
ENT.Author			= "_Kilburn"
ENT.Information		= "A small TF2 health kit. Gives 20.5% health."
ENT.Category		= "Team Fortress 2"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.AdminOnly		= true

ENT.Type = "anim"  
ENT.Base = "item_healthkit_base"    

ENT.Model = "models/items/medkit_small.mdl"
ENT.HealthPercentage = 20.5

if SERVER then
	AddCSLuaFile("shared.lua")
end