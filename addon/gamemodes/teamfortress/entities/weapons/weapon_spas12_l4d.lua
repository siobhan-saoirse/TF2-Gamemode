
if (!IsMounted("left4dead2")) then return end
AddCSLuaFile()
SWEP.Base = "weapon_smg_silenced"
SWEP.Category = "Left 4 Dead 2"
SWEP.PrintName = "SPAS12"
SWEP.Author = "Daisreich"

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/v_models/v_shotgun_spas.mdl" )
SWEP.WorldModel = "models/w_models/weapons/w_shotgun_spas.mdl"
SWEP.ViewModelFOV = 52
SWEP.UseHands = true
SWEP.HoldType = "shotgun"
SWEP.Primary.Delay = 0.3
SWEP.Primary.ClipSize = 8  -- How much bullets are in the mag
SWEP.Primary.DefaultClip = 8 -- How much bullets preloaded when spawned
SWEP.Primary.Damage = 30
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Spread = 0.6
SWEP.Primary.NumberofShots = 10
SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Automatic = true

SWEP.ShootSound = Sound("weapons/auto_shotgun_spas/gunfire/shotgun_fire_1.wav")

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end 

function SWEP:Deploy()
	if SERVER then
		self:SendWeaponAnim(ACT_VM_DEPLOY)
	end
end
function SWEP:PrimaryAttack()
 
	if ( !self:CanPrimaryAttack() ) then return end
	 
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
	if SERVER then
		self.Owner:EmitSound(self.ShootSound, 75, math.random(95,105))	
	end
	self.Owner:ViewPunch( Angle( rnda,0,0 ) ) 
	self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
	 
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) 
	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), 1, 1, function()
		self:SendWeaponAnim(ACT_VM_IDLE)
	end)
end 