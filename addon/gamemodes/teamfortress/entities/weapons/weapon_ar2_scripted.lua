AddCSLuaFile()
SWEP.Base = "weapon_base"
SWEP.Category = "Half-Life 2 (Scripted)" 
SWEP.PrintName = "Pulse-Rifle"
SWEP.Author = "Daisreich"

SWEP.Slot = 0
SWEP.SlotPos = 0

SWEP.Spawnable = true
 
--SWEP.ViewModel = Model( "models/v_models/v_huntingrifle.mdl" )
SWEP.ViewModel = Model( "models/weapons/v_irifle.mdl" )
SWEP.WorldModel = "models/weapons/w_irifle.mdl"
SWEP.UseHands = false
SWEP.HoldType = "ar2"
SWEP.Primary.Delay = 0.1
SWEP.Primary.ClipSize = 30  -- How much bullets are in the mag
SWEP.Primary.DefaultClip = 64 -- How much bullets preloaded when spawned
SWEP.Primary.Damage = 8
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Spread = 0.25
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Ammo = "AR2" 
SWEP.Secondary.Ammo = "AR2AltFire"
SWEP.Primary.Recoil = 0.3
SWEP.Primary.Automatic = true
SWEP.Secondary.Automatic = true
SWEP.DeployAfterPickup = false
SWEP.HitDistance = 48
SWEP.ShootSound = Sound("Weapon_AR2.Single")
SWEP.ViewModelFOV = 54
SWEP.ViewModelFlip = false
function SWEP:Deploy()
	self:SetWeaponHoldType( self.HoldType ) 
		local vm = self:GetOwner():GetViewModel()
		if SERVER then
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("ir_draw")))
		end
		timer.Stop("Idle"..self.Owner:EntIndex())
		timer.Stop("Idle2"..self.Owner:EntIndex())
		local vm = self:GetOwner():GetViewModel()
		timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("ir_draw")) , 1, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("ir_idle")))
			timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("ir_idle")) , 0, function()
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("ir_idle")))
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

	self.Primary.Spread = 0.25
	self.Primary.Recoil = 0.3
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
	bullet.TracerName = "AR2Tracer"
	bullet.Force = self.Primary.Force 
	bullet.Damage = self.Primary.Damage 
	bullet.AmmoType = self.Primary.Ammo 
	 
	local rnda = self.Primary.Recoil * math.random(-1, 1)  
	local rndb = self.Primary.Recoil * math.random(-1, 1) 
	local rndc = self.Primary.Recoil * math.random(-1, 1) 
	  
	self:ShootEffects()
	self.Primary.Spread = self.Primary.Spread + 0.07
	self.Primary.Recoil = self.Primary.Recoil + 0.08
	self.Owner:FireBullets( bullet ) 
		self:EmitSound(self.ShootSound, 65,100)	
		self.Owner:ViewPunch( Angle( rnda,0,0 ) ) 
		self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("ir_fire")))
		self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) 
		timer.Stop("Idle"..self.Owner:EntIndex())
		timer.Stop("Idle2"..self.Owner:EntIndex())
		local vm = self:GetOwner():GetViewModel()
		
	
end 
function SWEP:SecondaryAttack()
	if ( self:Ammo2() <= 0 ) then return end
	local vm = self:GetOwner():GetViewModel()
	self:SetNextSecondaryFire( CurTime() + 1.6 )
	self:EmitSound("Weapon_CombineGuard.Special1")
	
	self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("shake")))
	timer.Simple(0.5, function()
		self:EmitSound("Weapon_IRifle.Single")
		
		self.Owner:ScreenFade( SCREENFADE.OUT, Color( 255, 255, 255, 128 ), 0.01, 0 )
		self.Owner:ViewPunch( Angle( -10,0,0 ) ) 
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("ir_fire2")))
		self.Owner:DoAnimationEvent(ACT_HL2MP_GESTURE_RANGE_ATTACK_CROSSBOW)
		local vecAiming = self.Owner:GetAimVector()//GetAutoaimVector( AUTOAIM_2DEGREES );
		self.Owner:RemoveAmmo( 1, self.Weapon:GetSecondaryAmmoType() )
		local vecVelocity = vecAiming * 1000
		if SERVER then
			local grenade = ents.Create("prop_combine_ball")
			grenade:SetPos(self.Owner:GetPos() + Vector(0,-7,62))
			grenade:SetAngles(self.Owner:EyeAngles())
			
			
			grenade:SetSaveValue( "m_flRadius", 10 )
			grenade:SetSaveValue( "m_flSpeed", vecVelocity:Length() )
			grenade:SetSaveValue( "m_vecAbsVelocity", vecVelocity )
			grenade:SetOwner(self.Owner)
			
			grenade:Spawn()
			grenade:Fire("explode","",4)
			grenade:SetSaveValue( "m_bLaunched", true )
			grenade:SetSaveValue( "m_nState", 2 )
			grenade:EmitSound("NPC_CombineBall.Launch")
			local vel = self.Owner:GetAimVector():Angle()
			vel.p = vel.p
			vel = vel:Forward() * 1100 * (grenade.Mass or 10)
			
			grenade:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(-2000,2000)))
			grenade:GetPhysicsObject():ApplyForceCenter(vel)
		end
	end)
end 

function SWEP:Reload()
		local vm = self:GetOwner():GetViewModel()
		local reload = "ir_reload"
		if (self:Clip1() < 1) then
			reload = 'ir_reload'
			self:DefaultReload(vm:GetSequenceActivity(vm:LookupSequence("ir_reload")))
		else
			self:DefaultReload(vm:GetSequenceActivity(vm:LookupSequence("ir_reload")))
		end
		self:EmitSound("Weapon_AR2.NPC_Reload")
		if SERVER then
			if (string.find(self:GetClass(),"smg") or string.find(self:GetClass(),"m4a1")) then
				self.Owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RELOAD_SMG1,true,true )
				umsg.Start("PlaySMGNormalWeaponWorldReload")
					umsg.Entity(self)	
				umsg.End()
			end
		end
		self.Primary.Spread = 0.25
		self.Primary.Recoil = 0.3
		timer.Stop("Idle"..self.Owner:EntIndex())
		timer.Stop("Idle2"..self.Owner:EntIndex())
		timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence(reload)) , 1, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("ir_idle")))
			timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("ir_idle")) , 0, function()
				self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("ir_idle")))
			end)
		end)
end