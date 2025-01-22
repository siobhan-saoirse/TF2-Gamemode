if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

SWEP.PrintName			= "Gas Passer"
SWEP.HasCModel = true
SWEP.Slot				= 1

SWEP.RenderGroup 		= RENDERGROUP_BOTH

end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/c_models/c_pyro_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_gascan/c_gascan.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.MuzzleEffect = ""

SWEP.ShootSound = "weapons/gas_can_throw.wav"
SWEP.ShootCritSound = "weapons/gas_can_throw.wav"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.Ammo			= TF_SECONDARY
SWEP.Primary.Delay          = 1

SWEP.ReloadSingle = false

SWEP.HasCustomMeleeBehaviour = true

SWEP.HoldType = "ITEM1"

SWEP.ProjectileShootOffset = Vector(0, 0, 0)

SWEP.Force = 800
SWEP.AddPitch = -4

SWEP.HoldType = "MELEE_ALLCLASS"

function SWEP:InspectAnimCheck()
self:CallBaseFunction("InspectAnimCheck")
self.VM_DRAW = ACT_ITEM2_VM_DRAW
self.VM_IDLE = ACT_ITEM2_VM_IDLE
self.VM_PRIMARYATTACK = ACT_ITEM2_VM_FIRE
self.VM_INSPECT_START = ACT_ITEM2_VM_INSPECT_START
self.VM_INSPECT_IDLE = ACT_ITEM2_VM_INSPECT_IDLE
self.VM_INSPECT_END = ACT_ITEM2_VM_INSPECT_END
end

function SWEP:Think()
	self.BaseClass.Think(self)
	self.Owner:SetPoseParameter("r_arm", 2.2)
	self.Owner:SetPoseParameter("r_hand_grip", 10.8)
end

function SWEP:PredictCriticalHit()
end

function SWEP:MeleeAttack()
	local pos = self.Owner:GetShootPos()
	
	local wmodel = self:GetItemData().model_player or self.WorldModel
	if SERVER then
		local grenade = ents.Create("tf_projectile_gas")
		grenade:SetPos(pos)
		grenade:SetAngles(self.Owner:EyeAngles())
		
		if self:Critical() then
			grenade.critical = true
		end
		
		grenade:SetOwner(self.Owner)
		
		grenade:Spawn()
		grenade:SetModel(wmodel)
		
		local vel = self.Owner:GetAimVector():Angle()
		vel.p = vel.p + self.AddPitch
		vel = vel:Forward() * self.Force * (grenade.Mass or 10)
		
		grenade:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(-2000,2000)))
		grenade:GetPhysicsObject():ApplyForceCenter(vel)
	end
end

function SWEP:PrimaryAttack()	
	if self:Ammo1() == 0 then
		return
	end
	
	if SERVER then
		self.Owner:Speak("TLK_JARATE_LAUNCH")
		//self.Owner:SelectWeapon("tf_weapon_club")
	end
	
	self:SendWeaponAnim(self.VM_PRIMARYATTACK)
	
	
	
	self:TakePrimaryAmmo(1)
	
	self.Owner.NextGiveAmmo = CurTime() + (20)
	self.Owner.NextGiveAmmoType = self.Primary.Ammo
	self:EmitSound("Weapon_GasCan.Throw")
	if CLIENT then
		self.Owner:DoTauntEvent("attackstand_gascan", true)
	end
	self:SetNextPrimaryFire(CurTime() + 0.8)
	self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
	
	--self.NextMeleeAttack = CurTime() + 0.25
	if not self.NextMeleeAttack then
		self.NextMeleeAttack = {}
	end
	
	table.insert(self.NextMeleeAttack, CurTime() + 0.25)
end
