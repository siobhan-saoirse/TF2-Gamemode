ENT.PrintName		= "Sentry Gun"
ENT.Author			= "Seamusmario"
ENT.Category = "Team Fortress 2"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Base	= "obj_base"
ENT.Type = "ai"  

ENT.AutomaticFrameAdvance = true

ENT.ObjectHealth = 150
ENT.Range = 1100

ENT.CollisionBox = {Vector(-24,-24,0), Vector(24,24,66)}
ENT.BuildHull = {Vector(-24,-24,0), Vector(24,24,86)}
ENT.Sapped = false
ENT.ObjectName = "#TF_Object_Sentry"

function ENT:GetObjectHealth()
	local t = self:GetBuildingType()
	local l = self:GetLevel()
	
	local m = 1
	if t == 1 then
		m = 0.666666
	end
	
	if l==2 then
		return math.ceil(180 * m)
	elseif l==3 then
		return math.ceil(216 * m)
	else
		return math.ceil(150 * m)
	end
end

function ENT:GetTargetIDSubText()
	local progress = Format("%d / %d", self:GetMetal(), self.UpgradeCost)
	local level = self:GetLevel()
	
	if level < self.NumLevels then
		return tf_lang.GetFormatted("#TF_playerid_object_upgrading", progress)
	else
		return ""
	end
end

function ENT:HUDAlertStatus()
	if self:GetState() ~= 3 then return end
	
	local p
	if self:GetLevel() == 3 then
		p = math.min(self:GetAmmo1Percentage(), self:GetAmmo2Percentage())
	else
		p = self:GetAmmo1Percentage()
	end
	
	if self:Health() < self:GetObjectHealth() then
		return 3
	elseif p < 0.25 then
		return 2
	elseif p < 0.5 then
		return 1
	end
	
	return 0
end

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:SetupDataTables()
	self.BaseClass.SetupDataTables(self)
	self:DTVar("Int", 2, "KillsInfo")
	--[[
	0x00AAAKKK
	KKK: Kills
	AAA: Assists
	]]
end

-----------------------------------------------------------

function ENT:GetKills()
	return bit.band(self.dt.KillsInfo, 0x00000fff)
end

function ENT:SetKills(k)
	self.dt.KillsInfo = bit.bor(bit.band(self.dt.KillsInfo, 0x7ffff000), bit.band(k, 0xfff))
end

function ENT:AddKills(k)
	self:SetKills(self:GetKills() + k)
end

-----------------------------------------------------------

function ENT:GetAssists()
	return bit.rshift(bit.band(self.dt.KillsInfo, 0x00fff000), 12)
end

function ENT:SetAssists(a)
	self.dt.KillsInfo = bit.bor(bit.band(self.dt.KillsInfo, 0x7f000fff), bit.lshift(bit.band(a, 0xfff), 12))
end

function ENT:AddAssists(a)
	self:SetAssists(self:GetAssists() + a)
end

-----------------------------------------------------------

function ENT:GetAmmo1Percentage()
	return self.dt.BuildingInfoFloat.y
end

function ENT:SetAmmo1Percentage(p)
	local v = self.dt.BuildingInfoFloat
	v.y = p
	self.dt.BuildingInfoFloat = v
end

-----------------------------------------------------------

function ENT:GetAmmo2Percentage()
	return self.dt.BuildingInfoFloat.z
end

function ENT:SetAmmo2Percentage(p)
	local v = self.dt.BuildingInfoFloat
	v.z = p
	self.dt.BuildingInfoFloat = v
end

-----------------------------------------------------------

PrecacheParticleSystem("bullet_tracer01_red")
PrecacheParticleSystem("bullet_tracer01_blue")
PrecacheParticleSystem("muzzle_sentry")
PrecacheParticleSystem("muzzle_sentry2")

PrecacheParticleSystem("cart_flashinglight_red")
PrecacheParticleSystem("cart_flashinglight")