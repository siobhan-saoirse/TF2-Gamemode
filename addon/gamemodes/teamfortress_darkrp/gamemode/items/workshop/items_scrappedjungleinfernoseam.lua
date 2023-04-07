"items_game"
{
	"qualities"
	{
	}
	"items"
	{
		"9999999"
		{
			"name"	"Assault Cannon"
			"item_class"	"tf_weapon_minigun_assaultcannon"
			"craft_class"	"weapon"
			"capabilities"
			{
				"nameable"		"1"
				"can_modify_socket"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_Minigun"
			"item_name"	"Assault Cannon"
			"item_slot"	"primary"
			"item_logname"	"iron_curtain"
			"item_iconname"	"iron_curtain"
			"image_inventory"	"backpack/workshop/weapons/c_models/c_assault_minigun/c_assault_minigun"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/workshop/weapons/c_models/c_assault_minigun/c_assault_minigun.mdl"
			"attach_to_hands"	"1"
			"propername"	"0"
			"item_quality"	"unique"
			"min_ilevel"	"5"
			"max_ilevel"	"5"
			"used_by_classes"
			{
				"heavy"	"1"
			}
			"visuals"
			{
				"sound_deploy"	"Weapon_Gatling.Draw"
				"sound_reload"	"Weapon_Gatling.Reload"
				"sound_empty"	"Weapon_Gatling.ClipEmpty"
				"sound_double_shot"	"Weapon_Gatling.Fire"
				"sound_special1"	"Weapon_Gatling.WindUp"
				"sound_special2"	"Weapon_Gatling.WindDown"
				"sound_special3"	"Weapon_Gatling.Spin"
				"sound_burst"	"Weapon_Gatling.FireCrit"
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
			"attributes"
			{
				"damage bonus"
				{
					"attribute_class"	"mult_dmg"
					"value"	"1.20"
				}
				"aiming movespeed decreased"
				{
					"attribute_class"	"mult_player_aiming_movespeed"
					"value" "0.4"
				}
			}
			"item_set"	"hibernating_bear"
		}
		"10000000"
		{
			"name"	"Spitfire"
			"item_class"	"tf_weapon_flaregun"
			"craft_class"	"weapon"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_Flaregun"
			"item_name"	"Spitfire"
			"item_slot"	"secondary"
			"anim_slot"	"ITEM1"
			"image_inventory"	"backpack/workshop/weapons/c_models/c_pilot_flaregun/c_pilot_flaregun"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/workshop/weapons/c_models/c_pilot_flaregun/c_pilot_flaregun.mdl"
			"attach_to_hands"	"1"
			"item_quality"	"unique"
			"propername"	"0"
			"min_ilevel"	"10"
			"max_ilevel"	"10"
			"used_by_classes"
			{
				"pyro"	"1"
			}
			"attributes"
			{
				"hidden secondary max ammo penalty"
				{
					"attribute_class"	"mult_maxammo_secondary"
					"value"	"0.5"
				}
				"crit vs burning players"
				{
					"attribute_class"	"or_crit_vs_playercond"
					"value"	"1"
				}	
			}
			"allowed_attributes"
			{
				"all_items"	"1"
				"dmg_reductions" "1"
				"player_health" "1"
				"player_movement" "1"
				"attrib_dmgdone"	"1"
				"attrib_critboosts"	"1"
				"attrib_onhit_slow" "1"
				"attrib_firerate" "1"
				"wpn_ignites" "1"
				"ammo_secondary" "1"
			}
			"visuals"
			{
				"sound_single_shot"	"Weapon_Detonator.Fire"
				"sound_burst"	"Weapon_Detonator.Fire"
			}
			"mouse_pressed_sound"	"ui/item_light_gun_pickup.wav"
			"drop_sound"		"ui/item_light_gun_drop.wav"
		}
		"10000001"
		{
			"name"	"Inside Jab"
			"item_class"	"tf_weapon_knife_sh"
			"craft_class"	"weapon"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_Knife"
			"item_name"	"Inside Jab"
			"item_description"	"#TF_SharpDresser_Desc"
			"item_slot"	"melee"
			"item_quality"	"unique"
			"propername"	"0"
			"min_ilevel"	"1"
			"max_ilevel"	"1"
			"item_logname"	"sharp_dresser"
			"item_iconname"	"sharp_dresser"
			"image_inventory"	"backpack/workshop/weapons/c_models/c_pistol_knife/c_pistol_knife"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/workshop/weapons/c_models/c_pistol_knife/c_pistol_knife.mdl"
			"attach_to_hands"	"1"
			"item_set"	"polycount_spy"
			"used_by_classes"
			{
				"spy"	"1"
			}
			"anim_slot"	"ITEM1"
			"visuals"
			{
				"sound_melee_hit"	"Weapon_Revolver.Single"
				"animation_replacement"
				{
					"ACT_VM_DRAW"	"ACT_ITEM1_VM_DRAW"
					"ACT_VM_IDLE"	"ACT_ITEM1_VM_IDLE"
					"ACT_VM_HITCENTER"	"ACT_ITEM1_VM_HITCENTER"
					"ACT_VM_HITCENTER2"	"ACT_ITEM1_VM_HITCENTER2"
					"ACT_VM_SWINGHARD"	"ACT_ITEM1_VM_SWINGHARD"
					"ACT_BACKSTAB_VM_UP"	"ACT_ITEM1_BACKSTAB_VM_UP"
					"ACT_BACKSTAB_VM_DOWN"	"ACT_ITEM1_BACKSTAB_VM_DOWN"
					"ACT_BACKSTAB_VM_IDLE"	"ACT_ITEM1_BACKSTAB_VM_IDLE"
					"ACT_MELEE_VM_STUN"	"ACT_MELEE_VM_ITEM1_STUN"
					"ACT_MELEE_VM_INSPECT_START"	"ACT_ITEM1_VM_INSPECT_START"
					"ACT_MELEE_VM_INSPECT_IDLE"		"ACT_ITEM1_VM_INSPECT_IDLE"
					"ACT_MELEE_VM_INSPECT_END"		"ACT_ITEM1_VM_INSPECT_END"
				}
			}	
			"mouse_pressed_sound"	"ui/item_knife_small_pickup.wav"
			"drop_sound"		"ui/item_light_gun_drop.wav"
		}
		"10000002"
		{
			"name"	"Viewfinder"
			"item_class"	"tf_weapon_sniperrifle"
			"craft_class"	"weapon"
			"item_type_name"	"#TF_Weapon_SniperRifle"
			"item_name"	"#TF_DEX_Rifle"
			"item_description"	"#TF_DEX_Rifle_Desc"
			"item_slot"	"primary"
			"item_quality"	"genuine"
			"image_inventory"	"backpack/workshop/weapons/c_models/c_sniperrifle_tv/c_sniperrifle_tv"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/workshop/weapons/c_models/c_sniperrifle_tv/c_sniperrifle_tv.mdl"
			"min_ilevel"	"1"
			"max_ilevel"	"1"
			"attach_to_hands"	"1"
			"used_by_classes"
			{
				"sniper"	"1"
			}
			"visuals"
			{
				"sound_single_shot"	"Weapon_SniperRailgun.Single"
				"sound_burst"		"Weapon_SniperRailgun_Large.SingleCrit"
				"muzzle_flash"	"muzzle_shotgun"
				"tracer_effect"	"bullet_tracer01"	
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
		}	
		"10000003"
		{
			"name"	"Handy Partner"
			"capabilities"
			{
				"nameable"		"1"
			}
			"craft_class"	"weapon"
			"item_class"	"tf_weapon_pda_engineer_build"
			"craft_material_type"	"weapon"
			"item_name"	"Handy Partner"
			"item_type_name"	"#TF_Weapon_PDA_Engineer"
			"item_slot"	"pda"
			"item_quality"	"unique"
			"min_ilevel"	"1"
			"max_ilevel"	"99"
			"attach_to_hands" "1"
			"image_inventory"	"backpack/workshop/weapons/c_models/c_mini_dispenser_pda/c_mini_dispenser_pda"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/workshop/weapons/c_models/c_mini_dispenser_pda/c_mini_dispenser_pda.mdl"
			"used_by_classes"
			{
				"engineer"	"1"
			}
			"attributes"
			{
				"kill eater score type"
				{
					"attribute_class"	"kill_eater_score_type"
					"value" 	"3" 
				}
				"kill eater score type 2"
				{
					"attribute_class"	"kill_eater_score_type_2"
					"value" 	"59" 
				}
				"kill eater score type 3"
				{
					"attribute_class"	"kill_eater_score_type_3"
					"value" 	"60" 
				}
			}
			"mouse_pressed_sound"	"ui/item_metal_weapon_pickup.wav"
			"drop_sound"		"ui/item_metal_weapon_drop.wav"
			"visuals"
			{
				"animation_replacement"
				{
					"ACT_VM_IDLE"	"ACT_ENGINEER_PDA2_VM_IDLE"
					"ACT_VM_DRAW"	"ACT_ENGINEER_PDA2_VM_DRAW"
				}
			}
		}		
		"10000004"
		{
			"name"	"Afterburner"
			"item_class"	"tf_weapon_flamethrower_degreaser"
			"craft_class"	"weapon"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"item_logname"	"degreaser"
			"item_iconname"	"degreaser"
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_Flamethrower"
			"item_name"	"Afterburner"
			"item_slot"	"primary"
			"image_inventory"	"backpack/workshop/weapons/c_models/c_afterburner/c_degreaser"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/workshop/weapons/c_models/c_afterburner/c_afterburner.mdl"
			"attach_to_hands"	"1"
			"item_quality"	"unique"
			"propername"	"0"
			"min_ilevel"	"10"
			"max_ilevel"	"10"
			"used_by_classes"
			{
				"pyro"	"1"
			}
			"attributes"
			{
				"deploy time decreased"
				{
					"attribute_class"	"mult_deploy_time"
					"value"	"0.35"
				}
				"weapon burn dmg reduced"
				{
					"attribute_class"	"mult_wpn_burndmg"
					"value" "0.75"
				}
			}
			"visuals"
			{
				"sound_single_shot"	"Weapon_Degreaser.FireStart"
				"sound_special1"	"Weapon_Degreaser.FireLoop"
				"sound_burst"	"Weapon_Degreaser.FireLoopCrit"
				"sound_special3"	"Weapon_Degreaser.FireEnd"
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
			"item_set"	"polycount_pyro"
		}
		"10000005"
		{
			"name"	"Specialist"
			"first_sale_date"	"2014/12/22"
			"item_class"	"tf_weapon_scattergun"
			"craft_class"	"weapon"
			"craft_material_type"	"weapon"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
				"can_craft_count"	"1"
			}
			"tags"
			{
				"can_deal_damage"			"1"
				"can_be_equipped_by_soldier_or_demo"	"1"
				"can_deal_critical_damage"	"1"
				"can_deal_mvm_penetration_damage"	"1"
				"can_deal_long_distance_damage"	"1"
				"can_deal_taunt_damage"		"1"
			}
			"item_type_name"	"#TF_Weapon_Shotgun"
			"item_name"	"Specialist"
			"item_slot"	"primary"
			"item_logname"	"panic_attack"
			"item_iconname"	"panic_attack"
			"show_in_armory"	"1"
			"item_quality"	"unique"
			"propername"	"0"
			"min_ilevel"	"10"
			"max_ilevel"	"10"
			"attach_to_hands"	"1"
			"image_inventory"	"backpack/workshop/weapons/c_models/c_specialist_scattergun/c_specialist_scattergun"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/workshop/weapons/c_models/c_specialist_scattergun/c_specialist_scattergun.mdl"
			"used_by_classes"
			{
				"scout"	"0"
			}
			"visuals"
			{
				"sound_single_shot"	"weapons/tf2_backshot_shotty.wav"
				"sound_burst"		"weapons/tf2_backshot_shotty_crit.wav"
				"muzzle_flash"	"muzzle_shotgun"
				"tracer_effect"	"bullet_shotgun_tracer01"
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
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
		}
		"10000006"
		{
			"name"	"Deputy"
			"item_class"	"tf_weapon_revolver_engy"
			"craft_class"	"weapon"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_Pistol"
			"item_name"	"Deputy"
			"item_slot"	"secondary"
			"item_quality"	"unique"
			"propername"	"0"
			"min_ilevel"	"1"
			"max_ilevel"	"1"
			"item_logname"	"sharp_dresser"
			"item_iconname"	"sharp_dresser"
			"image_inventory"	"backpack/weapons/c_models/c_revolver/c_revolver"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/workshop/weapons/c_models/c_engy_revolver/c_engy_revolver.mdl"
			"attach_to_hands"	"1"
			"used_by_classes"
			{
				"engineer"	"1"
			}
			"mouse_pressed_sound"	"ui/item_light_gun_pickup.wav"
			"drop_sound"		"ui/item_light_gun_drop.wav"
		}

		
		"10000007"
		{
			"name"			"Charger Shield"
			"item_class"		"tf_wearable_item_demoshield_l4d"
			"craft_class"	"weapon"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"item_type_name" 	"#TF_Wearable_Shield"
			"item_name"		"#TF_Unique_Achievement_Shield"
			"item_description"	"#TF_Unique_Achievement_Shield_Desc"
			"item_slot"		"primary"
			"anim_slot"		"FORCE_NOT_USED"
			"item_quality"		"unique"
			"propername"	"0"
			"min_ilevel"		"10"
			"max_ilevel"		"10"
			"image_inventory"	"backpack/weapons/c_models/c_targe/c_targe"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/empty.mdl"
			"act_as_wearable" "1"
			"attach_to_hands"	"0"
			"attach_to_hands_vm_only"	"1"
			"drop_type"	"drop"
			"used_by_classes"
			{
				"charger"	"1"
			}
			"attributes"
			{
				"dmg taken from fire reduced"
				{
					"attribute_class"	"mult_dmgtaken_from_fire"
					"value"			"0.5"
				}
				"dmg taken from blast reduced"
				{
					"attribute_class"	"mult_dmgtaken_from_explosions"
					"value"			"0.6"
				}
			}
			"allowed_attributes"
			{
				"all_items"	"1"
				"dmg_reductions" "1"
				"player_health" "1"
				"attrib_healthregen" "1"
				"player_movement" "1"
			}
			"mouse_pressed_sound"	"ui/item_wood_pole_pickup.wav"
			"drop_sound"		"ui/item_wood_pole_drop.wav"
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