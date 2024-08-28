if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Shotgun"
	SWEP.Slot				= 0
end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_engineer_arms.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_frontierjustice.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.MuzzleEffect = "muzzle_shotgun"
SWEP.MuzzleOffset = Vector(20, 4, -3)

SWEP.ShootSound = Sound("Weapon_FrontierJustice.Single")
SWEP.ShootCritSound = Sound("Weapon_FrontierJustice.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_Shotgun.WorldReload")

SWEP.TracerEffect = "bullet_shotgun_tracer01"
PrecacheParticleSystem("bullet_shotgun_tracer01_red")
PrecacheParticleSystem("bullet_shotgun_tracer01_red_crit")
PrecacheParticleSystem("bullet_shotgun_tracer01_blue")
PrecacheParticleSystem("bullet_shotgun_tracer01_blue_crit")
PrecacheParticleSystem("muzzle_shotgun")

SWEP.BaseDamage = 9
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

SWEP.PunchView = Angle( -2, 0, 0 )

SWEP.ReloadSingle = true

SWEP.HoldType = "PRIMARY"

function SWEP:Deploy()

	for k,v in ipairs(ents.FindByClass("obj_sentrygun")) do
		if v:GetOwner() == self.Owner then
			if v:Health() <= 80 then
				if SERVER then
					GAMEMODE:StartCritBoost(self.Owner)
					
					ParticleEffectAttach("soldierbuff_red_buffed", PATTACH_ABSORIGIN_FOLLOW, self.Owner, 0)
				end
			end
		end
	end
	
	if self:CanPrimaryAttack() == false then
		if SERVER then
			if GAMEMODE:StopCritBoost(self.Owner) then
			
				self.Owner:StopParticlesNamed("soldierbuff_red_buffed")
				self.Owner:StopParticlesNamed("soldierbuff_blue_buffed")
				
			end
		end
	end
	return self:CallBaseFunction("Deploy")
end