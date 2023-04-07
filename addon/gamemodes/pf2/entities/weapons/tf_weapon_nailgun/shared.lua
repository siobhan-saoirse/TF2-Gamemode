if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

SWEP.PrintName			= "Nailgun"
SWEP.Slot				= 0

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/v_models/v_nailgun_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_nailgun.mdl"
SWEP.Crosshair = 		"tf_crosshair1"

SWEP.MuzzleEffect = "muzzle_pistol"

SWEP.ShootSound = Sound("weapons/nail_gun_shoot.wav")
SWEP.ShootCritSound = Sound("weapons/nail_gun_shoot_crit.wav")
SWEP.ReloadSound = Sound("weapons/pistol_worldreload.wav")

SWEP.Primary.ClipSize		= 50
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_METAL
SWEP.Primary.Delay          = 0.1

SWEP.BulletSpread = 0.01

SWEP.IsRapidFire = true
SWEP.ReloadSingle = false

SWEP.ReloadTime = 2.4	

SWEP.HoldType = "ITEM1"

SWEP.ProjectileShootOffset = Vector(0, 8, -5)

function SWEP:Deploy()
	if not self:CallBaseFunction("Deploy") then return end
	self:EmitSound("weapons/nail_gun_draw.wav", 90)
end

function SWEP:ShootProjectile()
	if SERVER then
		local syringe = ents.Create("tf_projectile_nail")
		local ang = self.Owner:EyeAngles()
		local vec = ang:Forward() + math.Rand(-self.BulletSpread,self.BulletSpread) * ang:Right() + math.Rand(-self.BulletSpread,self.BulletSpread) * ang:Up()
		
		syringe:SetPos(self:ProjectileShootPos())
		syringe:SetAngles(vec:Angle())
		if self:Critical() then
			syringe.critical = true
		end
		syringe:SetOwner(self.Owner)
		--syringe:SetProjectileType(1)
		
		self:InitProjectileAttributes(syringe)
		
		syringe:Spawn()
	end
	
	if self.Owner:GetInfoNum("tf_robot", 0) == 1 then
		self:SetHoldType("SECONDARY")
	end 
	if self.Owner:GetInfoNum("tf_giant_robot", 0) == 1 then
		self:SetHoldType("SECONDARY")
	end 
	self:ShootEffects()
end
