if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

SWEP.PrintName			= "DM Rocket Launcher"
SWEP.Slot				= 3
SWEP.RenderGroup = RENDERGROUP_BOTH
SWEP.HasCModel = true
end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/v_models/v_rocketlauncher_dm.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_rocketlauncher_dm.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.MuzzleEffect = "muzzle_pipelauncher"

SWEP.ShootSound = Sound("weapons/rocket_dm_shoot.wav")
SWEP.ShootSoundLevel = 94
SWEP.ShootCritSound = Sound("weapons/rocket_dm_shoot_crit.wav")
SWEP.ReloadSound = "weapons/quake_rpg_reload_remastered.wav"
SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8

SWEP.IsRapidFire = false
SWEP.ReloadSingle = true

SWEP.HoldType = "PRIMARY"
SWEP.HoldTypeHL2 = "rpg"

SWEP.ProjectileShootOffset = Vector(0, 13, -4)

SWEP.PunchView = Angle( 0, 0, 0 )

SWEP.Properties = {}

function SWEP:ShootProjectile()
	if SERVER then
		local rocket = ents.Create("tf_projectile_rocket")
		rocket:SetPos(self:ProjectileShootPos())
		rocket:SetAngles(self.Owner:EyeAngles())
		
		if self:Critical() then
			rocket.critical = true
		end
		
		for k,v in pairs(self.Properties) do
			rocket[k] = v
		end
		
		rocket:SetOwner(self.Owner)
		self:InitProjectileAttributes(rocket)
		rocket.NameOverride = "env_explosion"
		
		rocket:Spawn()
		rocket:Activate()
	end
	
	self:ShootEffects()
end

