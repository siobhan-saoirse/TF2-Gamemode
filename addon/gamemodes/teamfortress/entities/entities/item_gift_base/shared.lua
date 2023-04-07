ENT.Type = "anim"  
ENT.Base = "item_ammopack_base"    

function ENT:CanPickup(ply)
	return ply:Alive()
end

function ENT:DropWithGravity(vel)
	self:EmitSound("Christmas.GiftDrop")
	self:SetMoveType(MOVETYPE_FLYGRAVITY)
	self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
	self:SetVelocity(vel)
	timer.Simple(8, function()
		if (IsValid(self)) then
			self:SetRenderFX(kRenderFxStrobeFast)
		end
	end)
	timer.Simple(12, function()
		if (IsValid(self)) then
			self:Hide()
		end
	end)
end

function ENT:Hide()
	self:Remove()
end


function ENT:PlayerTouched(pl)
	local a = self.AmmoPercentage
	if pl.TempAttributes and pl.TempAttributes.AmmoFromPacksMultiplier then
		a = a * pl.TempAttributes.AmmoFromPacksMultiplier
	end
	
	self:EmitSound("Christmas.GiftPickup", 100, 100)
	self:Hide()
	if pl:IsPlayer() then
		GAMEMODE:GiveAmmoPercent(pl, a)
	end
end

if SERVER then
	AddCSLuaFile("shared.lua")
end