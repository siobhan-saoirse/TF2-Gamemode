
include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	self:AddEffects(EF_NOINTERP)
	self.NextRemoveNoInterp = CurTime() + 0.5
end

function ENT:Draw()
	self:DrawModel()
	
	if self.LastDrawn then
		self:FrameAdvance(CurTime() - self.LastDrawn)
	end
	self.LastDrawn = CurTime()
end

function ENT:Think()
	if self.LastScale ~= self.dt.Scale then
		if self.dt.Scale > 0 then
			local scl = Vector(self.dt.Scale, self.dt.Scale, self.dt.Scale)
			self:SetModelScale( 0.8, 0 )
			self:GetOwner():SetModelScale( 0.8, 0 )
		end
		self.LastScale = self.dt.Scale
	end
	
	if self.NextRemoveNoInterp and CurTime() > self.NextRemoveNoInterp then
		self.NextRemoveNoInterp = nil
		self:RemoveEffects(EF_NOINTERP)
	end
end
