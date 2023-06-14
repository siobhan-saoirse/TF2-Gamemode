-- taken from https://gmod.facepunch.com/f/gmodaddon/jgtl/Nextbot-Pathfinding-for-Players/1/

if SERVER then AddCSLuaFile() end

ENT.Base = "base_nextbot"
ENT.Type = "nextbot"

function ENT:Initialize()
	self:SetModel("models/gman.mdl")
	self:SetSolid(SOLID_NONE)
	self:SetNoDraw(GetConVar("developer"):GetFloat() == 0)
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

	local options = options or {}
	self.P = Path( "Follow" )
	local path = self.P
	path:SetMinLookAheadDistance( 300 )
	path:SetGoalTolerance( options.tolerance or 20 )


	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do

		
		for k,v in ipairs(player.GetBots()) do
			if (v.ControllerBot:EntIndex() == self:EntIndex()) then
				v.loco:Approach(self.PosGen,1)
				v.loco:SetDesiredSpeed( 100 )  
				path:Compute( v, self.PosGen )
				path:Update( v )
			end
		end

		-- If we're stuck then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then

			self:HandleStuck()

			return "stuck"

		end

		path:Draw()
		debugoverlay.Line(path:GetStart(), path:GetEnd(), 0.2, Color(0,255,0), false)
		--
		-- If they set maxage on options then make sure the path is younger than it
		--
		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
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

function ENT:IsNPC()
	return false 
end

function ENT:IsNextBot()
	return false 
end

function ENT:HandleStuck()
	for k,v in ipairs(player.GetBots()) do
		if (v.ControllerBot:EntIndex() == self:EntIndex() and self.P:GetCurrentGoal().pos != nil) then
			v:SetPos(self.P:GetCurrentGoal().pos)
		end
	end
end
function ENT:RunBehaviour()
	while (true) do
		if self.PosGen then
			self:ChasePos({})
		end
		coroutine.yield()
	end
end