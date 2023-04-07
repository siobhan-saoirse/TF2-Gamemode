if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

SWEP.PrintName			= "Mad Milk"
SWEP.HasCModel = true
SWEP.Slot				= 1

SWEP.RenderGroup 		= RENDERGROUP_BOTH

function SWEP:ResetParticles(state_override)
	self:CallBaseFunction("ResetParticles", state_override)
	
	if not self.DoneDeployParticle then
		if self.Owner==LocalPlayer() and not LocalPlayer():ShouldDrawLocalPlayer() then
			local ent = self:GetViewModelEntity()
			if IsValid(ent) then
				ParticleEffectAttach("energydrink_milk_splash", PATTACH_POINT_FOLLOW, ent, ent:LookupAttachment("drink_spray"))
			end
		end
		
		self.DoneDeployParticle = true
	end
end

end

PrecacheParticleSystem("energydrink_milk_splash")

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/c_models/c_scout_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_madmilk/c_madmilk.mdl"
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

SWEP.ProjectileShootOffset = Vector(0, 0, 0)

SWEP.Properties = {}
SWEP.Force = 800
SWEP.AddPitch = -4

SWEP.VM_DRAW = ACT_ITEM1_VM_DRAW
SWEP.VM_IDLE = ACT_ITEM1_VM_IDLE
SWEP.VM_PRIMARYATTACK = ACT_ITEM1_VM_PRIMARYATTACK

function SWEP:InspectAnimCheck()
	self:CallBaseFunction("InspectAnimCheck")
	if self:GetItemData().model_player == "models/weapons/c_models/c_breadmonster/c_breadmonster_milk.mdl" then
	self.VM_DRAW = ACT_BREADMONSTER_VM_DRAW
	self.VM_IDLE = ACT_BREADMONSTER_VM_IDLE
	self.VM_PRIMARYATTACK = ACT_BREADMONSTER_VM_PRIMARYATTACK
	end
end

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
		grenade.JarType = 2
		self:InitProjectileAttributes(grenade)
		
		grenade:Spawn()
		grenade:SetModel(wmodel)
		
		local vel = self.Owner:GetAimVector():Angle()
		vel.p = vel.p + self.AddPitch
		vel = vel:Forward() * self.Force * (grenade.Mass or 10)
		
		grenade:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(-2000,2000)))
		grenade:GetPhysicsObject():ApplyForceCenter(vel)
		if self:GetItemData().model_player == "models/weapons/c_models/c_breadmonster/c_breadmonster_milk.mdl" then
			grenade:SetModel("models/weapons/c_models/c_breadmonster/c_breadmonster_milk.mdl")
			self:SetHoldType("MELEE_ALLCLASS")
			self.Owner:DoAnimationEvent(ACT_DOD_PRIMARYATTACK_BOLT,true)
			self.ShootSound = Sound("Weapon_bm_throwable.throw")
			self.ShootCritSound = Sound("Weapon_bm_throwable.throw")
			self.Owner:EmitSound(self.ShootSound)
		end
	end
end

function SWEP:PrimaryAttack()
	if (self:Ammo1() < 1) then return end
	if not self:CallBaseFunction("PrimaryAttack") then return false end
	
	if SERVER then
		self.Owner:Speak("TLK_JARATE_LAUNCH")
	end
	
	self:SendWeaponAnim(self.VM_PRIMARYATTACK)
	if self:GetItemData().model_player != "models/weapons/c_models/c_breadmonster/c_breadmonster_milk.mdl" then
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	else
		if SERVER then
			self.Owner:DoAnimationEvent(ACT_MP_THROW,true)
		end
	end
	
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

function SWEP:Holster()
	if CLIENT then
		self.DoneDeployParticle = false
	end
	
	return self:CallBaseFunction("Holster")
end
