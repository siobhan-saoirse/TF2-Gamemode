
EFFECT.LifeTime = 10
EFFECT.FadeTime = 2

local GibModels = {
Model("models/weapons/w_models/w_stickybomb_gib1.mdl"),
Model("models/weapons/w_models/w_stickybomb_gib2.mdl"),
Model("models/weapons/w_models/w_stickybomb_gib3.mdl"),
Model("models/weapons/w_models/w_stickybomb_gib4.mdl"),
Model("models/weapons/w_models/w_stickybomb_gib5.mdl"),
Model("models/weapons/w_models/w_stickybomb_gib6.mdl"),
}

function EFFECT:Init(data)
	local pos = data:GetOrigin()
	local id = data:GetMagnitude()
	local mdl = GibModels[id] or GibModels[1]
	
	self:SetModel(mdl)
	self:SetPos(pos)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	--self.Entity:SetCollisionBounds(Vector(-128,-128,-128), Vector(128,128,128))
	
	self:InitPhysics()
	
	self.NextDeath = CurTime() + self.LifeTime
end

function EFFECT:InitPhysics()
	self:PhysicsInit(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid(self.WModel2) then
		phys:Wake()
		phys:SetVelocity(VectorRand() * math.Rand(200, 600))
		phys:AddAngleVelocity(Vector(math.Rand(-20,20),math.Rand(-20,20),math.Rand(-20,20)))
	end
end

function EFFECT:Think()
	if not self:GetPhysicsObject():IsValid(self.WModel2) then
		self:InitPhysics()
	end
	
	local diff = self.NextDeath - CurTime()
	
	if diff<self.FadeTime then
		local a = math.Clamp(255*diff/self.FadeTime, 0, 255)
		self:SetColor(Color(255,255,255,a))
	end
	
	return diff>0
end

function EFFECT:Render()
	self:DrawModel()
end
