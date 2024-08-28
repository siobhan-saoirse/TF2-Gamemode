if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Pistol"
end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.Slot				= 1
SWEP.ViewModel			= "models/weapons/c_models/c_engineer_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_pistol/c_pistol.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.MuzzleEffect = "muzzle_pistol"
SWEP.MuzzleOffset = Vector(20, 4, -2)

SWEP.ShootSound = Sound("Weapon_Pistol.TF_Single")
SWEP.ShootCritSound = Sound("Weapon_Pistol.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_Pistol.WorldReloadEngineer")

SWEP.TracerEffect = "bullet_pistol_tracer01"
PrecacheParticleSystem("bullet_pistol_tracer01_red")
PrecacheParticleSystem("bullet_pistol_tracer01_red_crit")
PrecacheParticleSystem("bullet_pistol_tracer01_blue")
PrecacheParticleSystem("bullet_pistol_tracer01_blue_crit")
PrecacheParticleSystem("muzzle_pistol")

SWEP.BaseDamage = 8
SWEP.DamageRandomize = 0
SWEP.MaxDamageRampUp = 0.5
SWEP.MaxDamageFalloff = 0.5

SWEP.BulletsPerShot = 1
SWEP.BulletSpread = 0.04

SWEP.Primary.ClipSize		= 12
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_SECONDARY
SWEP.Primary.Delay          = 0.15
SWEP.ReloadTime = 1.2

SWEP.HoldType = "SECONDARY"

SWEP.HoldTypeHL2 = "pistol"

SWEP.IsRapidFire = true

function SWEP:InspectAnimCheck()
	self.BaseClass.InspectAnimCheck(self)
	if self.Owner:GetPlayerClass() == "scout" then
		self.ReloadSound = Sound("Weapon_Pistol.WorldReload")
	end
	if self.Owner:GetPlayerClass() == "merc_dm" then
		self:SetHoldType("SECONDARY2") 
		self.ReloadTime = 2
		self.Primary.ClipSize		= 15
		self.ShootSound = Sound("weapons/pistol_dm_shoot.wav")
		self.ShootCritSound = Sound("weapons/pistol_dm_shoot_crit.wav")
		self.ReloadSound = Sound("weapons/pistol_worldreload_merc.wav")
		if CLIENT then
			self.RenderGroup = RENDERGROUP_BOTH
			
			self.ViewModel = "models/weapons/v_models/v_pistol_mercenary.mdl"
			self.WorldModel			= "models/weapons/w_models/w_pistol_mercenary.mdl"
			self:SetModel("models/weapons/v_models/v_pistol_mercenary.mdl")
		end
		
		self.ViewModel = "models/weapons/v_models/v_pistol_mercenary.mdl"
		self.WorldModel			= "models/weapons/w_models/w_pistol_mercenary.mdl"
		self:SetModel("models/weapons/v_models/v_pistol_mercenary.mdl")
	end
end