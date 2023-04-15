-- taken from https://gmod.facepunch.com/f/gmodaddon/jgtl/Nextbot-Pathfinding-for-Players/1/

if SERVER then AddCSLuaFile() end

ENT.Base = "base_nextbot"
ENT.Type = "nextbot"

function ENT:Initialize()
	self:SetModel("models/gman.mdl")
	self:SetNoDraw(true)
	self:SetSolid( SOLID_NONE )
	self.PosGen = nil
	self.LookAtTime = 0
	self.LookAt = Angle(0, 0, 0)
end

function ENT:ChasePos( options ) 
	self.P = Path("Follow")
	self.P:SetMinLookAheadDistance(300)
	self.P:SetGoalTolerance(20)
	if (self.PosGen == nil) then return end
	self.P:Compute(self, self.PosGen)
	
	if !self.P:IsValid() then return end
	while self.P:IsValid() do
		if self.P:GetAge() > 0.3 then
			if (self.PosGen == nil) then return end
			self.P:Compute(self, self.PosGen)
		end
		if GetConVar("developer"):GetFloat() > 0 then
			self.P:Draw()
		end
		
		if self.loco:IsStuck() then
			self:HandleStuck()
			return
		end
		coroutine.wait(2)
		coroutine.yield()
	end
end

function ENT:OnInjured()
	return false
end

function ENT:OnKilled()
	return false 
end

function ENT:HandleStuck()
	for k,v in ipairs(player.GetBots()) do
		if (v.ControllerBot:EntIndex() == self:EntIndex()) then
			self:SetModel(v:GetModel())
			v:SetPos(v.LastPath[v.CurSegment + 1])
		end
	end
end
function ENT:RunBehaviour()
	while (true) do
		if self.PosGen then
			self:ChasePos({})
		end
		coroutine.wait(2)
		coroutine.yield()
	end
end