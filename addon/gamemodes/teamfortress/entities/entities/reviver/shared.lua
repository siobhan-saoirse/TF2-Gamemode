ENT.Base = "base_entity"   
ENT.Type = "anim"     
 
ENT.IsReviveMark = true
ENT.AutomaticFrameAdvance = true

if CLIENT then

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

end