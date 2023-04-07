-- Real class name: tf_weapon_bet_rocketlauncher (see shd_items.lua)

if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then

SWEP.PrintName			= "Cow Mangler"
SWEP.Slot				= 0
SWEP.HasCModel = true

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_soldier_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_drg_cowmangler/c_drg_cowmangler.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.MuzzleEffect = ""
 
SWEP.ShootSound = Sound("Weapon_CowMangler.Single")
SWEP.ShootCritSound = Sound("Weapon_CowMangler.Single")
SWEP.CustomExplosionSound = Sound("Weapon_CowMangler.Explode")
SWEP.Primary.Reload = Sound("Weapon_CowMangler.Reload")
SWEP.ReloadSoundFinish = Sound("Weapon_CowMangler.ReloadFinal")

SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8

SWEP.IsRapidFire = false
SWEP.ReloadSingle = true

SWEP.HoldType = "PRIMARY2"

SWEP.ProjectileShootOffset = Vector(0, 13, -4)

SWEP.PunchView = Angle( 0, 0, 0 )

SWEP.Properties = {}

function SWEP:ShootProjectile()
	self.ShootCritSound = Sound("Weapon_CowMangler.Single")
	if SERVER then
		local rocket = ents.Create("tf_drg_rocket")
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
			rocket.critical = false
		end
		
		for k,v in pairs(self.Properties) do
			rocket[k] = v
		end
		
		rocket:SetOwner(self.Owner)
		self:InitProjectileAttributes(rocket)
		rocket.ExplosionSound = "weapons/cow_mangler_explosion_normal_0"..math.random(1,6)..".wav"
		
		rocket:Spawn()
		rocket:Activate()
	end	
	
	self:ShootEffects()
end


function SWEP:SecondaryAttack()
	if (self:Clip1() < 4) then return end
	if self:GetItemData().model_player == "models/workshop/weapons/c_models/c_russian_riot/c_russian_riot.mdl" then
		self.ShootSound = Sound(")weapons/family_business_shoot.wav")
		self.ShootCritSound = Sound(")weapons/family_business_shoot.wav")
		self.Primary.ClipSize = 8
		self.Primary.DefaultClip = 8
		self.Primary.Delay = 0.5
	end
	if self:GetItemData().model_player == "models/workshop/weapons/c_models/c_reserve_shooter/c_reserve_shooter.mdl" then
		self.Primary.ClipSize = 3
		self.Primary.DefaultClip = 3
	end
	self:StopTimers()
	if self.Owner:GetMaterial() == "models/shadertest/predator" then return end
	
	auto_reload = self.Owner:GetInfoNum("tf_righthand", 1)
	
	if self:Clip1() >= 1 then
		self:SendWeaponAnim(ACT_PRIMARY_VM_PRIMARYATTACK_3)
	end
	self.ShootCritSound = Sound("Weapon_CowMangler.Single")
	if not self:CallBaseFunction("PrimaryAttack") then return false end
	if ( IsFirstTimePredicted() ) then
		if SERVER then
			self:GetOwner():SetClassSpeed(self:GetOwner():GetClassSpeed() * 0.25)
		end
		self:SetNextPrimaryFire(CurTime() + 2.2)
		self:SetNextSecondaryFire(CurTime() + 2.2)
	end
	if ( IsFirstTimePredicted() ) then
		self:ShootProjectile2()
		if SERVER then
			self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_PRIMARY_SUPER,true)
		end
		if self:GetVisuals() and self:GetVisuals()["sound_single_shot"] then
			self.ShootSound = self:GetVisuals()["sound_single_shot"]
			self.ShootCritSound = self:GetVisuals()["sound_burst"]
		end
		timer.Simple(0.35 * self.Owner:GetViewModel():GetPlaybackRate(), function()
			if CLIENT then
				if (self:GetItemData().model_player == "models/weapons/c_models/c_shotgun/c_shotgun.mdl" || self:GetItemData().model_player == "models/workshop/weapons/c_models/c_russian_riot/c_russian_riot.mdl" || self:GetItemData().model_player == "models/workshop/weapons/c_models/c_reserve_shooter/c_reserve_shooter.mdl") then
					----PrintTable(self.CModel:GetAttachments())
					local effectdata = EffectData()
					effectdata:SetEntity( self.Owner:GetViewModel() )
					effectdata:SetOrigin( self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass")).Pos )
					effectdata:SetAngles( Angle(self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass")).Ang.x,self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass")).Ang.y,self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass")).Ang.z) )
					util.Effect( "ShotgunShellEject", effectdata )
				end
			end
		end)
	end
	

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
						if SERVER then
							v:AddEntityRelationship(self.Owner, D_HT, 99)
						end
					end
				end
				if self.Owner:Team() == TEAM_BLU then 
					self.Owner:SetSkin(1) 
				elseif self.Owner:Team() == TF_TEAM_PVE_INVADERS then 
					self.Owner:SetSkin(1) 
				else 
					self.Owner:SetSkin(0) 
				end 
				self.Owner:EmitSound("player/spy_disguise.wav", 65, 100) 
			end
		end
	end
	timer.Simple(2.1, function()
		if (self:Clip1() == self.Primary.ClipSize) then
			self:TakePrimaryAmmo(4)
		end
		self.Owner:ViewPunch( self.PunchView )

	end)
	self:RollCritical() -- Roll and check for criticals first
	
	
	self.NextReloadStart = nil
	self.NextReload = nil
	self.Reloading = false
	
	return true
end

function SWEP:ShootProjectile2()
	if (self:Clip1() < 4) then return end
	
	self:EmitSound("Weapon_CowMangler.Charging")
	timer.Simple(2.1,function()
		if SERVER then
			self.Owner:ResetClassSpeed()
			local rocket = ents.Create("tf_drg_rocket")
			rocket:SetPos(self:ProjectileShootPos())
			local ang = self.Owner:EyeAngles()
			
			if self.WeaponMode == 1 then
				local charge = (CurTime() - self.ChargeStartTime) / self.ChargeTime
				rocket.Gravity = Lerp(1 - charge, self.MinGravity, self.MaxGravity)
				rocket.BaseSpeed = Lerp(charge, self.MinForce, self.MaxForce)
				ang.p = ang.p + Lerp(1 - charge, self.MinAddPitch, self.MaxAddPitch)
			end
			
			rocket:SetAngles(ang)
			
			rocket.critical = true
			
			for k,v in pairs(self.Properties) do
				rocket[k] = v
			end
			
			rocket:SetOwner(self.Owner)
			self:InitProjectileAttributes(rocket)
			rocket.ExplosionSound = "weapons/cow_mangler_explosion_normal_0"..math.random(1,6)..".wav"
			
			rocket:Spawn()
			rocket:Activate()
		end	
	end)
	
end