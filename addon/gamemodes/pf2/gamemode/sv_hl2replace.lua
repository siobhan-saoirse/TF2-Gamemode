
local HL2Weapon = {
	weapon_pistol = 1,
	weapon_357 = 1,
	--weapon_alyxgun
	weapon_annabelle = 1,
	weapon_ar2 = 1,
	--weapon_bugbait
	weapon_crossbow = 1,
	--weapon_crowbar
	weapon_frag = 1,
	weapon_rpg = 1,
	weapon_shotgun = 1,
	weapon_smg1 = 1,
	weapon_stunstick = 1,
	weapon_annabelle = 1,
	
	ai_weapon_pistol = 1,
	ai_weapon_357 = 1,
	ai_weapon_ar2 = 1,
	ai_weapon_crossbow = 1,
	ai_weapon_frag = 1,
	ai_weapon_rpg = 1,
	ai_weapon_shotgun = 1,
	ai_weapon_smg1 = 1,
	ai_weapon_stunstick = 1,
	ai_weapon_annabelle = 1,
}

local HL2AmmoSize = {
	item_ammo_357 = 1,
	item_ammo_357_large = 2,
	item_ammo_ar2 = 1,
	item_ammo_ar2_large = 2,
	item_ammo_crossbow = 1,
	item_ammo_pistol = 1,
	item_ammo_pistol_large = 2,
	item_ammo_smg1 = 1,
	item_ammo_smg1_large = 2,
	item_ammo_smg1_grenade = 1,
	--item_battery = 1,
	item_box_buckshot = 1,
	item_rpg_round = 1,
	item_ammo_ar2_altfire = 1,
	
	item_ammo_crate = 3,
}

local function CreateTFAmmoTrigger(wep, val)
	if IsValid(wep) and wep:GetModel() then
		--[[local ammo = ents.Create("item_droppedweapon")
		ammo.WeaponEntity = wep
		ammo:Spawn()
		ammo:Activate()]]
	end
end

function GM:PlayerCanPickupWeapon(ply, wep)
	if ply:IsHL2() then
		return true
	end
	return true
end

function GM:InitPostEntity()
	local global = ents.FindByClass("env_global")[1]
	if global then
		local state = global.globalstate
		local init = global.initialstate
		if state=="antlion_allied" then
			-- Msg("Antlions are allied\n")
			SetGlobalBool("AntlionsAreAllied", true)
			self.AntlionsAreAllied = true
		end
		
		if state=="gordon_precriminal" then
			-- Msg("Gordon is precriminal\n")
			SetGlobalBool("GordonIsPrecriminal", true)
			self.GordonIsPrecriminal = true
		end
	end
	
	local landmark = ents.Create("tf_hl2landmark")
	landmark:Spawn()
	landmark:SetName(tostring(landmark))
	
	local err = landmark:Load()
	-- MsgN("Loading data from previous level")
	if err==1 then
		-- MsgN("No data to load")
	elseif err==2 then
		-- MsgN("Error reading file")
	end
	
	if not landmark:IsValidMap() then
		-- MsgN("Wrong map, landmark data will not be used")
	end
	
	for _,v in pairs(ents.FindByClass("trigger_changelevel")) do
		v:Fire("addoutput", "OnChangeLevel "..landmark:GetName()..",Trigger", 0)
		
		
		local b = ents.Create("trigger_mp_changelevel")
		b:SetModel(v:GetModel())
		b:SetPos(v:GetPos())
		b:SetAngles(v:GetAngles())
		b:Spawn()
		b.Changelevel = v
		b.Landmark = landmark
	end
	
	for _,v in pairs(ents.FindByClass("trigger_autosave")) do
		v:Fire("addoutput", "OnStartTouch "..landmark:GetName()..",Checkpoint", 0)
	end
	
	self.Landmark = landmark
	self.PostEntityDone = true
end

local function ReplaceWeapon(ent)
	if not ent:IsValid() then return end
	
	local phys = ent:GetPhysicsObject()
	if HL2Weapon[ent:GetClass()] and phys and phys:IsValid() then
		--[[local drop = ents.Create("item_droppedweapon")
		drop:SetSolid(SOLID_VPHYSICS)
		drop:SetModel(ent:GetModel())
		drop:PhysicsInit(SOLID_VPHYSICS)
		drop:SetPos(ent:GetPos())
		drop:SetAngles(ent:GetAngles())
		ent:Remove()
		drop:Spawn()
		drop:Activate()
		
		drop:SetMoveType(MOVETYPE_VPHYSICS)
		drop:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		
		local phys2 = drop:GetPhysicsObject()
		if phys2:IsValid() then
			phys2:AddAngleVelocity(phys:GetAngleVelocity())
			phys2:AddVelocity(phys:GetVelocity())
			phys2:Wake()
		end]]
		
	end
end

function GM:EntityKeyValue(ent, key, value)
	local k = string.lower(key)
	if ent:GetClass() == "prop_physics" then
		if not ent.KeyValues then
			ent.KeyValues = {}
		end
		ent.KeyValues[key] = value
	elseif ent:GetClass()=="trigger_changelevel" then
		ent[k] = value
		
		if k=="spawnflags" then
			--[[if bit.bor(tonumber(value),4)>0 then
				print(ent,"previous")
			end]]
		--[[else
			ent:SetKeyValue("spawnflags", 2)]]
		end
	elseif ent:GetClass()=="env_global" then
		ent[key] = value
	elseif ent:GetClass()=="info_player_start" then
		if k == "spawnflags" and tonumber(value) and tonumber(value) > 0 then
			ent.IsMasterSpawn = true
		end
	elseif ent:GetClass()=="func_areaportal" then
		if key == "target" then
			ent.TargetDoorName = value
		end
	end
end

function GM:OnEntityCreated(ent)
	--[[local phys = ent:GetPhysicsObject()
	if HL2Weapon[ent:GetClass()] and phys and phys:IsValid() then
		timer.Simple(0.05, function() ReplaceWeapon(ent) end)
	end]]
	
	if not self.PostEntityDone then
		return
	end
	
	if not IsValid(ent) then
		return
	end

	-- Jarated zombies release jarated headcrabs
	if (ent:IsNPC()) then
		ent:AddFlags(FL_CLIENT)
	end
	if ent:IsNPC() and string.find(ent:GetClass(), "headcrab") then
		local owner = ent:GetOwner()
		if owner:IsNPC() and owner:HasPlayerState(PLAYERSTATE_JARATED) then
			ent.NextEndJarate = owner.NextEndJarate
			ent:AddPlayerState(PLAYERSTATE_JARATED, true)
		end
	end
end


function GM:GetInflictorClass(ent, attacker, inflictor)
	if ent:IsNPC() and attacker == ent then
		return ""
	end
	
	if IsValid(inflictor) then
		local inflictorclass = inflictor.NameOverride or inflictor:GetClass()
		local seq = (ent.LastDamageData and ent.LastDamageData.attacker_sequence) or 0
		local dmginfo = ent.LastDamageInfo or DamageInfo()
		
		
		if inflictor.GetKillIconName and not inflictor.NameOverride then
			return inflictor:GetKillIconName()
		end
		
		
		if attacker:GetClass()=="combine_mine" then
			return "combine_mine"
		end
		if attacker:GetClass()=="npc_vortigaunt" then
			if dmginfo:IsDamageType(DMG_SLASH) then
				return "npc_vortigaunt"
			elseif dmginfo:IsDamageType(DMG_SHOCK) then
				return "npc_vortigaunt_beam"
			end
		end
		
		if inflictorclass=="prop_physics" and dmginfo:IsExplosionDamage() then
			return "env_explosion"
		end
		
		if inflictorclass=="npc_hunter" then
			if seq==10 or seq==11 then
				return "npc_hunter_pound"
			elseif seq==12 then
				return "npc_hunter_skewer"
			elseif seq==115 or seq==116 then
				return "npc_hunter"
			end
		end
		
		if inflictorclass=="npc_antlion_worker" and dmginfo:IsDamageType(DMG_POISON) then
			return "npc_antlion_worker_explosion"
		end
		
		if inflictorclass=="npc_strider" then
			if dmginfo:IsDamageType(DMG_BULLET) then
				return "npc_strider_minigun"
			else
				return "npc_strider"
			end
		end
		
		return inflictor.NameOverride or inflictor:GetClass()
	else
		return "World"
	end
end