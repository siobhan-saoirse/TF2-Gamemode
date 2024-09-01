
if (!IsMounted("cstrike")) then return end
AddCSLuaFile()
SWEP.Base = "weapon_base"
SWEP.Category = "Counter-Strike: Source"
SWEP.PrintName = "M3-Super 90"
SWEP.Author = "Daisreich"

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.Spawnable = true
 
--SWEP.ViewModel = Model( "models/v_models/v_huntingrifle.mdl" )
SWEP.ViewModel = Model( "models/weapons/v_shot_m3super90.mdl" )
SWEP.WorldModel = "models/weapons/w_shot_m3super90.mdl"
SWEP.ViewModelFOV = 75
SWEP.UseHands = true
SWEP.HoldType = "shotgun"
SWEP.Primary.Delay = 0.8
SWEP.Primary.ClipSize = 8  -- How much bullets are in the mag
SWEP.Primary.DefaultClip = 8 -- How much bullets preloaded when spawned
SWEP.Primary.Damage = 20
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Spread = 1.0
SWEP.Primary.NumberofShots = 10
SWEP.Primary.Ammo = "ar2" 
SWEP.Secondary.Ammo = "none"
SWEP.Primary.Recoil = 0.4
SWEP.Primary.Automatic = true
SWEP.Secondary.Automatic = true
SWEP.DeployAfterPickup = false
SWEP.HitDistance = 48
SWEP.ReloadTime = 0.5
SWEP.ShootSound = Sound("^weapons/m3/m3-1.wav")
SWEP.ViewModelFlip = true
function SWEP:Deploy()
	self:SetWeaponHoldType( self.HoldType ) 
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


function SWEP:Think()

	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()

	if self.NextReload and CurTime()>=self.NextReload then
		self:SetClip1(self:Clip1() + self.AmmoAdded)
		if (self:GetClass() != "tf_weapon_particle_launcher") then
			if not self.ReloadSingle and self.ReloadDiscardClip then
				self.Owner:RemoveAmmo(self.Primary.ClipSize, self.Primary.Ammo, false)
			else
				self.Owner:RemoveAmmo(self.AmmoAdded, self.Primary.Ammo, false)
			end
		end
		
		self.Delay = -1
		self.QuickDelay = -1
		
		if self:Clip1()>=self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo)==0 then
			-- Stop reloading
			self.Reloading = false
			self.CanInspect = true
				--self:SendWeaponAnim(ACT_RELOAD_FINISH)
				if SERVER then
					if (self.ReloadingEmpty) then
						self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("after_reload")))
						local deploy = "insert"
						timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence(deploy)), 1, function()
							self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
							timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle")) , 0, function()
								self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
							end)
						end)
					else
						local deploy = "insert"
						self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("after_reload")))
						timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence(deploy)), 1, function()
							self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
							timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle")) , 0, function()
								self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
							end)
						end)
					end
				end
			self.NextReload = nil
		else
			if SERVER then
				if (self.ReloadingEmpty) then
					self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("insert")))
				else
					self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("insert")))
				end
			end
			self.NextReload = CurTime() + (self.ReloadTime)
		end
	end
	
	if self.NextReloadStart and CurTime()>=self.NextReloadStart then
		if SERVER then
			if (self.ReloadingEmpty) then
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("start_reload")))
			else
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("start_reload")))
			end
		end
		--self.Owner:SetAnimation(10000) -- reload loop	 	
		self.NextReload = CurTime() + (self.ReloadTime)
		
		self.AmmoAdded = 1
		
		self.NextReloadStart = nil
	end
	local meleetime = self:GetNextMeleeAttack()

	if ( meleetime > 0 && CurTime() > meleetime ) then

		self:DealDamage()

		self:SetNextMeleeAttack( 0 )

	end
end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	 
	local vm = self:GetOwner():GetViewModel()
	if (self.NextReloadStart and self.NextReloadStart > CurTime()) then return end
	if (self.NextReload and self.NextReload > CurTime()) then
		-- Stop reloading
		self.Reloading = false
		self.CanInspect = true
			--self:SendWeaponAnim(ACT_RELOAD_FINISH)
			if SERVER then
				if (self.ReloadingEmpty) then
					self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("after_reload")))
				else
					self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("after_reload")))
				end
			end
		self.NextReload = nil
		self:SetNextPrimaryFire( CurTime() + 0.5 ) 
		return
	end
	
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
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("shoot"..math.random(1,2))))
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) 
		timer.Stop("Idle"..self.Owner:EntIndex())
		timer.Stop("Idle2"..self.Owner:EntIndex())
		timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("shoot"..math.random(1,2))) , 1, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
			timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle")) , 0, function()
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
			end)
		end)
	
end 
function SWEP:SecondaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end
	
end 

function SWEP:Reload()
	local vm = self:GetOwner():GetViewModel()
	
	if self.NextReloadStart or self.NextReload or self.Reloading then return end
	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Stop("Idle2"..self.Owner:EntIndex())
	if self.Primary and self.Primary.Ammo and self.Primary.ClipSize ~= -1 then
		local available = self.Owner:GetAmmoCount(self.Primary.Ammo)
		local ammo = self:Clip1()
		
		if ammo < self.Primary.ClipSize and available > 0 then
			self.NextIdle = nil
			if SERVER then
				if (self:Clip1() < 1) then
					self.ReloadingEmpty = true
				else
					self.ReloadingEmpty = false
				end
			end
			self.Owner:SetAnimation(PLAYER_RELOAD)
			self.NextReloadStart = CurTime()
			return true
		end
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

