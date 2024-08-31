
if CLIENT then
	killicon.Add( "tf_projectile_rocket", "backpack/weapons/w_models/w_rocketlauncher_large", Color( 255, 255, 255, 255 ) )
end

-- Sticky bomb
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

ENT.Explosive = true

PrecacheParticleSystem("rockettrail")
PrecacheParticleSystem("rockettrail_underwater")
PrecacheParticleSystem("eyeboss_projectile")
PrecacheParticleSystem("critical_rocket_red")
PrecacheParticleSystem("critical_rocket_blue")
PrecacheParticleSystem("cinefx_goldrush")
PrecacheParticleSystem("mvm_soldier_shockwave")

PrecacheParticleSystem("ExplosionCore_MidAir")
PrecacheParticleSystem("ExplosionCore_MidAir_underwater")
PrecacheParticleSystem("ExplosionCore_Wall")
PrecacheParticleSystem("ExplosionCore_Wall_underwater") 

function ENT:SetupDataTables()  
	self:DTVar("Bool", 0, "Critical")
end  

function ENT:InitEffects()
	local effect = ParticleSuffix(GAMEMODE:EntityTeam(self:GetOwner()))
	-- gotta love the accuracy :P
	if (GAMEMODE:EntityTeam(self:GetOwner()) != TEAM_RED and GAMEMODE:EntityTeam(self:GetOwner()) != TEAM_BLU) then
		ParticleEffectAttach("rockettrail_underwater", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("trail"))
	else
		ParticleEffectAttach("rockettrail", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("trail"))
	end
	
	if self.dt.Critical then
		if (GAMEMODE:EntityTeam(self:GetOwner()) != TEAM_RED and GAMEMODE:EntityTeam(self:GetOwner()) != TEAM_BLU) then
			ParticleEffectAttach("eyeboss_projectile", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("trail"))
		else
			ParticleEffectAttach("critical_rocket_"..effect, PATTACH_POINT_FOLLOW, self, self:LookupAttachment("trail"))
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
 
ENT.ExplosionSound = Sound("TF_BaseExplosionEffect.Sound")
ENT.ExplosionSoundFast = Sound("Weapon_RPG_DirectHit.Explode")
ENT.ExplosionSoundNuke = Sound("Cart.Explode")
ENT.BounceSound = Sound("Weapon_Grenade_Pipebomb.Bounce")

ENT.BaseDamage = 95
ENT.DamageRandomize = 0.8
ENT.MaxDamageRampUp = 1.2
ENT.MaxDamageFalloff = 0.8
ENT.DamageModifier = 1

ENT.BaseSpeed = 1100
ENT.ExplosionRadiusInit = 150
ENT.OwnerDamage = 1

ENT.CritDamageMultiplier = 3

ENT.HitboxSize = 10

function ENT:Critical()
	if self:GetOwner():GetClass() == "eyeball_boss" then
		return true
	end
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
	self:AddEffects(EF_NOSHADOW)
	
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
	
	self:SetHealth(1)
	self:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
	self:SetCollisionBounds(min, max)
	self:SetSolid(SOLID_BBOX)
	
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
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
	if SERVER and !IsValid(self:GetOwner()) then
		self:Remove()
	end
	
	for k,v in ipairs(ents.FindInSphere(self:GetPos(),200)) do
		if (v:IsValid() and v:IsTFPlayer() and v:EntIndex() != self:GetOwner():EntIndex() and !v:IsFriendly(self:GetOwner()) and v:Health() > 0 and self:GetPos():Distance(v:GetPos()) < v:GetModelRadius() + 24) then
			self:DoExplosion(v)
		end
	end
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

	if ent == self:GetOwner() and self:GetOwner():GetClass() == "eyeball_boss" then return end
	self.Touch = nil
	
	local effect, angle

	if self.Nuke then
		self:EmitSound(self.ExplosionSoundNuke)
		effect = "cinefx_goldrush"
		angle = Angle(0,self:GetAngles().y, 0)
		
		local explosion = ents.Create("info_particle_system")
		explosion:SetKeyValue("effect_name", effect)
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
		if (self:Critical()) then

			-- lets not do this, please

			--ParticleEffect("Explosion_ShockWave_01", self:GetPos(), self:GetAngles())
 
			if self:GetOwner():Team() == TEAM_BLU then
				--ParticleEffect("drg_cow_explosioncore_charged_blue", self:GetPos(), self:GetAngles())		
			elseif self:GetOwner():Team() == TF_TEAM_PVE_INVADERS then
				--ParticleEffect("drg_cow_explosioncore_charged_blue", self:GetPos(), self:GetAngles())		
			else
				--ParticleEffect("drg_cow_explosioncore_charged", self:GetPos(), self:GetAngles())
			end
			
			--self:EmitSound("explode_8")
		end
		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetAngles(angle)
			effectdata:SetAttachment(flags)
		util.Effect("tf_explosion", effectdata, true, true)
	end
	
	local owner = self:GetOwner()
	if not owner or not owner:IsValid(self.WModel2) then owner = self end
	
	local damage = self:CalculateDamage(owner:GetPos()+Vector(0,0,1))
	local range = self.ExplosionRadiusInit
	if self.ExplosionRadiusMultiplier and self.ExplosionRadiusMultiplier>1 then
		range = range * self.ExplosionRadiusMultiplier
	end
	--[[if self.FastRocket then
		range = range * 0.4
	end]]
	
	--self.ResultDamage = damage
	if (IsValid(owner)) then
		if owner:IsPlayer() and owner:GetActiveWeapon():GetItemData().model_player == "models/weapons/c_models/c_rocketjumper/c_rocketjumper.mdl" then
			for k,v in ipairs(ents.FindInSphere(self:GetPos(), range*1)) do
				if v == owner then
					owner.m_flBlastJumpLaunchTime = CurTime()
					util.BlastDamage(self, owner, self:GetPos(), range*1, damage)
					if (!owner.Whistle) then
						owner.Whistle = CreateSound(owner,"BlastJump.Whistle")
						owner.Whistle:PlayEx(0.25,200)
					end
					if (owner.Whistle and !owner.Whistle:IsPlaying()) then
						owner.Whistle:PlayEx(0.25,200)
					end
				end
			end
		else
			if self.Nuke then
				--util.BlastDamage(self, owner, self:GetPos(), range*6, damage*6)
				util.BlastDamage(self, owner, self:GetPos(), range*6, 100)
			else
				--util.BlastDamage(self, owner, self:GetPos(), range, damage)
				util.BlastDamage(self, owner, self:GetPos(), range*1, damage)
			end
		end
	end
	
	for k,v in ipairs(ents.FindInSphere(self:GetPos(),range)) do
		if (v:IsPlayer()) then
			if ((string.find(v:GetModel(),"/bot_") or (string.find(game.GetMap(), "mvm_") and self:GetOwner():Team() != TEAM_BLU and v:Team() != self:GetOwner():Team())) and !v:IsFriendly(self:GetOwner())) then
				ParticleEffect("mvm_soldier_shockwave", self:GetPos(), self:GetAngles())
				if (!v:HasPlayerState(PLAYERSTATE_STUNNED)) then
					--v:EmitSound("TFPlayer.StunImpact")
				end
				timer.Stop("StunnedReset"..v:EntIndex())
				timer.Stop("Stunned"..v:EntIndex())
				timer.Create("Stunned"..v:EntIndex(), 0.1, 10, function()
					if (v:IsMiniBoss()) then
						v:SetClassSpeed(v:GetPlayerClassTable().Speed * 0.8)
					else
						v:SetClassSpeed(v:GetPlayerClassTable().Speed * 0.7)
					end
					v:AddPlayerState(PLAYERSTATE_STUNNED)
				end)
				timer.Create("StunnedReset"..v:EntIndex(), 1, 0, function()
					v:ResetClassSpeed()
					v:RemovePlayerState(PLAYERSTATE_STUNNED)
				end)
				self.BaseDamage = 95 * 1.2
			end
		end
	end
	if ForceDamageClasses[ent:GetClass()] then
		local dmginfo = DamageInfo()
		dmginfo:SetDamage(100)
		dmginfo:SetDamageType(DMG_BLAST)
		dmginfo:SetAttacker(owner)
		dmginfo:SetInflictor(self)
		dmginfo:SetDamagePosition(self:GetPos())
		dmginfo:SetDamageForce(vector_up)
		ent:TakeDamageInfo(dmginfo)
	end
	
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
	if not ent:IsTrigger() and ent:IsSolid() then	
		if (ent:IsTFPlayer() and IsValid(self:GetOwner()) and ent:IsFriendly(self:GetOwner())) then
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			return
		end
		self:DoExplosion(ent)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	end
end

end
