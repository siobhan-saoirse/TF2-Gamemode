
if (!IsMounted("cstrike")) then return end
AddCSLuaFile()
SWEP.Base = "weapon_base"
SWEP.Category = "Half-Life 2 (Scripted)"
SWEP.PrintName = "Shotgun"
SWEP.Author = "Daisreich"

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.Spawnable = true
 
--SWEP.ViewModel = Model( "models/v_models/v_huntingrifle.mdl" )
SWEP.ViewModel = Model( "models/weapons/c_shotgun.mdl" )
SWEP.WorldModel = "models/weapons/w_shotgun.mdl"
SWEP.UseHands = false
SWEP.HoldType = "shotgun"
SWEP.Primary.Delay = 0.85
SWEP.Primary.ClipSize = 6  -- How much bullets are in the mag
SWEP.Primary.DefaultClip = 6 -- How much bullets preloaded when spawned
SWEP.Primary.Damage = 10
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Spread = 1.0
SWEP.Primary.NumberofShots = 10
SWEP.Primary.Ammo = "ar2" 
SWEP.Secondary.Ammo = "none"
SWEP.Primary.Recoil = 0.25
SWEP.Primary.Automatic = true
SWEP.Secondary.Automatic = true
SWEP.DeployAfterPickup = false
SWEP.HitDistance = 48
SWEP.ReloadTime = 0.4
SWEP.ShootSound = Sound("Weapon_Shotgun.Single")
SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = false
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
						self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("reload3")))
						local deploy = "insert"
						timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence(deploy)), 1, function()
							self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("pump")))
							self.Owner:EmitSound("Weapon_Shotgun.Special1")
							timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("pump")) , 1, function()
								self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
								timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle")) , 0, function()
									self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
								end)
							end)
						end)
					else
						local deploy = "insert"
						self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("reload3")))
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
					self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("reload2")))
				else
					self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("reload2")))
				end
			end
			self:EmitSound("Weapon_Shotgun.Reload")
			self.NextReload = CurTime() + (self.ReloadTime)
		end
	end
	
	if self.NextReloadStart and CurTime()>=self.NextReloadStart then
		if SERVER then
			if (self.ReloadingEmpty) then
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("reload1")))
			else
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("reload1")))
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
					self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("reload3")))
				else
					self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("reload3")))
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
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("fire01")))
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) 
		timer.Stop("Idle"..self.Owner:EntIndex())
		timer.Stop("Idle2"..self.Owner:EntIndex())
		timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("fire01")) , 1, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("pump")))
			self:EmitSound("Weapon_Shotgun.Special1")
			timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("pump")) , 1, function()
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
				timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle")) , 0, function()
					self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
				end)
			end)
		end)
	
end 
function SWEP:SecondaryAttack()
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
					self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("reload3")))
				else
					self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("reload3")))
				end
			end
		self.NextReload = nil
		self:SetNextPrimaryFire( CurTime() + 0.5 ) 
		return
	end
	
	local bullet = {} 
	bullet.Num = self.Primary.NumberofShots + 6
	bullet.Src = self.Owner:GetShootPos() 
	bullet.Dir = self.Owner:GetAimVector() 
	bullet.Spread = Vector( self.Primary.Spread * 0.12 , self.Primary.Spread * 0.12, 0)
	bullet.Tracer = 1
	bullet.Force = self.Primary.Force 
	bullet.Damage = self.Primary.Damage 
	bullet.AmmoType = self.Primary.Ammo 
	 
	local rnda = self.Primary.Recoil * -1 
	local rndb = self.Primary.Recoil * math.random(-1, 1) 
	  
	self:ShootEffects()
	 
	self:FireBullets( bullet ) 
		self:EmitSound("Weapon_Shotgun.NPC_Double", 85,100)	
		self.Owner:ViewPunch( Angle( rnda - 2,0,0 ) ) 
		self:TakePrimaryAmmo(self.Primary.TakeAmmo + 1) 
		self.Owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW,true,true )
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("altfire")))
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay + 0.3 ) 
		self:SetNextSecondaryFire( CurTime() + self.Primary.Delay + 0.3 ) 
		timer.Stop("Idle"..self.Owner:EntIndex())
		timer.Stop("Idle2"..self.Owner:EntIndex())
		timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("fire01")) , 1, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("pump")))
			self:EmitSound("Weapon_Shotgun.Special1")
			timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("pump")) , 1, function()
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
				timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle")) , 0, function()
					self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
				end)
			end)
		end)
	
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
				self.Owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RELOAD_SHOTGUN,true,true )
			end

			self.NextReloadStart = CurTime()
			return true
		end
	end
end