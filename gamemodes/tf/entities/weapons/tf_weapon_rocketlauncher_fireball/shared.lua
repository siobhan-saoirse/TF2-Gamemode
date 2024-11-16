-- Real class name: tf_weapon_bet_rocketlauncher (see shd_items.lua)

if SERVER then
	AddCSLuaFile( "shared.lua" )
	include("sv_airblast.lua")

end

if CLIENT then

SWEP.PrintName			= "The Dragon's Fury"
SWEP.Slot				= 0
SWEP.HasCModel = true

end

PrecacheParticleSystem("pyro_blast")
PrecacheParticleSystem("pyro_blast_flash")
PrecacheParticleSystem("pyro_blast_lines")
PrecacheParticleSystem("pyro_blast_warp")
PrecacheParticleSystem("pyro_blast_warp2")

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_pyro_arms.mdl"
SWEP.WorldModel			= "models/workshop/weapons/c_models/c_atom_launcher/c_atom_launcher.mdl"
SWEP.Crosshair = "tf_crosshair3"


SWEP.MuzzleEffect = "pyro_blast"
 
SWEP.ShootSound = Sound(")weapons/dragons_fury_shoot.wav")
SWEP.ShootCritSound = Sound(")weapons/dragons_fury_shoot_crit.wav")
SWEP.CustomExplosionSound = Sound("")

SWEP.AirblastSound = Sound("Weapon_FlameThrower.AirBurstAttack")
SWEP.AirblastDeflectSound = Sound("Weapon_FlameThrower.AirBurstAttackDeflect")
SWEP.Primary.ClipSize	= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8

SWEP.Secondary.Automatic	= true
SWEP.Secondary.Delay		= 1.8
SWEP.IsRapidFire = false
SWEP.ReloadSingle = true

SWEP.AirblastRadius = 120
SWEP.HoldType = "PRIMARY"

SWEP.ProjectileShootOffset = Vector(0, 13, -4)

SWEP.PunchView = Angle( -6, 0, 0 )

SWEP.Properties = {}

function SWEP:InspectAnimCheck()
self:CallBaseFunction("InspectAnimCheck")
self.VM_DRAW = ACT_PRIMARY_VM_DRAW
self.VM_IDLE = ACT_PRIMARY_VM_IDLE
self.VM_PRIMARYATTACK = ACT_PRIMARY_VM_PRIMARYATTACK_3
self.VM_INSPECT_START = ACT_PRIMARY_VM_INSPECT_START
self.VM_INSPECT_IDLE = ACT_PRIMARY_VM_INSPECT_IDLE
self.VM_INSPECT_END = ACT_PRIMARY_M_INSPECT_END
end

function SWEP:Deploy()
	self:CallBaseFunction("Deploy")
end

function SWEP:ShootProjectile()
	if SERVER then
		local rocket = ents.Create("tf_projectile_rocket_fireball")
		rocket:SetPos(self:ProjectileShootPos())
		local ang = self.Owner:EyeAngles()
		
		if self.WeaponMode == 1 then
			local charge = (CurTime() - self.ChargeStartTime) / self.ChargeTime
			rocket.Gravity = Lerp(1 - charge, self.MinGravity, self.MaxGravity)
			rocket.BaseSpeed = Lerp(charge, self.MinForce, self.MaxForce)
			ang.p = ang.p + Lerp(1 - charge, self.MinAddPitch, self.MaxAddPitch)
		end
		
		rocket:SetAngles(ang)
		
		if self:Critical() then
			self.Owner:EmitSoundEx(")weapons/dragons_fury_shoot_crit.wav")
			rocket.critical = true
		else
			self.Owner:EmitSoundEx(")weapons/dragons_fury_shoot.wav")
		end
		
		for k,v in pairs(self.Properties) do
			rocket[k] = v
		end
		
		rocket:SetOwner(self.Owner)
		self:InitProjectileAttributes(rocket)
		rocket.ExplosionSound = self.CustomExplosionSound
		
		rocket:Spawn()
		rocket:Activate()
	end
	
	
end


function SWEP:SecondaryAttack()
	if not self.IsDeployed then return false end
	
	if self.NoAirblast then return false end
	
	if self:Ammo1()<20 then
		return
	end
	
	local Delay = self.Delay or -1
	if Delay>=0 and CurTime()<Delay then return end
	self.Delay = CurTime() + self.Secondary.Delay
	if SERVER then
		self.Owner:EmitSoundEx(self.AirblastSound)
		self.Owner:EmitSoundEx("weapons/dragons_fury_pressure_build.wav")
		timer.Simple(1.55, function()	
			self.Owner:EmitSoundEx("weapons/dragons_fury_pressure_build_stop.wav")
		end)
	end
	
	if SERVER then
		umsg.Start("DoMuzzleFlash")
			umsg.Entity(self)
		umsg.End()
	end
	
	
	// This is the VM airblast animation. It's broken.
	--self.SendWeaponAnim(self.VM_SECONDARYATTACK) // old implementation, doesn't work
	self:SendWeaponAnim(ACT_PRIMARY_VM_SECONDARYATTACK) // new implementation, works? VM glitches, community primary weapons fail?
	--self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.NextIdle = CurTime() + self:SequenceDuration() - 0.2 // culprit?
	
	self:TakePrimaryAmmo(20)
	if SERVER then
		self:DoAirblast()
	end
end