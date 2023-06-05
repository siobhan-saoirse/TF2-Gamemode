ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

if CLIENT then

function ENT:Draw()
end

end

if SERVER then

AddCSLuaFile( "shared.lua" ) 

ENT.NoDamageCooperation = true

local DamagePeriod = 0.5
local DamagePerTick = 1

function ENT:ShouldExtinguishInWater()
	if not IsValid(self.Target) then return false end
	
	-- Metallic props that can be ignited are usually oil drums, don't extinguish them when they enter water)
	if self.Target:GetClass() == "prop_physics" and self.Target:GetMaterialType() == MAT_METAL then
		return false
	end
	
	return true
end

function ENT:GetInflictorName(inf)
	if inf.NameOverride then
		return inf.NameOverride
	end
	
	if inf.GetItemData then
		local d = inf:GetItemData()
		if d.item_iconname then
			--return "tf_weapon_"..d.item_iconname
			return d.item_iconname
		end
	end
	
	return inf:GetClass()
end

function ENT:TargetIsFireproof()
	if IsValid(self.Target) and self.Target:IsPlayer() then
		if self.Target.TempAttributes.Fireproof then
			return true
		end
		
		local c = self.Target:GetPlayerClassTable()
		if c and c.Fireproof then
			return true
		end
	end
	return false
end

function ENT:Update(data)
	local NameOverride
	if IsValid(data.Inflictor) then
		NameOverride = self:GetInflictorName(data.Inflictor)
		self.Attributes = data.Inflictor.Attributes
	end

	-- Extend the life time
	self.LifeTime = data.LifeTime or 10
	if data.Inflictor and data.Inflictor.BurnTimeMultiplier then
		self.LifeTime = self.LifeTime * data.Inflictor.BurnTimeMultiplier
	end
	
	self.DamagePerTick = DamagePerTick
	if data.Inflictor and data.Inflictor.BurnDamageMultiplier then
		self.DamagePerTick = self.DamagePerTick * data.Inflictor.BurnDamageMultiplier
	end
	
	self.RemainingDamage = self.DamagePerTick * math.floor(self.LifeTime / 0.5)
	
	-- Update the inflictor and attacker (kill credit goes to the last player who ignited this entity)
	if NameOverride then
		self.NameOverride = NameOverride
	end
	if IsValid(data.Owner) then
		self:SetOwner(data.Owner)
	end
end

function ENT:Initialize()
	self:SetNoDraw(true)
	self:SetNotSolid(true)
	
	self.LifeTime = self.LifeTime or 10
	if self.Inflictor and self.Inflictor.BurnTimeMultiplier then
		self.LifeTime = self.LifeTime * self.Inflictor.BurnTimeMultiplier
	end
	
	self.DamagePerTick = DamagePerTick
	if self.Inflictor and self.Inflictor.BurnDamageMultiplier then
		self.DamagePerTick = self.DamagePerTick * self.Inflictor.BurnDamageMultiplier
	end
	
	
	if IsValid(self.Target) then
		self:SetPos(self.Target:GetPos())
		self:SetParent(self.Target)
	else
		self.Target = self:GetParent()
	end
	
	if IsValid(self.Inflictor) then
		self.NameOverride = self:GetInflictorName(self.Inflictor)
		self.Attributes = self.Inflictor.Attributes
	end
	
	if IsValid(self.Target) then
		-- If the entity is already on fire
		if IsValid(self.Target.FireEntity) then
			-- Extend the life time
			self.Target.FireEntity.RemainingDamage = self.DamagePerTick * math.floor(self.LifeTime / DamagePeriod)
			
			-- Update the inflictor and attacker (kill credit goes to the last player who ignited this entity)
			if self.NameOverride then
				self.Target.FireEntity.NameOverride = self.NameOverride
			end
			if IsValid(self:GetOwner()) then
				self.Target.FireEntity:SetOwner(self:GetOwner())
			end
			
			self:Remove()
			return
		else
			if (self.Target:IsTFPlayer()) then
				self.Target:AddPlayerState(PLAYERSTATE_ONFIRE, true)
			end
			if not self:TargetIsFireproof() then
				--self.Target:SetNWBool("ShouldDropBurningRagdoll", true)
				self.Target:AddDeathFlag(DF_FIRE)
			end
			if self.Target:IsPlayer() and !self.Target:IsMiniBoss() then
				--self.Target:Speak("TLK_ONFIRE")
			end
			
			--print("ignite",self.Target)
			self.Target.FireEntity = self
			self.RemainingDamage = self.DamagePerTick * math.floor(self.LifeTime / DamagePeriod)
		end
	end
	
	if self.Target:IsNPC() then
		self:EmitSound("General.BurningFlesh")
	else
		self:EmitSound("General.BurningObject")
	end
	self.NextBurn = CurTime() + 0.5  
	NextBurn = CurTime() + 0.5
end

function ENT:Think()
	if not IsValid(self) or not IsValid(self.Target) then return false end
	if (self.Target:IsPlayer() and self.Target:IsL4D()) then
		self.Target:Ignite(10,70)
	end
	if (self:ShouldExtinguishInWater() and self.Target:WaterLevel()>2) or self.RemainingDamage<=0 or self:TargetIsFireproof() then
		self:Remove()
		return
	elseif CurTime()>self.NextBurn then
		local dmginfo = DamageInfo()
			if IsValid(self:GetOwner()) then
				dmginfo:SetAttacker(self:GetOwner())
			else
				dmginfo:SetAttacker(self)
			end
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(self.DamagePerTick)
			if self.Target:IsPlayer() then
				dmginfo:SetDamageType(bit.bor(DMG_GENERIC,DMG_DIRECT))
			else
				dmginfo:SetDamageType(bit.bor(DMG_BURN,DMG_DIRECT))
			end
			dmginfo:SetDamagePosition(self.Target:GetPos())
		self.Target:TakeDamageInfo(dmginfo)
		GAMEMODE:AddDamageCooperation(self.Target, dmginfo:GetAttacker(), self.DamagePerTick, ASSIST_FIRE)
		
		self.NextBurn = CurTime() + 0.5
		self.RemainingDamage = self.RemainingDamage - self.DamagePerTick
	end
	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	if self.NextBurn and IsValid(self.Target) then
		self.Target:Extinguish()
		self.Target:RemovePlayerState(PLAYERSTATE_ONFIRE, true)
		if self.Target:Health()>0 then
			--self.Target:SetNWBool("ShouldDropBurningRagdoll", false)
			self.Target:RemoveDeathFlag(DF_FIRE)
		end
		self:EmitSound("General.StopBurning")
	end
end

end
