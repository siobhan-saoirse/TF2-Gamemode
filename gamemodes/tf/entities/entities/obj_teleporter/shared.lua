
ENT.Base = "obj_base"
ENT.Type = "ai"  

ENT.AutomaticFrameAdvance = true

PrecacheParticleSystem("teleporter_arms_circle_red")
PrecacheParticleSystem("teleporter_red_charged_level1")
PrecacheParticleSystem("teleporter_red_charged_level2")
PrecacheParticleSystem("teleporter_red_charged_level3")
PrecacheParticleSystem("teleporter_red_entrance_level1")
PrecacheParticleSystem("teleporter_red_entrance_level2")
PrecacheParticleSystem("teleporter_red_entrance_level3")
PrecacheParticleSystem("teleporter_red_exit_level1")
PrecacheParticleSystem("teleporter_red_exit_level2")
PrecacheParticleSystem("teleporter_red_exit_level3")

PrecacheParticleSystem("teleporter_arms_circle_blue")
PrecacheParticleSystem("teleporter_blue_charged_level1")
PrecacheParticleSystem("teleporter_blue_charged_level2")
PrecacheParticleSystem("teleporter_blue_charged_level3")
PrecacheParticleSystem("teleporter_blue_entrance_level1")
PrecacheParticleSystem("teleporter_blue_entrance_level2")
PrecacheParticleSystem("teleporter_blue_entrance_level3")
PrecacheParticleSystem("teleporter_blue_exit_level1")
PrecacheParticleSystem("teleporter_blue_exit_level2")
PrecacheParticleSystem("teleporter_blue_exit_level3")

ENT.ObjectHealth = 150

ENT.Sound_Spin1 = Sound("Building_Teleporter.SpinLevel1")
ENT.Sound_Spin2 = Sound("Building_Teleporter.SpinLevel2")
ENT.Sound_Spin3 = Sound("Building_Teleporter.SpinLevel3")

ENT.CollisionBox = {Vector(-24,-24,0), Vector(24,24,12)}
ENT.BuildHull = {Vector(-28,-28,0), Vector(28,28,95)}
ENT.Sapped = false
ENT.ObjectName = "#TF_Object_Tele"

function ENT:SetupDataTables()
	self.BaseClass.SetupDataTables(self)
	self:DTVar("Entity", 2, "LinkedTeleporter")
end

function ENT:GetTargetIDSubText()
	local charge = self:GetChargePercentage()
	local link = self:GetLinkedTeleporter()
	
	if not IsValid(link) then
		return tf_lang.GetRaw("#TF_playerid_teleporter_entrance_nomatch")
	elseif charge < 0 then
		return tf_lang.GetFormatted("#TF_playerid_object_recharging", math.floor(charge * 100))
	else
		return self.BaseClass.GetTargetIDSubText(self)
	end
end

function ENT:GetTargetIDName(nolocalize)
	local name = self.ObjectName or GAMEMODE:EntityName(self)
	return tf_lang.GetFormatted("#TF_playerid_object_mode",
		tf_lang.GetRaw(self.ObjectName),
		GAMEMODE:EntityName(self:GetBuilder()),
		tf_lang.GetRaw(self:GetBuildingData().mode_name or "")
	)
end

function ENT:IsEntrance()
	return self:GetBuildMode() == 0
end

function ENT:IsExit()
	return self:GetBuildMode() == 1
end

function ENT:IsReady()
	local link = self:GetLinkedTeleporter()
	if self:IsEntrance() then
		return IsValid(link) and (self:GetChargePercentage() >= 1)
	end
end

function ENT:GetChargePercentage()
	return self.dt.BuildingInfoFloat.y
end

function ENT:SetChargePercentage(p)
	local v = self.dt.BuildingInfoFloat
	v.y = p
	self.dt.BuildingInfoFloat = v
end

function ENT:GetLinkedTeleporter()
	return self.dt.LinkedTeleporter
end

function ENT:SetLinkedTeleporter(e)
	self.dt.LinkedTeleporter = e
end