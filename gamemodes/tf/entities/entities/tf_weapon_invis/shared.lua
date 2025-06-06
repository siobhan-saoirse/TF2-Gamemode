ENT.Type 			= "anim"
ENT.Base 			= "tf_wearable_item"

ENT.MeleeRange = 0

ENT.ForceMultiplier = 0
ENT.CritForceMultiplier = 0
ENT.ForceAddPitch = 0
ENT.CritForceAddPitch = 0

ENT.DefaultBaseDamage = 0
ENT.DamagePerHead = 10
--ENT.MaxHeads = 5

ENT.BaseDamage = 0
ENT.DamageRandomize = 0
ENT.MaxDamageRampUp = 0
ENT.MaxDamageFalloff = 0
ENT.StartCloakCooldown = false
ENT.StopCloakCooldown = false

ENT.HitPlayerSound = Sound("DemoCharge.HitFlesh")
ENT.HitPlayerRangeSound = Sound("DemoCharge.HitFleshRange")
ENT.HitWorldSound = Sound("DemoCharge.HitWorld")

ENT.CritStartSound = Sound("")
ENT.CritStopSound = Sound("Player.Spy_UnCloakReduced")

ENT.DefaultChargeDuration = 15
ENT.ChargeCooldownDuration = 8
ENT.ChargeSteerConstraint = GetConVar( "sensitivity" )

function ENT:SetupDataTables()
	self.BaseClass.SetupDataTables(self)
	self:DTVar("Bool", 0, "Cloaking")
	self:DTVar("Bool", 1, "Ready")
	self:DTVar("Float", 0, "NextEndCharge")
	self:DTVar("Float", 1, "AdditiveChargeDuration")
	self:DTVar("Float", 1, "ChargeCooldownMultiplier")
end

if CLIENT then

ENT.GlobalCustomHUD = {HudSpyCloak = true}  

function ENT:Think()
	self.BaseClass.Think(self)
	
	if not self.Initialized then
		self.Initialized = true
		if IsValid(self:GetOwner()) then
			self:GetOwner().TargeEntity = self
			if self:GetOwner() == LocalPlayer() then
				HudDemomanPipes:SetProgress(1)
				HudDemomanPipes:SetChargeStatus(0)
			end
		end
	end
	
	if self:GetOwner() == LocalPlayer() then
		if self.dt.Cloaking then
			if not self.ChargeDuration then
				self.ChargeDuration = self.DefaultChargeDuration + self.dt.AdditiveChargeDuration
			end
			
			local p = (self.dt.NextEndCharge - CurTime()) / self.ChargeDuration
			local p0 = p * (self.DefaultChargeDuration / self.ChargeDuration)
			
			if p0 < 0.33 then
				HudDemomanPipes:SetChargeStatus(3)
			elseif p0 < 0.66 then
				HudDemomanPipes:SetChargeStatus(2)
			else
				HudDemomanPipes:SetChargeStatus(1)
			end
			
			HudDemomanPipes:SetProgress(p)
		else
			HudDemomanPipes:SetChargeStatus(0)
			if self.dt.Ready then
				HudDemomanPipes:SetProgress(1)
			else
				self.ChargeDuration = nil
				
				local cooldown = self.ChargeCooldownDuration * self.dt.ChargeCooldownMultiplier
				local p = 1 - (self.dt.NextEndCharge - CurTime()) / cooldown
				HudDemomanPipes:SetProgress(p)
			end
		end
	end
end

end

if SERVER then

AddCSLuaFile("shared.lua")

function ENT:CanChargeThrough(ent)
	if ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_physics_multiplayer" then
		return (ent:GetPhysicsObject():IsValid(self.WModel2) and ent:GetPhysicsObject():IsMoveable() and ent:GetPhysicsObject():GetMass() < 200) or
				(ent:GetMaxHealth() > 1)
	elseif ent:GetClass() == "prop_dynamic" or ent:GetClass() == "prop_dynamic_override" then
		return ent:GetMaxHealth() > 1
	elseif ent:GetClass() == "func_breakable" then
		return true
	end
	
	return false
end

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	if IsValid(self:GetOwner()) then
		self:GetOwner().TargeEntity = self
	end
	self.dt.Cloaking = false
	self.dt.Ready = true
	self.dt.ChargeCooldownMultiplier = 1
	self:SetModel("models/empty.mdl")
end

function ENT:SendViewModelAnim( act , index , rate )
	
	local vm = self:GetOwner():GetViewModel( index )
	
	if ( not IsValid( vm ) ) then
		return
	end
	
	local seq = vm:SelectWeightedSequence( act )
	
	if ( seq == -1 ) then
		return
	end
	
	vm:SendViewModelMatchingSequence( seq )
	vm:SetPlaybackRate( rate or 1 )
end

function ENT:StartCloaking()
	if self.StopCloakCooldown == true then return end 
	if not self.ChargeDuration then
		self.dt.AdditiveChargeDuration = self:GetOwner().TempAttributes.AdditiveChargeDuration or 0
		self.dt.ChargeCooldownMultiplier = self:GetOwner().TempAttributes.ChargeCooldownMultiplier or 1
		self.ChargeDuration = self.DefaultChargeDuration + self.dt.AdditiveChargeDuration
	end
	
	local vm = self:GetOwner():GetViewModel(1)
			
	if ( IsValid( vm ) ) then
		--associate its weapon to us
		vm:SetWeaponModel( self:GetModel(), self )
	end
	self.dt.Ready = false
	self.dt.Cloaking = true
	self.dt.NextEndCharge = CurTime() + self.ChargeDuration
	self:GetOwner():EmitSound("Player.Spy_Cloak")
	self:GetOwner():PrintMessage(HUD_PRINTCENTER, "You are now cloaked."	)	
	self:SendViewModelAnim( ACT_VM_DRAW, 1 )
	for _,v in pairs(ents.GetAll()) do
		if v:IsNPC() and not v:IsFriendly(self:GetOwner()) then
			v:AddEntityRelationship(self:GetOwner(), D_LI, 99)
		end
	end
	self:GetOwner():SetNWBool("Bonked", true)
	local ent = self.Owner
	if (ent:Team() == TEAM_BLU) then
		ent:SetMaterial("models/shadertest/shader3")
	else
		ent:SetMaterial("models/props_combine/tprings_globe")
	end
	timer.Create("Cloak2"..self:GetOwner():EntIndex(), 0.8, 1, function()
		self:GetOwner():SetMaterial("color")
		ent:AddEffects(EF_NOSHADOW)
		
		self:GetOwner():SetNWBool("NoWeapon", true)
	end)
	for _,v in pairs(ents.FindByClass("tf_hat")) do
		if v:GetOwner()==self:GetOwner() then
			v:SetKeyValue("effects", "0")
			v:SetParent(self:GetOwner())
			v:SetNoDraw(true)
			v:DrawShadow(true)
			v.Dead = true
		end
	end	
	for _,v in pairs(ents.FindByClass("tf_wearable_hat")) do
		if v:GetOwner()==self:GetOwner() then
			v:SetKeyValue("effects", "0")
			v:SetParent(self:GetOwner())
			v:SetNoDraw(true)
			v:DrawShadow(true)
			v.Dead = true
		end
	end	
end
 
function ENT:StopCloaking()
	if self.StopCloakCooldown == true then return end 
	self.ChargeDuration = self.ChargeDuration
	self.dt.Ready = true
	self.dt.Cloaking = false
	self.dt.NextEndCharge = CurTime() + self.ChargeCooldownDuration * self.dt.ChargeCooldownMultiplier
	self.SpeedBonus = nil
	self:GetOwner():ResetClassSpeed()

	self:SendViewModelAnim( ACT_VM_HOLSTER, 1 )
	
	self:GetOwner():SetNWBool("NoWeapon", false)
	
	self:GetOwner():PrintMessage(HUD_PRINTCENTER, "You are now decloaked."	)
	self:EmitSound("player/spy_uncloak.wav")
	local ent = self.Owner
	if (ent:Team() == TEAM_BLU) then
		ent:SetMaterial("models/shadertest/shader3")
	else
		ent:SetMaterial("models/props_combine/tprings_globe")
	end
	timer.Create("Cloak2"..self:GetOwner():EntIndex(), 0.8, 1, function()
		self:GetOwner():SetMaterial("")
		ent:RemoveEffects(EF_NOSHADOW)
	end)
	for _,v in pairs(ents.GetAll()) do
		if v:IsNPC() and not v:IsFriendly(self:GetOwner()) then
			v:AddEntityRelationship(self:GetOwner(), D_HT, 99)
		end
	end

	self:GetOwner():SetNWBool("Bonked", false)
	for _,v in pairs(ents.FindByClass("tf_hat")) do
		if v:GetOwner()==self:GetOwner() then
			v:SetKeyValue("effects", "0")
			v:SetParent(self:GetOwner())
			vself.WModel2:SetNoDraw(false)
			v:DrawShadow(false)
			v.Dead = false
		end
	end
	for _,v in pairs(ents.FindByClass("tf_wearable_hat")) do
		if v:GetOwner()==self:GetOwner() then
			v:SetKeyValue("effects", "0")
			v:SetParent(self:GetOwner())
			vself.WModel2:SetNoDraw(false)
			v:DrawShadow(false)
			v.Dead = false
		end
	end
	if self.ChargeSoundEnt then
		self.ChargeSoundEnt:Stop()
		self.ChargeSoundEnt = nil
	end
	
	if self.ChargeState then
		if self.ChargeState == 2 then
			if self.CritStartSoundEnt then
				self.CritStartSoundEnt:Stop()
				self.CritStartSoundEnt = nil
				self:GetOwner():EmitSound(self.CritStopSound)
			end
		end
		
		self.NextEndCritBoost = CurTime() + 0.4
	end
end

function ENT:OnMeleeSwing()
	if self.dt.Cloaking then
		self:StopCloaking()
	end
end

function ENT:OnPrimaryAttack()
	if self.dt.Cloaking then
		self:StopCloaking()
	end
end

function ENT:Think()
	if not IsValid(self:GetOwner()) then return end
	
	if self.dt.Cloaking then
		local vel = self:GetOwner():GetVelocity():LengthSqr()
		
		if CurTime() > self.dt.NextEndCharge then
			self:StopCloaking()
			return
		end
		
		local p = (self.dt.NextEndCharge - CurTime()) / self.ChargeDuration
		local p0 = p * (self.DefaultChargeDuration / self.ChargeDuration)
		
		if p0 < 0.33 and self.ChargeState == 1 then
			self.ChargeState = 2
			
			if not self.CritStartSoundEnt then
				local rf = RecipientFilter()
				rf:AddAllPlayers()
				self.CritStartSoundEnt = CreateSound(self, self.CritStartSound,rf)
			end
			if self.CritStartSoundEnt then
				self.CritStartSoundEnt:Play()
			end
		elseif p0 < 0.66 and not self.ChargeState then
			self.ChargeState = 1
		end
	elseif not self.dt.Ready then
		if CurTime() > self.dt.NextEndCharge then
			self.dt.Ready = true
			self:GetOwner():SendLua("surface.PlaySound('player/recharged.wav')")
		end
		self.ChargeState = nil
	end
	
	if self.NextEndCritBoost and CurTime() > self.NextEndCritBoost then
		GAMEMODE:StopCritBoost(self:GetOwner())
		self.NextEndCritBoost = nil
	end
	
	if self:GetOwner():KeyDown(IN_ATTACK2) and self.dt.Ready and self.StartCloakCooldown == false then
		self:StartCloaking()
		self.StartCloakCooldown = true
		self.StopCloakCooldown = true
		timer.Simple(1.6, function()
			self.StopCloakCooldown = false
		end)
		timer.Simple(1.5, function()
			self.StartCloakCooldown = false
		end)
		
	end

	if self:GetOwner():KeyDown(IN_ATTACK2) and not self.dt.Ready and self.StopCloakCooldown == false then
		self:StopCloaking()
		self.StopCloakCooldown = true
		timer.Simple(1.6, function()
			self.StopCloakCooldown = false
		end)
	end
	self:NextThink(CurTime())
	return true
end

end 