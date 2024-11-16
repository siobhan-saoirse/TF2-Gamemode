ENT.PrintName		= "Resupply Locker"
ENT.Author			= "LeadKiller"
ENT.Information		= "A resupply locker."
ENT.Category		= "Team Fortress 2"

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

ENT.Model = "models/props_gameplay/resupply_locker.mdl"
ENT.HealthPercentage = 100

if SERVER then
	AddCSLuaFile("shared.lua")
end