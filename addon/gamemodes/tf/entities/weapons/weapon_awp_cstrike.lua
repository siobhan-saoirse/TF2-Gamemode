
if (!IsMounted("cstrike")) then return end
AddCSLuaFile()
SWEP.Base = "weapon_base"
SWEP.Category = "Counter-Strike: Source"
SWEP.PrintName = "AWP"
SWEP.Author = "Daisreich"
 
SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.Spawnable = true

--SWEP.ViewModel = Model( "models/v_models/v_huntingrifle.mdl" )
SWEP.ViewModel = Model( "models/weapons/v_snip_awp.mdl" )
SWEP.WorldModel = "models/weapons/w_snip_awp.mdl"
SWEP.ViewModelFOV = 75
SWEP.UseHands = true
SWEP.HoldType = "crossbow"
SWEP.Primary.Delay = 1.455
SWEP.Primary.ClipSize = 10  -- How much bullets are in the mag
SWEP.Primary.DefaultClip = 10 -- How much bullets preloaded when spawned
SWEP.Primary.Damage = 115
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Spread = 0.000020
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Ammo = "SniperRound" 
SWEP.Secondary.Ammo = "none"
SWEP.Primary.Recoil = 0.5
SWEP.Primary.Automatic = true
SWEP.Secondary.Automatic = true
SWEP.DeployAfterPickup = false
SWEP.HitDistance = 48
SWEP.ShootSound = Sound("Weapon_AWP.Single")
SWEP.ViewModelFlip = true
function SWEP:Deploy()
	self:SetWeaponHoldType( self.HoldType ) 
		local vm = self:GetOwner():GetViewModel()
		if SERVER then
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("awm_draw")))
		end
		timer.Stop("awm_idle"..self.Owner:EntIndex())
		timer.Stop("Idle2"..self.Owner:EntIndex())
		local vm = self:GetOwner():GetViewModel()
		timer.Create("awm_idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("awm_draw")) , 1, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("awm_idle")))
			timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("awm_idle")) , 0, function()
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("awm_idle")))
			end)
		end)
	return true
end 

local phys_pushscale = GetConVar( "phys_pushscale" )

function SWEP:DealDamage()

end

function SWEP:SecondaryAttack( right )

	if (not self.NextAllowZoom or CurTime()>self.NextAllowZoom) and self.Owner:IsOnGround() then
		self:ToggleZoom()
		self.NextAllowZoom = CurTime() + 0.4
	elseif self.NextAutoZoomIn then -- No, don't zoom me in automatically after that
		self.NextAutoZoomIn = nil
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

function SWEP:ZoomIn()
	self:SetWeaponHoldType("rpg")
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

function SWEP:Think()

	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()

	local meleetime = self:GetNextMeleeAttack()

	if ( meleetime > 0 && CurTime() > meleetime ) then

		self:DealDamage()

		self:SetNextMeleeAttack( 0 )

	end
end


function SWEP:Holster()

	self:SetNextMeleeAttack( 0 )
	self:ZoomOut()
	
	return true

end

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	self:NetworkVar( "Int", 2, "Combo" )

end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end 

function SWEP:Holster()

	self:SetNextMeleeAttack( 0 )
	timer.Stop("Idle2"..self.Owner:EntIndex())

	return true

end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	 
	local vm = self:GetOwner():GetViewModel()
	local bullet = {} 
	bullet.Num = self.Primary.NumberofShots 
	bullet.Src = self.Owner:GetShootPos() 
	bullet.Dir = self.Owner:GetAimVector() 
	bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
	bullet.Tracer = 1
	bullet.Force = self.Primary.Force 
	bullet.Damage = self.Primary.Damage 
	bullet.AmmoType = self.Primary.Ammo 
	 
	local rnda = self.Primary.Recoil * -1 
	local rndb = self.Primary.Recoil * math.random(-1, 1) 
	  
	self:ShootEffects()
	 
	self.Owner:FireBullets( bullet ) 
		self:EmitSound(self.ShootSound, 85,100)	
		self.Owner:ViewPunch( Angle( rnda,0,0 ) ) 
		self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("awm_fire")))
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) 
		timer.Stop("awm_idle"..self.Owner:EntIndex())
		timer.Stop("Idle2"..self.Owner:EntIndex())
		local vm = self:GetOwner():GetViewModel()
		timer.Create("awm_idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("awm_fire")) , 1, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("awm_idle")))
			timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("awm_idle")) , 0, function()
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("awm_idle")))
			end)
		end)
	
end 
function SWEP:AdjustMouseSensitivity()
	if self.ZoomStatus then
		return 0.35
	end
end

function SWEP:ZoomOut()
	self:SetWeaponHoldType("crossbow")
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
	if self.ZoomStatus then 
		self.ZoomedVeryClose = false
		self:ZoomOut()
	else 
		if (self.ZoomStatus and !self.ZoomedVeryClose) then
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


function SWEP:Reload()
		local vm = self:GetOwner():GetViewModel()
		local reload = "awm_reload"
		if self.ZoomStatus and !self.Owner:KeyDown(IN_WALK) then 
			self.ZoomedVeryClose = false
			self:ZoomOut()
		end
		if (self:Clip1() < 1) then
			reload = 'awm_reload'
			self:DefaultReload(vm:GetSequenceActivity(vm:LookupSequence("awm_reload")))
			if SERVER then
				self.Owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RELOAD_SMG1,true,true )
			end
		else
			self:DefaultReload(vm:GetSequenceActivity(vm:LookupSequence("awm_reload")))
			if SERVER then
				self.Owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RELOAD_SMG1,true,true )
			end
		end
		timer.Stop("awm_idle"..self.Owner:EntIndex())
		timer.Stop("Idle2"..self.Owner:EntIndex())
		timer.Create("awm_idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence(reload)) , 1, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("awm_idle")))
			timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("awm_idle")) , 0, function()
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("awm_idle")))
			end)
		end)
end