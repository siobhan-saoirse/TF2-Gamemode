
"items_game"
{
	"qualities"
	{
	}
	"items"
	{
        "10000008"
		{
			"name"	"Brutal Bat"
			"item_class"	"tf_weapon_bat"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_Knife"
			"item_name"	"Brutal Bat"
			"item_slot"	"melee"
			"item_quality"	"unique"
			"propername"	"0"
			"min_ilevel"	"1"
			"max_ilevel"	"1"
			"item_logname"	"bat"
			"item_iconname"	"bat"
			"image_inventory"	"backpack/weapons/c_models/c_bat/c_nat"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"attach_to_hands" "1"
			"model_player"	"models/weapons/w_models/w_bat.mdl"
			"used_by_classes"
			{
				"scout"	"1"
			}
			"attributes"
			{
				"heal on kill"
				{
					"attribute_class"	"heal_on_kill"
					"value"	"25"
				}
				"damage bonus"
				{
					"attribute_class"	"mult_dmg"
					"value"	"1.1"
				}			
				"max health additive penalty"
				{
					"attribute_class"	"add_maxhealth"
					"value" "-10"
				}
				"hit self on miss"
				{
					"attribute_class"	"hit_self_on_miss"
					"value"	"1"
				}
			}			
			"mouse_pressed_sound"	"ui/item_knife_small_pickup.wav"
			"drop_sound"		"ui/item_light_gun_drop.wav"
		}
		"10000009"
		{
			"name"	"The Laser Rifle"
			"item_class"	"tf_weapon_sniperrifle"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_SniperRifle"
			"item_name"	"The Laser Rifle"
			"item_description"	"#TF_DEX_Rifle_Desc"
			"item_slot"	"primary"
			"item_quality"	"genuine"
			"image_inventory"	"backpack/weapons/c_models/c_dex_sniperrifle/c_dex_sniperrifle"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/weapons/w_models/w_sniperrifle.mdl"
			"min_ilevel"	"1"
			"max_ilevel"	"1"
			"attach_to_hands"	"1"
			"show_in_armory"	"1"
			"used_by_classes"
			{
				"sniper"	"1"
			}
			"visuals"
			{
				"sound_single_shot"	"Weapon_SniperRailgun_Large.Single"
				"sound_burst"		"Weapon_SniperRailgun_Large.SingleCrit"
				"muzzle_flash"	"muzzle_shotgun"
				"tracer_effect"	"sniper_dxhr_rail"	
			}
			"attributes"
			{			
				"damage penalty on bodyshot"
				{
					"attribute_class"	"bodyshot_damage_modify"
					"value" "-1"
				}
				"dmg taken from bullets increased"
				{
					"attribute_class"	"mult_dmgtaken_from_bullets"
					"value" "2"
				}
				"fire rate bonus"
				{
					"attribute_class"	"mult_postfiredelay"
					"value"		"1.10"
				}
				"crit mod disabled"
				{
					"attribute_class"	"mult_crit_chance"
					"value"	"0"
				}
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
        }
        
		"10000010"
		{
			"name"	"Scout's Shotgun"
			"item_class"	"tf_weapon_scattergun"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_Scattergun"
			"item_name"	"Scout's Shotgun"
			"item_logname"	"shotgun"
			"item_iconname"	"shotgun"
			"item_slot"	"primary"
			"item_quality"	"unique"
			"propername"	"0"
			"min_ilevel"	"10"
			"max_ilevel"	"10"
			"image_inventory"	"backpack/weapons/c_models/c_pep_scattergun"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/weapons/c_models/c_pep_scattergun.mdl"
			"attach_to_hands" "1"
			"used_by_classes"
			{
				"scout"	"1"
			}
			"attributes"
			{
				"bullets per shot bonus"
				{
					"attribute_class"	"mult_bullets_per_shot"
					"value" "3"
				}
				"clip size bonus"
				{
					"attribute_class"	"mult_clipsize"
					"value" "1.20"
				}
				"spread penalty"
				{
					"attribute_class"	"mult_spread_scale"
					"value" "1.60"
				}
				"damage penalty"
				{
					"attribute_class"	"mult_dmg"
					"value" "0.45"
				}
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
				"attrib_clip"	"1"
				"attrib_firerate" "1"
			}
			"visuals"
			{
				"sound_single_shot"	"Weapon_Scatter_Gun_Double.Single"
				"sound_burst"	"Weapon_Scatter_Gun_Double.SingleCrit"
				"muzzle_flash"	"muzzle_shotgun"
				"tracer_effect"	"bullet_bignasty_tracer01"
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
		}
		"10000011"
		{
			"name"	"Pyro's Flaming Shotgun"
			"item_class"	"tf_weapon_shotgun_pyro"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_Shotgun"
			"item_name"	"Pyro's Flaming Shotgun"
			"item_logname"	"shotgun"
			"item_iconname"	"shotgun"
			"item_slot"	"secondary"
			"item_quality"	"unique"
			"propername"	"0"
			"min_ilevel"	"10"
			"max_ilevel"	"10"
			"image_inventory"	"backpack/weapons/w_models/w_shotgun"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/weapons/c_models/c_shotgun/c_shotgun.mdl"
			"attach_to_hands" "0"
			"used_by_classes"
			{
				"pyro"	"1"
			}
			"attributes"
			{
				"Set DamageType Ignite"
				{
					"attribute_class"	"set_dmgtype_ignite"
					"value" "1"
				}		
				"minicrit vs burning player"
				{
					"attribute_class"	"or_minicrit_vs_playercond_burning"
					"value" "1"
				}
				"dmg taken from bullets increased"
				{
					"attribute_class"	"mult_dmgtaken_from_bullets"
					"value"	"1.1"
				}
				"crit mod disabled"
				{
					"attribute_class" "mult_crit_chance"
					"value"		"0"
				}
			}
			"visuals"
			{
				"sound_single_shot"	"Weapon_Scatter_Gun_Double.Single"
				"sound_burst"	"Weapon_Scatter_Gun_Double.SingleCrit"
				"muzzle_flash"	"muzzle_shotgun"
				"tracer_effect"	"bullet_bignasty_tracer01"
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
		}
        "10000012"
		{
			"name"	"Poison Knife"
			"item_class"	"tf_weapon_knife"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_Knife"
			"item_name"	"Poison Knife"
			"item_slot"	"melee"
			"item_quality"	"unique"
			"propername"	"0"
			"min_ilevel"	"1"
			"max_ilevel"	"1"
			"item_logname"	"eternal_reward"
			"item_iconname"	"eternal_reward"
			"image_inventory"	"backpack/weapons/w_models/w_knife"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"attach_to_hands" "1"
			"model_player"	"models/weapons/w_models/w_knife.mdl"
			"used_by_classes"
			{
				"spy"	"1"
			}
			"attributes"
			{
				"heal on kill"
				{
					"attribute_class"	"heal_on_kill"
					"value"	"25"
				}
				"damage bonus"
				{
					"attribute_class"	"mult_dmg"
					"value"	"1.1"
				}
				"health drain"
				{
					"attribute_class"	"add_health_regen"
					"value"	"-2"
				}
				"bleeding duration"
				{
					"attribute_class"	"bleeding_duration"
					"value" "5"
				}
			}		
			"visuals"
			{
				"animation"
				{
					"activity"		"ACT_VM_DRAW"
					"replacement"		"ACT_ITEM2_VM_DRAW"
				}
				"animation"
				{ 
					"activity"		"ACT_VM_IDLE"
					"replacement"		"ACT_ITEM2_VM_IDLE"
				}
				"animation"
				{
					"activity"		"ACT_VM_HITCENTER"
					"replacement"		"ACT_ITEM2_VM_HITCENTER"
				}
				"animation"
				{
					"activity"		"ACT_VM_SWINGHARD"
					"replacement"		"ACT_ITEM2_VM_SWINGHARD"
				}
			}		
			"mouse_pressed_sound"	"ui/item_knife_small_pickup.wav"
			"drop_sound"		"ui/item_light_gun_drop.wav"
        }

		"10000013"
		{
			"name"	"Pyro's Rocket Launcher"
			"item_class"	"tf_weapon_rocketlauncher"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_RocketLauncher"
			"item_name"	"Pyro's Rocket Launcher"
			"item_slot"	"primary"
			"anim_slot"	"item1"
			"item_quality"	"unique"
			"propername"	"0"
			"min_ilevel"	"1"
			"max_ilevel"	"1"
			"image_inventory"	"backpack/weapons/c_models/c_bet_rocketlauncher/c_bet_rocketlauncher"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/workshop/weapons/c_models/c_scorch_shot/c_scorch_shot.mdl"
			"attach_to_hands" "1"
			"used_by_classes"
			{
				"pyro"	"1"
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
			"visuals"
			{
				"muzzle_flash"	""
				"tracer_effect"	""
				"sound_special1"	"weapons\quake_explosion_remastered.wav"
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
        }
							
		"10000014"
		{
			"name"	"Classic Pistol"
			"item_class"	"tf_weapon_pistol"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_Pistol"
			"item_name"	"Classic Pistol"
			"item_description"	"#TF_TTG_MaxGun_Desc"
			"item_slot"	"secondary"
			"item_logname"	"maxgun"
			"item_iconname"	"maxgun"
			"image_inventory"	"backpack/workshop/weapons/c_models/c_ttg_max_gun/c_ttg_max_gun"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/workshop/weapons/c_models/c_ttg_max_gun/c_ttg_max_gun.mdl"
			"attach_to_hands"	"1"
			"show_in_armory"	"1"
			"item_quality"	"unique"
			"propername"	"0"
			"min_ilevel"	"5"
			"max_ilevel"	"5"
			"used_by_classes"
			{
				"scout"	"1"
				"engineer"	"1"
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
				"attrib_clip"	"1"
				"ammo_metal" "1"
            }

			"attributes"
			{
				"heal on kill"
				{
					"attribute_class"	"heal_on_kill"
					"value"	"25"
				}
				"damage penalty"
				{
					"attribute_class"	"mult_dmg"
					"value"	"0.9"
				}
                
				"clip size bonus"
				{
					"attribute_class"	"mult_clipsize"
					"value" "1.3"
				}
			}		
			"visuals"
			{
				"muzzle_flash"	"muzzle_pistol"
				"tracer_effect"	"bullet_tracer01"
			}
			"mouse_pressed_sound"	"ui/item_light_gun_pickup.wav"
			"drop_sound"		"ui/item_light_gun_drop.wav"
        }

		"10000015"
		{
			"name"	"Soldier's Flaming Shotgun"
			"item_class"	"tf_weapon_shotgun_pyro"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_Shotgun"
			"item_name"	"Soldier's Flaming Shotgun"
			"item_logname"	"shotgun"
			"item_iconname"	"shotgun"
			"item_slot"	"secondary"
			"item_quality"	"unique"
			"propername"	"0"
			"min_ilevel"	"10"
			"max_ilevel"	"10"
			"image_inventory"	"backpack/weapons/w_models/w_shotgun"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/weapons/c_models/c_shotgun/c_shotgun.mdl"
			"attach_to_hands" "1"
			"used_by_classes"
			{
				"soldier"	"1"
			}
			"attributes"
			{
				"Set DamageType Ignite"
				{
					"attribute_class"	"set_dmgtype_ignite"
					"value" "1"
				}		
				"minicrit vs burning player"
				{
					"attribute_class"	"or_minicrit_vs_playercond_burning"
					"value" "1"
				}
				"dmg taken from bullets increased"
				{
					"attribute_class"	"mult_dmgtaken_from_bullets"
					"value"	"1.1"
				}
				"crit mod disabled"
				{
					"attribute_class" "mult_crit_chance"
					"value"		"0"
				}
			}
			"visuals"
			{
				"sound_single_shot"	"Weapon_FrontierJustice.Single"
				"sound_burst"	"Weapon_FrontierJustice.SingleCrit"
				"muzzle_flash"	"muzzle_shotgun"
				"tracer_effect"	"bullet_bignasty_tracer01"
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
        }

		"10000016"
		{
			"name"	"Heavy's Hammer"
			"item_class"	"tf_weapon_allclass"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"item_logname"	"fireaxe"
			"item_iconname"	"fireaxe"
			"show_in_armory"	"1"
			"item_type_name"	"Heavy's Hammer"
			"item_name"	"Heavy's Hammer"
			"item_slot"	"melee"
			"image_inventory"	"backpack/player/items/all_class/all_pan"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/weapons/c_models/c_sledgehammer/c_sledgehammer.mdl"
			"attach_to_hands"	"1"
			"show_in_armory"	"1"
			"item_quality"	"unique"
			"propername"	"0"
			"min_ilevel"	"5"
			"max_ilevel"	"5"
			"used_by_classes"
			{
				"heavy"		"1"
			}
			"attributes"
			{
				"always tradable"
				{
					"attribute_class"	"always_tradable"
					"value"				"1"
				}		
				"minicrit vs wet player"
				{
					"attribute_class"	"or_minicrit_vs_playercond_burning"
					"value" "1"
                }
				"damage bonus"
				{
					"attribute_class"	"mult_dmg"
					"value"	"1.3"
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
			"visuals"
			{
				"sound_melee_hit"		"Weapon_Wrench.HitFlesh"
				"sound_melee_hit_world"	"Weapon_Wrench.HitWorld"
				"sound_melee_hit_mvm_robot" "Weapon_Wrench.HitFlesh"
			}			
			"mouse_pressed_sound"	"ui/item_metal_weapon_pickup.wav"
			"drop_sound"		"ui/item_metal_weapon_drop.wav"
        }
        	 
		"100000017"
		{
			"name"	"Pyro's Spy Checker 3000"
			"item_class"	"tf_weapon_flamethrower"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"item_logname"	"degreaser"
			"item_iconname"	"degreaser"
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_Flamethrower"
			"item_name"	"Pyro's Spy Checker 3000"
			"item_slot"	"primary"
			"image_inventory"	"backpack/weapons/c_models/c_flamethrower/c_flamethrower"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/weapons/c_models/c_flamethrower/c_flamethrower.mdl"
			"attach_to_hands"	"1"
			"show_in_armory"	"1"
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
				"crit vs wet player"
				{
					"attribute_class"	"crit_vs_wet_players"
					"value" "1"
                }	
				"crit vs burning player"
				{
					"attribute_class"	"or_crit_vs_playercond"
					"value" "1"
                }
				"damage bonus"
				{
					"attribute_class"	"mult_dmg"
					"value"	"1.3"
                }
				"heal on kill"
				{
					"attribute_class"	"heal_on_kill"
					"value"	"35"
                }	
				"max health additive penalty"
				{
					"attribute_class"	"add_maxhealth"
					"value" "-10"
				}	
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
			"item_set"	"polycount_pyro"
		}

		"10000018"
		{
			"name"	"Leadpipe"
			"item_class"	"tf_weapon_allclass"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"item_logname"	"kukri"
			"item_iconname"	"kukri"
			"show_in_armory"	"1"
			"item_type_name"	"Leadpipe"
			"item_name"	"Heavy's Hammer"
			"item_slot"	"melee"
			"image_inventory"	"backpack/player/items/all_class/all_pan"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/weapons/w_models/w_leadpipe.mdl"
			"attach_to_hands"	"0"
			"item_quality"	"unique"
			"propername"	"0"
			"min_ilevel"	"5"
			"max_ilevel"	"5"
			"used_by_classes"
			{
				"heavy"		"1"
			}
			"attributes"
			{
				"always tradable"
				{
					"attribute_class"	"always_tradable"
					"value"				"1"
				}		
				"minicrit vs wet player"
				{
					"attribute_class"	"or_minicrit_vs_playercond_burning"
					"value" "1"
                }
				"damage bonus"
				{
					"attribute_class"	"mult_dmg"
					"value"	"1.5"
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
			"visuals"
			{
				"sound_melee_hit"		"Weapon_Wrench.HitFlesh"
				"sound_melee_hit_world"	"Weapon_Shovel.HitWorld"
				"sound_melee_hit_mvm_robot" "Weapon_Wrench.HitFlesh"
			}			
			"mouse_pressed_sound"	"ui/item_metal_weapon_pickup.wav"
			"drop_sound"		"ui/item_metal_weapon_drop.wav"
        }

		"10000019"
		{
			"name"	"Heavy's Reserve Shooter"
			"first_sale_date"	"2011/03/23"
			"item_class"	"tf_weapon_shotgun_hwg"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
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
				"can_deal_mvm_peusermessageration_damage"	"1"
				"can_deal_long_distance_damage"	"1"
				"can_deal_taunt_damage"		"1"
			}
			"item_type_name"	"#TF_Weapon_Shotgun"
			"item_name"	"#TF_ReserveShooter"
			"item_slot"	"secondary"
			"item_logname"	"reserve_shooter"
			"item_iconname"	"reserve_kill"
			"show_in_armory"	"1"
			"item_quality"	"unique"
			"propername"	"0"
			"min_ilevel"	"10"
			"max_ilevel"	"10"
			"attach_to_hands"	"1"
			"show_in_armory"	"1"
			"image_inventory"	"backpack/workshop/weapons/c_models/c_reserve_shooter/c_reserve_shooter_large"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/weapons/c_models/c_reserve_shooter/c_reserve_shooter.mdl"
			"used_by_classes"
			{
				"heavy"	"1"
			}
			"visuals"
			{
				"sound_single_shot"	"Weapon_Reserve_Shooter.Single"
				"sound_burst"		"Weapon_Reserve_Shooter.SingleCrit"
				"muzzle_flash"	"muzzle_shotgun"
				"tracer_effect"	"bullet_shotgun_tracer01"
			}
			"attributes"
			{
				"clip size penalty"
				{
					"attribute_class"	"mult_clipsize"
					"value" "0.5"
				}
				"mod mini-crit airborne deploy"
				{
					"attribute_class"	"mini_crit_airborne_deploy"
					"value" "3"
				}
				"deploy time decreased"
				{
					"attribute_class"	"mult_deploy_time"
					"value"	"0.85"
				}
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
		}
		"10000020"
		{
			"name"	"Engineer's Reserve Shooter"
			"first_sale_date"	"2011/03/23"
			"item_class"	"tf_weapon_shotgun_primary"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
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
				"can_deal_mvm_peusermessageration_damage"	"1"
				"can_deal_long_distance_damage"	"1"
				"can_deal_taunt_damage"		"1"
			}
			"item_type_name"	"#TF_Weapon_Shotgun"
			"item_name"	"#TF_ReserveShooter"
			"item_slot"	"primary"
			"item_logname"	"reserve_shooter"
			"item_iconname"	"reserve_kill"
			"show_in_armory"	"1"
			"item_quality"	"unique"
			"propername"	"0"
			"min_ilevel"	"10"
			"max_ilevel"	"10"
			"attach_to_hands"	"1"
			"show_in_armory"	"1"
			"image_inventory"	"backpack/workshop/weapons/c_models/c_reserve_shooter/c_reserve_shooter_large"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/weapons/c_models/c_reserve_shooter/c_reserve_shooter.mdl"
			"used_by_classes"
			{
				"engineer"	"1"
			}
			"visuals"
			{
				"sound_single_shot"	"Weapon_Reserve_Shooter.Single"
				"sound_burst"		"Weapon_Reserve_Shooter.SingleCrit"
				"muzzle_flash"	"muzzle_shotgun"
				"tracer_effect"	"bullet_shotgun_tracer01"
			}
			"attributes"
			{
				"clip size penalty"
				{
					"attribute_class"	"mult_clipsize"
					"value" "0.5"
				}
				"mod mini-crit airborne deploy"
				{
					"attribute_class"	"mini_crit_airborne_deploy"
					"value" "3"
				}
				"deploy time decreased"
				{
					"attribute_class"	"mult_deploy_time"
					"value"	"0.85"
				}
			}
			"mouse_pressed_sound"	"ui/item_heavy_gun_pickup.wav"
			"drop_sound"		"ui/item_heavy_gun_drop.wav"
		}
		"10000021"
		{
			"name"			"Charger's Chargin' Targe"
			"item_class"		"tf_wearable_item_demoshield_l4d"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
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
		
		"10000022"
		{
			"name"	"Assault Cannon"
			"item_class"	"tf_weapon_minigun"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
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
			"show_in_armory"	"1"
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
			}
			"item_set"	"hibernating_bear"
		}
		"10000023"
		{
			"name"	"Spitfire"
			"item_class"	"tf_weapon_flaregun"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
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
			"show_in_armory"	"1"
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
		"10000024"
		{
			"name"	"Inside Jab"
			"item_class"	"tf_weapon_knife_sh"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
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
			"show_in_armory"	"1"
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
		"10000025"
		{
			"name"	"Viewfinder"
			"item_class"	"tf_weapon_sniperrifle"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
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
			"show_in_armory"	"1"
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
		"10000026"
		{
			"name"	"Handy Partner"
			"capabilities"
			{
				"nameable"		"1"
			}
			"craft_class"	"weapon"
			"show_in_armory"	"1"
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
				"pda_builds_minidispenser"
				{
					"attribute_class"	"pda_builds_minidispenser"
					"value" 	"1" 
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
		"10000028"
		{
			"name"	"Specialist"
			"first_sale_date"	"2014/12/22"
			"item_class"	"tf_weapon_scattergun"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
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
			"show_in_armory"	"1"
			"image_inventory"	"backpack/workshop/weapons/c_models/c_specialist_scattergun/c_specialist_scattergun"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/workshop/weapons/c_models/c_specialist_scattergun/c_specialist_scattergun.mdl"
			"used_by_classes"
			{
				"scout"	"1"
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
		"10000029"
		{
			"name"	"Deputy"
			"item_class"	"tf_weapon_revolver_engy"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_Revolver"
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
			"show_in_armory"	"1"
			"used_by_classes"
			{
				"engineer"	"1"
			}
			"mouse_pressed_sound"	"ui/item_light_gun_pickup.wav"
			"drop_sound"		"ui/item_light_gun_drop.wav"
		}
        	 
		"10000062"
		{
			"name"	"Afterburner"
			"item_class"	"tf_weapon_flamethrower"
			"craft_class"	"weapon"
			"show_in_armory"	"1"
			"capabilities"
			{
				"nameable"		"1"
				"can_gift_wrap" 	"1"
			}
			"item_logname"	"degreaser"
			"item_iconname"	"degreaser"
			"show_in_armory"	"1"
			"item_type_name"	"#TF_Weapon_Flamethrower"
			"item_name"	"Pyro's Spy Checker 3000"
			"item_slot"	"primary"
			"image_inventory"	"backpack/workshop/weapons/c_models/c_afterburner/c_degreaser"
			"image_inventory_size_w"		"128"
			"image_inventory_size_h"		"82"
			"model_player"	"models/workshop/weapons/c_models/c_afterburner/c_afterburner.mdl"
			"attach_to_hands"	"1"
			"show_in_armory"	"1"
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
				"deploy time increased"
				{
					"attribute_class"	"mult_deploy_time"
					"value"	"1.2"
				}		
			}
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