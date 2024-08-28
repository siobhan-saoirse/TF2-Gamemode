if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

SWEP.PrintName			= "Fireball Spell"
SWEP.HasCModel = true
SWEP.Slot				= 5

SWEP.RenderGroup 		= RENDERGROUP_BOTH

end


SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/c_models/c_scout_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_energy_drink/c_energy_drink.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.MuzzleEffect = ""

SWEP.ShootSound = ""
SWEP.ShootCritSound = ""

SWEP.Primary.ClipSize		= -1
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 0.8
SWEP.ReloadSingle = false

SWEP.HasCustomMeleeBehaviour = true

SWEP.HoldType = "MELEE_ALLCLASS"
SWEP.HoldTypeHL2 = "grenade"

SWEP.ProjectileShootOffset = Vector(0, 0, 0)

SWEP.Properties = {}
SWEP.Force = 800
SWEP.AddPitch = -4

SWEP.VM_DRAW = ACT_ITEM1_VM_DRAW
SWEP.VM_IDLE = ACT_ITEM1_VM_IDLE
SWEP.VM_PRIMARYATTACK = ACT_SPELL_VM_FIRE

function SWEP:InspectAnimCheck()
	self:CallBaseFunction("InspectAnimCheck")
	self.VM_DRAW = ACT_SPELL_VM_DRAW
	self.VM_IDLE = ACT_SPELL_VM_IDLE
	self.VM_HITCENTER = ACT_SPELL_VM_FIRE
	self.VM_SWINGHARD = ACT_SPELL_VM_FIRE
	self.VM_INSPECT_START = ACT_ITEM3_VM_INSPECT_START
	self.VM_INSPECT_IDLE = ACT_ITEM3_VM_INSPECT_IDLE
	self.VM_INSPECT_END = ACT_ITEM3_VM_INSPECT_END
	
	end

function SWEP:PredictCriticalHit()
end

function SWEP:MeleeAttack()
		if SERVER then
			local rocket = ents.Create("tf_projectile_capsule")
			rocket:SetPos(self:ProjectileShootPos())
			local ang = self.Owner:EyeAngles()
			
			if self.WeaponMode == 1 then
				local charge = (CurTime() - self.ChargeStartTime) / self.ChargeTime
				rocket.Gravity = Lerp(1 - charge, self.MinGravity, self.MaxGravity)
				rocket.BaseSpeed = Lerp(charge, self.MinForce, self.MaxForce)
				ang.p = ang.p + Lerp(1 - charge, self.MinAddPitch, self.MaxAddPitch)
			end
			
			rocket:SetAngles(ang)
			
			
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

function SWEP:PrimaryAttack()
	if not self:CallBaseFunction("PrimaryAttack") then return false end
	
	if SERVER then
		self.Owner:Speak("TLK_JARATE_LAUNCH")
	end
	
	self.VM_DRAW = ACT_SPELL_VM_DRAW
	self.VM_IDLE = ACT_SPELL_VM_IDLE
	self.VM_HITCENTER = ACT_SPELL_VM_FIRE
	self.VM_SWINGHARD = ACT_SPELL_VM_FIRE
	self.VM_INSPECT_START = ACT_ITEM3_VM_INSPECT_START
	self.VM_INSPECT_IDLE = ACT_ITEM3_VM_INSPECT_IDLE
	self.VM_INSPECT_END = ACT_ITEM3_VM_INSPECT_END
	self:SendWeaponAnim(self.VM_PRIMARYATTACK)
	self.Owner:DoAnimationEvent(ACT_MP_THROW,true)
	self.Owner:EmitSound("misc/halloween/spell_fireball_cast.wav")
	self.Owner.NextGiveAmmo = CurTime() + (self.Properties.ReloadTime or 20)
	self.Owner.NextGiveAmmoType = self.Primary.Ammo
	
	self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
	
	--self.NextMeleeAttack = CurTime() + 0.25
	if not self.NextMeleeAttack then
		self.NextMeleeAttack = {}
	end
	
	table.insert(self.NextMeleeAttack, CurTime() + 0.01)
end
