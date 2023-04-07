
include("shared.lua")

function ENT:Initialize()
	MsgFN("Initialized %s", tostring(self))
	
	self:InstallDataTable()
	self:SetupDataTables() -- we need to do this manually because SNPCs do not support clientside scripts
end


--[[function ENT:Think()
	if not self.DoneInitAnimFix then
		local seq = self:GetSequence()
		if self:GetSequenceActivity(seq) == ACT_OBJ_ASSEMBLING then
			self:AddEffects(EF_NOINTERP)
			self:SetCycle(0)
			self.NextRemoveNoInterp = CurTime() + 0.05
			self.DoneInitAnimFix = true
		end
	end
	
	if self.NextRemoveNoInterp and CurTime()>self.NextRemoveNoInterp then
		self.NextRemoveNoInterp = nil
		self:RemoveEffects(EF_NOINTERP)
	end
end]]

