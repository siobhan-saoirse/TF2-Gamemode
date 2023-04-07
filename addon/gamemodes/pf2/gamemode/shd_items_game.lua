-- tf_items
--[[
if !file.Exists("scripts/items/items_game.txt", "GAME") then
    Error("ERROR: items_game.txt NOT FOUND!\nLIVE TF WEAPONS WILL NOT BE LOADED!\n")
end

local items_game = util.KeyValuesToTable(file.Read("scripts/items/items_game.txt", "GAME")) 
local prefabs = items_game["prefabs"]
local items = items_game["items"]
for k, v in pairs(items_game["items"]) do
    -- fix an issue where prefabs would sometimes be split up and invalid
    if v.prefab and string.find(v.prefab, " ") then
        local tab = string.Split(v.prefab, " ")
        for i, o in pairs(tab) do
            if string.find(o, "weapon") then
                v.prefab = o
            end
        end
    end
	
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
            local oldvisuals = v.visuals
            v.visuals = prefab.visuals
            table.Merge(v.visuals, oldvisuals)
        end
    end

    if prefabs[v.prefab] and v.attributes then
        local prefab = prefabs[v.prefab]
        if prefab.attributes then
            local oldvisuals = v.attributes
            v.attributes = prefab.attributes
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

    v.id = k
    v.propername = 0
	if (string.find(v.name,"MvM GateBot ")) then
		v.item_name = v.name
        v.item_slot = "head"
        v.item_class = "tf_wearable"
		v.item_quality = "collectors"
	end
	if (string.find(v.name,"Gloves of Running Urgently MvM")) then
		v.item_name = v.name
		v.item_quality = "collectors"
	end
    if (!v.item_slot) then
        v.item_slot = "misc"
        v.item_class = "tf_wearable"
		v.item_quality = "unique"
    end
	if (!v.item_quality) then
		v.item_quality = "unique"
	end
    if (!v.item_name) then
        v.item_name = v.name
		v.item_quality = "unique"
    end
    if (v.item_slot == "hat") then
        v.item_class = "tf_wearable_item"
		v.item_quality = "unique"
		v.visuals = {}
		v.visuals.hide_player_bodygroup_name = { "hat" }
    elseif (v.prefab == "misc" or v.prefab == "no_craft misc" or v.prefab == "valve base_misc" or v.prefab == "base_misc" or v.prefab == "no_craft misc marketable") then
        v.item_slot = "misc"
        v.item_class = "tf_wearable_item"
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

    if !v.item_class then
        v.item_class = "tf_wearable_item"
    end
    if (v.item_class == "tf_weapon_rocketlauncher_directhit") then
        v.item_class = "tf_weapon_rocketlauncher_dh"
    end
    if k == 513 then
        v.item_class = "tf_weapon_rocketlauncher_qrl"
		elseif k == 20 then
			v.item_slot = "primary"
		elseif k == 19 then
        v.item_slot = "secondary"
    end

    if v.id == 424 then print(tf_lang.GetRaw(v.item_name)) end

    if v.item_name then
        v.name = tf_lang.GetRaw(v.item_name)
        tf_items.Items[v.name] = v
  
        if v.name == "Natascha" then
			v.item_class = "tf_weapon_minifun"
		end
        if v.name == "Deflector" then
			v.item_class = "tf_weapon_minigun"
		end
        if v.name == "Huo-Long Heater" then
			v.item_class = "tf_weapon_minigun_burner"
		end
        if v.name == "Brass Beast" then
			v.item_class = "tf_weapon_minigun_bb"
		end
        if v.name == "Black Box" || v.name == "Festive Black Box" then
			v.item_class = "tf_weapon_rocketlauncher_bbox"
            v.attributes["health on radius damage"] = {}
            v.attributes["health on radius damage"]["attribute_class"] = "add_health_on_radius_damage"
            v.attributes["health on radius damage"]["value"] = "20"
            v.attributes["clip size penalty"] = {}
            v.attributes["clip size penalty"]["attribute_class"] = "mult_clipsize"
            v.attributes["clip size penalty"]["value"] = "0.75"
		end
        if v.name == "Red-Tape Recorder" then
			v.item_class = "tf_weapon_rtr" 
            v.item_slot = "primary"
		end
        if v.name == "Sapper" then 
            v.item_slot = "primary"
		end
        if v.name == "Half-Zatoichi" then
			v.item_class = "tf_weapon_katana"
            v.model_player = "models/weapons/c_models/c_shogun_katana/c_shogun_katana.mdl"
			v.item_slot = "melee"
        end
        if v.name == "Bootlegger" then
			v.item_class = "tf_wearable"
			v.item_slot = "secondary"
        end
        if v.name == "Ali Baba's Wee Booties" then
			v.item_class = "tf_wearable"
			v.item_slot = "secondary"
        end
        if v.name == "Concheror" then
			v.item_class = "tf_weapon_buff_item_conch"
		end
        if v.name == "Sharp Dresser" then
			v.item_class = "tf_weapon_knife_sh"
        end
        if v.name == "Sandvich" then
			v.attach_to_hands = 1
            v.item_slot = "secondary"
			v.item_class = "tf_weapon_lunchbox"
			v.used_by_classes = {}
			v.used_by_classes["heavy"] = {}
			v.used_by_classes["heavy"] = 1
			v.item_quality = "unique"
        end
        if v.name == "Bonk! Atomic Punch" then
			v.attach_to_hands = 1
            v.item_slot = "secondary"
			v.item_class = "tf_weapon_lunchbox_drink"
			v.used_by_classes = {}
			v.used_by_classes["scout"] = {}
			v.used_by_classes["scout"] = 1
			v.item_quality = "unique"
        end
        if v.item_class == "tf_weapon_pistol" then
			v.attach_to_hands = 1
            v.item_slot = "secondary"
			v.item_class = "tf_weapon_pistol"
			v.used_by_classes = {}
			v.used_by_classes["engineer"] = {}
			v.used_by_classes["engineer"] = 1
			v.item_quality = "unique"
        end
        if v.item_class == "tf_weapon_pistol_scout" then
			v.attach_to_hands = 1
            v.item_slot = "secondary"
			v.item_class = "tf_weapon_pistol"
			v.used_by_classes = {}
			v.used_by_classes["engineer"] = {}
			v.used_by_classes["engineer"] = 1
			v.item_quality = "unique"
        end
        if v.name == "Rainblower" then
			v.item_class = "tf_weapon_flamethrower_rb"
        end
        if v.name == "Quick-Fix" then
			v.item_class = "tf_weapon_medigun_qf"
		end
        if v.name == "Vaccinator" then
			v.item_class = "tf_weapon_medigun_vaccinator"
		end
        if v.name == "Beggar's Bazooka" then
			v.item_class = "tf_weapon_rocketlauncher_rapidfire"
        end
        if v.name == "Phlogistinator" then
            v.item_class = "tf_weapon_phlogistinator"
        end
        if v.name == "Widowmaker" then
			v.item_class = "tf_weapon_shotgun_imalreadywidowmaker"
		end  
        if v.name == "Spy-cicle" then
			v.item_class = "tf_weapon_knife_icicle" 
        end
        if v.name == "Escape Plan" then
			v.item_class = "tf_weapon_pickaxe" 
		end
        if v.name == "Tomislav" then
			v.item_class = "tf_weapon_minigun_tomislav"  
            print("Tomislav Time")
        end   
        if v.name == "Flame Thrower" then
			v.attach_to_hands = 1
			v.item_slot = "primary"
			v.item_class = "tf_weapon_flamethrower" 
			v.item_quality = "unique" 
        end    
		if v.prefab == "weapon_eyelander" or v.prefab == "weapon_sword" then
			v.attach_to_hands = 1
            v.item_slot = "melee"
            if (v.name != "Half-Zatoichi") then
			    v.item_class = "tf_weapon_sword"	
            end
			v.item_quality = "unique"
		end
    elseif v.name then
        tf_items.Items[tf_lang.GetRaw(v.name)] = v
    else
        v.name = "Test " .. math.random(30000)
        tf_items.Items[v.name] = v
    end

    tf_items.ItemsByID[v.id] = v
end

tf_items.Items.n = #items]]
-- This isn't necessarily needed.
function abc()
    return false
end