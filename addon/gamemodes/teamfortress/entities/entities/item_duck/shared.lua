ENT.PrintName		= "Duck"
ENT.Author			= "Agent Agrimar, _Kilburn"
ENT.Information		= "It's a duck! Quack."
ENT.Category		= "Team Fortress 2"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true

ENT.Type = "anim"  
ENT.Base = "item_healthkit_base"    

ENT.Model = "models/items/target_duck.mdl"
ENT.HealthPercentage = 1

if SERVER then

AddCSLuaFile("shared.lua")

function ENT:CanPickup(ply)
	return ply:Health()<ply:GetMaxHealth()
end

function ENT:PlayerTouched(pl)
	local h = self.HealthPercentage
	if pl.TempAttributes and pl.TempAttributes.HealthFromPacksMultiplier then
		h = h * pl.TempAttributes.HealthFromPacksMultiplier
	end
	
	self:EmitSound("Duck.Touch")
	self:Hide()
	GAMEMODE:GiveHealthPercent(pl, h)
	GAMEMODE:ExtinguishEntity(pl)
	GAMEMODE:EntityStopBleeding(pl)
end

end
