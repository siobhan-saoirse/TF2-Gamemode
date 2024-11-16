
local Gibs = {GIB_HEAD, GIB_HEADGEAR1, GIB_HEADGEAR2}

function EFFECT:Init(data)
	local pl = data:GetEntity()
	local c = pl:GetPlayerClassTable()
	
	if not c or not c.Gibs then return end
	
	local exclude = {}
	for _,h in pairs(ents.FindByClass("tf_hat")) do
		if h:GetOwner()==pl then
			local hat = h:GetHatData()
			if hat then
				for _,v in ipairs(hat.disabledgibs or {}) do
					exclude[v] = true
				end
				
				if not(hat.nomodel or hat.nodrop) then
					local effectdata = EffectData()
						effectdata:SetEntity(h)
						effectdata:SetMagnitude(0)
						effectdata:SetOrigin(pl:GetPos())
						effectdata:SetAngles(pl:GetAngles())
						effectdata:SetNormal(Vector(0,0,1))
					util.Effect("tf_gib", effectdata)
				end
			end
		end
	end
	
	for _,k in ipairs(Gibs) do
		if not exclude[k] then
			local v = c.Gibs[k]
			if v then
				local effectdata = EffectData()
					effectdata:SetEntity(pl)
					effectdata:SetMagnitude(v)
					effectdata:SetOrigin(pl:GetPos())
					effectdata:SetAngles(pl:GetAngles())
					effectdata:SetNormal(Vector(0,0,1))
					effectdata:SetRadius(1)
					util.Effect("tf_gib", effectdata)
			end
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end