if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.HeadshotScore = 1
end

SWEP.PrintName			= "Crusader's Crossbow"
SWEP.Category			= "Team Fortress 2"
SWEP.Spawnable 			= true
if CLIENT then

SWEP.Slot				= 0

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_medic_arms_empty.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_crusaders_crossbow/c_crusaders_crossbow.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.MuzzleEffect = ""

SWEP.ShootSound = Sound("Weapon_CompoundBow.Single")
SWEP.ShootCritSound = Sound("Weapon_CompoundBow.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_SyringeGun.WorldReload")

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 0.15
SWEP.ReloadTime = 1.45

SWEP.IsRapidFire = false
SWEP.ReloadSingle = false

SWEP.HoldType = "PRIMARY"
SWEP.HoldTypeHL2 = "crossbow"

SWEP.ProjectileShootOffset = Vector(0, 8, -4)

function SWEP:ShootProjectile()
	if SERVER then
		local syringe = ents.Create("tf_projectile_arrow_heal")
		local ang = self.Owner:EyeAngles()
		local vec = ang:Forward()
		
		--local vec = ang:Forward() + math.Rand(-self.BulletSpread,self.BulletSpread) * ang:Right() + math.Rand(-self.BulletSpread,self.BulletSpread) * ang:Up()
		
		syringe:SetPos(self:ProjectileShootPos())
		syringe:SetAngles(vec:Angle())
		if self:Critical() then
			syringe.critical = true
		end
		syringe:SetOwner(self.Owner)
		--syringe:SetProjectileType(1)
		
		self:InitProjectileAttributes(syringe)
		
		syringe.NameOverride = self:GetItemData().item_iconname
		syringe:Spawn()
	end
	
	self:ShootEffects()
end
