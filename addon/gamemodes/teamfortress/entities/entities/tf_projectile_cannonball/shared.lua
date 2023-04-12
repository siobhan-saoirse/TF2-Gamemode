
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

ENT.Explosive = true

if CLIENT then

function ENT:Draw()
	self:DrawModel()
end

end

if SERVER then

AddCSLuaFile( "shared.lua" )

ENT.Model = "models/weapons/w_models/w_cannonball.mdl"
ENT.Model2 = "models/weapons/w_models/w_stickybomb2.mdl"

ENT.ExplosionSound = Sound("Weapon_LooseCannon.Explode")
ENT.BounceSound = Sound("Weapon_Grenade_Pipebomb.Bounce")

ENT.BaseDamage = 60
ENT.DamageRandomize = 0.3
ENT.MaxDamageRampUp = 0.3
ENT.MaxDamageFalloff = 0
ENT.DamageModifier = 1
ENT.ExplodeTime = 1

--ENT.BaseSpeed = 1100
ENT.ExplosionRadiusInit = 180

ENT.CritDamageMultiplier = 2.8

ENT.Mass = 30

local BlastForceMultiplier = 16
local BlastForceToVelocityMultiplier = (0.015 / BlastForceMultiplier)

function ENT:Critical()
	return self.critical
end

function ENT:CalculateDamage(ownerpos)
	return tf_util.CalculateDamage(self, self:GetPos(), ownerpos)
end

function ENT:GetRocketJumpForce(owner, dmginfo)
	local ang = dmginfo:GetDamageForce():Angle()
	local force = dmginfo:GetDamageForce():Length() * BlastForceToVelocityMultiplier
	ang.p = math.Clamp(ang.p, -70, -89)
	
	return ang:Forward() * force
end

function ENT:Reflect(pl, weapon, dir)
	
end

function ENT:GetRealPos()
	if self.ExplosiveHat then
		return self:GetPos() + 81*self:GetUp()
	else
		return self:GetPos()
	end
end

function ENT:Initialize()
	if self:GetOwner().TempAttributes.ProjectileModelModifier == 1 then
		self.ExplosiveHat = true
		self.BouncesLeft = 1
		self:SetModel("models/player/items/soldier/soldier_shako.mdl")
		self:PhysicsInit(SOLID_VPHYSICS)
		self.BounceSound = "Flesh.ImpactSoft"
		self:SetPos(self:GetPos() - 81 * self:GetUp())
	elseif self.GrenadeMode==-1 then
		self:SetModel(self.Model)
		self:SetNoDraw(true)
		self:DrawShadow(false)
		self:SetNotSolid(true)
		self:DoExplosion()
		return
	elseif self.GrenadeMode==1 then
		self.BouncesLeft = 2
		self:SetModel(self.Model2)
		self:PhysicsInitSphere(8, "metal_bouncy")
	else
		self.BouncesLeft = 1
		self:SetModel(self.Model)
		self:PhysicsInit(SOLID_VPHYSICS)
	end
	
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetHealth(1)
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)

	if self.GrenadeMode==1 then
		self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
	else
		self:SetMoveCollide(MOVECOLLIDE_FLY_SLIDE)
	end
	
	if GAMEMODE:EntityTeam(self:GetOwner()) == TEAM_BLU then
		if self.GrenadeMode==1 then
			self:SetMaterial("models/weapons/w_stickybomb/w_stickybomb2_blue")
		else
			self:SetSkin(1)
		end
	elseif GAMEMODE:EntityTeam(self:GetOwner()) == TF_TEAM_PVE_INVADERS then
		if self.GrenadeMode==1 then
			self:SetMaterial("models/weapons/w_stickybomb/w_stickybomb2_blue")
		else
			self:SetSkin(1)
		end
	end
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid(self.WModel2) then
		phys:Wake()
		if self.GrenadeMode==1 then
			self.Bounciness = 1
			phys:SetMass(self.Mass * 2)
		else
			phys:SetMass(self.Mass)
		end
		--phys:EnableDrag(false)
	end
	
	self.ai_sound = ents.Create("ai_sound")
	self.ai_sound:SetPos(self:GetRealPos())
	self.ai_sound:SetKeyValue("volume", "80")
	self.ai_sound:SetKeyValue("duration", "8")
	self.ai_sound:SetKeyValue("soundtype", "8")
	self.ai_sound:SetParent(self)
	self.ai_sound:Spawn()
	self.ai_sound:Activate()
	self.ai_sound:Fire("EmitAISound", "", 0.3)
	
	self.NextExplode = CurTime() + self.ExplodeTime
	
	local effect = ParticleSuffix(GAMEMODE:EntityTeam(self:GetOwner()))
	
	self.particle_timer = ents.Create("info_particle_system")
	self.particle_timer:SetPos(self:GetRealPos())
	self.particle_timer:SetParent(self)
	self.particle_timer:SetKeyValue("effect_name","pipebomb_timer_" .. effect)
	self.particle_timer:SetKeyValue("start_active", "1")
	self.particle_timer:Spawn()
	self.particle_timer:Activate()
	
	self.particle_trail = ents.Create("info_particle_system")
	self.particle_trail:SetPos(self:GetRealPos())
	self.particle_trail:SetParent(self)
	self.particle_trail:SetKeyValue("effect_name","pipebombtrail_" .. effect)
	self.particle_trail:SetKeyValue("start_active", "1")
	self.particle_trail:Spawn()
	self.particle_trail:Activate()
	
	if self.critical then
		self.particle_crit = ents.Create("info_particle_system")
		self.particle_crit:SetPos(self:GetRealPos())
		self.particle_crit:SetParent(self)
		self.particle_crit:SetKeyValue("effect_name","critical_pipe_" .. effect)
		self.particle_crit:SetKeyValue("start_active", "1")
		self.particle_crit:Spawn()
		self.particle_crit:Activate()
	end
end

function ENT:OnRemove()
	if self.ai_sound then self.ai_sound:Remove() end
	if self.particle_timer and self.particle_timer:IsValid(self.WModel2) then self.particle_timer:Remove() end
	if self.particle_trail and self.particle_trail:IsValid(self.WModel2) then self.particle_trail:Remove() end
	if self.particle_crit and self.particle_crit:IsValid(self.WModel2) then self.particle_crit:Remove() end
end

function ENT:Think()
	if self.NextExplode and CurTime()>=self.NextExplode then
		self:DoExplosion()
		self.NextExplode = nil
	end
end

function ENT:GravGunPunt( ply )
	self:SetOwner(ply)
	self:GetPhysicsObject():EnableMotion( true )
	return true
end
 
function ENT:GravGunPickupAllowed( ply )
	self:GetPhysicsObject():EnableMotion( true )
	return true
end

function ENT:DoExplosion()
	self.PhysicsCollide = nil
	
	self:EmitSound(self.ExplosionSound, 100, 100)
	
	local flags = 0
	
	if self:WaterLevel()>0 then
		flags = bit.bor(flags, 1)
	end
	
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetRealPos())
		effectdata:SetAngles(self:GetAngles())
		effectdata:SetAttachment(flags)
	util.Effect("tf_explosion", effectdata, true, true)
	
	local owner = self:GetOwner()
	if not owner or not owner:IsValid(self.WModel2) then owner = self end
	
	local range, damage
	
	if self.GrenadeMode==-1 then
		range = self.ExplosionRadiusInit
	elseif self.BouncesLeft<=0 then
		range = self.ExplosionRadiusInit
		
		self.BaseDamage = 64
		self.DamageRandomize = 0
		self:GetOwner()Damage = 1
	else
		range = self.ExplosionRadiusInit * 0.7
		
		self.BaseDamage = 100
		self.DamageRandomize = 0.05
		self:GetOwner()Damage = 0.6
	end
	
	--self.ResultDamage = self.BaseDamage
	
	--util.BlastDamage(self, owner, self:GetPos(), range, self.BaseDamage)
	util.BlastDamage(self, owner, self:GetRealPos(), range, 100)
	for k,v in ipairs(ents.FindInSphere(self:GetRealPos(), range)) do
		if v:IsTFPlayer() and !v:IsFriendly(self:GetOwner()) and !v:OnGround() and v.HitByCannonball then
			v.HitByCannonball = false
			ParticleEffectAttach("doubledonk_text", PATTACH_POINT_FOLLOW, v, v:LookupAttachment("head"))
			v:EmitSound("player/doubledonk.wav", 95)
			local dir = self:GetOwner():GetAimVector()
			local dir2 = dir:Angle()
			dir2.p = math.Clamp(dir2.p - 45,-90,90)
			dir2 = dir2:Forward()
			
			v:SetGroundEntity(NULL)
			v:SetLocalVelocity(dir2 * 400)
			v:SetThrownByExplosion(true)
		end
	end
	self:SetNoDraw(true)
	self:SetNotSolid(true)
	self:Fire("kill", "", 0.01)
end

function ENT:Break()
	if self.Dead then return end
	
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetRealPos())
		effectdata:SetNormal(Vector(0,0,1))
		effectdata:SetMagnitude(2)
		effectdata:SetScale(1)
		effectdata:SetRadius(5)
	util.Effect("Sparks", effectdata)
	
	self.Dead = true
	self:SetNotSolid(true)
	self:SetNoDraw(true)
	self:Fire("kill", "", 0.01)
end

function ENT:PhysicsCollide(data, physobj)
	if data.HitEntity and data.HitEntity:IsValid(self.WModel2) and (data.HitEntity:IsNPC() or data.HitEntity:IsPlayer()) and data.HitEntity:Health()>0 and !data.HitEntity:IsFriendly(self:GetOwner()) then
		local range = self.ExplosionRadiusInit
		util.BlastDamage(self, self:GetOwner(), self:GetRealPos(), range, 20)
		self:EmitSound("weapons/loose_cannon_ball_impact.wav", 95)
		data.HitEntity.HitByCannonball = true
		data.HitEntity.readyToDonk = true
			local dir = self:GetOwner():GetAimVector()
			local dir2 = dir:Angle()
			dir2.p = math.Clamp(dir2.p - 45,-90,90)
			dir2 = dir2:Forward()
			
			data.HitEntity:SetGroundEntity(NULL)
			data.HitEntity:SetLocalVelocity(dir2 * 400)
			data.HitEntity:SetThrownByExplosion(true)
	else
		if self.DetonateMode == 2 then
			self:Break()
			return
		end
		
		if data.Speed > 50 and data.DeltaTime > 0.2 then
			self:EmitSound(self.BounceSound, 100, 100)
		end
		
		self.BouncesLeft = self.BouncesLeft - 1
		
		if self.Bounciness then
			local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
			local NewVelocity = physobj:GetVelocity()
			NewVelocity:Normalize()
			
			LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
			
			local TargetVelocity = NewVelocity * LastSpeed * self.Bounciness
			
			physobj:SetVelocity( TargetVelocity )
		end
	end
end

end
