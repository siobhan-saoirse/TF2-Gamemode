-- Sticky bomb

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

ENT.Explosive = true

ENT.AutomaticFrameAdvance = true

PrecacheParticleSystem("ExplosionCore_MidAir")
PrecacheParticleSystem("ExplosionCore_MidAir_underwater")
PrecacheParticleSystem("ExplosionCore_Wall")
PrecacheParticleSystem("ExplosionCore_Wall_underwater")

function ENT:InitEffects()
end

if CLIENT then

function ENT:Initialize()
end

function ENT:Draw()
	self:DrawModel()
end

end

if SERVER then

AddCSLuaFile( "shared.lua" )

ENT.Model = Model("models/buildables/sentry3_rockets.mdl")
 
ENT.ExplosionSound = Sound("TF_BaseExplosionEffect.Sound")

ENT.BaseDamage = 100
ENT.DamageRandomize = 0
ENT.MaxDamageRampUp = 0
ENT.MaxDamageFalloff = 0
ENT.DamageModifier = 1

ENT.BaseSpeed = 1100
ENT.ExplosionRadiusInit = 150
ENT.OwnerDamage = 0

ENT.CritDamageMultiplier = 3

ENT.Size = 10

function ENT:Critical()
	return self.critical
end

function ENT:CalculateDamage(ownerpos)
	return tf_util.CalculateDamage(self, self:GetPos(), ownerpos)
end

function ENT:Initialize()
	local min = Vector(-self.Size, -self.Size, -self.Size)
	local max = Vector( self.Size,  self.Size,  self.Size)
	
	self:SetModel(self.Model)
	
	self:SetMoveType(MOVETYPE_FLY)
	self:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
	self:SetCollisionBounds(min, max)
	self:SetSolid(SOLID_BBOX)
	
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE)
	
	self:SetLocalVelocity(self:GetForward() * self.BaseSpeed)
	
	self.ai_sound = ents.Create("ai_sound")
	self.ai_sound:SetPos(self:GetPos())
	self.ai_sound:SetKeyValue("volume", "80")
	self.ai_sound:SetKeyValue("duration", "8")
	self.ai_sound:SetKeyValue("soundtype", "8")
	self.ai_sound:SetParent(self)
	self.ai_sound:Spawn()
	self.ai_sound:Activate()
	self.ai_sound:Fire("EmitAISound", "", 0.3)
	
	
	self:ResetSequence(self:LookupSequence("idle"))
	self:SetPlaybackRate(1)
	self:SetCycle(0)
	self:InitEffects()
end

function ENT:FindTarget()
	local v1, v2, dot
	v1 = self:GetForward()
	
	local max, target
	
	for _,v in pairs(ents.GetAll()) do
		if (v:IsPlayer() or v:IsNPC()) and v:Health()>0 and GAMEMODE:EntityTeam(v)~=self:GetOwner():Team() then
			v2 = (v:GetPos() - self:GetPos()):GetNormal()
			dot = v1:DotProduct(v2)
			
			if not max or dot>max then
				max, target = dot, v
			end
		end
	end
	
	self.Target = target
end

function ENT:Think()
--[[
	if not self.Homing then
		self:SetAngles(self:GetVelocity():Angle())
		return
	end
	
	if not IsValid(self.Target) or self.Target:Health()<=0 then
		if (not self.NextTargetSearch or CurTime()>self.NextTargetSearch) then
			self:FindTarget()
			self.NextTargetSearch = CurTime() + 2
		end
		self:SetAngles(self:GetVelocity():Angle())
		return
	end]]
	
	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	self.ai_sound:Remove()
end

function ENT:DoExplosion(ent)
	self.Touch = nil
	
	local effect, angle

	--[[if self.FastRocket then
		self:EmitSound(self.ExplosionSoundFast)
	else]]
		sound.Play(self.ExplosionSound, self:GetPos())
	--end
	
	local flags = 0
	
	if ent:IsWorld() then
		local tr = util.QuickTrace(self:GetPos(), self:GetForward()*10, self)
		if tr.HitWorld then
			flags = bit.bor(flags, 2)
			angle = tr.HitNormal:Angle():Up():Angle()
		else
			angle = self:GetAngles()
		end
	else
		angle = self:GetAngles()
	end
	
	if self:WaterLevel()>0 then
		flags = bit.bor(flags, 1)
	end
	
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetAngles(angle)
		effectdata:SetAttachment(flags)
	util.Effect("tf_explosion", effectdata, true, true)
	
	local owner = self:GetOwner()
	if not owner or not owner:IsValid(self.WModel2) then owner = self end
	
	--local damage = self:CalculateDamage(owner:GetPos()+Vector(0,0,1))
	local range = self.ExplosionRadiusInit
	if self.ExplosionRadiusMultiplier and self.ExplosionRadiusMultiplier>1 then
		range = range * self.ExplosionRadiusMultiplier
	end
	--[[if self.FastRocket then
		range = range * 0.4
	end]]
	
	--self.ResultDamage = damage
	self:GetOwner()Damage = 0.8
	
	util.BlastDamage(self.Launcher or self, owner, self:GetPos(), range, 100)
	
	self:Remove()
end

function ENT:Touch(ent)
	if ent:IsSolid() then
		self:DoExplosion(ent)
	end
end

end
