-- Real class name: tf_weapon_handgun_scout_primary (see shd_items.lua)

if SERVER then
	AddCSLuaFile( "shared.lua" )
	include("sv_airblast.lua")
end

if CLIENT then
	SWEP.PrintName			= "Scattergun"
	SWEP.Slot				= 0
end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/v_models/v_pistol_scout.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_shortstop/c_shortstop.mdl" 
SWEP.Crosshair = "tf_crosshair1"

SWEP.MuzzleEffect = "muzzle_scattergun"
SWEP.MuzzleOffset = Vector(20, 4, -3)

SWEP.ShootSound = Sound("weapons/short_stop_shoot.wav")
SWEP.ShootCritSound = Sound("weapons/short_stop_shoot_crit.wav")
SWEP.ReloadSound = Sound("weapons/short_stop_reload.wav")
SWEP.AirblastDeflectSound = Sound("weapons/push_impact.wav")

SWEP.TracerEffect = "bullet_scattergun_tracer01"

SWEP.BaseDamage = 12
SWEP.DamageRandomize = 0	
SWEP.MaxDamageRampUp = 0.5
SWEP.MaxDamageFalloff = 0.5

SWEP.BulletsPerShot = 4
SWEP.BulletSpread = 0.035

SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_SECONDARY
SWEP.Primary.Delay          = 0.36
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay          = 1.5
SWEP.AirblastRadius = 80

SWEP.AutoReloadTime = 0.21

--SWEP.ReloadSingle = true

SWEP.HoldType = "SECONDARY"
SWEP.HoldTypeHL2 = "revolver"
SWEP.IsRapidFire = true
SWEP.ReloadTime		= 1.5

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
				self.Owner:SetAnimation(PLAYER_RELOAD) -- reload start
				self.NextReloadStart = CurTime() + (self.ReloadStartTime or self:SequenceDuration())
			else
				self:SendWeaponAnimEx(self.VM_RELOAD)
				self.Owner:GetViewModel():SetPlaybackRate(0.7)
				self.Owner:DoAnimationEvent(ACT_MP_RELOAD_STAND_SECONDARY)
				self.NextIdle = CurTime() + (self.ReloadTime or self:SequenceDuration())
				self.NextReload = self.NextIdle
				
				self.AmmoAdded = math.min(self.Primary.ClipSize - ammo, available)
				self.Reloading = true
				
				if self.ReloadSound then
					self:EmitSound(self.ReloadSound)
				end
				
				--self.reload_cur_start = CurTime()
			end
			--self:SetNextPrimaryFire( CurTime() + ( self.Primary.Delay || 0.25 ) + 1.4 )
			--self:SetNextSecondaryFire( CurTime() + ( self.Primary.Delay || 0.25 ) + 1.4 )
			return true
		end
	end
end

function SWEP:SecondaryAttack()
	if not self.IsDeployed then return false end
	


	
	if self.NoAirblast then return false end
	
	local Delay = self.Delay or -1
	if Delay>=0 and CurTime()<Delay then return end
	self.Delay = CurTime() + self.Secondary.Delay
	if CLIENT then
		self.Owner:EmitSound("player/shove"..math.random(1,10)..".wav", 80, 100)
	end
	
	if SERVER then
	self.Owner:EmitSound("weapons/push.wav")
	end 

	self.Owner:DoAnimationEvent(ACT_DOD_PRONE_FORWARD_ZOOMED)
	self:SendWeaponAnimEx(ACT_SECONDARY_VM_ALTATTACK)
	timer.Create("SwitchToIdle", 1.2, 1, function()
		if self.Owner:GetActiveWeapon() != self then timer.Stop("SwitchToIdle") end
		self:SendWeaponAnimEx(ACT_SECONDARY_VM_IDLE_2)
	end)

	if SERVER then
		self:DoAirblast()	
	end
end

function SWEP:Think()
	self:CallBaseFunction("Think")
	self.VM_DRAW = ACT_SECONDARY_VM_DRAW_2
	self.VM_IDLE = ACT_SECONDARY_VM_IDLE_2
	self.VM_PRIMARYATTACK = ACT_SECONDARY_VM_PRIMARYATTACK_2
	self.VM_RELOAD = ACT_SECONDARY_VM_RELOAD_2
	self.VM_INSPECT_START = ACT_PRIMARY_ALT1_VM_INSPECT_START
	self.VM_INSPECT_IDLE = ACT_PRIMARY_ALT1_VM_INSPECT_IDLE
	self.VM_INSPECT_END = ACT_PRIMARY_ALT1_VM_INSPECT_END
end