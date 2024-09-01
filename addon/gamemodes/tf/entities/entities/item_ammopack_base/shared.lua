
ENT.Type = "anim"  
ENT.Base = "item_base"    

ENT.Model = "models/items/ammopack_small.mdl"
ENT.AmmoPercentage = 1

if SERVER then

AddCSLuaFile("shared.lua")

function ENT:CanPickup(ply)
	return not ply:HasFullAmmo()
end

function ENT:PlayerTouched(pl)
	local a = self.AmmoPercentage
	if pl.TempAttributes and pl.TempAttributes.AmmoFromPacksMultiplier then
		a = a * pl.TempAttributes.AmmoFromPacksMultiplier
	end
	
	pl:SendLua([[EmitSound("AmmoPack.Touch", Vector(]]..pl:GetPos().x..[[,]]..pl:GetPos().y..[[,]]..pl:GetPos().z..[[)]])
	self:Hide()
	if pl:IsPlayer() then
		GAMEMODE:GiveAmmoPercent(pl, a)
	end
end



end