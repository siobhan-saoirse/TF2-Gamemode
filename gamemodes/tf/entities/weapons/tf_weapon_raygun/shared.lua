-- Real class name: tf_weapon_bet_rocketlauncher (see shd_items.lua)

if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then

SWEP.PrintName			= "Raygun"
SWEP.Slot				= 1
SWEP.HasCModel = true
SWEP.RenderGroup 		= RENDERGROUP_BOTH



end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/v_models/v_shotgun_soldier.mdl"
SWEP.WorldModel			= "models/workshop/weapons/c_models/c_drg_righteousbison/c_drg_righteousbison.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.MuzzleEffect = ""

SWEP.ShootSound = Sound("Weapon_Bison.Single")
SWEP.ShootCritSound = Sound("Weapon_Bison.SingleCrit")
SWEP.CustomExplosionSound = Sound("Weapon_CowMangler.Explode")
SWEP.Primary.Reload = Sound("Weapon_Bison.Reload")

SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_METAL
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.3

SWEP.IsRapidFire = false
SWEP.ReloadSingle = true

SWEP.HoldType = "SECONDARY2"

SWEP.ProjectileShootOffset = Vector(0, 13, -4)

SWEP.PunchView = Angle( 0, 0, 0 )

SWEP.Properties = {}

function SWEP:InspectAnimCheck()
self:CallBaseFunction("InspectAnimCheck")
self.VM_DRAW = ACT_SECONDARY2_VM_DRAW
self.VM_IDLE = ACT_SECONDARY2_VM_IDLE
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
		----MsgN("Requested reload!")
		self.RequestedReload = true
		return false
	end
	
	self.CanInspect = false
	
	----MsgN("Reload!")
	self.RequestedReload = false
	
	if self.Primary and self.Primary.Ammo and self.Primary.ClipSize ~= -1 then
		local available = self.Owner:GetAmmoCount(self.Primary.Ammo)
		local ammo = self:Clip1()
		
		if ammo < self.Primary.ClipSize and available > 0 then
			self.NextIdle = nil
			if self.ReloadSingle then
				--self:SendWeaponAnim(ACT_RELOAD_START)
				self:SendWeaponAnimEx(ACT_SECONDARY2_RELOAD_START)
				self.Owner:SetAnimation(PLAYER_RELOAD)
				self.NextReloadStart = CurTime() + (self.ReloadStartTime or self:SequenceDuration())
			else
				self:SendWeaponAnimEx(ACT_SECONDARY2_VM_RELOAD)
				self.Owner:SetAnimation(PLAYER_RELOAD)
				self.NextIdle = CurTime() + (self.ReloadTime or self:SequenceDuration())
				self.NextReload = self.NextIdle
				
				self.AmmoAdded = math.min(self.Primary.ClipSize - ammo, available)
				self.Reloading = true
				
				
				
				--self.reload_cur_start = CurTime()
			end
			--self:SetNextPrimaryFire( CurTime() + ( self.Primary.Delay || 0.25 ) + 1.4 )
			--self:SetNextSecondaryFire( CurTime() + ( self.Primary.Delay || 0.25 ) + 1.4 )
			return true
		end
	end
end

function SWEP:Think()
	self:TFViewModelFOV()
	self:TFFlipViewmodel()
	//deployspeed = math.Round(GetConVar("tf_weapon_deploy_speed"):GetFloat() - GetConVar("tf_weapon_deploy_speed"):GetInt(), 2)
	//deployspeed = math.Round(GetConVar("tf_weapon_deploy_speed"):GetFloat(),2)
	
	if SERVER and self.NextReplayDeployAnim then
		if CurTime() > self.NextReplayDeployAnim then
			--MsgFN("Replaying deploy animation %d", self.VM_DRAW)
			timer.Simple(0.1, function() self:SendWeaponAnim(self.VM_DRAW) end)
			self.NextReplayDeployAnim = nil
		end
	end
	
	if not game.SinglePlayer() or SERVER then
		if self.NextIdle and CurTime()>=self.NextIdle then
			self:SendWeaponAnim(self.VM_IDLE)
			self.NextIdle = nil
		end
		
		if self.RequestedReload then
			self:Reload()
		end
	end
	
	if not self.IsDeployed and self.NextDeployed and CurTime()>=self.NextDeployed then
		self.IsDeployed = true
		self.CanInspect = true
		self:CheckAutoReload()
	end
	
	if self.IsDeployed then
		self.CanInspect = true
	end
			
	//--print(deployspeed)
	
	if self.NextReload and CurTime()>=self.NextReload then
		self:SetClip1(self:Clip1() + self.AmmoAdded)
		
		if not self.ReloadSingle and self.ReloadDiscardClip then
			self.Owner:RemoveAmmo(self.Primary.ClipSize, self.Primary.Ammo, false)
		else
			self.Owner:RemoveAmmo(self.AmmoAdded, self.Primary.Ammo, false)
		end
		
		self.Delay = -1
		self.QuickDelay = -1
		
		
		if self:Clip1()>=self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo)==0 then
			-- Stop reloading
			self.Reloading = false
			self.CanInspect = true
			if self.ReloadSingle then
				--self:SendWeaponAnim(ACT_RELOAD_FINISH)
				self:SendWeaponAnim(ACT_SECONDARY2_RELOAD_FINISH)
				self.Owner:DoAnimationEvent(ACT_MP_RELOAD_STAND_END)
				self.CanInspect = true
				--self.Owner:SetAnimation(10001) -- reload finish
				self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
			else
				self:SendWeaponAnim(self.VM_IDLE)
				self.NextIdle = nil
			end
			self.NextReload = nil
		else
			self:SendWeaponAnim(ACT_SECONDARY2_VM_RELOAD)
			--self.Owner:SetAnimation(10000)	
			self.Owner:DoAnimationEvent(ACT_MP_RELOAD_STAND_LOOP)	
			self.Owner:EmitSoundEx("Weapon_Pomson.Reload")
			self.NextReload = CurTime() + (self.ReloadTime or self:SequenceDuration())
			
		end
	end
	
	if self.NextReloadStart and CurTime()>=self.NextReloadStart then
		self:SendWeaponAnim(ACT_SECONDARY2_VM_RELOAD)
		self.Owner:DoAnimationEvent(ACT_MP_RELOAD_STAND_LOOP)
		--self.Owner:SetAnimation(10000) -- reload loop
		self.NextReload = CurTime() + (self.ReloadTime or self:SequenceDuration())
		
		self.AmmoAdded = 1
		self.Owner:EmitSoundEx("Weapon_Pomson.Reload")
		 
		self.NextReloadStart = nil
	end
	
	self:Inspect()
end


function SWEP:PrimaryAttack()
	self:StopTimers()

	if not self:CallBaseFunction("PrimaryAttack") then return false end
	
	if self.Owner:GetMaterial() == "models/shadertest/predator" then return end
	
	auto_reload = self.Owner:GetInfoNum("tf_righthand", 1)
	
	self:SendWeaponAnim(ACT_SECONDARY2_VM_PRIMARYATTACK)
	self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
	if self then
		if self.Owner:GetInfoNum("tf_autoreload", 1) == 1 then
			if auto_reload then
				timer.Create("AutoReload", (self:SequenceDuration() + self.AutoReloadTime), 1, function() if IsValid(self) and IsValid(self.Owner) and isfunction(self:Reload()) then self:Reload() end end)
			end
		end
	end
	
	if self:Clip1() <= 0 then
		self:Reload()
	end
	
	if self.Owner:GetPlayerClass() == "spy" then
		if self.Owner:GetModel() == "models/player/scout.mdl" or  self.Owner:GetModel() == "models/player/soldier.mdl" or  self.Owner:GetModel() == "models/player/pyro.mdl" or  self.Owner:GetModel() == "models/player/demo.mdl" or  self.Owner:GetModel() == "models/player/heavy.mdl" or  self.Owner:GetModel() == "models/player/engineer.mdl" or  self.Owner:GetModel() == "models/player/medic.mdl" or  self.Owner:GetModel() == "models/player/sniper.mdl" or  self.Owner:GetModel() == "models/player/hwm/spy.mdl"	 or self.Owner:GetModel() == "models/player/kleiner.mdl" then
			if self.Owner:KeyDown( IN_ATTACK ) then
				if self.Owner:GetInfoNum("tf_robot", 0) == 0 then
					self.Owner:SetModel("models/player/spy.mdl") 
				else
					self.Owner:SetModel("models/bots/spy/bot_spy.mdl")
				end
				if IsValid( button) then 
					button:Remove() 
				end
				for _,v in pairs(ents.GetAll()) do
					if v:IsNPC() and not v:IsFriendly(self.Owner) then
						v:AddEntityRelationship(self.Owner, D_HT, 99)
					end
				end
				if self.Owner:Team() == TEAM_BLU then 
					self.Owner:SetSkin(1) 
				elseif self.Owner:Team() == TF_TEAM_PVE_INVADERS then 
					self.Owner:SetSkin(1) 
				else 
					self.Owner:SetSkin(0) 
				end 
				self.Owner:EmitSoundEx("player/spy_disguise.wav", 65, 100) 
			end
		end
	end
	
	self:RollCritical() -- Roll and check for criticals first
	
	self.Owner:ViewPunch( self.PunchView )
	
	self.NextReloadStart = nil
	self.NextReload = nil
	self.Reloading = false
	return true
end


function SWEP:ShootProjectile()
	if SERVER then
		local rocket = ents.Create("tf_projectile_pomson")
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
			rocket.critical = true
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
	
	self:ShootEffects()
end