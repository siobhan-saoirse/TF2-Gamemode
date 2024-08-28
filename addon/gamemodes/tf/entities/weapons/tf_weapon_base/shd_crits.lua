
PrecacheParticleSystem("critgun_weaponmodel_red")
PrecacheParticleSystem("critgun_weaponmodel_blu")

if SERVER then

function SWEP:SetCritBoostEffect(i)
	if self.LastCritBoostEffect==i then return end
	
	umsg.Start("SetCritBoostEffect")
		umsg.Entity(self)
		umsg.Char(i)
	umsg.End()
	
	self.LastCritBoostEffect = i
end

end

function SWEP:RollCritical()
	if self.IsRapidFire then
		if self.Owner:GetNWBool("NextShotIsCritical") and not self.NextCritStop then
			self.NextCritStop = CurTime() + self.CritSpreadDuration
		end
	elseif SERVER then
		GAMEMODE:RollCritical(self.Owner)
	end
	
	return self:Critical()
end

function SWEP:Critical(ent,dmginfo)
	-- If there is an attribute which might prevent crits from happening, don't even make critical effects
	if gamemode.Call("ShouldCrit", NULL, self, self.Owner) == false then
		return false
	end
	
	local force_crit
	if CLIENT or self.CritsOnHeadshot --[[or self.MeleeAttack]] then
		force_crit = self:PredictCriticalHit()
	--[[elseif IsValid(ent) then
		force_crit = self:ShouldOverrideCritical(ent)]]
	end
	
	if force_crit==nil and self.CritTime and CurTime()-self.CritTime<0.01 then
		return self.CurrentShotIsCrit
	end
	
	self.CritTime = CurTime()
	if force_crit == false then
		self.CurrentShotIsCrit = false
		self.NextCritStop = nil
		return false
	elseif force_crit or self.Owner:GetNWBool("NextShotIsCritical") or (self.NextCritStop and CurTime()<=self.NextCritStop) then
		self.CurrentShotIsCrit = true
		return true
	else
		self.CurrentShotIsCrit = false
		self.NextCritStop = nil
		return false
	end
end

function SWEP:CriticalEffect()
	local crit = self:PredictCriticalHit()
	if crit == nil then
		return self:Critical()
	else
		return crit
	end
end

-- Used when critical hits depend on a condition (such as headshots)
function SWEP:PredictCriticalHit()
	if self.CritsOnHeadshot then
		local tr = util.TraceLine{
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + 8000*self.Owner:GetAimVector(),
			filter = self.Owner,
			mask = MASK_SHOT,
		}
		
		if tr.Hit and tr.HitGroup == HITGROUP_HEAD then
			--self.Owner.NextShotIsCritical = true
			--self.Owner:SetNWBool("NextShotIsCritical", true)
			self.NameOverride = self.HeadshotName
			return true
		else
			--self.Owner.NextShotIsCritical = false
			--self.Owner:SetNWBool("NextShotIsCritical", false)
			self.NameOverride = nil
		end
	end
	
	if self.MeleeAttack then
		local tr = self:MeleeAttack(true) -- perform a dummy melee attack (doesn't do any damage)
		return gamemode.Call("ShouldCrit", tr.Entity, self, self.Owner)
		--return self:ShouldOverrideCritical(tr.Entity)
	--[[else
		return self:ShouldOverrideCritical(NULL)]]
	end
end
