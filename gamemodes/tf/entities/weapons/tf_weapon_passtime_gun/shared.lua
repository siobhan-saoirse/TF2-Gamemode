if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Jack"
SWEP.Slot				= 5
end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_sniper_arms.mdl"
SWEP.WorldModel			= "models/passtime/ball/passtime_ball.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Swing = Sound("Weapon_Shovel.Miss")
SWEP.SwingCrit = Sound("Weapon_Shovel.MissCrit")
SWEP.HitFlesh = Sound("Weapon_Shovel.HitFlesh")
SWEP.HitWorld = Sound("Weapon_Shovel.HitWorld")

local SpeedTable = {
{40, 1.6},
{80, 1.4},
{120, 1.2},
{160, 1.1},
}

SWEP.MinDamage = 0.5
SWEP.MaxDamage = 1.75

SWEP.BaseDamage = 65
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8
SWEP.Ball					= 1

SWEP.CanInspect = false

SWEP.VM_DRAW = ACT_BALL_VM_PICKUP
SWEP.VM_IDLE = ACT_BALL_VM_IDLE
SWEP.VM_THROWBALL = ACT_BALL_VM_THROW_START
SWEP.VM_RELOAD = ACT_BALL_VM_CATCH

SWEP.AddPitch = 0
SWEP.ProjectileShootOffset = Vector(0, 7, -6)
SWEP.Force = 1100

SWEP.CriticalChance = 0

SWEP.HoldType = "PASSTIME"

function SWEP:InspectAnimCheck()

	self.VM_DRAW = ACT_BALL_VM_PICKUP
	self.VM_IDLE = ACT_BALL_VM_IDLE
	self.VM_HITCENTER = ACT_BALL_VM_THROW_START
	self.VM_SWINGHARD = ACT_BALL_VM_THROW_END
	self:CallBaseFunction("InspectAnimCheck")
end
function SWEP:Think()
	self:CallBaseFunction("Think")
	
	if self.Owner:GetPlayerClass() == "scout" then
		self.Primary.Delay = 0.5
	else
		self.Primary.Delay = 0.80
	end
end

function SWEP:PrimaryAttack()
	if self.Ball == 0 then
		return
	end

	self:SendWeaponAnim(self.VM_HITCENTER)
	self.Owner:DoAttackEvent()
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	self.NextIdle = ni
	
	self:ShootProjectile(self.BulletsPerShot, self.BulletSpread)
		
	self:StopTimers()
	
	self.Ball = 0
	
	return true
end

function SWEP:ShootProjectile()
	timer.Simple(0.26, function()
		if IsValid(self) then 
			self:SendWeaponAnim(self.VM_SWINGHARD)
		end
	end)

	timer.Simple(0.46, function() 
		if IsValid(self) then 
			if SERVER then
				local grenade = ents.Create("tf_projectile_passtime_ball")
				grenade:SetModel("models/passtime/ball/passtime_ball.mdl")
				grenade:SetPos(self:ProjectileShootPos())
				grenade:SetAngles(self.Owner:EyeAngles())		

		
				self:InitProjectileAttributes(grenade)
		
				grenade.NameOverride = self:GetItemData().item_iconname
				grenade:Spawn()
		
				local vel = self.Owner:GetAimVector():Angle()
				vel.p = vel.p + self.AddPitch
				vel = vel:Forward() * self.Force * (grenade.Mass or 10)
		
				grenade:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(-2000,2000)))
			
				grenade:GetPhysicsObject():ApplyForceCenter(vel)
				self.Owner:EmptyLoadoutSlot("pda2")
			end
		end
	end)
end

function SWEP:OnDrop()
	self.Ball = 1
	//self:Remove()
	
	//self:SetPos(self:ProjectileShootPos())
	//self:SetAngles(self.Owner:EyeAngles())
	
	//local vel = self.Owner:GetAimVector():Angle()
	//vel.p = vel.p + self.AddPitch
	//vel = vel:Forward() * self.Force * (grenade.Mass or 10)
	
	self:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(-2000,2000)))
		
	self:GetPhysicsObject():ApplyForceCenter(Vector(math.random(-2000,2000)))
	
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_CUSTOM)
	self:SetMoveCollide(MOVECOLLIDE_FLY_SLIDE)
end

function SWEP:OnRemove()
	
end