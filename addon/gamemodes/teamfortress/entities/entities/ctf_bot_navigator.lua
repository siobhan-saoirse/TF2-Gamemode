-- taken from https://gmod.facepunch.com/f/gmodaddon/jgtl/Nextbot-Pathfinding-for-Players/1/

if SERVER then AddCSLuaFile() end

ENT.Base = "base_nextbot"
ENT.Type = "nextbot"

function ENT:Initialize()
	self:SetModel("models/gman.mdl")
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetNoDraw(GetConVar("developer"):GetFloat() == 0)
	self.PosGen = nil
	self.LookAtTime = 0
	self.LookAt = Angle(0, 0, 0)
	self.NextCenter = 0
	self.nextStuckJump = 0
	self.NextJump = 0
end

function ENT:ChasePos( options )  

	local options = options or {}
	self.P = Path( "Chase" )
	local path = self.P
	path:SetMinLookAheadDistance( 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	for k,v in ipairs(player.GetBots()) do
		if (v.ControllerBot:EntIndex() == self:EntIndex()) then
			path:Compute( v, self.PosGen )
		end
	end

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do

		self.loco:SetDesiredSpeed( 100 )
		self.loco:Approach(self.PosGen,1)
		for k,v in ipairs(player.GetBots()) do
			if (v.ControllerBot:EntIndex() == self:EntIndex()) then
				path:Compute( v, self.PosGen )
			end
		end
		for k,v in ipairs(player.GetBots()) do
			if (v.ControllerBot:EntIndex() == self:EntIndex()) then
				path:Update( v )
			end
		end

		-- If we're stuck then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then

			self:HandleStuck()

			return "stuck"

		end

		if GetConVar("developer"):GetFloat() > 0 then
			path:Draw()
		end

		--
		-- If they set maxage on options then make sure the path is younger than it
		--
		if ( options.maxage ) then
			if ( path:GetAge() > options.maxage ) then return "timeout" end
		end

		--
		-- If they set repath then rebuild the path every x seconds
		--
		if ( path:GetAge() > 0.02 ) then path:Compute( self, pos ) end

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