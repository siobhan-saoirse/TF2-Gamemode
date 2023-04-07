if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

SWEP.PrintName			= "Tranqulizer Gun"
SWEP.Slot				= 1

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/v_models/v_tranq_spy.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_tranq.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.MuzzleEffect = "muzzle_syringe"
PrecacheParticleSystem("muzzle_syringe")

SWEP.ShootSound = Sound("Weapon_Tranq.Single")
SWEP.ShootCritSound = Sound("Weapon_Tranq.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_Tranq.WorldReload")

SWEP.BaseDamage = 15
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0.7
SWEP.MaxDamageFalloff = 0.5

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_SECONDARY
SWEP.Primary.Delay          = 0.5
SWEP.ReloadTime = 1.5

SWEP.BulletSpread = 0.02

SWEP.IsRapidFire = true
SWEP.ReloadSingle = false

SWEP.HoldType = "PRIMARY"

SWEP.HoldTypeHL2 = "ar2"

SWEP.ProjectileShootOffset = Vector(40, 8, -5)

function SWEP:ShootProjectile()
	if SERVER then
		local syringe = ents.Create("tf_projectile_syringe")
		local ang = self.Owner:EyeAngles()
		local vec = ang:Forward() + math.Rand(-self.BulletSpread,self.BulletSpread) * ang:Right() + math.Rand(-self.BulletSpread,self.BulletSpread) * ang:Up()
		
		syringe:SetPos(self:ProjectileShootPos())
		syringe:SetAngles(vec:Angle())
		if self:Critical() then
			syringe.critical = true
		end
		syringe:SetOwner(self.Owner)
		--syringe:SetProjectileType(1)
		syringe.BaseDamage = self.BaseDamage
		self:InitProjectileAttributes(syringe)
		
		syringe:Spawn()
		syringe:SetModel("models/weapons/w_models/w_dart_proj.mdl")
	end
	
	self:ShootEffects()
end
