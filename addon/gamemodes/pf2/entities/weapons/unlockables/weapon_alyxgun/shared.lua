
if SERVER then

AddCSLuaFile("shared.lua")
SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

end

if CLIENT then

SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
SWEP.PrintName			= "Alyx's Gun"

end

list.GetForEdit("NPCWeapons").weapon_alyxgun = "Alyx's Gun"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 30
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AlyxGun"
SWEP.Primary.Delay			= 0.1
SWEP.Primary.Damage			= 10
SWEP.Primary.Spread			= 0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.HoldType				= "pistol"

SWEP.ViewModel			= "models/weapons/v_357.mdl"
SWEP.WorldModel			= "models/weapons/W_Alyx_Gun.mdl"

function SWEP:Initialize()
	if SERVER then
		self:SetNPCMinBurst(1)
		self:SetNPCMaxBurst(6)
		self:SetNPCFireRate(self.Primary.Delay)
	end
	
	self:SetWeaponHoldType(self.HoldType)
	
	if file.Exists("../sound/weapons/alyx_gun/alyx_gun_fire3.wav", "GAME") then
		self.ShootSound = Sound("Weapon_Alyx_Gun.NPC_Single")
	else
		self.ShootSound = Sound("Weapon_Pistol.NPC_Single")
	end
end

function SWEP:Deploy()
	if SERVER and self.Owner:IsNPC() then
		self.Owner:SetCurrentWeaponProficiency(4)
	end
	
	return true
end

function SWEP:Reload()
	self:DefaultReload(ACT_VM_RELOAD)
end

function SWEP:Think()	
end

function SWEP:PrimaryAttack()
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay )
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay )
	
	if not self:CanPrimaryAttack() then return end
	
	self:EmitSound(self.ShootSound)
	
	self:ShootBullet()
	self:TakePrimaryAmmo(1)
end

function SWEP:ShootBullet()
	self.Owner:FireBullets{
		Num = 1,
		Src = self.Owner:GetShootPos(),
		Dir = self.Owner:GetAimVector(),
		Spread = Vector(self.Primary.Spread, self.Primary.Spread, 0),
		Tracer = 4,
		Force = 5,
		Damage = self.Primary.Damage
	}
	
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
end

function SWEP:SecondaryAttack()
	return
end
