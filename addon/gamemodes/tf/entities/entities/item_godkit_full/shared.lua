ENT.PrintName		= "Godkit (infinite)"
ENT.Author			= "LeadKiller"
ENT.Information		= "A large TF2 health kit. Gives 100% health."
ENT.Category		= "Team Fortress 2"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.AdminOnly		= true

ENT.Type = "anim"  
ENT.Base = "item_godkit_base"    

ENT.Model = "models/items/tf_gift.mdl"
ENT.HealthPercentage = 999
ENT.AmmoPrecentage = 999

if SERVER then
	AddCSLuaFile("shared.lua")
end