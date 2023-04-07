if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then

SWEP.PrintName			= "Thermal Thruster"
SWEP.HasCModel = true
SWEP.Slot				= 1

end

sound.Add( {
	name = "RocketJumpLoop",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 95,
	sound = { "misc/grenade_jump_lp_01.wav"	}
} )
SWEP.Base				= "tf_weapon_base"

SWEP.ViewModel			= "models/weapons/c_models/c_pyro_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_rocketpack/c_rocketpack.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.MuzzleEffect = ""

SWEP.ShootSound = ""
SWEP.ShootCritSound = ""

SWEP.Primary.ClipSize		= 2
SWEP.Primary.DefaultClip = 2
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 1.5

SWEP.ReloadSingle = true

SWEP.ReloadTime = 8

SWEP.ReloadSound = ""

SWEP.HasCustomMeleeBehaviour = true

SWEP.ProjectileShootOffset = Vector(0, 0, 0)

SWEP.Force = 800
SWEP.AddPitch = -4

SWEP.HoldType = "ITEM4"

function SWEP:InspectAnimCheck()
self:CallBaseFunction("InspectAnimCheck")
self.VM_DRAW = ACT_ITEM4_VM_DRAW
self.VM_IDLE = ACT_ITEM4_VM_IDLE
self.VM_PRIMARYATTACK = ACT_ITEM4_VM_PRIMARYATTACK
self.VM_RELOAD_START = ACT_ITEM4_VM_HOLSTER
self.VM_RELOAD_LOOP = ACT_ITEM4_VM_HOLSTER
self.VM_RELOAD_END = ACT_ITEM4_VM_DRAW
self.VM_INSPECT_START = ACT_ITEM4_VM_IDLE
self.VM_INSPECT_IDLE = ACT_ITEM4_VM_IDLE
self.VM_INSPECT_END = ACT_ITEM4_VM_IDLE
end

function SWEP:Think()
	self:CallBaseFunction("Think")
end

function SWEP:Deploy()
	self:CallBaseFunction("Deploy")
	self:CreateSounds(self.Owner)
	self.Owner:SetPoseParameter("r_arm", 0)
	self.Owner:SetPoseParameter("r_hand_grip", 0)
	self:EmitSound("Weapon_RocketPack.BoostersExtend", 85)
end
function SWEP:Holster()
	if SERVER then
		--self.WModel2:ResetSequence("undeploy")
		--self.WModel2:SetPlaybackRate(1)
		--self.WModel2:SetCycle(0)
	end
	self:EmitSound("Weapon_RocketPack.BoostersRetract", 85)
	return self.BaseClass.Holster(self)
end  

function SWEP:PredictCriticalHit()
end
function SWEP:CreateSounds(owner)
	if not IsValid(owner) then return end
	
	self.RocketJumpLoop = CreateSound(owner, "RocketJumpLoop")
	
end
function SWEP:PrimaryAttack()	
	if not self:CallBaseFunction("PrimaryAttack") then return false end
	self:SetNextPrimaryFire(CurTime() + 1.5)
	if self.Owner:GetAmmoCount( self.Weapon:GetPrimaryAmmoType() ) == 0 then
		return
	end
	
	self.Owner:SetLocalVelocity( Vector( 0, 0, 300 ) + self.Owner:GetVelocity() * 1 )
	
	self:SendWeaponAnimEx(ACT_ITEM4_VM_PRIMARYATTACK)
	
	self:EmitSound( "Weapon_RocketPack.BoostersCharge", 85 )
	
	self:TakePrimaryAmmo(1)
	
	self.Owner.NextGiveAmmo = CurTime() + (20)
	self.Owner.NextGiveAmmoType = self.Primary.Ammo
	
	self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
	self.Owner:DoAnimationEvent(ACT_DOD_PRONE_ZOOMED, true)	 
	 
	self.Owner:AddPlayerState(PLAYERSTATE_STUNNED)
	timer.Simple(0.55, function()
		self.Owner:SetLocalVelocity( self.Owner:GetAimVector() + Vector( 0, 0, 700 ) + self.Owner:GetVelocity() * 4 )
		self:EmitSound( "Weapon_RocketPack.BoostersFire", 85 )
		self.Owner:RemovePlayerState(PLAYERSTATE_STUNNED)
		self.RocketJumpLoop:Play()
		timer.Create("CheckIfOnGround", 0.001, 0, function()
			
		self.RocketJumpLoop:ChangePitch(math.Clamp(100, 100, 250), 0)
			if self.Owner:OnGround() then
				self:EmitSound( "Weapon_RocketPack.BoostersShutdown", 85 )
				if SERVER then
					self.Owner:EmitSound( "Weapon_RocketPack.Land", 85 )
					self.Owner:StopSound("RocketJumpLoop")
					for k,v in pairs(ents.FindInSphere(self.Owner:GetPos(), 110)) do
						if v:Health() >= 0 then
							if v:IsPlayer() and v:Nick() != self.Owner:Nick() and not v:IsFriendly(self.Owner) then
								v:TakeDamage(45, self.Owner, self)
								v:EmitSound("weapons/mantreads.wav", 85, 100)
								v:EmitSound("player/fall_damage_dealt.wav", 85, 100)
								timer.Create("Stomp", 0.001, 30, function()
									self.Owner:DoAnimationEvent(ACT_SIGNAL1)
								end)
								v:AddPlayerState(PLAYERSTATE_STUNNED)
								timer.Simple(3, function()
								
								v:RemovPlayerState(PLAYERSTATE_STUNNED)
								end)
							end
							if v:IsNPC() and not v:IsFriendly(self.Owner) then
								v:TakeDamage(45, self.Owner, self)
								v:EmitSound("weapons/mantreads.wav", 85, 100)
								v:EmitSound("player/fall_damage_dealt.wav", 85, 100)
								timer.Create("Stomp", 0.001, 30, function()
									self.Owner:DoAnimationEvent(ACT_SIGNAL1)
								end)
							end
						end
					end
				end
				timer.Stop("CheckIfOnGround")
			end
		end)
	end)
end
