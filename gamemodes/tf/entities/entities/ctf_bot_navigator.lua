-- taken from https://gmod.facepunch.com/f/gmodaddon/jgtl/Nextbot-Pathfinding-for-Players/1/

if SERVER then AddCSLuaFile() end

ENT.Type = "point"

function ENT:Initialize()
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

function ENT:OnInjured()
	return false
end

function ENT:OnKilled()
	return false
end


function ENT:FindChaseSpots( tbl )

	local tbl = tbl or {}

	tbl.pos			= tbl.pos			or self:GetOwner():WorldSpaceCenter()
	tbl.radius		= tbl.radius		or 1000
	tbl.stepdown	= tbl.stepdown		or 20
	tbl.stepup		= tbl.stepup		or 20
	tbl.type		= tbl.type			or 'hiding'

	-- Use a path to find the length
	local path = Path( "Chase" )

	-- Find a bunch of areas within this distance
	local areas = navmesh.Find( tbl.pos, tbl.radius, tbl.stepdown, tbl.stepup )

	local found = {}

	-- In each area
	for _, area in ipairs( areas ) do

		-- get the spots
		local spots

		if ( tbl.type == 'hiding' ) then 
			spots = area:GetHidingSpots(1)
		else
			spots = area:GetHidingSpots(8)
		end
		for k, vec in ipairs( spots ) do

			-- Work out the length, and add them to a table
			path:Invalidate()
			if (IsValid(self:GetOwner())) then
				if (self:GetOwner().TargetEnt != nil) then
					path:Chase( self:GetOwner(), self:GetOwner().TargetEnt ) -- TODO: This is bullshit - it's using 'self.pos' not tbl.pos
				else
					path:Compute( self:GetOwner(), tbl.pos ) -- TODO: This is bullshit - it's using 'self.pos' not tbl.pos
				end
			end

			table.insert( found, { vector = vec, distance = path:GetLength() } )

		end

	end

	return found

end

--
-- Name: NextBot:FindSpot
-- Desc: Like FindSpots but only returns a vector
-- Arg1: string|type|Either "random", "near", "far"
-- Arg2: table|options|A table containing a bunch of tweakable options. See the function definition for more details
-- Ret1: vector|If it finds a spot it will return a vector. If not it will return nil.
--
function ENT:FindSpot( type, options )

	local spots = self:FindChaseSpots( options )
	if ( !spots || #spots == 0 ) then return end

	if ( type == "near" ) then

		table.SortByMember( spots, "distance", true )
		return spots[1].vector

	end

	if ( type == "far" ) then

		table.SortByMember( spots, "distance", false )
		return spots[1].vector

	end

	-- random
	return spots[ math.random( 1, #spots ) ].vector

end