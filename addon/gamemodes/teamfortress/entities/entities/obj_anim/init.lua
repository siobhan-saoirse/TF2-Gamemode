
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()
	local owner = self:GetOwner()
	if not IsValid(owner) then
		self:Remove()
		return
	end
	
	self:SetBuilder(owner.Player)
	self:SetModel(owner:GetModel())
	self:SetSkin(owner:GetSkin())
	self:SetPos(owner:GetPos())
	self:SetAngles(owner:GetAngles())
	self:SetParent(owner)
	self:SetNotSolid(true)
end

function ENT:Think()
	self:NextThink(CurTime()+0.00001)
	return true
end
