-- Sticky bomb

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

ENT.Explosive = true

PrecacheParticleSystem("rockettrail")
PrecacheParticleSystem("critical_rocket_red")
PrecacheParticleSystem("critical_rocket_blue")
PrecacheParticleSystem("cinefx_goldrush")

PrecacheParticleSystem("ExplosionCore_MidAir")
PrecacheParticleSystem("ExplosionCore_MidAir_underwater")
PrecacheParticleSystem("ExplosionCore_Wall")
PrecacheParticleSystem("ExplosionCore_Wall_underwater")

function ENT:SetupDataTables()  
	self:DTVar("Bool", 0, "Critical")
end  

function ENT:InitEffects()
	local effect = ParticleSuffix(GAMEMODE:EntityTeam(self:GetOwner()))
	if self:GetOwner():Team() == TEAM_RED or self:GetOwner():Team() == TEAM_NEUTRAL then
		ParticleEffectAttach( "drg_cow_rockettrail_normal", PATTACH_POINT_FOLLOW, self, 1 )
	else
		ParticleEffectAttach( "drg_cow_rockettrail_normal_blue", PATTACH_POINT_FOLLOW, self, 1 )
	end
	if self.dt.Critical then
		if self:GetOwner():Team() == TEAM_RED or self:GetOwner():Team() == TEAM_NEUTRAL then
			ParticleEffectAttach( "drg_cow_rockettrail_charged", PATTACH_POINT_FOLLOW, self, 1 )
		else
			ParticleEffectAttach( "drg_cow_rockettrail_charged_blue", PATTACH_POINT_FOLLOW, self, 1 )
		end
	end
end

if CLIENT then

function ENT:Initialize()
	self:InitEffects()
	
	local bomb = self:GetNWEntity("Bomb")
	if IsValid(bomb) then
		bomb:SetModelScale(Vector(0.5, 0.5, 0.5))
	end
end

function ENT:Draw()
	self:DrawModel()
end

end

if SERVER then

AddCSLuaFile( "shared.lua" )

ENT.Model = Model("models/weapons/w_models/w_rocket.mdl")
ENT.ModelNuke = Model("models/props_trainyard/cart_bomb_separate.mdl")

ENT.ExplosionSound = Sound("Weapon_Grenade_Pipebomb.Explode")
ENT.ExplosionSound2 = Sound("weapons/cow_mangler_explode.wav")
ENT.ExplosionSoundFast = Sound("Weapon_RPG_DirectHit.Explode")
ENT.ExplosionSoundNuke = Sound("Cart.Explode")
ENT.BounceSound = Sound("Weapon_Grenade_Pipebomb.Bounce")

ENT.BaseDamage = 90
ENT.DamageRandomize = 0.1
ENT.MaxDamageRampUp = 0.25
ENT.MaxDamageFalloff = 0.53
ENT.DamageModifier = 1

ENT.BaseSpeed = 1100
ENT.ExplosionRadiusInit = 150
ENT.OwnerDamage = 1

ENT.CritDamageMultiplier = 3

ENT.HitboxSize = 10

function ENT:Critical()
	return self.dt.Critical
end

function ENT:CalculateDamage(ownerpos)
	return tf_util.CalculateDamage(self, self:GetPos(), ownerpos)
end

function ENT:Initialize()
	self.dt.Critical = self.critical
	
	local min = Vector(-self.HitboxSize, -self.HitboxSize, -self.HitboxSize)
	local max = Vector( self.HitboxSize,  self.HitboxSize,  self.HitboxSize)
	
	self:SetModel(self.Model)
	if self.Nuke then
		local bomb = ents.Create("prop_dynamic")
		bomb:SetModel(self.ModelNuke)
		bomb:SetPos(self:GetPos())
		bomb:SetAngles((-1 * self:GetForward()):Angle())
		bomb:SetNotSolid(true)
		bomb:SetParent(self)
		bomb:Spawn()
		
		self:SetNWEntity("Bomb", bomb)
	elseif self.Error then
		local bomb = ents.Create("prop_dynamic")
		bomb:SetModel("models/error.mdl")
		bomb:SetPos(self:GetPos())
		bomb:SetAngles((-1 * self:GetForward()):Angle())
		bomb:SetPos(bomb:LocalToWorld(-1 * bomb:OBBCenter()))
		bomb:SetNotSolid(true)
		bomb:SetParent(self)
		bomb:Spawn()
		
		--self:SetNWEntity("Bomb", bomb)
		self:SetColor(255,255,255,0)
		self.NameOverride = "have_an_error"
	end
	
	if self.Gravity then
		self:SetMoveType(MOVETYPE_FLYGRAVITY)
		self:SetGravity(self.Gravity)
	else
		self:SetMoveType(MOVETYPE_FLY)
	end
	
	self:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
	self:SetCollisionBounds(min, max)
	self:SetSolid(SOLID_BBOX)
	
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)	
	PrecacheParticleSystem("drg_cow_rockettrail_normal_blue")
	PrecacheParticleSystem("drg_cow_rockettrail_normal")
	

	self:SetMaterial("Models/effects/vol_light001")
	
	self:SetLocalVelocity(self:GetForward() * self.BaseSpeed)
	
	--[[
	if self.FastRocket then
		self:SetLocalVelocity(self:GetForward() * self.BaseSpeed * 1.8)
		--self.BaseDamage = self.BaseDamage * 1.25
		self.NameOverride = "tf_projectile_rocket_direct"
	else
		self:SetLocalVelocity(self:GetForward() * self.BaseSpeed)
	end]]
	
	self.ai_sound = ents.Create("ai_sound")
	self.ai_sound:SetPos(self:GetPos())
	self.ai_sound:SetKeyValue("volume", "80")
	self.ai_sound:SetKeyValue("duration", "8")
	self.ai_sound:SetKeyValue("soundtype", "8")
	self.ai_sound:SetParent(self)
	self.ai_sound:Spawn()
	self.ai_sound:Activate()
	self.ai_sound:Fire("EmitAISound", "", 0.3)
	

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
	end
end

function ENT:OnRemove()
	self.ai_sound:Remove()
end

local ForceDamageClasses = {
	npc_combinegunship = true,
	npc_helicopter = true,
}

function ENT:DoExplosion(ent)
	
	local dmginfo = DamageInfo()
	self.Touch = nil
	
	local effect, angle

	if self.Nuke then
		self:EmitSound(self.ExplosionSoundNuke)
		effect = "cinefx_goldrush"
		angle = Angle(0,self:GetAngles().y, 0)
		
		local explosion = ents.Create("info_particle_system")
		explosion:SetKeyValue("effect_name", "effect")
		explosion:SetKeyValue("start_active", "1")
		explosion:SetPos(self:GetPos()) 
		explosion:SetAngles(self:GetAngles())
		explosion:Spawn()
		explosion:Activate() 
		
		explosion:Fire("Kill", "", 5)
	else
		--[[if self.FastRocket then
			self:EmitSound(self.ExplosionSoundFast)
		else]]
			if self.dt.Critical then
				self:EmitSound("weapons/cow_mangler_explosion_charge_0"..math.random(1,6)..".wav", 95, 100)
			else
				self:EmitSound(self.ExplosionSound, 95, 100)
			end
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
		util.Effect("drg_cow_explosion_sparkles_blue", effectdata, true, true)
		
		if self:GetOwner():Team() == TEAM_RED or self:GetOwner():Team() == TEAM_NEUTRAL then
			
			effect = "drg_cow_explosion_flashup"
			effect2 = "drg_cow_explosioncore_normal"
			effect3 = "drg_cow_explosion_sparkles"
			
		else
		
			effect = "drg_cow_explosion_flashup_blue"
			effect2 = "drg_cow_explosioncore_normal_blue"
			effect3 = "drg_cow_explosion_sparkles_blue"	

		end
		angle = Angle(0,self:GetAngles().y, 0)
		
		local explosion = ents.Create("info_particle_system")
		explosion:SetKeyValue("effect_name", effect)
		explosion:SetKeyValue("start_active", "1")
		explosion:SetPos(self:GetPos()) 
		explosion:SetAngles(self:GetAngles())
		explosion:Spawn()
		explosion:Activate() 
		local explosion2 = ents.Create("info_particle_system")
		explosion2:SetKeyValue("effect_name", effect2)
		explosion2:SetKeyValue("start_active", "1")
		explosion2:SetPos(self:GetPos()) 
		explosion2:SetAngles(self:GetAngles())
		explosion2:Spawn()
		explosion2:Activate() 
		local explosion3 = ents.Create("info_particle_system")
		explosion3:SetKeyValue("effect_name", effect2)
		explosion3:SetKeyValue("start_active", "1")
		explosion3:SetPos(self:GetPos()) 
		explosion3:SetAngles(self:GetAngles())
		explosion3:Spawn()
		explosion3:Activate() 
		
		explosion:Fire("Kill", "", 5)
		explosion2:Fire("Kill", "", 5)
		explosion3:Fire("Kill", "", 5)
	end
	
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
	
	if self.Nuke then
		--util.BlastDamage(self, owner, self:GetPos(), range*6, damage*6)
		util.BlastDamage(self, owner, self:GetPos(), range*6, 100)
	else
		--util.BlastDamage(self, owner, self:GetPos(), range, damage)
		for k,v in ipairs(ents.FindInSphere(self:GetPos(), range)) do
			dmginfo:SetDamage(80)
			dmginfo:SetDamageType(DMG_DISSOLVE)
			dmginfo:SetAttacker(owner)
			dmginfo:SetInflictor(self)
			dmginfo:SetDamagePosition(self:GetPos())
			dmginfo:SetDamageForce(vector_up)
			v:TakeDamageInfo(dmginfo)
		end
		util.BlastDamage(self, owner, self:GetPos(), range, 100)
	end
	
		local dmginfo = DamageInfo()
		dmginfo:SetDamage(80)
		dmginfo:SetDamageType(DMG_DISSOLVE)
		dmginfo:SetAttacker(owner)
		dmginfo:SetInflictor(self)
		dmginfo:SetDamagePosition(self:GetPos())
		dmginfo:SetDamageForce(vector_up)
		ent:TakeDamageInfo(dmginfo)
	
	self:Remove()
end

--[[
function ENT:ModifyInitialDamage(ent, dmginfo)
	if self.FastRocket and self:GetOwner() ~= ent then
		local frac = dmginfo:GetDamage() * 0.01
		local saturate = 1.5
		local range_reduce = 0.7
		local mul = 1.25
		
		frac = math.Clamp(saturate * (frac - range_reduce) / (1 - range_reduce), 0, 1) * mul
		
		return frac * 100
	else
		return dmginfo:GetDamage()
	end
end]]

function ENT:Touch(ent)
	if ent:IsSolid() then
		self:DoExplosion(ent)
	end
end

end



function ENT:TF2BlastDamage(origin, radius, dmg)


	
	

	local expd = DamageInfo()



	expd:SetAttacker(self:GetOwner())
	expd:SetDamageType(DMG_DISSOLVE)

	expd:SetDamagePosition(origin)
	
	
	local subjects = ents.FindInSphere(origin, radius)
	
	for k,v in pairs(subjects) do
	
		local dist = v:GetPos():Distance(origin)
		expd:SetDamage((radius-dist) * (dmg/radius))
		

		
		local fvTrace = util.TraceLine({
			start = origin,
			endpos = v:GetPos()
		})
		
		local ForceVector = fvTrace.Normal*((radius-dist) * (40000/radius))
		
		expd:SetDamageForce(ForceVector)
		
		--v:Ignite(4)
		
		v:TakeDamageInfo(expd)		
	end

end