if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Gun"
end

SWEP.Base				= "tf_weapon_base"

SWEP.ViewModel			= "models/weapons/v_models/v_scattergun_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_scattergun.mdl"

SWEP.MuzzleEffect = "muzzle_flash"
SWEP.MuzzleOffset = Vector(0,0,0)

SWEP.ShootSound = Sound("")
SWEP.ShootCritSound = Sound("")
SWEP.ReloadSound = Sound("")
SWEP.TracerEffect = "bullet_tracer01"
PrecacheParticleSystem("muzzle_flash")

SWEP.BulletsPerShot = 1
SWEP.BulletSpread = 0.2

SWEP.PunchView = Angle( 0, 0, 0 )

SWEP.HoldType = "PRIMARY"

SWEP.AutoReloadTime = 0.01

SWEP.CriticalChance = 1.5
idle_timer = 1
end_timer = 1
post_timer = 5.30

inspecting = false
inspecting_post = false

CreateClientConVar("tf_autoreload", "1", true, true)

function SWEP:ShootPos()
	--local vm = self.Owner:GetViewModel()
	--return vm:GetAttachment(vm:LookupAttachment("muzzle"))
	
	return self:GetAttachment(self:LookupAttachment("muzzle")).Pos
end

function SWEP:PrimaryAttack()
	if not self.IsDeployed then return false end 
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
	
	if (self:CanPrimaryAttack() and CurTime() > self:GetNextPrimaryFire() and self:Clip1() >= 0) then
		if SERVER then
			self:SendWeaponAnim(self.VM_PRIMARYATTACK)
		end
		
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		self:ShootEffects()
	end
	if not self:CallBaseFunction("PrimaryAttack") then return false end
	if ( IsFirstTimePredicted() ) then
		self:ShootProjectile(self.BulletsPerShot, self.BulletSpread)
		self.Owner:DoAttackEvent()
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
				local ply = self.Owner 
				if (ply:GetModel() == "models/player/scout.mdl") then
					ply.playerclass = "Scout"
				elseif (ply:GetModel() == "models/player/soldier.mdl") then
					ply.playerclass = "Soldier"
				elseif (self:GetModel() == "models/player/pyro.mdl") then
					ply.playerclass = "Pyro"
				elseif (ply:GetModel() == "models/player/demo.mdl") then
					ply.playerclass = "Demoman"
				elseif (ply:GetModel() == "models/player/heavy.mdl") then
					ply.playerclass = "Heavy"
				elseif (ply:GetModel() == "models/player/engineer.mdl") then
					ply.playerclass = "Engineer"
				elseif (ply:GetModel() == "models/player/medic.mdl") then
					ply.playerclass = "Medic"
				elseif (ply:GetModel() == "models/player/sniper.mdl") then
					ply.playerclass = "Medic"
				else
					local class = ply:GetPlayerClass()
					ply.playerclass = string.upper(string.sub(class,1,1))..string.sub(class,2)	
				end
				self.Owner:EmitSound("player/spy_disguise.wav", 65, 100) 
			end
		end
	end
	
	self:TakePrimaryAmmo(1)
	self:RollCritical() -- Roll and check for criticals first
	
	self.Owner:ViewPunch( self.PunchView )
	
	self.NextReloadStart = nil
	self.NextReload = nil
	self.Reloading = false
	
	return true
end

--local force_bullets_lagcomp = CreateConVar("force_bullets_lagcomp", 0, {FCVAR_REPLICATED})

function SWEP:ShootProjectile(num_bullets, aimcone)
	self:StopTimers()
	
	if self.Owner:GetMaterial() == "models/shadertest/predator" then return end
	
	--local b = force_bullets_lagcomp:GetBool()
	
	--if b then
		--self.Owner:LagCompensation(true)
	--end
	
	self:FireTFBullets{
		Num = num_bullets,
		Src = self.Owner:GetShootPos(),
		--Src = self:ShootPos(),
		Dir = self.Owner:GetAimVector(),
		Spread = Vector(aimcone, aimcone, 0),
		Attacker = self.Owner,
		
		Team = GAMEMODE:EntityTeam(self.Owner),
		Damage = self.BaseDamage,
		RampUp = 0,
		Falloff = 0,
		Critical = self:Critical(),
		CritMultiplier = 0,
		DamageModifier = 0,
		DamageRandomize = 0,
		
		Tracer = 1,
		TracerName = self.TracerEffect,
		Force = 1,
	}
	
	--if b then
		--self.Owner:LagCompensation(false)
	--end
	
end

function SWEP:ShootEffects()
	if (!self:CanPrimaryAttack()) then return end
			if (self:Critical()) then
				self:EmitSound(self.ShootCritSound)
			else
				self:EmitSound(self.ShootSound)
			end
	local wmodel = self.WorldModelOverride or self.WorldModel
	if (self.Owner:GetNWBool("NoWeapon")) then
		self.WorldModel = "models/empty.mdl"
	else
		self.WorldModel = wmodel;
	end;
	local vm = self.Owner:GetViewModel()
	if CLIENT then
		if IsValid(self.CModel) then
			self.CModel:SetModel(wmodel) 
			self.CModel:SetNoDraw(true)
			self.CModel:SetParent(vm)
			self.CModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
		elseif IsValid(vm) and !IsValid(self.CModel) then
			self.CModel = ClientsideModel(wmodel)
			if not IsValid(self.CModel) then return end
			self.CModel:SetModel(wmodel)
			self.CModel:SetNoDraw(true)
			self.CModel:SetParent(vm)
			self.CModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
			self.CModel:Spawn()
			self.CModel:Activate()
		end
	end
	if self.Owner:GetMaterial() == "models/shadertest/predator" then return end
	if SERVER then
		if self.MuzzleEffect and self.MuzzleEffect~="" then
			umsg.Start("DoMuzzleFlash")
				umsg.Entity(self)
			umsg.End()
		end
	end
end