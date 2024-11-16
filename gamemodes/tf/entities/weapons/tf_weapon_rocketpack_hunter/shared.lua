if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then

SWEP.PrintName			= "Thermal Thruster"
SWEP.HasCModel = true
SWEP.Slot				= 1

end

SWEP.Base				= "tf_weapon_base"

SWEP.ViewModel			= "models/weapons/arms/v_jockey_arms.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_flaregun_shell.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.MuzzleEffect = ""

SWEP.ShootSound = ""
SWEP.ShootCritSound = ""

SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 1.5

SWEP.ReloadSingle = true

SWEP.ReloadTime = 0.1

SWEP.ReloadSound = ""

SWEP.HasCustomMeleeBehaviour = true

SWEP.ProjectileShootOffset = Vector(0, 0, 0)

SWEP.Force = 800
SWEP.AddPitch = -4

function SWEP:Think()
	self:CallBaseFunction("Think")
end

function SWEP:PredictCriticalHit()
end

function SWEP:PrimaryAttack()	
	if not self:CallBaseFunction("PrimaryAttack") then return false end
	self:SetNextPrimaryFire(CurTime() + 1.5)
	if self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() ) == 0 then
		return
	end

	-- Obsolete
end
