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

SWEP.VM_DRAW = ACT_ITEM1_VM_DRAW
SWEP.VM_IDLE = ACT_ITEM1_VM_IDLE
SWEP.VM_PRIMARYATTACK = ACT_ITEM1_VM_RELOAD

function SWEP:Deploy()
	self.BaseClass.Deploy(self)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + 40)
	self.Owner:DoTauntEvent("taunt04", true)
	self.Owner:SetNWBool("Taunting", true)
	if SERVER then
	self.Owner:ConCommand("tf_tp_simulation_toggle")
	end
	if (self:GetItemData().name != "Crit-a-Cola") then

		timer.Simple(1.2, function() 
			self.Owner:DoTauntEvent("a_flinch01", true)
			if SERVER then
				if (self.Owner:GetWeapons()[1] == self) then
					self.Owner:SelectWeapon(self.Owner:GetWeapons()[2])	
				else
					self.Owner:SelectWeapon(self.Owner:GetWeapons()[1])	
				end
			end
			self.Owner:SetNWBool("Taunting", false) 
			self.Owner:SetNWBool("Bonked", true) 
			if SERVER then
				ParticleEffectAttach( 'warp_version', PATTACH_ABSORIGIN_FOLLOW, self.Owner, 0)
				local att = 1
				local att2 = 1
				local att3 = 1
				local att4 = 1
				local att5 = 1
				if (self:GetOwner():LookupAttachment("back_upper")) then

					att = self:GetOwner():LookupAttachment("back_upper")
					att2 = self:GetOwner():LookupAttachment("back_lower")
					att3 = self:GetOwner():LookupAttachment("foot_R")
					att4 = self:GetOwner():LookupAttachment("foot_L")
					att5 = self:GetOwner():LookupAttachment("hand_L")

				end
				if self:GetOwner():Team() == TEAM_BLU then
					self:GetOwner().trail = util.SpriteTrail( self:GetOwner(), att, Color( 255, 255, 255 ), false, 12, 12, 0.5, 1 / ( 96 * 1 ), "effects/beam001_blu" )
					self:GetOwner().trail2 = util.SpriteTrail( self:GetOwner(), att2, Color( 255, 255, 255 ), false, 16, 16, 0.5, 1 / ( 96 * 1 ), "effects/beam001_blu" )
					self:GetOwner().trail3 = util.SpriteTrail( self:GetOwner(), att3, Color( 255, 255, 255 ), false, 8, 8, 0.5, 1 / ( 96 * 1 ), "effects/beam001_white" )
					self:GetOwner().trail4 = util.SpriteTrail( self:GetOwner(), att4, Color( 255, 255, 255 ), false, 8, 8, 0.5, 1 / ( 96 * 1 ), "effects/beam001_white" )
					self:GetOwner().trail5 = util.SpriteTrail( self:GetOwner(), att5, Color( 255, 255, 255 ), false, 8, 8, 0.5, 1 / ( 96 * 1 ), "effects/beam001_blu" )
				else
					self:GetOwner().trail = util.SpriteTrail( self:GetOwner(), att, Color( 255, 255, 255 ), false, 12, 12, 0.5, 1 / ( 96 * 1 ), "effects/beam001_red" )
					self:GetOwner().trail2 = util.SpriteTrail( self:GetOwner(), att2, Color( 255, 255, 255 ), false, 16, 16, 0.5, 1 / ( 96 * 1 ), "effects/beam001_red" )
					self:GetOwner().trail3 = util.SpriteTrail( self:GetOwner(), att3, Color( 255, 255, 255 ), false, 8, 8, 0.5, 1 / ( 96 * 1 ), "effects/beam001_white" )
					self:GetOwner().trail4 = util.SpriteTrail( self:GetOwner(), att4, Color( 255, 255, 255 ), false, 8, 8, 0.5, 1 / ( 96 * 1 ), "effects/beam001_white" )
					self:GetOwner().trail5 = util.SpriteTrail( self:GetOwner(), att5, Color( 255, 255, 255 ), false, 8, 8, 0.5, 1 / ( 96 * 1 ), "effects/beam001_red" )
				end
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
			if SERVER then
				if (IsValid(self:GetOwner().trail)) then
					self:GetOwner().trail:Remove()
					self:GetOwner().trail2:Remove()
					self:GetOwner().trail3:Remove()
					self:GetOwner().trail4:Remove()
					self:GetOwner().trail5:Remove()
				end
			end
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
			timer.Simple(20, function()
				self.Owner:ResetClassSpeed()
			end)	
			self.Owner:StopParticles() 
			timer.Simple(5, function()
				self.Owner:RemovePlayerState(PLAYERSTATE_MARKED)
			end)
			GAMEMODE:StopMiniCritBoost(self.Owner)
			self.Owner:StopSound("Weapon_General.CritPower")
			end
		end)
	end
	timer.Simple(40, function()
		if CLIENT then
		self.Owner:EmitSound("player/recharged.wav", 95)
		end
	end)
end