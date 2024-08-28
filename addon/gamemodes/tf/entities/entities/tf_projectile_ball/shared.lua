
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

ENT.Model = "models/weapons/w_models/w_baseball.mdl"
ENT.Model2 = "models/weapons/w_models/w_stickybomb2.mdl"

ENT.ExplosionSound2 = Sound("player/pl_impact_stun_range.wav")
ENT.ExplosionSound = Sound("player/pl_impact_stun.wav")
ENT.BounceSound = Sound("Weapon_Baseball.HitWorld")

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
		self.BouncesLeft = 1
		self:SetModel(self.Model)
		self:PhysicsInit(SOLID_VPHYSICS)
	
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetHealth(1)
	
	self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
	
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
	
	self.particle_trail = ents.Create("info_particle_system")
	self.particle_trail:SetPos(self:GetRealPos())
	self.particle_trail:SetParent(self)
	self.particle_trail:SetKeyValue("effect_name","stunballtrail_" .. effect)
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

function ENT:DoExplosion()
	self.PhysicsCollide = nil
	
	
	local flags = 0
	
	if self:WaterLevel()>0 then
		flags = bit.bor(flags, 1)
	end
	
	local owner = self:GetOwner()
	
	local range, damage
	
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
function ENT:Touch(ent)
	if ent.Base == "npc_tf2base" or ent.Base == "npc_tf2base_mvm" or ent.Base == "npc_demo_red" or ent.Base == "npc_demo_mvm" or ent.Base == "npc_scout_mvm" or ent.Base == "npc_hwg_red" or ent.Base == "npc_heavy_mvm" or ent.Base == "npc_heavy_mvm_shotgun" or ent.Base == "npc_soldier_red" or ent.Base == "npc_sniper_red" or ent.Base == "npc_spy_red" or ent.Base == "npc_scout_red" or ent.Base == "npc_pyro_red" or ent.Base == "npc_medic_red" or ent.Base == "npc_engineer_red" and !ent:IsFriendly(self:GetOwner()) and ent:Health()>0 and self.critical and !ent.IsStunned then
		self:EmitSound(self.ExplosionSound2, 100, 100)
		timer.Create("StunRobot25", 0.001, 1, function()
			ent:RestartGesture(ACT_MP_STUN_BEGIN,2)
			timer.Create("StunRobotloop3", 0.6, 0, function()
				if not IsValid(ent) then timer.Stop("StunRobotloop") return end
				timer.Create("StunRobotloop4", 0.2,  0, function()
					if not IsValid(ent) then timer.Stop("StunRobotloop4") return end
					ent:RestartGesture(ACT_MP_STUN_MIDDLE,2)
				end)
			end)
		end) 
		ent:RestartGesture(ACT_MP_STUN_BEGIN, true)
		ent.IsStunned = true
		ParticleEffectAttach("bonk_text", PATTACH_POINT_FOLLOW, ent, ent:LookupAttachment("head"))
		timer.Simple(5, function()
			if not IsValid(ent) then return end
			timer.Stop("StunRobotloop3")
			timer.Stop("StunRobotloop4")
			
			ent.IsStunned = false
			ent:RestartGesture(ACT_MP_STUN_END,2)
		end)
	elseif ent.Base == "npc_tf2base" or ent.Base == "npc_tf2base_mvm" or ent.Base == "npc_demo_red" or ent.Base == "npc_demo_mvm" or ent.Base == "npc_scout_mvm" or ent.Base == "npc_hwg_red" or ent.Base == "npc_heavy_mvm" or ent.Base == "npc_heavy_mvm_shotgun" or ent.Base == "npc_soldier_red" or ent.Base == "npc_sniper_red" or ent.Base == "npc_spy_red" or ent.Base == "npc_scout_red" or ent.Base == "npc_pyro_red" or ent.Base == "npc_medic_red" or ent.Base == "npc_engineer_red" and !ent:IsFriendly(self:GetOwner()) and ent:Health()>0 and !self.critical then
		self:EmitSound(self.ExplosionSound2, 100, 100)
		self:DoExplosion()
	end
end
function ENT:PhysicsCollide(data, physobj)
	if data.HitEntity and data.HitEntity:IsValid(self.WModel2) and data.HitEntity:IsTFPlayer() and !data.HitEntity:IsNPC() and !data.HitEntity:IsFriendly(self:GetOwner()) and data.HitEntity:Health()>0 and self.critical then
		self:EmitSound(self.ExplosionSound2, 100, 100)
		ParticleEffectAttach("bonk_text", PATTACH_POINT_FOLLOW, data.HitEntity, data.HitEntity:LookupAttachment("head"))
		timer.Create("Stunned"..data.HitEntity:EntIndex(), 0.1, 80, function()
			data.HitEntity:SetClassSpeed(data.HitEntity:GetPlayerClassTable().Speed * 0.7)
			data.HitEntity:AddPlayerState(PLAYERSTATE_STUNNED)
		end)
		timer.Simple(8, function()
			timer.Stop("Stunned"..data.HitEntity:EntIndex())
			data.HitEntity:ResetClassSpeed()
			data.HitEntity:RemovePlayerState(PLAYERSTATE_STUNNED)
		end)	
	end
	if data.HitEntity and data.HitEntity:IsValid(self.WModel2) and data.HitEntity:IsTFPlayer() and !data.HitEntity:IsNPC() and !data.HitEntity:IsFriendly(self:GetOwner()) and data.HitEntity:Health()>0 then
		self:EmitSound(self.ExplosionSound, 100, 100)
		timer.Create("Stunned"..data.HitEntity:EntIndex(), 0.1, 80, function()
			data.HitEntity:SetClassSpeed(data.HitEntity:GetPlayerClassTable().Speed * 0.7)
			data.HitEntity:AddPlayerState(PLAYERSTATE_STUNNED)
		end)
		timer.Simple(8, function()
			timer.Stop("Stunned"..data.HitEntity:EntIndex())
			data.HitEntity:ResetClassSpeed()
			data.HitEntity:RemovePlayerState(PLAYERSTATE_STUNNED)
		end)	
		ParticleEffectAttach("bonk_text", PATTACH_POINT_FOLLOW, data.HitEntity, data.HitEntity:LookupAttachment("head"))
	end 
	if data.HitEntity and data.HitEntity:IsValid(self.WModel2) and data.HitEntity:GetClass() == "npc_antlionguard" and !data.HitEntity:IsFriendly(self:GetOwner()) and !self.critical and data.HitEntity:Health()>0 then
		self:EmitSound(self.ExplosionSound, 100, 100)
		ParticleEffectAttach("bonk_text", PATTACH_POINT_FOLLOW, data.HitEntity, data.HitEntity:LookupAttachment("head"))
		data.HitEntity:EmitSound("NPC_AntlionGuard.FrustratedRoar")
		data.HitEntity:Fire("EnableBark") 
		data.HitEntity:SetModelScale(data.HitEntity:GetModelScale() + 0.04)
		data.HitEntity:SetMaxHealth(data.HitEntity:GetMaxHealth() + 50)
		data.HitEntity:SetHealth(data.HitEntity:GetHealth() + 45)
		data.HitEntity:Fire("DisableBark", "", 8)
		self:GetOwner():EmitSound("vo/scout_stunballhit0"..math.random(1,9)..".wav")
	end 
	if data.HitEntity and data.HitEntity:IsValid(self.WModel2) and data.HitEntity:GetClass() == "npc_antlionguard" and !data.HitEntity:IsFriendly(self:GetOwner()) and self.critical and data.HitEntity:Health()>0 then
		self:EmitSound(self.ExplosionSound2, 100, 100)
		ParticleEffectAttach("bonk_text", PATTACH_POINT_FOLLOW, data.HitEntity, data.HitEntity:LookupAttachment("head"))
		data.HitEntity:EmitSound("NPC_AntlionGuard.FrustratedRoar")
		data.HitEntity:EmitSound("NPC_AntlionGuard.FrustratedRoar")
		data.HitEntity:EmitSound("NPC_AntlionGuard.FrustratedRoar")
		data.HitEntity:Fire("EnableBark") 
		data.HitEntity:SetModelScale(data.HitEntity:GetModelScale() + 0.15)
		data.HitEntity:SetMaxHealth(data.HitEntity:GetMaxHealth() + 140)
		data.HitEntity:SetHealth(data.HitEntity:GetHealth() + 125)
		data.HitEntity:Fire("DisableBark", "", 15)
		self:GetOwner():EmitSound("vo/scout_stunballhit0"..math.random(1,9)..".wav")
	end 
	if data.HitEntity and data.HitEntity:IsValid(self.WModel2) and (data.HitEntity:IsNPC() or data.HitEntity:IsPlayer()) and data.HitEntity:Health()>0 then
		if self.BouncesLeft>0 then
			if self.critical then
				self:EmitSound(self.ExplosionSound2, 100, 100)
			else
				self:EmitSound(self.ExplosionSound, 100, 100)
			end
			self:DoExplosion()	
			self:GetOwner():EmitSound("vo/scout_stunballhit0"..math.random(1,9)..".wav")
		end
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
