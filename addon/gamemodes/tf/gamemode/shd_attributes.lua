local function VALID(e)			return IsValid(e) end
local function ISPLAYER(e)		return VALID(e) and e:IsTFPlayer() end
local function ONFIRE(e)		return VALID(e) and e:HasPlayerState(PLAYERSTATE_ONFIRE) end
local function ISBUILDING(e)	return VALID(e) and (not e:IsTFPlayer() or e:IsBuilding()) end
local function ISSELFDMG(e,d)	return d and d:GetAttacker() == e and not d:GetInflictor().ApplyAttributesOnSelfDamage end

local CURRENT_ENT = NULL
local CURRENT_PLAYER = NULL

function GetAttributeEntity()
	return CURRENT_ENT
end

function GetAttributeOwner()
	return CURRENT_PLAYER
end

local ATTRIBUTES = {
------------------------------------------------------------------------------------
-- Initialisation attributes
-- Apply when the weapon is equipped

["stickybomb_charge_rate"] = {
	equip = function(v,weapon,owner)
		weapon.ChargeTime = weapon.ChargeTime * v
	end,
}, 

["mult_reload_time_hidden"] = {
	equip = function(v,weapon,owner)
		weapon.ReloadTimeMultiplier = v
	end,
},

["mult_reload_time"] = {
	equip = function(v,weapon,owner)
		weapon.ReloadTimeMultiplier = v
	end,
},

["hwn_mult_reload_time"] = {
	equip = function(v,weapon,owner)
		weapon.ReloadTimeMultiplier = v
	end,
},

["charge_turn_control"] = {
	equip = function(v,weapon,owner)
		if (IsValid(owner.TargeEntity)) then
			owner.TargeEntity.ChargeSteerConstraint = owner.TargeEntity.ChargeSteerConstraint * v
		end
	end,
},

["mult_clipsize"] = {
	equip = function(v,weapon,owner)
		weapon.Primary.ClipSize = math.Round(weapon.Primary.ClipSize * v)
		weapon:SetClip1(weapon.Primary.ClipSize)
	end,
},

["mult_postfiredelay"] = {
	equip = function(v,weapon,owner)
		weapon.Primary.Delay = weapon.Primary.Delay * v
		if weapon.HasSecondaryFire then
			weapon.Secondary.Delay = weapon.Secondary.Delay * v
		end
	end,
},
["minigun_no_spin_sounds"] = {
	equip = function(v,weapon,owner)
		weapon.SpecialSound3OLD = weapon.SpecialSound3
		weapon.SpecialSound2OLD = weapon.SpecialSound2
		weapon.SpecialSound3 = weapon.SpecialSound2OLD
		weapon.SpecialSound2 = Sound("")
	end,
},

["mult_crit_chance"] = {
	equip = function(v,weapon,owner)
		weapon.CriticalChance = weapon.CriticalChance * v
	end,
},
	
["mult_maxammo_primary"] = {
	equip = function(v,weapon,owner)
		if SERVER and owner.AmmoMax and owner.AmmoMax[TF_PRIMARY] then
			owner.AmmoMax[TF_PRIMARY] = math.Round(owner.AmmoMax[TF_PRIMARY] * v)
		end
	end,
},

["mult_maxammo_secondary"] = {
	equip = function(v,weapon,owner)
		if SERVER and owner.AmmoMax and owner.AmmoMax[TF_SECONDARY] then
			owner.AmmoMax[TF_SECONDARY] = math.Round(owner.AmmoMax[TF_SECONDARY] * v)
		end
	end,
},

["mult_maxammo_metal"] = {
	equip = function(v,weapon,owner)
		if SERVER and owner.AmmoMax and owner.AmmoMax[TF_METAL] then
			owner.AmmoMax[TF_METAL] = math.Round(owner.AmmoMax[TF_METAL] * v)
		end
	end,
},

["mult_medigun_healrate"] = {
	unimplemented = true,
	equip = function(v,weapon,owner)
		weapon.HealRateMultiplier = (weapon.HealRateMultiplier or 1) * v
	end,
},

["mult_medigun_uberchargerate"] = {
	equip = function(v,weapon,owner)
		weapon.UberchargeRateMultiplier = (weapon.UberchargeRateMultiplier or 1) * v
	end,
},

["mult_medigun_overheal_amount"] = {
	unimplemented = true,
	equip = function(v,weapon,owner)
		weapon.OverhealMultiplier = (weapon.OverhealMultiplier or 1) * v
	end,
},

["mult_medigun_overheal_decay"] = {
	unimplemented = true,
	equip = function(v,weapon,owner)-- NOT IMPLEMENTED
		weapon.OverhealDecayMultiplier = (weapon.OverhealDecayMultiplier or 1) * v
	end,
},

["mult_sniper_charge_per_sec"] = {
	equip = function(v,weapon,owner)
		weapon.SniperChargeRateMultiplier = (weapon.SniperChargeRateMultiplier or 1) * v
	end,
},

["mult_zoom_fov"] = {
	equip = function(v,weapon,owner)
		weapon.ZoomMultiplier = (weapon.ZoomMultiplier or 1) * v
	end,
},

["mult_player_aiming_movespeed"] = {
	equip = function(v,weapon,owner)
		weapon.DeployMoveSpeedMultiplier = (weapon.DeployMoveSpeedMultiplier or 1) * v
	end,
},

["mult_move_speed_when_active"] = {
	equip = function(v,weapon,owner)
		if SERVER then
			weapon.LocalSpeedBoost = (weapon.LocalSpeedBoost or 1) * v
		end
	end,
},

["mult_minigun_spinup_time"] = {
	equip = function(v,weapon,owner)
		weapon.MinigunSpinupMultiplier = (weapon.MinigunSpinupMultiplier or 1) * v
	end,
},

["mult_construction_value"] = {
	equip = function(v,weapon,owner)
		weapon.ConstructRateMultiplier = (weapon.ConstructRateMultiplier or 1) * v
	end,
},

["mult_repair_value"] = {
	unimplemented = true,
	equip = function(v,weapon,owner)-- NOT IMPLEMENTED
		weapon.RepairRateMultiplier = (weapon.RepairRateMultiplier or 1) * v
	end,
},

["mult_spread_scale"] = {
	equip = function(v,weapon,owner)
		weapon.BulletSpread = weapon.BulletSpread * v
	end,
},

["mult_reload_time"] = {
	unimplemented = true,
	equip = function(v,weapon,owner)-- NOT IMPLEMENTED
		weapon.ReloadTime = weapon.ReloadTime * v
	end,
},

["mult_bullets_per_shot"] = {
	equip = function(v,weapon,owner)
		weapon.BulletsPerShot = math.Round(weapon.BulletsPerShot * v)
	end,
},

["mult_cloak_meter_consume_rate"] = {
	unimplemented = true,
	equip = function(v,weapon,owner)-- NOT IMPLEMENTED
		-- todo
	end,
},

["mult_cloak_meter_regen_rate"] = {
	unimplemented = true,
	equip = function(v,weapon,owner)-- NOT IMPLEMENTED
		-- todo
	end,
},

["set_scattergun_no_reload_single"] = {
	boolean = true,
	equip = function() end,
},

["set_scattergun_has_knockback"] = {
	boolean = true,
	equip = function() end,
},

["set_flamethrower_push_disabled"] = {
	boolean = true,
	equip = function(v,weapon,owner)
		weapon.NoAirblast = true
	end,
},

["unimplemented_altfire_disabled"] = {
	boolean = true,
	equip = function(v,weapon,owner)
		weapon.ForceDisableAltFire = true
	end,
},

["unimplemented_mod_zoom_speed_disabled"] = {
	boolean = true,
	equip = function(v,weapon,owner)
		weapon.DisableZoomSpeedPenalty = true
	end,
},

["unimplemented_mod_sniper_no_charge"] = {
	boolean = true,
	equip = function(v,weapon,owner)
		weapon.DisableSniperCharge = true
	end,
},

["wrench_no_upgrades"] = {
	boolean = true,
	equip = function(v,weapon,owner)
		weapon.NoUpgrades = true
	end,
},

["set_charge_type"] = {-- NOT IMPLEMENTED
	unimplemented = true,
	equip = function(v,weapon,owner)
		weapon.UberchargeType = v
	end,
},

["set_buff_type"] = {-- NOT IMPLEMENTED
	unimplemented = true,
	equip = function(v,weapon,owner)
		weapon.BuffType = v
	end,
},

["set_detonate_mode"] = {
	equip = function(v,weapon,owner)
		weapon.DetonateMode = v
	end,
	projectile_fired = function(v,proj,weapon,owner)
		proj.DetonateMode = v
	end,
},

["set_weapon_mode"] = {
	equip = function(v,weapon,owner)
		weapon.WeaponMode = v
	end,
	projectile_fired = function(v,proj,weapon,owner) end,
},

["set_altfire_mode"] = {
	equip = function(v,weapon,owner)
		weapon.AltFireMode = v
	end,
},

["provide_on_active"] = {
	equip = function(v,weapon,owner)
		weapon.OnlyProvideAttributesOnActive = true
	end,
},

["add_maxhealth"] = {
	equip = function(v,weapon,owner)
		if SERVER then
			owner:SetMaxHealth(owner:GetMaxHealth() + v)
		end
	end,
},

["add_max_pipebombs"] = {
	equip = function(v,weapon,owner)
		if SERVER then
			weapon.MaxBombs = (weapon.MaxBombs or 8) + v
		end
	end,
},

["set_scout_doublejump_disabled"] = {
	equip = function(v,weapon,owner)
		owner.TempAttributes.DisableDoubleJump = true
	end,
},

["set_fire_retardant"] = {
	equip = function(v,weapon,owner)
		if SERVER then
			owner.TempAttributes.Fireproof = true
		end
	end,
},

["mult_player_movespeed"] = {
	equip = function(v,weapon,owner)
		if SERVER then
			weapon.SpeedBonus = (weapon.SpeedBonus or 1) * v
			owner:ResetClassSpeed()
		end
	end,
},

["mult_player_movespeed_active"] = {
	equip = function(v,weapon,owner)
		if SERVER then
			weapon.SpeedBonus = (weapon.SpeedBonus or 1) * v
			owner:ResetClassSpeed()
		end
	end,
},

["mult_health_fromhealers"] = {
	equip = function(v,weapon,owner)
		if SERVER then
			owner.TempAttributes.HealthFromHealersMultiplier = (owner.TempAttributes.HealthFromHealersMultiplier or 1) * v
		end
	end,
},

["mult_health_frompacks"] = {
	equip = function(v,weapon,owner)
		if SERVER then
			owner.TempAttributes.HealthFromPacksMultiplier = (owner.TempAttributes.HealthFromPacksMultiplier or 1) * v
		end
	end,
},

["add_health_regen"] = {
	_global_health_regen = function(v,ent,data)
		data.health = data.health + v
	end,
},

["active_item_health_regen"] = {
	health_regen = function(v,ent,data)
		data.health = data.health + v
		if ent:IsPlayer() then
			umsg.Start("PlayerHealthBonus", ent)
				umsg.Short(v)
			umsg.End()
			
			umsg.Start("PlayerHealthBonusEffect")
				umsg.Long(ent:UserID())
				umsg.Bool(v>0)
			umsg.End()
		end
	end,
},

["medic_regen"] = {
	_global_medic_health_regen = function(v,ent,data)
		data.health = data.health * v
	end,
},

["add_player_capturevalue"] = {
	unimplemented = true,
	equip = function(v,weapon,owner)
		if SERVER then
			owner.TempAttributes.CaptureValue = (owner.TempAttributes.CaptureValue or 0) + v
		end
	end,
},

["addperc_ammo_regen"] = {
	_global_ammo_regen = function(v,ent,data)
		local w = GetAttributeEntity()
		if IsValid(w) then
			local pl = w.Owner
			if IsValid(pl) then
				if w.Primary and w.Primary.Ammo and w.Primary.Ammo ~= "none" then
					data[w.Primary.Ammo] = (data[w.Primary.Ammo] or 0) + math.Round(v * pl.AmmoMax[w.Primary.Ammo])
				end
			end
		end
	end,
},

["add_metal_regen"] = {
	_global_ammo_regen = function(v,ent,data)
		data[TF_METAL] = (data[TF_METAL] or 0) + v
	end,
},

["set_attached_particle"] = {
	equip = function(v,weapon,owner)
		if CLIENT then
			weapon.AttachedParticle = tf_items.Particles[v]
		end
	end,
},

["wrench_builds_minisentry"] = {
	equip = function(v,weapon,owner)
		if SERVER then
			owner.TempAttributes.BuildsMiniSentries = true
		end
	end,
},

["pda_builds_minidispenser"] = {
	equip = function(v,weapon,owner)
		if SERVER then
			owner.TempAttributes.BuildsMiniDispensers = true
		end
	end,
},

["add_maxhealth_nonbuffed"] = {
	unimplemented = true,
	equip = function(v,weapon,owner)
		
	end,
},

["set_item_tint_rgb"] = {
	equip = function(v,weapon,owner)
		if SERVER then
			if weapon.SetItemTint then
				weapon:SetItemTint(v)
			else
				local b = (v % 256)
				v = math.floor(v / 256)
				local g = (v % 256)
				v = math.floor(v / 256)
				weapon:SetColor(v, g, b, 255)
			end
		end
	end,
},

["building_cost_reduction"] = {-- NOT IMPLEMENTED
	unimplemented = true,
	equip = function(v,weapon,owner)
		
	end,
},

["set_disguise_on_backstab"] = {-- NOT IMPLEMENTED
	unimplemented = true,
	equip = function(v,weapon,owner)
		
	end,
},

["set_cannot_disguise"] = {-- NOT IMPLEMENTED
	unimplemented = true,
	equip = function(v,weapon,owner)
		
	end,
},

["set_silent_killer"] = {
	equip = function(v,weapon,owner)
		weapon.IsSilentKiller = true
	end,
	
	on_kill = function(v,ent,inf,att)
		ent:AddDeathFlag(DF_SILENCED)
	end,
},

["sanguisuge"] = {
	equip = function(v,weapon,owner)
		weapon.IsSilentKiller = true 
	end,
	
	on_kill = function(v,ent,inf,att) 
		att:SetHealth(att:Health() + ent:GetMaxHealth() * 0.5)
	end,
},

["hit_self_on_miss"] = {
	boolean = true,
	equip = function(v,weapon,owner)
		weapon.MeleeHitSelfOnMiss = true
		weapon.ApplyAttributesOnSelfDamage = true
	end,
},

["mod_charge_time"] = {
	equip = function(v,weapon,owner)
		if SERVER then
			owner.TempAttributes.AdditiveChargeDuration = (owner.TempAttributes.AdditiveChargeDuration or 0) + v
		end
	end,
},

["self_mark_for_death"] = {
	equip = function(v,weapon,owner)
		weapon.MarkForDeath = true
	end,
},

["mult_single_wep_deploy_time"] = {
	equip = function(v,weapon,owner)
		weapon.DeployTimeMultiplier = (weapon.DeployTimeMultiplier or 0.75) * v
	end,
},

["mult_deploy_time"] = {
	equip = function(v,weapon,owner)
		if not owner.TempAttributes then
			owner.TempAttributes = {}
		end
		
		owner.TempAttributes.DeployTimeMultiplier = (owner.TempAttributes.DeployTimeMultiplier or 1) * v
	end,
},

------------------------------------------------------------------------------------
-- Projectile initialisation attributes
-- Apply to a projectile whenever it is fired

["fires_healing_bolts"] = {
	projectile_fired = function(v,proj,weapon,owner)
		proj.IsHealingBolt = true
	end,
},

["mult_explosion_radius"] = {
	equip = function(v,weapon,owner)
		weapon.ExplosionRadiusMultiplier = (weapon.ExplosionRadiusMultiplier or 1) * v
	end,
	projectile_fired = function(v,proj,weapon,owner)
		if proj.Explosive then
			proj.ExplosionRadiusMultiplier = (proj.ExplosionRadiusMultiplier or 1) * v
		end
	end,
},

["mult_projectile_speed"] = {
	equip = function(v,weapon,owner)
		if weapon.Force then weapon.Force = weapon.Force * v end
	end,
	projectile_fired = function(v,proj,weapon,owner)
		if proj.BaseSpeed then proj.BaseSpeed = proj.BaseSpeed * v end
		if proj.Force then proj.Force = proj.Force * v end
	end,
},

["mult_projectile_range"] = {
	projectile_fired = function(v,proj,weapon,owner)
		if proj.HitboxSize then
			proj.HitboxSize = proj.HitboxSize * v
		end
	end,
},

["mult_dmg_falloff"] = {
	unimplemented = true,
	projectile_fired = function(v,proj,weapon,owner) -- NOT IMPLEMENTED
		-- todo
	end,
},

["desc_jarate_description"] = {
	projectile_fired = function(v,proj,weapon,owner)
		if proj:GetClass()~="tf_projectile_jar" then
			local jar = scripted_ents.Get("tf_projectile_jar")
			if not jar then return end
			
			proj.DoSpecialDamage = jar.DoSpecialDamage
			proj.DoExplosion = jar.DoExplosion
			proj.BugbaitTouch = jar.BugbaitTouch
			proj.ActivateBugbaitTargets = jar.ActivateBugbaitTargets
			
			proj.NoSelfDamage = true
			proj.NoMiniCrits = true
			proj.ExplosionSound = "Jar.Explode"
			
			proj.Trail = util.SpriteTrail(proj, 0, Color(200,255,0,200), false,
			0.1, 5, 1, 1/(5+1)*0.5, "Effects/arrowtrail_red.vmt")
		end
	end,
},
["desc_gascan_description"] = {
	projectile_fired = function(v,proj,weapon,owner)
		if proj:GetClass()=="tf_projectile_gas" then
			local jar = scripted_ents.Get("tf_projectile_gas")
			if not jar then return end
			
			proj.DoSpecialDamage = jar.DoSpecialDamage
			proj.DoExplosion = jar.DoExplosion
			proj.BugbaitTouch = jar.BugbaitTouch
			proj.ActivateBugbaitTargets = jar.ActivateBugbaitTargets
			
			proj.NoSelfDamage = true
			proj.NoMiniCrits = true
			proj.ExplosionSound = "weapons/gas_can_explode.wav"
			
			proj.Trail = util.SpriteTrail(proj, 0, Color(200,255,0,200), false,
			0.1, 5, 1, 1/(5+1)*0.5, "Effects/arrowtrail_red.vmt")
		end
	end,
},

["sticky_arm_time"] = {
	projectile_fired = function(v,proj,weapon,owner)
		proj.AdditionalArmTime = (proj.AdditionalArmTime or 0) + v
	end,
},

["set_flamethrower_back_crit"] = {
	boolean = true,
	projectile_fired = function(v,proj,weapon,owner)
		proj.CritsFromBehind = true
	end,
},

["mult_wpn_burndmg"] = {
	projectile_fired = function(v,proj,weapon,owner)
		proj.BurnDamageMultiplier = (proj.BurnDamageMultiplier or 1) * v
	end,
},

["mult_wpn_burntime"] = {
	projectile_fired = function(v,proj,weapon,owner)
		proj.BurnTimeMultiplier = (proj.BurnTimeMultiplier or 1) * v
	end,
},

["have_an_error"] = {
	projectile_fired = function(v,proj,weapon,owner)
		proj.Error = true
	end,
},

------------------------------------------------------------------------------------
-- Crit attributes
-- Give forced critical hit conditions (return true to force a critical hit, false to inhibit critical hits, nil to keep the usual random crits)

["or_crit_vs_playercond"] = {
	boolean = true,
	crit_override = function(v,ent,hitgroup,dmginfo)
		if ISPLAYER(ent) and ONFIRE(ent) and dmginfo:GetInflictor():GetClass() != "entityflame" then return true end
	end,
},

["or_minicrit_vs_playercond_burning"] = {
	boolean = true,
	minicrit_override = function(v,ent,hitgroup,dmginfo)
		if ISPLAYER(ent) and ONFIRE(ent) and dmginfo:GetInflictor():GetClass() != "entityflame" then return true end
	end,
},

["set_nocrit_vs_nonburning"] = {
	boolean = true,
	crit_override = function(v,ent,hitgroup,dmginfo)
		if not(ISPLAYER(ent) and ONFIRE(ent)) then return false end
	end,
},

["mini_crit_airborne"] = {
	boolean = true,
	minicrit_override = function(v,ent,hitgroup,dmginfo)
		if ISPLAYER(ent) and not ent:OnGround() and ent:IsThrownByExplosion() then return true end
	end,
},

["crit_while_airborne"] = {
	boolean = true,
	crit_override = function(v,ent,hitgroup,dmginfo)
		if SERVER then
			local inf, att
			if dmginfo then
				inf, att = dmginfo:GetInflictor(), dmginfo:GetAttacker()
			else
				inf = CURRENT_ENT
				if IsValid(inf) and IsValid(inf.Owner) then
					att = inf.Owner
					print(att:IsThrownByExplosion())
					if ISPLAYER(att) and not att:OnGround() and att:IsThrownByExplosion() then return true end
				end
			end
		end
	end,
},

["minicrits_become_crits"] = {
	boolean = true,
	crit_override = function(v,ent,hitgroup,dmginfo)
		if SERVER then
			local inf, att
			if dmginfo then
				inf, att = dmginfo:GetInflictor(), dmginfo:GetAttacker()
			else
				inf = CURRENT_ENT
				if IsValid(inf) and IsValid(inf.Owner) then
					att = inf.Owner
				end
			end
			
			if gamemode.Call("ShouldMiniCrit", ent, inf, att, hitgroup, dmginfo) then
				return true
			end
		end
	end,
},

------------------------------------------------------------------------------------
-- Damage attributes
-- Modify the amount of damage dealt based on certain conditions, or perform special actions on hit

["mult_dmg"] = {
	post_damage = function(v,ent,hitgroup,dmginfo)
		if not ISSELFDMG(ent,dmginfo) then
			dmginfo:SetDamage(dmginfo:GetDamage() * v)
			dmginfo:SetDamageForce(dmginfo:GetDamageForce() * v)
		end
	end,
},

["mult_dmg_vs_players"] = {
	post_damage = function(v,ent,hitgroup,dmginfo)
		if ISPLAYER(ent) and not ISBUILDING(ent) then
			dmginfo:SetDamage(dmginfo:GetDamage() * v)
		end
	end,
},

["mult_dmg_vs_buildings"] = {
	post_damage = function(v,ent,hitgroup,dmginfo)
		if ISBUILDING(ent) then
			dmginfo:SetDamage(dmginfo:GetDamage() * v)
		end
	end,
},

["mult_dmg_vs_nonburning"] = {
	post_damage = function(v,ent,hitgroup,dmginfo)
		if not ONFIRE(ent) then
			dmginfo:SetDamage(dmginfo:GetDamage() * v)
		end
	end,
},

["speed_boost_on_hit"] = {
	post_damage = function(v,ent,hitgroup,dmginfo)
		if not ISSELFDMG(ent,dmginfo) and ISPLAYER(ent) and ent:Health()>0 and not ISBUILDING(ent) then
			local att = dmginfo:GetAttacker()
			if (!att:HasPlayerState(PLAYERSTATE_SPEED)) then
				dmginfo:GetAttacker():SendLua("LocalPlayer():EmitSound('DisciplineDevice.PowerUp')")
			end
			timer.Stop("Stunned"..att:EntIndex())
			timer.Stop("StunnedStop"..att:EntIndex())
			--att:AddPlayerState(PLAYERSTATE_SPEED,true)
			timer.Create("Stunned"..att:EntIndex(), 0.1, v * 10, function()
				att:SetClassSpeed(att:GetPlayerClassTable().Speed * 1.5)
			end)
			timer.Create("StunnedStop"..att:EntIndex(), v, 1, function()
				timer.Stop("Stunned"..att:EntIndex())
				--att:RemovePlayerState(PLAYERSTATE_SPEED,true)
				att:SendLua("LocalPlayer():EmitSound('DisciplineDevice.PowerDown')")
				att:EmitSound("Building_Speedpad.BoostStop")
				att:ResetClassSpeed()
			end)
		end
	end,
},

["speed_buff_ally"] = {
	pre_damage_ally = function(v,ent,hitgroup,dmginfo)
		local att = dmginfo:GetAttacker()
		if (ent:IsFriendly(att)) then
			if (!att:HasPlayerState(PLAYERSTATE_SPEED)) then
				dmginfo:GetAttacker():SendLua("LocalPlayer():EmitSound('DisciplineDevice.PowerUp')")
			end
			timer.Stop("Stunned"..att:EntIndex())
			timer.Stop("StunnedStop"..att:EntIndex())
			--att:AddPlayerState(PLAYERSTATE_SPEED,true)
			timer.Create("Stunned"..att:EntIndex(), 0.1, v * 40, function()
				att:SetClassSpeed(att:GetPlayerClassTable().Speed * 1.5)
			end)
			timer.Create("StunnedStop"..att:EntIndex(), v + 4, 1, function()
				timer.Stop("Stunned"..att:EntIndex())
				--att:RemovePlayerState(PLAYERSTATE_SPEED,true)
				att:SendLua("LocalPlayer():EmitSound('DisciplineDevice.PowerDown')")
				att:EmitSound("Building_Speedpad.BoostStop")
				att:ResetClassSpeed()
			end)
			if (ent:IsPlayer()) then
				if (!ent:HasPlayerState(PLAYERSTATE_SPEED)) then
					ent:SendLua("LocalPlayer():EmitSound('DisciplineDevice.PowerUp')")
				end
			end
			timer.Stop("Stunned"..ent:EntIndex())
			timer.Stop("StunnedStop"..ent:EntIndex())
			--ent:AddPlayerState(PLAYERSTATE_SPEED,true)
			timer.Create("Stunned"..ent:EntIndex(), 0.1, v * 40, function()
				ent:SetClassSpeed(ent:GetPlayerClassTable().Speed * 1.5)
			end)
			timer.Create("StunnedStop"..ent:EntIndex(), v + 4, 1, function()
				timer.Stop("Stunned"..ent:EntIndex())
				--ent:RemovePlayerState(PLAYERSTATE_SPEED,true)
				if (ent:IsPlayer()) then
					ent:SendLua("LocalPlayer():EmitSound('DisciplineDevice.PowerDown')")
				end
				ent:EmitSound("Building_Speedpad.BoostStop")
				ent:ResetClassSpeed()
			end)
		end
	end,
},

["speed_boost_on_kill"] = {
	on_kill = function(v,ent,inf,att)
		if not ISBUILDING(ent) then
			if (!att:HasPlayerState(PLAYERSTATE_SPEED)) then
				att:SendLua("LocalPlayer():EmitSound('DisciplineDevice.PowerUp')")
			end
			timer.Stop("Stunned"..att:EntIndex())
			timer.Stop("StunnedStop"..att:EntIndex())
			--att:AddPlayerState(PLAYERSTATE_SPEED,true)
			timer.Create("Stunned"..att:EntIndex(), 0.1, v * 10, function()
				--att:SetClassSpeed(att:GetPlayerClassTable().Speed * 1.5)
			end)
			timer.Create("StunnedStop"..att:EntIndex(), v, 1, function()
				timer.Stop("Stunned"..att:EntIndex())
				--att:RemovePlayerState(PLAYERSTATE_SPEED,true)
				att:SendLua("LocalPlayer():EmitSound('DisciplineDevice.PowerDown')")
				att:EmitSound("Building_Speedpad.BoostStop")
				att:ResetClassSpeed()
			end)
		end
	end,
},

["unimplemented_mod_dmg_vs_nonstunned"] = {
	unimplemented = true,
	post_damage = function(v,ent,hitgroup,dmginfo)
		if not ISSELFDMG(ent,dmginfo) and ISPLAYER(ent) and ent:Health()>0 and not ISBUILDING(ent) then
			-- todo
		end
	end,
},

["add_onhit_addhealth"] = {
	post_damage = function(v,ent,hitgroup,dmginfo)
		if not ISSELFDMG(ent,dmginfo) and ISPLAYER(ent) and ent:Health()>0 and not ISBUILDING(ent) then
			dmginfo:GetAttacker():SetHealth(dmginfo:GetAttacker():Health() + v)
		end
	end,
	projectile_fired = function(v,proj,weapon,owner) end,
},

["add_health_on_radius_damage"] = {
	post_damage = function(v,ent,hitgroup,dmginfo)
		if not ISSELFDMG(ent,dmginfo) and ISPLAYER(ent) and ent:Health()>0 and not ISBUILDING(ent) then
			dmginfo:GetAttacker():SetHealth(dmginfo:GetAttacker():Health() + v)
		end
	end,
	projectile_fired = function(v,proj,weapon,owner) end,
},

["add_onhit_ubercharge"] = {
	post_damage = function(v,ent,hitgroup,dmginfo)
		if not ISSELFDMG(ent,dmginfo) and ISPLAYER(ent) and ent:Health()>0 and not ISBUILDING(ent) then
			local att = dmginfo:GetAttacker()
			att:SetNWInt("Ubercharge", math.Clamp(att:GetNWInt("Ubercharge") + math.floor(v * 100),0,100))
		end
	end,
	equip = function(v,weapon,owner)
		if CLIENT then
			if not weapon.CustomHUD then weapon.CustomHUD = {} end
			weapon.CustomHUD.HudMedicCharge = true
		end
	end,
},

["addperc_ondmgdone_tmpbuff"] = {
	post_damage = function(v,ent,hitgroup,dmginfo)
		local inf = dmginfo:GetInflictor()
		local att = dmginfo:GetAttacker()
		
		local buff = 0
		if inf.NextDamageBuffExpire and inf.InitialDamageBuff then
			buff = inf.InitialDamageBuff * math.Clamp((inf.NextDamageBuffExpire - CurTime()) / 5, 0, 1)
		end
		
		if ent~=att then
			dmginfo:ScaleDamage(1+buff)
		end
		
		if ent~=att and ISPLAYER(ent) and ent:Health()>0 and not ISBUILDING(ent) then
			if not inf.LastDamageBuffDone or CurTime() - inf.LastDamageBuffDone > 0.01 then
				inf.DamageBuff = buff + v
				inf.InitialDamageBuff = inf.DamageBuff
				inf.NextDamageBuffExpire = CurTime() + 5
			end
			inf.LastDamageBuffDone = CurTime()
		end
	end,
},

["stickies_detonate_stickies"] = {
	post_damage = function(v,ent,hitgroup,dmginfo)
		if dmginfo:GetAttacker():CanDamage(ent) and dmginfo:GetDamage()>1 then
			if ent:GetClass()=="tf_projectile_pipe_remote" then
				ent:Break()
			elseif ent:GetClass()=="combine_mine" then
				local effectdata
				
				effectdata = EffectData()
				effectdata:SetEntity(ent)
				effectdata:SetOrigin(ent:GetPos())
				effectdata:SetScale(128)
				util.Effect("ThumperDust", effectdata, true, true)
				
				ent:Remove()
			end
		end
	end,
},

["bleeding_duration"] = {
	pre_damage = function(v,ent,hitgroup,dmginfo)
		if ent~=dmginfo:GetAttacker() and ent:CanBleed() then
			--GAMEMODE:EntityStartBleeding(ent, dmginfo:GetInflictor(), dmginfo:GetAttacker(), v)
		end
	end,
},

["jarate_duration"] = {
	post_damage = function(v,ent,hitgroup,dmginfo)
		local inf = dmginfo:GetInflictor()
		if inf:GetClass() == "tf2_weapon_sniperrifle" and inf.ChargeTime then

		end
		
		local att = dmginfo:GetAttacker()
		
		--ent:AddPlayerState(PLAYERSTATE_JARATED, true)
		--timer.Simple(0, function() if IsValid(ent) then ent:AddPlayerState(PLAYERSTATE_JARATED, true) end end)
		
		ent.NextEndJarate = CurTime() + v
		
	end,
	
	equip = function(v,weapon,owner)
		weapon.UsesJarateChargeMeter = true
	end,
},

["no_self_blast_dmg"] = {
	_global_post_damage = function(v,ent,hitgroup,dmginfo)
		if ent == dmginfo:GetAttacker() and dmginfo:IsExplosionDamage() then
			dmginfo:SetDamage(0)
			--dmginfo:SetDamageForce(dmginfo:GetDamageForce() * 1.5)
		end
	end,
},

["rocket_jump_dmg_reduction"] = {
	_global_post_damage = function(v,ent,hitgroup,dmginfo)
		local inf = dmginfo:GetInflictor()
		local att = dmginfo:GetAttacker()
		
		if dmginfo:IsExplosionDamage() then
			if ent == att then
				-- The attacker injured themselves with an explosion
				if not inf.GunboatsDamageData or inf.GunboatsDamageData.time ~= CurTime() then
					inf.GunboatsDamageData = {time = CurTime(), att = att}
				end
				if inf.GunboatsDamageData.hitenemy then
					-- The same explosion also hit an enemy before
					return
				else
					-- Didn't hit anyone else yet, apply the damage reduction
					local absorbed_damage = dmginfo:GetDamage() * (1 - v)
					dmginfo:ScaleDamage(v)
					inf.GunboatsDamageData.absorbeddamage = (inf.GunboatsDamageData.absorbeddamage or 0) + absorbed_damage
				end
			elseif ent:IsTFPlayer() then
				-- The explosion has injured an enemy
				if not inf.GunboatsDamageData or inf.GunboatsDamageData.time ~= CurTime() then
					inf.GunboatsDamageData = {time = CurTime(), att = att}
				end
				inf.GunboatsDamageData.hitenemy = true
				if att == inf.GunboatsDamageData.att and inf.GunboatsDamageData.absorbeddamage then
					-- The explosion injured this enemy after the damage reduction has been applied on the attacker, cancel the damage reduction
					-- by simulating damage taken
					local h = att:Health() - inf.GunboatsDamageData.absorbeddamage
					if h > 0 then
						att:SetHealth(att:Health() - inf.GunboatsDamageData.absorbeddamage)
						umsg.Start("PushDamageIndicator", att)
							umsg.Vector(dmginfo:GetDamagePosition()-att:GetPos())
							umsg.Float(inf.GunboatsDamageData.absorbeddamage)
						umsg.End()
					else
						--MsgN("Dead, simulating damage taken")
						att:SetHealth(0)
						att:TakeDamageInfo(CopyDamageInfo(dmginfo))
					end
					
					inf.GunboatsDamageData.absorbeddamage = 0
				end
			end
		end
	end,
},

["mark_for_death"] = {
	post_damage = function(v,ent,hitgroup,dmginfo)
		local att = dmginfo:GetAttacker()
		if att:IsValidEnemy(ent) then
			--if (!ent:HasPlayerState(PLAYERSTATE_MARKED)) then
				--ent:AddPlayerState(PLAYERSTATE_MARKED, true)
				if (ent:IsPlayer()) then
					if SERVER then
						ent:SendLua('LocalPlayer():GetActiveWeapon():EmitSound("Weapon_Marked_for_Death.Indicator")')
					end
				end
				if CLIENT then
					ent:EmitSound('Weapon_Marked_for_Death.Initial')
				end
			--end
		end
	end,
},

------------------------------------------------------------------------------------
-- Damage received attributes
-- Modify the amount of damage received by the player

["unimplemented_absorb_dmg_while_cloaked"] = {
	unimplemented = true,
	_global_post_damage_received = function(v,pl,hitgroup,dmginfo)
		-- todo
	end,
},

["mult_dmgtaken_from_fire"] = {
	_global_post_damage_received = function(v,pl,hitgroup,dmginfo)
		local inf = dmginfo:GetInflictor()
		if dmginfo:IsDamageType(DMG_BURN) or (IsValid(inf) and inf:GetClass() == "entityflame") then
			dmginfo:ScaleDamage(v)
		end
	end,
},

["mult_dmgtaken_from_crit"] = {
	_global_post_damage_received = function(v,pl,hitgroup,dmginfo)
		if pl.LastDamageWasCrit and pl~=dmginfo:GetAttacker() then
			dmginfo:ScaleDamage(v)
		end
	end,
},

["mult_dmgtaken_from_explosions"] = {
	_global_post_damage_received = function(v,pl,hitgroup,dmginfo)
		if dmginfo:IsDamageType(DMG_BLAST) then
			dmginfo:ScaleDamage(v)
		end
	end,
},

["mult_dmgtaken_from_bullets"] = {
	_global_post_damage_received = function(v,pl,hitgroup,dmginfo)
		if dmginfo:IsDamageType(DMG_BULLET) then
			dmginfo:ScaleDamage(v)
		end
	end,
},

["mult_dmgself_push_force"] = {
	_global_post_damage_received = function(v,pl,hitgroup,dmginfo)
		if pl == dmginfo:GetAttacker() then
			dmginfo:SetDamageForce(dmginfo:GetDamageForce() * v)
		end
	end,
},

["blast_dmg_to_self"] = {
	_global_post_damage_received = function(v,pl,hitgroup,dmginfo)
		if dmginfo:IsDamageType(DMG_BLAST) and pl == dmginfo:GetAttacker() then
			dmginfo:ScaleDamage(v)
		end
	end,
},

["no_death_from_headshots"] = {
	_global_post_damage_received = function(v,pl,hitgroup,dmginfo)
		local inf = dmginfo:GetInflictor()
		local can_headshot = inf.CritsOnHeadshot or (not inf.IsTFWeapon and not inf.IsTFBuilding)
		
		if dmginfo:IsDamageType(DMG_BULLET) and pl.LastDamageWasCrit and can_headshot then
			dmginfo:SetDamage(math.max(2, pl:Health())-1)
		end
	end,
},

-- those only apply when the weapon that uses them is deployed
["dmg_from_ranged"] = {
	post_damage_received = function(v,pl,hitgroup,dmginfo)
		if dmginfo:IsDamageType(DMG_BULLET)
		or dmginfo:IsDamageType(DMG_GENERIC)
		or dmginfo:IsDamageType(DMG_BLAST)
		or dmginfo:IsDamageType(DMG_BURN)
		or dmginfo:IsDamageType(DMG_CRUSH) then
			dmginfo:ScaleDamage(v)
		end
	end,
},

["dmg_from_melee"] = {
	post_damage_received = function(v,pl,hitgroup,dmginfo)
		if dmginfo:IsDamageType(DMG_CLUB)
		or dmginfo:IsDamageType(DMG_SLASH) then
			dmginfo:ScaleDamage(v)
		end
	end,
},

------------------------------------------------------------------------------------
-- Kill attributes
-- Make things happen when an enemy is killed with that weapon

["add_onkill_critboost_time"] = {
	on_kill = function(v,ent,inf,att)
		if not ISBUILDING(ent) then
			--GAMEMODE:AddCritBoostTime(att, v)
		end
	end,
},

["heal_on_kill"] = {
	on_kill = function(v,ent,inf,att)
		if not ISBUILDING(ent) then
			--GAMEMODE:HealPlayer(att, att, v, true, true)
			att:SetHealth(att:Health() + v)
		end
	end,
},

["set_turn_to_gold"] = {
	boolean = true,
	pre_damage = function(v,ent,inf,att)
	engineer_gold_lines =
	{
		"scenes/Player/Engineer/low/3605.vcd",
		"",
		"",
		"",
		"",
		"scenes/Player/Engineer/low/3690.vcd",
		"",
		"",
		"",
		"",
		"scenes/Player/Engineer/low/3691.vcd",
		"",
		"",
		"",
		"",
	}
	
		if ent:CanReceiveCrits() then
			ent:EmitSound("weapons/saxxy_impact_gen_06.wav")
			--ent:SetNWBool("ShouldDropGoldenRagdoll", true)
			ent:AddDeathFlag(DF_GOLDEN)
			if inf.Owner:GetPlayerClass() == "engineer" then
				att:PlayScene(engineer_gold_lines[math.random( #engineer_gold_lines )])
			end
		end
	end,
},

["drop_health_pack_on_kill"] = {
	boolean = true,
	_global_on_kill = function(v,ent,inf,att)
		if not ISBUILDING(ent) then
			local pl = GetAttributeOwner()
			if IsValid(pl) then
				local item = ents.Create("item_healthkit_small")
				local a, b = ent:WorldSpaceAABB()
				item:SetPos((a+b) * 0.5)
				
				item.RespawnTime = -1
				item:Spawn()
				
				if ent.LastDamageInfo then
					local vel = ent.LastDamageInfo:GetDamageForce()
					local ang = vel:Angle()
					ang.p = math.min(ang.p, -20)
					vel = math.min(0.01 * vel:Length(), 400) * ang:Forward()
					item:DropWithGravity(vel)
				end
			end
		end
	end,
},

------------------------------------------------------------------------------------
-- Other

["set_blockbackstab_once"] = {
	unimplemented = true,
	boolean = true,
	_global_crit_received_override = function(v,pl,hitgroup,dmginfo)
		-- todo
	end,
	_global_post_damage_received = function(v,pl,hitgroup,dmginfo)
		-- todo
	end,
},

}

-- Those functions are automatically called when the property of an attribute is applied
local ACTIONS = {
	equip = function(a,weapon,owner)
		if weapon.OnEquipAttribute then
			weapon:OnEquipAttribute(a,owner)
		end
	end,
	projectile_fired = function(a,proj,weapon,owner)
		if proj.OnInitAttribute then
			proj:OnInitAttribute(a,weapon,owner)
		end
	end,
}

local DEFAULT = {
	active = true,
}

if CLIENT then

concommand.Add("searchattrib", function(pl, cmd, args)
	for k,v in SortedPairs(tf_items.AttributesByID) do
		for _,n in ipairs(args) do
			if string.find(v.name, n) then
				print(k, v.name)
				break
			end
		end
	end
end)

end

function RegisterAttribute(att, data)
	ATTRIBUTES[att] = data
end

function IsAttributeUnimplemented(att)
	return ATTRIBUTES[att] == nil or ATTRIBUTES[att].unimplemented
end

function AttributeFunc(att, act, ...)
	local a = ATTRIBUTES[att.attribute_class]
	if not a then return end
	
	if a.boolean and att.value == 0 then return end
	
	local f = a[act]
	if not f then return DEFAULT[act] end
	
	local res = f(att.value, ...)
	
	local af = ACTIONS[act]
	if af then
		af(att, ...)
	end
	
	return res
end

function ApplyAttributes(att, act, ...)
	for _,a in pairs(att or {}) do
		local c = AttributeFunc(a, act, ...)
		if c ~= nil then
			return c
		end
	end
end

function ApplyAttributesFromEntity(ent, act, ...)
	CURRENT_ENT = ent
	local c = ApplyAttributes(ent.Attributes or (ent.GetAttributes and ent:GetAttributes()), act, ...)
	CURRENT_ENT = NULL
	return c
end

function ApplyGlobalAttributesFromPlayer(pl, act, ...)
	CURRENT_PLAYER = pl
	for _,w in pairs(pl:GetTFItems()) do
		if not w.OnlyProvideAttributesOnActive or pl:GetActiveWeapon() == w then
			local c = ApplyAttributesFromEntity(w, "_global_"..act, ...)
			if c ~= nil then
				CURRENT_PLAYER = NULL
				return c
			end
		end
	end
	
	if pl.ItemSetAttributes then
		local c = ApplyAttributes(pl.ItemSetAttributes, "_global_"..act, ...)
		if c ~= nil then
			CURRENT_PLAYER = NULL
			return c
		end
	end
	
	CURRENT_PLAYER = NULL
end
