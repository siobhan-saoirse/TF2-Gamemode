-- Flare

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

PrecacheParticleSystem("flaregun_trail_red")
PrecacheParticleSystem("flaregun_trail_blue")
PrecacheParticleSystem("flaregun_crit_red")
PrecacheParticleSystem("flaregun_crit_blue")
PrecacheParticleSystem("flaregun_destroyed")
ENT.FlareType = "Flare"
ENT.FlareTypeAngle = "FlareAngle"
ENT.IsTFWeapon = true

ENT.MannMelter = false

function ENT:InitEffects()
	local effect = "flaregun"
	
	if self.critical then
		effect = effect.."_crit_"
	else
		effect = effect.."_trail_"
	end
	
	effect = effect..ParticleSuffix(GAMEMODE:EntityTeam(self:GetOwner()))
	
	if self.MannMelter == true then
		
		ParticleEffectAttach( "drg_manmelter_projectile", PATTACH_ABSORIGIN_FOLLOW, self, 0 )

	else
		
		ParticleEffectAttach(effect, PATTACH_ABSORIGIN_FOLLOW, self, 0)

	end
end

if CLIENT then

function ENT:Initialize()
	self:InitEffects()
end

function ENT:Draw()
	self:DrawModel()
end
ENT.AutomaticFrameAdvance = true -- Must be set on client
end

if SERVER then

AddCSLuaFile( "shared.lua" )

ENT.Model = "models/weapons/w_models/w_flaregun_shell.mdl"

ENT.ExplosionSound = "weapons/flare_detonator_explode.wav"

ENT.BaseDamage = 30
ENT.DamageRandomize = 0.1
ENT.MaxDamageRampUp = 0
ENT.MaxDamageFalloff = 0
ENT.DamageModifier = 1

ENT.HitboxSize = 0.5

ENT.CritDamageMultiplier = 2.5
ENT.ExplosionRadiusMultiplier = 20
ENT.HitSound = Sound("Default.FlareImpact")
ENT.IsSpecial = false
function ENT:Critical()
	return self.critical
end

function ENT:MiniCrit()
	return self.minicrit
end

function ENT:CalculateDamage(ownerpos)
	return tf_util.CalculateDamage(self, self:GetPos(), ownerpos)
end

function ENT:Initialize()
	local min = Vector(-self.HitboxSize, -self.HitboxSize, -self.HitboxSize)
	local max = Vector( self.HitboxSize,  self.HitboxSize,  self.HitboxSize)
	
	self:SetModel(self.ModelOverride or self.Model)
	
	self:SetMoveType(MOVETYPE_FLYGRAVITY)
	self:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
	self:SetCollisionBounds(min, max)
	self:SetSolid(SOLID_BBOX)
	
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	
	if self.MannMelter == true then
		
		self:SetMaterial("Models/effects/vol_light001")

	end

	self:SetLocalVelocity(self:GetForward() * (self.Force or 1650))
	self:SetGravity(0.3)
	
	if GAMEMODE:EntityTeam(self:GetOwner()) == TEAM_BLU then
		self:SetSkin(1)
	elseif GAMEMODE:EntityTeam(self:GetOwner()) == TF_TEAM_PVE_INVADERS then
		self:SetSkin(1)
	end
	
	self:InitEffects()
end

function ENT:Think()
	if self.FlareTypeAngle == "ScorchAngle" then
		self:SetAngles(self:GetAngles() + Angle(math.random(-20,10),  math.random(-20,10),  math.random(-20,10))) 
	else
		self:SetAngles(self:GetVelocity():Angle())
	end
	if SERVER and not IsValid(self:GetOwner()) then
		self:Remove()
	end
	self:NextThink(CurTime())
	return true
end

function ENT:Hit(ent)
	self.Touch = nil
	if ent:IsTFPlayer() then
		self:EmitSound("player/pl_impact_flare"..math.random(1,3)..".wav", 85, 100)
	else
		
		if self:GetOwner():GetActiveWeapon():GetItemData().model_player == "models/workshop/weapons/c_models/c_detonator/c_detonator.mdl" then
			self.HitWorld = true
			self:DoExplosion()
			self:Fire("Kill", "", 0.01)
		else
			self:EmitSound("physics/concrete/concrete_impact_flare"..math.random(1,4)..".wav", 85, 100)
		end
	end
	
	local explosion = ents.Create("info_particle_system")
	explosion:SetKeyValue("effect_name", "flaregun_destroyed")
	explosion:SetKeyValue("start_active", "1")
	explosion:SetPos(self:GetPos()) 
	explosion:SetAngles(self:GetAngles())
	explosion:Spawn()
	explosion:Activate() 
	explosion:Fire("Kill", "", 0.5)
	
	local owner = self:GetOwner()
	if not owner or not owner:IsValid(self.WModel2) then owner = self end
	
	local damage = self:CalculateDamage(owner:GetPos())
	local dir = self:GetVelocity():GetNormal()
	
	if ent:IsTFPlayer() and ent:HasPlayerState(PLAYERSTATE_ONFIRE) then
		self.critical = true
	end
	if self.IsSpecial then
		for k,v in ipairs(ents.FindInSphere(self:GetPos(), 350)) do 
			if v:IsFlammable() then 
				if (v:IsTFPlayer() and v:IsFriendly(self:GetOwner())) then return end
				GAMEMODE:IgniteEntity(ent, self, owner, 10)
				local dmginfo = DamageInfo()
				dmginfo:SetDamageType(DMG_GENERIC)
				dmginfo:SetDamage(self.BaseDamage)  
				dmginfo:SetAttacker(owner)
				dmginfo:SetInflictor(self)
				ent:TakeDamageInfo(dmginfo)
			end
		end
	else
		if ent:IsFlammable() then
			if (ent:IsTFPlayer() and ent:IsFriendly(self:GetOwner())) then return end
			GAMEMODE:IgniteEntity(ent, self, owner, 10)
			local dmginfo = DamageInfo() 
			dmginfo:SetDamageType(DMG_GENERIC)
			dmginfo:SetDamage(self.BaseDamage)
			dmginfo:SetAttacker(owner)
			dmginfo:SetInflictor(self)
			ent:TakeDamageInfo(dmginfo)
		end
	end
	self:SetLocalVelocity(Vector(0,0,0))
	
	local range = 60
	if self.FlareType == "Scorch" and IsValid(ent) then
		for k,v in ipairs(ents.FindInSphere(self:GetPos(), 180)) do
				if v:IsValid(self.WModel2) and v:IsTFPlayer() and !v:IsFriendly(owner) then
					self:EmitSound("player/pl_impact_flare"..math.random(1,3)..".wav", 85, 100)
					GAMEMODE:IgniteEntity(v, self, owner, 10)
					util.BlastDamage(self, owner, self:GetPos(), range*1, 20)	
				end
			self:SetVelocity(self:GetVelocity() + Vector(0, 0, 120) + v:GetVelocity())
			self.FlareTypeAngle = "ScorchAngle"
			self:SetMoveType(MOVETYPE_FLYGRAVITY)
		end		
		timer.Simple(2, function()
			for k,v in ipairs(ents.FindInSphere(self:GetPos(), 180)) do
				if v:IsValid(self.WModel2) and v:IsTFPlayer() and !v:IsFriendly(owner) then
					self:EmitSound("player/pl_impact_flare"..math.random(1,3)..".wav", 85, 100)
					GAMEMODE:IgniteEntity(v, self, owner, 10)
					util.BlastDamage(self, owner, self:GetPos(), range*1, 20)
				end
			end	
		local flags = 0
			local explosion = ents.Create("info_particle_system")
			explosion:SetKeyValue("effect_name", "flaregun_destroyed")
			explosion:SetKeyValue("start_active", "1")
			explosion:SetPos(self:GetPos()) 
			explosion:SetAngles(self:GetAngles())
			explosion:Spawn()
			explosion:Activate() 
			explosion:Fire("Kill", "", 0.5)
			self:SetMoveType(MOVETYPE_NONE)
			self:SetNotSolid(true) 
			self:SetNoDraw(true)
			self:Fire("kill", "", 0.1)	
		end)
	else
		
		self:SetMoveType(MOVETYPE_NONE)
		self:SetNotSolid(true)
		self:SetNoDraw(true)

		self:Fire("kill", "", 0.1)
	end
end


function ENT:DoExplosion()
	self.Touch = nil
	
	local effect, angle

		if !self.HitWorld then
			self:EmitSound("Weapon_Detonator.Detonate")
		else
			self:EmitSound("Weapon_Detonator.DetonateWorld")
		end
		
		local flags = 0
		
		if self:WaterLevel()>0 then
			flags = bit.bor(flags, 1)
		end
		
		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetAttachment(flags)
		util.Effect("tf_explosion", effectdata, true, true)
	
	local owner = self:GetOwner()
	if not owner or not owner:IsValid(self.WModel2) then owner = self end
	
	--local damage = self:CalculateDamage(owner:GetPos()+Vector(0,0,1))
	local range = 60
	--[[if self.FastRocket then
		range = range * 0.4
	end]]
	
	--self.ResultDamage = damage
	
	if self.Nuke then
		--util.BlastDamage(self, owner, self:GetPos(), range*6, damage*6)
		util.BlastDamage(self, owner, self:GetPos(), range*6, 100)
	else
		--util.BlastDamage(self, owner, self:GetPos(), range, damage)
		util.BlastDamage(self, owner, self:GetPos(), range*2, 50)
	end
	
	for k,v in ipairs(ents.FindInSphere(self:GetPos(), range*2)) do
		if v:Health() >= 0 and v:IsFlammable() then
			GAMEMODE:IgniteEntity(v, self, owner, 10)
		end
	end
	
	self:Remove()
end

function ENT:Touch(ent)
	if ent:IsSolid() then
		if (ent:IsTFPlayer() and ent:IsFriendly(self:GetOwner())) then return end
		self:Hit(ent)
	end
end

end
