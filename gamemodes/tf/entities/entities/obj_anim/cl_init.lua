
include("shared.lua")

//ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	self:AddEffects(EF_NOINTERP)
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
	if self.LastScale ~= self.dt.Scale then
		if self.dt.Scale > 0 then
			local scl = self.dt.Scale
			self:SetModelScale( scl, 0 )
			self:GetOwner():SetModelScale( scl, 0 )
		end
		self.LastScale = self.dt.Scale
	end
end
