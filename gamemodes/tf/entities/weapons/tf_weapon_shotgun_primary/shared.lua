if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Slot				= 0 
if CLIENT then
	SWEP.PrintName			= "Shotgun"
end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_engineer_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_shotgun/c_shotgun.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.MuzzleEffect = "muzzle_shotgun"
SWEP.MuzzleOffset = Vector(20, 4, -3)

SWEP.ShootSound = Sound("weapons/shotgun_shoot.wav")
SWEP.ShootCritSound = Sound("Weapon_Shotgun.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_Shotgun.WorldReload")

SWEP.TracerEffect = "bullet_shotgun_tracer01"
PrecacheParticleSystem("bullet_shotgun_tracer01_red")
PrecacheParticleSystem("bullet_shotgun_tracer01_red_crit")
PrecacheParticleSystem("bullet_shotgun_tracer01_blue")
PrecacheParticleSystem("bullet_shotgun_tracer01_blue_crit")
PrecacheParticleSystem("muzzle_shotgun")

SWEP.BaseDamage = 6
SWEP.DamageRandomize = 4
SWEP.MaxDamageRampUp = 0.5
SWEP.MaxDamageFalloff = 0.5

SWEP.BulletsPerShot = 10
SWEP.BulletSpread = 0.0675

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 0.6
SWEP.ReloadTime = 0.5

SWEP.PunchView = Angle( -2, 0, 0 )

SWEP.ReloadSingle = true

SWEP.HoldType = "PRIMARY"

SWEP.HoldTypeHL2 = "shotgun"

function SWEP:Think()
	if self:GetItemData().model_player == "models/workshop/weapons/c_models/c_trenchgun/c_trenchgun.mdl" then
		if self:Health() <= self.Owner:GetMaxHealth() then
			self:SetNextPrimaryFire(CurTime() + self.Primary.Delay - self.Owner:Health() / 4 )
		end
	end
	self:CallBaseFunction("Think")
end

function SWEP:PrimaryAttack()
	self:CallBaseFunction("PrimaryAttack")
end