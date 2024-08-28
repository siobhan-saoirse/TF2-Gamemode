if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

SWEP.PrintName			= "AR2 Versus Mode"
SWEP.RenderGroup = RENDERGROUP_BOTH
SWEP.Slot				= 0

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_irifle.mdl"
SWEP.WorldModel			= "models/weapons/w_irifle.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.MuzzleEffect = ""

SWEP.ShootSound = Sound("Weapon_AR2.NPC_Single")
SWEP.ShootCritSound = Sound("Weapon_AR2.NPC_Double")
SWEP.ReloadSound = Sound("Weapon_AR2.NPC_Reload")

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 0.09
SWEP.ReloadTime = 2
SWEP.BulletsPerShot = 1
SWEP.BulletSpread = 0.08
SWEP.IsRapidFire = true
SWEP.ReloadSingle = false
SWEP.BaseDamage = 8
SWEP.DamageRandomize = 0.4
SWEP.MaxDamageRampUp = 1.2
SWEP.MaxDamageFalloff = 0.08
SWEP.HoldType = "SECONDARY"
SWEP.HoldTypeHL2 = "AR2"

SWEP.Force = 1100
SWEP.AddPitch = -4
SWEP.UseHands = true

SWEP.Properties = {}


function SWEP:SecondaryAttack()
	self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_MELEE_SECONDARY)
	self:SetNextSecondaryFire( CurTime() + 1.6 )
	self:EmitSound("Weapon_CombineGuard.Special1")
	timer.Simple(0.5, function()
		self:EmitSound("Weapon_IRifle.Single")
		self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
		self.Owner:DoAnimationEvent(ACT_COMBINE_AR2_ALTFIRE)
		local vecAiming = self.Owner:GetAimVector()//GetAutoaimVector( AUTOAIM_2DEGREES );

		local vecVelocity = vecAiming * 1000
		if SERVER then
			local grenade = ents.Create("prop_combine_ball")
			grenade:SetPos(self:ProjectileShootPos())
			grenade:SetAngles(self.Owner:EyeAngles())
			
			if self:Critical() then
				grenade.critical = true
			end
			
			
			self:InitProjectileAttributes(grenade)
			grenade:SetSaveValue( "m_flRadius", 10 )
			grenade:SetSaveValue( "m_flSpeed", vecVelocity:Length() )
			grenade:SetSaveValue( "m_vecAbsVelocity", vecVelocity )
			grenade.NameOverride = self:GetItemData().item_iconname
			grenade:SetOwner(self.Owner)
			
			grenade:Spawn()
			grenade:Fire("explode","",4)
			grenade:SetSaveValue( "m_bLaunched", true )
			grenade:SetSaveValue( "m_nState", 2 )
			grenade:EmitSound("NPC_CombineBall.Launch")
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
	end)
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
				--self.Owner:SetAnimation(PLAYER_RELOAD) -- reload start
				self.NextReloadStart = CurTime() + (self.ReloadStartTime or self:SequenceDuration())
			else
				self:SendWeaponAnimEx(self.VM_RELOAD)
				--self.Owner:DoAnimationEvent(ACT_GESTURE_RELOAD, true)
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

