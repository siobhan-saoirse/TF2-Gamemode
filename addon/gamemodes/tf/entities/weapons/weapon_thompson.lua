
if (!IsMounted("dod")) then return end
AddCSLuaFile()
SWEP.Base = "weapon_dod_base_gun"
SWEP.Category = "Day of Defeat"
SWEP.PrintName = "Thompson"
SWEP.Author = "Daisreich"

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/weapons/cstrike/c_thompson.mdl" )
SWEP.WorldModel = "models/weapons/w_thompson.mdl"
SWEP.UseHands = false
SWEP.HoldType = "ar2"
SWEP.Primary.Delay = 0.085
SWEP.Primary.ClipSize = 30  -- How much bullets are in the mag
SWEP.Primary.DefaultClip = 30 -- How much bullets preloaded when spawned
SWEP.Primary.Damage = 40
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Spread = 0.955
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Ammo = "SMG1" 
SWEP.Secondary.Ammo = "none"
SWEP.Primary.Recoil = 2
SWEP.Primary.Automatic = true
SWEP.Secondary.Automatic = true
SWEP.DeployAfterPickup = false
SWEP.HitDistance = 48
SWEP.ShootSound = Sound("Weapon_Thompson.Shoot")

function SWEP:Deploy()
	self:SetWeaponHoldType( self.HoldType )
	local vm = self:GetOwner():GetViewModel()
	local deploy = "draw"
		if SERVER then
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("draw")))
		end
	timer.Stop("Idle2"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence(deploy)), 1, function()
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle")) , 0, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
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
	self.Owner:ViewPunch( Angle( rndb,0,0 ) ) 
	self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
	
	self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("shoot"..math.random(1,3))))
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) 
	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Stop("Idle2"..self.Owner:EntIndex())
	local vm = self:GetOwner():GetViewModel()
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("shoot1")) , 1, function()
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle")) , 0, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
		end)
	end)
end 

function SWEP:SecondaryAttack( right )
	if SERVER then
		self.Owner:DoAnimationEvent( ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,true,true )
	end

	local anim = "punch"

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Stop("Idle2"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("punch")) , 1, function()
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle")) , 0, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
		end)
	end)
	self:SetNextMeleeAttack( CurTime() + 0.1 )

	self:SetNextPrimaryFire( CurTime() + 0.4 )
	self:SetNextSecondaryFire( CurTime() + 0.4 )

end
function SWEP:Reload()
	local vm = self:GetOwner():GetViewModel()
	local reload = "reload"
	if (self:Clip1() < 1) then
		reload = 'reload'
		self:DefaultReload(vm:GetSequenceActivity(vm:LookupSequence("reload")))
	else
		self:DefaultReload(vm:GetSequenceActivity(vm:LookupSequence("reload")))
	end
	if SERVER then
		if (string.find(self:GetClass(),"smg") or string.find(self:GetClass(),"m16a1")) then
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