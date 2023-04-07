function EFFECT:Init(data)
	local pos = data:GetOrigin()
	
	local glowEmitter = ParticleEmitter(pos)
	--local particle = glowEmitter:Add("particle/Particle_Glow_01_Additive", pos)
	local particle = glowEmitter:Add("particle/fire", pos)
	particle:SetVelocity(Vector(0,0,0))
	particle:SetDieTime(math.Rand(1.4,1.6))
	particle:SetStartSize(math.Rand(14,18))
	particle:SetEndSize(0)
	particle:SetColor(255,255,255,255)
	particle:SetStartAlpha(255)
	particle:SetEndAlpha(255)
	
	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetNormal(Vector(0,0,1))
		effectdata:SetMagnitude(2)
		effectdata:SetScale(1)
		effectdata:SetRadius(1)
	util.Effect("Sparks", effectdata)
	
	for i=1,6 do
		effectdata = EffectData()
			effectdata:SetOrigin(pos)
			effectdata:SetMagnitude(i)
		util.Effect("tf_stickybomb_gib", effectdata)
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end
