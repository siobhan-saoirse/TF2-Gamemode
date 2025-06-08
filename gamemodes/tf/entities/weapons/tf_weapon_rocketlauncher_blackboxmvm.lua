-- Real class name: tf_weapon_bet_rocketlauncher (see shd_items.lua)

if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then

SWEP.PrintName			= "The Black Box MVM Soldier"
SWEP.Slot				= 0
SWEP.HasCModel = true

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_soldier_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_bet_rocketlauncher/c_bet_rocketlauncher.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Spawnable = true
SWEP.Adminolny = false
SWEP.Category = "Team Fortress 2"

SWEP.MuzzleEffect = "muzzle_pipelauncher"

SWEP.ShootSound = Sound("Weapon_RPG_BlackBox.Single")
SWEP.ShootCritSound = Sound("Weapon_RPG_BlackBox.SingleCrit")
SWEP.CustomExplosionSound = Sound("Weapon_RPG_BlackBox.Explode")
SWEP.ReloadSound = Sound("Weapon_RPG.WorldReload")

SWEP.Primary.ClipSize		= 3
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay = 0.8 * 0
SWEP.ReloadTime = 0.8 * 0.9

SWEP.IsRapidFire = false
SWEP.ReloadSingle = true

SWEP.HoldType = "PRIMARY"

SWEP.ProjectileShootOffset = Vector(0, 13, -4)

SWEP.PunchView = Angle( 0, 0, 0 )

SWEP.Properties = {}

function SWEP:InspectAnimCheck()
	self:CallBaseFunction("InspectAnimCheck")
	self.VM_RELOAD_START = ACT_PRIMARY_RELOAD_START_2
	self.VM_RELOAD = ACT_PRIMARY_VM_RELOAD_2
	self.VM_RELOAD_FINISH = ACT_PRIMARY_RELOAD_FINISH_2
end

function SWEP:Deploy()
	self:CallBaseFunction("Deploy")
end

function SWEP:ShootProjectile()
	if SERVER then
		local rocket = ents.Create("tf_projectile_rocket")
		rocket:SetPos(self:ProjectileShootPos())
		local ang = self.Owner:EyeAngles()
		
		if self.WeaponMode == 1 then
			local charge = (CurTime() - self.ChargeStartTime) / self.ChargeTime
			rocket.Gravity = Lerp(1 - charge, self.MinGravity, self.MaxGravity)
			rocket.BaseSpeed = Lerp(charge, self.MinForce, self.MaxForce)
			ang.p = ang.p + Lerp(1 - charge, self.MinAddPitch, self.MaxAddPitch)
		end
		
		rocket:SetAngles(ang)
		
		if self:Critical() then
			rocket.critical = true
		end
		
		for k,v in pairs(self.Properties) do
			rocket[k] = v
		end
		
		rocket:SetOwner(self.Owner)
		self:InitProjectileAttributes(rocket)
		rocket.ExplosionSound = self.CustomExplosionSound
		
		rocket:Spawn()
		rocket:Activate()
	end
	
	self:ShootEffects()
end
