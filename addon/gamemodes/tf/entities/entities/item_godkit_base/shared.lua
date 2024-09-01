
ENT.Type = "anim"  
ENT.Base = "item_base"    

ENT.Model = "models/items/medkit_small.mdl"
ENT.HealthPercentage = 999
ENT.AmmoPercentage = 999

if SERVER then

AddCSLuaFile("shared.lua")

function ENT:CanPickup(ply)
	return ply:Health()<ply:GetMaxHealth() or not ply:HasFullAmmo()
end

function ENT:PlayerTouched(pl)
	local h = self.HealthPercentage
	if pl.TempAttributes and pl.TempAttributes.HealthFromPacksMultiplier then
		h = h * pl.TempAttributes.HealthFromPacksMultiplier 
	end
	
	pl:SendLua([[EmitSound("HealthKit.Touch", Vector(]]..pl:GetPos().x..[[,]]..pl:GetPos().y..[[,]]..pl:GetPos().z..[[))]])
	self:Hide()
	GAMEMODE:GiveHealthPercent(pl, h)
	GAMEMODE:ExtinguishEntity(pl)
	GAMEMODE:EntityStopBleeding(pl)
	local a = self.AmmoPercentage
	if pl.TempAttributes and pl.TempAttributes.AmmoFromPacksMultiplier then
		a = a * pl.TempAttributes.AmmoFromPacksMultiplier
	end
	
	pl:SendLua([[EmitSound("AmmoPack.Touch", Vector(]]..pl:GetPos().x..[[,]]..pl:GetPos().y..[[,]]..pl:GetPos().z..[[)]])
	self:Hide()
	GAMEMODE:GiveAmmoPercent(pl, a)
	self:Remove()
end

end
