
--[[
Explosion flags:
1  Underwater
2  Wall explosion
4  Jarate
8  Clientside sound
16 Mad Milk
32
64
]]

local ExplosionSounds = {
")weapons/pipe_bomb1.wav",
")weapons/pipe_bomb2.wav",
")weapons/pipe_bomb3.wav",
}

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local ang = data:GetAngles()
	local flags = data:GetAttachment()
	
	local effect
	
	if bit.band(flags, 16) > 0 then
		effect = "peejar_impact_milk"
	elseif bit.band(flags, 4) > 0 then
		if bit.band(flags, 1) > 0 then
			effect = "peejar_impact_small"
		else
			effect = "peejar_impact"
		end
	else
		effect = "ExplosionCore"
		if bit.band(flags, 2) > 0 then
			effect = effect.."_Wall"
		else
			effect = effect.."_MidAir"
		end
		
		if bit.band(flags, 1) > 0 then
			effect = effect.."_underwater"
		end
	end
	
	self:SetPos(pos)
	local effectdata = EffectData()
	effectdata:SetOrigin( pos )
	util.Effect( "HelicopterMegaBomb", effectdata )
	if bit.band(flags, 8) > 0 then
		self.NextExplosionSound = CurTime() + 0.05
	end
end

function EFFECT:Think()
	if self.NextExplosionSound then
		if CurTime()>self.NextExplosionSound then
			local mindist, best
			for _,v in pairs(ents.GetAll()) do
				if v.NextExplosionSound then
					local d = EyePos():Distance(v:GetPos())
					if not mindist or d<mindist then
						mindist, best = d, v
					end
					v.NextExplosionSound = nil
				end
			end
			
			if best then
				sound.Play(table.Random(ExplosionSounds), best:GetPos(), 95, 100)
			end
			
			return false
		end
		return true
	end
	
	return false
end

function EFFECT:Render()
end
