
ENT.Base = "base_entity"
ENT.Type = "anim"  

ENT.AutomaticFrameAdvance = true
ENT.RotationSpeed = 150

ENT.BuildHull = {Vector(-28,-28,0), Vector(28,28,94)}
ENT.BuildDistance = 80
ENT.BuildYOffset = 30
ENT.BuildYOffsetDuck = 30
ENT.BuildYOffsetStand = 30
ENT.BuildYRange = 120
ENT.HeightTolerancy = 10
ENT.ModelScale = 1

function ENT:SetupDataTables()
	self:DTVar("Bool", 0, "Allowed")
	self:DTVar("Int", 0, "Rotation")
	self:DTVar("Float", 0, "Scale")
	
	if SERVER then
		self.dt.Allowed = true
	end
end

function ENT:RotateBlueprint()
	self.dt.Rotation = (self.dt.Rotation + 1) % 4
end

function ENT:CalcPos(pl)
	if not self.Building then
		self.Building = self:GetOwner():GetBuilding()
		if not self.Building then return end
		
		local tab = scripted_ents.Get(self.Building.class_name)
		if tab then
			if tab.SetupBlueprint then
				tab:SetupBlueprint(self, self:GetOwner():GetBuildMode())
			end
		end
		
		--[[
		if CLIENT then
			self.Model:SetModelScale(Vector(self.ModelScale, self.ModelScake, self.ModelScale))
			self.Model:SetupBones()
		end]]
	end
	
	--[[
	local entdata = scripted_ents.Get(obj.class_name)
	if not entdata then
		self:Remove() return
	end]]
	
	local ang = pl:EyeAngles()
	ang.p = 0
	local dir = ang:Forward()
	
	local origin
	
	if pl:Crouching() then
		origin = pl:GetPos() + self.BuildYOffsetDuck * vector_up
	else
		origin = pl:GetPos() + self.BuildYOffsetStand * vector_up
	end
	
	local pos = origin + self.BuildDistance * dir
	local tr = util.TraceHull{
		start = pos + self.BuildYOffset * vector_up,
		endpos = pos - self.BuildYRange * vector_up,
		mins = self.BuildHull[1],
		maxs = self.BuildHull[2],
		filter = self,
	}
	
	if tr.Hit and not tr.StartSolid then
		pos = tr.HitPos
		local p

		p = pos + Vector(self.BuildHull[1].x, self.BuildHull[1].y, 1)
		tr = util.TraceLine{
			start = p, endpos = p - self.HeightTolerancy * vector_up,
			filter = self,
		}
		if not tr.Hit then return pos, ang, false end
		
		p = pos + Vector(self.BuildHull[1].x, self.BuildHull[2].y, 1)
		tr = util.TraceLine{
			start = p, endpos = p - self.HeightTolerancy * vector_up,
			filter = self,
		}
		if not tr.Hit then return pos, ang, false end
		
		p = pos + Vector(self.BuildHull[2].x, self.BuildHull[1].y, 1)
		tr = util.TraceLine{
			start = p, endpos = p - self.HeightTolerancy * vector_up,
			filter = self,
		}
		if not tr.Hit then return pos, ang, false end
		
		p = pos + Vector(self.BuildHull[2].x, self.BuildHull[2].y, 1)
		tr = util.TraceLine{
			start = p, endpos = p - self.HeightTolerancy * vector_up,
			filter = self,
		}
		if not tr.Hit then return pos, ang, false end
		
		return pos, ang, true
	end
	
	return pos, ang, false
end
