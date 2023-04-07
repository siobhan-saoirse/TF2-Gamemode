if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

SWEP.PrintName			= "The Flare Gun"
SWEP.Category			= "Team Fortress 2"
SWEP.Spawnable			= true
if CLIENT then

SWEP.HasCModel = true

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.Slot				= 1
SWEP.ViewModel			= "models/weapons/c_models/c_pyro_arms_empty.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_flaregun_pyro/c_flaregun_pyro.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.MuzzleEffect = ""

SWEP.ShootSound = Sound("weapons/flaregun_shoot.wav")
SWEP.ShootCritSound = Sound("TFWeapon_FlareGun.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_FlareGun.WorldReload")

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_SECONDARY
SWEP.Primary.Delay          = 2.02

SWEP.IsRapidFire = false
SWEP.ReloadSingle = false

SWEP.HoldType = "ITEM1"
SWEP.HoldTypeHL2 = "revolver"
SWEP.BaseDamage = 25
SWEP.ProjectileShootOffset = Vector(0, 8, -5)
 
SWEP.PunchView = Angle( -2, 0, 0 )

SWEP.VM_DRAW = ACT_ITEM1_VM_DRAW
SWEP.VM_IDLE = ACT_ITEM1_VM_IDLE
SWEP.VM_PRIMARYATTACK = ACT_ITEM1_VM_PRIMARYATTACK
SWEP.VM_RELOAD = ACT_ITEM1_VM_RELOAD

function SWEP:PrimaryAttack()
	if self.NextIdle then return end
	if SERVER and self:Ammo1() != 0 then
		timer.Simple(0.7, function()
			--self.WModel2:SetBodygroup(1, 1) 
		end)
		timer.Simple(1.1, function()
			--self.WModel2:SetBodygroup(1, 0)
		end)
	end
	if CLIENT and self:Ammo1() != 0 then
		if self:GetClass() == "tf_weapon_flaregun" then
			timer.Simple(0.7, function()
				self.CModel:SetBodygroup(1, 1)
			end)	
			timer.Simple(1.1, function()
				self.CModel:SetBodygroup(1, 0)
			end) 
		end
	end

	if not self:CanPrimaryAttack() then
		return
	end
	self:SendWeaponAnim(self.VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	self:ShootProjectile()



	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if self.Primary.Delay == 0.5 then
		self.Owner:GetViewModel():SetPlaybackRate(2.5)
	end
	
	self:TakePrimaryAmmo(1)
	
	self:StopTimers()
	
	self.Owner:ViewPunch( self.PunchView )
	
	self:RollCritical()
end


function SWEP:Inspect()
	self:InspectAnimCheck()

	if (self:GetOwner():GetMoveType()==MOVETYPE_NOCLIP) and GetConVar("tf_haltinspect"):GetBool() and self.CanInspect == true then
		//self.CanInspect = false
		//self:StopTimers()
		return false
	--[[else
		if self.Owner:OnGround() and self.IsDeployed and self.Reloading == false then
			self.CanInspect = true 
		end]]  
	end
	
	//if self:GetSequenceActivity(self:GetSequence()) == self.VM_INSPECT_IDLE then

	if self.IsDeployed and self.CanInspect then
		if self.Owner ~= nil then
		if ( self:GetOwner():KeyPressed( IN_SPEED ) and inspecting == false and self.Owner:GetInfoNum("tf_sprintinspect", 1) == 1 ) then
			inspecting = true
			self:SendWeaponAnim( self.VM_INSPECT_START )
			timer.Create("StartInspection", self:SequenceDuration(), 1,function()
				if self:GetOwner():KeyDown( IN_SPEED ) then 
					self:SendWeaponAnim( self.VM_INSPECT_IDLE )
					inspecting_idle = true
				else
					self:SendWeaponAnim( ACT_BUILDING_VM_INSPECT_END )
					inspecting_post = false
					inspecting = false
					timer.Create("PostInspection", self:SequenceDuration(), 1, function()
						if !self:GetOwner():KeyDown( IN_SPEED ) then
							self:SendWeaponAnim( self.VM_IDLE )
						end
					end )
				end
			end )
		end
		
		if ( self:GetOwner():KeyReleased( IN_SPEED ) and inspecting_idle == true and self.Owner:GetInfoNum("tf_sprintinspect", 1) == 1 ) then
			self:SendWeaponAnim( ACT_BUILDING_VM_INSPECT_END )
			inspecting_post = false
			inspecting_idle = false
			inspecting = false 
			timer.Create("PostInspection", self:SequenceDuration(), 1, function()
				if !self:GetOwner():KeyDown( IN_SPEED ) then
					self:SendWeaponAnim( self.VM_IDLE )
				end
			end )
		end

		if ( self:GetOwner():KeyPressed( IN_RELOAD ) and ((self.Base ~= "tf_weapon_melee_base") or self.Base == "tf_weapon_melee_base") and inspecting == false and self.Owner:GetInfoNum("tf_reloadinspect", 1) == 1 ) then
			inspecting = true
			self:SendWeaponAnim( self.VM_INSPECT_START )
			timer.Create("StartInspection", self:SequenceDuration(), 1, function()
				if self:GetOwner():KeyDown( IN_RELOAD ) then 
					self:SendWeaponAnim( self.VM_INSPECT_IDLE )
					inspecting_idle = true
				else
					self:SendWeaponAnim( ACT_BUILDING_VM_INSPECT_END )
					inspecting_post = false
					inspecting = false
					timer.Create("PostInspection", self:SequenceDuration(), 1, function()
						if !self:GetOwner():KeyDown( IN_RELOAD ) then
							self:SendWeaponAnim( self.VM_IDLE )
						end
					end )
				end
			end )
		end
		
		if ( self:GetOwner():KeyReleased( IN_RELOAD ) and inspecting_idle == true and self.Owner:GetInfoNum("tf_reloadinspect", 1) == 1 ) then
			self:SendWeaponAnim( ACT_BUILDING_VM_INSPECT_END)
			inspecting_post = false
			inspecting_idle = false
			inspecting = false 
			timer.Create("PostInspection", self:SequenceDuration(), 1, function()
				if !self:GetOwner():KeyDown( IN_RELOAD ) then
					self:SendWeaponAnim( self.VM_IDLE )
				end
			end )
		end
		end
	end
end	

function SWEP:SecondaryAttack()
	if self:GetItemData().model_player == "models/weapons/c_models/c_detonator/c_detonator.mdl" then
		for k,v in ipairs(ents.FindByClass("tf_projectile_flare")) do
			if v:GetOwner() == self.Owner then
				v:DoExplosion()
				v:Fire("Kill", "", 0.01)
			end
		end
	end
end

function SWEP:ShootProjectile()
	
	if SERVER then
		-- lol syringe
		
		local syringe = ents.Create("tf_projectile_flare")
		local ang = self.Owner:EyeAngles()
		
		syringe:SetPos(self:ProjectileShootPos())	
		syringe:SetAngles(ang)
		syringe.Inflictor = self
		if self:Critical() then
			syringe.critical = true
		end 
		syringe:SetOwner(self.Owner)
		self:InitProjectileAttributes(syringe)
		
		syringe.NameOverride = self:GetItemData().item_iconname
		syringe:Spawn()
	end
	
	self:ShootEffects()
end

function SWEP:Think()
	self:TFViewModelFOV()

	if self.NextIdle and CurTime()>=self.NextIdle then
		self:SendWeaponAnim(self.VM_IDLE)
		self.NextIdle = nil
		self.IsDeployed = true
	end
	if self:GetItemData().model_player == "models/workshop/weapons/c_models/c_scorch_shot/c_scorch_shot.mdl" then
		for k,v in ipairs(ents.FindByClass("tf_projectile_flare")) do
			if v:GetOwner() == self.Owner then
				v.FlareType = "Scorch"
			end
		end
	end
	if self:GetItemData().model_player == "models/workshop/weapons/c_models/c_scorch_shot/c_scorch_shot.mdl" then
		self.ShootSound = Sound("Weapon_ScorchShot.Single")
		self.ShootCritSound = Sound("Weapon_ScorchShot.SingleCrit")
	end
	self:Inspect()
end

local WeaponBodygroups = {
	shell = 1,
}

function SWEP:FireAnimationEvent(pos, ang, event, options)
	if event == 37 then
		local bodygroup, set = string.match(options, "(.-)%s+(%d+)")
		bodygroup = WeaponBodygroups[bodygroup or ""]
		set = tonumber(set)
	end
end
