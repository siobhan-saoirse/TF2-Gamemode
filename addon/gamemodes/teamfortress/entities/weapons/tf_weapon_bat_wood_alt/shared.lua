if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Sandman 2"
SWEP.Slot				= 3
end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/v_models/v_bat_scout.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_wooden_bat/c_wooden_bat.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Swing = Sound("Weapon_BaseballBat.HitBall")
SWEP.SwingCrit = Sound("Weapon_Bat.MissCrit")
SWEP.HitFlesh = Sound("Weapon_BaseballBat.HitFlesh")
SWEP.HitWorld = Sound("Weapon_BaseballBat.HitWorld")

SWEP.BaseDamage = 65
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= 1
SWEP.Primary.Delay          = 10

SWEP.HoldType = "MELEE"

SWEP.ProjectileShootOffset = Vector(0, 7, -6)
SWEP.Force = 1100
SWEP.AddPitch = -4
function SWEP:InspectAnimCheck()
	self:CallBaseFunction("InspectAnimCheck")
	self.VM_DRAW = ACT_VM_DRAW_SPECIAL
	self.VM_IDLE = ACT_VM_IDLE_SPECIAL
	self.VM_HITCENTER = ACT_VM_HITCENTER_SPECIAL
	self.VM_SWINGHARD = ACT_VM_HITCENTER_SPECIAL
	self.VM_INSPECT_START = ACT_MELEE_VM_INSPECT_START
	self.VM_INSPECT_IDLE = ACT_MELEE_VM_INSPECT_IDLE
	self.VM_INSPECT_END = ACT_MELEE_VM_INSPECT_END
end


function SWEP:MeleeAttack()
	self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_MELEE_SECONDARY)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SPECIAL)
	if SERVER then
		self.Owner:EmitSound("Weapon_BaseballBat.HitBall")
		local grenade = ents.Create("tf_projectile_ball")
		grenade:SetPos(self:ProjectileShootPos())
		grenade:SetAngles(self.Owner:EyeAngles())
		
		if self:Critical() then
			grenade.critical = true
		end
		
		grenade:SetOwner(self.Owner)
		
		self:InitProjectileAttributes(grenade)
		
		grenade.NameOverride = self:GetItemData().item_iconname
		grenade:Spawn()
		
		local vel = self.Owner:GetAimVector():Angle()
		vel.p = vel.p + self.AddPitch
		vel = vel:Forward() * self.Force * (grenade.Mass or 10)
		
		if self.Owner.TempAttributes.ProjectileModelModifier == 1 then
			grenade:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-800,800),math.random(-800,800),math.random(-800,800)))
		else
			grenade:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(-2000,2000)))
		end
		grenade:GetPhysicsObject():ApplyForceCenter(vel)
	end
	
	self:StopTimers()
	self:ShootEffects()
end