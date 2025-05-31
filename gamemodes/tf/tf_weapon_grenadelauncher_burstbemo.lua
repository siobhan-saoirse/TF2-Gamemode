if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

SWEP.Slot				= 0
if CLIENT then

SWEP.PrintName			= "Burst Fire Grenade Launcher for Demoman"

function SWEP:InitializeCModel()
	self:CallBaseFunction("InitializeCModel")
	
	if IsValid(self.CModel) then
		self.CModel:SetBodygroup(1, 1)
	end
	
	for _,v in pairs(self.Owner:GetTFItems()) do
		if v:GetClass() == "tf_wearable_item_demoshield" then
			self.ShieldEntity = v
			v:InitializeCModel(self)
		end
	end	
	
	for _,v in pairs(self.Owner:GetTFItems()) do
		if v:GetClass() == "tf_wearable_item_tideturnr" then
			self.ShieldEntity = v
			v:InitializeCModel(self)
		end
	end
end


function SWEP:ViewModelDrawn()
	self:CallBaseFunction("ViewModelDrawn")
	
	if IsValid(self.ShieldEntity) and IsValid(self.ShieldEntity.CModel) then
		self.ShieldEntity:StartVisualOverrides()
		self.ShieldEntity.CModel:DrawModel()
		self.ShieldEntity:EndVisualOverrides()
	end
end

function SWEP:InitializeWModel2()
	self:CallBaseFunction("InitializeWModel2")
	
	--[[if IsValid(self.WModel2) then
		--self.WModel2:SetBodygroup(1, 1)
	end]]
end

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_demo_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_grenadelauncher/c_grenadelauncher.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "Team Fortress 2"

--[[ --Viewmodel Settings Override (left-over from testing; works well)
SWEP.ViewModelFOV	= 70
SWEP.ViewModelFlip	= false
]]

SWEP.MuzzleEffect = "muzzle_grenadelauncher"
PrecacheParticleSystem("muzzle_grenadelauncher")

SWEP.ShootSound = Sound("Weapon_GrenadeLauncher.Single")
SWEP.ShootCritSound = Sound("Weapon_GrenadeLauncher.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_GrenadeLauncher.WorldReload")

SWEP.Primary.ClipSize		= 4 
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 0.6 * 0.05
SWEP.ReloadTime = 0.6 * 1.75

SWEP.IsRapidFire = false
SWEP.ReloadSingle = true

SWEP.HoldType = "SECONDARY"

SWEP.HoldTypeHL2 = "shotgun"

SWEP.ProjectileShootOffset = Vector(0, 7, -6)
SWEP.Force = 1100 * 1.1
SWEP.AddPitch = -4

SWEP.PunchView = Angle( -2, 0, 0 )

SWEP.Properties = {}

SWEP.SpinSound = true

function SWEP:OnEquipAttribute(a, owner)
	if a.attribute_class == "mult_clipsize" then
		self.SpinSound = false
	end
end


function SWEP:ShootProjectile()
	if SERVER then
		grenade = ents.Create("tf_projectile_pipe")
		grenade:SetPos(self:ProjectileShootPos())
		if self:GetItemData().model_player == "models/workshop/weapons/c_models/c_quadball/c_quadball.mdl" then
			grenade.Model = "models/workshop/weapons/c_models/c_quadball/w_quadball_grenade.mdl"
		end

		if self:Critical() then
			grenade.critical = true
		end
		local ang = self.Owner:EyeAngles()
		grenade:SetAngles(ang)
		for k,v in pairs(self.Properties) do
			grenade[k] = v
		end
		
		grenade:SetOwner(self.Owner)
		
		self:InitProjectileAttributes(grenade)
		grenade.NameOverride = self:GetItemData().item_iconname		
		grenade:Spawn()
		
		if self:GetItemData().model_player == "models/workshop/weapons/c_models/c_quadball/c_quadball.mdl" then
			grenade:SetModel("models/workshop/weapons/c_models/c_quadball/w_quadball_grenade.mdl")
			grenade.GrenadeMode = 2
			grenade.ExplosionSound = Sound("Weapon_Airstrike.Explosion")
			grenade:SetMoveCollide(MOVECOLLIDE_DEFAULT)
			grenade.BouncesLeft = 1
			grenade.Mass = 11
		end
		if self.VM_RELOAD == ACT_PRIMARY_VM_RELOAD_2 then
			grenade.DetonateMode = 2
			else
			grenade.DetonateMode = 0
		end
		
		local vel = self.Owner:GetAimVector():Angle()
		if (self.Owner.TFBot and self.Owner:Nick() == "Giant Burst Fire Demo") then	
			vel = self.Owner:GetAimVector():Angle() + Angle(math.random(-5,5),math.random(-5,5),0)
		end
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
	self:ShootEffects()
end

function SWEP:InspectAnimCheck()
self.VM_INSPECT_START = ACT_PRIMARY_VM_INSPECT_START
self.VM_INSPECT_IDLE = ACT_PRIMARY_VM_INSPECT_IDLE
self.VM_INSPECT_END = ACT_PRIMARY_VM_INSPECT_END

		if self:GetItemData().model_player == "models/workshop/weapons/c_models/c_lochnload/c_lochnload.mdl" then
			self.VM_RELOAD = ACT_PRIMARY_VM_RELOAD_2
			self.ShootSound = Sound("weapons/loch_n_load_shoot.wav")
			self.ShootSoundCrit = Sound("weapons/loch_n_load_shoot_crit.wav")
			self.Primary.ClipSize		= 3
		end
	if self:GetItemData().model_player == "models/weapons/c_models/c_lochnload/c_lochnload.mdl" then
		self.ShootSound = Sound("weapons/loch_n_load_shoot.wav")
		self.ShootCritSound = Sound("weapons/loch_n_load_shoot_crit.wav")
	end
	if ( self:GetOwner():KeyPressed( IN_SPEED ) and inspecting == false and GetConVar("tf_caninspect"):GetBool() and self.Owner:GetInfoNum("tf_sprintinspect", 1) == 1 ) then
		timer.Create("StartInspection", self:SequenceDuration(), 1,function()
			if self:GetOwner():KeyDown(  ) then 
				inspecting_idle = true
			else
				if CLIENT then
					timer.Create("PlaySpin", 1.07, 1, function() surface.PlaySound( "player/taunt_clip_spin_long.wav" ) end)
				end
				inspecting_idle = false
			end
		end )
	end

	if ( self:GetOwner():KeyReleased( IN_SPEED ) and inspecting_idle == true and GetConVar("tf_caninspect"):GetBool() and self.Owner:GetInfoNum("tf_sprintinspect", 1) == 1 ) then
		if CLIENT then
			timer.Create("PlaySpin", 1.07, 1, function() surface.PlaySound( "player/taunt_clip_spin_long.wav" ) end)
		end
	end

	if ( self:GetOwner():KeyPressed( IN_RELOAD ) and self:Clip1() == self:GetMaxClip1() and inspecting == false and GetConVar("tf_caninspect"):GetBool() and self.Owner:GetInfoNum("tf_reloadinspect", 1) == 1 ) then
		timer.Create("StartInspection", self:SequenceDuration(), 1,function()
			if self:GetOwner():KeyDown( IN_RELOAD ) then 
				inspecting_idle = true
			else
				if CLIENT then
					timer.Create("PlaySpin", 1.07, 1, function() surface.PlaySound( "player/taunt_clip_spin_long.wav" ) end)
				end
				inspecting_idle = false
			end
		end )
	end

	if ( self:GetOwner():KeyReleased( IN_RELOAD ) and self:Clip1() == self:GetMaxClip1() and inspecting_idle == true and GetConVar("tf_caninspect"):GetBool() and self.Owner:GetInfoNum("tf_reloadinspect", 1) == 1 ) then
		if CLIENT then
			timer.Create("PlaySpin", 1.07, 1, function() surface.PlaySound( "player/taunt_clip_spin_long.wav" ) end)
		end
	end
	
	--[[	if ( self:GetOwner():GetNWString("inspect") == "inspecting_released" and inspecting_post == false and GetConVar("tf_caninspect"):GetBool() and self.SpinSound == true and !(self.Owner:GetMoveType()==MOVETYPE_NOCLIP) ) then
		if CLIENT then
			timer.Create("PlaySpin", 2.06, 1, function() surface.PlaySound( "player/taunt_clip_spin_long.wav" ) end)
		end
	end]]
	self.BaseClass.InspectAnimCheck(self)
end

function SWEP:StopTimers()
	self:CallBaseFunction("StopTimers")
	timer.Remove("PlaySpin")
end
