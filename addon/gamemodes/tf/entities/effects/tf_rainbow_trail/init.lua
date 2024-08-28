
local RAINBOW = {
	{255,0,0},
	{0,255,0},
	{0,0,255},
	{255,255,0},
	{0,255,255},
	{255,0,255},
}

function EFFECT:Init(data)
	local pl = data:GetEntity()
	
	if not IsValid(pl) then
		return
	end
	
	--local rag = pl:GetRagdollEntity()
	local rag = pl.GeyRagdoll
	
	if not IsValid(rag) then
		return
	end
	
	self.Parent = rag
	
	self.DieTime = CurTime() + 5
end

function EFFECT:DoParticleEffects()
	local b, pos
	
	if not self.Emitter then
		self.Emitter = ParticleEmitter(self.Parent:GetPos())
	end
	
	for i=0,100 do
		b = self.Parent:TranslatePhysBoneToBone(i)
		if b<0 then break end
		
		local mat = self.Parent:GetBoneMatrix(b)
		
		if mat then
			pos = self.Parent:GetBoneMatrix(b):GetTranslation()
			
			local particle = self.Emitter:Add("particle/particle_smokegrenade", pos)
			particle:SetGravity(Vector(0,0,200))
			particle:SetVelocity(Angle(math.Rand(-90,90), math.Rand(-180,180), 0):Forward() * math.Rand(5,50) + 2*self.Parent:GetVelocity())
			particle:SetAirResistance(300)
			particle:SetDieTime(math.Rand(0.5,1.1))
			particle:SetStartSize(math.Rand(5,8))
			particle:SetEndSize(math.Rand(8,10))
			particle:SetRoll(math.Rand(150,180))
			particle:SetRollDelta(0.6*math.random(-1,1))
			
			local col = table.Random(RAINBOW)
			particle:SetColor(unpack(col))
			
			particle:SetStartAlpha(100)
			particle:SetEndAlpha(0)
		end
	end
	self.Emitter:Finish()
end

function EFFECT:Think()
	if not IsValid(self.Parent) or (CurTime()>self.DieTime) then
		return false
	end
	
	if not self.NextEmit or CurTime()>self.NextEmit then
		self:DoParticleEffects()
		self.NextEmit = CurTime() + 0.08
	end
	return true
end

function EFFECT:Render()
	
end
