if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

SWEP.PrintName			= "Jarate"
SWEP.HasCModel = true
SWEP.Slot				= 1

SWEP.RenderGroup 		= RENDERGROUP_BOTH

end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/c_models/c_sniper_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/urinejar.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.MuzzleEffect = ""

SWEP.ShootSound = ""
SWEP.ShootCritSound = ""

SWEP.Primary.ClipSize		= -1
SWEP.Primary.Ammo			= TF_GRENADES1
SWEP.Primary.Delay          = 0.8

SWEP.ReloadSingle = false

SWEP.HasCustomMeleeBehaviour = true

SWEP.HoldType = "ITEM1"
SWEP.HoldTypeHL2 = "grenade"

SWEP.ProjectileShootOffset = Vector(0, 0, 0)

SWEP.Properties = {}
SWEP.Force = 800
SWEP.AddPitch = -4

SWEP.VM_DRAW = ACT_ITEM1_VM_DRAW
SWEP.VM_IDLE = ACT_ITEM1_VM_IDLE
SWEP.VM_PRIMARYATTACK = ACT_ITEM1_VM_RELOAD

function SWEP:PredictCriticalHit()
end

function SWEP:MeleeAttack()
	local pos = self.Owner:GetShootPos()
	local wmodel = self:GetItemData().model_player or self.WorldModel
	if SERVER then
		local grenade = ents.Create("tf_projectile_jar")
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
		grenade:SetModel(wmodel)
		
		local vel = self.Owner:GetAimVector():Angle()
		vel.p = vel.p + self.AddPitch
		vel = vel:Forward() * self.Force * (grenade.Mass or 10)
		
		grenade:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(-2000,2000)))
		grenade:GetPhysicsObject():ApplyForceCenter(vel)
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
	
	self.Owner.NextGiveAmmo = CurTime() + (self.Properties.ReloadTime or 20)
	self.Owner.NextGiveAmmoType = self.Primary.Ammo
	
	self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
	
	--self.NextMeleeAttack = CurTime() + 0.25
	if not self.NextMeleeAttack then
		self.NextMeleeAttack = {}
	end
	
	table.insert(self.NextMeleeAttack, CurTime() + 0.25)
end
