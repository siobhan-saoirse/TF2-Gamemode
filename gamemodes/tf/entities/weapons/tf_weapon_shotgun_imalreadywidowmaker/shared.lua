if SERVER then 
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Widowmaker"
SWEP.Slot				= 0
end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_engineer_arms.mdl"
SWEP.WorldModel			= "models/workshop_partner/weapons/c_models/c_dex_shotgun/c_dex_shotgun.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.MuzzleEffect = "muzzle_shotgun"
SWEP.MuzzleOffset = Vector(20, 4, -3)

SWEP.ShootSound = Sound("weapons/shotgun_shoot.wav")
SWEP.ShootCritSound = Sound("Weapon_Shotgun.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_WidowMaker.Cock_Forward")

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

SWEP.Primary.ClipSize		= -1
SWEP.Primary.Ammo			= TF_METAL
SWEP.Primary.Delay          = 0.6
SWEP.ReloadTime = 0.5

SWEP.PunchView = Angle( -2, 0, 0 )

SWEP.ReloadSingle = true

SWEP.HoldType = "PRIMARY"

function SWEP:CanPrimaryAttack()
	if (self:Ammo1() > 0) then
		return true
	end
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:EmitSound("Weapon_WidowMaker.Empty")
	return false
end

function SWEP:InspectAnimCheck()
	self:CallBaseFunction("InspectAnimCheck") 
	self.VM_PRIMARYATTACK = ACT_VM_PRIMARYATTACK_SPECIAL
end

function SWEP:PrimaryAttack()
	self:StopTimers()

	if not self:CallBaseFunction("PrimaryAttack") then return false end
	
	if self.Owner:GetMaterial() == "models/shadertest/predator" then return end
	
	auto_reload = self.Owner:GetInfoNum("tf_righthand", 1)
	
	self:SendWeaponAnim(self.VM_PRIMARYATTACK)
	self.Owner:DoAttackEvent()
	
	self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
	if self then
	end
	self:ShootProjectile(self.BulletsPerShot, self.BulletSpread)
	if SERVER then
	self.Owner:RemoveAmmo(40, self.Primary.Ammo, false)
	umsg.Start("PlayerMetalBonus", self.Owner)
		umsg.Short(-40)
	umsg.End()
	end
	
	self:RollCritical() -- Roll and check for criticals first
	
	self.Owner:ViewPunch( self.PunchView )
	
	self.NextReloadStart = nil
	self.NextReload = nil
	self.Reloading = false
	
	return true
end
