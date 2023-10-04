
function GM:ShouldCrit(ent, inf, att, hitgroup, dmginfo) 
	-- forced criticals due to attributes
	if ent ~= att then
		local c
		
		if ent:IsPlayer() then
			c = ApplyAttributesFromEntity(ent:GetActiveWeapon(), "crit_received_override", ent, hitgroup, dmginfo)
			if c~=nil then return c end
			
			c = ApplyGlobalAttributesFromPlayer(ent, "crit_received_override", ent, hitgroup, dmginfo)
			if c~=nil then return c end
		end
		
		c = ApplyAttributesFromEntity(inf, "crit_override", ent, hitgroup, dmginfo)
		
		if c~=nil then return c end
	end
	
	-- Calling this hook clientside or with no damage info will only check attributes
	-- With melee weapons, this is useful for predicting if the melee attack will be a crit (although it's not 100% accurate)
	-- For bullet and projectile based weapons, if there is a condition which prevents crits from happening,
	-- (aka if this function returns false) never give the projectile a critical effect (since it won't always actually crit)
	
	-- so we just return nil for default behaviour if there is nothing special with the attributes
	if CLIENT or not dmginfo then return end
	
	-- derp
	if not ent:CanReceiveCrits() then return false end
	if dmginfo:IsDamageType(DMG_ACID) and !string.find(dmginfo:GetAttacker():GetModel(),"spitter") then
		return true
	end
	if dmginfo:GetDamage() == 0 and not inf.ZeroDamageCrits then return false end
	
	if att:IsNPC() then
		if (math.random(1,5) == 1) then
			return true
		else
			return false
		end
	end
	
	-- if the weapon or projectile is critical
	if (inf.Critical and inf:Critical(ent, dmginfo)) or (att.Critical) then
		return true
	end
	
	-- if it's a headshot for any other gun that isn't from TF2 (also jarated NPCs can't do headshots)
	if (not inf.IsTFWeapon and not inf.IsTFBuilding) and dmginfo:IsBulletDamage() and hitgroup == HITGROUP_HEAD then
		if not(att:IsNPC() and att:HasPlayerState(PLAYERSTATE_JARATED)) then
			return true
		end
	end

	return false
end

function GM:ShouldMiniCrit(ent, inf, att, hitgroup, dmginfo)
	-- forced minicrits due to attributes
	if ent ~= att then
		local c
		
		if ent:IsPlayer() then
			c = ApplyAttributesFromEntity(ent:GetActiveWeapon(), "minicrit_received_override", ent, hitgroup, dmginfo)
			if c~=nil then return c end
			
			c = ApplyGlobalAttributesFromPlayer(ent, "minicrit_received_override", ent, hitgroup, dmginfo)
			if c~=nil then return c end
		end
		
		c = ApplyAttributesFromEntity(inf, "minicrit_override", ent, hitgroup, dmginfo)
		
		if c~=nil then return c end
	end
	
	if CLIENT or not dmginfo then return end
	
	if not ent:CanReceiveCrits() then return false end
	
	if dmginfo:GetDamage() == 0 and not inf.ZeroDamageMiniCrits then return false end
	
	if att:IsPlayer() then
		local w = att:GetActiveWeapon()
		if att.CritBoostType == 2 then
			if not att.CritBoostSlotConstraint or (inf.GetItemData and inf:GetItemData().item_slot == att.CritBoostSlotConstraint) then
				return true
			end
		end
	end
	
	if att:IsNPC() then
		local c = att:CallNPCEvent("minicrit_override", ent, hitgroup, dmginfo)
		if c~=nil then return c end
	end
	
	-- if the inflictor decides to mini-crit that entity
	if inf.MiniCrit and inf:MiniCrit(ent, dmginfo) then
		return true
	end
	
	-- if the entity is covered in Jarate
	if ent:HasPlayerState(PLAYERSTATE_JARATED) then
		return true
	end
	-- if the entity is marked for death
	if (ent:HasPlayerState(PLAYERSTATE_MARKED)) then
		return true
	end
end

---------------------------------------------------------------------------------------------------------

if SERVER then

function DispatchCritEffect(ent, inf, att, is_mini_crit)
	-- Where the "critical hit!" effect should appear
	local critpos
	--if dmginfo:IsDamageType(DMG_CLUB) or dmginfo:IsDamageType(DMG_SLASH) or dmginfo:IsDamageType(DMG_DIRECT) then
		--critpos = ent:GetPos()+Vector(0,0,60)
		if ent:IsTFPlayer() then
			critpos = ent:HeadTarget(ent:GetPos())+Vector(0,0,10)
		else
			critpos = ent:GetPos()
		end
	--[[else
		critpos = dmginfo:GetDamagePosition()
	end]]
	
	-- Doing this to prevent crit effects from appearing several times on the same victim
	-- This would happen on weapons that shoot several bullets at once, aka shotguns
	if not inf.CritHits then inf.CritHits = {} end
	if not inf.CritHits[CurTime()] then inf.CritHits[CurTime()] = {} end
	
	-- Cleaning up old data that don't belong to this instant
	for k,_ in pairs(inf.CritHits) do
		if k<CurTime() then inf.CritHits[k] = nil end
	end
	
	if not inf.CritHits[CurTime()][ent] then
		-- Notify the attacker that they scored a crit hit :D
		if att:IsPlayer() then
			if is_mini_crit then
				SendUserMessage("CriticalHitMiniOther", att, critpos)
			else
				SendUserMessage("CriticalHit", att, critpos)
			end
		end
		
		-- Notify the victim that they have been critted in the face D:
		if ent:IsPlayer() and ent.NextSpeak and ent.NextSpeak<CurTime() then
			SendUserMessage("CriticalHitReceived", ent)
		end
		
		-- Also notify all teammates if the hit is a mini crit
		if is_mini_crit then
			local rp = RecipientFilter()
			for _,v in pairs(team.GetPlayers(att:EntityTeam())) do
				rp:AddPlayer(v)
			end
			SendUserMessage("CriticalHitMiniOther", rp, critpos)

		end
	end
	
	inf.CritHits[CurTime()][ent] = true
end

end
