ENT.PrintName		= "Health Kit (medium)"
ENT.Author			= "_Kilburn"
ENT.Information		= "A medium TF2 health kit. Gives 50% health."
ENT.Category		= "Team Fortress 2"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.AdminOnly		= true

ENT.Type = "anim"  
ENT.Base = "item_healthkit_base"    

ENT.Model = "models/items/medkit_medium.mdl"
ENT.HealthPercentage = 50

if SERVER then
	AddCSLuaFile("shared.lua")
end
