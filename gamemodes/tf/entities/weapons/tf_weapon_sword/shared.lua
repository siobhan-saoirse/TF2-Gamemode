if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.PrintName			= "Eyelander"
SWEP.Slot				= 2

if CLIENT then

SWEP.HasCModel = true

local WhisperIdle = Sound("Sword.Idle")
local WhisperKill = Sound("Sword.Hit")

usermessage.Hook("SwordWhisper", function(msg)
	local t = msg:ReadChar()
	if t==2 then	LocalPlayer():EmitSound(WhisperKill)
	else			LocalPlayer():EmitSound(WhisperIdle)
	end
end)

SWEP.GlobalCustomHUD = {HudItemEffectMeter_Demoman = function(self) return self.dt.IsEyelander end}

end
 
SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/c_models/c_demo_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_claymore/c_claymore.mdl"
SWEP.Crosshair = "tf_crosshair3"
SWEP.ItemName = "Unique Achievement Sword"

SWEP.Swing = Sound("Weapon_Sword.Swing")
SWEP.SwingCrit = Sound("Weapon_Sword.SwingCrit")
SWEP.HitFlesh = Sound("Weapon_Sword.HitFlesh")
SWEP.HitRobot = Sound("MVM_Weapon_Sword.HitFlesh")
SWEP.HitWorld = Sound("Weapon_Sword.HitWorld")
SWEP.CriticalChance = 20

SWEP.WhisperKillProbabilityPlayer = 0.5
SWEP.WhisperKillProbabilityNPC = 0.2

SWEP.WhisperIdleMinDelay = 10
SWEP.WhisperIdleMaxDelay = 60
SWEP.WhisperKillMinDelay = 2
SWEP.WhisperKillMaxDelay = 4

SWEP.MeleeRange = 100
SWEP.HealthBonus = 15

SWEP.MeleeAttackDelay = 0.15
SWEP.BaseDamage = 65
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

--SWEP.CriticalChance = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay          = 0.8

SWEP.HoldType = "ITEM1"

SWEP.UsesSpecialAnimations = true

--[[
SWEP.VM_DRAW = "cm_draw"
SWEP.VM_IDLE = "cm_idle"
SWEP.VM_HITCENTER = "cm_swing_a,cm_swing_b"
SWEP.VM_SWINGHARD = "cm_swing_c"]]

function SWEP:SetupDataTables()
	self:CallBaseFunction("SetupDataTables")
	self:DTVar("Bool", 0, "IsEyelander")
end

-- The following weapons should not collect heads

local NoHeadCollecting = {
	[172] = true,	-- Scotsman's Skullcutter
	[327] = true,	-- Claidheamohmor
}

function SWEP:InitAttributes(owner, attributes)
	self:CallBaseFunction("InitAttributes", owner, attributes)
	
	
	if NoHeadCollecting[self:ItemIndex()] then
		return
	end
	
	self.dt.IsEyelander = true
end

function SWEP:OnPlayerKilled(ent)
	--ent:SetNWBool("ShouldDropDecapitatedRagdoll", true)
	ent:AddDeathFlag(DF_DECAP)
	
	if self.dt.IsEyelander and ent:CanGiveHead() then
		self.Owner:SetNWInt("Heads", self.Owner:GetNWInt("Heads") + 1)
		self.Owner:AddPlayerState(PLAYERSTATE_EYELANDER)
		self.Owner:UpdateState(0.1)
		
		if self.Owner:GetNWInt("Heads")<=4 then
			--self.Owner:SetClassSpeed(self.Owner:GetClassSpeed() + self.SpeedBonus)
			self.Owner.TempAttributes.AdditiveSpeedBonus = (self.Owner.TempAttributes.AdditiveSpeedBonus or 0) + 7.5
			self.Owner:ResetClassSpeed()
			
			self.Owner:SetMaxHealth(self.Owner:GetMaxHealth() + self.HealthBonus)
			--self.Owner:SetNWInt("PlayerMaxHealthBuff", self.HealthBonus * self:GetNWInt("Heads"))
		end
		self.Owner:SetHealth(self.Owner:Health() + self.HealthBonus)
		
		local prob
		if ent:IsPlayer() then	prob = self.WhisperKillProbabilityPlayer
		else					prob = self.WhisperKillProbabilityNPC
		end
		
		if math.random()<prob then
			self.WhisperType = 2
			self.NextWhisper = CurTime() + math.Rand(self.WhisperKillMinDelay, self.WhisperKillMaxDelay)
		end
	end
end

function SWEP:Think()
	if (self:GetItemData()) then
		if (self:GetItemData().model_player) then

			if (self:GetItemData().model_player == "models/workshop/weapons/c_models/c_demo_sultan_sword/c_demo_sultan_sword.mdl") then
				self:SetWeaponHoldType("MELEE_ALLCLASS") 
				self.HoldType = "MELEE_ALLCLASS"
				local hold = "MELEE_ALLCLASS"
				self.VM_DRAW			= _G["ACT_"..hold.."_VM_DRAW"]
				self.VM_IDLE			= _G["ACT_"..hold.."_VM_IDLE"]
				self.VM_HITCENTER	= _G["ACT_"..hold.."_VM_HITCENTER"]
				self.VM_SWINGHARD	= _G["ACT_"..hold.."_VM_SWINGHARD"]
				self.VM_PRIMARYATTACK	= _G["ACT_"..hold.."_VM_PRIMARYATTACK"]
				self.VM_SECONDARYATTACK	= _G["ACT_"..hold.."_VM_SECONDARYATTACK"]
				self.VM_RELOAD			= _G["ACT_"..hold.."_VM_RELOAD"]
				self.VM_RELOAD_START	= _G["ACT_"..hold.."_RELOAD_START"]
				self.VM_RELOAD_FINISH	= _G["ACT_"..hold.."_RELOAD_FINISH"]
				
				-- Special activities
				self.VM_CHARGE			= _G["ACT_"..hold.."_VM_CHARGE"]
				self.VM_DRYFIRE			= _G["ACT_"..hold.."_VM_DRYFIRE"]
				self.VM_IDLE_2			= _G["ACT_"..hold.."_VM_IDLE_2"]
				self.VM_CHARGE_IDLE_3	= _G["ACT_"..hold.."_VM_CHARGE_IDLE_3"]
				self.VM_IDLE_3			= _G["ACT_"..hold.."_VM_IDLE_3"]
				self.VM_PULLBACK		= _G["ACT_"..hold.."_VM_PULLBACK"]
				self.VM_PREFIRE			= _G["ACT_"..hold.."_ATTACK_STAND_PREFIRE"]
				self.VM_POSTFIRE		= _G["ACT_"..hold.."_ATTACK_STAND_POSTFIRE"]
				
				self.VM_INSPECT_START	= _G["ACT_"..hold.."_VM_INSPECT_START"]
				self.VM_INSPECT_IDLE	= _G["ACT_"..hold.."_VM_INSPECT_IDLE"]
				self.VM_INSPECT_GND		= _G["ACT_"..hold.."_VM_INSPECT_GND"]
			end
			
		end
	end
	self:InspectAnimCheck()
	if (self:GetItemData().model_player == "models/weapons/c_models/c_bigaxe/c_bigaxe.mdl") then
		self.HitWorld = "Halloween.HeadlessBossAxeHitWorld"
		self.HitFlesh = "Halloween.HeadlessBossAxeHitFlesh"
	end
	self.BaseClass.Think(self)
	if SERVER and self.dt.IsEyelander then
		if not self.NextWhisper then
			self.WhisperType = 1
			self.NextWhisper = CurTime() + math.Rand(self.WhisperIdleMinDelay, self.WhisperIdleMaxDelay)
		elseif CurTime()>self.NextWhisper then
			if self.WhisperType == 2 then
				if not self.Owner.NextSpeak or CurTime()>self.Owner.NextSpeak then
					umsg.Start("SwordWhisper", self.Owner)
						umsg.Char(2)
					umsg.End()
					self.WhisperType = 1
					self.NextWhisper = CurTime() + math.Rand(self.WhisperIdleMinDelay, self.WhisperIdleMaxDelay)
				else
					self.NextWhisper = CurTime() + math.Rand(self.WhisperKillMinDelay, self.WhisperKillMaxDelay)
				end
			else
				if not self.Owner.NextSpeak or CurTime()>self.Owner.NextSpeak then
					umsg.Start("SwordWhisper", self.Owner)
						umsg.Char(1)
					umsg.End()
				end
				self.NextWhisper = CurTime() + math.Rand(self.WhisperIdleMinDelay, self.WhisperIdleMaxDelay)
			end
		end
	end
end

function SWEP:OnRemove()
	if SERVER then
		--self.Owner:SetNWInt("Heads", 0)
	end
end