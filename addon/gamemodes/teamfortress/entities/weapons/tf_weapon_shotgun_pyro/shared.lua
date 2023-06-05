if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Slot				= 1
if CLIENT then
	SWEP.PrintName			= "Shotgun"
end

SWEP.Base				= "tf_weapon_gun_base"
SWEP.HasCModel 			= true
SWEP.ViewModel			= "models/weapons/c_models/c_pyro_arms_empty.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_shotgun/c_shotgun.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.MuzzleEffect = "muzzle_shotgun"
SWEP.MuzzleOffset = Vector(20, 4, -3)

SWEP.ShootSound = Sound("weapons/shotgun_shoot.wav")
SWEP.ShootCritSound = Sound("Weapon_Shotgun.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_Shotgun.WorldReload")

SWEP.TracerEffect = "bullet_shotgun_tracer01"
PrecacheParticleSystem("bullet_shotgun_tracer01_red")
PrecacheParticleSystem("bullet_shotgun_tracer01_red_crit")
PrecacheParticleSystem("bullet_shotgun_tracer01_blue")
PrecacheParticleSystem("bullet_shotgun_tracer01_blue_crit")
PrecacheParticleSystem("muzzle_shotgun")

SWEP.BaseDamage = 6
SWEP.DamageRandomize = 1
SWEP.MaxDamageRampUp = 3
SWEP.MaxDamageFalloff = 3

SWEP.BulletsPerShot = 10
SWEP.BulletSpread = 0.0675

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_SECONDARY
SWEP.Primary.Delay          = 0.625
SWEP.ReloadTime = 0.5

SWEP.PunchView = Angle( -2, 0, 0 )

SWEP.ReloadSingle = true

SWEP.HoldType = "SECONDARY"
function SWEP:PrimaryAttack()
	
	if self.Owner:GetInfoNum("tf_robot", 0) == 1 then
	self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_SECONDARY)
	end
	return self:CallBaseFunction("PrimaryAttack")
end
function SWEP:Reload()
	self:StopTimers()
	if CLIENT and _G.NOCLIENTRELOAD then return end
	
	if self.NextReloadStart or self.NextReload or self.Reloading then return end
	
	if self.RequestedReload then
		if self.Delay and CurTime() < self.Delay then
			return false
		end
	else
		--MsgN("Requested reload!")
		self.RequestedReload = true
		return false
	end
	
	self.CanInspect = false
	
	--MsgN("Reload!")
	self.RequestedReload = false
	
	if self.Primary and self.Primary.Ammo and self.Primary.ClipSize ~= -1 then
		local available = self.Owner:GetAmmoCount(self.Primary.Ammo)
		local ammo = self:Clip1()
		
		if ammo < self.Primary.ClipSize and available > 0 then
			self.NextIdle = nil
			if self.ReloadSingle then
				--self:SendWeaponAnim(ACT_RELOAD_START)
				self:SendWeaponAnimEx(self.VM_RELOAD_START)
				self.Owner:DoAnimationEvent(ACT_MP_RELOAD_STAND_PRIMARY) -- reload start
				self.NextReloadStart = CurTime() + (self.ReloadStartTime or self:SequenceDuration())
			else
				self:SendWeaponAnimEx(self.VM_RELOAD)
				self.Owner:SetAnimation(PLAYER_RELOAD)
				if self.ReloadTime == 1.15 then
					self.Owner:GetViewModel():SetPlaybackRate(1.4)
				end
				self.NextIdle = CurTime() + (self.ReloadTime or self:SequenceDuration())
				self.NextReload = self.NextIdle
				
				self.AmmoAdded = math.min(self.Primary.ClipSize - ammo, available)
				self.Reloading = true
				
				if self.ReloadSound and SERVER then
					umsg.Start("PlayTFWeaponWorldReload")
						umsg.Entity(self)
					umsg.End()
				end
				
				--self.reload_cur_start = CurTime()
			end
			--self:SetNextPrimaryFire( CurTime() + ( self.Primary.Delay || 0.25 ) + 1.4 )
			--self:SetNextSecondaryFire( CurTime() + ( self.Primary.Delay || 0.25 ) + 1.4 )
			return true
		end
	end
end

function SWEP:Deploy()
	self:CallBaseFunction("Deploy")
end

function SWEP:Think()
	if self.Owner:GetInfoNum("tf_robot", 0) == 1 then
		self:SetHoldType("ITEM1")
	end
	if self.Owner:GetPlayerClass() == "medicshotgun" then
		self.Slot = 0
		self.VM_DRAW = ACT_SECONDARY_VM_DRAW	
		self.VM_IDLE = ACT_SECONDARY_VM_IDLE
		self.VM_PRIMARYATTACK = ACT_SECONDARY_VM_PRIMARYATTACK
		self.VM_RELOAD_START = ACT_SECONDARY_RELOAD_START
		self.VM_RELOAD = ACT_SECONDARY_VM_RELOAD
		self.VM_RELOAD_FINISH = ACT_SECONDARY_RELOAD_FINISH
		self.Owner:GetViewModel():SetBodygroup(0,0)
		self.Owner:GetViewModel():SetBodygroup(1,0)
	end
	return self.BaseClass.Think(self)
end


