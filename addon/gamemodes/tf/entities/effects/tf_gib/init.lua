
EFFECT.LifeTime = 10
EFFECT.FadeTime = 2

local FleshGibs = {
[GIB_LEFTLEG]	= true,
[GIB_RIGHTLEG]	= true,
[GIB_LEFTARM]	= true,
[GIB_RIGHTARM]	= true,
[GIB_TORSO]		= true,
[GIB_TORSO2]	= true,
[GIB_HEAD]		= true,
[GIB_ORGAN]		= true,
}

function EFFECT:Init(data)
	local pl = data:GetEntity()
	local id = data:GetMagnitude()
	local pos = data:GetOrigin()
	local ang = data:GetAngles()
	local force = data:GetRadius()
	local dir = data:GetNormal()
	
	local hat
	local mdl
	
	if pl.IsTFWearableItem then
		hat = pl
		pl = hat:GetOwner()
	end
	
	if hat then
		mdl = hat.Model
		self.GibType = GIB_HAT
	end
	
	if not mdl then
		mdl = HumanGibs[id]
		self.GibType = GAMEMODE.GibTypeTable[id] or GIB_UNKNOWN
	end
	
	--Msg("gib : "..mdl.."\n")
	if (self.GibType == GIB_HEAD) then
		pl.HeadDeathEntity = self
	end
	self.GibOwner = pl
	
	self:SetModel(mdl)
	self:SetPos(pos)
	self:SetAngles(ang)
	
	if IsValid(pl) then
		gamemode.Call("SetupPlayerGib", pl, self, self.GibType)
	end
	
	self.InitialColor = self:GetColor()
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	--self:SetCollisionBounds(Vector(-128,-128,-128), Vector(128,128,128))
	
	if FleshGibs[self.GibType] and pl:GetNWBool("ShouldDropBurningRagdoll") then
		ParticleEffectAttach("burningplayer_flyingbits", PATTACH_ABSORIGIN_FOLLOW, self, 0)
	end
	
	self.ItemTint = 0
	if hat and self.GibType == GIB_HAT then
		--hat:SetupSkinAndBodygroups(self)
		hat.InitVisuals(self, pl, hat:GetVisuals())
		if hat.GetItemTint then
			self.ItemTint = hat:GetItemTint()
			self:CopyVisualOverrides(hat)
		end
	else
		if pl:EntityTeam()==TEAM_BLU then
			self:SetSkin(1)
		else
			self:SetSkin(0)
		end
	end
	
	self.Dir = dir
	self.Force = force
	self:InitPhysics()
	
	self.NextDeath = CurTime() + self.LifeTime
end

function EFFECT:CheckPhysics()
	if not self:GetPhysicsObject():IsValid(self.WModel2) then
		self:InitPhysics()
		return
	end
	
	if self.LastPos then
		if self:GetPhysicsObject():GetPos() == self.LastPos and self:GetVelocity() ~= vector_origin then
			self:InitPhysics()
		end
	end
	self.LastPos = self:GetPhysicsObject():GetPos()
end

function EFFECT:InitPhysics()
	self:PhysicsInit(SOLID_VPHYSICS)
	
	local phys = self:GetPhysicsObject()
	if phys and phys:IsValid(self.WModel2) then
		phys:Wake()
		phys:SetVelocity(self.Dir * math.Rand(200, 300) + Angle(0, math.Rand(-180, 180), 0):Forward() * math.Rand(0, 50) * self.Force)
		phys:AddAngleVelocity(Vector(math.Rand(-200,200),math.Rand(-200,200),math.Rand(-200,200)))
	end
end

function EFFECT:Think()
	self:CheckPhysics()
	if self.NextDeath == nil then return end
	local diff = self.NextDeath - CurTime()
	
	if diff<self.FadeTime then
		local a = math.Clamp(255*diff/self.FadeTime, 0, self.InitialColor.a)
		self:SetColor(Color(self.InitialColor.r,self.InitialColor.g,self.InitialColor.b,a))
	end
	
	return diff>0
end

function EFFECT:Render()
	if (file.Exists(self:GetModel(),"GAME")) then
		self:StartVisualOverrides()
		self:StartItemTint(self.ItemTint)
		self:DrawModel()
		self:EndItemTint()
		self:EndVisualOverrides()
	end
end
