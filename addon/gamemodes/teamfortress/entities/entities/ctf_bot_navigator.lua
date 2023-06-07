-- taken from https://gmod.facepunch.com/f/gmodaddon/jgtl/Nextbot-Pathfinding-for-Players/1/

if SERVER then AddCSLuaFile() end

ENT.Base = "base_nextbot"
ENT.Type = "nextbot"

function ENT:Initialize()
	self:SetModel("models/gman.mdl")
	self:SetSolid( SOLID_NONE )
	self:SetNoDraw(true)
	self.PosGen = nil
	self.LookAtTime = 0
	self.LookAt = Angle(0, 0, 0)
	self.NextCenter = 0
	self.nextStuckJump = 0
	self.NextJump = 0
end

function ENT:ChasePos( options )  

	local options = options or {}
	self.P = Path( "Follow" )
	local path = self.P
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, self.PosGen )

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do

		path:Update( self )

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
		if ( options.repath ) then
			if ( path:GetAge() > options.repath ) then path:Compute( self, pos ) end
		end

		coroutine.wait(10)
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
		for k,v in ipairs(player.GetBots()) do
			if (v.ControllerBot:EntIndex() == self:EntIndex()) then
				self:SetModel(v:GetModel())
				self:SetModelScale(v:GetModelScale())
			end
		end
		if self.PosGen then
			self:ChasePos({})
		end
		coroutine.yield()
	end
end