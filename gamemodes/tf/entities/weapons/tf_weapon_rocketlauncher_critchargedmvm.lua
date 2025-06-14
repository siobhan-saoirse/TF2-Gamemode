if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

SWEP.PrintName			= "Crit MVM Rocket Launcher"
SWEP.Slot				= 0

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/v_models/v_rocketlauncher_soldier.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_rocketlauncher.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Spawnable = true
SWEP.Adminonly = true
SWEP.Category = "Team Fortress 2"

SWEP.MuzzleEffect = "muzzle_pipelauncher"

SWEP.ShootSound = Sound("weapons/rocket_shoot.wav")
SWEP.ShootSoundLevel = 94
SWEP.ShootCritSound = Sound("Weapon_RPG.SingleCrit")

SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay = 0.8 * 0.6
SWEP.ReloadTime = 0.8 * -1.8

SWEP.IsRapidFire = false
SWEP.ReloadSingle = true

SWEP.HoldType = "PRIMARY"

SWEP.ProjectileShootOffset = Vector(0, 13, -4)

SWEP.PunchView = Angle( 0, 0, 0 )

SWEP.Properties = {}

SWEP.ChargeTime = 2
SWEP.MinForce = 150
SWEP.MaxForce = 2800 * 0.65
SWEP.CriticalChance = 100
SWEP.MinAddPitch = -1
SWEP.MaxAddPitch = -6

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
		rocket.BaseDamage = 95 * 2.0
		rocket.BaseSpeed = 1100 * 1
		self:InitProjectileAttributes(rocket)
		rocket.NameOverride = "tf_projectile_rocket_trolling"
		
		rocket:Spawn()
		rocket:Activate()
	end
	
	self:ShootEffects()
end
