-- Syringe

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

PrecacheParticleSystem("nailtrails_medic_red")
PrecacheParticleSystem("nailtrails_medic_blue")
PrecacheParticleSystem("nailtrails_medic_red_crit")
PrecacheParticleSystem("nailtrails_medic_blue_crit")

PrecacheParticleSystem("stunballtrail_red_crit")
PrecacheParticleSystem("stunballtrail_blue_crit")

ENT.IsTFWeapon = true

function ENT:SetupDataTables()  
	self:DTVar("Int", 0, "ProjectileType")
	self:DTVar("Bool", 0, "Critical")
end  

function ENT:SetProjectileType(t)
	self.dt.ProjectileType = t
end

function ENT:ProjectileType()
	return self.dt.ProjectileType
end

function ENT:InitEffects()
	if self:ProjectileType()==3 then
		if SERVER then
			local mat
			if GAMEMODE:EntityTeam(self:GetOwner())==TEAM_BLU then
				mat = "Effects/arrowtrail_blu.vmt"
			elseif GAMEMODE:EntityTeam(self:GetOwner())==TF_TEAM_PVE_INVADERS then
				mat = "Effects/arrowtrail_blu.vmt"
			else
				mat = "Effects/arrowtrail_red.vmt"
			end
			
			self.Trail = util.SpriteTrail(self, 0, Color(255,255,255,200), false,
				0.1, 5, 0.1, 1/(5+1)*0.5, mat)
		end
		
		if self.dt.Critical then
			local effect = "stunballtrail_"..ParticleSuffix(GAMEMODE:EntityTeam(self:GetOwner())).."_crit"
			ParticleEffectAttach(effect, PATTACH_ABSORIGIN_FOLLOW, self, 0)
		end
		return
	end
	
	local effectname = "nailtrails_medic_blue_crit"
	
	local effect = "nailtrails_medic_"..ParticleSuffix(GAMEMODE:EntityTeam(self:GetOwner()))
	if self.dt.Critical then
		effect = effect.."_crit"
	end
	
	ParticleEffectAttach(effect, PATTACH_ABSORIGIN_FOLLOW, self, 0)
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

ENT.Models = {
	Model("models/weapons/w_models/w_syringe_proj.mdl"),
	Model("models/weapons/c_models/c_leechgun/c_leech_proj.mdl"),
	Model("models/weapons/w_models/w_syringe.mdl"),
}

ENT.BaseDamage = 10
ENT.DamageRandomize = 0.1
ENT.MaxDamageRampUp = 0.2
ENT.MaxDamageFalloff = 0.5
ENT.DamageModifier = 1

ENT.HitboxSize = 0.5

ENT.CritDamageMultiplier = 3

ENT.BaseSpeed = 1650

function ENT:OnInitAttribute(att)
	if att.attribute_class == "add_onhit_addhealth" then
		self:SetProjectileType(2)
	elseif att.attribute_class == "radial_onhit_addhealth" then
		self:SetProjectileType(3)
	end
end

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
	
	self:SetModel(self.Models[self:ProjectileType()] or self.Models[1])
	
	if self:ProjectileType()==2 then
		self.NameOverride = "tf_projectile_blutsauger"
	end
	
	self:SetMoveType(MOVETYPE_FLYGRAVITY)
	self:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
	self:SetCollisionBounds(min, max)
	self:SetSolid(SOLID_BBOX)
	self:SetTrigger(true)
	
	--self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	self:SetNotSolid(true)
	 
	self:SetLocalVelocity(self:GetForward() * self.BaseSpeed)
	
	if GAMEMODE:EntityTeam(self:GetOwner()) == TEAM_BLU then
		self:SetSkin(1)
	elseif GAMEMODE:EntityTeam(self:GetOwner()) == TF_TEAM_PVE_INVADERS then
		self:SetSkin(1)
	end
	
	self:InitEffects()
	
	if self:ProjectileType()==3 then
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Right(), -90)
		self:SetAngles(ang)
	end
end

function ENT:Think()
	if self:ProjectileType()==3 then
		local ang = self:GetVelocity():Angle()
		ang:RotateAroundAxis(ang:Right(), -90)
		self:SetAngles(ang)
	else
		self:SetAngles(self:GetVelocity():Angle())
	end
end

function ENT:Hit(ent)
	self.Touch = nil
	
	if ent:IsWorld() then
		local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetAngles(self:GetAngles())
			effectdata:SetMagnitude(self:GetSkin())
			effectdata:SetAttachment(self:ProjectileType()-1)
		util.Effect("tf_syringe_stuck", effectdata)
	end

	local owner = self:GetOwner()
	if not owner or not owner:IsValid(self.WModel2) then owner = self end
	
	local damage = self:CalculateDamage(owner:GetPos())
	local dir = self:GetVelocity():GetNormal()
	
	self:FireBullets{
		Src=self:GetPos(),
		Attacker=owner,
		Dir=dir,
		Spread=Vector(0,0,0),
		Num=1,
		Damage=damage,
		Tracer=0,
		HullSize=self.HitboxSize,
	}
	
	if IsValid(self.Trail) then
		self.Trail:SetParent()
		self.Trail:Fire("kill", "", 1)
	end
	
	self:Fire("kill", "", 0.01)
end

function ENT:Touch(ent)
	if not ent:IsTrigger() and GAMEMODE:ShouldCollide(self, ent) then
		self:Hit(ent)
	end
end

end
