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
		coroutine.wait(1)
		coroutine.yield()
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
		coroutine.wait(1)
		coroutine.yield()
	end
end