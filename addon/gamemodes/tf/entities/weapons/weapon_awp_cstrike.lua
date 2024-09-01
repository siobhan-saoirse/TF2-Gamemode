
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

local cvar_bob = GetConVar("tf_cl_bob")
local cvar_bobup = GetConVar("tf_cl_bobup")
local cvar_bobcycle = GetConVar("tf_cl_bobcycle")

local bobtime = 0
local lastbobtime = 0
local lastspeed = 0
local cycle = 0
local speed = 0
local flmaxSpeedDelta = 0
local bob_offset = 0

function SWEP:CalcViewModelBobHelper(  )
	local cl_bob = cvar_bob:GetFloat()
	local cl_bobcycle = math.max(cvar_bobcycle:GetFloat(), 0.1)
	local cl_bobup = cvar_bobup:GetFloat()
	
	local ply = LocalPlayer()
	
	if ply:ShouldDrawLocalPlayer() then return 0 end

	local cltime = CurTime()
	local cycle = cltime - math.floor(cltime/cl_bobcycle)*cl_bobcycle
	cycle = cycle / cl_bobcycle
	if (cycle < cl_bobup) then
		cycle = math.pi * cycle / cl_bobup
	else
		cycle = math.pi + math.pi*(cycle-cl_bobup)/(1.0 - cl_bobup)
	end

	local velocity = ply:GetVelocity()

	self.g_verticalBob = math.Clamp(math.sqrt(velocity[1]*velocity[1] + velocity[2]*velocity[2]),-320.0,320.0) * cl_bob
	self.g_verticalBob = self.g_verticalBob*0.3 + self.g_verticalBob*0.7*math.sin(cycle)
	if (self.g_verticalBob > 4) then
		self.g_verticalBob = 4
	elseif (self.g_verticalBob < -7) then
		self.g_verticalBob = -7
	end
	
	local cycle2 = cltime - math.floor(cltime/(cl_bobcycle*2))*(cl_bobcycle*2)
	cycle2 = cycle2 / cl_bobcycle*0.5
	if (cycle2 < cl_bobup) then
		cycle2 = math.pi * cycle2 / cl_bobup
	else
		cycle2 = math.pi + math.pi*(cycle2-cl_bobup)/(1.0 - cl_bobup)
	end

	self.g_lateralBob = math.Clamp(math.sqrt(velocity[1]*velocity[1] + velocity[2]*velocity[2]),-320.0,320.0) * cl_bob
	self.g_lateralBob = self.g_lateralBob*0.3 + self.g_lateralBob*0.7*math.sin(cycle2)
	if (self.g_lateralBob > 4) then
		self.g_lateralBob = 4
	elseif (self.g_lateralBob < -7) then
		self.g_lateralBob = -7
	end
	return 0.0
end

function SWEP:VectorMA( start, scale, direction, dest )
	--[[
	dest.x = start.x + scale * direction.x;
	dest.y = start.y + scale * direction.y;
	dest.z = start.z + scale * direction.z;
	]]
	return Vector(start.x + scale * direction.x,start.y + scale * direction.y,start.z + scale * direction.z)
end

function SWEP:CalcViewModelView(vm, oldpos, oldang, newpos, newang)
	if (string.StartWith(self.Owner:GetModel(),"models/infected/")) then
		return oldpos, oldang
	else
		-- actual code, for reference
		--[[
		
		Vector	forward, right;
		AngleVectors( angles, &forward, &right, NULL );

		CalcViewmodelBob();

		// Apply bob, but scaled down to 40%
		VectorMA( origin, g_verticalBob * 0.4f, forward, origin );

		// Z bob a bit more
		origin[2] += g_verticalBob * 0.1f;

		// bob the angles
		angles[ ROLL ]	+= g_verticalBob * 0.5f;
		angles[ PITCH ]	-= g_verticalBob * 0.4f;

		angles[ YAW ]	-= g_lateralBob  * 0.3f;

	//	VectorMA( origin, g_lateralBob * 0.2f, right, origin );

		]]
		if CLIENT then
			local forward = self.Owner:GetForward()
			local right = self.Owner:GetRight()
			local origin = oldpos
			local angles = oldang
			self:CalcViewModelBobHelper()

			// Apply bob, but scaled down to 40%
			origin = self:VectorMA( origin, self.g_verticalBob * 0.4, forward, origin );

			// Z bob a bit more
			origin.z = origin.z + self.g_verticalBob * 0.1;

			// bob the angles
			angles.r	= angles.r + self.g_verticalBob * 0.5;
			angles.p	= angles.p - self.g_verticalBob * 0.4;
			angles.y = angles.y - self.g_lateralBob  * 0.3;

			--origin = self:VectorMA( origin, self.g_lateralBob * 0.2, right, origin );
			return origin, angles
		else
			return oldpos, oldang
		end
	end
end

