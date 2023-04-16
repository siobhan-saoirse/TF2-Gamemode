if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Scattergun"
SWEP.Slot				= 0
end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_scout_arms_empty.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_scattergun.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.MuzzleEffect = "muzzle_scattergun"
SWEP.MuzzleOffset = Vector(20, 4, -3)

SWEP.ShootSound = Sound("Weapon_Scatter_Gun.Single")
SWEP.ShootCritSound = Sound("Weapon_Scatter_Gun.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_Scatter_Gun.WorldReload")
SWEP.DeploySound = Sound("weapons/draw_secondary.wav")

SWEP.TracerEffect = "bullet_scattergun_tracer01"
PrecacheParticleSystem("bullet_scattergun_tracer01_red")
PrecacheParticleSystem("bullet_scattergun_tracer01_red_crit")
PrecacheParticleSystem("bullet_scattergun_tracer01_blue")
PrecacheParticleSystem("bullet_scattergun_tracer01_blue_crit")
PrecacheParticleSystem("muzzle_scattergun")


SWEP.BaseDamage = 12
SWEP.DamageRandomize = 0	
SWEP.MaxDamageRampUp = 0.5
SWEP.MaxDamageFalloff = 0.5

SWEP.BulletsPerShot = 10
SWEP.BulletSpread = 0.0675

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 0.6
SWEP.ReloadTime = 0.5

SWEP.ReloadSingle = true

SWEP.HoldType = "PRIMARY"

SWEP.HoldTypeHL2 = "shotgun"

SWEP.KnockbackForceOwner = 225

SWEP.KnockbackMaxForce = 600
SWEP.MinKnockbackDistance = 512
SWEP.KnockbackAddPitch = -30

SWEP.PunchView = Angle( -2, 0, 0 )

function SWEP:OnEquipAttribute(a, owner)
	if a.attribute_class == "set_scattergun_no_reload_single" then
		self.ReloadSingle = false
		self.ReloadDiscardClip = true
	elseif a.attribute_class == "set_scattergun_has_knockback" then
		self.ScattergunHasKnockback = true
		self.ReloadTime = 1.6
	end
end


function SWEP:CanPrimaryAttack()
	if (self.Primary.ClipSize == -1 and self:Ammo1() > 0) or self:Clip1() > 0 then
		return true
	end
	return false
end

function SWEP:SetupCModelActivities(item)
	if item then
		for _,a in pairs(item.attributes or {}) do
			if a.attribute_class == "set_scattergun_no_reload_single" and a.value == 1 then
				item = table.Copy(item)
				break
			end
		end
	end
	
	return self:CallBaseFunction("SetupCModelActivities", item)
end

if SERVER then

function SWEP:DoOwnerKnockback()
	if self.Owner:OnGround() then return end
	if self.Owner.KnockbackJumpsRemaining and self.Owner.KnockbackJumpsRemaining <= 0 then return end
	
	local vel = self.Owner:GetVelocity()
	local dir = self.Owner:GetAimVector()
	local work = vel:Dot(dir)
	--if work < 0 then work = 0 end
	
	local force = self.KnockbackForceOwner + work
	if force < 0 then force = 0 end
	
	self.Owner:SetVelocity(-force * dir)
	
	self.Owner.KnockbackJumpsRemaining = (self.Owner.KnockbackJumpsRemaining or 1) - 1
	self.Owner:SetThrownByExplosion(true)
end

hook.Add("OnPlayerHitGround", "TFKnockbackJumpsReset", function(pl)
	pl.KnockbackJumpsRemaining = 1
end)

hook.Add("PostScaleDamage", "TFKnockbackDamage", function(ent, hitgroup, dmginfo)
	local inf = dmginfo:GetInflictor()
	local att = dmginfo:GetAttacker()
	
	if inf.ScattergunHasKnockback and not ent:IsThrownByExplosion() then
		local dist = inf:GetPos():Distance(ent:GetPos())
		if dist < inf.MinKnockbackDistance then
			if not inf.MaxKnockbackDamage then
				inf.MaxKnockbackDamage = inf.BaseDamage * (1 + inf.MaxDamageRampUp + inf.DamageRandomize) * inf.BulletsPerShot
			end
			
			local force = inf.KnockbackMaxForce * dmginfo:GetDamage() / inf.MaxKnockbackDamage
			local ang = att:EyeAngles()
			ang.p = ang.p + inf.KnockbackAddPitch
			
			ent:SetGroundEntity(NULL)
			ent:SetVelocity(ang:Forward() * force)
			ent:SetThrownByExplosion(true)
		end
	end
end)

end



function SWEP:PrimaryAttack()
	if not self:CallBaseFunction("PrimaryAttack") then return end
	
	if SERVER and self.ScattergunHasKnockback then
		self:DoOwnerKnockback()
	end
	
	return
end
