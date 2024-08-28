
if (!IsMounted("left4dead")) then return end
AddCSLuaFile()
SWEP.Base = "weapon_smg_silenced"
SWEP.Category = "Left 4 Dead 2"
SWEP.PrintName = "Military Sniper Rifle"
SWEP.Author = "Daisreich"

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/v_models/v_sniper_military.mdl" )
SWEP.WorldModel = "models/w_models/weapons/w_sniper_military.mdl"
SWEP.ViewModelFOV = 50
SWEP.UseHands = true
SWEP.HoldType = "crossbow"
SWEP.Primary.Delay = 0.21
SWEP.Primary.ClipSize = 30  -- How much bullets are in the mag
SWEP.Primary.DefaultClip = 128 -- How much bullets preloaded when spawned
SWEP.Primary.Damage = 35
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Spread = 0.35
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Ammo = "SniperRound" 
SWEP.Secondary.Ammo = "none"
SWEP.Primary.Recoil = 0.25
SWEP.Primary.Automatic = false
SWEP.Secondary.Automatic = true
SWEP.DeployAfterPickup = false
SWEP.HitDistance = 48
SWEP.ShootSound = Sound("Sniper_Military.Fire")

function SWEP:ToggleZoom()
	if self.ZoomStatus then self:ZoomOut()
	else self:ZoomIn()
	end
end

function SWEP:Deploy()
	self:SetWeaponHoldType( self.HoldType )
	local vm = self:GetOwner():GetViewModel()
	local deploy = "deploy"
	if (!self.DeployAfterPickup) then
		deploy = "deploy"
		if SERVER then
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("deploy")))
		end
		self.DeployAfterPickup = true
	else
		if SERVER then
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("deploy")))
		end
	end
	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Stop("Idle2"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence(deploy)), 1, function()
		if SERVER then
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
		end
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle")) , 0, function()
			if SERVER then
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
			end
		end)
	end)
	return true
end 

function SWEP:Holster()

	self:SetNextMeleeAttack( 0 )
	self:ZoomOut()
	timer.Stop("Idle2"..self.Owner:EntIndex())

	return true

end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end 

function SWEP:PrimaryAttack()
 
	if ( !self:CanPrimaryAttack() ) then return end
	 
	local vm = self:GetOwner():GetViewModel()
	local bullet = {} 
	bullet.Num = self.Primary.NumberofShots 
	bullet.Src = self.Owner:GetShootPos() 
	bullet.Dir = self.Owner:GetAimVector()
	if (!self.ZoomStatus) then
		bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
	end
	bullet.Tracer = 1
	bullet.Force = self.Primary.Force 
	bullet.Damage = self.Primary.Damage 
	bullet.AmmoType = self.Primary.Ammo 
	 
	local rnda = self.Primary.Recoil * -1 
	local rndb = self.Primary.Recoil * math.random(-1, 1) 
	 
	self:ShootEffects()
	 
	self.Owner:FireBullets( bullet ) 
	self:EmitSound(self.ShootSound, 75)	
	self.Owner:ViewPunch( Angle( rnda,0,0 ) ) 
	self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
	self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("fire")))
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) 
	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Stop("Idle2"..self.Owner:EntIndex())
	local vm = self:GetOwner():GetViewModel()
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("fire")) , 1, function()
		if SERVER then
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
		end
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle")) , 0, function()
			if SERVER then
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
			end
		end)
	end)
end 

function SWEP:SecondaryAttack( right )
		if (self.Owner:KeyDown(IN_WALK)) then return end
		if (self.ZoomStatus) then
			self:ZoomOut()
			return
		end
	if SERVER then
		self.Owner:DoAnimationEvent( ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,true,true )
	end

	local anim = "melee"

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	self:EmitSound( ")player/survivor/swing/swish_weaponswing_swipe"..math.random(5,6)..".wav", 75, 100 )

	self:SetNextMeleeAttack( CurTime() + 0.1 )

	self:SetNextPrimaryFire( CurTime() + 0.7 )
	self:SetNextSecondaryFire( CurTime() + 0.7 )

end
function SWEP:Reload()
	local vm = self:GetOwner():GetViewModel()
	local reload = "reload"
	self:ZoomOut()
	if (self:Clip1() < 1) then
		reload = 'reload'
		self:DefaultReload(vm:GetSequenceActivity(vm:LookupSequence("reload")))
		if SERVER then
			if (self:Clip1() < 15) then
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("reload")))
			end
		end
	else
		self:DefaultReload(vm:GetSequenceActivity(vm:LookupSequence("reload")))
		if SERVER then
			if (self:Clip1() < 15) then
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("reload")))
			end
		end
	end
	if SERVER then
		self.Owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RELOAD_AR2,true,true )
		if (string.find(self:GetClass(),"smg") or string.find(self:GetClass(),"m16a1")) then
			umsg.Start("PlaySMGNormalWeaponWorldReload")
				umsg.Entity(self)	
			umsg.End()
		end
	end
	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Stop("Idle2"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence(reload)) , 1, function()
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle")) , 0, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
		end)
	end)
end

function SWEP:ZoomIn()
	if CLIENT then return end
	
	if SERVER then
		self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_PREFIRE, true)
		self.Owner:EmitSound("Default.Zoom")
	end
	self.NextAutoZoomIn = nil
	self.Owner:SetFOV(10,0.2,self)
	if not self.ZoomStatus then
		self.Primary.Spread = 0.001
		self.ZoomStatus = true
		umsg.Start("SetZoomStatus")
			umsg.Entity(self)
			umsg.Bool(true)
		umsg.End()
		--self.Owner:DoAnimationEvent(ACT_MP_DEPLOYED, true)
		
		--self.Owner:DrawViewModel(false)
	end
end

function SWEP:AdjustMouseSensitivity()
	if self.ZoomStatus then
		return 0.35
	end
end

function SWEP:Think()

	if (self.Owner:KeyPressed(IN_ATTACK2) and self.Owner:KeyDown(IN_WALK)) then
		if SERVER then
			if (not self.NextAllowZoom or CurTime()>self.NextAllowZoom) and self.Owner:IsOnGround() then
				self:ToggleZoom()
				self.NextAllowZoom = CurTime() + 0.4
			elseif self.NextAutoZoomIn then -- No, don't zoom me in automatically after that
				self.NextAutoZoomIn = nil
			end
		end
	end
	return self.BaseClass.Think(self)
end
function SWEP:ZoomOut()
	if CLIENT then return end
	
	if SERVER then
		self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_POSTFIRE, true)
	end
	self.Primary.Spread = 0.35
	self.NextAutoZoomOut = nil
	self.Owner:SetFOV(0,0.2,self)
	if self.ZoomStatus then
		self.Owner:EmitSound("Default.Zoom")
		self.ZoomStatus = false
		umsg.Start("SetZoomStatus")
			umsg.Entity(self)
			umsg.Bool(false)
		umsg.End()
		self.Owner:DoAnimationEvent(ACT_MP_STAND_PRIMARY, true)
		
		--self.Owner:DrawViewModel(true)
		self.ChargeTimerStart = nil
	end
	
	if not self.DisableZoomSpeedPenalty then
		local owner = self.CurrentOwner or self.Owner
		owner:ResetClassSpeed()
	end
end

function SWEP:ToggleZoom()
	if self.ZoomStatus and !self.Owner:KeyDown(IN_WALK) then 
		self.ZoomedVeryClose = false
		self:ZoomOut()
	else 
		if (self.Owner:KeyDown(IN_WALK) and self.ZoomStatus and !self.ZoomedVeryClose) then
			if SERVER then
				self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_PREFIRE, true)
				self.Owner:EmitSound("Default.Zoom")
			end
			self.ZoomedVeryClose = true
			self.Owner:SetFOV(2,0.2,self)
		else
			self.ZoomedVeryClose = false
			self:ZoomIn()
		end
	end
end