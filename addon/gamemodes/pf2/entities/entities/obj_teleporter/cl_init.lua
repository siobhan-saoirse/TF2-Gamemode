
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
		ParticleEffectAttach(p.exit[level], PATTACH_ABSORIGIN_FOLLOW, self, 0)
	end
	
	if self:IsReady() then
		ParticleEffectAttach(p.charged[level], PATTACH_ABSORIGIN_FOLLOW, self, 0)
	end
end

function ENT:Think()
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
