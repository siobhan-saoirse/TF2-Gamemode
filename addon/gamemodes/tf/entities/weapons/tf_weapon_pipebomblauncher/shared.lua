if SERVER then
	AddCSLuaFile( "shared.lua" )
	
end

if CLIENT then

SWEP.PrintName			= "Stickybomb Launcher"

SWEP.GlobalCustomHUD = {HudDemomanPipes = true}
SWEP.CustomHUD = {HudBowCharge = true}
function SWEP:ClientStartCharge()
	self.ClientCharging = true
	self.ClientChargeStart = CurTime()
end

function SWEP:ClientEndCharge()
	self.ClientCharging = false
end

end

sound.Add( {
	name = "Taunt.Demo01FootSpin",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_foot_spin.wav"} 
} )
sound.Add( {
	name = "Weapon_Sticky_Jumper.Single",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"weapons/sticky_jumper_shoot.wav"} 
} )
sound.Add( {
	name = "Taunt.Demo01HandClap",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_hand_clap.wav"} 
} )
sound.Add( {
	name = "Demoman.Jeers11",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"vo/demoman_jeers11.wav"} 
} )
sound.Add( {
	name = "Demoman.Jeers10",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"vo/demoman_jeers10.wav"} 
} )
sound.Add( {
	name = "Demoman.Jeers09",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"vo/demoman_jeers09.wav"} 
} )
sound.Add( {
	name = "Demoman.Jeers08",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"vo/demoman_jeers08.wav"} 
} )
sound.Add( {
	name = "Demoman.Jeers07",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"vo/demoman_jeers07.wav"} 
} )
sound.Add( {
	name = "Demoman.Jeers06",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"vo/demoman_jeers06.wav"} 
} )
sound.Add( {
	name = "Demoman.Jeers05",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"vo/demoman_jeers05.wav"} 
} )
sound.Add( {
	name = "Demoman.Jeers04",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"vo/demoman_jeers04.wav"} 
} )
sound.Add( {
	name = "Demoman.Jeers03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"vo/demoman_jeers03.wav"} 
} )
sound.Add( {
	name = "Demoman.Jeers02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"vo/demoman_jeers02.wav"} 
} )
sound.Add( {
	name = "Demoman.Jeers01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"vo/demoman_jeers01.wav"} 
} )
sound.Add( {
	name = "Taunt.Demo01HandClap2",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_hand_clap.wav"} 
} )

SWEP.Base				= "tf_weapon_gun_base"

SWEP.Slot				= 1
SWEP.HasTeamColouredVModel = false
SWEP.HasTeamColouredWModel = false

SWEP.ViewModel			= "models/weapons/c_models/c_demo_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_stickybomb_launcher/c_stickybomb_launcher.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.ChargeTime = 4
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.MuzzleEffect = "muzzle_pipelauncher"
PrecacheParticleSystem("muzzle_pipelauncher")

SWEP.ShootSound = Sound("Weapon_StickyBombLauncher.Single")
SWEP.ShootCritSound = Sound("Weapon_StickyBombLauncher.SingleCrit")
SWEP.DetonateSound = Sound("Weapon_StickyBombLauncher.ModeSwitch")
SWEP.ChargeSound = Sound("weapons/stickybomblauncher_charge_up.wav")
SWEP.ReloadSound = Sound("Weapon_StickyBombLauncher.WorldReload")
SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_SECONDARY
SWEP.Primary.Delay          = 0.6
SWEP.ReloadTime = 0.7

SWEP.IsRapidFire = false
SWEP.ReloadSingle = true

SWEP.HoldType = "PRIMARY"
SWEP.HoldTypeHL2 = "ar2"

SWEP.MaxBombs = 8
SWEP.Bombs = {}

SWEP.ProjectileShootOffset = Vector(0, 13, -10)
SWEP.MinForce = 805
SWEP.MaxForce = 805*2.3
SWEP.AddPitch = -4

SWEP.SensorCone = 30
SWEP.NoSensorDetonateRadius = 100

SWEP.PunchView = Angle( -2, 0, 0 )

function SWEP:Deploy() 
	if CLIENT then
		HudBowCharge:SetProgress(0)
	end
				
	if self.Owner:IsPlayer() and not self.Owner:IsHL2() and self.Owner:Team() == TEAM_BLU and string.find(game.GetMap(), "mvm_") then
		timer.Create("Unstuck"..self.Owner:EntIndex(), 0.01, 0, function()
			if SERVER then
				if self.Owner:IsInWorld() == false then
					self.Owner:Spawn()
				end
			end
		end)
		self.Owner:SetBloodColor(BLOOD_COLOR_MECH)
	end
	
	return self:CallBaseFunction("Deploy")
end

function SWEP:OnEquipAttribute(a, owner)
	if a.attribute_class == "mult_maxammo_secondary" then
		self.Safe = true
	end
end

function SWEP:IsBombInSensorCone(ent)
	local dot = self.Owner:GetAimVector():Dot((ent:GetPos() - self.Owner:GetShootPos()):GetNormal())
	
	if not self.SensorCos then
		self.SensorCos = math.cos(math.rad(self.SensorCone * 0.5))
	end
	
	return dot >= self.SensorCos
end

function SWEP:InitOwner()
	self.Owner:SetNWInt("NumBombs", 0)
	self.Owner.Bombs = {}
end

function SWEP:CreateSounds()
	self.ChargeUpSound = CreateSound(self, self.ChargeSound)
	
	self.SoundsCreated = true
end

function SWEP:PrimaryAttack()
	if not self.IsDeployed then return false end
	if self.Reloading then return false end
	
	self.NextDeployed = nil
	
	-- Already charging
	if self.Charging then return end
	
	local Delay = self.Delay or -1
	local QuickDelay = self.QuickDelay or -1
	
	if (not(self.Primary.QuickDelay>=0 and self.Owner:KeyPressed(IN_ATTACK)) and Delay>=0 and CurTime()<Delay)
	or (self.Primary.QuickDelay>=0 and self.Owner:KeyPressed(IN_ATTACK) and QuickDelay>=0 and CurTime()<QuickDelay) then
		return
	end
	
	self.Delay =  CurTime() + self.Primary.Delay
	self.QuickDelay =  CurTime() + self.Primary.QuickDelay
	
	if not self:CanPrimaryAttack() then
		return
	end
	
	if self.NextReload or self.NextReloadStart then
		self.NextReload = nil
		self.NextReloadStart = nil
	end
	
	-- Start charging
	self.Charging = true
	self:SendWeaponAnim(self.VM_PULLBACK)
	
	if SERVER then
		self:CallOnClient("ClientStartCharge", "")
	end
	
	self.NextIdle2 = CurTime()+self:SequenceDuration()
	self.ChargeStartTime = CurTime()
end

function SWEP:Think()
	local BASESPEED = 3 --this is really bad if anyone has a better way of doing this please tell me
	local sp = 100
	
	
	if self.Charging then
		if (not self.Owner:KeyDown(IN_ATTACK) or CurTime() - self.ChargeStartTime > self.ChargeTime) then
			self.Charging = false
			
			self:SendWeaponAnim(self.VM_PRIMARYATTACK)
			self.Owner:DoAttackEvent()
			
			self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
			
			self:ShootProjectile()
			self:TakePrimaryAmmo(1)
			
			self.Delay =  CurTime() + self.Primary.Delay
			self.QuickDelay =  CurTime() + self.Primary.QuickDelay
			
			if SERVER then
				self:CallOnClient("ClientEndCharge", "")
			end
			
			if self:Clip1() <= 0 then
				self:Reload()
			end
			
			if SERVER and not self.Primary.NoFiringScene then
				self.Owner:Speak("TLK_FIREWEAPON", true)
			end
			
			self:RollCritical() -- Roll and check for criticals first
			
			if (game.SinglePlayer() or CLIENT) and self.ChargeUpSound then
				self.ChargeUpSound:Stop()
				self.ChargeUpSound = nil
			end
		else
			if (game.SinglePlayer() or CLIENT) and not self.ChargeUpSound then
				self.ChargeUpSound = CreateSound(self, self.ChargeSound)
				self.ChargeUpSound:Play()
			end
		end
	end
	self:CallBaseFunction("Think")
	self.Owner:SetWalkSpeed(BASESPEED * sp)
	
	if CLIENT then
		if self.ClientCharging and self.ClientChargeStart then
			HudBowCharge:SetProgress((CurTime()-self.ClientChargeStart) / self.ChargeTime)
		else
			HudBowCharge:SetProgress(0)
		end
	end
	
	
end

function SWEP:GlobalSecondaryAttack()
	if SERVER then
		self:DetonateProjectiles()
	end
end

function SWEP:ShootProjectile()
	if SERVER then
		if not self.Owner.Bombs then
			self:InitOwner()
		end
		
		if auto_reload then
			timer.Create("AutoReload", (self:SequenceDuration() + self.AutoReloadTime), 1, function() self:Reload() end)
		end
		
		local grenade = ents.Create("tf_projectile_pipe_remote")
		grenade:SetPos(self:ProjectileShootPos())
		grenade:SetAngles(self.Owner:EyeAngles())
		
		if self:Critical() then
			grenade.critical = true
		end
		grenade:SetOwner(self.Owner)
		
		self:InitProjectileAttributes(grenade)
		
		grenade:Spawn()
		if self.Safe == true then
			grenade:SetModel("models/weapons/w_models/w_stickybomb2.mdl")
		end

		if self:GetItemData().model_player == "models/workshop/weapons/c_models/c_kingmaker_sticky/c_kingmaker_sticky.mdl" then
			grenade:SetModel("models/workshop/weapons/c_models/c_kingmaker_sticky/w_kingmaker_stickybomb.mdl")
			grenade.ExplosionSound = Sound("Weapon_TackyGrendadier.Explode")
		end
		local force = Lerp((CurTime() - self.ChargeStartTime) / self.ChargeTime, self.MinForce, self.MaxForce)
		
		local vel = self.Owner:GetAimVector():Angle()
		vel.p = vel.p + self.AddPitch
		vel = vel:Forward() * force * (grenade.Mass or 10)
		
		grenade:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(-2000,2000)))
		grenade:GetPhysicsObject():ApplyForceCenter(vel)
		
		table.insert(self.Owner.Bombs, grenade)
		if #self.Owner.Bombs>self.MaxBombs then
			table.remove(self.Owner.Bombs, 1):DoExplosion()
		end
		
		self.Owner:SetNWInt("NumBombs", #self.Owner.Bombs)
		if self:GetItemData().model_player == "models/weapons/c_models/c_sticky_jumper/c_sticky_jumper.mdl" then
			grenade:SetModel("models/weapons/w_models/w_stickybomb2.mdl")
			self.CriticalChance = 0
			self.MaxBombs = 2
			grenade.ExplosionSound = Sound("weapons/sticky_jumper_explode1.wav")
		end
		end
	self:ShootEffects()
	self.Owner:ViewPunch( self.PunchView )
end

function SWEP:DetonateProjectiles(nosound, noexplode)
	if SERVER then
		local owner = (IsValid(self.Owner) and self.Owner) or self.CurrentOwner
		
		if not self or not self:IsValid() then return end
		
		if not owner.Bombs then
			self:InitOwner()
		end
		
		local det = false
		
		if not owner.Bombs then return end
		
		for k=#owner.Bombs,1,-1 do
			local bomb = owner.Bombs[k]
			local ready = bomb and (bomb.Ready or noexplode)
			
			if ready and bomb.DetonateMode == 1 and not noexplode then
				if bomb:GetPos():Distance(owner:GetShootPos()) > self.NoSensorDetonateRadius and not self:IsBombInSensorCone(bomb) then
					ready = false
				end
			end
			
			if ready then
				if noexplode then
					bomb:Break()
				else
					bomb:DoExplosion()
					det = true
				end
				table.remove(owner.Bombs, k)
			end
		end
		
		if det and not nosound then
			self.Owner:EmitSound(self.DetonateSound, 100, 100)
		end
		
		owner:SetNWInt("NumBombs", #owner.Bombs)
	end
end

function SWEP:OnRemove()
	self:DetonateProjectiles(true, true)
	
	if (game.SinglePlayer() or CLIENT) and self.ChargeUpSound then
		self.ChargeUpSound:Stop()
	end
end

