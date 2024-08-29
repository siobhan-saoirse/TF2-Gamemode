if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

SWEP.PrintName			= "Cleaver"
SWEP.HasCModel = true
SWEP.Slot				= 1

end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/c_models/c_scout_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_sd_cleaver/c_sd_cleaver.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.MuzzleEffect = ""

SWEP.ShootSound = Sound("weapons/cleaver_throw.wav")
SWEP.ShootCritSound = Sound("weapons/cleaver_throw.wav")

SWEP.Primary.ClipSize		= -1
SWEP.Primary.Ammo			= TF_GRENADES1
SWEP.Primary.Delay          = 1

SWEP.ReloadSingle = false

SWEP.HasCustomMeleeBehaviour = true

SWEP.HoldType = "ITEM1"

SWEP.ProjectileShootOffset = Vector(0, 0, 0)

SWEP.Properties = {}
SWEP.Force = 800
SWEP.AddPitch = -4
SWEP.VM_PRIMARYATTACK = ACT_ITEM3_VM_RELOAD		
function SWEP:PredictCriticalHit()
end

function SWEP:InspectAnimCheck()
	self:CallBaseFunction("InspectAnimCheck")
	self.VM_DRAW = ACT_ITEM3_VM_DRAW
	self.VM_IDLE = ACT_ITEM3_VM_IDLE
end

function SWEP:MeleeAttack()
	local pos = self.Owner:GetShootPos()
	
	if SERVER then
		local grenade = ents.Create("tf_projectile_cleaver")
		grenade:SetPos(pos)
		grenade:SetAngles(self.Owner:EyeAngles())
		
		if self:Critical() then
			grenade.critical = true
		end
		
		for k,v in pairs(self.Properties) do
			grenade[k] = v
		end
		
		grenade:SetOwner(self.Owner)
		self:InitProjectileAttributes(grenade)
		
		grenade:Spawn()
		
		local vel = self.Owner:GetAimVector():Angle()
		vel.p = vel.p + self.AddPitch
		vel = vel:Forward() * self.Force * (grenade.Mass or 10)
		
		grenade:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(-2000,2000)))
		grenade:GetPhysicsObject():ApplyForceCenter(vel)
		self.Owner:EmitSound(self.ShootSound)
	end
end

function SWEP:PrimaryAttack()
	if not self:CallBaseFunction("PrimaryAttack") then return false end
	
	if self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() ) == 0 then
		return
	end
	
	if SERVER then
		self.Owner:Speak("TLK_JARATE_LAUNCH")
		//self.Owner:SelectWeapon("tf_weapon_club")
	end
	
	self:SendWeaponAnim(self.VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	
	
	self:TakePrimaryAmmo(1)
	
	self.Owner.NextGiveAmmo = CurTime() + (self.Properties.ReloadTime or 5)
	self.Owner.NextGiveAmmoType = self.Primary.Ammo
	
	self.NextIdle = CurTime() + self:SequenceDuration()
	
	--self.NextMeleeAttack = CurTime() + 0.25
	if not self.NextMeleeAttack then
		self.NextMeleeAttack = {}
	end
	
	table.insert(self.NextMeleeAttack, CurTime() + 0.25)
end
