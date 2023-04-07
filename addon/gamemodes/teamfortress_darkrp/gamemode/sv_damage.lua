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
npc_helicopter = true,
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

	if ent:IsPlayer() and (!ent.NextFlinch or CurTime() > ent.NextFlinch) and ent:IsL4D() then
		if (hitgroup == HITGROUP_HEAD) then
			ent:AnimRestartGesture(GESTURE_SLOT_FLINCH, ACT_FLINCH_HEAD, true)
		elseif (hitgroup == HITGROUP_CHEST) then
			ent:AnimRestartGesture(GESTURE_SLOT_FLINCH, ACT_FLINCH_CHEST, true)
		elseif (hitgroup == HITGROUP_STOMACH) then
			ent:AnimRestartGesture(GESTURE_SLOT_FLINCH, ACT_FLINCH_STOMACH, true)
		elseif (hitgroup == HITGROUP_LEFTARM) then
			ent:AnimRestartGesture(GESTURE_SLOT_FLINCH, ACT_FLINCH_LEFTARM, true)
		elseif (hitgroup == HITGROUP_RIGHTARM) then
			ent:AnimRestartGesture(GESTURE_SLOT_FLINCH, ACT_FLINCH_RIGHTARM, true)
		elseif (hitgroup == HITGROUP_LEFTLEG) then
			ent:AnimRestartGesture(GESTURE_SLOT_FLINCH, ACT_FLINCH_LEFTLEG, true)
		elseif (hitgroup == HITGROUP_RIGHTLEG) then
			ent:AnimRestartGesture(GESTURE_SLOT_FLINCH, ACT_FLINCH_RIGHTLEG, true)
		end
		ent.NextFlinch = CurTime() + 0.5
	end
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
	end
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
	if not att:CanDamage(ent) then
		dmginfo:SetDamage(0)
		dmginfo:SetDamageType(DMG_GENERIC)
		return true
	end
	if (ent:IsPlayer() and ent:IsL4D()) then
		if (string.find(ent:GetModel(),"infected") and (dmginfo:IsDamageType(DMG_FALL) or dmginfo:IsDamageType(DMG_ACID))) then
			if (dmginfo:IsDamageType(DMG_FALL)) then
				if (ent:GetPlayerClass() == "tank") then
					ent:EmitSound("HulkZombie.Thud")
				else
					ent:EmitSound("PlayerZombie.Thud")
				end
			end
			dmginfo:SetDamage(0)
			dmginfo:SetDamageType(DMG_GENERIC)
		end
	end

	-- Self damage
	if ent == att then
		dontscaledamage = true
	end

	-- Critical and mini critical hits

	gamemode.Call("PreScaleDamage", ent, hitgroup, dmginfo)
	dmginfo:ScaleDamage(1)
 	local is_normal_damage = true
	-- if the entity can receive crits
	if gamemode.Call("ShouldCrit", ent, inf, att, hitgroup, dmginfo) then
		if att == ent then
			-- Self damage, don't scale the damage, but still notify the player that they critted themselves
			if ent:IsPlayer() and !ent:IsBot() then
				net.Start("CriticalHitRecieved")
				net.Send(att)
			end
			dontscaledamage = true
		else
			-- Modify the damage
			if inf.BaseDamage and inf.CritDamageMultiplier then
				if inf.Explosive then
					-- TF2 explosives inflict 100 damage, this way we have an easy way to manipulate damage falloff
					dmginfo:ScaleDamage(1.5)
				else
					dmginfo:ScaleDamage(1.5)
				end
			else
				dmginfo:ScaleDamage(1.5)
			end

			DispatchCritEffect(ent, inf, att, false)

			is_normal_damage = false
		end

		ent.LastDamageWasCrit = true
	elseif gamemode.Call("ShouldMiniCrit", ent, inf, att, hitgroup, dmginfo) then
		local mul

		if att:IsNPC() then
			-- NPCs do doubled damage against other NPCs and 50% times more damage on players
			if ent:IsPlayer() then
				mul = 1.5
			else
				mul = 2
			end
		else
			mul = 1.35
		end

		-- Modify the damage
		-- (apparently, minicrits don't suffer from damage spread either)
		if inf.BaseDamage and inf.CritDamageMultiplier then
		else
			dmginfo:ScaleDamage(mul)
		end
		
		DispatchCritEffect(ent, inf, att, true)
		is_normal_damage = false
		
		ent.LastDamageWasCrit = true
	end
	
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
						dmginfo:SetDamage(inf.BaseDamage * 0.8)
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
					
					damage = inf:CalculateDamage(owner:GetPos()+Vector(0,0,1))
					
					inf.CalculatedDamage = damage
				else
					damage = inf.BaseDamage or 0
				end
			end
			
			dmginfo:SetDamage(damage)
			
		elseif dmginfo:IsBulletDamage() and (inf:IsWeapon() or inf.IsTFBuilding) then
			if (inf.IsTFWeapon or inf.IsTFBuilding) and inf.CalculateDamage then
				-- Bullet damage inflicted from a TF2 weapon
				local damage = inf:CalculateDamage(dmginfo:GetDamagePosition(), ent)
				
				-- Entities that aren't players or NPCs (such as props) do not process every bullet from a shotgun blast as individual
				-- Instead, they take a single damage info, which is the sum of the damage inflicted by every bullet received
				if not ent:IsTFPlayer() then
					-- that's quite convenient since bullets fired from TF2 weapons initially inflict only 1 damage
				end
				
				dmginfo:SetDamage(damage)
			else
				-- Bullet damage inflicted from another weapon
				
				-- TODO: Simulate damage spread here?
			end
		end
		
		ent.LastDamageWasCrit = false
	end
	
	return true
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
	
	--[[
	if not dmginfo:IsDamageType(DMG_DIRECT) then
		-- make NPCs a bit harder to kill
		dmginfo:ScaleDamage(0.7)
	end]]
	
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
	
	if (string.find(dmginfo:GetAttacker():GetClass(),"tf_weapon")) then
		dmginfo:SetAttacker(dmginfo:GetAttacker().Owner)
	end
	if ent:IsTFPlayer() and ent:Health() <= 0 then 
		return
	end
	
	local v = ent
	if (dmginfo:GetAttacker():IsPlayer() and !dmginfo:GetAttacker():IsHL2() and IsValid(dmginfo:GetAttacker():GetActiveWeapon()) and dmginfo:GetAttacker():GetActiveWeapon():GetItemData().item_name == "#TF_Minigun_Deflector" and string.find(v:GetClass(), "tf_projectile_")) then
		
		v:EmitSound("Halloween.HeadlessBossAxeHitWorld")
		
		local effectdata = EffectData()
			effectdata:SetOrigin(v:GetPos())
			effectdata:SetNormal(Vector(0,0,1))
			effectdata:SetMagnitude(2)
			effectdata:SetScale(1)
			effectdata:SetRadius(5)
		util.Effect("Sparks", effectdata)
		
		v:Remove()
		
	end
	if (ent:IsPlayer() and attacker:EntIndex() != ent:EntIndex()) then
		if (attacker:IsTFPlayer()) then
			if (attacker:EntIndex() != ent:EntIndex()) then
				if ( !attacker:IsFlagSet(FL_NOTARGET) and dmginfo:GetDamage() > 0) then
					if (!attacker:IsFriendly(ent)) then
						ent.TargetEnt = attacker
					else
						if (attacker:IsPlayer() and !(attacker.TargetEnt == ent and ent.TargetEnt == attacker)) then
							if (ent:Team() == TEAM_RED) then
								for k,v in ipairs(ents.FindInSphere(ent:GetPos(),350)) do
									if (v:GetClass() == "monster_barney") then
										v:EmitSound(table.Random({"barney/donthurtem.wav","barney/leavealone.wav"}),75,100,1,CHAN_VOICE)
									elseif (v:GetClass() == "monster_scientist") then
										v:EmitSound(table.Random({"scientist/whatyoudoing.wav","scientist/stopattacking.wav","scientist/youinsane.wav"}),75,100,1,CHAN_VOICE)
									end
								end
							end
							if (math.random(1,3) == 1) then
								ent:Speak("TLK_PLAYER_PAIN")
								timer.Simple(1.5, function()
									ent:Speak("TLK_REQUEST_DUEL")
								end)
							elseif (math.random(1,3) == 2) then
								ent:Speak("TLK_PLAYER_ATTACKER_PAIN")
								timer.Simple(1.5, function()
									ent:Speak("TLK_JARATE_HIT")
								end)
							else
								ent:Speak("TLK_PLAYER_PAIN")
							end
							if (math.random(1,7) == 1 and attacker:IsPlayer() and !attacker:IsBot() and ent:IsBot()) then
								ent:Speak("TLK_DUEL_WAS_ACCEPTED")
								self:TriggerRevenge(ent, attacker)
								ent.victimclass = attacker.playerclass or ""
								attacker:Speak("TLK_JARATE_HIT")
								ent.TargetEnt = attacker
								attacker.TargetEnt = ent
								if (ent:Team() == TEAM_RED) then
									for k,v in ipairs(ents.FindInSphere(ent:GetPos(),350)) do
										if (v:GetClass() == "monster_barney") then
											v:EmitSound(table.Random({"barney/ba_stepoff.wav","barney/ba_uwish.wav","barney/ba_iwish.wav","barney/ba_somuch.wav","barney/ba_endline.wav","barney/ba_dontmake.wav","barney/ba_tomb.wav"}),75,100,1,CHAN_VOICE)
											v.TargetEnt = attacker
											if SERVER then
												v:AddEntityRelationship(attacker,D_HT,99)	
												v:SetEnemy(attacker,true)
											end
										elseif (v:GetClass() == "monster_scientist") then
											v:EmitSound("scientist/sci_fear"..math.random(1,15)..".wav",75,100,1,CHAN_VOICE)
											v.TargetEnt = attacker
											if SERVER then
												v:AddEntityRelationship(attacker,D_FR,99)
												v:SetEnemy(attacker,true)
											end
										end
									end
								end
							end
							dmginfo:SetDamage(dmginfo:GetDamage() * 0.065)
						end
						local name = dmginfo:GetAttacker():GetName()
						MsgAll(name.." attacked "..ent:Nick())
					end
				end
			end
		end
	end
	if (dmginfo:GetAttacker():IsPlayer() and !dmginfo:GetAttacker():IsHL2() and IsValid(dmginfo:GetAttacker():GetActiveWeapon()) and dmginfo:GetAttacker():GetActiveWeapon():GetItemData().model_player == "models/weapons/c_models/c_double_barrel.mdl" and ent:IsOnGround()) then
	
		local dir = dmginfo:GetAttacker():GetAimVector()
		local dir2 = dir:Angle()
		dir2.p = math.Clamp(dir2.p - 45,-90,90)
		dir2 = dir2:Forward()
		
		local pos = dmginfo:GetAttacker():GetShootPos() + 80 * 1.5 * dir
		local reflect
		v:SetGroundEntity(NULL)
		dmginfo:SetDamageForce(dmginfo:GetDamageForce() * 2)
		if (v:IsNPC()) then
			v:SetVelocity(dir2 * 400 + dmginfo:GetDamageForce() * 0.005)
		else
			v:SetLocalVelocity(dir2 * 400 + Vector(0,0,50))
		end
		
		v:SetClassSpeed(v:GetPlayerClassTable().Speed * 0.6)
		timer.Create("ResetStun"..v:EntIndex(), 1, 1, function()
			v:ResetClassSpeed()
		end)
		
	elseif (dmginfo:GetAttacker():IsPlayer() and !dmginfo:GetAttacker():IsHL2() and IsValid(dmginfo:GetAttacker():GetActiveWeapon()) and string.find(dmginfo:GetAttacker():GetActiveWeapon():GetItemData().model_player,"natascha") and v:IsPlayer()) then
	
		v:SetClassSpeed(v:GetPlayerClassTable().Speed * 0.6)
		timer.Create("ResetStun"..v:EntIndex(), 1, 1, function()
			v:ResetClassSpeed()
		end)
		
	elseif (dmginfo:GetAttacker():IsPlayer() and !dmginfo:GetAttacker():IsHL2() and dmginfo:GetAttacker():GetPlayerClass() == "melee_scout_expert" and ent:IsOnGround()) then
	
		local dir = dmginfo:GetAttacker():GetAimVector()
		local dir2 = dir:Angle()
		dir2.p = math.Clamp(dir2.p - 45,-90,90)
		dir2 = dir2:Forward()
		
		local pos = dmginfo:GetAttacker():GetShootPos() + 80 * 1.5 * dir
		local reflect
		v:SetGroundEntity(NULL)
		v:SetGroundEntity(NULL)
		if (v:IsNPC()) then
			v:SetVelocity(dir2 * 400 + dmginfo:GetDamageForce() * 0.005)
		else
			v:SetLocalVelocity(dir2 * 400 + Vector(0,0,50))
		end
	elseif (dmginfo:GetAttacker():IsPlayer() and !dmginfo:GetAttacker():IsHL2() and dmginfo:GetAttacker():GetPlayerClass() == "steelgauntletpusher" and ent:IsOnGround()) then
	
		local dir = dmginfo:GetAttacker():GetAimVector()
		local dir2 = dir:Angle()
		dir2.p = math.Clamp(dir2.p - 45,-90,90)
		dir2 = dir2:Forward()
		
		local pos = dmginfo:GetAttacker():GetShootPos() + 80 * 1.5 * dir
		local reflect
		v:SetGroundEntity(NULL)
		v:SetGroundEntity(NULL)
		if (v:IsNPC()) then
			v:SetVelocity(dir2 * 400 + dmginfo:GetDamageForce() * 0.005)
		else
			v:SetLocalVelocity(dir2 * 400 + Vector(0,0,50))
		end
		dmginfo:ScaleDamage(1.5)
		
	elseif (dmginfo:GetAttacker():IsPlayer() and !dmginfo:GetAttacker():IsHL2() and dmginfo:GetAttacker():GetPlayerClass() == "bowman") then
	
		dmginfo:ScaleDamage(0.5)
		
	elseif (dmginfo:GetAttacker():IsPlayer() and !dmginfo:GetAttacker():IsHL2() and dmginfo:GetAttacker():GetPlayerClass() == "captain_punch") then
	
		dmginfo:ScaleDamage(5)
		
	elseif (dmginfo:GetAttacker():IsPlayer() and !dmginfo:GetAttacker():IsHL2() and dmginfo:GetAttacker():GetPlayerClass() == "superheavyweightchamp") then
	
		dmginfo:ScaleDamage(1.2)
		
	elseif (dmginfo:GetAttacker():IsPlayer() and !dmginfo:GetAttacker():IsHL2() and IsValid(dmginfo:GetAttacker():GetActiveWeapon()) and dmginfo:GetAttacker():GetActiveWeapon():GetItemData().item_name == "#TF_Minigun_Deflector") then
	
		dmginfo:ScaleDamage(1.5)
		
	end
	-- Projectiles such as grenades don't do physical damage
	if inflictor.Explosive and not dmginfo:IsExplosionDamage() then
		dmginfo:SetDamage(0)
		return true
	end
	
	if ent:IsPlayer() and ent:Armor() <= 70 then
		if ent:Armor() != 0 then
			ent:EmitSound("player/resistance_light"..math.random(1,4)..".wav", 90, math.random(90,105))
		end
	end
	if ent:IsPlayer() and ent:Armor() >= 80 then
		ent:EmitSound("player/resistance_medium"..math.random(1,4)..".wav", 90, math.random(90,105))
	end
	if ent:IsPlayer() and ent:Armor() >= 99 then
		ent:EmitSound("player/resistance_medium"..math.random(1,4)..".wav", 90, math.random(90,105))
	end
	
	if ent:IsPlayer() and ent:Armor() >= 180 then
		ent:EmitSound("player/resistance_heavy"..math.random(1,4)..".wav", 90, math.random(90,105))
	end
	
	if ent:IsPlayer() and ent:Armor() >= 200 then
		ent:EmitSound("player/resistance_heavy"..math.random(1,4)..".wav", 90, math.random(90,105))
	end
	if ent:IsPlayer() and ent:Health() <= 50 then
		ent:ConCommand("wos_ls_force_incap")
		if ent:GetPlayerClass() == "coach" then
			ent:EmitSound("player/survivor/voice/coach/incapacitatedinitial0"..math.random(1,3)..".wav", 95)
		end
		if ent:GetPlayerClass() == "bill" then
			ent:EmitSound("player/survivor/voice/namvet/incapacitatedinitial0"..math.random(1,4)..".wav", 95)
		end
	end

	--print("EntityTakeDamage",ent,dmginfo)
	
	-- Some HL2 projectiles seem to keep the original attacker, even though their owner got changed (by Pyro's airblast, for instance)
	-- Fixing this issue by storing the new attacker in a separate variable
	if inflictor.AttackerOverride and attacker~=inflictor.AttackerOverride then
		attacker = inflictor.AttackerOverride
		dmginfo:SetAttacker(attacker)
	end
	--[[
	if attacker:IsPlayer() and ent:Health() >= 1  and ent:IsPlayer() or ent:IsNPC() and !attacker:IsFriendly(ent) and ent.IsReviveMarker != true then
		if (attacker:IsPlayer()) then
			if attacker:GetInfo("tf_dingalingaling_sound") == "hitsound_electro" then
				attacker:EmitSound("ui/"..attacker:GetInfo("tf_dingalingaling_sound")..math.random(1,3)..".wav", 50)
			elseif attacker:IsL4D() then
				attacker:EmitSound("ui/littlereward.wav", 55)
			elseif attacker:GetInfo("tf_dingalingaling_sound") == "hitsound" then 
				attacker:EmitSound("ui/"..attacker:GetInfo("tf_dingalingaling_sound")..".wav", 50)
			elseif attacker:GetInfo("tf_dingalingaling_sound") == "hitsound_menu_note" then 
				attacker:EmitSound("ui/"..attacker:GetInfo("tf_dingalingaling_sound")..math.random(1,9)..".wav", 50)
			elseif attacker:GetInfo("tf_dingalingaling_sound") == "hitsound_percussion" then 
				attacker:EmitSound("ui/"..attacker:GetInfo("tf_dingalingaling_sound")..math.random(1,5)..".wav", 50)
			elseif attacker:GetInfo("tf_dingalingaling_sound") == "hitsound_retro" then 
				attacker:EmitSound("ui/"..attacker:GetInfo("tf_dingalingaling_sound")..math.random(1,5)..".wav", 50)
			elseif attacker:GetInfo("tf_dingalingaling_sound") == "hitsound_vortex" then 
				attacker:EmitSound("ui/"..attacker:GetInfo("tf_dingalingaling_sound")..math.random(1,5)..".wav", 50)
			elseif attacker:GetInfo("tf_dingalingaling_sound") == "hitsound_squasher" then 
				attacker:EmitSound("ui/"..attacker:GetInfo("tf_dingalingaling_sound")..".wav", 50)
			elseif attacker:GetInfo("tf_dingalingaling_sound") == "hitsound_space" then 
				attacker:EmitSound("ui/"..attacker:GetInfo("tf_dingalingaling_sound")..".wav", 50)
			elseif attacker:GetInfo("tf_dingalingaling_sound") == "hitsound_beepo" then 
				attacker:EmitSound("ui/"..attacker:GetInfo("tf_dingalingaling_sound")..".wav", 50)
			end
		end
	end
	]]
	
	--Msg(tostring(ent).." - "..tostring(dmginfo).." > Received damage : "..dmginfo:GetDamage().."  Attacker : "..tostring(attacker).."\n")
	-- No damage from fire, as we are using a custom fire system
	if inflictor:GetClass()=="entityflame" or dmginfo:IsDamageType(DMG_BURN) and ent:IsPlayer() then
		if (string.find(ent:GetModel(),"infected")) then
			ent:Ignite(10,90)
			if ent:IsPlayer() and ent:GetPlayerClass() == "tank" then
				dmginfo:ScaleDamage(math.random(1.8,8))
			else
				dmginfo:ScaleDamage(math.random(1.2,2.3))
			end
		end
		dmginfo:SetDamageType(DMG_GENERIC)
	end
	local ply = ent
	if (ply:IsPlayer() and (!ply.NextSpeak or CurTime() > ply.NextSpeak) and dmginfo:GetDamage() != 0) then
		if (ply:IsL4D() and !dmginfo:IsDamageType(DMG_FALL) and !dmginfo:IsDamageType(DMG_ACID)) then
			if ply:GetPlayerClass() == "boomer" then
				timer.Adjust("VoiceL4d"..ply:EntIndex(), 1.0)
				
				if (string.find(ply:GetModel(),"l4d1")) then
					if (inflictor:GetClass()=="entityflame") then
						ply:EmitSound("L4D1_BoomerZombie.Pain")
					else
						ply:EmitSound("L4D1_BoomerZombie.PainShort")
					end
				else
					if (inflictor:GetClass()=="entityflame") then
						ply:EmitSound("BoomerZombie.Pain")
					else
						ply:EmitSound("BoomerZombie.PainShort")
					end
				end
				if (inflictor:GetClass()=="entityflame") then
					ply.NextSpeak = CurTime() + 0.6
				else
					ply.NextSpeak = CurTime() + 0.8
				end
			end
			if ply:GetPlayerClass() == "spitter" then
				timer.Adjust("VoiceL4d"..ply:EntIndex(), 1.0)
				if (inflictor:GetClass()=="entityflame") then
					ply:EmitSound("SpitterZombie.Pain")
				else
					ply:EmitSound("SpitterZombie.PainShort")
				end
				if (inflictor:GetClass()=="entityflame") then
					ply.NextSpeak = CurTime() + 0.6
				else
					ply.NextSpeak = CurTime() + 0.8
				end
			end
			if ply:GetPlayerClass() == "witch" then
				ply:EmitSound("vj_l4d/witch/voice/pain/witch_pain_"..math.random(1,3)..".wav")
			end
			if ply:GetPlayerClass() == "hunter" then
				timer.Adjust("VoiceL4d"..ply:EntIndex(), 1.0)
				if (inflictor:GetClass()=="entityflame") then
					ply:EmitSound("HunterZombie.Pain")
				else
					ply:EmitSound("HunterZombie.PainShort")
				end
				if (inflictor:GetClass()=="entityflame") then
					ply.NextSpeak = CurTime() + 0.6
				else
					ply.NextSpeak = CurTime() + 0.8
				end
			end 
			if ply:GetPlayerClass() == "jockey" then
				timer.Adjust("VoiceL4d"..ply:EntIndex(), 1.0)
				ply:EmitSound("JockeyZombie.Pain")
				if (inflictor:GetClass()=="entityflame") then
					ply.NextSpeak = CurTime() + 0.6
				else
					ply.NextSpeak = CurTime() + 0.8
				end
			end 
			if ply:GetPlayerClass() == "smoker" then
				timer.Adjust("VoiceL4d"..ply:EntIndex(), 1.0)
				if (inflictor:GetClass()=="entityflame") then
					ply:EmitSound("SmokerZombie.Pain")
				else
					ply:EmitSound("SmokerZombie.PainShort")
				end
				if (inflictor:GetClass()=="entityflame") then
					ply.NextSpeak = CurTime() + 0.6
				else
					ply.NextSpeak = CurTime() + 0.8
				end
			end 
			if ply:GetPlayerClass() == "tank" then
				timer.Adjust("VoiceL4d"..ply:EntIndex(), 1.0)
				dmginfo:SetDamageForce(Vector(0,0,0))
				if (string.find(ply:GetModel(),"l4d1")) then
					ply:EmitSound("L4D1_HulkZombie.Pain")
				else
					ply:EmitSound("HulkZombie.Pain")
				end
				if (inflictor:GetClass()=="entityflame") then
					ply.NextSpeak = CurTime() + 0.6
				else
					ply.NextSpeak = CurTime() + 0.8
				end
			end
			if ply:GetPlayerClass() == "charger" then
				timer.Adjust("VoiceL4d"..ply:EntIndex(), 1.0)
				ply:EmitSound("ChargerZombie.Pain")
				if (inflictor:GetClass()=="entityflame") then
					ply.NextSpeak = CurTime() + 0.6
				else
					ply.NextSpeak = CurTime() + 0.8
				end
			end
		end
	end
	-- Friendly fire
	local t1, t2 = attacker:EntityTeam(), ent:EntityTeam()
	if attacker~=ent and attacker:IsTFPlayer() and (t1==TEAM_RED or t1==TEAM_BLU or t1==TF_TEAM_PVE_INVADERS or t1==TEAM_INFECTED) and t1==t2 and !GetConVar("mp_friendlyfire"):GetBool() then
		dmginfo:SetDamage(0)
		dmginfo:SetDamageType(DMG_GENERIC)
		return true
	end
	
	-- Quickfix for bullet damage mysteriously gaining DMG_ALWAYSGIB flag
	if dmginfo:GetDamageType() == bit.bor(DMG_BULLET,DMG_ALWAYSGIB) then
		dmginfo:SetDamageType(DMG_BULLET)
	end
	
	if dmginfo:GetDamage()==0 then return end

	if ent:IsPlayer() then
		--print("EntityTakeDamage", ent, dmginfo)
		for _,chgr in ipairs(ents.FindInSphere(ent:GetPos(), 90)) do
			if (chgr:IsPlayer() and chgr:GetPlayerClass() == "charger") then
				if (IsValid(ent.RagdollEntity) and ent:Alive()) then
					ent = chgr
					chgr:TakeDamageInfo(dmginfo)
				end
			end
		end
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
	
	if ent:IsTFPlayer() then
		-- Increased bullet force
		if dmginfo:IsBulletDamage() and (ent:IsPlayer()) then
			if (ent:IsL4D()) then
				dmginfo:SetDamageForce(dmginfo:GetDamageForce() * 0.01)
			else
				dmginfo:SetDamageForce(dmginfo:GetDamageForce() * BulletForceMultiplier)
			end
		elseif dmginfo:IsBulletDamage() and (!ent:IsPlayer()) then
			dmginfo:SetDamageForce(dmginfo:GetDamageForce() * BulletForceMultiplier)
		end
		
		-- Overexaggerated explosion force
		if (ent:IsNPC() or ent:IsPlayer()) and ent:ShouldReceiveDamageForce() and dmginfo:IsExplosionDamage() and !ent:IsL4D()  then
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
	
	if dmginfo:GetDamage()<1 then
		return
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
	ent:Speak("TLK_PLAYER_EXPRESSION", true)
	if ((attacker:IsTFPlayer()) and (string.find(attacker:GetModel(), "infected") or (string.find(attacker:GetModel(), "cpthazama/l4d") and !string.find(attacker:GetModel(), "common")))) then
		if (string.find(attacker:GetModel(), "spitter") and dmginfo:IsDamageType(DMG_ACID)) then
			ent:EmitSound("PlayerZombie.AttackHit")
		end
		if (string.find(attacker:GetModel(), "hulk") and ent:IsHL2()) then
			ent:EmitSound("PlayerZombie.AttackHit")
			if (ent:Alive()) then
				local ply = ent
				if (!IsValid(ply.RagdollEntity2)) then
					ent:SetPos(ent:GetPos() + Vector(0,0,30))
					ent:DoAnimationEvent(ACT_MP_SWIM_IDLE)
					ent:SetNoDraw(true)
					local animent = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
					animent:SetModel("models/cpthazama/l4d2/shared/anim_survivor.mdl")
					animent:SetSkin(ply:GetSkin())
					animent:SetPos(ply:GetPos())
					animent:SetAngles(ply:GetAngles())
					animent:SetParent(ply)
					animent:Spawn()
					animent:Activate()
					ent:SetNWBool("Taunting",true)
					ply.RagdollEntity = animent
					animent:SetSolid( SOLID_OBB ) -- This stuff isn't really needed, but just for physics
					animent:PhysicsInit( SOLID_OBB )
					animent:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
					animent:SetSequence( "Idle_Fall_From_TankPunch" )
					animent:SetPlaybackRate( 1 )
					local animent2 = ents.Create( 'prop_dynamic_override' ) -- The entity used for the death animation	
					animent2:SetModel(ply:GetModel())
					animent2:SetSkin(ply:GetSkin())
					animent2:SetPos(ply:GetPos())
					animent2:SetAngles(ply:GetAngles())
					animent2:SetParent(animent)
					animent2:AddEffects(EF_BONEMERGE)
					ply.RagdollEntity2 = animent2
					animent.AutomaticFrameAdvance = true

					function animent:Think() -- This makes the animation work
						self:NextThink( CurTime() )
						return true
					end
					net.Start("ActivateTauntCam")
					net.Send(ply)
					timer.Create("LandedOnGround"..ply:EntIndex(), 0, 0, function()
						if (ply:Health() < 0 ) then
							if (IsValid(animent)) then
								animent:Remove()
							end
							if (IsValid(animent2)) then
								animent2:Remove()
							end
							net.Start("DeActivateTauntCam")
							net.Send(ply)
							ent:SetNoDraw(false)
							ent:SetNWBool("Taunting",false)
						end
						if (ply:IsOnGround()) then

							animent:SetSequence( "GetUpFrom_TankPunch" )
							timer.Simple(animent:SequenceDuration(animent:LookupSequence("GetUpFrom_TankPunch")), function()
								if (IsValid(animent)) then
									animent:Remove()
								end
								if (IsValid(animent2)) then
									animent2:Remove()
								end
								net.Start("DeActivateTauntCam")
								net.Send(ply)
								ent:SetNoDraw(false)
								ent:SetNWBool("Taunting",false)
							end)
							timer.Stop("LandedOnGround"..ply:EntIndex())
						end
					end)
				end
			end
		end
	end
	if ((attacker:IsTFPlayer()) and (string.find(attacker:GetModel(), "cpthazama/l4d") and string.find(attacker:GetModel(), "common"))) then
		ent:EmitSound("Zombie.Punch")
		ent:SetVelocity(Vector(0,0,0))
	end
	if inflictor:GetClass()=="tf_entityflame" then
		ent:Speak("TLK_ONFIRE")
	end
	
	if not ent.NextFlinch or CurTime() > ent.NextFlinch and !ent:IsL4D() then
		ent:DoAnimationEvent(ACT_MP_GESTURE_FLINCH_CHEST, true)
		ent.NextFlinch = CurTime() + 0.5
	end
	
	if hp<=0 then
		--ent.LastDamageInfo = CopyDamageInfo(dmginfo)
	elseif not dmginfo:IsFallDamage() and not dmginfo:IsDamageType(DMG_DIRECT) then
		if ent:Health() <= ent:GetMaxHealth() * 0.5 or ent == attacker then
			if ent:HasGodMode() == false and !ent.IsDrowning then
				ent:Speak("TLK_PLAYER_PAIN")
			elseif (ent:HasGodMode() and !ent.IsDrowning) then
				if ent:GetPlayerClass() == "scout" then
					ent:EmitSound("Scout.BeingShotInvincible"..math.random(10,36))
				end
				ent:Speak("TLK_PLAYER_ATTACKER_PAIN")
			end
		else
			if ent:HasGodMode() == false and !ent.IsDrowning then
				ent:Speak("TLK_PLAYER_PAIN")
			elseif (ent:HasGodMode() and !ent.IsDrowning) then
				if ent:GetPlayerClass() == "scout" then
					ent:EmitSound("Scout.BeingShotInvincible"..math.random(10,36))
				end
				ent:Speak("TLK_PLAYER_PAIN")
			end
		end

		umsg.Start("PushDamageIndicator", ent)
			umsg.Vector(dmginfo:GetDamagePosition()-ent:GetPos())
			umsg.Float(dmginfo:GetDamage())
		umsg.End()
	elseif dmginfo:IsFallDamage() then 
		if ent:GetPlayerClass() == "fastzombie" then
			dmginfo:SetDamage( 0 )
		end
		ent:Speak("TLK_PLAYER_ATTACKER_PAIN")
	end
	if ent:IsPlayer() and ent:GetPlayerClass() == "l4d_zombie" then
		ent:EmitSound("vj_l4d_com/gore/bullets/bullet_impact_0"..math.random(1,8)..".wav")
	end
	
	
				if ent:IsPlayer() and  ent:GetPlayerClass() == "zombie" then
					ent:EmitSound("Zombie.Pain")
				end
				if ent:IsPlayer() and  ent:GetPlayerClass() == "poisonzombie" then
					ent:EmitSound("NPC_PoisonZombie.Pain")
				end
				if ent:IsPlayer() and  ent:GetPlayerClass() == "zombine" then
					ent:EmitSound("Zombine.Pain")
				end
				if ent:IsPlayer() and  ent:GetPlayerClass() == "fastzombie" then
					ent:EmitSound("NPC_FastZombie.Pain")
				end
end

--------------------------------------------------------------
-- Fire

function GM:IgniteEntity(ent, inf, att, dur)
	local fl
	if (ent:IsPlayer() and ent:IsL4D()) then
		ent:Ignite(10,70)
	else
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
			ent:SetNWInt("BurnLevel", 0.5)
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
