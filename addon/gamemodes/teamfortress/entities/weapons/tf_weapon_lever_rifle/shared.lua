if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Lever Rifle"
SWEP.Slot				= 0
end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/v_models/v_leverrifle_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_leverrifle.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.MuzzleEffect = "muzzle_scattergun"
SWEP.MuzzleOffset = Vector(20, 4, -3)

SWEP.ShootSound = Sound("Weapon_Scatter_Gun.Single")
SWEP.ShootCritSound = Sound("Weapon_Scatter_Gun.SingleCrit")
SWEP.ReloadSound = Sound("TF_Weapon_Shotgun.Reload")

SWEP.TracerEffect = "bullet_scattergun_tracer01"

SWEP.BaseDamage = 6
SWEP.DamageRandomize = 0
SWEP.MaxDamageRampUp = 0.75
SWEP.MaxDamageFalloff = 0.5

SWEP.BulletsPerShot = 10
SWEP.BulletSpread = 0.0675

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 0.6
SWEP.ReloadTime = 0.625

SWEP.ReloadSingle = true

SWEP.HoldType = "PRIMARY"

SWEP.KnockbackForceOwner = 225

SWEP.KnockbackMaxForce = 600
SWEP.MinKnockbackDistance = 512
SWEP.KnockbackAddPitch = -30

function SWEP:OnEquipAttribute(a, owner)
	if a.attribute_class == "set_scattergun_no_reload_single" then
		self.ReloadSingle = false
		self.ReloadDiscardClip = true
	elseif a.attribute_class == "set_scattergun_has_knockback" then
		self.ScattergunHasKnockback = true
	end
end

function SWEP:SetupCModelActivities(item)
	if item then
		for _,a in pairs(item.attributes or {}) do
			if a.attribute_class == "set_scattergun_no_reload_single" and a.value == 1 then
				item = table.Copy(item)
				item.anim_slot = "ITEM2"
				self.HoldType = "ITEM2"
				self:SetWeaponHoldType("ITEM2")
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
