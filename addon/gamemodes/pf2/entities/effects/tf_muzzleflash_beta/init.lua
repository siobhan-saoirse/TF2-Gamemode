
local EFFECT = {}


EFFECT.LifeTime = 0.15

EFFECT.Model = "models/effects/sentry1_muzzle/sentry1_muzzle.mdl"

EFFECT.SineStart = 70
EFFECT.SineEnd = 180

EFFECT.RenderGroup = RENDERGROUP_BOTH

function EFFECT:Init(data)
	local ent
	if LocalPlayer().IsThirdperson then
		ent = data:GetEntity()
	else
		ent = data:GetEntity().CModel
	end

	if !IsValid(ent) then return end
	
	self.Entity:SetModel(self.Model)
	self.Entity:SetPos(ent:GetPos())
	self.Entity:SetAngles(ent:GetAngles())
	self.Entity:SetColor(Color(255,255,255,255))
	self.Entity:SetRenderMode(RENDERMODE_GLOW)
	
	self.Parent = ent
	self.NextDeath = CurTime() + self.LifeTime
end

function EFFECT:Think()
	if IsValid(self.Parent) and self.NextDeath then
		return CurTime()<self.NextDeath
	end
	return false
end

function EFFECT:Render()
	local diff = 1 - ((self.NextDeath - CurTime()) / self.LifeTime)
	local size = math.sin(math.rad(Lerp(diff, self.SineStart, self.SineEnd)))
	
	local att = self.Parent:LookupAttachment("muzzle")
	PrintTable(self.Parent:GetAttachments())
	if att<0 then return end
	
	att = self.Parent:GetAttachment(att)
	
	self.Entity:SetModelScale(size)
	self.Entity:SetPos(att.Pos)
	self.Entity:SetAngles(att.Ang)
	
	render.UpdateRefractTexture()
	self.Entity:DrawModel()
end