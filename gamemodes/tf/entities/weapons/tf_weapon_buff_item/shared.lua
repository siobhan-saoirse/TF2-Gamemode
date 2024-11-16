	if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Horn"
SWEP.Slot				= 1
end


SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/c_models/c_soldier_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_sandwich/c_sandwich.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Swing = Sound("weapons/buff_banner_horn_red.wav")
SWEP.SwingCrit = Sound("weapons/buff_banner_horn_blue.wav")
SWEP.Swing2 = Sound("weapons/battalions_backup_red.wav")
SWEP.SwingCrit2 = Sound("weapons/battalions_backup_blue.wav")
SWEP.HitFlesh = Sound("")
SWEP.HitWorld = Sound("weapons/buff_banner_flag.wav")

SWEP.BaseDamage = 45
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay          = 30
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay          = 30
SWEP.RangedMinHealing = 45
SWEP.RangedMaxHealing = 85

SWEP.HoldType = "MELEE"

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SendWeaponAnim(ACT_ITEM1_VM_SECONDARYATTACK)
		self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_ITEM1, true)
		if self:GetItemData().model_player == "models/weapons/c_models/c_battalion_bugle/c_battalion_bugle.mdl" then
			if self.Owner:Team() == TEAM_BLU then
				self:EmitSound(self.SwingCrit2, 85 )
			elseif self.Owner:Team() == TF_TEAM_PVE_INADERS then
				self:EmitSound(self.SwingCrit2, 85 )
			else
				self:EmitSound(self.Swing2, 85 )
			end
		else
			if self.Owner:Team() == TEAM_BLU then
				self:EmitSound(self.SwingCrit, 85 )
			elseif self.Owner:Team() == TF_TEAM_PVE_INADERS then
				self:EmitSound(self.SwingCrit, 85 )
			else
				self:EmitSound(self.Swing, 85 )
			end
		end
	timer.Simple(3, function()
		if SERVER then
		self.Owner:EmitSoundEx( self.HitWorld, 85	 )
		self.Owner:Speak("TLK_PLAYER_BATTLECRY")
		self.Owner:SelectWeapon("tf_weapon_rocketlauncher")
		self.Owner:SelectWeapon("tf_weapon_rocketlauncher_bbox")
		self.Owner:SelectWeapon("tf_weapon_rocketlauncher_qrl")
		self.Owner:SelectWeapon("tf_weapon_rocketlauncher_dh")
		self.Owner:SelectWeapon("tf_weapon_rocketlauncher_dt")
		self.Owner:SelectWeapon("tf_weapon_rocketlauncher_airstrike")
		self.Owner:SelectWeapon("tf_weapon_particle_launcher")
		GAMEMODE:StartMiniCritBoost(self.Owner)
		end
	end)
	timer.Simple(20, function()
		GAMEMODE:StopCritBoost(self.Owner)
	end)
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_ITEM1_VM_DRAW)
	
	return self:CallBaseFunction("Holster")
end

function SWEP:Holster()
	self.NextMeleeAttack = nil
	
	self:StopTimers()
	
	return self:CallBaseFunction("Holster")
end