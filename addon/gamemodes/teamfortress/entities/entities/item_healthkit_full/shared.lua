ENT.PrintName		= "Health Kit (large)"
ENT.Author			= "_Kilburn"
ENT.Information		= "A large TF2 health kit. Gives 100% health."
ENT.Category		= "Team Fortress 2"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.AdminOnly		= true

ENT.Type = "anim"  
ENT.Base = "item_healthkit_base"    

ENT.Model = "models/items/medkit_large.mdl"
ENT.HealthPercentage = 100

if SERVER then
	AddCSLuaFile("shared.lua")
end