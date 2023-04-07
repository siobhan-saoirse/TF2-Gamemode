
if (!IsMounted("left4dead")) then return end
AddCSLuaFile()
SWEP.Base = "weapon_smg_silenced"
SWEP.Category = "Left 4 Dead"
SWEP.PrintName = "Auto Shotgun"
SWEP.Author = "Daisreich"

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/l4d1/v_models/v_autoshotgun.mdl" )
SWEP.WorldModel = "models/w_models/weapons/w_autoshot_m4super.mdl"
SWEP.ViewModelFOV = 50
SWEP.UseHands = true
SWEP.HoldType = "shotgun"
SWEP.Primary.Delay = 0.25
SWEP.Primary.ClipSize = 10 -- How much bullets are in the mag
SWEP.Primary.DefaultClip = 10 -- How much bullets preloaded when spawned
SWEP.Primary.Damage = 12
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Spread = 0.95
SWEP.Primary.NumberofShots = 12
SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Automatic = false
SWEP.DeployAfterPickup = false
SWEP.ReloadTime = 0.4
SWEP.HitDistance = 48
SWEP.ShootSound = Sound("^l4d1/weapons/auto_shotgun/gunfire/auto_shotgun_fire_1.wav")
SWEP.ReloadingEmpty = false
local function CopyPoseParams(pEntityFrom, pEntityTo)
	if (SERVER) then
		for i = 0, pEntityFrom:GetNumPoseParameters() - 1 do
			local sPose = pEntityFrom:GetPoseParameterName(i)
			pEntityTo:SetPoseParameter(sPose, pEntityFrom:GetPoseParameter(sPose))
		end
	else
		for i = 0, pEntityFrom:GetNumPoseParameters() - 1 do
			local flMin, flMax = pEntityFrom:GetPoseParameterRange(i)
			local sPose = pEntityFrom:GetPoseParameterName(i)
			pEntityTo:SetPoseParameter(sPose, math.Remap(pEntityFrom:GetPoseParameter(sPose), 0, 1, flMin, flMax))
		end
	end
end
function SWEP:Deploy()
	self:SetWeaponHoldType( self.HoldType )
	local vm = self:GetOwner():GetViewModel()
	local deploy = "autoshot_deploy"
	if (!self.DeployAfterPickup) then
		deploy = "autoshot_deploy"
		if SERVER then
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_deploy")))
		end
		self.DeployAfterPickup = true
	else
		if SERVER then
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_deploy")))
		end
	end
	timer.Stop("Idle2"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence(deploy)), 1, function()
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_idle")))
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("autoshot_idle")) , 0, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_idle")))
		end)
	end)
	return true
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
						self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_reload_empty_pump")))
						local deploy = "autoshot_reload_empty_pump"
						timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence(deploy)), 1, function()
							self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_idle")))
							timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("autoshot_idle")) , 0, function()
								self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_idle")))
							end)
						end)
					else
						local deploy = "autoshot_reload_finish_nopump"
						self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_reload_finish_nopump")))
						timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence(deploy)), 1, function()
							self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_idle")))
							timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("autoshot_idle")) , 0, function()
								self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_idle")))
							end)
						end)
					end
				end
			self.NextReload = nil
		else
			if SERVER then
				if (self.ReloadingEmpty) then
					self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_reload_empty_start")))
				else
					self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_reload_start")))
				end
			end
			self.NextReload = CurTime() + (self.ReloadTime)
		end
	end
	
	if self.NextReloadStart and CurTime()>=self.NextReloadStart then
		if SERVER then
			if (self.ReloadingEmpty) then
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_reload_empty_start")))
			else
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_reload_start")))
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
	if SERVER then
		CopyPoseParams(self.Owner,vm)
	end
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
	if (self.NextReloadStart and self.NextReloadStart > CurTime()) then return end
	if (self.NextReload and self.NextReload > CurTime()) then
		-- Stop reloading
		self.Reloading = false
		self.CanInspect = true
			--self:SendWeaponAnim(ACT_RELOAD_FINISH)
			if SERVER then
				if (self.ReloadingEmpty) then
					self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_reload_empty_pump")))
				else
					self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_reload_finish_nopump")))
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
	self:EmitSound(self.ShootSound, 150)	
	self.Owner:ViewPunch( Angle( rnda,0,0 ) ) 
	self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
	
	self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_shoot1")))
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) 
	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Stop("Idle2"..self.Owner:EntIndex())
	local vm = self:GetOwner():GetViewModel()
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("autoshot_shoot1")) , 1, function()
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_idle")))
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("autoshot_idle")) , 0, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_idle")))
		end)
	end)
end 

function SWEP:SecondaryAttack( right )
	if SERVER then
		self.Owner:DoAnimationEvent( ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,true,true )
	end

	local anim = "autoshot_melee"

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	self:EmitSound( ")player/survivor/swing/swish_weaponswing_swipe"..math.random(5,6)..".wav", 75, math.random(95,105) )

	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Stop("Idle2"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("autoshot_melee")) , 1, function()
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_idle")))
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("autoshot_idle")) , 0, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("autoshot_idle")))
		end)
	end)
	self:SetNextMeleeAttack( CurTime() + 0.1 )

	self:SetNextPrimaryFire( CurTime() + 0.7 )
	self:SetNextSecondaryFire( CurTime() + 0.7 )

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