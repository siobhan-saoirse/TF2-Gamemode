local BlastForceMultiplier = 16
local BlastForceToVelocityMultiplier = (0.015 / BlastForceMultiplier)

local BulletForceMultiplier = 3

local ForceScaleDamageEntityClasses = {
tf_flame = true,
tf_entityflame = true,
tf_entitybleed = true,
npc_grenade_frag = true,
rpg_missile = true,
tf_projectile_rocket = true,
grenade_spit = true,
obj_sentrygun = true,
obj_dispenser = true,
}
local ForceDamageClasses = {
npc_combinegunship = true,
npc_helcopter = true,
}

--[[
function GM:OnPlayerHitGround(pl, inWater, onFloater, speed)
	if speed>580 and not inWater and not onFloater then
		local dmg = self:GetFallDamage(pl, speed)
		pl:ViewPunch(Angle())
	end
	return true
end]]

local mp_falldamage = GetConVar("mp_falldamage")

-- No ear ringing sound when damaged by explosion
function GM:OnDamagedByExplosion(pl, dmginfo)
end

function GM:GetFallDamage(pl, sp)
	if mp_falldamage:GetBool() then
		if sp <= 550 then return 0 end

		return math.sqrt(sp-550)*3.47
	else
		return 10
	end
end

function GM:PreScaleDamage(ent, hitgroup, dmginfo)
	local inf, att = dmginfo:GetInflictor(), dmginfo:GetAttacker()

	ApplyAttributesFromEntity(dmginfo:GetInflictor(), "pre_damage", ent, hitgroup, dmginfo)

	if att:IsPlayer() then
		ApplyGlobalAttributesFromPlayer(att, "pre_damage", ent, hitgroup, dmginfo)
	end

	if ent:IsPlayer() then
		ApplyAttributesFromEntity(ent:GetActiveWeapon(), "pre_damage_received", ent, hitgroup, dmginfo)
		ApplyGlobalAttributesFromPlayer(ent, "pre_damage_received", ent, hitgroup, dmginfo)
	end

	if att:IsNPC() then
		att:CallNPCEvent("pre_damage", ent, hitgroup, dmginfo)
	end

	-- Used for recalculating custom damage falloff
	-- (especially for the Direct Hit which does not do enough damage due to its poor blast radius)
	--[[if inf.ModifyInitialDamage then
		dmginfo:SetDamage(inf:ModifyInitialDamage(ent, dmginfo))
	end]]
	--[[
	if dmginfo:GetAttacker() ~= ent and inf.ExplosionRadiusMultiplier and inf.ExplosionRadiusMultiplier < 1 then
		local frac = dmginfo:GetDamage() * 0.01
		local saturate = 1 / inf.ExplosionRadiusMultiplier
		local range_reduce = 1 - inf.ExplosionRadiusMultiplier

		frac = math.Clamp(saturate * (frac - range_reduce) / (1 - range_reduce), 0, 1)

		if frac * 100 < 1 then
			dmginfo:SetDamage(0)
		else
			dmginfo:SetDamage(frac * 100)
		end
	end]]
end

function GM:PostScaleDamage(ent, hitgroup, dmginfo)
	local att = dmginfo:GetAttacker()

	ApplyAttributesFromEntity(dmginfo:GetInflictor(), "post_damage", ent, hitgroup, dmginfo)

	if att:IsPlayer() then
		ApplyGlobalAttributesFromPlayer(att, "post_damage", ent, hitgroup, dmginfo)
	end

	if ent:IsPlayer() then
		ApplyAttributesFromEntity(ent:GetActiveWeapon(), "post_damage_received", ent, hitgroup, dmginfo)
		ApplyGlobalAttributesFromPlayer(ent, "post_damage_received", ent, hitgroup, dmginfo)
	end

	if att:IsNPC() then
		att:CallNPCEvent("post_damage", ent, hitgroup, dmginfo)
	end

	if dmginfo:GetDamage() > 0 and ent:IsTFPlayer() and not ent:IsBuilding()
	and att:IsTFPlayer() and not att:IsBuilding() and ent:HasPlayerState(PLAYERSTATE_MILK) then
		GAMEMODE:HealPlayer(nil, att, dmginfo:GetDamage() * 0.75, true, false)
	end
end

--------------------------------------------------------------
-- TF2 damage system (takes care of damage spread
-- for TF2 bullets, special damage effects (jarate) and crits)

function GM:CommonScaleDamage(ent, hitgroup, dmginfo)
	if ent:IsTFPlayer() and ent:Health() <= 0 then
		return
	end

	--ent.DoneScaleDamage = true

	local dontscaledamage = false

	local att, inf = dmginfo:GetAttacker(), dmginfo:GetInflictor()

	-- HL2 guns and melee weapons use the owner as the inflictor, get the real inflictor by retrieving the owner's current weapon
	if inf == att and att:IsPlayer() then
		inf = att:GetActiveWeapon()
	end

	-- Damage from fire produces this annoying burn pain sound that we don't want
	-- Just turn it into something else
	if dmginfo:IsDamageType(DMG_BURN) and ent:IsPlayer() then
		dmginfo:SetDamageType(bit.band(dmginfo:GetDamageType(), 65535-DMG_BURN))
	end

	-- Projectiles such as grenades don't do physical damage
	if inf.Explosive and not dmginfo:IsExplosionDamage() then
		dmginfo:SetDamage(0)
		return true
	end

	-- For projectiles or weapons that have a special way to deal damage (jarate)
	if inf.DoSpecialDamage then
		inf:DoSpecialDamage(ent, dmginfo)
	end

	-- Friendly fire
	if (!ent:IsL4D() and !att:IsL4D()) then
		if not att:CanDamage(ent) then
			dmginfo:SetDamage(0)
			dmginfo:SetDamageType(DMG_GENERIC)
			return
		end
	end

	-- Self damage
	if ent == att then
		dontscaledamage = true
	else
		dontscaledamage = true
	end

	-- Critical and mini critical hits
	if (string.find(att:GetClass(),"tf_weapon")) then
		if (IsValid(att:GetOwner())) then
			dmginfo:SetAttacker(att:GetOwner())
		end
	end
	gamemode.Call("PreScaleDamage", ent, hitgroup, dmginfo)

	local is_normal_damage = true
	if (ent.TFBot and ent:EntIndex() != att:EntIndex() and att:IsTFPlayer() and !att:IsFriendly(ent)) then
		ent.TargetEnt = att
		for k,v in ipairs(ents.FindInSphere(ent:GetPos(),1200)) do
			if (v:IsTFPlayer() and (v:IsFriendly(ent)) and v:EntIndex() != ent:EntIndex()) then
				if (math.random(1,5) == 1 and v:Health() > 0) then
					if (v:IsPlayer()) then
						if (ent:IsBot()) then
							local args = {"TLK_PLAYER_HELP"}
							if (!string.find(v:GetModel(),"/bot_")) then
								if ent:Speak(args[1]) then
									ent:DoAnimationEvent(ACT_MP_GESTURE_VC_HANDMOUTH, true)
							
									umsg.Start("TFPlayerVoice")
										umsg.Entity(ent)
										umsg.String(args[1])
									umsg.End()
								end
							end 
						end
						if (v:IsBot()) then
							if (math.random(1,5) == 1 and !string.find(v:GetModel(),"/bot_")) then
								local args = {"TLK_PLAYER_BATTLECRY"}
								if v:Speak(args[1]) then
									v:DoAnimationEvent(ACT_MP_GESTURE_VC_FISTPUMP, true)
							
									umsg.Start("TFPlayerVoice")
										umsg.Entity(v)
										umsg.String(args[1])
									umsg.End()
								end
							end
							v.TargetEnt = att
						end
					elseif (v:IsNPC()) then
						v:SetEnemy(att)
					end
				end
			end
		end
	end
	if (ent.TFBot and ent:EntIndex() != att:EntIndex() and att:IsTFPlayer() and !att:IsFriendly(ent)) then
		for k,v in ipairs(ents.FindInSphere(ent:GetPos(),1200)) do
			if (v:IsTFPlayer() and (v:IsFriendly(ent)) and v:EntIndex() != ent:EntIndex()) then
				if (math.random(1,3) == 1 and !att:IsPlayer() and ent.TFBot and (!IsValid(ent.TargetEnt) or ent.TargetEnt:EntIndex() != att:EntIndex())) then
					ent.TargetEnt = att
					local args = {"TLK_PLAYER_BATTLECRY"}
					if ent:Speak(args[1]) and !string.find(v:GetModel(),"/bot_") then
						ent:DoAnimationEvent(ACT_MP_GESTURE_VC_FISTPUMP, true)
				
						umsg.Start("TFPlayerVoice")
							umsg.Entity(ent)
							umsg.String(args[1])
						umsg.End()
					end
				end
				if (math.random(1,5) == 1 and v:Health() > 0) then
					if (v:IsPlayer()) then
						if (ent:IsBot()) then
							local args = {"TLK_PLAYER_HELP"}
							if ent:Speak(args[1])  and !string.find(v:GetModel(),"/bot_") then
								ent:DoAnimationEvent(ACT_MP_GESTURE_VC_HANDMOUTH, true)
						
								umsg.Start("TFPlayerVoice")
									umsg.Entity(ent)
									umsg.String(args[1])
								umsg.End()
							end
						end
						if (v:IsBot()) then
							if (math.random(1,5) == 1 and !string.find(v:GetModel(),"/bot_")) then
								local args = {"TLK_PLAYER_BATTLECRY"}
								if v:Speak(args[1]) then
									v:DoAnimationEvent(ACT_MP_GESTURE_VC_FISTPUMP, true)
							
									umsg.Start("TFPlayerVoice")
										umsg.Entity(v)
										umsg.String(args[1])
									umsg.End()
								end
							end
							v.TargetEnt = att
						end
					elseif (v:IsNPC()) then
						v:SetEnemy(att)
					end
					ent.TargetEnt = att
				end
			end
		end
	end
	is_normal_damage = true
	-- if the entity can receive crits
	
	if is_normal_damage then
		-- Not a crit, calculate the damage properly here
		
		if inf.Explosive then
			-- Explosive damage
			
			local damage = inf.CalculatedDamage
			
			-- Self damage
			if att==ent then
				if ent:IsPlayer() and inf.BaseDamage then
					if inf.OwnerDamage then
						damage = inf.BaseDamage * inf.OwnerDamage
					else
						dmginfo:SetDamage(inf.BaseDamage)
					end
					dmginfo:SetDamageForce(dmginfo:GetDamageForce() * 2)
				elseif ent.IsTFBuilding then
					damage = 0
					dmginfo:SetDamageForce(vector_origin)
				end
			end
			
			if not damage then
				if inf.CalculateDamage then
					local owner = inf:GetOwner()
					if not owner or not owner:IsValid() then owner = inf end
					
					--damage = inf:CalculateDamage(owner:GetPos()+Vector(0,0,1))
					
					--inf.CalculatedDamage = damage
					damage = inf.BaseDamage or 0
				else
					damage = inf.BaseDamage or 0
				end
			end
			
			--dmginfo:SetDamage(damage)
			dmginfo:SetDamage(inf.BaseDamage)
			
		elseif dmginfo:IsBulletDamage() and (inf:IsWeapon() or inf.IsTFBuilding) then
			if (inf.IsTFWeapon or inf.IsTFBuilding) and inf.CalculateDamage then
				-- Bullet damage inflicted from a TF2 weapon
				local damage = inf:CalculateDamage(dmginfo:GetDamagePosition(), ent)
				
				--dmginfo:SetDamage(damage)
				dmginfo:SetDamage(inf.BaseDamage)
				dontscaledamage = true
			else
				-- Bullet damage inflicted from another weapon
				
				-- TODO: Simulate damage spread here?
			end
		end
		
		ent.LastDamageWasCrit = false
	end
	
	if dmginfo:IsBulletDamage() and (inf.IsTFWeapon or inf.IsTFBuilding) and inf.CalculateDamage then
		dmginfo:SetDamageForce(dmginfo:GetDamageForce() * (dmginfo:GetDamage()) * 0.5)
	end
	
	if (ent:IsPlayer() and ent:IsBot() and string.find(ent:GetModel(),"_boss.mdl")) then
		dmginfo:SetDamageForce(dmginfo:GetDamageForce() * 0.3)
	end

	return dontscaledamage
end

function GM:ScalePlayerDamage(pl, hitgroup, dmginfo)
	local dontscaledamage = self:CommonScaleDamage(pl, hitgroup, dmginfo)
	
	--if not dontscaledamage then
		 -- players seem to receive doubled damage from other players, so we'll just fix this
		--dmginfo:ScaleDamage(0.5)
	--end
	
	--Msg(tostring(pl).." - "..tostring(dmginfo).." > Calculated damage : "..dmginfo:GetDamage().."  Attacker : "..tostring(dmginfo:GetAttacker()).."\n")
	
	--[[
	local att = dmginfo:GetAttacker()
	if att:IsPlayer() and att~=pl and dmginfo:GetDamage()>=1 then
		if att:Visible(pl) then
			--Msg("Sent damage notifier ("..dmginfo:GetDamage()..")\n")
			umsg.Start("PushDamageNotifier", att)
				umsg.Float(CurTime())
				umsg.Vector(pl:GetPos() + Vector(0, 0, pl:OBBMaxs().z))
				umsg.Float(dmginfo:GetDamage())
			umsg.End()
		end
	end]]
end

function GM:ScaleNPCDamage(npc, hitgroup, dmginfo)
	self:CommonScaleDamage(npc, hitgroup, dmginfo)
	local att = dmginfo:GetAttacker()
	if (npc:IsNPC() and att:IsPlayer()) then
		if (att:Team() == TEAM_NEUTRAL) then
			npc.HatesNeutral = true
			npc:AddEntityRelationship(att,D_HT,99)
		end
	end
	
	if not dmginfo:IsDamageType(DMG_DIRECT) then
		-- make NPCs a bit harder to kill
		--dmginfo:ScaleDamage(0.7)
	end
	
	--Msg(tostring(npc).." - "..tostring(dmginfo).." > Calculated damage : "..dmginfo:GetDamage().."  Attacker : "..tostring(dmginfo:GetAttacker()).."\n")
	
	--[[
	local att = dmginfo:GetAttacker()
	if npc:IsNPC() and att:IsPlayer() and dmginfo:GetDamage()>=1 then
		if att:Visible(npc) then
			--Msg("Sent damage notifier ("..dmginfo:GetDamage()..")\n")
			umsg.Start("PushDamageNotifier", att)
				umsg.Float(CurTime())
				umsg.Vector(npc:GetPos() + Vector(0, 0, npc:OBBMaxs().z))
				umsg.Float(dmginfo:GetDamage())
			umsg.End()
		end
	end]]
	
	--print("ScaleNPCDamage",npc,dmginfo)
end

function GM:EntityTakeDamage(  ent, dmginfo )

	local inflictor = dmginfo:GetInflictor()
	local attacker = dmginfo:GetAttacker()
	local amount = dmginfo:GetDamage()
	
	-- Friendly fire
	if (!attacker:IsL4D() and !ent:IsL4D()) then
		if attacker~=ent and attacker:IsTFPlayer() and attacker:IsFriendly(ent) and !GetConVar("mp_friendlyfire"):GetBool() then
			dmginfo:SetDamageType(DMG_GENERIC)
			dmginfo:SetDamage(0)
			if (ent:IsPlayer()) then
				ent:SetBloodColor(DONT_BLEED)
			end
			return
		else
			if (ent:IsPlayer()) then
				ent:SetBloodColor(BLOOD_COLOR_RED)
			end
		end
	end

	if (ent:IsPlayer() and ent:GetInfoNum("tf_robot",0) != 1) then
		ent:SetBloodColor(BLOOD_COLOR_RED)
	elseif (ent:IsPlayer() and ent:GetInfoNum("tf_robot",0) == 1) then
		ent:SetBloodColor(DONT_BLEED)
	end

	if ent:IsTFPlayer() and ent:Health() <= 0 then
		return
	end
	
	-- Projectiles such as grenades don't do physical damage
	if inflictor.Explosive and not dmginfo:IsExplosionDamage() then
		dmginfo:SetDamage(0)
		return true
	end
	--print("EntityTakeDamage",ent,dmginfo)
	
	-- Some HL2 projectiles seem to keep the original attacker, even though their owner got changed (by Pyro's airblast, for instance)
	-- Fixing this issue by storing the new attacker in a separate variable
	if inflictor.AttackerOverride and attacker~=inflictor.AttackerOverride then
		attacker = inflictor.AttackerOverride
		dmginfo:SetAttacker(attacker)
	end
	
	--Msg(tostring(ent).." - "..tostring(dmginfo).." > Received damage : "..dmginfo:GetDamage().."  Attacker : "..tostring(attacker).."\n")
	-- No damage from fire, as we are using a custom fire system
	if (inflictor:GetClass()=="entityflame" and ent:IsNPC()) then
		if (IsValid(ent:GetEnemy())) then
			dmginfo:SetAttacker(ent:GetEnemy())
		end
	elseif inflictor:GetClass()=="entityflame" and ent:IsPlayer() then
		dmginfo:SetDamageType(DMG_GENERIC)
	end
	
	
	-- Quickfix for bullet damage mysteriously gaining DMG_ALWAYSGIB flag
	if dmginfo:GetDamageType() == bit.bor(DMG_BULLET,DMG_ALWAYSGIB) then
		dmginfo:SetDamageType(DMG_BULLET)
	end
	
	if (ent:IsPlayer() and attacker:GetClass() == "infected") then
		ent:EmitSound("Player.HitInternal")
	end
	if ent:IsPlayer() then
		--print("EntityTakeDamage", ent, dmginfo)
		if not ent.DamagePositions then
			--print("-> Manually calling ScalePlayerDamage")
			self:ScalePlayerDamage(ent, 0, dmginfo)
		else
			if ent.ScaleDamageSubstract then
				--print("Substracting "..ent.ScaleDamageSubstract.." from total damage")
				dmginfo:SubtractDamage(ent.ScaleDamageSubstract)
			end
		end
		ent.DamagePositions = nil
	end
	
	if not ent:IsTFPlayer() then
		--print("-> Manually calling ScaleNPCDamage")
		self:ScaleNPCDamage(ent, 0, dmginfo)
	elseif ent:IsNPC() then
		if ForceScaleDamageEntityClasses[inflictor:GetClass()] or ForceDamageClasses[ent:GetClass()] then
			--print("-> Manually calling ScaleNPCDamage")
			self:ScaleNPCDamage(ent, 0, dmginfo)
		end
	end
	
	gamemode.Call("PostScaleDamage", ent, 0, dmginfo)
	
	-- Increased explosion force
	if dmginfo:IsExplosionDamage() then
		dmginfo:SetDamageForce(dmginfo:GetDamageForce() * (inflictor.BlastForceMultiplier or 1) * BlastForceMultiplier)
	end
	if gamemode.Call("ShouldCrit", ent, inflictor, attacker, hitgroup, dmginfo) then
		if att == ent then
			-- Self damage, don't scale the damage, but still notify the player that they critted themselves
			if ent:IsPlayer() and ent.NextSpeak<CurTime() then
				SendUserMessage("CriticalHitReceived", ent)
			end
		else
			-- Modify the damage
			dmginfo:ScaleDamage(3)

			if ent:IsPlayer() and ent.NextSpeak<CurTime() then
				SendUserMessage("CriticalHitReceived", ent)
			end
			DispatchCritEffect(ent, inflictor, attacker, false)
		end

		ent.LastDamageWasCrit = true
	elseif gamemode.Call("ShouldMiniCrit", ent, inflictor, attacker, hitgroup, dmginfo) then
		local mul

		if ent:IsPlayer() and ent.NextSpeak<CurTime() then
			SendUserMessage("CriticalHitReceived", ent)
		end
		
		-- Modify the damage
		-- (apparently, minicrits don't suffer from damage spread either)
		dmginfo:ScaleDamage(1.35)
		
		DispatchCritEffect(ent, inflictor, attacker, true)
		
		ent.LastDamageWasCrit = true
	else
		dmginfo:ScaleDamage(1)
	end
	if ent:IsTFPlayer() then
		-- Increased bullet force
		if dmginfo:IsBulletDamage() then
			--dmginfo:SetDamageForce(dmginfo:GetDamageForce() * BulletForceMultiplier)
		end
		
		-- Overexaggerated explosion force
		if (ent:IsNPC() or ent:IsPlayer()) and ent:ShouldReceiveDamageForce() and dmginfo:IsExplosionDamage() then
			local force = dmginfo:GetDamageForce() * BlastForceToVelocityMultiplier
			
			ent:SetGroundEntity(NULL)
			ent:SetThrownByExplosion(true)
			
			if ent:IsPlayer() and attacker==ent then
				-- Rocket jumping
				if inflictor.GetRocketJumpForce then
					force = inflictor:GetRocketJumpForce(ent, dmginfo)
				else
					local dist = (ent:GetPos() - inflictor:GetPos()):Length()
					local fraction = math.Clamp(dist / 50, 0.3, 2)
					
					force = force * fraction
				end
				
				local vel = ent:GetVelocity() + force
				--MsgN(tostring(vel))
				if vel.z > 100 and vel.z > vel:Length2D() then
					--MsgN("Dispatching rocket jump effect")
					umsg.Start("PlayerRocketJumpEffect")
						umsg.Long(ent:UserID())
					umsg.End()
				end
			end
			
			if ent.ExplosionForceCalcTime ~= CurTime() then
				ent.ExplosionForceCalcTime = CurTime()
				if not ent.ExplosionForceCalc then
					ent.ExplosionForceCalc = Vector()
				end
				ent.ExplosionForceCalc:Zero()
			end
			
			ent.ExplosionForceCalc:Add(force)
			ent:SetVelocity(ent.ExplosionForceCalc)
			
			if ent:IsPlayer() then
				ent:DoAnimationEvent(ACT_MP_AIRWALK, false)
				--ent:DoAnimationEvent(ACT_MP_JUMP_FLOAT, false)
			end
		end
		
		-- Player damaged someone else, add crit percentage bonus
		if attacker:IsPlayer() and ent~=attacker then
			local realdmg = math.Clamp(dmginfo:GetDamage(), 0, ent:Health())
			self:AddTotalDamage(attacker, realdmg)
		end
		
		-- Reset the damage timer for the victim, for the medigun healing ramp
		self:ResetLastDamaged(ent)
		
		-- Cooperations against that victim
		if dmginfo:GetDamage() > 0 and attacker~=ent and not inflictor.NoDamageCooperation and not dmginfo:IsFallDamage() then
			self:AddDamageCooperation(ent, attacker, dmginfo:GetDamage(), ASSIST_NORMAL, nil, {inflictor=inflictor})
		end
		
		-- Force dispatch a blood effect when the entity has been damaged by either fall or direct damage
		if dmginfo:IsFallDamage() or dmginfo:IsDamageType(DMG_DIRECT) then
			ent:DispatchBloodEffect()
		end
		
		-- Store some info regarding damage for death hooks
		ent.LastDamageInfo = CopyDamageInfo(dmginfo)
		ent.LastDamageData = {
			attacker_sequence = attacker:GetSequence(),
		}
	end
	
	-- Combine synths (striders, gunship) normally get hurt only from heavy explosive damage
	-- This adds a health counter that decreases as they take bullet damage, and creates an explosion when it reaches zero (and then restarts again)
	if ent:GetAlternateHealth()>0 and not dmginfo:IsExplosionDamage() then
		local h = ent:GetAlternateHealth()
		if not ent.TempHealth then ent.TempHealth = h end
		ent.TempHealth = ent.TempHealth - dmginfo:GetDamage()
		if ent.TempHealth<=0 then
			util.BlastDamage(inflictor, attacker, dmginfo:GetDamagePosition(), 80, 1000)
			
			local effectdata = EffectData()	
				effectdata:SetOrigin(dmginfo:GetDamagePosition())
			util.Effect("Explosion", effectdata, true, true)
			
			ent.TempHealth = h
		end
	end
	
	if (IsValid(ent:GetOwner()) and IsValid(ent:GetOwner().ShovedAnimation)) then
		ent:GetOwner():TakeDamageInfo(dmginfo)
		dmginfo:ScaleDamage(0)
	end
	if dmginfo:GetDamage()<1 then
		return
	end
	if (ent:IsPlayer() and ent.TFBot and attacker:IsTFPlayer()) then

        ent.ControllerBot.LookAtTime = CurTime() + 2
        ent.ControllerBot.LookAt = ((ent:GetPos() + VectorRand() * 128) - attacker:GetPos()):Angle()

	end
	if ent:IsTFPlayer() and attacker:IsPlayer() and attacker~=ent and dmginfo:GetDamage()>=1 then
		--MsgFN("%s Health = %d", tostring(ent), ent:Health())
		if attacker:Visible(ent) then
			--Msg("Sent damage notifier ("..dmginfo:GetDamage()..")\n")
			umsg.Start("PushDamageNotifier", attacker)
				umsg.Float(CurTime())
				umsg.Vector(ent:HeadTarget(ent:GetPos())+Vector(0,0,10))
				umsg.Float(dmginfo:GetDamage())
			umsg.End()
		end
	end
	
	if not ent:IsPlayer() or not ent:Alive() then return end
	
	-- Pain and death sounds
	local hp = ent:Health() - dmginfo:GetDamage()
	if ent:GetInfoNum("tf_robot",0) != 1 or ent:IsBot() and GetConVar("tf_bots_are_robots"):GetBool() then
	ent:Speak("TLK_PLAYER_EXPRESSION", true)
	if ((inflictor:GetClass()=="tf_entityflame" or inflictor:GetClass()=="entityflame") and math.random(1,3) == 1) then
		ent:Speak("TLK_ONFIRE")
	end
	
	if not ent.NextFlinch or CurTime() > ent.NextFlinch and !ent:IsL4D() then
		ent:DoAnimationEvent(ACT_MP_GESTURE_FLINCH_CHEST, true)
		ent.NextFlinch = CurTime() + 0.5
	end
	if hp<=0 then
		--ent.LastDamageInfo = CopyDamageInfo(dmginfo)
	elseif not dmginfo:IsFallDamage() and not dmginfo:IsDamageType(DMG_DIRECT) and ent:WaterLevel() < 1 then
		if 2*ent:Health()<ent:GetMaxHealth() or ent == attacker then
			if ent:HasGodMode() == false then
				ent:Speak("TLK_PLAYER_ATTACKER_PAIN")
			else
				if ent:GetPlayerClass() == "scout" then
					ent:EmitSound("Scout.BeingShotInvincible"..math.random(10,36))
				end
				ent:EmitSound("tf/weapons/fx/rics/ric"..math.random(1,4)..".wav", 80, math.random(92, 106))
			end
		else
			if ent:HasGodMode() == false then
				ent:Speak("TLK_PLAYER_PAIN")
			else
				if ent:GetPlayerClass() == "scout" then
					ent:EmitSound("Scout.BeingShotInvincible"..math.random(10,36))
				end
				ent:EmitSound("tf/weapons/fx/rics/ric"..math.random(1,4)..".wav", 80, math.random(92, 106), 1, CHAN_BODY)
			end
		end
		
		umsg.Start("PushDamageIndicator", ent)
			umsg.Vector(dmginfo:GetDamagePosition()-ent:GetPos())
			umsg.Float(dmginfo:GetDamage())
		umsg.End()
	elseif dmginfo:IsFallDamage() then 
		ent:Speak("TLK_PLAYER_ATTACKER_PAIN")
	end
	end
end

--------------------------------------------------------------
-- Fire

function GM:IgniteEntity(ent, inf, att, dur)
	local fl
	
	ent:AddFlags(FL_ONFIRE)
	if (ent:IsNPC()) then
		ent:Ignite(dur)
	end
	if IsValid(ent.FireEntity) then
		fl = {}
		fl.Target = ent
		fl.Inflictor = inf
		fl.LifeTime = dur
		fl.Owner = att
		ent.FireEntity:Update(fl)
	else
		fl = ents.Create("tf_entityflame")
		fl.Target = ent
		fl.Inflictor = inf
		fl.LifeTime = dur
		fl:SetOwner(att)
		fl:Spawn()
		fl:Activate()
		
		if not ent:IsTFPlayer() then -- No need to spawn unnecessary entityflames on players
			ent:Fire("ignite","",0.05) -- Ignite it using the classic method, gamemode hooks like the one below will take care of the rest
		end
	end
end

function GM:ExtinguishEntity(ent)
	if IsValid(ent.FireEntity) then
		ent.FireEntity:Remove()
	end
	ent:Extinguish()
end

function GM:EntityStartBleeding(ent, inf, att, dur)
	local fl
	
	if IsValid(ent.BleedEntity) then
		fl = {}
		fl.Target = ent
		fl.Inflictor = inf
		fl.LifeTime = dur
		fl.Owner = att
		ent.BleedEntity:Update(fl)
	else
		fl = ents.Create("tf_entitybleed")
		fl.Target = ent
		fl.Inflictor = inf
		fl.LifeTime = dur
		fl:SetOwner(att)
		fl:Spawn()
		fl:Activate()
	end
end

function GM:EntityStopBleeding(ent)
	if IsValid(ent.BleedEntity) then
		ent.BleedEntity:Remove()
	end
end

-- NPC classes which should keep the default entityflame entity
-- This is useful for tricking zombies into believing they are still on fire
--[[local KeepDefaultEntityflame = {
npc_zombie = true,
npc_zombie_torso = true,
npc_fastzombie = true,
npc_fastzombie_torso = true,
npc_poisonzombie = true,
npc_combine_s = true,
npc_metropolice = true,
}]]

-- Special entities that should never be ignited
local CannotIgnite = {
raggib = true,
}

-- Replacing boring laggy HL2 fire by fancy TF2 fire
hook.Add("OnEntityCreated", "TFDisableHL2Fire", function(ent)
	if IsValid(ent) and ent:GetClass()=="entityflame" then
		local p = ent:GetParent()
		if IsValid(p) then
			if CannotIgnite[p:GetClass()] then
				ent:Remove()
				return
			end
			
			if p:IsNPC() then
				-- Don't kill it, just make it invisible so NPCs like zombies still believe they are on fire
				ent:EmitSound("General.StopBurning")
				ent:AddEffects(EF_NODRAW)
				
				if p:GetClass()=="npc_zombie" then
					-- For some reason, zombies don't immediately perform the "walk on fire" animation, so we'll just do it manually here
					p:SetMovementActivity(ACT_WALK_ON_FIRE)
				end
			else
				ent:Remove()
			end
			
			if not IsValid(ent.FireEntity) then
				local fl = ents.Create("tf_entityflame")
				fl.Target = p
				fl:Spawn()
				fl:Activate()
			end
		end
	end
end)