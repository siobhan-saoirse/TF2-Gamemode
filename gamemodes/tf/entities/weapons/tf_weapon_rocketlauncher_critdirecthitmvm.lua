-- Real class name: tf_weapon_rocketlauncher_directhit (see shd_items.lua)

if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then

SWEP.PrintName			= "Crit Direct Hit "
SWEP.Slot				= 0
SWEP.HasCModel = true

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_soldier_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_directhit/c_directhit.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "Team Fortress 2"

SWEP.MuzzleEffect = "muzzle_pipelauncher"

SWEP.ShootSound = Sound("Weapon_RPG_DirectHit.Single")
SWEP.ShootCritSound = Sound("Weapon_RPG_DirectHit.SingleCrit")
SWEP.ReloadSound = Sound("")
SWEP.CustomExplosionSound = Sound("Weapon_RPG_DirectHit.Explode")

SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8

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
		
		--rocket.FastRocket = true
		for k,v in pairs(self.Properties) do
			rocket[k] = v
		end
		
		rocket:SetOwner(self.Owner)
		self:InitProjectileAttributes(rocket)
		
		rocket.NameOverride = self:GetItemData().item_iconname or self.NameOverride 
		rocket.ExplosionSound = self.CustomExplosionSound
		
		if (self.ProjectileDamageMultiplier) then
			rocket.OldBaseDamage = rocket.BaseDamage
			rocket.BaseDamage = rocket.OldBaseDamage * self.ProjectileDamageMultiplier
		end
		rocket:Spawn()
		rocket:Activate()
	end
	
	self:ShootEffects()
end
