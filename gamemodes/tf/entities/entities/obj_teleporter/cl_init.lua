
include("shared.lua")

ENT.RenderGroup 		= RENDERGROUP_BOTH

local TeleporterParticles = {
	{
		arms = "teleporter_arms_circle_red",
		charged = {
			"teleporter_red_charged_level1",
			"teleporter_red_charged_level2",
			"teleporter_red_charged_level3",
		},
		entrance = {
			"teleporter_red_entrance_level1",
			"teleporter_red_entrance_level2",
			"teleporter_red_entrance_level3",
		},
		exit = {
			"teleporter_red_exit_level1",
			"teleporter_red_exit_level2",
			"teleporter_red_exit_level3",
		},
	},
	{
		arms = "teleporter_arms_circle_blue",
		charged = {
			"teleporter_blue_charged_level1",
			"teleporter_blue_charged_level2",
			"teleporter_blue_charged_level3",
		},
		entrance = {
			"teleporter_blue_entrance_level1",
			"teleporter_blue_entrance_level2",
			"teleporter_blue_entrance_level3",
		},
		exit = {
			"teleporter_blue_exit_level1",
			"teleporter_blue_exit_level2",
			"teleporter_blue_exit_level3",
		},
	},
}

ENT.Sound_Spin1 = Sound("Building_Teleporter.SpinLevel1")
ENT.Sound_Spin2 = Sound("Building_Teleporter.SpinLevel2")
ENT.Sound_Spin3 = Sound("Building_Teleporter.SpinLevel3")

function ENT:UpdateParticles()
	local link = self:GetLinkedTeleporter()
	local level = self:GetLevel()
	
	self:StopParticles()
	
	if not IsValid(link) then return end
	
	local p
	if self:Team() == TEAM_BLU then
		p = TeleporterParticles[2]
	else
		p = TeleporterParticles[1]
	end
	
	ParticleEffectAttach(p.arms, PATTACH_POINT_FOLLOW, self, self:LookupAttachment("arm_attach_L"))
	ParticleEffectAttach(p.arms, PATTACH_POINT_FOLLOW, self, self:LookupAttachment("arm_attach_R"))
	
	if self:IsEntrance() then
		ParticleEffectAttach(p.entrance[level], PATTACH_ABSORIGIN_FOLLOW, self, 0)
	elseif self:IsExit() then
		ParticleEffectAttach(p.entrance[level], PATTACH_ABSORIGIN_FOLLOW, self, 0)
	end
	
	if self:IsReady() then
		ParticleEffectAttach(p.charged[level], PATTACH_ABSORIGIN_FOLLOW, self, 0)
	end
end

function ENT:Think()
	if !self.Spin_Sound and self:GetLinkedTeleporter() != nil and self:GetState()==3 || self.Spin_Sound and !self.Spin_Sound:IsPlaying() and self:GetLinkedTeleporter() != nil and self:GetState()==3 then
		
		if (self:GetLevel() == 1) then

			self.Spin_Sound = CreateSound(self, self.Sound_Spin1)
			self.Spin_Sound:Play()

		elseif self:GetLevel() == 2 then

			self.Spin_Sound = CreateSound(self, self.Sound_Spin2)
			self.Spin_Sound:Play()

		else

			self.Spin_Sound = CreateSound(self, self.Sound_Spin3)
			self.Spin_Sound:Play()

		end
	end
	if (self:GetState()~=3 and self.Spin_Sound) then

		self.Spin_Sound:Stop()

	end
	if self.Spin_Sound then
		self.Spin_Sound:ChangePitch(math.Clamp(100*self:GetNWFloat("SpinSpeed",0), 1, 100), 0)
	end
	local link = self:GetLinkedTeleporter()
	local level = self:GetLevel()
	local ready = self:IsReady()
	
	if link ~= self.LastLinkedTeleporter or level ~= self.LastLevel or ready ~= self.LastReady then
		self:UpdateParticles()
		self.LastLinkedTeleporter = link
		self.LastLevel = level
		self.LastReady = ready
	end
end


function ENT:OnRemove()
	if self.Spin_Sound then
		self.Spin_Sound:Stop()
	end
end