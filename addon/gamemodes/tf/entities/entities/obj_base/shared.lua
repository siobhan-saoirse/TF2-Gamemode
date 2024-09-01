
ENT.Base = "base_entity"
ENT.Type = "ai"  

ENT.AutomaticFrameAdvance = true

ENT.IsTFBuilding = true
ENT.Building = true
ENT.NumLevels = 3
ENT.ObjectHealth = 100
ENT.Upgradable = true
ENT.UpgradeCost = 200

ENT.CollisionBox = {Vector(-22,-22,0), Vector(22,22,75)}
ENT.BuildHull = {Vector(-22,-22,0), Vector(22,22,75)}
ENT.BuildDistance = 80
ENT.BuildYOffsetStand = 10
ENT.BuildYOffsetDuck = -4
ENT.BuildYRange = 120
ENT.HeightTolerancy = 10
ENT.KillCreditAsInflictor = true
ENT.SappedBy = nil
PrecacheParticleSystem("ExplosionCore_buildings")

function ENT:GetObjectHealth()
	return self.ObjectHealth
end

-- The text which should show up under the Target ID when looking at that building
function ENT:GetTargetIDSubText()
	local progress = Format("%d / %d", self:GetMetal(), self.UpgradeCost)
	local level = self:GetLevel()
	
	if level < self.NumLevels then
		return tf_lang.GetFormatted("#TF_playerid_object_upgrading_level", level, progress)
	else
		return tf_lang.GetFormatted("#TF_playerid_object_level", level, progress)
	end
end

-- The type of alert that should show up on the HUD for this entity
-- 0: none
-- 1: wrench, not pulsing (half ammo)
-- 2: wrench, pulsing red (low ammo)
-- 3: wrench, pulsing red, two beeps (damaged)
-- 4: sapper, pulsing red, repeatedly beeps (being sapped)
function ENT:HUDAlertStatus()
	if self:GetState() ~= 3 then return end
	
	if self:Health() < self:GetObjectHealth() then
		return 3
	end
	return 0
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "BuildingInfo")
	--[[
	0x0TTTLLSS
	T: Building sub-type
	L: Building level
	S: Building status
	]]
	
	self:NetworkVar("Int", 1, "BuildingInfo2")
	--[[
	0x0MMMUUUU
	M: Building mode
	U: Building upgrade status
	]]
	
	self:NetworkVar("Vector", 3, "BuildingInfoFloat")
end

function ENT:GetDeathnoticeName(nolocalize)
	local name = self.ObjectName or GAMEMODE:EntityName(self)
	
	if IsValid(self:GetBuilder()) then
		return Format("%s\1%s", name, GAMEMODE:EntityName(self:GetBuilder()))
	else
		return name
	end
end

function ENT:GetTargetIDName(nolocalize)
	local name = self.ObjectName or GAMEMODE:EntityName(self)
	return tf_lang.GetFormatted("#TF_playerid_object", tf_lang.GetRaw(self.ObjectName), GAMEMODE:EntityName(self:GetBuilder()))
end

function ENT:SetupBlue--print(blueprint, mode)
	blueprint.BuildHull = self.BuildHull
	blueprint.BuildDistance = self.BuildDistance
	--blueprint.BuildYOffset = self.BuildYOffset
	blueprint.BuildYOffsetStand = self.BuildYOffsetStand
	blueprint.BuildYOffsetDuck = self.BuildYOffsetDuck
	blueprint.BuildYRange = self.BuildYRange
	blueprint.HeightTolerancy = self.HeightTolerancy
end

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:Team()
	return self:GetNWInt("Team") or TEAM_NEUTRAL
end

function ENT:SetTeam(t)
	if CLIENT then return end
	
	local oldteam = self:GetNWInt("Team")
	self:SetNWInt("Team", t)
	
	if oldteam ~= t then
		GAMEMODE:UpdateEntityRelationship(self)
	end
end

-- The obj_anim entity attached to this building can act as a second datatable just in case we run out of datatable slots
function ENT:CallFromModelEntity(func, default, ...)
	if not self.Model and CLIENT then
		for _,v in pairs(ents.FindByClass("obj_anim")) do
			if v:GetOwner() == self then
				self.Model = v
			end
		end
	end
	
	if IsValid(self.Model) and self.Model[func] then
		return self.Model[func](self.Model, ...)
	else
		return default
	end
end

-----------------------------------------------------------

function ENT:GetBuilder()
	return self:CallFromModelEntity("GetBuilder", NULL)
end

function ENT:SetBuilder(b)
	self:CallFromModelEntity("SetBuilder", nil, b)
end

-----------------------------------------------------------

function ENT:GetBuildGroup()
	return self:CallFromModelEntity("GetBuildGroup", 0)
end

function ENT:SetBuildGroup(g)
	self:CallFromModelEntity("SetBuildGroup", nil, g)
end

-----------------------------------------------------------

function ENT:GetBuildMode()
	return self:CallFromModelEntity("GetBuildMode", 0)
end

function ENT:SetBuildMode(m)
	self:CallFromModelEntity("SetBuildMode", nil, m)
end

-----------------------------------------------------------

function ENT:GetBuildingData()
	return self:CallFromModelEntity("GetBuildingData", {})
end

-----------------------------------------------------------

function ENT:GetState()
	return bit.band(self.dt.BuildingInfo, 0x000000ff)
end

function ENT:SetState(s)
	--self.dt.BuildingInfo = (self.dt.BuildingInfo & 0x7fffff00) | (s & 0xff)
	self.dt.BuildingInfo = bit.bor(bit.band(self.dt.BuildingInfo, 0x7fffff00), bit.band(s, 0xff))
end

-----------------------------------------------------------

function ENT:GetLevel()
	return bit.rshift(bit.band(self.dt.BuildingInfo, 0x0000ff00), 8)
end

function ENT:SetLevel(l)
	self.dt.BuildingInfo = bit.bor(bit.band(self.dt.BuildingInfo, 0x7fff00ff), bit.lshift(bit.band(l, 0xff), 8))
end

function ENT:LevelUp()
	return self:SetLevel(self:GetLevel()+1)
end

-----------------------------------------------------------

function ENT:GetBuildingType()
	return bit.rshift(bit.band(self.dt.BuildingInfo, 0x0fff0000), 16)
end

function ENT:SetBuildingType(t)
	self.dt.BuildingInfo = bit.bor(bit.band(self.dt.BuildingInfo, 0x7000ffff), bit.lshift(bit.band(t, 0xfff), 16))
end

-----------------------------------------------------------

function ENT:GetMetal()
	return bit.band(self.dt.BuildingInfo2, 0x0000ffff)
end

function ENT:SetMetal(m)
	self.dt.BuildingInfo2 = bit.bor(bit.band(self.dt.BuildingInfo2, 0x7fff0000), bit.band(m, 0xffff))
end

-----------------------------------------------------------

function ENT:GetMode()
	return bit.rshift(bit.band(self.dt.BuildingInfo2, 0x0fff0000), 16)
end

function ENT:SetMode(m)
	self.dt.BuildingInfo2 = bit.bor(bit.band(self.dt.BuildingInfo2, 0x7000ffff), bit.lshift(bit.band(m, 0xfff), 16))
end

-----------------------------------------------------------

function ENT:GetBuildProgress()
	return self.dt.BuildingInfoFloat.x
end

function ENT:SetBuildProgress(f)
	local v = self.dt.BuildingInfoFloat
	v.x = f
	self.dt.BuildingInfoFloat = v
end

-----------------------------------------------------------

function ENT:ShouldCollide(ent)
	if ent == self:GetBuilder() then
		return true
	end
end