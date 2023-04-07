
ENT.Type = "anim"  
ENT.Base = "base_anim"    

function ENT:SetupDataTables()
	self:DTVar("Entity", 0, "HitEntity")
end

if SERVER then

AddCSLuaFile("shared.lua")

function ENT:SetHitEntity(ent)
	self.dt.HitEntity = ent
end

function ENT:Initialize()
	self:DrawShadow(false)
	self:SetNotSolid(true)
	
	if not IsValid(self:GetOwner()) or not self:GetOwner():IsWeapon()
	or not IsValid(self:GetOwner().Owner) or not self:GetOwner().Owner:IsPlayer() then
		self:Remove()
		return
	end
	
	--self.Enabled = true
	self:GetOwner():DeleteOnRemove(self)
	self:SetRenderMode(RENDERMODE_GLOW)
end

function ENT:Enable()
	self.Enabled = true
end

function ENT:Disable()
	self.Enabled = false
end

function ENT:Think()
	if self.Enabled and self:GetOwner().UpdateLaserDotPosition then
		self:GetOwner():UpdateLaserDotPosition(self)
		self:NextThink(CurTime())
		return true
	end
end

end

if CLIENT then

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local sniperdot_red = Material("effects/sniperdot_red")
local sniperdot_blue = Material("effects/sniperdot_blue")

function ENT:Initialize()
	self:DrawShadow(false)
end

function ENT:Draw()
	local owner = self:GetOwner()
	
	if owner.Owner:GetActiveWeapon() ~= owner then
		return
	end
	
	if owner.Owner==LocalPlayer() and not LocalPlayer():ShouldDrawLocalPlayer() then
		return
	end
	
	if not owner.ChargeTimerStart then
		return
	end
	
	if self.dt.HitEntity == LocalPlayer() and not LocalPlayer():ShouldDrawLocalPlayer() then
		return
	end
	
	local charge
	if owner.DisableSniperCharge or not owner.ChargeTimerStart then
		charge = 0
	else
		charge = owner.Time0 + (CurTime() - owner.ChargeTimerStart) * owner.Rate
		local chargetime = owner.ChargeTime / (owner.SniperChargeRateMultiplier or 1)
		
		charge = math.Clamp(100*charge/chargetime, 0, 100)
	end
	
	if owner.Owner:EntityTeam()==TEAM_BLU then
		render.SetMaterial(sniperdot_blue)
	else
		render.SetMaterial(sniperdot_red)
	end
	
	local s = 6
	render.DrawSprite(self:GetPos(), s, s, Color(255,255,255,100))
	
	s = Lerp(charge*0.01, 2, 6)
	
	if s>0 then
		render.DrawSprite(self:GetPos(), s, s, Color(255,255,255,255))
	end
end

end
