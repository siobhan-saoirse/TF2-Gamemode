if SERVER then
	AddCSLuaFile( "shared.lua" )
end
game.AddParticles( "particles/soldierbuff.pcf" )
PrecacheParticleSystem( "soldierbuff_red_buffed" )
PrecacheParticleSystem( "soldierbuff_blue_buffed" )

if CLIENT then
	SWEP.PrintName			= "Concheror"
	SWEP.Slot				= 1
	SWEP.HasCModel			= true

	SWEP.RenderGroup 		= RENDERGROUP_BOTH
	
end


SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/c_models/c_soldier_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_shogun_warhorn/c_shogun_warhorn.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Spawnable = true
SWEP.SpeedEnabled = false
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.Swing = Sound("weapons/samurai/tf_conch.wav")	
SWEP.HitFlesh = Sound("")
SWEP.HitWorld = Sound("weapons/buff_banner_flag.wav")

SWEP.BaseDamage = 45
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay          = 28
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay          = 30
SWEP.RangedMinHealing = 45
SWEP.RangedMaxHealing = 85

SWEP.HoldType = "MELEE"

SWEP.Ready = true
function SWEP:InspectAnimCheck()
	self:CallBaseFunction("InspectAnimCheck")
	self.VM_DRAW = ACT_ITEM2_VM_DRAW
	self.VM_IDLE = ACT_ITEM2_VM_IDLE
end

function SWEP:PrimaryAttack()

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )	
	self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_ITEM2, true)
	self:SendWeaponAnim(ACT_ITEM2_VM_SECONDARYATTACK)
	self:EmitSound("items/samurai/tf_conch.wav", 90, 100)
	timer.Simple(3, function()
		if SERVER then
		timer.Create("SetFasterSpeed1", 1, 20, function()
			self.Owner:SetClassSpeed(self.Owner:GetClassSpeed() * 1.003)	
		end)
		if SERVER then
		animent3 = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
		animent3:SetAngles(self.Owner:GetAngles())
		animent3:SetPos(self.Owner:GetPos())
		animent3:SetModel("models/workshop_partner/weapons/c_models/c_shogun_warbanner/c_shogun_warbanner.mdl")
		animent3:Spawn()
		animent3:Activate()
		animent3:SetParent(self.Owner)
		animent3:AddEffects(EF_BONEMERGE)
		animent3:SetName("Cosmetic"..self.Owner:EntIndex())
		
		if self.Owner:GetPlayerClass() == "soldierbuffed" then	
			timer.Create("RemoveBanner"..self.Owner:EntIndex(), 120, 1, function()
				animent3:Remove()
			end)
		else
			timer.Create("RemoveBanner"..self.Owner:EntIndex(), 20, 1, function()
				animent3:Remove()
			end)
		end
		end
		self.Ready = false
		timer.Create("HealFor20Secs", 1, 20, function()
			GAMEMODE:HealPlayer(self.Owner, self.Owner, 30, false, false)
			self.Owner:SetArmor(120) 
		end)
		for k,v in ipairs(team.GetPlayers(self.Owner:Team())) do
			GAMEMODE:StartMiniCritBoost(v)
			ParticleEffectAttach("soldierbuff_red_buffed", PATTACH_ABSORIGIN_FOLLOW, v, 0)
			timer.Create("HealFor20Secs"..v:EntIndex(), 1, 20, function()
				GAMEMODE:HealPlayer(self.Owner, v, 30, false, false)
				v:SetArmor(120)
				v:SetClassSpeed(v:GetClassSpeed() * 1.003)				
			end)
		end
		self.SpeedEnabled = true
		self.Owner:Speak("TLK_PLAYER_BATTLECRY")
		self.Owner:SelectWeapon("tf_weapon_rocketlauncher")
		self.Owner:SelectWeapon("tf_weapon_rocketlauncher_bbox")
		self.Owner:SelectWeapon("tf_weapon_rocketlauncher_qrl")
		self.Owner:SelectWeapon("tf_weapon_rocketlauncher_dh")
		self.Owner:SelectWeapon("tf_weapon_rocketlauncher_dt")
		self.Owner:SelectWeapon("tf_weapon_rocketlauncher_airstrike")
		self.Owner:SelectWeapon("tf_weapon_particle_launcher")
		GAMEMODE:StartMiniCritBoost(self.Owner)
		ParticleEffectAttach("soldierbuff_red_buffed", PATTACH_ABSORIGIN_FOLLOW, self.Owner, 0)
		end
	end)
	if self.Owner:GetPlayerClass() == "soldierbuffed" then
		timer.Simple(120, function()
			if SERVER then
				for k,v in ipairs(team.GetPlayers(self.Owner:Team())) do
					timer.Stop("SetFasterSpeed1"..v:EntIndex())
					GAMEMODE:StopCritBoost(v) 
					v:ResetClassSpeed()
					v:StopParticles() 
				end
				timer.Stop("SetFasterSpeed1")
				GAMEMODE:StopCritBoost(self.Owner) 
				self.Owner:ResetClassSpeed()	
								
			end
			self.Owner:StopParticles()
			self.SpeedEnabled = false
			self.Ready = true
		end)
	else
		timer.Simple(20, function()
			if SERVER then
				for k,v in ipairs(team.GetPlayers(self.Owner:Team())) do
					timer.Stop("SetFasterSpeed1"..v:EntIndex())
					GAMEMODE:StopCritBoost(v) 
					v:ResetClassSpeed()
					v:StopParticles() 
				end
				timer.Stop("SetFasterSpeed1")
				GAMEMODE:StopCritBoost(self.Owner) 
				self.Owner:ResetClassSpeed()	
								
			end
			self.Owner:StopParticles()
			self.SpeedEnabled = false
			self.Ready = true
		end)
	end
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_ITEM2_VM_DRAW)
	--MsgFN("Deploy %s", tostring(self))
	self.BaseClass.Deploy(self)
end

function SWEP:Holster()
	self.NextMeleeAttack = nil
	return self:CallBaseFunction("Holster")
end