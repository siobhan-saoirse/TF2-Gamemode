
EFFECT.LifeTime = 10
EFFECT.FadeTime = 2

EFFECT.Models = {
	Model("models/weapons/w_models/w_syringe_proj.mdl"),
	Model("models/weapons/c_models/c_leechgun/c_leech_proj.mdl"),
	Model("models/weapons/w_models/w_syringe.mdl"),
}

function EFFECT:Init(data)
	local pos, ang, skin, stype = data:GetOrigin(), data:GetAngles(), data:GetMagnitude(), data:GetAttachment()
	
	self.Entity:SetModel(self.Models[stype+1] or self.Models[1])
	if stype==2 then
		self.Entity:SetPos(pos - 18 * ang:Up())
	elseif stype==1 then
		self.Entity:SetPos(pos - 7 * ang:Forward())
	else
		self.Entity:SetPos(pos)
	end
	
	self.Entity:SetAngles(ang)
	self.Entity:SetSkin(skin)
	
	self.NextDeath = CurTime() + self.LifeTime
end

function EFFECT:Think()
	local diff = self.NextDeath - CurTime()
	
	if diff<self.FadeTime then
		local a = math.Clamp(255*diff/self.FadeTime, 0, 255)
		self.Entity:SetColor(Color(255,255,255,a))
	end
	
	return diff>0
end

function EFFECT:Render()
	self.Entity:DrawModel()
end
