if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

SWEP.PrintName			= "Mannmelter"
SWEP.HasCModel = true
SWEP.Slot				= 1

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_pyro_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_drg_manmelter/c_drg_manmelter.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.MuzzleEffect = ""

SWEP.ShootSound = Sound("weapons/man_melter_fire.wav")
SWEP.ShootCritSound = Sound("weapons/man_melter_fire_crit.wav")
SWEP.ReloadSound = Sound("Weapon_FlareGun.WorldReload")

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_SECONDARY
SWEP.Primary.Delay          = 4

SWEP.IsRapidFire = false
SWEP.ReloadSingle = false

SWEP.HoldType = "ITEM1"

SWEP.ProjectileShootOffset = Vector(0, 8, -5)

SWEP.PunchView = Angle( -2, 0, 0 )

function SWEP:InspectAnimCheck()
	self:CallBaseFunction("InspectAnimCheck")
	self.VM_DRAW = ACT_SECONDARY2_VM_DRAW
	self.VM_IDLE = ACT_SECONDARY2_VM_IDLE
	self.VM_PRIMARYATTACK = ACT_SECONDARY2_VM_PRIMARYATTACK
	self.VM_RELOAD = ACT_SECONDARY2_VM_RELOAD
end

function SWEP:PrimaryAttack()
	if self.NextIdle then return end
	
	if not self:CanPrimaryAttack() then
		return
	end
	
	self:SendWeaponAnim(self.VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	self:ShootProjectile()
	
	self.NextIdle = CurTime()+self.Primary.Delay
	
	self:TakePrimaryAmmo(1)
	
	self:StopTimers()
	
	self.Owner:ViewPunch( self.PunchView )
	
	self:RollCritical()
end

function SWEP:ShootProjectile()
	if SERVER then
		-- lol syringe
		
		local syringe = ents.Create("tf_projectile_flare")
		local ang = self.Owner:EyeAngles()
		
		syringe:SetPos(self:ProjectileShootPos())
		syringe:SetAngles(ang)
		syringe.Inflictor = self
		if self:Critical() then
			syringe.critical = true
		end
		syringe:SetOwner(self.Owner)
		self:InitProjectileAttributes(syringe)
		
		syringe.MannMelter = true

		syringe.NameOverride = self:GetItemData().item_iconname
		syringe:Spawn()
	end
	
	self:ShootEffects()
end

function SWEP:Think()
	self:TFViewModelFOV()

	if self.NextIdle and CurTime()>=self.NextIdle then
		self:SendWeaponAnim(self.VM_IDLE)
		self.NextIdle = nil
		self.IsDeployed = true	
	end
	
	self:Inspect()
end

local WeaponBodygroups = {
	shell = 1,
}

function SWEP:FireAnimationEvent(pos, ang, event, options)
	if event == 37 then
		local bodygroup, set = string.match(options, "(.-)%s+(%d+)")
		bodygroup = WeaponBodygroups[bodygroup or ""]
		set = tonumber(set)
		
		if bodygroup and set and IsValid(self.CModel) then
			self.CModel:SetBodygroup(bodygroup, set)
		end
	end
end
