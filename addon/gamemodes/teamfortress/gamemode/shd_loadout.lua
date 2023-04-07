include("shd_items.lua")
--include("shd_workshop.lua")

tf_items.LoadGameItems("items_game.lua")
--
--==================================================
-- DIRECT FIXES
--==================================================

-- Fixes the Homewrecker sounding like an axe (now sounds more like a hammer) and cutting zombies in half
if file.Exists("gamemodes/teamfortress/gamemode/items/workshop/items_livetf2.lua","GAME") then
tf_items.ItemsByID[153].visuals = {}
tf_items.ItemsByID[153].visuals.sound_melee_miss = "Weapon_Wrench.Miss"
tf_items.ItemsByID[153].visuals.sound_melee_hit = "Weapon_Wrench.HitFlesh"
tf_items.ItemsByID[153].visuals.sound_melee_hit_world = "Weapon_Wrench.HitWorld"
tf_items.ItemsByID[153].visuals.sound_melee_burst = "Weapon_Wrench.MissCrit"

-- Same for the Powerjack
tf_items.ItemsByID[214].visuals = {}
tf_items.ItemsByID[214].visuals.sound_melee_miss = "Weapon_Wrench.Miss"
tf_items.ItemsByID[214].visuals.sound_melee_hit = "Weapon_Wrench.HitFlesh"
tf_items.ItemsByID[214].visuals.sound_melee_hit_world = "Weapon_Wrench.HitWorld"
tf_items.ItemsByID[214].visuals.sound_melee_burst = "Weapon_Wrench.MissCrit"

-- Fixes the Tribalman's Shiv doing metal impact sounds (it is actually wooden)
tf_items.ItemsByID[171].visuals = {}
tf_items.ItemsByID[171].visuals.sound_melee_hit_world = "Weapon_BaseballBat.HitWorld"

-- Missing killicons
tf_items.ItemsByID[308].item_iconname = "lochnload"
tf_items.ItemsByID[312].item_iconname = "gatling"
tf_items.ItemsByID[317].item_iconname = "candy_cane"
tf_items.ItemsByID[325].item_iconname = "boston_basher"
tf_items.ItemsByID[327].item_iconname = "claidheamohmor"
end

--==================================================
-- end of direct fixes
--==================================================

if CLIENT then

LoadoutPanelSlots = {
	scout		= {"primary"	, "secondary"	, "melee"	, "head"	, "misc"},
	soldier		= {"primary"	, "secondary"	, "melee"	, "head"	, "misc"},
	pyro		= {"primary"	, "secondary"	, "melee"	, "head"	, "misc"},
	demoman		= {"primary"	, "secondary"	, "melee"	, "head"	, "misc"},
	heavy		= {"primary"	, "secondary"	, "melee"	, "head"	, "misc"},
	engineer	= {"primary"	, "secondary"	, "melee"	, "head"	, "misc"},
	medic		= {"primary"	, "secondary"	, "melee"	, "head"	, "misc"},
	sniper		= {"primary"	, "secondary"	, "melee"	, "head"	, "misc"},
	spy			= {"secondary"	, "melee"		, "pda2"	, "head"	, "misc"}
}

-- Slot order:
-- primary, secondary, melee, pda, pda2, building, head, misc
-- use -1 for no item
DefaultPlayerLoadout = {
	scout		= {13	, 23	, 0		, -1	, -1	, -1	, -1	, -2	},
	soldier		= {18	, 10	, 6		, -1	, -1	, -1	, -1	, -2	},
	pyro		= {21	, 12	, 2		, -1	, -1	, -1	, -1	, -2	},
	demoman		= {20	, 19	, 1		, -1	, -1	, -1	, -1	, -2	},
	heavy		= {15	, 11	, 5		, -1	, -1	, -1	, -1	, -2	},
	engineer	= {9	, 22	, 7		, 25	, 26	, 28	, -1	, -2	},
	medic		= {17	, 29	, 8		, -1	, -1	, -1	, -1	, -2	},
	sniper		= {14	, 16	, 3		, -1	, -1	, -1	, -1	, -2	},
	spy			= {-1	, 24	, 4		, 27	, 30	, -1	, -1	, -2	},
}

end

-- penis

tf_items.AttributesByID[1337] = {
	id = 1337,
	name = "Have an erroR!",
	attribute_class = "have_an_error",
	attribute_name = "gey painis secks",
	min_value = 1,
	max_value = 1,
	description_string = "",
	description_format = "value_is_additive",
	hidden = 0,
	effect_type = "neutral"
}
tf_items.Attributes["Have an erroR!"] = tf_items.AttributesByID[1337]
