
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

ENT.Model = "models/weapons/w_models/w_grenade_grenadelauncher.mdl"
ENT.Model2 = "models/weapons/w_models/w_stickybomb2.mdl"

ENT.ExplosionSound = Sound("common/bass.wav")
ENT.BounceSound = "common/null.wav"

ENT.BaseDamage = 20
ENT.DamageRandomize = 0.3
ENT.MaxDamageRampUp = 0
ENT.MaxDamageFalloff = 0
ENT.DamageModifier = 1

--ENT.BaseSpeed = 1100
ENT.ExplosionRadiusInit = 180

ENT.CritDamageMultiplier = 3

ENT.Mass = 5

local BlastForceMultiplier = 200
local BlastForceToVelocityMultiplier = (0.015 / BlastForceMultiplier)

function ENT:Critical()
	return self.critical
end

function ENT:CalculateDamage(ownerpos)
	return tf_util.CalculateDamage(self, self:GetPos(), ownerpos)
end

function ENT:GetRocketJumpForce(owner, dmginfo)
	local ang = dmginfo:GetDamageForce():Angle()
	local force = dmginfo:GetDamageForce():Length() * BlastForceToVelocityMultiplier * 600
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
	if self:GetOwner():IsPlayer() then
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
	else
			self.BouncesLeft = 1
			self:SetModel(self.Model)
			self:PhysicsInit(SOLID_VPHYSICS)
	end
	
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:PhysicsInit(SOLID_CUSTOM)
	self:AddFlags(FL_GRENADE)
	self:SetHealth(1)
	
	if self.GrenadeMode==1 then
		self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
	else
		self:SetMoveCollide(MOVECOLLIDE_FLY_SLIDE)
	end
	
	if GAMEMODE:EntityTeam(self:GetOwner()) == TEAM_BLU then
		if self.GrenadeMode==1 then
			self:SetMaterial("models/weapons/w_stickybomb/w_stickybomb2_blue")
		end
	elseif GAMEMODE:EntityTeam(self:GetOwner()) == TF_TEAM_PVE_INVADERS then
		if self.GrenadeMode==1 then
			self:SetMaterial("models/weapons/w_stickybomb/w_stickybomb2_blue")
		end
	end
	
	self:SetSkin(1)
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid(self.WModel2) then
		phys:Wake()
		if self.GrenadeMode==1 then
			self.Bounciness = 1
			phys:SetMass(self.Mass)
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
	
	self.NextExplode = CurTime() + 0.3
	
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

function ENT:GravGunPunt( ply )
	self:GetPhysicsObject():EnableMotion( true )
	return true
end

function ENT:GravGunPickupAllowed( ply )
	self:GetPhysicsObject():EnableMotion( true )
	return true
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
	for k,v in ipairs(ents.FindInSphere(self:GetPos(), 50)) do
		if ( v:IsValid(self.WModel2) and v:IsTFPlayer() and v:Health() >= 0 and v != self:GetOwner() ) then
			self:DoExplosion()
		end
	end
end

function ENT:DoExplosion()
	self.PhysicsCollide = nil
	
	self:EmitSound(self.ExplosionSound, 150, 100)
	
	local flags = 0
	
	if self:WaterLevel()>0 then
		flags = bit.bor(flags, 1)
	end
	
	ParticleEffect("Explosion_ShockWave_01", self:GetPos(), self:GetAngles())
	
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
	local d = DamageInfo()
	d:SetDamage( 500 )
	d:SetAttacker( owner )
	d:SetDamageType( bit.bor(DMG_AIRBOAT,DMG_BLAST) ) 
	util.BlastDamageInfo(d, self:GetRealPos(), range)
	
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
	if data.HitEntity and data.HitEntity:IsValid(self.WModel2) and (data.HitEntity:IsTFPlayer()) and data.HitEntity:Health()>0 then
		if self.BouncesLeft>0 then
			self:DoExplosion()
		end
	else
		if data.Speed > 50 and data.DeltaTime > 0.2 then
			self:EmitSound(self.BounceSound, 100, 100)
			for k,v in ipairs(ents.FindInSphere(self:GetPos(), 100)) do
				if v:GetClass() == "npc_metropolice" then
					EmitSentence( "METROPOLICE_DANGER_GREN"..math.random(0,2), v:GetPos(), v:EntIndex(), CHAN_VOICE, 1, 75, 0, 100 )
				elseif v:GetClass() == "npc_combine_s" then
					EmitSentence( "COMBINE_GREN"..math.random(0,1), v:GetPos(), v:EntIndex(), CHAN_VOICE, 0.5, 75, 0, 100 )
				elseif v:GetClass() == "npc_sniper" then
					EmitSentence( "METROPOLICE_DANGER_VEHICLE0", v:GetPos(), v:EntIndex(), CHAN_VOICE, 0.5, 75, 0, 100 )
				end
			end
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
