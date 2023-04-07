-- Flare

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

PrecacheParticleSystem("flaregun_trail_red")
PrecacheParticleSystem("flaregun_trail_blue")
PrecacheParticleSystem("flaregun_crit_red")
PrecacheParticleSystem("flaregun_crit_blue")
PrecacheParticleSystem("flaregun_destroyed")

PrecacheParticleSystem("drg_cow_rockettrail_normal")
PrecacheParticleSystem("drg_cow_rockettrail_normal_blue")
ENT.IsTFWeapon = true


function ENT:InitEffects()
	local effect = ParticleSuffix(GAMEMODE:EntityTeam(self:GetOwner()))
	if self:GetOwner():Team() == TEAM_RED or self:GetOwner():Team() == TEAM_NEUTRAL then
		ParticleEffectAttach( "drg_cow_rockettrail_normal", PATTACH_POINT_FOLLOW, self, 1 )
	else
		ParticleEffectAttach( "drg_cow_rockettrail_normal_blue", PATTACH_POINT_FOLLOW, self, 1 )
	end
	if self.Critical then
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
end

function ENT:Draw()
	self:DrawModel()
end

end

if SERVER then

AddCSLuaFile( "shared.lua" )

ENT.Model = "models/weapons/w_models/w_flaregun_shell.mdl"

ENT.BaseDamage = 15

ENT.HitboxSize = 0.5

ENT.CritDamageMultiplier = 3

ENT.HitSound = Sound("Default.FlareImpact")

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
	
	self:SetMoveType(MOVETYPE_FLY)
	self:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
	self:SetCollisionBounds(min, max)
	self:SetSolid(SOLID_BBOX)
 	self:SetMaterial("Models/effects/vol_light001")
	
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	
	self:SetLocalVelocity(self:GetForward() * (self.Force or 1650))
	self:SetGravity(0.5)
	
	if GAMEMODE:EntityTeam(self:GetOwner()) == TEAM_BLU then
		self:SetSkin(1)
	elseif GAMEMODE:EntityTeam(self:GetOwner()) == TF_TEAM_PVE_INVADERS then
		self:SetSkin(1)
	end
	
	self:InitEffects()
end

function ENT:Think()
	self:SetAngles(self:GetVelocity():Angle())
end

function ENT:Hit(ent)
	self.Touch = nil
	if !ent:IsPlayer() and !ent:IsNPC() then
		self:EmitSound("physics/concrete/concrete_impact_flare"..math.random(1,4)..".wav", 80, 100)
	end
	
	local explosion = ents.Create("info_particle_system")
	explosion:SetKeyValue("effect_name", "drg_pomson_impact")
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
	
	if ent:IsPlayer() then
		ent:EmitSound("weapons/drg_pomson_drain_01.wav", 90, math.random(90, 100))
	elseif ent:IsNPC() then
		ent:EmitSound("weapons/drg_pomson_drain_01.wav", 90, math.random(90, 100))
	end
	
	self:FireBullets{
		Src=self:GetPos(),
		Attacker=owner,
		Dir=dir,
		Spread=Vector(0,0,0),
		Num=1,
		Damage=damage,
		Tracer=0,
		HullSize=self.HitboxSize*2,
	}
	
	self:SetLocalVelocity(Vector(0,0,0))
	self:SetMoveType(MOVETYPE_NONE)
	self:SetNotSolid(true)
	self:SetNoDraw(true)
	self:Fire("kill", "", 0.1)
end

function ENT:Touch(ent)
	if not ent:IsTrigger() then
		self:Hit(ent)
	end
end

end
