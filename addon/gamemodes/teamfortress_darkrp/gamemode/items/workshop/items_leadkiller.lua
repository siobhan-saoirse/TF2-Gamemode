"items_game"
{
	"qualities"
	{
	}
	"items"
	{
		"10000030"
		{
			"name"	"The PASSTIME Jack"
			"item_class"	"tf_weapon_passtime_gun"
			"craft_class"	"weapon"
			"capabilities"
			{
				"nameable"		"0"
				"can_gift_wrap" 	"0"
			}
			"show_in_armory"	"0"
			"item_type_name"	"#TF_Ball"
			"item_name"	"#TF_Ball"
			"item_slot"	"pda2"
			"image_inventory"	"passtime/hud/passtime_ball"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/passtime/ball/passtime_ball.mdl"
			"attach_to_hands"	"1"
			"anim_slot"	"item1"
			"item_quality"	"unusual"
			"propername"	"0"
			"min_ilevel"	"8"
			"max_ilevel"	"8"
			"used_by_classes"
			{
				"scout"		"1"
				"soldier"	"1"
				"pyro"		"1"
				"demoman"	"1"
				"heavy"		"1"
				"engineer"	"1"
				"medic"		"1"
				"sniper"	"1"
				"spy"		"1"
			}
			"attributes"
			{
				"always tradable"
				{
					"attribute_class"	"always_tradable"
					"value"				"1"
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
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
		}
		"10000031"
		{
			"name"	"Engie's Fist"
			"item_class"	"tf_weapon_engi_fist"
			"craft_class"	"weapon"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"0"
			"item_type_name"	"#TF_Weapon_Fists"
			"item_name"	"Engie's Fist"
			"item_slot"	"melee"
			"item_quality"	"unique"
			"anim_slot"	"item2"
			"min_ilevel"	"15"
			"max_ilevel"	"15"
			"propername"	"0"
			"item_logname"	"robot_arm"
			"item_iconname"	"robot_arm_kill"
			"image_inventory"	"backpack/weapons/v_models/v_fist_heavy"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"attach_to_hands" "1"
			"used_by_classes"
			{
				"engineer"	"1"
			}
			"attributes"
			{
				"crit mod disabled"
				{
					"attribute_class"	"mult_crit_chance"
					"value"	"0"
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
				"attrib_vs_burning" "1"
				"attrib_firerate" "1"
				"ammo_metal" "1"
				"only_on_wrench" "1"
			}
			"mouse_pressed_sound"	"ui/item_robot_arm_pickup.wav"
			"drop_sound"		"ui/item_robot_arm_drop.wav"
		}
	}
}