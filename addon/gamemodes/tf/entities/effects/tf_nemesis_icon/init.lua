
function EFFECT:Init(data)
	local ent = data:GetEntity()
	self.Parent = ent
	
	if not IsValid(self.Parent) then
		return
	end
	
	if IsValid(self.Parent.NemesisEffect) then
		self:Remove()
		return
	end
	
	self.Parent.NemesisEffect = self
	
	if self.Parent:EntityTeam() == TEAM_BLU then
		ParticleEffectAttach("particle_nemesis_blue", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	else
		ParticleEffectAttach("particle_nemesis_red", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	end
	
	self:SetParent(self.Parent)
end

function EFFECT:Think()
	if self.NextDie then
		return CurTime() <= self.NextDie
	end
	
	if IsValid(self.Parent) then
		if not self.ParentHeight then
			self.ParentHeight = self.Parent:OBBMaxs().z
		end
		
		self:SetPos(self.Parent:GetPos() + self.ParentHeight * vector_up)
	else
		self:SetParent()
		self:SetPos(-10000*vector_up)
		self.NextDie = CurTime() + 1
	end
	
	return true
end

function EFFECT:Render()
end

function EFFECT:Destroy()
	self.Parent.NemesisEffect = nil
	self.Parent = nil
end
