if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Hot Hand"
SWEP.Slot				= 2
end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/v_models/v_bat_scout.mdl"
SWEP.WorldModel			= "models/empty.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Swing = Sound("weapons/slap_swing.wav") -- Sound("Weapon_Slap.Swing")
SWEP.SwingCrit = Sound("weapons/slap_swing_crit.wav") -- Sound("Weapon_Slap.Swing")
SWEP.HitFlesh = Sound("Weapon_Slap.OpenHand") -- Sound("Weapon_Slap.Swing")
SWEP.HitWorld = Sound("weapons/slap_hit_world1.wav") -- Sound("Weapon_Slap.Swing")

SWEP.BaseDamage = 35
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay          = 1.0

SWEP.HoldType = "MELEE_ALLCLASS"

SWEP.Special_HumiliationCount = "#Humiliation_Count"
SWEP.Special_HumiliationKill = "#Humiliation_Kill" 

function SWEP:InspectAnimCheck()
self:CallBaseFunction("InspectAnimCheck")
self.VM_DRAW = _G["ACT_ITEM3_VM_DRAW"]
self.VM_IDLE = _G["ACT_ITEM3_VM_IDLE"]
self.VM_HITCENTER = _G["ACT_ITEM3_VM_PRIMARYATTACK"]
self.VM_SWINGHARD = _G["ACT_ITEM3_VM_PRIMARYATTACK"]
self.VM_INSPECT_START = _G["ACT_ITEM3_VM_INSPECT_START"]
self.VM_INSPECT_IDLE = _G["ACT_ITEM3_VM_INSPECT_IDLE"]
self.VM_INSPECT_END = _G["ACT_ITEM3_VM_INSPECT_END"]
self.Owner:SetPoseParameter("r_hand_grip",15.0)
self.Owner:SetPoseParameter("r_arm",3)
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if self:CriticalEffect() then
		----MsgN(Format("[%f] From SWEP:PrimaryAttack (%s) : Critical hit!", CurTime(), tostring(self)))
		self:EmitSound(self.SwingCrit, 100, 100)
		--[[if SERVER then
			self:EmitSound(self.SwingCrit, 100, 100)
			umsg.Start("DoMeleeSwing",self.Owner)
				umsg.Entity(self)
				umsg.Bool(true)
			umsg.End()
		end]]
			self:SendWeaponAnim(self.VM_SWINGHARD)
		if self.HasThirdpersonCritAnimation then
			self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_SECONDARYFIRE, true)
		else
			self.Owner:SetAnimation(PLAYER_ATTACK1)
		end
	else
		self:EmitSound(self.Swing, 100, 100)
		--[[if SERVER then
			self:EmitSound(self.Swing, 100, 100)
			umsg.Start("DoMeleeSwing",self.Owner)
				umsg.Entity(self)
				umsg.Bool(false)
			umsg.End()
		end]]
		
		if self.UsesLeftRightAnim then
			self:SendWeaponAnim(self.VM_HITLEFT)
		else
			self:SendWeaponAnim(self.VM_HITCENTER)
		end
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
	
	if self.HasCustomMeleeBehaviour then return true end
	
	if SERVER and IsValid(self.Owner.TargeEntity) then
		self.Owner.TargeEntity:OnMeleeSwing()
	end
	
	
	self.NextIdle = CurTime() + self:SequenceDuration()  
	
	--self.NextMeleeAttack = CurTime() + self.MeleeAttackDelay
	if not self.NextMeleeAttack then
		self.NextMeleeAttack = {}
	end

	if not self.NextMeleeAttack2 then
		self.NextMeleeAttack2 = {}
	end
	
	self:StopTimers()
	self.CriticalChance = 20
	self.HitFlesh = Sound("Weapon_Slap.OpenHand") 
	self.HitWorld = Sound("Weapon_Slap.OpenHandHitWorld") 
	if (IsFirstTimePredicted()) then
		table.insert(self.NextMeleeAttack, CurTime() + self.MeleeAttackDelay)
		table.insert(self.NextMeleeAttack2, CurTime() + self.MeleeAttackDelay + 0.3)
	end
	
	return true
end

function SWEP:Think()
	self:CallBaseFunction("Think")
	while self.NextMeleeAttack2 and self.NextMeleeAttack2[1] and CurTime() > self.NextMeleeAttack2[1] and IsFirstTimePredicted() do
		self.HitFlesh = Sound("Weapon_Slap.BackHand") 
		self.HitWorld = Sound("Weapon_Slap.BackHandHitWorld") 
		self.CriticalChance = 0
		self:MeleeAttack()
		table.remove(self.NextMeleeAttack2, 1)
		
		self:RollCritical()
	end
end
function SWEP:OnMeleeHit(tr)
	if CLIENT then return end
	
	local ent = tr.Entity
	if not (ent:IsTFPlayer() and self.Owner:CanDamage(ent) and not ent:IsBuilding()) then return end
	
	local InflictorClass = gamemode.Call("GetInflictorClass", ent, self.Owner, self)
	
	umsg.Start("Notice_EntityHumiliationCounter")
		umsg.String(GAMEMODE:EntityName(ent))
		umsg.Short(GAMEMODE:EntityTeam(ent))
		umsg.Short(GAMEMODE:EntityID(ent))
		
		umsg.String(InflictorClass)
		
		umsg.String(GAMEMODE:EntityName(self.Owner))
		umsg.Short(GAMEMODE:EntityTeam(self.Owner))
		umsg.Short(GAMEMODE:EntityID(self.Owner))
		
		--[[
		umsg.String(GAMEMODE:EntityName(cooperator))
		umsg.Short(GAMEMODE:EntityTeam(cooperator))
		umsg.Short(GAMEMODE:EntityID(cooperator))]]
		
		umsg.Bool(self.CurrentShotIsCrit)
	umsg.End()
end
