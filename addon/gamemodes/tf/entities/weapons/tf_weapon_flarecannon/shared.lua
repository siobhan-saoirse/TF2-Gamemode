if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

SWEP.PrintName			= "The Flare Gun"
SWEP.HasCModel = true
SWEP.Slot				= 1

function SWEP:InitializeCModel()
	self:CallBaseFunction("InitializeCModel")
	 
	if IsValid(self.CModel) then
		self.CModel:SetBodygroup(1, 1)
	end
end

function SWEP:InitializeWModel2()
	self:CallBaseFunction("InitializeWModel2")
	
	if IsValid(self.WModel2) then
		--self.WModel2:SetBodygroup(1, 1)
	end
end

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_pyro_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_flaregun_pyro/c_flaregun_pyro.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.MuzzleEffect = ""

SWEP.ShootSound = Sound(")weapons/flaregun_shoot.wav")
SWEP.ShootSoundLevel = 94
SWEP.ShootCritSound = Sound("Weapon_FlareGun.SingleCrit")

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_SECONDARY
SWEP.Primary.Delay          = 2.02

SWEP.IsRapidFire = false
SWEP.ReloadSingle = false

SWEP.HoldType = "ITEM1"

SWEP.ProjectileShootOffset = Vector(0, 8, -5)

SWEP.VM_DRAW = ACT_ITEM1_VM_DRAW
SWEP.VM_IDLE = ACT_ITEM1_VM_IDLE
SWEP.VM_PRIMARYATTACK = ACT_ITEM1_VM_PRIMARYATTACK
SWEP.VM_RELOAD = ACT_ITEM1_VM_RELOAD

function SWEP:PrimaryAttack()
	if self.NextIdle then return end
	
	if not self:CanPrimaryAttack() then
		return
	end
	
	self:SendWeaponAnim(self.VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	self:ShootProjectile()
	
	self.NextIdle = CurTime()+self:SequenceDuration()
	
	self:TakePrimaryAmmo(1)
	
	self:RollCritical()
end

function SWEP:ShootProjectile()
	if SERVER then
		local syringe = ents.Create("tf_projectile_rocket_flare")
		local ang = self.Owner:EyeAngles()
		
		syringe:SetPos(self:ProjectileShootPos())
		syringe:SetAngles(ang)
		syringe.Inflictor = self
		if self:Critical() then
			syringe.critical = true
		end
		syringe:SetOwner(self.Owner)
		syringe:Spawn()
	end
	
	self:ShootEffects()
end

function SWEP:Think()
	if self.NextIdle and CurTime()>=self.NextIdle then
		self:SendWeaponAnim(self.VM_IDLE)
		self.NextIdle = nil
	end
end