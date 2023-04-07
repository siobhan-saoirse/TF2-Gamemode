if CLIENT then
	SWEP.WepSelectIcon = surface.GetTextureID( "vgui/hud/weapon_l4d2_chainsaw" )
	SWEP.DrawWeaponInfoBox	= false
	SWEP.BounceWeaponIcon = false
	SWEP.RenderGroup = RENDERGROUP_BOTH
	killicon.Add( "weapon_l4d2_chainsaw", "vgui/hud/weapon_l4d2_chainsaw", Color( 0, 0, 0, 255 ) )
	end
	
	SWEP.Base				= "tf_weapon_gun_base"

	SWEP.PrintName = "Texan Chainsaw"

	SWEP.ViewModel = "models/weapons/melee/v_chainsaw.mdl"
	SWEP.WorldModel = "models/weapons/c_models/c_shotgun/c_shotgun.mdl"
	
	SWEP.ViewModelFlip = false
	
	SWEP.SwayScale = 0.5
	SWEP.BobScale = 0.5
	
	SWEP.AutoSwitchTo = false
	SWEP.AutoSwitchFrom = false
	SWEP.Weight = 5
	
	SWEP.Slot = 0
	SWEP.SlotPos = 0
	
	SWEP.UseHands = false
	SWEP.HoldType = "PRIMARY"
	SWEP.FiresUnderwater = false
	SWEP.DrawCrosshair = true
	SWEP.DrawAmmo = true
	SWEP.CSMuzzleFlashes = 1
	
	SWEP.WalkSpeed = 250
	SWEP.RunSpeed = 500
	
	SWEP.Cut = 0
	
	SWEP.Idle = 0
	SWEP.IdleTimer = CurTime()
	
	SWEP.Primary.Sound = Sound( "Chainsaw.FullThrottle" )
	SWEP.Primary.ClipSize = -1
	SWEP.Primary.DefaultClip = 128
	SWEP.Primary.MaxAmmo = 200
	SWEP.Primary.Automatic = true
	SWEP.Primary.Ammo = TF_METAL
	SWEP.Primary.Damage = 36
	SWEP.Primary.TakeAmmo = 1
	SWEP.Primary.Recoil = 2
	SWEP.Primary.Delay = 0.1
	SWEP.Primary.Force = 5000
	
	SWEP.Secondary.Sound = Sound( "Weapon.Swing" )
	SWEP.Secondary.ClipSize = -1
	SWEP.Secondary.DefaultClip = -1
	SWEP.Secondary.Automatic = false
	SWEP.Secondary.Ammo = "none"
	SWEP.Secondary.Damage = 10
	SWEP.Secondary.Delay = 0.73
	SWEP.Secondary.Force = 5000
	
	function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
	self.Idle = 0
	self.IdleTimer = CurTime() + 3
	end
	
	function SWEP:Deploy()
	self.ChainsawHighSpeed = CreateSound( self.Owner, self.Primary.Sound )
	self:SetWeaponHoldType( self.HoldType )
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
	self:SetNextSecondaryFire( CurTime() + self.Owner:GetViewModel():SequenceDuration() )
	self.Cut = 0
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	if SERVER then
		self.Owner:EmitSound("weapons/chainsaw/chainsaw_start_0"..math.random(1,2)..".wav")
	end
	end
	
	function SWEP:Holster()
	self.Cut = 0
	self.Idle = 0
	self.IdleTimer = CurTime()
	self.Owner:SetWalkSpeed( 200 )
	self.Owner:SetRunSpeed( 400 )
	if SERVER then
	self.Owner:StopSound( "Chainsaw.Start" )
	self.Owner:StopSound( "Chainsaw.Idle" )
	self.ChainsawHighSpeed:StopSound()
	self.Owner:StopSound( self.Primary.Sound )
	self.Owner:EmitSound( "Chainsaw.Stop" )
	end
	return true
	end
	
	function SWEP:PrimaryAttack()
	if self.Weapon:Ammo1() <= 0 then return end
	if self.FiresUnderwater == false and self.Owner:WaterLevel() == 3 then return end
	self.Owner:StopSound("Chainsaw.Idle")
	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:DoAnimationEvent( ACT_MP_ATTACK_STAND_SECONDARY )
	self.ChainsawHighSpeed:Play()
	self.Owner:ViewPunch( Angle( -1 * self.Primary.Recoil, 0, 0 ) )
	self:TakePrimaryAmmo( self.Primary.TakeAmmo )
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	self.Cut = 1
	self.Idle = 0
	self.IdleTimer = CurTime() + 0.2
	--self.Owner:LagCompensation( true )
	local tr = util.TraceLine( {
	start = self.Owner:GetShootPos(),
	endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 80,
	filter = self.Owner,
	mask = MASK_SHOT_HULL,
	} )
	if !IsValid( tr.Entity ) then
	tr = util.TraceHull( {
	start = self.Owner:GetShootPos(),
	endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 80,
	filter = self.Owner,
	mins = Vector( -16, -16, 0 ),
	maxs = Vector( 16, 16, 0 ),
	mask = MASK_SHOT_HULL,
	} )
	end
	if SERVER and IsValid( tr.Entity ) then
	local dmginfo = DamageInfo()
	local attacker = self.Owner
	if !IsValid( attacker ) then
	attacker = self
	end
	dmginfo:SetAttacker( attacker )
	dmginfo:SetInflictor( self )
	dmginfo:SetDamageType(DMG_ALWAYSGIB)
	dmginfo:SetDamage( self.Primary.Damage )
	dmginfo:SetDamageForce( self.Owner:GetForward() * self.Primary.Force )
	tr.Entity:TakeDamageInfo( dmginfo )
	if tr.Hit then
	if tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 then
	self.Owner:EmitSound( "Chainsaw.Gore"..math.random( 1, 6 ) )
	end
	end
	end
	end
	
	function SWEP:SecondaryAttack()
	self.Owner:EmitSound( self.Secondary.Sound )
	--self.Owner:LagCompensation( true )
	local tr = util.TraceLine( {
	start = self.Owner:GetShootPos(),
	endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 75,
	filter = self.Owner,
	mask = MASK_SHOT_HULL,
	} )
	if !IsValid( tr.Entity ) then
	tr = util.TraceHull( {
	start = self.Owner:GetShootPos(),
	endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 75,
	filter = self.Owner,
	mins = Vector( -16, -16, 0 ),
	maxs = Vector( 16, 16, 0 ),
	mask = MASK_SHOT_HULL,
	} )
	end
	if SERVER and tr.Hit and !( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) then
	self.Owner:EmitSound( "Weapon.HitWorld" )
	end
	if SERVER and IsValid( tr.Entity ) then
	local dmginfo = DamageInfo()
	local attacker = self.Owner
	if !IsValid( attacker ) then
	attacker = self
	end
	dmginfo:SetAttacker( attacker )
	dmginfo:SetInflictor( self )
	dmginfo:SetDamage( self.Secondary.Damage )
	dmginfo:SetDamageForce( self.Owner:GetForward() * self.Secondary.Force )
	tr.Entity:TakeDamageInfo( dmginfo )
	if tr.Hit then
	if tr.Entity:IsNPC() or tr.Entity:IsPlayer() and GAMEMODE:EntityTeam(tr.Entity) != self.Owner:Team() and tr.Entity:Health() > 0 then
	self.Owner:EmitSound( "Weapon.HitInfected" )
	end
	if tr.Entity:IsNPC() or tr.Entity:IsPlayer() and GAMEMODE:EntityTeam(tr.Entity) == self.Owner:Team() and tr.Entity:Health() > 0 then
	self.Owner:EmitSound( "player/survivor/hit/rifle_swing_hit_survivor"..math.random(1,2)..".wav" )
	end
	if !( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) then
	self.Owner:EmitSound( "Weapon.HitWorld" )
	end
	end
	end
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:DoAnimationEvent( ACT_MP_ATTACK_STAND_MELEE )
	self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	self.Idle = 0
	self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
	end
	
	function SWEP:Reload()
	end
	
	function SWEP:Think()
	if self.Cut == 1 and self.Owner:KeyReleased( IN_ATTACK ) then
	if SERVER then
	self.ChainsawHighSpeed:Stop()
	self.Owner:EmitSound( "Chainsaw.Stop" )
	end
	self.Cut = 0
	end
	if self.Cut == 1 and self.Weapon:Ammo1() <= 0 then
	if SERVER then
	self.Owner:StopSound( self.Primary.Sound )
	self.Owner:EmitSound( "Chainsaw.Stop" )
	end
	self.Cut = 0
	end
	local tr = util.TraceLine( {
	start = self.Owner:GetShootPos(),
	endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 75,
	filter = self.Owner,
	mask = MASK_SHOT_HULL,
	} )
	if self.Idle == 0 and self.IdleTimer > CurTime() and self.IdleTimer < CurTime() + 0.1 and self:Ammo1() >= 1 then
	self.Weapon:SendWeaponAnim( ACT_VM_IDLE )
	if SERVER then
	self.Owner:EmitSound("Chainsaw.Idle")
	end
	self.Idle = 1
	end
	if self.Weapon:Ammo1() > self.Primary.MaxAmmo then
	self.Owner:SetAmmo( self.Primary.MaxAmmo, self.Primary.Ammo )
	end
	end