ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

if CLIENT then

function ENT:Draw()
end

end

if SERVER then

AddCSLuaFile( "shared.lua" )

local DamagePeriod = 0.5
local DamagePerTick = 2

function ENT:GetInflictorName(inf)
	--[[if inf.GetItemData then
		local d = inf:GetItemData()
		if d.item_iconname then
			return "tf_weapon_"..d.item_iconname
		end
	end
	
	return inf:GetClass()]]
	
	return nil
end

function ENT:Update(data)
	local NameOverride
	if IsValid(data.Inflictor) then
		NameOverride = self:GetInflictorName(data.Inflictor)
		--self.Attributes = data.Inflictor.Attributes
	end

	-- Extend the life time
	data.LifeTime = data.LifeTime or 8
	self.RemainingDamage = DamagePerTick * (math.floor(data.LifeTime / DamagePeriod) + 1)
	
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
	
	self.LifeTime = self.LifeTime or 8
	
	if IsValid(self.Target) then
		self:SetPos(self.Target:GetPos())
		self:SetParent(self.Target)
	else
		self.Target = self:GetParent()
	end
	
	if IsValid(self.Inflictor) then
		self.NameOverride = self:GetInflictorName(self.Inflictor)
		--self.Attributes = self.Inflictor.Attributes
	end
	
	if IsValid(self.Target) then
		-- If the entity is already bleeding
		if IsValid(self.Target.BleedEntity) then
			-- Extend the life time
			self.Target.BleedEntity.RemainingDamage = DamagePerTick * (math.floor(self.LifeTime / DamagePeriod) + 1)
			
			-- Update the inflictor and attacker
			if self.NameOverride then
				self.Target.BleedEntity.NameOverride = self.NameOverride
			end
			if IsValid(self:GetOwner()) then
				self.Target.BleedEntity:SetOwner(self:GetOwner())
			end
			
			self:Remove()
			return
		else
			self.Target:AddPlayerState(PLAYERSTATE_BLEEDING, false)
			self.Target.BleedEntity = self
			self.RemainingDamage = DamagePerTick * (math.floor(self.LifeTime / DamagePeriod) + 1)
		end
	end
	
	self.NextBleed = CurTime() + 0.5
end

function ENT:Think()
	if not IsValid(self) or not IsValid(self.Target) then return false end

	if self.RemainingDamage<=0 or self.Target:Health()<=0 then
		self:Remove()
		return
	elseif CurTime()>self.NextBleed then
		local dmginfo = DamageInfo()
			if IsValid(self:GetOwner()) then
				dmginfo:SetAttacker(self:GetOwner())
			else
				dmginfo:SetAttacker(self)
			end
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(DamagePerTick)
			dmginfo:SetDamageType(bit.bor(DMG_POISON,DMG_GENERIC))
			dmginfo:SetDamagePosition(self.Target:GetPos())
		self.Target:TakeDamageInfo(dmginfo)
		self.NextBleed = CurTime() + DamagePeriod
		self.RemainingDamage = self.RemainingDamage - DamagePerTick
	end
	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	self.Target:RemovePlayerState(PLAYERSTATE_BLEEDING, false)
end

end
