"items_game"
{
	"qualities"
	{
	}
	"items"
	{
		"10000032"
		{
			"name"	"Hidden Big Axe"
			"item_class"	"tf_weapon_sword"
			"craft_class"	"weapon"
			"capabilities"
			{
				"nameable"		"1"
				"can_modify_socket"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_Axe"
			"item_name"	"#TF_HalloweenBoss_Axe"
			"item_description"	"#TF_HalloweenBoss_Axe_Desc"
			"item_slot"	"melee"
			"item_quality"	"rarity4"
			"item_logname"	"headtaker"
			"item_iconname"	"headtaker"
			"propername"	"1"
			"min_ilevel"	"5"
			"max_ilevel"	"5"
			"image_inventory"	"backpack/weapons/c_models/c_headtaker/c_headtaker"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/weapons/c_models/c_bigaxe/c_bigaxe.mdl"
			"attach_to_hands"	"1"
			"used_by_classes"
			{
			}
			"visuals"
			{
				"sound_melee_miss"	"Weapon_Sword.Swing"
				"sound_melee_hit"	"Weapon_Sword.HitFlesh"
				"sound_melee_hit_world"	"Weapon_Sword.HitWorld"
				"sound_melee_burst"	"Weapon_Sword.SwingCrit"
				"sound_special1"	"Sword.Hit"
				"sound_special2"	"Sword.Idle"
			}
			"attributes"
			{
				"crit mod disabled"
				{
					"attribute_class"	"mult_crit_chance"
					"value"	"0"
				}
				"max health additive penalty"
				{
					"attribute_class"	"add_maxhealth"
					"value" "-25"
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
			}
			"mouse_pressed_sound"	"ui/item_knife_large_pickup.wav"
			"drop_sound"		"ui/item_metal_weapon_drop.wav"
		}
	}
	"attributes"
	{
	}
	"item_sets"
	{
	}
	"attribute_controlled_attached_particles"
	{
	}
}