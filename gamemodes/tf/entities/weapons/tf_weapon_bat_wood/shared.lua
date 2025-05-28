if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Sandman"
end
SWEP.Base				= "tf_weapon_melee_base"

SWEP.Slot				= 2
SWEP.ViewModel			= "models/weapons/v_models/v_bat_scout.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_wooden_bat/c_wooden_bat.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Spawnable = true
SWEP.Adminonly = true
SWEP.Category = "Team Fortress 2"

SWEP.Swing = Sound("Weapon_Bat.Miss")
SWEP.SwingCrit = Sound("Weapon_Bat.MissCrit")
SWEP.HitFlesh = Sound("Weapon_BaseballBat.HitFlesh")
SWEP.HitRobot = Sound("MVM_Weapon_BaseballBat.HitFlesh")
SWEP.HitWorld = Sound("Weapon_BaseballBat.HitWorld")

SWEP.BaseDamage = 45
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay          = 0.5
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay          = 10

SWEP.HoldType = "MELEE"
SWEP.HasThirdpersonCritAnimation = false

SWEP.ProjectileShootOffset = Vector(0, 7, -6)
SWEP.Force = 1500
SWEP.AddPitch = 1

function SWEP:Think()
	self.BaseClass.Think(self)
	self.VM_DRAW = ACT_VM_DRAW_SPECIAL
	self.VM_IDLE = ACT_VM_IDLE_SPECIAL
	self.VM_HITCENTER = ACT_VM_HITCENTER_SPECIAL
	self.VM_SWINGHARD = ACT_VM_HITCENTER_SPECIAL
	self.VM_INSPECT_START = ACT_MELEE_VM_INSPECT_START
	self.VM_INSPECT_IDLE = ACT_MELEE_VM_INSPECT_IDLE
	self.VM_INSPECT_END = ACT_MELEE_VM_INSPECT_END
end


function SWEP:SecondaryAttack()
	self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_MELEE_SECONDARY)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_SPECIAL)
	self:SetNextPrimaryFire( CurTime() + 0.25 )
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	if SERVER then
		self.Owner:EmitSoundEx("Weapon_BaseballBat.HitBall")
		local grenade = ents.Create("tf_projectile_ball")
		grenade:SetPos(self:ProjectileShootPos())
		grenade:SetAngles(self.Owner:EyeAngles())
		
		if self:Critical() then
			grenade.critical = true
		end
		
		
		self:InitProjectileAttributes(grenade)
		
		grenade.NameOverride = self:GetItemData().item_iconname
		grenade:SetOwner(self.Owner)	
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
	
	self.NextIdle = CurTime() + self:SequenceDuration()
	self:StopTimers()
	self:ShootEffects()
end
