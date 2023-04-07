
if (!IsMounted("left4dead2")) then return end
AddCSLuaFile()
SWEP.Base = "weapon_smg_silenced"
SWEP.Category = "Left 4 Dead 2"
SWEP.PrintName = "Submachine Gun"
SWEP.Author = "Daisreich"

SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/v_models/v_smg.mdl" )
SWEP.WorldModel = "models/w_models/weapons/w_smg_uzi.mdl"
SWEP.ViewModelFOV = 50
SWEP.UseHands = true
SWEP.HoldType = "AR2"
SWEP.Primary.Delay = 0.06
SWEP.Primary.ClipSize = 50  -- How much bullets are in the mag
SWEP.Primary.DefaultClip = 150 -- How much bullets preloaded when spawned
SWEP.Primary.Damage = 28
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Spread = 0.75
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Ammo = "SMG1"
SWEP.Secondary.Ammo = "none"
SWEP.Primary.Recoil = 0.25
SWEP.Primary.Automatic = true
SWEP.Secondary.Automatic = true

SWEP.HitDistance = 48
SWEP.ShootSound = Sound(")weapons/smg/gunfire/smg_fire_1.wav")

function SWEP:Deploy()
	self:SetWeaponHoldType( self.HoldType )
	if SERVER then
		self:SendWeaponAnim(ACT_VM_DRAW)
	end
	local vm = self:GetOwner():GetViewModel()
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:SelectWeightedSequence(ACT_VM_DRAW)) , 1, function()
		self:SendWeaponAnim(ACT_VM_IDLE)
	end)
	return true
end 

function SWEP:Holster()

	self:SetNextMeleeAttack( 0 )

	return true

end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
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
		self.Owner:EmitSound(self.ShootSound, 75)	
	end
	self.Owner:ViewPunch( Angle( rnda,0,0 ) ) 
	self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
	 
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) 
	timer.Stop("Idle"..self.Owner:EntIndex())
	local vm = self:GetOwner():GetViewModel()
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:SelectWeightedSequence(ACT_VM_PRIMARYATTACK)) , 1, function()
		self:SendWeaponAnim(ACT_VM_IDLE)
	end)
end 

function SWEP:Reload()
	local vm = self:GetOwner():GetViewModel()
	self:DefaultReload(ACT_VM_RELOAD)
	if SERVER then
		if (string.find(self:GetClass(),"smg") or string.find(self:GetClass(),"m16a1")) then
			self.Owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RELOAD_SMG1,true,true )
			umsg.Start("PlaySMGNormalWeaponWorldReload")
				umsg.Entity(self)
			umsg.End()
		end
	end
	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:SelectWeightedSequence(ACT_VM_RELOAD)) , 1, function()
		self:SendWeaponAnim(ACT_VM_IDLE)
	end)
end

	usermessage.Hook("PlaySMGNormalWeaponWorldReload", function(msg)
		local w = msg:ReadEntity()
		
		if IsValid(w) and w.ReloadSound and (w.Owner ~= LocalPlayer() or LocalPlayer():ShouldDrawLocalPlayer()) then
			w.Owner:EmitSound("weapons/smg/gunother/smg_clip_out_1.wav",75)
			timer.Simple(0.8,function()
				w.Owner:EmitSound("weapons/smg/gunother/smg_clip_in_1.wav",75)
				timer.Simple(0.25,function()
					w.Owner:EmitSound("weapons/smg/gunother/smg_clip_locked_1.wav",75)
					timer.Simple(0.7,function()
						w.Owner:EmitSound("weapons/smg/gunother/smg_slideback_1.wav",75)
						timer.Simple(0.25,function()
							w.Owner:EmitSound("weapons/smg/gunother/smg_slideforward_1.wav",75)
						end)
					end)
				end)
			end)
		end
	end)