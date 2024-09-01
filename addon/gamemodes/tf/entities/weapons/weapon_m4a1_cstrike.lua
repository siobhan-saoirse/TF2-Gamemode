
if (!IsMounted("cstrike")) then return end
AddCSLuaFile()
SWEP.Base = "weapon_base"

SWEP.BobScale			= 0
SWEP.Category = "Counter-Strike: Source"
SWEP.PrintName = "M4A1" 
SWEP.Author = "Daisreich"

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.Spawnable = true

--SWEP.ViewModel = Model( "models/v_models/v_huntingrifle.mdl" )
SWEP.ViewModel = Model( "models/weapons/cstrike/c_rif_m4a1.mdl" )
SWEP.WorldModel = "models/weapons/w_rif_m4a1.mdl"
SWEP.ViewModelFOV = GetConVar("viewmodel_fov"):GetInt()
SWEP.UseHands = true
SWEP.HoldType = "AR2"
SWEP.Primary.Delay = 0.08
SWEP.Primary.ClipSize = 30  -- How much bullets are in the mag
SWEP.Primary.DefaultClip = 128 -- How much bullets preloaded when spawned
SWEP.Primary.Damage = 25
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Spread = 0.75
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Ammo = "SMG1" 
SWEP.Secondary.Ammo = "none"
SWEP.Primary.Recoil = 0.25
SWEP.Primary.Automatic = true
SWEP.Secondary.Automatic = true
SWEP.DeployAfterPickup = false
SWEP.HitDistance = 48
SWEP.ShootSound = Sound("^weapons/m4a1/m4a1_unsil-1.wav")
SWEP.ShootSound2 = Sound("^weapons/m4a1/m4a1-1.wav")
SWEP.ViewModelFlip = false
SWEP.IsSilenced = false
function SWEP:Deploy()
	self:SetWeaponHoldType( self.HoldType ) 
	if (!self.IsSilenced) then
		local vm = self:GetOwner():GetViewModel()
		if SERVER then
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("draw_unsil")))
		end
		timer.Stop("Idle"..self.Owner:EntIndex())
		timer.Stop("Idle2"..self.Owner:EntIndex())
		local vm = self:GetOwner():GetViewModel()
		timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("draw_unsil")) , 1, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle_unsil")))
			timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle_unsil")) , 0, function()
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle_unsil")))
			end)
		end)
		self.WorldModel = "models/weapons/w_rif_m4a1.mdl"
	else
	
		local vm = self:GetOwner():GetViewModel()
		if SERVER then
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("draw")))
		end
		timer.Stop("Idle"..self.Owner:EntIndex())
		timer.Stop("Idle2"..self.Owner:EntIndex())
		local vm = self:GetOwner():GetViewModel()
		timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("draw")) , 1, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
			timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle")) , 0, function()
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
			end)
		end)
		self.WorldModel = "models/weapons/w_rif_m4a1_silencer.mdl"
		
	end
	return true
end 

local phys_pushscale = GetConVar( "phys_pushscale" )

function SWEP:DealDamage()

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
	bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
	bullet.Tracer = 1
	bullet.Force = self.Primary.Force 
	bullet.Damage = self.Primary.Damage 
	bullet.AmmoType = self.Primary.Ammo 
	 
	local rnda = self.Primary.Recoil * -1 
	local rndb = self.Primary.Recoil * math.random(-1, 1) 
	  
	self:ShootEffects()
	 
	self.Owner:FireBullets( bullet ) 
	if (!self.IsSilenced) then
		self:EmitSound(self.ShootSound, 85,100)	
		self.Owner:ViewPunch( Angle( rnda,0,0 ) ) 
		self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("shoot"..math.random(1,3).."_unsil")))
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) 
		timer.Stop("Idle"..self.Owner:EntIndex())
		timer.Stop("Idle2"..self.Owner:EntIndex())
		local vm = self:GetOwner():GetViewModel()
		timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("shoot"..math.random(1,3).."_unsil")) , 1, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle_unsil")))
			timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle_unsil")) , 0, function()
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle_unsil")))
			end)
		end)
	else
		self:EmitSound(self.ShootSound2, 60,100)	
		self.Owner:ViewPunch( Angle( rnda,0,0 ) ) 
		self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("shoot"..math.random(1,3))))
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) 
		timer.Stop("Idle"..self.Owner:EntIndex())
		timer.Stop("Idle2"..self.Owner:EntIndex())
		local vm = self:GetOwner():GetViewModel()
		timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("shoot"..math.random(1,3))) , 1, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
			timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle")) , 0, function()
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
			end)
		end)
	
	end
	
end 
function SWEP:SecondaryAttack()
	local vm = self:GetOwner():GetViewModel()
	if (!self.IsSilenced) then
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("add_silencer")))
		timer.Stop("Idle"..self.Owner:EntIndex())
		timer.Stop("Idle2"..self.Owner:EntIndex())
		timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("add_silencer")) , 1, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
			timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle")) , 0, function()
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
			end)
		end)
		self.IsSilenced = true
		self.WorldModel = "models/weapons/w_rif_m4a1_silencer.mdl"
	else
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("detach_silencer")))
		timer.Stop("Idle"..self.Owner:EntIndex())
		timer.Stop("Idle2"..self.Owner:EntIndex())
		timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("detach_silencer")) , 1, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle_unsil")))
			timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle_unsil")) , 0, function()
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle_unsil")))
			end)
		end)
		self.IsSilenced = false
		self.WorldModel = "models/weapons/w_rif_m4a1.mdl"
	end
	self:SetNextPrimaryFire( CurTime() + 1.5 ) 
	self:SetNextSecondaryFire( CurTime() + 1.5 ) 
end 

function SWEP:Reload()
	if (!self.IsSilenced) then
		local vm = self:GetOwner():GetViewModel()
		local reload = "reload_unsil"
		if (self:Clip1() < 1) then
			reload = 'reload_unsil'
			self:DefaultReload(vm:GetSequenceActivity(vm:LookupSequence("reload_unsil")))
		else
			self:DefaultReload(vm:GetSequenceActivity(vm:LookupSequence("reload_unsil")))
		end
		if SERVER then
			if (string.find(self:GetClass(),"smg") or string.find(self:GetClass(),"m4a1")) then
				self.Owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RELOAD_SMG1,true,true )
				umsg.Start("PlaySMGNormalWeaponWorldReload")
					umsg.Entity(self)	
				umsg.End()
			end
		end
		timer.Stop("Idle"..self.Owner:EntIndex())
		timer.Stop("Idle2"..self.Owner:EntIndex())
		timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence(reload)) , 1, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle_unsil")))
			timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle_unsil")) , 0, function()
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle_unsil")))
			end)
		end)
	else
	
		local vm = self:GetOwner():GetViewModel()
		local reload = "reload"
		if (self:Clip1() < 1) then
			reload = 'reload'
			self:DefaultReload(vm:GetSequenceActivity(vm:LookupSequence("reload")))
		else
			self:DefaultReload(vm:GetSequenceActivity(vm:LookupSequence("reload")))
		end
		if SERVER then
			if (string.find(self:GetClass(),"smg") or string.find(self:GetClass(),"m4a1")) then
				self.Owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RELOAD_SMG1,true,true )
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
	if (IsValid(self.Owner) and string.StartWith(self.Owner:GetModel(),"models/infected/")) then
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
			local origin = newpos 
			local angles = newang
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

