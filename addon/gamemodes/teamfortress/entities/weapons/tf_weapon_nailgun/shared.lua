if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

SWEP.PrintName			= "Nailgun"
SWEP.Slot				= 0

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/v_models/v_nailgun_scout.mdl"
SWEP.WorldModel			= "models/advancedweaponiser/nailgun/c_nailgun.mdl"
SWEP.Crosshair = 		"tf_crosshair1"

SWEP.MuzzleEffect = "muzzle_pistol"

SWEP.ShootSound = Sound("weapons/nail_gun_shoot.wav")
SWEP.ShootCritSound = Sound("weapons/nail_gun_shoot_crit.wav")
SWEP.ReloadSound = Sound("weapons/pistol_worldreload.wav")

SWEP.Primary.ClipSize		= 40
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_METAL
SWEP.Primary.Delay          = 0.1

SWEP.BulletSpread = 0.01

SWEP.IsRapidFire = true
SWEP.ReloadSingle = false

SWEP.ReloadTime = 1.5	

SWEP.HoldType = "SECONDARY2"

SWEP.ProjectileShootOffset = Vector(0, 8, -5)

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
				self.Owner:DoAnimationEvent(ACT_MP_RELOAD_STAND_SECONDARY)
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
	if not self:CallBaseFunction("Deploy") then return end
	if SERVER then
		self.Owner:EmitSound("weapons/nail_gun_draw.wav", 90)
	end
end

function SWEP:ShootProjectile()
	if SERVER then
		local syringe = ents.Create("tf_projectile_nail")
		local ang = self.Owner:EyeAngles()
		local vec = ang:Forward() + math.Rand(-self.BulletSpread,self.BulletSpread) * ang:Right() + math.Rand(-self.BulletSpread,self.BulletSpread) * ang:Up()
		
		syringe:SetPos(self:ProjectileShootPos())
		syringe:SetAngles(vec:Angle())
		if self:Critical() then
			syringe.critical = true
		end
		syringe:SetOwner(self.Owner)
		--syringe:SetProjectileType(1)
		
		self:InitProjectileAttributes(syringe)
		
		syringe:Spawn()
	end
	
	if self.Owner:GetInfoNum("tf_robot", 0) == 1 then
		self:SetHoldType("SECONDARY")
	end 
	if self.Owner:GetInfoNum("tf_giant_robot", 0) == 1 then
		self:SetHoldType("SECONDARY")
	end 
	self:ShootEffects()
end
