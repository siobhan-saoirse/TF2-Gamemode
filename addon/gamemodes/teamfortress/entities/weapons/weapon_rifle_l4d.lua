if (!IsMounted("left4dead")) then return end
AddCSLuaFile()
SWEP.Base = "weapon_smg_silenced"
SWEP.Category = "Left 4 Dead"
SWEP.PrintName = "Assault Rifle"
SWEP.Author = "Daisreich"

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/l4d1/v_models/v_rifle.mdl" )
SWEP.WorldModel = "models/w_models/weapons/w_rifle_m16a2.mdl"
SWEP.ViewModelFOV = 52
SWEP.UseHands = true
SWEP.HoldType = "AR2"
SWEP.Primary.Delay = 0.08
SWEP.Primary.ClipSize = 50  -- How much bullets are in the mag
SWEP.Primary.DefaultClip = 150 -- How much bullets preloaded when spawned
SWEP.Primary.Damage = 25
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Spread = 0.85
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Recoil = 0.4
SWEP.Primary.Automatic = true
SWEP.DeployAfterPickup = false

SWEP.HitDistance = 48
SWEP.ShootSound = Sound("^l4d1/weapons/rifle/gunfire/rifle_fire_1.wav")

function SWEP:Deploy()
	self:SetWeaponHoldType( self.HoldType )
	local vm = self:GetOwner():GetViewModel()
	local deploy = "rifle_draw"
	if (!self.DeployAfterPickup) then
		deploy = "rifle_pickup"
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("rifle_pickup")))
		self.DeployAfterPickup = true
	else
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("rifle_draw")))
	end
	timer.Stop("Idle2"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence(deploy)), 1, function()
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("rifle_idle")))
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("rifle_idle")) , 0, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("rifle_idle")))
		end)
	end)
	return true
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
	self:EmitSound(self.ShootSound, 95)	
	self.Owner:ViewPunch( Angle( rnda,0,0 ) ) 
	self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
	
	self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("rifle_shoot1")))
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) 
	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Stop("Idle2"..self.Owner:EntIndex())
	local vm = self:GetOwner():GetViewModel()
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("rifle_shoot1")) , 1, function()
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("rifle_idle")))
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("rifle_idle")) , 0, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("rifle_idle")))
		end)
	end)
end 

function SWEP:SecondaryAttack( right )
	if SERVER then
		self.Owner:DoAnimationEvent( ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,true,true )
	end

	local anim = "rifle_melee"

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	self:EmitSound( ")player/survivor/swing/swish_weaponswing_swipe"..math.random(5,6)..".wav", 75, 100 )

	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Stop("Idle2"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("rifle_melee")) , 1, function()
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("rifle_idle")))
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("rifle_idle")) , 0, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("rifle_idle")))
		end)
	end)
	self:SetNextMeleeAttack( CurTime() + 0.1 )

	self:SetNextPrimaryFire( CurTime() + 0.7 )
	self:SetNextSecondaryFire( CurTime() + 0.7 )

end
function SWEP:Reload()
	local vm = self:GetOwner():GetViewModel()
	local reload = "rifle_reload1"
	if (self:Clip1() < 1) then
		reload = 'rifle_reload_empty'
		self:DefaultReload(vm:GetSequenceActivity(vm:LookupSequence("rifle_reload_empty")))
	else
		self:DefaultReload(vm:GetSequenceActivity(vm:LookupSequence("rifle_reload1")))
	end
	if SERVER then
		if (string.find(self:GetClass(),"smg") or string.find(self:GetClass(),"rifle")) then
			self.Owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RELOAD_SMG1,true,true )
			umsg.Start("PlaySMGNormalWeaponWorldReload")
				umsg.Entity(self)	
			umsg.End()
		end
	end
	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Stop("Idle2"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence(reload)) , 1, function()
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("rifle_idle")))
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("rifle_idle")) , 0, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("rifle_idle")))
		end)
	end)
end