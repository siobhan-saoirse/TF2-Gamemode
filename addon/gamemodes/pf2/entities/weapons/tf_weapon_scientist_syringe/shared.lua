
PrecacheParticleSystem("boomer_vomit_b")
PrecacheParticleSystem("boomer_vomit_c")
PrecacheParticleSystem("boomer_vomit_d")
PrecacheParticleSystem("boomer_vomit_e")
PrecacheParticleSystem("boomer_vomit_f")

if SERVER then
	AddCSLuaFile( "shared.lua" )
end


if CLIENT then
	SWEP.PrintName			= "Healing Syringe"
end
SWEP.ReadyToPounce		= true
SWEP.Base				= "tf_weapon_base"
SWEP.Slot				= 0
SWEP.UseHands = false
SWEP.ViewModel = Model( "models/weapons/c_medkit.mdl" )
SWEP.WorldModel = Model( "models/empty.mdl" )
SWEP.Crosshair = "tf_crosshair3"

SWEP.DeployedSyringe = false
SWEP.VM_DRAW = ACT_IDLE
SWEP.VM_IDLE = ACT_IDLE
SWEP.HoldType = "melee"


SWEP.HealAmount = 20 -- Maximum heal amount per use
SWEP.MaxAmmo = 100 -- Maxumum ammo

local HealSound = Sound( "items/medshot4.wav" )
local DenySound = Sound( "WallHealth.Deny" )

function SWEP:Initialize()

	self:SetHoldType( "slam" )

	if ( CLIENT ) then return end


	return self.BaseClass.Initialize(self)
end

function SWEP:PrimaryAttack()

	if ( CLIENT ) then return end
	if (!self.DeployedSyringe) then
		self:SendWeaponAnim( ACT_VM_DRAW )
		self.Owner:DoAnimationEvent(ACT_ARM,true)
		self.VM_IDLE = ACT_VM_IDLE
		self.DeployedSyringe = true
		self:SetNextPrimaryFire(CurTime() + 2)
		self.Owner:DrawViewModel(true)
		
		EmitSentence( "SC_HEAL" .. math.random( 1, 7 ), self.Owner:GetPos(), self.Owner:EntIndex()	, CHAN_VOICE, 1, 75, 0, 100 )
		timer.Simple(1.0, function()
			timer.Create( "medkit_ammo" .. self:EntIndex(), 1, 0, function()
				if ( self:Clip1() < self.MaxAmmo ) then self:SetClip1( math.min( self:Clip1() + 2, self.MaxAmmo ) ) end
			end )

			self.Owner:SetBodygroup(2,1)
		end)
		return
	else
		if ( self.Owner:IsPlayer() ) then
			self.Owner:LagCompensation( true )
		end

		local tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 64,
			filter = self.Owner
		} )

		if ( self.Owner:IsPlayer() ) then
			self.Owner:LagCompensation( false )
		end

		local ent = tr.Entity

		local need = self.HealAmount
		if ( IsValid( ent ) ) then need = math.min( ent:GetMaxHealth() - ent:Health(), self.HealAmount ) end

		if ( IsValid( ent ) && self:Clip1() >= need && ( ent:IsPlayer() or ent:IsNPC() ) && ent:Health() < ent:GetMaxHealth() ) then

			self:TakePrimaryAmmo( need )

			ent:SetHealth( math.min( ent:GetMaxHealth(), ent:Health() + need ) )
			ent:EmitSound( HealSound )

			self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

			self.Owner:DoAnimationEvent(ACT_MELEE_ATTACK1,true)
			self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() + 0.5 )
			self.Owner:SetAnimation( PLAYER_ATTACK1 )

			-- Even though the viewmodel has looping IDLE anim at all times, we need this to make fire animation work in multiplayer
			timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() if ( IsValid( self ) ) then self:SendWeaponAnim( ACT_VM_IDLE ) end end )

		else

			self:SendWeaponAnim( ACT_VM_HOLSTER	 )
			self.Owner:DoAnimationEvent(ACT_DISARM,true)
			self.DeployedSyringe = false
			self:SetNextPrimaryFire( CurTime() + 2 )
			timer.Stop( "medkit_ammo" .. self:EntIndex() )
			timer.Stop( "weapon_idle" .. self:EntIndex() )
			timer.Simple(0.6, function()
				self.Owner:DrawViewModel(false)
			end)
			timer.Simple(1.0, function()
				self.Owner:SetBodygroup(2,0)
			end)
			return

		end
	end

end

function SWEP:SecondaryAttack()

	if ( CLIENT ) then return end

	if (!self.DeployedSyringe) then
		self:SendWeaponAnim( ACT_VM_DRAW )
		self.VM_IDLE = ACT_VM_IDLE
		self.DeployedSyringe = true
		return
	end
	
	local ent = self.Owner

	local need = self.HealAmount
	if ( IsValid( ent ) ) then need = math.min( ent:GetMaxHealth() - ent:Health(), self.HealAmount ) end

	if ( IsValid( ent ) && self:Clip1() >= need && ent:Health() < ent:GetMaxHealth() ) then

		self:TakePrimaryAmmo( need )

		ent:SetHealth( math.min( ent:GetMaxHealth(), ent:Health() + need ) )
		ent:EmitSound( HealSound )

		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )

		self:SetNextSecondaryFire( CurTime() + self:SequenceDuration() + 0.5 )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )

		timer.Create( "weapon_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function() if ( IsValid( self ) ) then self:SendWeaponAnim( ACT_VM_IDLE ) end end )

	else

		ent:EmitSound( DenySound )
		self:SetNextSecondaryFire( CurTime() + 1 )

	end

end

function SWEP:OnRemove()

	timer.Stop( "medkit_ammo" .. self:EntIndex() )
	timer.Stop( "weapon_idle" .. self:EntIndex() )
	
	self.Owner:SetBodygroup(1,0)
	return self.BaseClass.OnRemove(self)
end

function SWEP:Holster()

	self.Owner:DrawViewModel(true)
	timer.Stop( "weapon_idle" .. self:EntIndex() )
	self.DeployedSyringe = false
	self.VM_IDLE = ACT_IDLE
	self.Owner:SetBodyGroup(2,0)
	
	return self.BaseClass.Holster(self)

end

function SWEP:CustomAmmoDisplay()

	self.AmmoDisplay = self.AmmoDisplay or {}
	self.AmmoDisplay.Draw = true
	self.AmmoDisplay.PrimaryClip = self:Clip1()

	return self.AmmoDisplay

end
