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

SWEP.WhisperKillProbabilityPlayer = 0.5
SWEP.WhisperKillProbabilityNPC = 0.2

SWEP.WhisperIdleMinDelay = 10
SWEP.WhisperIdleMaxDelay = 60
SWEP.WhisperKillMinDelay = 2
SWEP.WhisperKillMaxDelay = 4

SWEP.MeleeRange = 100
SWEP.HealthBonus = 15

SWEP.MeleeAttackDelay = 0.2
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

SWEP.VM_DRAW = ACT_VM_DRAW_SPECIAL
SWEP.VM_IDLE = ACT_VM_IDLE_SPECIAL
SWEP.VM_HITCENTER = ACT_VM_HITCENTER_SPECIAL
SWEP.VM_SWINGHARD = ACT_VM_SWINGHARD_SPECIAL

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
	if self:GetItemData().model_player == "models/weapons/c_models/c_headtaker/c_headtaker.mdl" then
		self.HitFlesh = Sound("Halloween.HeadlessBossAxeHitFlesh")
		self.HitWorld = Sound("Halloween.HeadlessBossAxeHitWorld")
	end
	self.VM_DRAW = ACT_VM_DRAW_SPECIAL
	self.VM_IDLE = ACT_VM_IDLE_SPECIAL
	self.VM_HITCENTER = ACT_VM_HITCENTER_SPECIAL
	self.VM_SWINGHARD = ACT_VM_SWINGHARD_SPECIAL
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