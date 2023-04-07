if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then

SWEP.PrintName			= "Shotgun Versus Mode"
SWEP.Slot				= 2
SWEP.RenderGroup		= RENDERGROUP_BOTH

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_shotgun.mdl"
SWEP.WorldModel			= "models/weapons/w_shotgun.mdl"
SWEP.Crosshair = "tf_crosshair2"

SWEP.MuzzleEffect = "muzzle_revolver"
SWEP.MuzzleOffset = Vector(20, 4, -2)

SWEP.ShootSound = Sound("Weapon_Shotgun.Single")
SWEP.ShootCritSound = Sound("Weapon_Shotgun.Double")
SWEP.ReloadSound = Sound("Weapon_Shotgun.Reload")

SWEP.TracerEffect = "bullet_pistol_tracer01"
PrecacheParticleSystem("bullet_pistol_tracer01_red")
PrecacheParticleSystem("bullet_pistol_tracer01_blue")
PrecacheParticleSystem("bullet_pistol_tracer01_red_crit")
PrecacheParticleSystem("bullet_pistol_tracer01_blue_crit")
PrecacheParticleSystem("muzzle_revolver")

SWEP.BaseDamage = 9
SWEP.DamageRandomize = 0
SWEP.MaxDamageRampUp = 0.5
SWEP.MaxDamageFalloff = 0.52
SWEP.BulletsPerShot = 6
SWEP.BulletSpread = 0.1

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 0.9
SWEP.ReloadTime = 0.4

SWEP.HoldType = "SECONDARY"
SWEP.HoldTypeHL2 = "revolver"

SWEP.DeploySound = Sound("weapons/draw_secondary.wav")


SWEP.IsRapidFire = false

-- Ambassador properties
SWEP.AccuracyRecoveryStartDelay = 0.5
SWEP.AccuracyRecoveryDelay = 0.75

SWEP.MinSpread = 0
SWEP.MaxSpread = 0.06
SWEP.CrosshairMaxScale = 3
SWEP.ReloadSingle = true
SWEP.UseHands = true
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 0.9)
	timer.Simple(0.25, function()
		self:SendWeaponAnim( ACT_SHOTGUN_PUMP )
		self:EmitSound("Weapon_Shotgun.Special1")
	end)
	return self:CallBaseFunction("PrimaryAttack")
end