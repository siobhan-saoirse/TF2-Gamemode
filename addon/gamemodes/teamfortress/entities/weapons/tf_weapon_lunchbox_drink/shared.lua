if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Bonk! Atomic Punch"
SWEP.Slot				= 1
 
function SWEP:ResetParticles(state_override)
	self:CallBaseFunction("ResetParticles", state_override)
	
	if not self.DoneDeployParticle then
		if self.Owner==LocalPlayer() and not LocalPlayer():ShouldDrawLocalPlayer() then
			local ent = self:GetViewModelEntity()
			if IsValid(ent) then
				ParticleEffectAttach("energydrink_splash", PATTACH_POINT_FOLLOW, ent, ent:LookupAttachment("drink_spray"))
			end
		end
		
		self.DoneDeployParticle = true
	end
end 

function SWEP:Deploy()
	self:CallBaseFunction("Deploy")
	
	ParticleEffectAttach("energydrink_splash", PATTACH_POINT_FOLLOW, ent, ent:LookupAttachment("drink_spray"))
end

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_scout_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_energy_drink/c_energy_drink.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Swing = Sound("")
SWEP.SwingCrit = Sound("")
SWEP.HitFlesh = Sound("")
SWEP.HitWorld = Sound("")

SWEP.BaseDamage = 45
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay          = 40
SWEP.RangedMinHealing = 45
SWEP.RangedMaxHealing = 85

SWEP.HoldType = "ITEM1"

function SWEP:Deploy()
	self:EmitSound("player/pl_scout_dodge_can_open.wav", 85)
	if (self.Owner:GetPlayerClass() == "bonk_scout") then
		self.Owner:SetNWBool("Taunting", true)
	end
	timer.Simple(0.8, function()
		if (self.Owner:GetPlayerClass() == "bonk_scout") then
			self:PrimaryAttack()
		end
	end)
	self.BaseClass.Deploy(self)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 40)
	self.Owner:DoAnimationEvent(ACT_DOD_SPRINT_AIM_SPADE, true)
	self.Owner:SetNWBool("Taunting", true)
	if SERVER then
	self.Owner:ConCommand("tf_tp_simulation_toggle")
	end
	if (self:GetItemData().name != "Crit-a-Cola") then

		timer.Simple(0.92, function() 
			if SERVER then
				if (self.Owner:GetWeapons()[1] == self) then
					self.Owner:SelectWeapon(self.Owner:GetWeapons()[2])	
				else
					self.Owner:SelectWeapon(self.Owner:GetWeapons()[1])	
				end
			end
			self.Owner:SetNWBool("Taunting", false) 
			self.Owner:SetNWBool("Bonked", true) 
			ParticleEffectAttach( 'warp_version', PATTACH_POINT_FOLLOW, self.Owner, 3)
			ParticleEffectAttach( 'scout_dodge_socks', PATTACH_ABSORIGIN_FOLLOW, self.Owner, 2 )
			ParticleEffectAttach( 'scout_dodge_pants', PATTACH_ABSORIGIN_FOLLOW, self.Owner, 2 )
			if self.Owner:Team() == TEAM_BLU then
				ParticleEffectAttach( 'scout_dodge_blue', PATTACH_POINT_FOLLOW, self.Owner, 3 )
			elseif self.Owner:Team() == TF_TEAM_PVE_INVADERS then
				ParticleEffectAttach( 'scout_dodge_blue', PATTACH_POINT_FOLLOW, self.Owner, 3 )
			else
				ParticleEffectAttach( 'scout_dodge_red', PATTACH_POINT_FOLLOW, self.Owner, 3 )
			end
			if SERVER then
			self.Owner:GodEnable()
			end
		end)
		timer.Simple(15, function()
			if SERVER then
			self.Owner:EmitSound("TFPlayer.StunImpact")
			self.Owner:SetClassSpeed(self.Owner:GetClassSpeed() * 0.75)
			ParticleEffectAttach("bonk_text", PATTACH_POINT_FOLLOW, self.Owner, self.Owner:LookupAttachment("head"))
			timer.Simple(20, function()
				self.Owner:ResetClassSpeed()
			end)	
			self.Owner:ConCommand("tf_firstperson")
			self.Owner:GodDisable()
			self.Owner:StopParticles() 
			self.Owner:SetNWBool("Bonked", false)
			end
		end)
		timer.Simple(7, function()
			if SERVER then
			self:EmitSound( "Scout.Invincible0"..math.random(1,4))
			end
		end)

	else
		timer.Simple(0.92, function() 
			if SERVER then
				if (self.Owner:GetWeapons()[1] == self) then
					self.Owner:SelectWeapon(self.Owner:GetWeapons()[2])	
				else
					self.Owner:SelectWeapon(self.Owner:GetWeapons()[1])	
				end
			end
			self.Owner:ConCommand("tf_firstperson")
			self.Owner:SetNWBool("Taunting", false) 
			self.Owner:SetNWBool("Bonked", false) 
			self.Owner:AddPlayerState(PLAYERSTATE_MARKED,true)
			if SERVER then
				GAMEMODE:StartMiniCritBoost(self.Owner)
				self.Owner:StopSound("Weapon_General.CritPower")
				self.Owner:EmitSound("Weapon_General.CritPower")
			end
		end)
		timer.Simple(15, function()
			if SERVER then
			self.Owner:EmitSound("TFPlayer.StunImpact")
			self.Owner:SetClassSpeed(self.Owner:GetClassSpeed() * 0.75)
			ParticleEffectAttach("bonk_text", PATTACH_POINT_FOLLOW, self.Owner, self.Owner:LookupAttachment("head"))
			timer.Simple(20, function()
				self.Owner:ResetClassSpeed()
			end)	
			self.Owner:StopParticles() 
			self.Owner:RemovePlayerState(PLAYERSTATE_MARKED)
			GAMEMODE:StopMiniCritBoost(self.Owner)
			self.Owner:StopSound("Weapon_General.CritPower")
			self.Owner:EmitSound("TFPlayer.CritBoostOff")
			end
		end)
	end
	timer.Simple(40, function()
		if CLIENT then
		self.Owner:EmitSound("player/recharged.wav", 95)
		end
	end)
end