
if (!IsMounted("left4dead")) then return end
AddCSLuaFile()
SWEP.Base = "weapon_smg_silenced"
SWEP.Category = "Left 4 Dead 2"
SWEP.PrintName = "Bilebomb"
SWEP.Author = "Daisreich"

SWEP.Slot = 2
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/v_models/v_bile_flask.mdl" )
SWEP.WorldModel = "models/w_models/weapons/w_eq_bile_flask.mdl"
SWEP.ViewModelFOV = 52
SWEP.UseHands = true
SWEP.HoldType = "grenade"
SWEP.Primary.Delay = 1.0
SWEP.Primary.ClipSize = -1 -- How much bullets are in the mag
SWEP.Primary.DefaultClip = 1 -- How much bullets preloaded when spawned
SWEP.Primary.Damage = 8
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Spread = 1.1
SWEP.Primary.NumberofShots = 10
SWEP.Primary.Ammo = "SLAM"
SWEP.Primary.Recoil = 1.5
SWEP.Primary.Automatic = true
SWEP.DeployAfterPickup = false
SWEP.ReloadTime = 0.5
SWEP.HitDistance = 48
SWEP.ShootSound = Sound("")
SWEP.ReloadingEmpty = false

SWEP.WeaponSkin = 1

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
	local deploy = "deploy"
	if (!self.DeployAfterPickup) then
		deploy = "deploy"
		if SERVER then
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("molotov_deploy")))
		end
		self.DeployAfterPickup = true
	else
		if SERVER then
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("molotov_deploy")))
		end
	end
	timer.Stop("Idle2"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence(deploy)), 1, function()
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("molotov_idle")))
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("molotov_idle")) , 0, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("molotov_idle")))
		end)
	end)
	return true
end 

function SWEP:Think()

	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()
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
	if ( self:Ammo1() <= 0 ) then 
		if SERVER then
			self:Remove()
		end
		return 
	end
	local vm = self:GetOwner():GetViewModel()
	self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("molotov_pullpin")))
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) 
	self:TakePrimaryAmmo(1)
	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Stop("Idle2"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("molotov_pullpin")) , 1, function()
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("molotov_throw")))
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		local pos = self.Owner:GetShootPos()
		local wmodel = self.WorldModel
		if SERVER then
			local grenade = ents.Create("prop_ceda_jar")
			grenade:SetPos(pos)
			grenade:SetAngles(self.Owner:EyeAngles())
			
			grenade:SetOwner(self.Owner)
			
			grenade:Spawn()
			grenade:EmitSound(self.ShootSound)
			grenade:SetModel(wmodel)
			
			local vel = self.Owner:GetAimVector():Angle()
			vel.p = vel.p 
			vel = vel:Forward() * 1100 * (10)
			
			grenade:GetPhysicsObject():AddAngleVelocity(Vector(math.random(-2000,2000),math.random(-2000,2000),math.random(-2000,2000)))
			grenade:GetPhysicsObject():ApplyForceCenter(vel)
		end
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("molotov_idle")) , 0, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("molotov_idle")))
		end)
	end)
end 

function SWEP:SecondaryAttack( right )
	if SERVER then
		self.Owner:DoAnimationEvent( ACT_GMOD_GESTURE_MELEE_SHOVE_1HAND,true,true )
	end

	local anim = "molotov_melee"

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	self:EmitSound( ")player/survivor/swing/swish_weaponswing_swipe"..math.random(5,6)..".wav", 75, math.random(95,105) )

	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Stop("Idle2"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("molotov_melee")) , 1, function()
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("molotov_idle")))
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("molotov_idle")) , 0, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("molotov_idle")))
		end)
	end)
	self:SetNextMeleeAttack( CurTime() + 0.1 )

	self:SetNextPrimaryFire( CurTime() + 0.7 )
	self:SetNextSecondaryFire( CurTime() + 0.7 )

end