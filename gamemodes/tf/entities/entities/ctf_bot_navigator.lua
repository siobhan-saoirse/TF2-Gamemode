-- taken from https://gmod.facepunch.com/f/gmodaddon/jgtl/Nextbot-Pathfinding-for-Players/1/

if SERVER then AddCSLuaFile() end

ENT.Base = "base_nextbot"
ENT.Type = "nextbot"

function ENT:Initialize()
	self:SetModel("models/gman.mdl")
	self:SetNoDraw(true)
	self:SetSolid( SOLID_NONE )
	self.PosGen = nil
	self.NextJump = -1
	self.NextDuck = 0
	self.cur_segment = 2
	self.Target = nil
	self.LastSegmented = 0
	self.ForgetTarget = 0
	self.NextCenter = 0
	self.LookAt = Angle(0, 0, 0)
	self.LookAtTime = 0
	self.goalPos = Vector(0, 0, 0)
	self.strafeAngle = 0
	self.nextStuckJump = 0
end

function ENT:ChasePos( options )
	if (self.PosGen ~= nil) then
		self.P = Path("Follow")
		self.P:Compute(self, self.PosGen)
		
		if !self.P:IsValid() then return end
		while self.P:IsValid() do
				 
			if (IsValid(self:GetOwner())) then
				local owner = self:GetOwner()
				self:SetModel(owner:GetModel())
				self:SetVelocity(owner:GetVelocity())
			end

			self.loco:FaceTowards(self.PosGen)
			self.loco:Approach( self.PosGen, 1 )
			--self.P:Compute(self:GetOwner(), self.PosGen)
			--self.P:Update( self:GetOwner() )
			
			if self.loco:IsStuck() then
				self:HandleStuck()
				return
			end
			
			coroutine.wait(1)
			coroutine.yield()
		end
	end
end

function ENT:OnInjured()
	return false
end

function ENT:OnKilled()
	return false
end

function ENT:RunBehaviour()
	while (true) do
		if self.PosGen then
			self:ChasePos({})
		end
		coroutine.wait(0.1)
		coroutine.yield()
	end
end


function ENT:Think()
	if self.PosGen then -- If the bot has a target location (i.e., an ally), go for it.
		if GetConVar("developer"):GetFloat() > 0 and self.P:IsValid() then
			self.P:Draw()
		end

		if (IsValid(self:GetOwner())) then
			self.loco:SetDesiredSpeed(self:GetOwner():GetWalkSpeed())
		end
	end
end