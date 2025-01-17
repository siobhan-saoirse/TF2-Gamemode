
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

ENT.Model = "models/weapons/c_models/c_sd_cleaver/c_sd_cleaver.mdl"
ENT.Model2 = "models/weapons/w_models/w_stickybomb2.mdl"

ENT.ExplosionSound2 = Sound("Cleaver.HitFlesh")
ENT.ExplosionSound = Sound("Cleaver.HitFlesh")
ENT.BounceSound = Sound("weapons/cleaver_hit_world.wav")

ENT.BaseDamage = 25
ENT.DamageRandomize = 0.3
ENT.MaxDamageRampUp = 0
ENT.MaxDamageFalloff = 0
ENT.DamageModifier = 1

--ENT.BaseSpeed = 1100
ENT.ExplosionRadiusInit = 180

ENT.CritDamageMultiplier = 3

ENT.Mass = 5

local BlastForceMultiplier = 16
local BlastForceToVelocityMultiplier = (0.015 / BlastForceMultiplier)

function ENT:Critical()
	return self.critical
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
ENT.Trail = {"peejar_trail_red_glow", "peejar_trail_blu_glow"}

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
	self:SetSolid(SOLID_CUSTOM)
	self:SetHealth(1)
	
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
	
	self.NextExplode = CurTime() + 20
	
	local effect = ParticleSuffix(GAMEMODE:EntityTeam(self:GetOwner()))
	local trail = self.Trail[self:GetOwner():EntityTeam()-1] or self.Trail[1]
	
	self.particle_trail = ents.Create("info_particle_system")
	self.particle_trail:SetPos(self:GetPos())
	self.particle_trail:SetParent(self)
	self.particle_trail:SetKeyValue("effect_name",trail)
	self.particle_trail:SetKeyValue("start_active", "1")
	self.particle_trail:Spawn()
	self.particle_trail:Activate()
	local effect = ParticleSuffix(GAMEMODE:EntityTeam(self:GetOwner()))
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

function ENT:DoExplosion()
	self:SetNoDraw(true)
	self:SetNotSolid(true)
	self:Fire("kill", "", 0.1)
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
	if data.HitEntity and data.HitEntity:IsPlayer() or data.HitEntity:IsNPC() and !data.HitEntity:IsFriendly(self:GetOwner()) then
		GAMEMODE:EntityStartBleeding(data.HitEntity, self, self:GetOwner(), 10)
		self:EmitSound("Cleaver.ImpactFlesh", 75, 100)
		local dmginfo = DamageInfo()
		dmginfo:SetDamageType(DMG_SLASH)
		dmginfo:SetDamage(math.Rand(35,90))
		dmginfo:SetAttacker(self:GetOwner())
		dmginfo:SetInflictor(self:GetOwner():GetActiveWeapon())
		data.HitEntity:TakeDamageInfo(dmginfo)
		self:DoExplosion()
	end 
	if data.HitEntity and (data.HitEntity:IsNPC() or data.HitEntity:IsPlayer()) and data.HitEntity:Health()>0 then
		
		local dmginfo = DamageInfo()
		dmginfo:SetDamageType(DMG_SLASH)
		dmginfo:SetDamage(math.random(8,90))
		dmginfo:SetAttacker(self:GetOwner())
		dmginfo:SetInflictor(self)
		local dmginfo = DamageInfo()
		dmginfo:SetDamageType(DMG_SLASH)
		dmginfo:SetDamage(35)
		dmginfo:SetAttacker(self:GetOwner())
		dmginfo:SetInflictor(self)
		data.HitEntity:TakeDamageInfo(dmginfo)
	else
		if self.DetonateMode == 2 then
			self:Break()
			return
		end
		
		if data.Speed > 50 and data.DeltaTime > 0.2 and self.BouncesLeft == 1 then
			self:EmitSound(self.BounceSound, 75, 100)
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			self.particle_trail:Remove()
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
