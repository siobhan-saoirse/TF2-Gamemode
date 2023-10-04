
if (!IsMounted("cstrike")) then return end
AddCSLuaFile()
SWEP.Base = "weapon_base"
SWEP.Category = "Counter-Strike: Source"
SWEP.PrintName = "Knife"
SWEP.Author = "Daisreich"

SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.Spawnable = true

--SWEP.ViewModel = Model( "models/v_models/v_huntingrifle.mdl" )
SWEP.ViewModel = Model( "models/weapons/v_knife_t.mdl" )
SWEP.WorldModel = "models/weapons/w_knife_ct.mdl"
SWEP.ViewModelFOV = 75
SWEP.UseHands = true
SWEP.HoldType = "knife"
SWEP.Primary.Delay = 0.5
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Ammo = "none"
SWEP.Primary.Recoil = 0.25
SWEP.Primary.Automatic = true
SWEP.Secondary.Automatic = true
SWEP.DeployAfterPickup = false
SWEP.HitDistance = 48
SWEP.IsTryingToBackstab = false
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

	local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())

	self.Owner:LagCompensation( true )
 
	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( (IsValid(tr.Entity) and !tr.Entity:IsTFPlayer()) or tr.HitWorld ) then
		if SERVER then
			self.Owner:EmitSound( "weapons/knife/knife_hitwall1.wav", 75, 100 )
		end
	end

	local hit = false
	local scale = phys_pushscale:GetFloat()
	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		if (!self.IsTryingToBackstab) then
			self.Owner:EmitSound( table.Random({
					"weapons/knife/knife_hit1.wav",
					"weapons/knife/knife_hit2.wav",
					"weapons/knife/knife_hit3.wav",
					"weapons/knife/knife_hit4.wav"
			}), 75, 100 )
		else
		self.Owner:EmitSound( "weapons/knife/knife_stab.wav", 75, 100 )
		end

		local dmginfo = DamageInfo()

		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		dmginfo:SetDamageType(DMG_SLASH)
		dmginfo:SetInflictor( self )
		if (!self.IsTryingToBackstab) then
			dmginfo:SetDamage( 45 )
		else
			dmginfo:SetDamage( 100 )
		end
		SuppressHostEvents( NULL ) -- Let the breakable gibs spawn in multiplayer on client
		tr.Entity:TakeDamageInfo( dmginfo )
		SuppressHostEvents( self.Owner )

		hit = true

	end

	if ( IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 80 * phys:GetMass() * scale, tr.HitPos )
		end
	end

	if ( SERVER ) then
		if ( hit && anim != "fists_uppercut" ) then
			self:SetCombo( self:GetCombo() + 1 )
		else
			self:SetCombo( 0 )
		end
	end

	self.Owner:LagCompensation( false )

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

function SWEP:PrimaryAttack()
	self:MeleeAttack(false)
end 
function SWEP:SecondaryAttack()
	self:MeleeAttack(true)
end 

function SWEP:MeleeAttack( right )
 
	if ( !self:CanPrimaryAttack() ) then return end
	 
		if (self.Owner:KeyDown(IN_WALK)) then return end
		if (self.ZoomStatus) then
			self:ZoomOut()
			return
		end
	if SERVER then
		self.Owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RANGE_ATTACK_KNIFE,true,true )
	end
	self:EmitSound("weapons/knife/knife_slash1.wav",75,100,CHAN_WEAPON)
	local anim = "stab_miss"
	if (!right) then
		anim = "midslash"..math.random(1,2)
	end


	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( (IsValid(tr.Entity) and tr.Entity:IsTFPlayer()) or tr.HitWorld ) then
		
		if (right) then
			
			anim = "stab"
	
		end
		
	end
	local vm = self.Owner:GetViewModel()
	if SERVER then
		vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )
	end

	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Stop("Idle2"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence( anim )) , 1, function()
		self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
		timer.Create("Idle2"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("idle")) , 0, function()
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("idle")))
		end)
	end)
	if (!right) then
		self:SetNextMeleeAttack( CurTime() + 0.1 )
		local tr = util.TraceLine( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mask = MASK_SHOT_HULL
		} )
	
		if ( !IsValid( tr.Entity ) ) then
			tr = util.TraceHull( {
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
				filter = self.Owner,
				mins = Vector( -10, -10, -8 ),
				maxs = Vector( 10, 10, 8 ),
				mask = MASK_SHOT_HULL
			} )
		end
		if (tr.HitWorld or IsValid(tr.Entity)) then
			self:SetNextPrimaryFire( CurTime() + 0.5 )
			self:SetNextSecondaryFire( CurTime() + 0.5 )
		else
			self:SetNextPrimaryFire( CurTime() + 0.4 )
			self:SetNextSecondaryFire( CurTime() + 0.4 )
		end
		self.IsTryingToBackstab = false
	else
		self:SetNextMeleeAttack( CurTime() + 0.1 )
		self:SetNextPrimaryFire( CurTime() + 1.0 )
		self:SetNextSecondaryFire( CurTime() + 1.0 )
		self.IsTryingToBackstab = true
	end

end
function SWEP:Reload()
end