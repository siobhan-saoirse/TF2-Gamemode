MsgN("Loading extra items and attributes")

if CLIENT then

local lang_data = [["lang" 
{ 
"Language" "English" 
"Tokens" 
{ 

"Attrib_Player_TurnGay" 				"Imbued with an ancestral gey power"
"Attrib_Player_TurnGay2" 				"On Hit: Victim turns gay\nGay players have a 50% probability\nto inflict negative damage"
"Attrib_Shoots_Nukes"					"Shoots massive nuclear payloads.\nHow can they even fit in there?"
"Attrib_Owner_Receives_Minicrits"		"All incoming hits are mini-crits"
"Attrib_CritVsNoclip"					"100% critical hits vs noclipping players"
"Attrib_EnableCrotchshots"				"Crits on an accurate shot between legs"
"Attrib_AltFire_Is_Vampire"				"Alt-Fire: +3 health on hit\n-75% damage done"
"Attrib_MilkDuration"					"On Hit: Mad Milk applied to target for %s1 seconds"
"Attrib_BouncyGrenades"					"Fires bouncy round grenades"
"Attrib_RadialHealOnHit"				"On Hit: +%s1 health on nearby teammates"
"Attrib_BurnDuration"					"On Hit: Victim catches fire for %s1 seconds"

"Attrib_DmgTaken_From_Fall_Reduced"		"+%s1% fall damage resistance on wearer"
"Attrib_DmgTaken_From_Fall_Increased"	"%s1% fall damage vulnerability on wearer"
"Attrib_DmgTaken_From_Phys_Reduced"		"+%s1% physics damage resistance on wearer"
"Attrib_DmgTaken_From_Phys_Increased"	"%s1% physics damage vulnerability on wearer"
"Attrib_JumpHeight_Bonus"				"+%s1% higher jump height on wearer"
"Attrib_JumpHeight_Penalty"				"%s1% lower jump height on wearer"

"Attrib_Charge_Is_Unstoppable"			"Running into an enemy does not end a charge"
"Attrib_Charge_Rate_Reduced"			"+%s1% longer cooldown"
"Attrib_Charge_Rate_Increased"			"%s1% shorter cooldown"

"Attrib_Rocket_Gravity"					"Fires heavy rockets that arc over distances\nRockets can be charged, increasing their velocity"

"Attrib_StoutShako_Launcher"			"Stout Shako for two refined!"

"TF_Unique_GayPride"		"Sexo de Pene Gay"
"TF_Unique_GayPride_Desc"	"Presumably stolen from an obscure\nbranch of the Spanish Inquisition, this\nweapon is imbued with sheer gey power"
"TF_Unique_Ludmila"			"Ludmila"
"TF_Unique_Bazooka"			"Bazooka"

"TF_Test_SyringeGun1"		"Syringe Gun Test 1"
"TF_Test_GrenadeLauncher1"	"Grenade Launcher Test 1"


"TF_Set_Demopan_Trader"		"The Demopan's Trading Kit"
}
}
]]

include("tf_lang_module.lua")
tf_lang.Parse(lang_data)

end

local item_data = [["items_game"
{ 
	"qualities"
	{
	}
	"items"
	{
		"10000049"
		{
			"name"	"The Sexo De Pene Gay"
			"hidden"	"1"
			"item_class"	"tf_weapon_rocketlauncher"
			"craft_class"	"weapon"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"attach_to_hands"	"1"
			"item_type_name"	"#TF_Weapon_RocketLauncher"
			"item_name"	"#TF_Unique_GayPride"
			"item_description"	"#TF_Unique_GayPride_Desc"
			"item_slot"	"primary"
			"item_quality"	"unique"
			"propername"	"1"
			"min_ilevel"	"1"
			"max_ilevel"	"1"
			"image_inventory"	"backpack/weapons/c_models/c_directhit/c_directhit"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/weapons/c_models/c_directhit/c_directhit.mdl"
			"attach_to_hands" "1"
			"used_by_classes"
			{
				"soldier"	"1"
			}
			"attributes"
			{
				"hidden turn gay"
				{
					"attribute_class"	"turn_gey"
					"value"	"1"
				}
				"turn player gay 2"
				{
					"attribute_class"	"turn_gey_2"
					"value"	"1"
				}
				"owner receives minicrits"
				{
					"attribute_class"	"owner_receive_minicrits"
					"value"	"1"
				}
			}
			"allowed_attributes"
			{
				"all_items"	"1"
				"dmg_reductions" "1"
				"player_health" "1"
				"attrib_healthregen" "1"
				"player_movement" "1"
				"attrib_dmgdone"	"1"
				"attrib_critboosts"	"1"
				"attrib_onhit_slow" "1"
				"attrib_clip"	"1"
				"attrib_firerate" "1"
				"wpn_explosive" "1"
				"ammo_primary" "1"
				"wpn_fires_projectiles" "1"
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
		}
		"10000050"
		{
			"name"	"Ludmila"
			"item_class"	"tf_weapon_minigun"
			"craft_class"	"weapon"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"attach_to_hands"	"1"
			"item_type_name"	"#TF_Weapon_Minigun"
			"item_name"	"#TF_Unique_Ludmila"
			"item_slot"	"primary"
			"item_logname"	"ludmila"
			"item_iconname"	"natascha"
			"image_inventory"	"backpack/weapons/c_models/c_w_ludmila/c_w_ludmila"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/weapons/w_models/w_minigun.mdl"
			"item_quality"	"unique"
			"min_ilevel"	"5"
			"max_ilevel"	"5"
			"used_by_classes"
			{
				"heavy"	"1"
			}
			"attributes"
			{
				"alt-fire is vampire"
				{
					"attribute_class"	"set_altfire_mode"
					"value"	"1"
				}
			}
			"allowed_attributes"
			{
				"all_items"	"1"
				"dmg_reductions" "1"
				"player_health" "1"
				"attrib_healthregen" "1"
				"player_movement" "1"
				"attrib_dmgdone"	"1"
				"attrib_critboosts"	"1"
				"attrib_onhit_rapid" "1"
				"attrib_vs_burning" "1"
				"wpn_uses_aimmode" "1"
				"only_on_minigun" "1"
			}
			"visuals"
			{
				"sound_reload"	"Weapon_Minifun.Reload"
				"sound_empty"	"Weapon_Minifun.ClipEmpty"
				"sound_double_shot"	"Weapon_Minifun.Fire"
				"sound_special1"	"Weapon_Minifun.WindUp"
				"sound_special2"	"Weapon_Minifun.WindDown"
				"sound_special3"	"Weapon_Minifun.Spin"
				"sound_burst"	"Weapon_Minifun.FireCrit"
				"skin"	"2"
				"attached_model"
				{
					"world_model"	"1"
					"model"	"models/weapons/c_models/c_w_ludmila/c_w_ludmila.mdl"
				}
				"attached_model"
 				{
 					"view_model"	"1"
 					"model" "models/weapons/c_models/c_v_ludmila/c_v_ludmila.mdl"
 				}
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
		}
		"10000051"
		{
			"name"	"The Walkabout"
			"item_class"	"tf_weapon_sniperrifle"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"attach_to_hands"	"1"
			"armory_desc"	"stockitem"
			"item_type_name"	"#TF_Weapon_SniperRifle"
			"item_name"	"#TF_Unique_Achievement_SniperRifle"
			"item_slot"	"primary"
			"item_quality"		"unique"
			"propername"	"1"
			"min_ilevel"	"1"
			"max_ilevel"	"1"
			"image_inventory"	"backpack/weapons/w_models/w_sniperrifle"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/weapons/w_models/w_sniperrifle.mdl"
			"used_by_classes"
			{
				"sniper"	"1"
			}
			"attributes"
			{
				"zoom speed mod disabled"
				{
					"attribute_class"	"unimplemented_mod_zoom_speed_disabled"
					"value"	"1"
				}
				"sniper no charge"
				{
					"attribute_class"	"unimplemented_mod_sniper_no_charge"
					"value"	"1"
				}
			}
			"allowed_attributes"
			{
				"all_items"	"1"
				"dmg_reductions" "1"
				"player_health" "1"
				"attrib_healthregen" "1"
				"player_movement" "1"
				"attrib_dmgdone"	"1"
				"attrib_onhit_slow" "1"
				"wpn_uses_aimmode" "1"
				"only_on_srifle" "1"
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
		}
		"10000052"
		{
			"name"	"Test 1 TF_WEAPON_SYRINGEGUN_MEDIC"
			"item_class"	"tf_weapon_syringegun_medic"
			"capabilities"
			{
				"nameable"		"1"
			}
			"show_in_armory"	"1"
			"attach_to_hands"	"1"
			"armory_desc"	"stockitem"
			"item_type_name"	"#TF_Weapon_SyringeGun"
			"item_name"	"#TF_Test_SyringeGun1"
			"item_slot"	"primary"
			"item_quality"		"unique"
			"min_ilevel"	"1"
			"max_ilevel"	"1"
			"image_inventory"	"backpack/weapons/w_models/w_syringegun"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/weapons/w_models/w_syringegun.mdl"
			"used_by_classes"
			{
				"medic"	"1"
			}
			"attributes"
			{
				"radial heal on hit"
				{
					"attribute_class"	"radial_onhit_addhealth"
					"value"	"15"
				}
				"damage bonus"
				{
					"attribute_class"	"mult_dmg"
					"value"	"3"
				}
				"fire rate penalty"
				{
					"attribute_class"	"mult_postfiredelay"
					"value" "3"
				}
				"clip size penalty"
				{
					"attribute_class"	"mult_clipsize"
					"value" "0.38"
				}
			}
			"allowed_attributes"
			{
				"all_items"	"1"
				"dmg_reductions" "1"
				"player_health" "1"
				"attrib_healthregen" "1"
				"player_movement" "1"
				"attrib_dmgdone"	"1"
				"attrib_critboosts"	"1"
				"attrib_onhit_rapid" "1"
				"attrib_clip"	"1"
				"attrib_firerate" "1"
				"attrib_medic" "1"
			}
			"mouse_pressed_sound"	"ui/item_light_gun_pickup.wav"
			"drop_sound"		"ui/item_light_gun_drop.wav"
		}
		"10000053"
		{
			"name"	"Test 1 TF_WEAPON_GRENADELAUNCHER"
			"item_class"	"tf_weapon_grenadelauncher"
			"capabilities"
			{
				"nameable"		"1"
			}
			"show_in_armory"	"1"
			"attach_to_hands"	"1"
			"armory_desc"	"stockitem"
			"item_type_name"	"#TF_Weapon_GrenadeLauncher"
			"item_name"	"#TF_Test_GrenadeLauncher1"
			"item_slot"	"secondary"
			"item_quality"		"unique"
			"min_ilevel"	"1"
			"max_ilevel"	"1"
			"image_inventory"	"backpack/weapons/w_models/w_grenadelauncher"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/weapons/w_models/w_grenadelauncher.mdl"
			"used_by_classes"
			{
				"demoman"	"1"
			}
			"attributes"
			{
				"bouncy grenades"
				{
					"attribute_class"	"set_grenade_mode"
					"value"	"1"
				}
				"Blast radius increased"
				{
					"attribute_class"	"mult_explosion_radius"
					"value" "1.15"
				}
				"Projectile range decreased"
				{
					"attribute_class"	"mult_projectile_range"
					"value" "0.75"
				}
			}
			"allowed_attributes"
			{
				"all_items"	"1"
				"dmg_reductions" "1"
				"player_health" "1"
				"attrib_healthregen" "1"
				"player_movement" "1"
				"attrib_dmgdone"	"1"
				"attrib_onhit_slow" "1"
				"attrib_clip"	"1"
				"attrib_firerate" "1"
				"wpn_explosive" "1"
				"ammo_primary" "1"
				"wpn_lobs_projectiles" "1"
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
		}
		"10000054"
		{
			"name"	"The Bazooka"
			"item_class"	"tf_weapon_rocketlauncher"
			"capabilities"
			{
				"nameable"		"1"
			}
			"show_in_armory"	"1"
			"attach_to_hands"	"1"
			"armory_desc"	"stockitem"
			"item_type_name"	"#TF_Weapon_RocketLauncher"
			"item_name"	"#TF_Unique_Bazooka"
			"item_slot"	"primary"
			"item_quality"		"unique"
			"propername"	"1"
			"min_ilevel"	"1"
			"max_ilevel"	"1"
			"image_inventory"	"backpack/weapons/w_models/w_rocketlauncher"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/weapons/w_models/w_rocketlauncher.mdl"
			"used_by_classes"
			{
				"soldier"	"1"
			}
			"attributes"
			{
				"heavy rockets"
				{
					"attribute_class"	"set_weapon_mode"
					"value"	"1"
				}
				"fire rate bonus"
				{
					"attribute_class"	"mult_postfiredelay"
					"value" "0.2"
				}
				"blast dmg to self increased"
				{
					"attribute_class"	"blast_dmg_to_self"
					"value" "1.25"
				}
			}
			"allowed_attributes"
			{
				"all_items"	"1"
				"dmg_reductions" "1"
				"player_health" "1"
				"attrib_healthregen" "1"
				"player_movement" "1"
				"attrib_dmgdone"	"1"
				"attrib_critboosts"	"1"
				"attrib_onhit_slow" "1"
				"attrib_clip"	"1"
				"attrib_firerate" "1"
				"wpn_explosive" "1"
				"ammo_primary" "1"
				"wpn_fires_projectiles" "1"
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
		}
	}
	"attributes"
	{
		"29"
		{
			"name"	"alt-fire is vampire"
			"attribute_class"	"set_altfire_mode"
			"attribute_name"	"Alt-fire Is Vampire"
			"min_value"	"1"
			"max_value"	"1"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_AltFire_Is_Vampire"
			"description_format"	"value_is_additive"
			"hidden"	"0"
			"effect_type"	"neutral"
			"stored_as_integer"	"0"
		}
		"633"
		{
			"name"	"turn player gay"
			"attribute_class"	"turn_gey"
			"attribute_name"	"Turn Player Gay"
			"min_value"	"1"
			"max_value"	"1"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_Player_TurnGay"
			"description_format"	"value_is_additive"
			"hidden"	"0"
			"effect_type"	"neutral"
			"stored_as_integer"	"0"
		}
		"700"
		{
			"name"	"turn player gay 2"
			"attribute_class"	"turn_gey_2"
			"attribute_name"	"Turn Player Gay 2"
			"min_value"	"1"
			"max_value"	"1"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_Player_TurnGay2"
			"description_format"	"value_is_additive"
			"hidden"	"0"
			"effect_type"	"positive"
			"stored_as_integer"	"0"
		}
		"701"
		{
			"name"	"hidden turn gay"
			"attribute_class"	"turn_gey"
			"attribute_name"	"Hidden Turn Player Gay"
			"min_value"	"1"
			"max_value"	"1"
			"group"	"only_on_unique"
			"description_string"	""
			"description_format"	"value_is_additive"
			"hidden"	"1"
			"effect_type"	"neutral"
			"stored_as_integer"	"0"
		}
		"702"
		{
			"name"	"owner receives minicrits"
			"attribute_class"	"owner_receive_minicrits"
			"attribute_name"	"Owner Receives Minicrits"
			"min_value"	"1"
			"max_value"	"1"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_Owner_Receives_Minicrits"
			"description_format"	"value_is_additive"
			"hidden"	"0"
			"effect_type"	"negative"
			"stored_as_integer"	"0"
		}
		"703"
		{
			"name"	"crit vs noclippers"
			"attribute_class"	"mod_crit_noclip"
			"attribute_name"	"Crit Vs Noclippers"
			"min_value"	"1"
			"max_value"	"1"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_CritVsNoclip"
			"description_format"	"value_is_additive"
			"hidden"	"0"
			"effect_type"	"positive"
			"stored_as_integer"	"0"
		}
		"704"
		{
			"name"	"mod enable crotchshots"
			"attribute_class"	"mod_enable_crotchshots"
			"attribute_name"	"Mod Enable Crotchshots"
			"min_value"	"1"
			"max_value"	"1"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_EnableCrotchshots"
			"description_format"	"value_is_additive"
			"hidden"	"0"
			"effect_type"	"positive"
			"stored_as_integer"	"0"
		}
		"705"
		{
			"name"	"milk duration"
			"attribute_class"	"milk_duration"
			"attribute_name"	"Milk Duration"
			"min_value"	"1"
			"max_value"	"4"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_MilkDuration"
			"description_format"	"value_is_additive"
			"hidden"	"0"
			"effect_type"	"positive"
			"armory_desc"	"on_hit milk"
			"stored_as_integer"	"0"
		}
		"706"
		{
			"name"	"bouncy grenades"
			"attribute_class"	"set_grenade_mode"
			"attribute_name"	"Bouncy Grenades"
			"min_value"	"1"
			"max_value"	"1"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_BouncyGrenades"
			"description_format"	"value_is_additive"
			"hidden"	"0"
			"effect_type"	"positive"
			"stored_as_integer"	"0"
		}
		"707"
		{
			"name"	"radial heal on hit"
			"attribute_class"	"radial_onhit_addhealth"
			"attribute_name"	"Radial Heal On Hit"
			"min_value"	"1"
			"max_value"	"30"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_RadialHealOnHit"
			"description_format"	"value_is_additive"
			"hidden"	"0"
			"effect_type"	"positive"
			"stored_as_integer"	"0"
		}
		"708"
		{
			"name"	"dmg taken from fall reduced"
			"attribute_class"	"mult_dmgtaken_from_fall"
			"attribute_name"	"Minor fall damage reduced"
			"min_value"	"0.95"
			"max_value"	"0.9"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_DmgTaken_From_Fall_Reduced"
			"description_format"	"value_is_inverted_percentage"
			"hidden"	"0"
			"effect_type"	"positive"
			"armory_desc"	"on_wearer"
			"stored_as_integer"	"0"
		}
		"709"
		{
			"name"	"dmg taken from fall increased"
			"attribute_class"	"mult_dmgtaken_from_fall"
			"attribute_name"	"Minor fall damage increased"
			"min_value"	"1.05"
			"max_value"	"1.25"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_DmgTaken_From_Fall_Increased"
			"description_format"	"value_is_percentage"
			"hidden"	"0"
			"effect_type"	"negative"
			"armory_desc"	"on_wearer"
			"stored_as_integer"	"0"
		}
		"710"
		{
			"name"	"dmg taken from physics reduced"
			"attribute_class"	"mult_dmgtaken_from_phys"
			"attribute_name"	"Minor physics damage reduced"
			"min_value"	"0.95"
			"max_value"	"0.9"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_DmgTaken_From_Phys_Reduced"
			"description_format"	"value_is_inverted_percentage"
			"hidden"	"0"
			"effect_type"	"positive"
			"armory_desc"	"on_wearer"
			"stored_as_integer"	"0"
		}
		"711"
		{
			"name"	"dmg taken from physics increased"
			"attribute_class"	"mult_dmgtaken_from_phys"
			"attribute_name"	"Minor physics damage increased"
			"min_value"	"1.05"
			"max_value"	"1.25"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_DmgTaken_From_Phys_Increased"
			"description_format"	"value_is_percentage"
			"hidden"	"0"
			"effect_type"	"negative"
			"armory_desc"	"on_wearer"
			"stored_as_integer"	"0"
		}
		"712"
		{
			"name"	"jump height bonus"
			"attribute_class"	"mult_player_jumpheight"
			"attribute_name"	"Minor jump height bonus"
			"min_value"	"1.05"
			"max_value"	"1.25"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_JumpHeight_Bonus"
			"description_format"	"value_is_percentage"
			"hidden"	"0"
			"effect_type"	"positive"
			"armory_desc"	"on_wearer"
			"stored_as_integer"	"0"
		}
		"713"
		{
			"name"	"jump height penalty"
			"attribute_class"	"mult_player_jumpheight"
			"attribute_name"	"Minor jump height penalty"
			"min_value"	"0.95"
			"max_value"	"0.9"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_JumpHeight_Bonus"
			"description_format"	"value_is_inverted_percentage"
			"hidden"	"0"
			"effect_type"	"negative"
			"armory_desc"	"on_wearer"
			"stored_as_integer"	"0"
		}
		"714"
		{
			"name"	"charge is unstoppable"
			"attribute_class"	"set_charge_mode"
			"attribute_name"	"Charge is unstoppable"
			"min_value"	"1"
			"max_value"	"1"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_Charge_Is_Unstoppable"
			"description_format"	"value_is_additive"
			"hidden"	"0"
			"effect_type"	"positive"
			"armory_desc"	"on_wearer"
			"stored_as_integer"	"0"
		}
		"715"
		{
			"name"	"cooldown rate penalty"
			"attribute_class"	"mult_cooldown_time"
			"attribute_name"	"Cooldown rate penalty"
			"min_value"	"1.2"
			"max_value"	"1.5"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_Charge_Rate_Reduced"
			"description_format"	"value_is_percentage"
			"hidden"	"0"
			"effect_type"	"negative"
			"armory_desc"	"on_wearer"
			"stored_as_integer"	"0"
		}
		"716"
		{
			"name"	"cooldown rate bonus"
			"attribute_class"	"mult_cooldown_time"
			"attribute_name"	"Cooldown rate bonus"
			"min_value"	"0.95"
			"max_value"	"0.9"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_Charge_Rate_Increased"
			"description_format"	"value_is_inverted_percentage"
			"hidden"	"0"
			"effect_type"	"positive"
			"armory_desc"	"on_wearer"
			"stored_as_integer"	"0"
		}
		"717"
		{
			"name"	"burn duration"
			"attribute_class"	"burn_duration"
			"attribute_name"	"Burn Duration"
			"min_value"	"1"
			"max_value"	"4"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_BurnDuration"
			"description_format"	"value_is_additive"
			"hidden"	"0"
			"effect_type"	"positive"
			"armory_desc"	"on_hit burn"
			"stored_as_integer"	"0"
		}
		"718"
		{
			"name"	"heavy rockets"
			"attribute_class"	"set_weapon_mode"
			"attribute_name"	"Heavy Rockets"
			"min_value"	"1"
			"max_value"	"1"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_Rocket_Gravity"
			"description_format"	"value_is_additive"
			"hidden"	"0"
			"effect_type"	"neutral"
			"stored_as_integer"	"0"
		}
		
		"1111"
		{
			"name"	"nuclear payload launcher"
			"attribute_class"	"nuke"
			"attribute_name"	"Nuclear Payload Launcher"
			"min_value"	"1"
			"max_value"	"1"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_Shoots_Nukes"
			"description_format"	"value_is_additive"
			"hidden"	"0"
			"effect_type"	"positive"
			"stored_as_integer"	"0"
		}
		"1112"
		{
			"name"	"stout shako launcher"
			"attribute_class"	"projectile_model_mod"
			"attribute_name"	"Stout Shako Launcher"
			"min_value"	"1"
			"max_value"	"1"
			"group"	"only_on_unique"
			"description_string"	"#Attrib_StoutShako_Launcher"
			"description_format"	"value_is_additive"
			"hidden"	"0"
			"effect_type"	"neutral"
			"stored_as_integer"	"0"
		}
	}
	"item_sets"
	{
		"secret_demo"
		{
			"name"	"#TF_Set_Demopan_Trader"
			"secret"	"1"
			"items"
			{
				"The Chargin' Targe"	"1"
				"Frying Pan"			"1"
				"Treasure Hat 1"		"1"
				"TTG Glasses"			"1"
			}
			"attributes"
			{
				"stout shako launcher"
				{
					"attribute_class"	"projectile_model_mod"
					"value"	"1"
				}
			}
		}
		"secret_soldier"
		{
			"name"	"#TF_Set_Worms_Kit"
			"secret"	"1"
			"items"
			{
				"The Bazooka"			"1"
				"The Equalizer"			"1"
				"Worms Gear"			"1"
			}
			"attributes"
			{
				"todo"
				{
					"attribute_class"	"todo"
					"value"	"1"
				}
			}
		}
	}
	"attribute_controlled_attached_particles"
	{
	}
}
]]

-- Attributes
local function VALID(e)			return IsValid(e) end
local function ISPLAYER(e)		return VALID(e) and e:IsTFPlayer() end
local function ONFIRE(e)		return VALID(e) and e:HasPlayerState(PLAYERSTATE_ONFIRE) end
local function ISBUILDING(e)	return VALID(e) and (not e:IsTFPlayer() or e:IsBuilding()) end

DF_GEY=128

desired = CreateClientConVar("wear_desired", "0", {FCVAR_CLIENTDLL}, "What wear type do you desire the most?")
sounds = CreateClientConVar("wear_sounds", "0", {FCVAR_CLIENTDLL}, "Do you want to hear sounds when you achieve something?")
lines = CreateClientConVar("wear_lines", "0", {FCVAR_CLIENTDLL}, "What to see messages alongside wear type?")

function PrintSkin()
	if desired:GetInt() == 0 and lines:GetInt() >= 2 then
		wear_strings = { 
			'Factory New. Well done!',
			'Minimal Wear. Few scratches, no jiffy.',
			'Feild Tested. Its good enough.',
			'Well Worn. This looks beat up!',
			'Battle Scarred. This looks like a car crash in slow motion!'
		}
	else
		wear_strings = { 
			'Factory New.',
			'Minimal Wear.',
			'Feild Tested.',
			'Well Worn.',
			'Battle Scarred.'
		}
	end

	if desired:GetInt() == 0 then
		wear_sounds = { 
			'misc/achievement_earned.wav',
			'misc/happy_birthday.wav',
			'misc/boring_applause_1.wav',
			'misc/clap_single_2.wav',
			'misc/hologram_stop.wav'
		}
	end
	
	if CLIENT then
		timer.Simple(0.02, function() if lines:GetInt() >= 1 then chat.AddText( Color(255,255,255), LocalPlayer(), " Your ", weapon_name:GetFullName() ," is ", Color( 100, 255, 100 ), wear_strings[wear_number]) end end)
		if desired:GetInt() == 0 and sounds:GetInt() >= 1 then surface.PlaySound(wear_sounds[wear_number]) end
	end
end

RegisterAttribute("material_override", {
	equip = function(v,weapon,owner)
		//weapon.CustomColorOverride = Color(255,30,150,255)
		if SERVER then
			weapon.CustomMaterialOverride = v
		else
			weapon.CustomMaterialOverride = Material(v)
		end
		
		if CLIENT then
			weapon.DrawWorldModel0 = weapon.DrawWorldModel
			weapon.DrawWorldModel = function(self,t)
				//render.SetColorModulation(1,0.2,0.7)
				if (IsValid(self.FakeWorldModel)) then
					self.FakeWorldModel:SetMaterial(v)
				end
				self:SetMaterial(v)
				self:DrawWorldModel0(t)
				//render.SetColorModulation(1,1,1)
			end
			
			weapon.ViewModelDrawn0 = weapon.ViewModelDrawn
			weapon.ViewModelDrawn = function(self,t)
				//render.SetColorModulation(1,0.2,0.7)
				if IsValid(self.CModel) then
					self.CModel:SetMaterial(v)
				end
				self:ViewModelDrawn0()
				//render.SetColorModulation(1,1,1)
			end
		end
		
	end,
})

RegisterAttribute("material_override_team", {
	equip = function(v,weapon,owner)
	if owner:Team() == 2 then
		team_skin = "_blue"
	else
		team_skin = "_red"
	end
		if SERVER then
			weapon.CustomMaterialOverride = v..team_skin
		else
			weapon.CustomMaterialOverride = Material(v..team_skin)
		end
		
		if CLIENT then
			weapon.DrawWorldModel0 = weapon.DrawWorldModel
			weapon.DrawWorldModel = function(self,t)
				self:SetMaterial(v..team_skin)
				if (IsValid(self.FakeWorldModel)) then
					self.FakeWorldModel:SetMaterial(v..team_skin)
				end
				self:DrawWorldModel0(t)
			end
			
			weapon.ViewModelDrawn0 = weapon.ViewModelDrawn
			weapon.ViewModelDrawn = function(self,t)
				if IsValid(self.CModel) then
					self.CModel:SetMaterial(v..team_skin)
				end
				self:ViewModelDrawn0()
			end
		end
		
	end,
})

RegisterAttribute("material_override_skin", {
	equip = function(v,weapon,owner)
		wear_types = { 
			'_factory_new_red',
			'_minimal_wear_red',
			'_feild_tested_red',
			'_well_worn_red',
			'_battle_scarred_red'
		}
		if desired:GetInt() >= 1 and desired:GetInt() <= 5 then
			wear_number = GetConVar("wear_desired"):GetInt()
		else
			wear_number = math.random( #wear_types )
		end
		
		if SERVER then
			weapon.CustomMaterialOverride = v..wear_types[wear_number]
		else
			weapon.CustomMaterialOverride = Material(v..wear_types[wear_number])
		end
		
		if CLIENT then
			weapon.DrawWorldModel0 = weapon.DrawWorldModel
			weapon.DrawWorldModel = function(self,t)
				self:SetMaterial(v..wear_types[wear_number])
				self:DrawWorldModel0(t)
			end
			
			weapon.ViewModelDrawn0 = weapon.ViewModelDrawn
			weapon.ViewModelDrawn = function(self,t)
				if IsValid(self.CModel) then
					self.CModel:SetMaterial(v..wear_types[wear_number])
				end
				self:ViewModelDrawn0()
			end
		end
		timer.Simple(0.02, function() weapon_name = weapon end)
		PrintSkin()
	end,
})

RegisterAttribute("material_override_skin_team", {
	equip = function(v,weapon,owner)
	if owner:Team() == 2 then
		wear_types = { 
			'_factory_new_blue',
			'_minimal_wear_blue',
			'_feild_tested_blue',
			'_well_worn_blue',
			'_battle_scarred_blue'
		}
	else
		wear_types = { 
			'_factory_new_red',
			'_minimal_wear_red',
			'_feild_tested_red',
			'_well_worn_red',
			'_battle_scarred_red'
		}
	end
		if desired:GetInt() >= 1 and desired:GetInt() <= 5 then
			wear_number = GetConVar("wear_desired"):GetInt()
		else
			wear_number = math.random( #wear_types )
		end
	
		if SERVER then
			weapon.CustomMaterialOverride = v..wear_types[wear_number]
		else
			weapon.CustomMaterialOverride = Material(v..wear_types[wear_number])
		end
		
		if CLIENT then
			weapon.DrawWorldModel0 = weapon.DrawWorldModel
			weapon.DrawWorldModel = function(self,t)
				if (IsValid(self.FakeWorldModel)) then
					self.FakeWorldModel:SetMaterial(v..wear_types[wear_number])
				end
				self:SetMaterial(v..wear_types[wear_number])
				self:DrawWorldModel0(t)
			end
			
			weapon.ViewModelDrawn0 = weapon.ViewModelDrawn
			weapon.ViewModelDrawn = function(self,t)
				if IsValid(self.CModel) then
					self.CModel:SetMaterial(v..wear_types[wear_number])
				end
				self:ViewModelDrawn0()
			end
		end	
		timer.Simple(0.02, function() weapon_name = weapon end)
		PrintSkin()
	end,
})

RegisterAttribute("nuke", {
	projectile_fired = function(v,proj,weapon,owner)
		proj.Nuke = true
	end,
	
	post_damage = function(v,ent,hitgroup,dmginfo)
		dmginfo:ScaleDamage(5)
	end,
})

RegisterAttribute("owner_receive_minicrits", {
	equip = function(v,weapon,owner)
		if SERVER then
			owner.TempAttributes.ReceiveCrits = true
		end
	end,
})

RegisterAttribute("mod_crit_noclip", {
	boolean = true,
	crit_override = function(v,ent,hitgroup,dmginfo)
		if ISPLAYER(ent) and ent:GetMoveType()==MOVETYPE_NOCLIP then return true end
	end,
})

RegisterAttribute("mod_enable_crotchshots", {
	boolean = true,
	
	crit_override = function(v,ent,hitgroup,dmginfo)
		if SERVER and ISPLAYER(ent) then
			local inf, att = dmginfo:GetInflictor(), dmginfo:GetAttacker()
			
			if inf.NonCrotchshotNameOverride == nil then
				inf.NonCrotchshotNameOverride = inf.NameOverride or false
			end
			
			if not inf.NonCrotchshotNameOverride then
				inf.NameOverride = nil
			else
				inf.NameOverride = inf.NonCrotchshotNameOverride
			end
			
			-- Weapon must be a sniper-type weapon (Sniper Rifle or Ambassador)
			if inf.IsTFWeapon and inf.BulletSpread == 0 and (inf.ChargeTimerStart or inf.CritsOnHeadshot) then
				local f1, f2 = ent:GetAngles(), att:GetAngles()
				f1.p = 0
				f2.p = 0
				local dot = f1:Forward():Dot(f2:Forward())
				
				-- Attacker and victim must be facing each other
				if dot > -0.5 then return end
				
				-- Pelvis bone check
				local bone
				bone = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_Pelvis") or ent:LookupBone("bip_pelvis") or -1)
				
				local dist = dmginfo:GetDamagePosition():Distance(bone:GetTranslation() - 3 * vector_up + 6*ent:GetForward())
				
				if dist < 8 then
					inf.NameOverride = "crotchshot"
					return true
				end
			end
		end
	end,
})

RegisterAttribute("milk_duration", {
	pre_damage = function(v,ent,hitgroup,dmginfo)
		local inf = dmginfo:GetInflictor()
		if inf:GetClass() == "tf_weapon_sniperrifle" and inf.ChargeTime then
			if not inf.ChargeTimerStart or (CurTime()-inf.ChargeTimerStart)/inf.ChargeTime < 0.25 then
				return
			end
		end
		
		local att = dmginfo:GetAttacker()
		if ent:IsTFPlayer() and ent~=att and ent:CanReceiveCrits() and att:IsValidEnemy(ent) then
			ent:AddPlayerState(PLAYERSTATE_MILK, true)
			ent.NextEndMilk = CurTime() + v
		end
	end,
	
	equip = function(v,weapon,owner)
		weapon.UsesJarateChargeMeter = true
	end,
})

RegisterAttribute("burn_duration", {
	pre_damage = function(v,ent,hitgroup,dmginfo)
		local att = dmginfo:GetAttacker()
		if ent:IsFlammable() and att:IsValidEnemy(ent) then
			GAMEMODE:IgniteEntity(ent, dmginfo:GetInflictor(), dmginfo:GetAttacker(), v)
		end
	end,
})

RegisterAttribute("set_grenade_mode", {
	equip = function(v,weapon,owner)
		weapon.GrenadeMode = v
	end,
	projectile_fired = function(v,proj,weapon,owner)
		proj.GrenadeMode = v
	end,
})

RegisterAttribute("projectile_model_mod", {
	equip = function(v,weapon,owner)
		owner.TempAttributes.ProjectileModelModifier = v
	end,
})


RegisterAttribute("radial_onhit_addhealth", {
	post_damage = function(v,ent,hitgroup,dmginfo)
		local att = dmginfo:GetAttacker()
		local pos = dmginfo:GetDamagePosition()
		
		if IsValid(att) and ent~=att and ent:IsTFPlayer() and ent:Health()>0 and not ent:IsBuilding() then
			for _,p in pairs(ents.FindInSphere(pos, 250)) do
				if p:IsTFPlayer() and not p:IsBuilding() and p:Health()>0 and p:EntityTeam()==att:EntityTeam() then
					GAMEMODE:HealPlayer(att, p, v, true, false)
				end
			end
		end
	end,
	projectile_fired = function(v,proj,weapon,owner) end,
})

RegisterAttribute("mult_dmgtaken_from_fall", {
	_global_post_damage_received = function(v,pl,hitgroup,dmginfo)
		if dmginfo:IsDamageType(DMG_FALL) then
			dmginfo:ScaleDamage(v)
		end
	end,
})

RegisterAttribute("mult_dmgtaken_from_phys", {
	_global_post_damage_received = function(v,pl,hitgroup,dmginfo)
		if dmginfo:IsDamageType(DMG_CRUSH) then
			dmginfo:ScaleDamage(v)
		end
	end,
})

RegisterAttribute("mult_player_jumpheight", {
	equip = function(v,weapon,owner)
		if SERVER then
			owner.PlayerJumpPower = owner.PlayerJumpPower * v
			owner:SetJumpPower(owner.PlayerJumpPower)
		end
	end,
})

RegisterAttribute("set_charge_mode", {
	boolean = true,
	equip = function(v,weapon,owner)
		if SERVER then
			owner.TempAttributes.ChargeIsUnstoppable = true
		end
	end,
})

RegisterAttribute("mult_cooldown_time", {
	equip = function(v,weapon,owner)
		if SERVER then
			owner.TempAttributes.ChargeCooldownMultiplier = (owner.TempAttributes.ChargeCooldownMultiplier or 1) * v
		end
	end,
})

if SERVER then

hook.Add("ShouldMiniCrit", "GAYPLAYER_MINICRIT", function(ent, inf, att, hitgroup, dmginfo)
	if ent.TempAttributes and ent.TempAttributes.ReceiveCrits then
		return true
	end
end)

hook.Add("PostScaleDamage", "GAYPLAYER_NEGDAMAGE", function(ent, hitgroup, dmginfo)
	if ent:IsTFPlayer() then
		if dmginfo:GetAttacker():GetNWBool("VeryGay") and math.random()<0.5 then
			GAMEMODE:HealPlayer(nil, ent, dmginfo:GetDamage(), true, false)
			dmginfo:SetDamage(0)
			dmginfo:SetDamageType(DMG_GENERIC)
		end
	end
end)
-- wtf?
hook.Add("DoPlayerDeath", "GAYREMOVE", function(pl,attacker,dmginfo)
	if CLIENT then
		timer.Simple(2.0, function()
		
			if (attacker:EntIndex() != pl:EntIndex() and attacker:IsTFPlayer()) then
				ply:SendLua('RunConsoleCommand("snd_soundmixer","Default_Mix")')
			end
			
		end)
	end
	pl:SetNWBool("VeryGay", false)
	pl.NextEndGay = 0
end)

end

if CLIENT then

hook.Add("SetupPlayerGib", "GEYGIB", function(pl, gib)
	if pl:HasDeathFlag(DF_GEY) then
		gib:SetMaterial("models/shiny")
		gib:SetColor(255,30,150,255)
	end
end)

hook.Add("SetupPlayerRagdoll", "GEYRAGDOLL_PLAYER", function(pl, rag)
	if pl:HasDeathFlag(DF_GEY) then
		rag:SetMaterial("models/shiny")
		rag:SetColor(255,30,150,255)
		for i=0,rag:GetPhysicsObjectCount()-1 do
			local p=rag:GetPhysicsObjectNum(i)
			p:SetMaterial("gmod_bouncy")
			p:ApplyForceCenter(Vector(0,0,math.Rand(2000,8000)))
			timer.Simple(0.1,function() if p and p:IsValid() then p:AddAngleVelocity(Vector(math.Rand(-100000,100000),math.Rand(-100000,100000),math.Rand(-100000,100000))) end end)
			p:SetMass(math.Rand(10,200))
		end
		rag.Gey=true
		pl.GeyRagdoll = rag
		local effectdata = EffectData()
		effectdata:SetEntity(pl)
		util.Effect("tf_rainbow_trail", effectdata)
	end
end)

hook.Add("SetupNPCRagdoll", "GEYRAGDOLL_NPC", function(npc, rag)
	if npc:HasDeathFlag(DF_GEY) then
		rag:SetMaterial("models/shiny")
		rag:SetColor(255,30,150,255)
		for i=0,rag:GetPhysicsObjectCount()-1 do
			local p=rag:GetPhysicsObjectNum(i)
			p:SetMaterial("gmod_bouncy")
			p:ApplyForceCenter(Vector(0,0,math.Rand(2000,8000)))
			p:SetMass(math.Rand(10,400))
			p:AddAngleVelocity(Vector(math.Rand(-10000,10000),math.Rand(-10000,10000),math.Rand(-10000,10000)))
		end
		rag.Gey=true
		npc.GeyRagdoll = rag
		local effectdata = EffectData()
		effectdata:SetEntity(npc)
		util.Effect("gayplayer", effectdata)
	end
end)

end

-- Loading everything up

tf_items.ParseGameItems(item_data)

MsgN("Done!")
