
ENT.Base = "obj_base"
ENT.Type = "ai"  
ENT.PrintName = "Dispenser"
ENT.Author			= "Seamusmario"
ENT.Category = "Team Fortress 2"
ENT.Spawnable = true

ENT.AutomaticFrameAdvance = true
ENT.Sapped = false
ENT.ObjectHealth = 150
ENT.MaxMetal = 400
ENT.IsEnabled = 0
ENT.CollisionBox = {Vector(-24,-24,0), Vector(24,24,55)}
ENT.BuildHull = {Vector(-24,-24,0), Vector(24,24,82)}
ENT.Sound_Idle = Sound("Building_Dispenser.Idle")
ENT.Sound_Heal = Sound("Building_Dispenser.Heal")
ENT.ObjectName = "#TF_Object_Dispenser"

function ENT:SetAutomaticFrameAdvance(bUsingAnim)
	self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:SetMetalAmount(m)
	--self:SetNWInt("Metal", m)
	self.MetalAmount = m
	self:SetAmmoPercentage(m / self.MaxMetal)
end

function ENT:GetMetalAmount()
	return self.MetalAmount
	--return self:GetNWInt("Metal") or 0
end

function ENT:AddMetalAmount(m)
	local a = self:GetMetalAmount()
	if a+m>self.MaxMetal then
		self:SetMetalAmount(self.MaxMetal)
		return self.MaxMetal - a
	elseif a+m<0 then
		self:SetMetalAmount(0)
		return a
	else
		self:SetMetalAmount(a+m)
		return m
	end
end

function ENT:GetAmmoPercentage()
	return self.dt.BuildingInfoFloat.y
end

function ENT:SetAmmoPercentage(p)
	local v = self.dt.BuildingInfoFloat
	v.y = p
	self.dt.BuildingInfoFloat = v
end

if CLIENT then
function ENT:Think()
	if !self.Idle_Sound and self:GetState()==3 || self.Idle_Sound and !self.Idle_Sound:IsPlaying() and self:GetState()==3 then
		self.Idle_Sound = CreateSound(self, self.Sound_Idle)
		self.Idle_Sound:Play()
	end
end

function ENT:OnRemove()

	
	if self.Idle_Sound then
		self.Idle_Sound:Stop()
	end
	
	if self.Heal_Sound then
		self.Heal_Sound:Stop()
	end

end

end