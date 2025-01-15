-- tf_items
local theitems = file.Read("scripts/items/items_game.txt", "GAME")
if !IsMounted("tf") then
    Error("ERROR: items_game.txt NOT FOUND!\n")
    theitems = file.Read("gamemodes/tf/gamemode/items/items_game_nomount.lua","GAME")
end
 
local items_game = util.KeyValuesToTable(theitems) 
local prefabs = items_game["prefabs"]
local attributes = items_game["attributes"]
local items = items_game["items"] 
local qualities = items_game["qualities"] 
for k, v in pairs(items_game["attributes"]) do
    v.id = k
    tf_items.AttributesByID[v.id] = v
end
for k, v in pairs(items_game["items"]) do
    -- fix an issue where prefabs would sometimes be split up and invalid
    if v.prefab and string.find(v.prefab, " ") then
        local tab = string.Split(v.prefab, " ")
        for i, o in pairs(tab) do
            if string.find(o, "weapon") then
                v.prefab = o
            elseif string.find(o, "hat") then
                v.prefab = "hat"
            elseif string.find(o, "misc") then
                v.prefab = "misc"
            end
        end
    end
    if (prefabs ~= nil) then
        if (v.prefab) then
            if (string.find(v.prefab,"valve ")) then
                v.prefab = string.Replace(v.prefab,"valve ", "")
            elseif (string.find(v.prefab," paintkit_base")) then 	
                v.prefab = string.Replace(v.prefab," paintkit_base", "")
            end
        end

        -- load visuals
        if prefabs[v.prefab] and v.visuals then
            local prefab = prefabs[v.prefab] 
            if prefab.visuals then
                local oldvisuals = prefab.visuals
                table.Merge(v.visuals, oldvisuals)
            end
        end
        if prefabs[v.prefab] and v.static_attrs then
            local prefab = prefabs[v.prefab]
            if prefab.static_attrs then
                local oldvisuals = v.static_attrs
                v.static_attrs = prefab.static_attrs
                table.Merge(v.static_attrs, oldvisuals)
            end
        end
        if prefabs[v.prefab] and v.attributes then
            local prefab = prefabs[v.prefab]
            if prefab.attributes then 
                local oldvisuals = v.attributes
                v.attributes = prefab.attributes
                if (v.static_attrs) then
                    table.Merge(v.static_attrs, v.attributes)
                end
                table.Merge(v.attributes, oldvisuals)
            end
        end

        -- add prefab variables that don't exist
        if v.prefab and prefabs[v.prefab] then
            for i, o in pairs(prefabs[v.prefab]) do
                if !v[i] then
                    v[i] = o
                end
            end
        end
    end
    v.id = k
    v.propername = 0
	if (string.find(v.name,"Grappling")) then
		v.id = 10000666
	end
	if (string.find(v.name,"MvM GateBot ")) then
		v.item_name = v.name
        v.item_slot = "head"
        v.item_class = "tf_wearable_item"
		v.item_quality = "collectors"
	end
	if (string.find(v.name,"Gloves of Running Urgently MvM")) then
		v.item_name = v.name
		v.item_quality = "collectors"
	end
    if (!v.item_slot) then
        v.item_slot = "misc"
        v.item_class = "tf_wearable_item"
        v.item_quality = "unique"
    end
    if (v.model_player) then
        if (v.item_slot == "hat" or v.equip_region == "hat" or v.prefab == "hat") then
            v.item_slot = "misc"
            v.item_class = "tf_wearable_item"
            v.item_quality = "unique"
        elseif (v.prefab == "misc" or v.prefab == "no_craft misc" or v.prefab == "valve base_misc" or v.prefab == "base_misc" or v.prefab == "no_craft misc marketable"or v.prefab == "misc") then
            v.item_slot = "misc"
            v.item_class = "tf_wearable_item"
            v.item_quality = "unique"
        end
    end
	if (!v.item_quality) then
		v.item_quality = "unique"
	end
    if (!v.item_name) then
        v.item_name = v.name
		v.item_quality = "unique"
    end
    if v.item_class == "saxxy" then
        v.item_class = "tf_weapon_allclass"
    elseif v.item_class == "tf_weapon_grenadelauncher" then
		v.item_slot = "secondary"
    elseif v.item_name == "#TF_Weapon_PanicAttack" then
        v.used_by_classes = {}
        v.used_by_classes["heavy"] = {}
        v.used_by_classes["heavy"] = 1
        v.used_by_classes["soldier"] = {}
        v.used_by_classes["soldier"] = 1
        v.used_by_classes["pyro"] = {}
        v.used_by_classes["pyro"] = 1
		v.item_slot = "secondary"
		v.item_quality = "unique"
    elseif v.item_name == "Shotgun" then
		v.item_slot = "secondary"
    elseif v.item_class == "tf_weapon_cannon" then
		v.item_slot = "secondary"
    elseif v.item_class == "tf_weapon_pipebomblauncher" then
		v.item_slot = "primary"
    elseif v.item_class == "tf_weapon_sniperrifle_classic" then
        v.item_class = "tf_weapon_sniperrifle"
    elseif v.item_class == "tf_weapon_sniperrifle_decap" then
        v.item_class = "tf_weapon_sniperrifle"
    elseif v.item_class == "tf_weapon_pep_brawler_blaster" then
        v.item_class = "tf_weapon_scattergun"
    elseif v.item_class == "tf_wearable_demoshield" then
        v.item_slot = "primary"
        v.item_class = "tf_wearable_item_demoshield"
    elseif v.item_class == "tf_weapon_particle_cannon" then
        v.item_class = "tf_weapon_particle_launcher"
    elseif v.item_class == "tf_weapon_rocketlauncher_directhit" then
        v.item_class = "tf_weapon_rocketlauncher_dh"
    elseif v.item_class == "tf_weapon_drg_pomson" then
        v.item_class = "tf_weapon_pomson"
    elseif v.item_class == "tf_weapon_handgun_scout_secondary" then
        v.item_class = "tf_weapon_pistol_scout"
    elseif v.item_class == "tf_weapon_handgun_scout_primary" then
        v.item_class = "tf_weapon_handgun_scout"
    elseif v.item_class == "tf_weapon_laser_pointer" then
        v.item_class = "tf_weapon_wrangler"
    elseif v.item_class == "tf_weapon_sapper" then
        v.item_slot = "primary"
    elseif v.item_class == "tf_weapon_soda_popper" then
        v.item_class = "tf_weapon_scattergun"	
    end
    if (v.item_class == nil) then
        v.item_class = "tf_wearable_item"
    end
    if (v.item_class == "tf_wearable") then
        v.item_class = "tf_wearable_item"
    end
    if (v.item_class == "tf_weapon_rocketlauncher_directhit") then
        v.item_class = "tf_weapon_rocketlauncher_dh"
    end
    if k == 513 then
        v.item_class = "tf_weapon_rocketlauncher"
		elseif k == 20 then
			v.item_slot = "primary"
		elseif k == 19 then
        v.item_slot = "secondary"
    end

    --if v.id == 424 then print(tf_lang.GetRaw(v.item_name)) end

    if v.item_name then
        v.name = tf_lang.GetRaw(v.item_name)
        tf_items.Items[v.name] = v
        if tf_lang.GetRaw(v.item_name) == "Red-Tape Recorder" then
			v.item_class = "tf_weapon_rtr" 
            v.item_slot = "primary"
		end
        if tf_lang.GetRaw(v.item_name) == "Sapper" then 
            v.item_slot = "primary"
		end
        if tf_lang.GetRaw(v.item_name) == "Half-Zatoichi" then
			v.item_class = "tf_weapon_katana"
            v.model_player = "models/weapons/c_models/c_shogun_katana/c_shogun_katana.mdl"
			v.item_slot = "melee"
        end
        if tf_lang.GetRaw(v.item_name) == "Bootlegger" then
			v.item_class = "tf_wearable_item"
			v.item_slot = "secondary"
        end
        if tf_lang.GetRaw(v.item_name) == "Ali Baba's Wee Booties" then
			v.item_class = "tf_wearable_item"
			v.item_slot = "secondary"
        end
        if tf_lang.GetRaw(v.item_name) == "Concheror" then
			v.item_class = "tf_weapon_buff_item_conch"
		end
        if tf_lang.GetRaw(v.item_name) == "Sandvich" then
			v.attach_to_hands = 1
            v.item_slot = "secondary"
			v.item_class = "tf_weapon_lunchbox"
			v.used_by_classes = {}
			v.used_by_classes["heavy"] = {}
			v.used_by_classes["heavy"] = 1
			v.item_quality = "unique"
        end
        if tf_lang.GetRaw(v.item_name) == "Bonk! Atomic Punch" then
			v.attach_to_hands = 1
            v.item_slot = "secondary"
			v.item_class = "tf_weapon_lunchbox_drink"
			v.used_by_classes = {}
			v.used_by_classes["scout"] = {}
			v.used_by_classes["scout"] = 1
			v.item_quality = "unique"
        end
        if tf_lang.GetRaw(v.item_name) == "Rainblower" then
			v.item_class = "tf_weapon_flamethrower_rb"
        end
        if tf_lang.GetRaw(v.item_name) == "Quick-Fix" then
			v.item_class = "tf_weapon_medigun_qf"
		end
        if tf_lang.GetRaw(v.item_name) == "Vaccinator" then
			v.item_class = "tf_weapon_medigun_vaccinator"
		end
        if tf_lang.GetRaw(v.item_name) == "Beggar's Bazooka" then
			v.item_class = "tf_weapon_rocketlauncher_rapidfire"
        end
        if tf_lang.GetRaw(v.item_name) == "Phlogistinator" then
            v.item_class = "tf_weapon_phlogistinator"
        end
        if tf_lang.GetRaw(v.item_name) == "Degreaser" then
            v.item_slot = "primary"
			v.item_class = "tf_weapon_flamethrower"
			v.used_by_classes = {}
			v.used_by_classes["pyro"] = {}
			v.used_by_classes["pyro"] = 1
			v.item_quality = "unique"
        end
        if tf_lang.GetRaw(v.item_name) == "Widowmaker" then
			v.item_class = "tf_weapon_shotgun_imalreadywidowmaker"
		end  
        if tf_lang.GetRaw(v.item_name) == "Spy-cicle" then
			v.item_class = "tf_weapon_knife_icicle" 
        end
        if tf_lang.GetRaw(v.item_name) == "Escape Plan" then
			v.item_class = "tf_weapon_pickaxe" 
		end
        if tf_lang.GetRaw(v.item_name) == "Tomislav" then
			v.item_class = "tf_weapon_minigun"  
            --print("Tomislav Time")
        end   
        if tf_lang.GetRaw(v.item_name) == "Flame Thrower" then
			v.attach_to_hands = 1
			v.item_slot = "primary"
			v.used_by_classes = {}
			v.used_by_classes["pyro"] = {}
			v.used_by_classes["pyro"] = 1
			v.item_class = "tf_weapon_flamethrower" 
			v.item_quality = "unique" 
        end    
        if tf_lang.GetRaw(v.item_name) == "AWPer Hand" then
			v.attach_to_hands = 1
			v.used_by_classes = {}
			v.used_by_classes["sniper"] = {}
			v.used_by_classes["sniper"] = 1
			v.item_slot = "primary"
			v.item_class = "tf_weapon_sniperrifle" 
			v.item_quality = "unique" 
        end    
		if tf_lang.GetRaw(v.item_name) == "Your Eternal Reward" or tf_lang.GetRaw(v.item_name) == "Wanga Prick" then
			v.attach_to_hands = 1
            v.item_slot = "melee"
            v.show_in_armory = 1 
			v.used_by_classes = {}
			v.visuals = {}
			v.visuals["animation_replacement"] = {}
			v.visuals["animation_replacement"]["ACT_VM_DRAW"] = {}
			v.visuals["animation_replacement"]["ACT_VM_DRAW"] = "ACT_ITEM2_VM_DRAW"
			v.visuals["animation_replacement"]["ACT_VM_IDLE"] = {}
			v.visuals["animation_replacement"]["ACT_VM_IDLE"] = "ACT_ITEM2_VM_IDLE"
			v.visuals["animation_replacement"]["ACT_VM_HITCENTER"] = {}
			v.visuals["animation_replacement"]["ACT_VM_HITCENTER"] = "ACT_ITEM2_VM_HITCENTER"
			v.visuals["animation_replacement"]["ACT_VM_SWINGHARD"] = {}
			v.visuals["animation_replacement"]["ACT_VM_SWINGHARD"] = "ACT_ITEM2_VM_SWINGHARD"
			v.visuals["animation_replacement"]["ACT_BACKSTAB_VM_UP"] = {}
			v.visuals["animation_replacement"]["ACT_BACKSTAB_VM_UP"] = "ACT_ITEM2_BACKSTAB_VM_UP"
			v.visuals["animation_replacement"]["ACT_BACKSTAB_VM_DOWN"] = {}
			v.visuals["animation_replacement"]["ACT_BACKSTAB_VM_DOWN"] = "ACT_ITEM2_BACKSTAB_VM_DOWN"
			v.visuals["animation_replacement"]["ACT_BACKSTAB_VM_IDLE"] = {}
			v.visuals["animation_replacement"]["ACT_BACKSTAB_VM_IDLE"] = "ACT_ITEM2_BACKSTAB_VM_IDLE" 
			v.used_by_classes["spy"] = {}
			v.used_by_classes["spy"] = 1
			v.item_class = "tf_weapon_knife"
			v.item_quality = "unique"
            v.prefab = "weapon_eternal_reward"
		end
		if v.prefab == "weapon_eyelander" or v.prefab == "weapon_sword" or v.prefab == "weapon_demo_sultan_sword" then
			v.attach_to_hands = 1
            v.item_slot = "melee"
            v.show_in_armory = 1 
			v.used_by_classes = {}
			v.used_by_classes["demoman"] = {}
			v.used_by_classes["demoman"] = 1
            if (tf_lang.GetRaw(v.item_name) != "Half-Zatoichi") then
			    v.item_class = "tf_weapon_sword"	
            else
                v.used_by_classes["soldier"] = {}
                v.used_by_classes["soldier"] = 1
            end
			v.item_quality = "unique"
		end
		if tf_lang.GetRaw(v.item_name) == "Scotsman's Skullcutter" then
			v.attach_to_hands = 1
            v.item_slot = "melee"
            v.show_in_armory = 1 
			v.item_class = "tf_weapon_sword"	
			v.used_by_classes = {}
			v.used_by_classes["demoman"] = {}
			v.used_by_classes["demoman"] = 1
			v.item_quality = "unique"
		end 
  
    elseif v.name then
        tf_items.Items[v.name] = v
    else
        v.name = "Test " .. math.random(30000)
        tf_items.Items[v.name] = v
    end

    --tf_items.ItemsByID[k] = v
    tf_items.Items[k] = v
end

tf_items.Attributes.n = #attributes
tf_items.Items.n = #items
tf_items.Qualities.n = #qualities