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
		self.P:SetGoalTolerance(250)
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
		if self.PosGen then
			self:ChasePos({})
		end
		coroutine.wait(0.1)
		coroutine.yield()
	end
end


function ENT:Think()
	if self.PosGen then -- If the bot has a target location (i.e., an ally), go for it.
		if (self.PosGen ~= nil) then
		end

		if (self.P ~= nil) then
			self.P:Compute(self, self.PosGen, function( area, fromArea, ladder, elevator, length )
				if ( !IsValid( fromArea ) ) then
			
					-- first area in path, no cost
					return 0
				
				else
				
					if ( !self.loco:IsAreaTraversable( area ) ) then
						-- our locomotor says we can't move here
						return -1
					end
			
					-- compute distance traveled along path so far
					local dist = 0
			
					if ( IsValid( ladder ) ) then
						dist = ladder:GetLength()
					elseif ( length > 0 ) then
						-- optimization to avoid recomputing length
						dist = length
					else
						dist = ( area:GetCenter() - fromArea:GetCenter() ):GetLength()
					end
			
					local cost = dist + fromArea:GetCostSoFar()
			
					-- check height change
					local deltaZ = fromArea:ComputeAdjacentConnectionHeightChange( area )
					if ( deltaZ >= self.loco:GetStepHeight() ) then
						if ( deltaZ >= self.loco:GetMaxJumpHeight() ) then
							-- too high to reach
							return -1
						end
			
						-- jumping is slower than flat ground
						local jumpPenalty = 5
						cost = cost + jumpPenalty * dist
					elseif ( deltaZ < -self.loco:GetDeathDropHeight() ) then
						-- too far to drop
						return -1
					end
			
					return cost
				end
			end)
			if self.loco:IsStuck() then
				self:HandleStuck()
				if (IsValid(self:GetOwner())) then
					self.nextStuckJump = CurTime() + math.Rand(1, 2)
				end
				return
			end
			self.loco:FaceTowards(self.PosGen)
			self.loco:Approach( self.PosGen, 1 )
		end

		if GetConVar('developer'):GetBool() then
			if (self.P ~= nil) then
				self.P:Draw()
			end
		end

		if (IsValid(self:GetOwner())) then
			self.loco:SetDesiredSpeed(self:GetOwner():GetWalkSpeed())
		end
	end
	self:NextThink(CurTime() + 0.3)
end