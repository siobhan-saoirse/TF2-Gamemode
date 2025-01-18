function GetKilliconData(name, highlight)
	local icon = Killicons["_images"]["d_skull"]
	local group = "_images"
	
	for k,v in pairs(Killicons) do
		if v[name] then
			icon = v[name]
			group = k
			break
		end
	end
	
	local path
	
	if string.sub(group, 1, 1)=="!" then 
		path = "HUD/"..string.sub(group, 2)
	else
		path = (highlight and ("HUD/dneg"..group)) or ("HUD/d"..group)
	end
	
	if highlight then
		return icon, Color(245, 229, 196, 200), path
	else
		return icon, Color(46, 43, 42, 220), path
	end
end

KilliconTranslate = {
-- HL2
weapon_pistol = "d_hl_pistol",
weapon_357 = "d_hl_357",
weapon_crossbow = "d_hl_crossbow",
weapon_smg1 = "d_hl_smg",
weapon_shotgun = "d_hl_shotgun",
weapon_ar2 = "d_hl_ar2",
weapon_crowbar = "d_hl_crowbar",
weapon_stunstick = "d_hl_stunstick",
weapon_rpg = "d_hl_rpg",
weapon_annabelle = "d_sniperrifle",
-- lua hl2
weapon_hl2_pistol = "d_hl_pistol",
weapon_hl2_357 = "d_hl_357",
weapon_hl2_crossbow = "d_hl_crossbow",
weapon_hl2_smg1 = "d_hl_smg",
weapon_hl2_shotgun = "d_hl_shotgun",
weapon_hl2_ar2 = "d_hl_ar2",
weapon_hl2_crowbar = "d_hl_crowbar",
weapon_hl2_stunstick = "d_hl_stunstick",
weapon_hl2_rpg = "d_hl_rpg",
weapon_hl2_annabelle = "d_sniperrifle",
-- L4D
weapon_l4d_smg = "d_hl_smg",
weapon_l4d_pistol = "d_hl_357",	
weapon_l4d_dual_pistol = "d_hl_357",	
weapon_l4d_rifle = "d_hl_smg",	
weapon_l4d_pumpshotgun = "d_hl_shotgun",
weapon_l4d_autoshotgun = "d_hl_shotgun",
-- Continue HL2	
crossbow_bolt = "d_hl_crossbow",
crossbow_bolt_deflect = "d_deflect_crossbowbolt",
rpg_missile = "d_hl_rpg",
rpg_missile_deflect = "d_deflect_rpg",
weapon_frag = "d_hl_frag",
m9k_proxy = "d_bomb_head",
npc_grenade_frag = "d_hl_frag",
npc_grenade_frag_deflect = "d_deflect_frag",
prop_combine_ball = "d_hl_combine_ball",
npc_headless_hatman = "d_headtaker",
prop_combine_ball_deflect = "d_deflect_combineball",
grenade_ar2 = "d_hl_ar2_grenade",
grenade_ar2_deflect = "d_deflect_ar2grenade",
grenade_spit = "d_hl_acidball",
grenade_spit_deflect = "d_deflect_acidball",
hunter_flechette = "d_hl_flechette",
simfphys_tankprojectile = "d_hl_rpg",

weapon_braaains = "d_hl_zombie",
weapon_cpt_spell_base = "d_hl_zombie",
player = "d_hl_zombie",
pill_puppet = "d_hl_zombie",
npc_zombie = "d_hl_zombie",
npc_zombie_torso = "d_hl_zombie",
npc_fastzombie = "d_hl_zombie",
npc_fastzombie_torso = "d_hl_zombie",
npc_poisonzombie = "d_hl_zombie",
npc_zombine = "d_hl_zombie",

tf_weapon_grapplinghook = "d_hl_crowbar",
tf_projectile_shortcircuit = "d_shortcircuit_ball",

npc_headcrab = "d_hl_headcrab",
npc_headcrab_fast = "d_hl_headcrab",
npc_headcrab_poison = "d_hl_headcrab",
npc_headcrab_black = "d_hl_headcrab",

npc_antlion = "d_hl_antlion",
npc_antlion_worker = "d_hl_antlion",
npc_antlion_worker_explosion = "d_hl_antworker_explosion",
npc_antlionguard = "d_hl_antlionguard",
tf_projectile_rocket_fireball = "d_dragons_fury",

npc_hunter = "d_hl_hunter_charge",
npc_hunter_pound = "d_hl_hunter_pound",
npc_hunter_skewer = "d_hl_hunter_skewer",

npc_vortigaunt_beam = "d_hl_vortigaunt_beam",
npc_vortigaunt = "d_hl_vortigaunt",

npc_helicopter = "d_hl_airboat_gun",
npc_combinegunship = "d_hl_airboat_gun",
npc_combinedropship = "d_hl_airboat_gun",
npc_strider_minigun = "d_hl_strider_minigun",
concussiveblast = "d_hl_strider_beam",
tf_weapon_superphyscannon = "d_hl_strider_beam",
npc_strider = "d_hl_strider_minigun",
rocketpack = "d_boot",

npc_rollermine = "d_hl_rollermine",
npc_manhack = "d_hl_manhack",
npc_turret_floor = "d_hl_floorturret",

have_an_error = "d_have_an_error",

-- Scout
tf_weapon_scattergun = "d_scattergun",
tf_weapon_pistol_scout = "d_pistol_scout",
tf_weapon_bat = "d_bat",
unarmed_combat = "d_hl_zombie",

-- Heavy
tf_weapon_minigun = "d_minigun",
tf_weapon_shotgun_hwg = "d_shotgun_hwg",
reserve_kill = "d_shotgun_hwg",
tf_weapon_fists = "d_fists",
weapon_fists = "d_fists",
weapon_hwg_boxinggloves = "d_gloves",
tf_weapon_minigun_tomislav = "d_tomislav",

-- Demoman
tf_projectile_pipe = "d_tf_projectile_pipe",
loose_cannon_explosion = "d_loose_cannon_explosion",
weapon_demo_scottishresistance = "d_sticky_resistance",
tf_projectile_pipe_remote = "d_tf_projectile_pipe_remote",
weapon_demo_quickielauncher = "d_tf_projectile_pipe_remote",
tf_projectile_pipe_defender = "d_sticky_resistance",
tf_projectile_pipe_round = "d_tf_projectile_pipe_remote",
tf_weapon_bottle = "d_bottle",
tf_weapon_sword = "d_sword",
tf_wearable_item_demoshield = "d_demoshield",

-- Soldier
tf_projectile_rocket = "d_tf_projectile_rocket",
monoculus = "d_monoculus",
tf_weapon_rocketlauncher = "d_taunt_scout",
tf_projectile_rocket_direct = "d_rocketlauncher_directhit",
tf_weapon_shotgun_soldier = "d_shotgun_soldier",
tf_weapon_shotgun = "d_shotgun_primary",
tf_weapon_shovel = "d_shovel",

-- Engineer
tf_weapon_shotgun_primary = "d_shotgun_primary",
tf_weapon_pistol = "d_pistol",
tf_weapon_wrench = "d_wrench",
obj_sentrygun = "d_obj_sentrygun",
npc_sentry_red = "d_obj_sentrygun",
npc_sentry_blue = "d_obj_sentrygun",
obj_sentrygun2 = "d_obj_sentrygun2",
obj_sentrygun3 = "d_obj_sentrygun3",
tf_projectile_sentryrocket = "d_obj_sentrygun3",

-- Pyro
tf_flame = "d_flamethrower",
tf_weapon_shotgun_pyro = "d_shotgun_pyro",
tf_weapon_fireaxe = "d_fireaxe",
tf_projectile_flare = "d_flaregun",

-- Medic
tf_projectile_syringe = "d_syringegun_medic",
tf_projectile_blutsauger = "d_blutsauger",
tf_weapon_bonesaw = "d_bonesaw",

-- Sniper
tf_weapon_sniperrifle = "d_sniperrifle",
tf_weapon_sniperrifle_headshot = "d_headshot",
tf_weapon_smg = "d_smg",
tf_weapon_club = "d_club",
tf_projectile_arrow = "d_huntsman",
tf_projectile_arrow_headshot = "d_huntsman_headshot",
tf_projectile_arrow_burning = "d_huntsman_burning",
tf_projectile_arrow_flyingburn = "d_huntsman_flyingburn",

-- Spy
tf_weapon_revolver = "d_revolver",
tf_weapon_knife = "d_knife",
tf_weapon_builder = "d_obj_attachment_sapper",
tf_weapon_knife_backstab = "d_backstab",
tf_weapon_ambassador_headshot = "d_ambassador_headshot",

-- Vehicles
prop_vehicle_jeep_old = "d_vehicle",
prop_vehicle_jeep = "d_vehicle",
prop_vehicle_airboat = "d_vehicle",
tf_wearable_item_demoshield_l4d = "d_vehicle",
gmod_sent_vehicle_fphysics_base = "d_vehicle",

-- Other
entityflame = "d_firedeath",
tf_entityflame = "d_firedeath",
env_fire	= "d_firedeath",
tf_entitybleed = "d_bleed_kill",
env_explosion = "d_explosion",
env_physexplosion = "d_explosion",
combine_mine = "d_hl_combine_mine",
weapon_l4d_first_aid_kit = "d_hl_combine_mine",
prop_physics = "d_hl_physics",

-- STOP MAKING THESE MOTHERFUCKING NEXTBOTS YOU FAHGET!!! (no homophobia, just mocking those idiots)
npc_obunga = "d_vehicle",
npc_quandale = "d_vehicle", 
npc_sanic = "d_vehicle", 
npc_lwsky = "d_mannpower_plague",
}

function TranslateKilliconName(name)
	return KilliconTranslate[name] or "d_"..name
end

function RegisterKillicon(name, texture, data)
	if not Killicons[texture] then Killicons[texture] = {} end
	Killicons[texture][name] = data
end

Killicons = {

["!leaderboard_dominated"] = {
d_domination={
	x=0,
	y=0,
	w=64,
	h=64,
},
},

["_images"]={
d_obj_sentrygun={
	x=96,
	y=160,
	w=64,
	h=32,
},
d_obj_sentrygun2={
	x=256,
	y=0,
	w=96,
	h=32,
},
d_obj_sentrygun3={
	x=256,
	y=32,
	w=96,
	h=32,
},
d_bat={
	x=0,
	y=0,
	w=96,
	h=32,
},
d_pistol={
	x=0,
	y=32,
	w=96,
	h=32,
},
d_pistol_scout={
	x=0,
	y=32,
	w=96,
	h=32,
},
d_nailgun={
	x=0,
	y=64,
	w=64,
	h=32,
},
d_sniperrifle={
	x=16,
	y=96,
	w=32,
	h=32,
},
d_smg={
	x=0,
	y=128,
	w=96,
	h=32,
},
d_club={
	x=0,
	y=160,
	w=96,
	h=32,
},
d_shovel={
	x=0,
	y=192,
	w=96,
	h=32,
},
d_tf_projectile_rocket={
	x=0,
	y=224,
	w=96,
	h=32,
},
d_tf_projectile_rocket_deflect={
	x=176,
	y=128,
	w=88,
	h=32,
},
d_shotgun_primary={
	x=0,
	y=256,
	w=96,
	h=32,
},
d_shotgun_soldier={
	x=0,
	y=256,
	w=96,
	h=32,
},
d_shotgun_hwg={
	x=0,
	y=256,
	w=96,
	h=32,
},
d_shotgun_pyro={
	x=0,
	y=256,
	w=96,
	h=32,
},
d_tf_projectile_pipe={
	x=0,
	y=288,
	w=96,
	h=32,
},
d_bottle={
	x=0,
	y=320,
	w=96,
	h=32,
},
d_syringegun_medic={
	x=0,
	y=352,
	w=96,
	h=32,
},
d_minigun={
	x=0,
	y=384,
	w=96,
	h=32,
},
d_pipe={
	x=0,
	y=448,
	w=96,
	h=32,
},
d_flamethrower={
	x=0,
	y=416,
	w=96,
	h=32,
},
d_fists={
	x=191,
	y=446,
	w=64,
	h=32,
},
d_fireaxe={
	x=0,
	y=480,
	w=96,
	h=32,
},
d_bonesaw={
	x=96,
	y=128,
	w=96,
	h=32,
},
d_knife={
	x=96,
	y=0,
	w=96,
	h=32,
},
d_revolver={
	x=96,
	y=32,
	w=96,
	h=32,
},
d_flaregun={
	x=96,
	y=64,
	w=96,
	h=32,
},
d_wrench={
	x=96,
	y=96,
	w=96,
	h=32,
},
d_scattergun={
	x=96,
	y=192,
	w=96,
	h=32,
},
d_tf_projectile_pipe_remote={
	x=96,
	y=224,
	w=96,
	h=32,
},
d_vehicle={
	x=96,
	y=256,
	w=96,
	h=32,
},
d_skull={
	x=116,
	y=288,
	w=52,
	h=32,
},
d_explosion={
	x=116,
	y=320,
	w=52,
	h=32,
},
d_headshot={
	x=120,
	y=352,
	w=42,
	h=32,
},
d_backstab={
	x=116,
	y=384,
	w=48,
	h=32,
},
d_ubersaw={
	x=96,
	y=416,
	w=96,
	h=32,
},
d_axtinguisher={
	x=96,
	y=448,
	w=96,
	h=32,
},
d_taunt_pyro={
	x=96,
	y=480,
	w=96,
	h=32,
},
d_bluedefend={
	x=194,
	y=0,
	w=32,
	h=32,
},
d_bluecapture={
	x=194,
	y=32,
	w=32,
	h=32,
},
d_reddefend={
	x=226,
	y=0,
	w=32,
	h=32,
},
d_redcapture={
	x=226,
	y=32,
	w=32,
	h=32,
},
d_obj_attachment_sapper={
	x=0,
	y=64,
	w=96,
	h=32,
},
d_deflect_promode={
	x=194,
	y=64,
	w=64,
	h=32,
},
d_deflect_sticky={
	x=194,
	y=96,
	w=64,
	h=32,
},
d_deflect_rocket={
	x=194,
	y=128,
	w=64,
	h=32,
},
d_deflect_flare={
	x=194,
	y=160,
	w=64,
	h=32,
},
d_bat_wood={
	x=0,
	y=0,
	w=96,
	h=32,
},
d_ball={
	x=192,
	y=192,
	w=64,
	h=32,
},
d_taunt_heavy={
	x=191,
	y=479,
	w=64,
	h=32,
},
d_taunt_scout={
	x=192,
	y=224,
	w=64,
	h=64,
},
d_gloves={
	x=0,
	y=448,
	w=96,
	h=32,
},
d_crit={
	x=192,
	y=409,
	w=64,
	h=34,
},
d_ambassador={
	x=263,
	y=67,
	w=92,
	h=32,
},
d_huntsman={
	x=263,
	y=98,
	w=96,
	h=32,
},
d_huntsman_burning={
	x=263,
	y=190,
	w=68,
	h=33,
},
d_huntsman_flyingburn={
	x=263,
	y=223,
	w=103,
	h=32,
},
d_taunt_spy={
	x=263,
	y=129,
	w=92,
	h=32,
},
d_huntsman_headshot={
	x=192,
	y=289,
	w=64,
	h=32,
},
d_ambassador_headshot={
	x=192,
	y=322, 
	h=32,
},
d_taunt_sniper={
	x=368,
	y=197,
	w=128,
	h=32,
},
d_taunt_medic={
	x=263,
	y=161,
	w=94,
	h=27,
}, 
d_saw_kill={
	x=192,
	y=359,
	w=64,
	h=32,
},
d_deflect_arrow={
	x=360,
	y=0,
	w=64,
	h=30,
},
d_firedeath={
	x=263,
	y=256,
	w=64,
	h=32,
},
d_pumpkindeath={
	x=263,
	y=358,
	w=96,
	h=32,
},
d_taunt_soldier={		
	x=323,
	y=446,
	w=64,
	h=32,
},
d_taunt_demoman={	
	x=323,
	y=479,
	w=64,
	h=32,
},
d_sword={		
	x=258,
	y=464,
	w=64,
	h=32,
},
d_demoshield={	
	x=258,
	y=398,
	w=64,
	h=32,
},
d_pickaxe={	
	x=258,
	y=431,
	w=64,
	h=32,
},
d_rocketlauncher_directhit={		
	x=368,
	y=263,
	w=92,
	h=32,
},
d_sticky_resistance={	
	x=323,
	y=413,
	w=64,
	h=32,
},
d_player_sentry={	
	x=388,
	y=446,
	w=64,
	h=32,
},
d_battleaxe={
	x=368,
	y=164,
	w=64,
	h=32,
},
d_tribalkukri={	
	x=368,
	y=65,
	w=92,
	h=32,
},
d_sledgehammer={	
	x=368,
	y=98,
	w=64,
	h=32,
},
d_paintrain={	
	x=368,
	y=131,
	w=64,
	h=32,
},
d_samrevolver={
	x=368,
	y=230,
	w=98,
	h=32,
},
d_natascha={
	x=368,
	y=297,
	w=98,
	h=32,
},
d_maxgun={
	x=368,
	y=330,
	w=98,
	h=32,
},
d_force_a_nature={
	x=368,
	y=363,
	w=128,
	h=32,
},

}, -- ["_images"]

["_images_v3"]={
	
d_sharp_dresser={
	x=0,
	y=288,
	w=96,
	h=32,
},

d_spycicle={
	x=0,
	y=512,
	w=96,
	h=32,
},

d_wrap_assassin={
	x=256,
	y=96,
	w=128,
	h=32,
},

d_blackrose={
	x=0,
	y=576,
	w=96,
	h=32,
},

d_lollichop={
	x=0,
	y=608,
	w=96,
	h=32,
},

d_pro_smg={
	x=0,
	y=705,
	w=64,
	h=31,
},

d_pep_pistol={
	x=0,
	y=737,
	w=48,
	h=31,
},

d_pro_rifle={
	x=256,
	y=128,
	w=128,
	h=32,
},

d_pep_brawlerblaster={
	x=256,
	y=160,
	w=128,
	h=32,
},

d_dumpster_device={
	x=256,
	y=192,
	w=128,
	h=32,
},

d_long_heatmaker={
	x=0,
	y=800,
	w=96,
	h=31,
},

d_annihilator={
	x=0,
	y=832,
	w=96,
	h=31,
},

d_guillotine={
	x=0,
	y=864,
	w=96,
	h=31,
},

d_freedom_staff={
	x=256,
	y=224,
	w=128,
	h=32,
},

d_airstrike={
	x=256,
	y=545,
	w=128,
	h=32,
},

d_ai_flamethrower={
	x=256,
	y=640,
	w=128,
	h=32,
},

d_quickiebomb_launcher={
	x=256,
	y=704,
	w=128,
	h=32,
},

d_nonnonviolent_protest={
	x=0,
	y=0,
	w=96,
	h=32,
},

d_batsaber={
	x=256,
	y=768,
	w=128,
	h=32,
},

d_the_capper={
	x=256,
	y=800,
	w=128,
	h=32,
},

d_shooting_star={
	x=256,
	y=832,
	w=128,
	h=32,
},

d_hot_hand={
	x=256,
	y=928,
	w=64,
	h=32,
},

d_tide_turner={
	x=192,
	y=545,
	w=64,
	h=32,
},

d_mannpower_plague={
	x=128,
	y=32,
	w=40,
	h=32
},
d_necro_smasher={
	x=192,
	y=608,
	w=64,
	h=32,
},	
d_rescue_ranger={
	x=256,
	y=416,
	w=128,
	h=32,
},	
d_monoculus={
	x=0,
	y=159,
	w=88,
	h=32,
},
d_apocofists={
	x=5,
	y=256,
	w=82,
	h=31,
},
d_ham_shank={
	x=187,
	y=91,
	w=76,
	h=39,
},
d_scorch_shot={
	x=0,
	y=640,
	w=96,
	h=32,
},
	
d_shortcircuit_ball={
	x=226,
	y=322,
	w=29,
	h=29
},

d_prinny_machete={
	x=100,
	y=859,
	w=93,
	h=41
},

d_bomb_head={
	x=270,
	y=351,
	w=106,
	h=36
},

d_loose_cannon_explosion={
	x=259,
	y=387,
	w=119,
	h=29
},

d_panic_attack={
	x=258,
	y=736,
	w=124,
	h=32,
},

d_iron_bomber={
	x=259,
	y=673,
	w=122,
	h=32,
},

d_psapper={
	x=278,
	y=480,
	w=83,
	h=33
},

d_lollichop={
	x=16,
	y=609,
	w=65,
	h=30,
},

d_rainblower={
	x=7,
	y=673,
	w=89,
	h=31,
},

d_holiday_punch={
	x=0,
	y=481,
	w=90,
	h=31,
},
	
d_dragons_fury={
	x=257,
	y=992,
	w=127,
	h=32,
},
	
d_phlogistinator={
	x=260,
	y=1,
	w=120,
	h=31,
}


},

["_images_v2"]={

d_battleneedle={
	x=256,
	y=640,
	w=96,
	h=32,
},

d_demokatana={
	x=384,
	y=128,
	w=96,
	h=32,
},

d_fryingpan={
	x=96,
	y=768,
	w=96,
	h=32,
},

d_atomizer={
	x=384,
	y=416,
	w=96,
	h=32,
},

d_bazaar_bargain={
	x=384,
	y=448,
	w=96,
	h=32,
},

d_bushwacka={
	x=256,
	y=608,
	w=96,
	h=32,
},

d_eviction_notice={
	x=384,
	y=544,
	w=96,
	h=32,
},

d_crossing_guard={
	x=0,
	y=960,
	w=96,
	h=32,
},

d_nessieclub={
	x=384,
	y=928,
	w=128,
	h=32,
},

d_kunai={
	x=384,
	y=64,
	w=96,
	h=32,
},

d_big_earner={
	x=384,
	y=480,
	w=96,
	h=32,
},

d_family_business={
	x=384,
	y=576,
	w=96,
	h=32,
},

d_persian_prusader={
	x=384,
	y=672,
	w=96,
	h=32,
},

d_shahanshah={
	x=384,
	y=736,
	w=96,
	h=32,
},

d_enforcer={
	x=384,
	y=768,
	w=96,
	h=32,
},

d_disciplinary_action={
	x=384,
	y=800,
	w=96,
	h=32,
},

d_mantreads={
	x=384,
	y=864,
	w=64,
	h=32,
},

d_solemn_vow={
	x=384,
	y=896,
	w=96,
	h=32,
},

d_mailbox={
	x=384,
	y=960,
	w=128,
	h=32,
},

d_quake_rl={
	x=384,
	y=992,
	w=128,
	h=32,
},

d_diamondback={
	x=320,
	y=896,
	w=64,
	h=32,
},

d_machina={
	x=256,
	y=288,
	w=128,
	h=32,
},


d_warfan={
	x=384,
	y=96,
	w=64,
	h=32,
},

d_splendid_screen={
	x=384,
	y=832,
	w=96,
	h=32,
},

d_wrench_golden={
	x=0,
	y=736,
	w=96,
	h=32,
},

d_market_gardener={
	x=386,
	y=288,
	w=87,
	h=32,
},
d_saxxy={
	x=392,
	y=255,
	w=77,
	h=33,
},	

d_tomislav={
	x=385,
	y=350,
	w=84,
	h=35
},

d_short_circuit={
	x=322,
	y=929,
	w=55,
	h=35
},

d_iron_curtain={
	x=260,
	y=706,
	w=89,
	h=28,
},

d_boot={
	x=394,
	y=867,
	w=46,
	y=27,
},

d_building_carried_destroyed={
	x=0,
	y=768,
	w=96,
	h=32,
},
d_taunt_guitar_kill={
	x=0,
	y=704,
	w=96,
	h=32,
},
d_frontier_kill={
	x=256,
	y=96,
	w=128,
	h=32,
},
d_wrench_golden={
	x=0,
	y=736,
	w=96,
	h=32,
},
d_southern_comfort_kill={
	x=256,
	y=992,
	w=64,
	h=32,
},
d_bleed_kill={
	x=256,
	y=928,
	w=32,
	h=32,
},
d_wrangler_kill={
	x=256,
	y=960,
	w=32,
	h=32,
},
d_robot_arm_kill={
	x=0,
	y=800,
	w=96,
	h=32,
},
d_robot_arm_combo_kill={
	x=0,
	y=832,
	w=96,
	h=32,
},
d_robot_arm_blender_kill={
	x=0,
	y=864,
	w=96,
	h=32,
},
d_degreaser={
	x=0,
	y=896,
	w=96,
	h=32,
},
d_powerjack={
	x=0,
	y=928,
	w=96,
	h=32,
},
d_eternal_reward={
	x=0,
	y=960,
	w=96,
	h=32,
},
d_letranger={
	x=0,
	y=992,
	w=96,
	h=32,
},
d_short_stop={
	x=256,
	y=896,
	w=64,
	h=32,
},
d_holy_mackerel={
	x=96,
	y=992,
	w=96,
	h=32,
},
d_headtaker={
	x=256,
	y=128,
	w=128,
	h=32,
},

}, -- ["_images_v2"]

["_images_custom"]={
d_blutsauger={
	x=0,
	y=0,
	w=96,
	h=32,
},
d_crotchshot={
	x=24,
	y=96,
	w=42,
	h=32,
},

-- CUSTOM WEAPONS
d_firecannone={
	x=0,
	y=128,
	w=96,
	h=32,
},
d_leviathan={
	x=0,
	y=160,
	w=96,
	h=32,
},
d_bofors={
	x=0,
	y=192,
	w=96,
	h=32,
},
-- /CUSTOM WEAPONS

d_amputator={
	x=96,
	y=0,
	w=96,
	h=32,
},
d_back_scratcher={
	x=96,
	y=32,
	w=96,
	h=32,
},
d_boston_basher={
	x=96,
	y=64,
	w=96,
	h=32,
},
d_ullapool_caber_explosion={
	x=96,
	y=96,
	w=96,
	h=32,
},
d_ullapool_caber={
	x=96,
	y=128,
	w=96,
	h=32,
},
d_claidheamohmor={
	x=96,
	y=160,
	w=96,
	h=32,
},
d_lochnload={
	x=96,
	y=192,
	w=96,
	h=32,
},
d_steel_fists={
	x=96,
	y=224,
	w=78,
	h=32,
},
d_bear_claws={
	x=96,
	y=256,
	w=78,
	h=32,
},
d_candy_cane={
	x=96,
	y=288,
	w=96,
	h=32,
},
d_gatling={
	x=96,
	y=320,
	w=96,
	h=32,
},
d_wrench_jag={
	x=96,
	y=352,
	w=96,
	h=32,
},
d_crusaders_crossbow={
	x=96,
	y=384,
	w=96,
	h=32,
},
}, -- ["_images_custom"]

["_images_hl2"]={
d_hl_crossbow={
	x=0,
	y=0,
	w=96,
	h=32,
},
d_hl_shotgun={
	x=0,
	y=32,
	w=96,
	h=32,
},
d_hl_ar2={
	x=0,
	y=64,
	w=96,
	h=32,
},
d_hl_frag={
	x=0,
	y=96,
	w=96,
	h=32,
},
d_hl_crowbar={
	x=0,
	y=128,
	w=96,
	h=32,
},
d_hl_pistol={
	x=0,
	y=160,
	w=96,
	h=32,
},
d_hl_357={
	x=0,
	y=192,
	w=96,
	h=32,
},
d_hl_smg={
	x=0,
	y=224,
	w=96,
	h=32,
},
d_hl_stunstick={
	x=0,
	y=256,
	w=96,
	h=32,
},
d_hl_physics={
	x=0,
	y=288,
	w=96,
	h=32,
},
d_hl_combine_ball={
	x=0,
	y=320,
	w=96,
	h=32,
},
d_hl_rpg={
	x=0,
	y=352,
	w=96,
	h=32,
},
d_hl_ar2_grenade={
	x=0,
	y=384,
	w=96,
	h=32,
},
d_deflect_frag={
	x=0,
	y=416,
	w=64,
	h=32,
},
d_deflect_ar2grenade={
	x=0,
	y=448,
	w=64,
	h=32,
},
d_deflect_rpg={
	x=0,
	y=480,
	w=64,
	h=32,
},
d_hl_zombie={
	x=96,
	y=0,
	w=96,
	h=32,
},
d_hl_antlion={
	x=96,
	y=32,
	w=96,
	h=32,
},
d_hl_headcrab={
	x=96,
	y=64,
	w=96,
	h=32,
},
d_hl_hunter_pound={
	x=96,
	y=96,
	w=96,
	h=32,
},
d_hl_hunter_skewer={
	x=96,
	y=128,
	w=96,
	h=32,
},
d_hl_antlionguard={
	x=96,
	y=160,
	w=96,
	h=32,
},
d_hl_hunter_charge={
	x=96,
	y=192,
	w=96,
	h=32,
},
d_hl_acidball={
	x=96,
	y=224,
	w=96,
	h=32,
},
d_hl_flechette={
	x=96,
	y=256,
	w=96,
	h=32,
},
d_hl_antworker_explosion={
	x=96,
	y=288,
	w=96,
	h=32,
},
d_hl_vortigaunt_beam={
	x=96,
	y=320,
	w=96,
	h=32,
},
d_hl_vortigaunt={
	x=96,
	y=352,
	w=96,
	h=32,
},
d_deflect_crossbowbolt={
	x=96,
	y=416,
	w=64,
	h=32,
},
d_deflect_combineball={
	x=96,
	y=448,
	w=64,
	h=32,
},
d_deflect_acidball={
	x=96,
	y=480,
	w=64,
	h=32,
},
d_hl_rollermine={
	x=192,
	y=0,
	w=96,
	h=32,
},
d_hl_manhack={
	x=192,
	y=32,
	w=96,
	h=32,
},
d_hl_floorturret={
	x=192,
	y=64,
	w=96,
	h=32,
},
d_hl_combine_mine={
	x=192,
	y=96,
	w=96,
	h=32,
},
d_hl_airboat_gun={
	x=192,
	y=128,
	w=96,
	h=32,
},
d_hl_strider_minigun={
	x=192,
	y=160,
	w=96,
	h=32,
},
d_hl_strider_beam={
	x=192,
	y=192,
	w=96,
	h=32,
},
d_hl_strider_skewer={
	x=192,
	y=224,
	w=96,
	h=32,
},
d_have_an_error={
	x=192,
	y=480,
	w=96,
	h=32,
},
} -- ["_images_hl2"]
} -- Killicons
