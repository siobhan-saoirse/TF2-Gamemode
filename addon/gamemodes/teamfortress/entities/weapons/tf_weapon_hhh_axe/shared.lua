if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then

SWEP.PrintName			= "Horseless Headless Horsemann's Headtaker"
SWEP.HasCModel = true
SWEP.Slot				= 3

SWEP.RenderGroup 		= RENDERGROUP_BOTH

local WhisperIdle = Sound("Sword.Idle")
local WhisperKill = Sound("Sword.Hit")

usermessage.Hook("SwordWhisper", function(msg)
	local t = msg:ReadChar()
	if t==2 then	LocalPlayer():EmitSound(WhisperKill)
	else			LocalPlayer():EmitSound(WhisperIdle)
	end
end)

SWEP.GlobalCustomHUD = {HudItemEffectMeter_Demoman = function(self) return self.dt.IsEyelander end}

function SWEP:InitializeCModel()
	self:CallBaseFunction("InitializeCModel")
	
	for _,v in pairs(self.Owner:GetTFItems()) do
		if v:GetClass() == "tf_wearable_item_demoshield" then
			self.ShieldEntity = v
			v:InitializeCModel(self)
		end
	end
	for _,v in pairs(self.Owner:GetTFItems()) do
		if v:GetClass() == "tf_wearable_item_tideturnr" then
			self.ShieldEntity = v
			v:InitializeCModel(self)
		end
	end
end

function SWEP:ViewModelDrawn()
	self:CallBaseFunction("ViewModelDrawn")
	
	if IsValid(self.ShieldEntity) and IsValid(self.ShieldEntity.CModel) then
		self.ShieldEntity:StartVisualOverrides()
		self.ShieldEntity.CModel:DrawModel()
		self.ShieldEntity:EndVisualOverrides()
	end
end

end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/v_models/v_bottle_demoman.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_bigaxe/c_bigaxe.mdl"
SWEP.Crosshair = "tf_crosshair3"
SWEP.ItemName = "Horseless Headless Horsemann's Headtaker"

SWEP.Swing = Sound("Halloween.HeadlessBossAttack")
SWEP.SwingCrit = Sound("Halloween.HeadlessBossAttack")
SWEP.HitFlesh = Sound("Halloween.HeadlessBossAxeHitFlesh")
SWEP.HitWorld = Sound("Halloween.HeadlessBossAxeHitWorld")

SWEP.WhisperKillProbabilityPlayer = 0.5
SWEP.WhisperKillProbabilityNPC = 0.2

SWEP.WhisperIdleMinDelay = 10
SWEP.WhisperIdleMaxDelay = 60
SWEP.WhisperKillMinDelay = 2
SWEP.WhisperKillMaxDelay = 4

SWEP.MeleeRange = 100
SWEP.HealthBonus = 15

SWEP.BaseDamage = 195
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

--SWEP.CriticalChance = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay          = 1

SWEP.HoldType = "MELEE"

SWEP.UsesSpecialAnimations = true
SWEP.MeleeAttackDelay = 0.45

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
			if self.Owner:GetInfoNum("tf_giant_robot",0) != 1 then
			self.Owner:ResetClassSpeed()
			end
			
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

function SWEP:Deploy()
	self:CallBaseFunction("Deploy")
	if self.Owner:GetPlayerClass() == "demoman" then
		self:SetHoldType("ITEM1")
	end
end
	
function SWEP:Think()
	self:CallBaseFunction("Think")
	
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