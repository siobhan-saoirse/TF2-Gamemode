if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "TF Player Controller"
	SWEP.Slot				= 0
end

SWEP.Base				= "weapon_base"

SWEP.ViewModel			= "models/weapons/c_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.UseHands = true
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "Civilian 2"

SWEP.Swing = Sound("Weapon_Fist.Miss")
SWEP.SwingCrit = Sound("Weapon_Fist.MissCrit")
SWEP.HitFlesh = Sound("items/powerup_pickup_knockout_melee_hit.wav")
SWEP.HitWorld = Sound("Weapon_Fist.HitWorld")

SWEP.CritEnabled = Sound("Weapon_BoxingGloves.CritEnabled")
SWEP.CritHit = Sound("Weapon_BoxingGloves.CritHit")

SWEP.DropPrimaryWeaponInstead = true

SWEP.BaseDamage = 145
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay          = 0.5

SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay          = 0.5

SWEP.CritForceAddPitch = 45

SWEP.HoldType = "primary"
SWEP.HoldTypeHL2 = "pistol"
SWEP.HasThirdpersonCritAnimation = false
SWEP.HasSecondaryFire = true
SWEP.UsesLeftRightAnim = true

SWEP.ShouldOccurFists = true
SWEP.DamageType = DMG_BLAST 

function SWEP:OnCritBoostStarted()
	--self.Owner:EmitSound(self.CritEnabled)
end

function SWEP:OnCritBoostAdded()
	--self.Owner:EmitSound(self.CritHit)
end


function SWEP:SecondaryAttack()

end
function SWEP:PrimaryAttack()
	if (self.Owner) then
		if (self.Owner:GetEyeTrace().Entity && self.Owner:GetEyeTrace().Entity:IsPlayer()) then
			self.Owner:GetEyeTrace().Entity.BeingControlled = true
			self.Owner:GetEyeTrace().Entity.BeingControlledBy = self.Owner
			self.Owner.ControllingPlayer = self.Owner:GetEyeTrace().Entity
			if SERVER then
				self.Owner:ExitVehicle()
				self.Owner:Flashlight(false)
				self.Owner:StripWeapons() 
				self.Owner:Spectate( OBS_MODE_CHASE )
				self.Owner:SpectateEntity(self.Owner:GetEyeTrace().Entity)
				
				self.Owner:SetNoDraw(true)
				self.Owner:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
				self.Owner:SetAvoidPlayers(false)
			end
			self:EmitSound("weapons/stunstick/alyx_stunner2.wav", 80, 110)
			self:SetNextPrimaryFire(CurTime() + 1)
		elseif (self.Owner:GetEyeTrace().Entity && self.Owner:GetEyeTrace().Entity:IsNPC()) then
			self.Owner:GetEyeTrace().Entity.BeingControlled = true
			self.Owner:GetEyeTrace().Entity.BeingControlledBy = self.Owner
			self.Owner.ControllingPlayer = self.Owner:GetEyeTrace().Entity
			if SERVER then
				self.Owner:GetEyeTrace().Entity:AddEntityRelationship(self.Owner,D_LI,99)
				self.Owner:ExitVehicle()
				self.Owner:Flashlight(false)
				self.Owner:StripWeapons() 
				self.Owner:Spectate( OBS_MODE_CHASE )
				self.Owner:SpectateEntity(self.Owner:GetEyeTrace().Entity)
				
				self.Owner:SetNoDraw(true)
				self.Owner:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
				self.Owner:SetAvoidPlayers(false)
			end
			self:EmitSound("weapons/stunstick/alyx_stunner2.wav", 80, 110)
			self:SetNextPrimaryFire(CurTime() + 1)
		else
			self:EmitSound("common/wpn_denyselect.wav", 80, 100)
			self:SetNextPrimaryFire(CurTime() + 0.5)
		end
	else
		self:EmitSound("common/wpn_denyselect.wav", 80, 100)
		self:SetNextPrimaryFire(CurTime() + 0.5)
	end
end
