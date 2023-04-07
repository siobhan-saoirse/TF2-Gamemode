ENT.Type = "anim"  
ENT.Base = "item_ammopack_base"    

function ENT:CanPickup(ply)
	return true
end

function ENT:DropWithGravity(vel)
	self:EmitSound("Halloween.PumpkinDrop")
	self:SetMoveType(MOVETYPE_FLYGRAVITY)
	self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
	self:SetVelocity(vel)
end

function ENT:Hide()
	self:Remove()
end

function ENT:PlayerTouched(pl)
	local a = self.AmmoPercentage
	if pl.TempAttributes and pl.TempAttributes.AmmoFromPacksMultiplier then
		a = a * pl.TempAttributes.AmmoFromPacksMultiplier
	end
	
	self:EmitSound("Halloween.PumpkinPickup", 100, 100)
	self:Hide()
	if pl:IsPlayer() then
		GAMEMODE:StartCritBoost(pl, 1)
		timer.Simple(3, function()
			if IsValid(pl) then
				GAMEMODE:StopCritBoost(pl)
			end
		end)
	end
end

if SERVER then
	AddCSLuaFile("shared.lua")
end