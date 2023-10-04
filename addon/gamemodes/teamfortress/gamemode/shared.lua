--[[
local old_include = include

function include(name)
	local time_start = SysTime()
	old_include(name)
	MsgN(Format("Included Lua file '%s', %f secs to load", name, SysTime() - time_start))
end
]]


--If you ask me a question about why I'm using console commands trust me, this shit is golden
 
resource.AddFile("models/weapons/c_models/c_scout_arms_empty.dx90.vtx")
resource.AddFile("models/weapons/c_models/c_scout_arms_empty.dx80.vtx")
resource.AddFile("models/weapons/c_models/c_scout_arms.mdl")
resource.AddFile("models/weapons/c_models/c_scout_arms_empty.sw.vtx")
resource.AddFile("models/weapons/c_models/c_scout_arms_empty.vvd")
resource.AddFile("models/weapons/c_models/c_soldier_arms_empty.dx90.vtx")
resource.AddFile("models/weapons/c_models/c_soldier_arms_empty.dx80.vtx")
resource.AddFile("models/weapons/c_models/c_soldier_arms.mdl") 
resource.AddFile("models/weapons/c_models/c_soldier_arms_empty.sw.vtx") 
resource.AddFile("models/weapons/c_models/c_soldier_arms_empty.vvd")
resource.AddFile("models/weapons/c_models/c_pyro_arms_empty.dx90.vtx")
resource.AddFile("models/weapons/c_models/c_pyro_arms_empty.dx80.vtx")
resource.AddFile("models/weapons/c_models/c_pyro_arms.mdl")
resource.AddFile("models/weapons/c_models/c_pyro_arms_empty.sw.vtx")
resource.AddFile("models/weapons/c_models/c_pyro_arms_empty.vvd")
resource.AddFile("models/weapons/c_models/c_demo_arms_empty.dx90.vtx")
resource.AddFile("models/weapons/c_models/c_demo_arms_empty.dx80.vtx")
resource.AddFile("models/weapons/c_models/c_demo_arms.mdl")
resource.AddFile("models/weapons/c_models/c_demo_arms_empty.sw.vtx")
resource.AddFile("models/weapons/c_models/c_demo_arms_empty.vvd")
resource.AddFile("models/weapons/c_models/c_heavy_arms_empty.dx90.vtx")
resource.AddFile("models/weapons/c_models/c_heavy_arms_empty.dx80.vtx")
resource.AddFile("models/weapons/c_models/c_heavy_arms.mdl")
resource.AddFile("models/weapons/c_models/c_heavy_arms_empty.sw.vtx")
resource.AddFile("models/weapons/c_models/c_heavy_arms_empty.vvd")
resource.AddFile("models/weapons/c_models/c_engineer_arms_empty.dx90.vtx")
resource.AddFile("models/weapons/c_models/c_engineer_arms_empty.dx80.vtx")
resource.AddFile("models/weapons/c_models/c_engineer_arms.mdl")
resource.AddFile("models/weapons/c_models/c_engineer_arms_empty.sw.vtx")
resource.AddFile("models/weapons/c_models/c_engineer_arms_empty.vvd")
resource.AddFile("models/weapons/c_models/c_medic_arms_empty.dx90.vtx")
resource.AddFile("models/weapons/c_models/c_medic_arms_empty.dx80.vtx")
resource.AddFile("models/weapons/c_models/c_medic_arms.mdl")
resource.AddFile("models/weapons/c_models/c_medic_arms_empty.sw.vtx")
resource.AddFile("models/weapons/c_models/c_medic_arms_empty.vvd")
resource.AddFile("models/weapons/c_models/c_sniper_arms_empty.dx90.vtx")
resource.AddFile("models/weapons/c_models/c_sniper_arms_empty.dx80.vtx")
resource.AddFile("models/weapons/c_models/c_sniper_arms.mdl")
resource.AddFile("models/weapons/c_models/c_sniper_arms_empty.sw.vtx")
resource.AddFile("models/weapons/c_models/c_sniper_arms_empty.vvd")
resource.AddFile("models/weapons/c_models/c_spy_arms_empty.dx90.vtx")
resource.AddFile("models/weapons/c_models/c_spy_arms_empty.dx80.vtx")
resource.AddFile("models/weapons/c_models/c_spy_arms.mdl")
resource.AddFile("models/weapons/c_models/c_spy_arms_empty.sw.vtx")
resource.AddFile("models/weapons/c_models/c_spy_arms_empty.vvd")

if CLIENT then
	language.Add("tool.turn_into_gatebot.name", "Gate-Botizer")
	language.Add("tool.turn_into_gatebot.desc", "Turn MvM TFBots into GateBots")
	language.Add("tool.turn_into_gatebot.left", "Left-click: Turn a MvM Bot into a GateBot.")
	language.Add("tool.reprogrammer.name", "Reprogrammer")
	language.Add("tool.reprogrammer.desc", "Change the TFBot or NPC Team to the opposite team or your team.")
	language.Add("tool.reprogrammer.left", "Left-click: Change TFBot or NPC team to the opposite team.")
	language.Add("tool.reprogrammer.right", "Right-click: Change TFBot or NPC team to your team.")
		
	include("cl_hud.lua")
	include("tf_lang_module.lua")

	include("cl_proxies.lua")
	include("cl_pickteam.lua")

	include("cl_conflict.lua")

	include("cl_entclientinit.lua")
	include("cl_deathnotice.lua") 
	include("cl_scheme.lua")

	include("cl_player_other.lua")

	include("cl_camera.lua")

	include("tf_draw_module.lua")

	include("cl_materialfix.lua")

	include("cl_pac.lua")

	include("cl_loadout.lua")
end  

sound.Add( {
	name = "Player.AmbientUnderWater",
	volume = 0.22,
	level = 75, 
	channel = CHAN_STATIC, 
	pitch = { 100 },
	sound = { "ambient/water/underwater.wav" } 
} )

sound.Add( {
	name = "RussianSong",
	volume = 1.0,
	level = 75,
	channel = CHAN_STATIC, 
	pitch = { 100 },
	sound = { "taunts/cossack_sandvich_noloop.wav" } 
} )

sound.Add( {
	name = "Player.PickupWeapon",
	volume = 0.7,
	level = 75,
	channel = CHAN_WEAPON, 
	pitch = { 100 }, 
	sound = { "items/ammo_pickup.wav" } 
} )
 
sound.Add( {
	name = "General.BurningObject",
	level = 75,
	channel = CHAN_WEAPON, 
	pitch = { 100 }, 
	sound = { "ambient/fire/fire_small_loop2.wav" } 
} )

sound.Add( {
	name = "BaseCombatCharacter.AmmoPickup",
	volume = 0.7,
	level = 75,
	channel = CHAN_WEAPON, 
	pitch = { 100 }, 
	sound = { "items/ammo_pickup.wav" } 
} )

sound.Add( {
	name = "CongaSong",
	volume = 1.0,
	level = 75,
	channel = CHAN_STATIC, 
	pitch = { 100 }, 
	sound = { "taunts/conga_sketch_167bpm_01-04_noloop.wav" } 
} )

sound.Add( {
	name = "Weapon_FlareGun.Reload",
	volume = 1.0,
	level = 75,
	channel = CHAN_STATIC, 
	pitch = { 100 },
	sound = { ")weapons/grenade_launcher_drum_load.wav" } 
} )

sound.Add( {
	name = "Weapon_Shotgun.Reload",
	volume = 1.0,
	level = 75,
	channel = CHAN_WEAPON, 
	pitch = { 100 },
	sound = { ")weapons/shotgun_reload.wav" } 
} )

sound.Add( {
	name = "SuitRecharge.Start",
	volume = 0.75,
	level = 75,
	channel = CHAN_ITEM, 
	pitch = { 67 },
	sound = { ")items/spawn_item.wav" } 
} )
sound.Add( {
	name = "Weapon_SMG1.Single",
	volume = 1.0,
	level = 120,
	channel = CHAN_WEAPON, 
	pitch = { 94, 105 },
	sound = { ")weapons/smg1/smg1_fire1.wav" } 
} )
sound.Add( {
	name = "Weapon_SMG1.Burst",
	volume = 1.0,
	level = 120,
	pitch = { 94, 105 },
	channel = CHAN_WEAPON,
	sound = { "weapons/smg1/smg1_fireburst1.wav" } 
} )
sound.Add( {
	name = "Player.FallDamage",
	volume = 1.0,
	level = 95,
	pitch = { 100 },
	channel = CHAN_WEAPON,
	sound = { "player/pl_fallpain.wav","player/pl_fallpain.wav","player/pl_fallpain.wav" } 
} )
sound.Add( {
	name = "Player.FallGib",
	volume = 1.0,
	level = 95,
	pitch = { 100 },
	channel = CHAN_WEAPON,
	sound = { "player/pl_fleshbreak.wav" } 
} )
sound.Add( {
	name = "AlienSlavePowerup",
	volume = 1.0,
	level = 140,
	channel = CHAN_WEAPON,
	pitch = { 130 },
	sound = { "debris/zap4.wav" } 
} )
sound.Add( {
	name = "AlienSlavePowerup2",
	volume = 1.0,
	level = 140,
	channel = CHAN_WEAPON,
	pitch = { 140 },
	sound = { "debris/zap4.wav" } 
} )
sound.Add( {
	name = "AlienSlavePowerup3",
	volume = 1.0,
	level = 140,
	channel = CHAN_WEAPON,
	pitch = { 150 },
	sound = { "debris/zap4.wav" } 
} )
sound.Add( {
	name = "AlienSlavePowerup4",
	volume = 1.0,
	level = 140,
	channel = CHAN_WEAPON,
	pitch = { 160 },
	sound = { "debris/zap4.wav" } 
} )
sound.Add( {
	name = "Weapon_SuperShotGun.TubeOpen",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "weapons/supershotgun_tube_open.wav" } 
} )
sound.Add( {
	name = "Weapon_SuperShotGun.TubeClose",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "weapons/supershotgun_tube_close.wav" } 
} )
sound.Add( {
	name = "Weapon_SuperShotGun.ShellsIn",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "weapons/supershotgun_shells_in.wav" } 
} )
sound.Add( {
	name = "Weapon_GrenadeLauncherDM.Cock_Back",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "weapons/grenade_launcher_dm_cock_back.wav" } 
} )

sound.Add( {
	name = "Weapon_Pistol.SlideForward",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "weapons/pistol_slideforward.wav" } 
} )
sound.Add( {
	name = "Weapon_Pistol.SlideBack",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "weapons/pistol_slideback.wav" } 
} )
sound.Add( {
	name = "Weapon_Pistol.ClipIn",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "weapons/pistol_clipin.wav" } 
} )
sound.Add( {
	name = "Weapon_Pistol.ClipOut",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "weapons/pistol_clipout.wav" } 
} )

sound.Add( {
	name = "Weapon_Crowbar.Single",
	volume = 1.0,
	level = 90,
	pitch = { 85, 100 },
	sound = { "^weapons/iceaxe/iceaxe_swing1.wav" } 
} )
sound.Add( {
	name = "DosidoIntro",
	volume = 1.0,
	level = 90,
	channel = CHAN_REPLACE,
	pitch = { 100 },
	sound = { "music/fortress_reel_loop.wav" } 
} )
sound.Add( {
	name = "Weapon_Crowbar_HL1.HitFlesh",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "^weapons/hl1/cbar_hitbod1.wav",  "^weapons/hl1/cbar_hitbod2.wav", "^weapons/hl1/cbar_hitbod3.wav" } 
} )
sound.Add( {
	name = "Weapon_Crowbar_HL1.HitWorld",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "^weapons/hl1/cbar_hit1.wav",  "^weapons/hl1/cbar_hit2.wav"} 
} )
sound.Add( {
	name = "ClassSelection.ThemeNonMVM",
	volume = 1.0,
	level = 50,
	pitch = { 100 },
	sound = { "music/class_menu_bg.wav"} 
} )
sound.Add( {
	name = "ClassSelection.ThemeL4D",
	volume = 1.0,
	level = 50,
	pitch = { 100 },
	sound = { "music/unalive/themonsterswithin.wav"} 
} )

sound.Add( {
	name = "Tank.Yell",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 120,
	pitch = { 100 },
	sound = { "player/tank/voice/yell/tank_yell_01.wav","player/tank/voice/yell/tank_yell_02.wav","player/tank/voice/yell/tank_yell_03.wav","player/tank/voice/yell/tank_yell_04.wav","player/tank/voice/yell/tank_yell_05.wav","player/tank/voice/yell/tank_yell_06.wav","player/tank/voice/yell/tank_yell_07.wav","player/tank/voice/yell/tank_yell_08.wav","player/tank/voice/yell/tank_yell_09.wav","player/tank/voice/yell/tank_yell_10.wav","player/tank/voice/yell/tank_yell_11.wav","player/tank/voice/yell/tank_yell_12.wav","player/tank/voice/yell/tank_yell_13.wav","player/tank/voice/yell/tank_yell_14.wav","player/tank/voice/yell/hulk_yell_1.wav","player/tank/voice/yell/hulk_yell_2.wav","player/tank/voice/yell/hulk_yell_3.wav","player/tank/voice/yell/hulk_yell_4.wav","player/tank/voice/yell/hulk_yell_5.wav","player/tank/voice/yell/hulk_yell_6.wav","player/tank/voice/yell/hulk_yell_7.wav","player/tank/voice/yell/hulk_yell_8.wav"} 
} )
sound.Add( {
	name = "Tank.Pain",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 120,
	pitch = { 100 },
	sound = { "player/tank/voice/pain/tank_pain_02.wav","player/tank/voice/pain/tank_pain_04.wav","player/tank/voice/pain/tank_pain_06.wav","player/tank/voice/pain/tank_pain_07.wav","player/tank/voice/pain/hulk_pain_1.wav","player/tank/voice/pain/hulk_pain_10.wav","player/tank/voice/pain/hulk_pain_11.wav","player/tank/voice/pain/hulk_pain_14.wav","player/tank/voice/pain/hulk_pain_8.wav","player/tank/voice/pain/hulk_pain_fire_3.wav","player/tank/voice/pain/hulk_pain_fire_4.wav","player/tank/voice/pain/tank_fire_07.wav","player/tank/voice/pain/tank_fire_01.wav","player/tank/voice/pain/tank_fire_02.wav","player/tank/voice/pain/tank_fire_03.wav","player/tank/voice/pain/tank_fire_04.wav","player/tank/voice/pain/tank_fire_05.wav","player/tank/voice/pain/tank_fire_06.wav","player/tank/voice/pain/tank_fire_07.wav" }
} )
sound.Add( {
	name = "Charger.Idle",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 120,
	pitch = { 100 },
	sound = {"player/charger/voice/alert/charger_alert_01.wav","player/charger/voice/alert/charger_alert_02.wav","player/charger/voice/idle/charger_lurk_01.wav","player/charger/voice/idle/charger_lurk_01.wav","player/charger/voice/idle/charger_lurk_02.wav","player/charger/voice/idle/charger_lurk_03.wav","player/charger/voice/idle/charger_lurk_04.wav","player/charger/voice/idle/charger_lurk_05.wav","player/charger/voice/idle/charger_lurk_06.wav","player/charger/voice/idle/charger_lurk_07.wav","player/charger/voice/idle/charger_lurk_08.wav","player/charger/voice/idle/charger_lurk_09.wav","player/charger/voice/idle/charger_lurk_10.wav","player/charger/voice/idle/charger_lurk_11.wav","player/charger/voice/idle/charger_lurk_14.wav","player/charger/voice/idle/charger_lurk_15.wav","player/charger/voice/idle/charger_lurk_16.wav","player/charger/voice/idle/charger_lurk_17.wav","player/charger/voice/idle/charger_lurk_18.wav","player/charger/voice/idle/charger_lurk_19.wav","player/charger/voice/idle/charger_lurk_20.wav","player/charger/voice/idle/charger_lurk_21.wav","player/charger/voice/idle/charger_lurk_22.wav","player/charger/voice/idle/charger_lurk_23.wav","player/charger/voice/idle/charger_spotprey_01.wav","player/charger/voice/idle/charger_spotprey_02.wav","player/charger/voice/idle/charger_spotprey_03.wav"} 
} )
sound.Add( {
	name = "Jockey.Idle",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 120,
	pitch = { 100 },
	sound = {"player/jockey/voice/idle/jockey_lurk01.wav","player/jockey/voice/idle/jockey_lurk03.wav","player/jockey/voice/idle/jockey_lurk04.wav","player/jockey/voice/idle/jockey_lurk05.wav","player/jockey/voice/idle/jockey_lurk06.wav","player/jockey/voice/idle/jockey_lurk07.wav","player/jockey/voice/idle/jockey_lurk09.wav","player/jockey/voice/idle/jockey_lurk11.wav","player/jockey/voice/idle/jockey_recognize02.wav","player/jockey/voice/idle/jockey_recognize06.wav","player/jockey/voice/idle/jockey_recognize07.wav","player/jockey/voice/idle/jockey_recognize08.wav","player/jockey/voice/idle/jockey_recognize09.wav","player/jockey/voice/idle/jockey_recognize10.wav","player/jockey/voice/idle/jockey_recognize11.wav","player/jockey/voice/idle/jockey_recognize12.wav","player/jockey/voice/idle/jockey_recognize13.wav","player/jockey/voice/idle/jockey_recognize15.wav","player/jockey/voice/idle/jockey_recognize16.wav","player/jockey/voice/idle/jockey_recognize16.wav","player/jockey/voice/idle/jockey_recognize18.wav","player/jockey/voice/idle/jockey_recognize19.wav","player/jockey/voice/idle/jockey_recognize20.wav","player/jockey/voice/idle/jockey_recognize24.wav","player/jockey/voice/idle/jockey_spotprey_01.wav","player/jockey/voice/idle/jockey_spotprey_02.wav"} 
} ) 
sound.Add( {
	name = "Jockey.Pain",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 120,
	pitch = { 100 },
	sound = {
		"player/jockey/voice/pain/jockey_pain01.wav",
		"player/jockey/voice/pain/jockey_pain02.wav",
		"player/jockey/voice/pain/jockey_pain03.wav",
		"player/jockey/voice/pain/jockey_pain04.wav",
		"player/jockey/voice/pain/jockey_pain05.wav",
		"player/jockey/voice/pain/jockey_pain06.wav",
		"player/jockey/voice/pain/jockey_pain07.wav",
		"player/jockey/voice/pain/jockey_pain08.wav"
	} 
} ) 
sound.Add( {
	name = "Hunter.Pain",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 120,
	pitch = { 100 },
	sound = {
		"player/hunter/voice/pain/hunter_pain_05.wav",
		"player/hunter/voice/pain/hunter_pain_08.wav",
		"player/hunter/voice/pain/hunter_pain_09.wav",
		"player/hunter/voice/pain/hunter_pain_12.wav",
		"player/hunter/voice/pain/hunter_pain_13.wav",
		"player/hunter/voice/pain/hunter_pain_14.wav",
		"player/hunter/voice/pain/hunter_pain_15.wav",
	} 
} ) 
sound.Add( {
	name = "Smoker.Pain",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 95,
	pitch = { 100 },
	sound = {
		"player/smoker/voice/pain/smoker_pain_02.wav",
		"player/smoker/voice/pain/smoker_pain_03.wav",
		"player/smoker/voice/pain/smoker_pain_04.wav",
		"player/smoker/voice/pain/smoker_pain_05.wav",
		"player/smoker/voice/pain/smoker_pain_06.wav",
		"player/smoker/voice/pain/smoker_painshort_01.wav",
		"player/smoker/voice/pain/smoker_painshort_02.wav",
		"player/smoker/voice/pain/smoker_painshort_03.wav",
		"player/smoker/voice/pain/smoker_painshort_04.wav",
		"player/smoker/voice/pain/smoker_painshort_05.wav",
		"player/smoker/voice/pain/smoker_painshort_06.wav",
	} 
} ) 
sound.Add( {
	name = "Charger.Pain",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 120,
	pitch = { 100 },
	sound = {
		"player/charger/voice/pain/charger_pain_01.wav",
		"player/charger/voice/pain/charger_pain_02.wav",
		"player/charger/voice/pain/charger_pain_03.wav",
		"player/charger/voice/pain/charger_pain_04.wav",
		"player/charger/voice/pain/charger_pain_05.wav",
		"player/charger/voice/pain/charger_pain_06.wav",
	} 
} ) 
sound.Add( {
	name = "Tank.Death",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 120,
	pitch = { 100 },
	sound = {
		"player/tank/voice/die/tank_death_01.wav",
		"player/tank/voice/die/tank_death_02.wav",
		"player/tank/voice/die/tank_death_03.wav",
		"player/tank/voice/die/tank_death_04.wav",
		"player/tank/voice/die/tank_death_05.wav",
		"player/tank/voice/die/tank_death_06.wav",
		"player/tank/voice/die/tank_death_07.wav",
	} 
} ) 
sound.Add( {
	name = "ClassSelection.ThemeMVM",
	volume = 1.0,
	level = 50,
	pitch = { 100 },
	sound = { "music/mvm_class_menu_bg.wav"} 
} ) 
sound.Add( {
	name = "Hunter.Music",
	volume = 1.0,
	level = 50,
	pitch = { 100 },
	sound = { "music/pzattack/exenteration.wav"} 
} )
sound.Add( {
	name = "Jockey.Music",
	volume = 1.0,
	level = 50,
	pitch = { 100 },
	sound = { "music/pzattack/vassalation.wav"} 
} )

if (file.Exists("sound/tf/weapons/explode1.wav", "WORKSHOP")) then

	sound.Add( {
		name = "TF_BaseExplosionEffect.Sound",
		volume = 1.0,
		level = 95,
		pitch = { 100 },
		channel = CHAN_ITEM,
		sound = { "tf/weapons/explode1.wav",  "tf/weapons/explode2.wav",  "tf/weapons/explode3.wav"} 
	} )

else

sound.Add( {
	name = "TF_BaseExplosionEffect.Sound",
	volume = 1.0,
	level = 95,
	pitch = { 100 },
	channel = CHAN_ITEM,
	sound = { "weapons/explode1.wav",  "weapons/explode2.wav"} 
} )

end
sound.Add( {
	name = "BaseExplosionEffect.Sound",
	volume = 1.0,
	level = 150,
	pitch = { 95, 105 },
	channel = CHAN_ITEM,
	sound = { "^weapons/explode3.wav", "^weapons/explode4.wav", "^weapons/explode5.wav" } 
} ) 
sound.Add( {
	name = "NPC_CombineDropship.NearRotorLoop",
	pitch = 100,
	level = 90,
	sound = { "npc/combine_gunship/dropship_engine_near_loop1.wav" } 
} )
sound.Add( {
	name = "NPC_Vortigaunt.RangedAttack",
	pitch = 150,
	level = 110,
	sound = { "npc/vort/attack_charge.wav" } 
} )
sound.Add( {
	name = "NPC_CombineDropship.RotorLoop",
	pitch = 100,
	level = 150,
	sound = { "npc/combine_gunship/dropship_engine_distant_loop1.wav" }
} )
sound.Add( {
	name = "NPC_AntlionGuard.NearStepHeavy",
	pitch = { 70, 85 },
	level = 85,
	sound = { "npc/antlion_guard/near_foot_heavy1.wav", "npc/antlion_guard/near_foot_heavy2.wav" } 
} )
sound.Add( {
	name = "Weapon_QuadLauncher.Reload",
	pitch = { 70, 105 },
	level = 85,
	sound = { "weapons/quake_ammo_pickup_remastered.wav" } 
} )
sound.Add( {
	name = "Weapon_QuadLauncher.Shoot",
	pitch = { 70, 105 },
	level = 85,
	channel = CHAN_WEAPON,
	sound = { "weapons/quake_rpg_fire_remastered.wav" } 
} )
sound.Add( {
	name = "Flesh.ImpactSoft",
	volume = 0.6,
	level = 75, 
	pitch = { 100 },
	sound = { "physics/body/body_medium_impact_soft1.wav", "physics/body/body_medium_impact_soft2.wav", "physics/body/body_medium_impact_soft5.wav", "physics/body/body_medium_impact_soft6.wav", "physics/body/body_medium_impact_soft7.wav"} 
} )
sound.Add( {
	name = "Flesh.ImpactHard",
	volume = 0.8,
	level = 75,
	pitch = { 100 },
	sound = { "physics/body/body_medium_impact_hard1.wav", "physics/body/body_medium_impact_hard2.wav", "physics/body/body_medium_impact_hard3.wav", "physics/body/body_medium_impact_hard4.wav", "physics/body/body_medium_impact_hard5.wav", "physics/body/body_medium_impact_hard6.wav"} 
} )

sound.Add( {
	name = "Selection.HeavyFootStomp",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_foot_stomp.wav"} 
} )

sound.Add( {
	name = "Selection.PyroFootStomp",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_foot_stomp.wav"} 
} )


sound.Add( {
	name = "Selection.HeavyEquipment1",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_equipment_gun2.wav"} 
} )

sound.Add( {
	name = "Selection.HeavyEquipment2",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_equipment_gun1.wav"} 
} )

sound.Add( {
	name = "Selection.PyroEquipment1",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_equipment_jingle3.wav"} 
} )

sound.Add( {
	name = "Selection.PyroEquipment2",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_equipment_jingle2.wav"} 
} )
sound.Add( {
	name = "Taunt.Scout01HandSmack",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_hand_clap.wav"} 
} )
sound.Add( {
	name = "Taunt.Scout02HandSmack",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_hand_clap.wav"} 
} )
sound.Add( {
	name = "DoSpark",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"ambient/energy/newspark01.wav","ambient/energy/newspark02.wav","ambient/energy/newspark03.wav","ambient/energy/newspark04.wav","ambient/energy/newspark05.wav","ambient/energy/newspark06.wav","ambient/energy/newspark07.wav","ambient/energy/newspark08.wav","ambient/energy/newspark09.wav","ambient/energy/newspark10.wav","ambient/energy/newspark11.wav"} 
} )
sound.Add( {
	name = "LoudSpark",
	volume = 1.0,
	level = 95,
	pitch = { 100 },
	sound = {"ambient/energy/newspark01.wav","ambient/energy/newspark02.wav","ambient/energy/newspark03.wav","ambient/energy/newspark04.wav","ambient/energy/newspark05.wav","ambient/energy/newspark06.wav","ambient/energy/newspark07.wav","ambient/energy/newspark08.wav","ambient/energy/newspark09.wav","ambient/energy/newspark10.wav","ambient/energy/newspark11.wav"} 
} )
sound.Add( {
	name = "ReallyLoudSpark",
	volume = 1.0,
	level = 135,
	pitch = { 100 },
	sound = {"ambient/energy/newspark01.wav","ambient/energy/newspark02.wav","ambient/energy/newspark03.wav","ambient/energy/newspark04.wav","ambient/energy/newspark05.wav","ambient/energy/newspark06.wav","ambient/energy/newspark07.wav","ambient/energy/newspark08.wav","ambient/energy/newspark09.wav","ambient/energy/newspark10.wav","ambient/energy/newspark11.wav"} 
} )


sound.Add( {
	name = "Selection.EngineerWrenchShoulder",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_shotgun_shoulder.wav"} 
} )

sound.Add( {
	name = "Selection.EngineerFootStomp",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_foot_stomp.wav"} 
} )	

sound.Add( {
	name = "Selection.EngineerClothesRustle",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_clothes_rustle.wav"} 
} )


sound.Add( {
	name = "Taunt.Heavy01HoldGun",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_grenade_catch.wav"} 
} )


sound.Add( {
	name = "Taunt.Heavy01ClothesRustle",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_clothes_rustle.wav"} 
} )


sound.Add( {
	name = "Taunt.Heavy01EquipmentGun",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_equipment_gun1.wav"} 
} )

sound.Add( {
	name = "Taunt.Heavy01EquipmentGun2",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_equipment_gun2.wav"} 
} )

sound.Add( {
	name = "Taunt.Heavy01EquipmentRustleHeavy",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_equipment_jingle2.wav"} 
} )
sound.Add( {
	name = "Taunt.Heavy01HoldGunLight",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_hand_clap2.wav"} 
} )

sound.Add( {
	name = "Selection.HeavyClothesRustle",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_clothes_rustle.wav"} 
} )


sound.Add( {
	name = "Selection.ScoutShotgunShoulder",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_shotgun_shoulder.wav"} 
} )


sound.Add( {
	name = "Selection.MedicHeelClick",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_heel_click.wav"} 
} )

sound.Add( {
	name = "Selection.MedicFootStomp",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_foot_stomp.wav"} 
} )	

sound.Add( {
	name = "Selection.MedicFootSlide",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_foot_spin.wav"} 
} )	

sound.Add( {
	name = "Selection.ScoutShotgunTwirl",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_shotgun_twirl.wav"} 
} ) 

sound.Add( { 
	name = "Selection.PyroClothesRustle",
	volume = 1.0, 
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_clothes_rustle.wav"} 
} )

sound.Add( {
	name = "Dirt.StepLeft",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/dirt1.wav","player/footsteps/dirt3.wav","player/footsteps/dirt2.wav","player/footsteps/dirt4.wav"} 
} )
sound.Add( {
	name = "Dirt.StepRight",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/dirt2.wav","player/footsteps/dirt4.wav","player/footsteps/dirt1.wav","player/footsteps/dirt3.wav"} 
} )
sound.Add( {
	name = "MetalGrate.StepLeft",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/metalgrate1.wav","player/footsteps/metalgrate3.wav","player/footsteps/metalgrate2.wav","player/footsteps/metalgrate4.wav"} 
} )
sound.Add( {
	name = "MetalVent.StepRight",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/duct2.wav","player/footsteps/duct4.wav","player/footsteps/duct1.wav","player/footsteps/duct3.wav"} 
} )
sound.Add( {
	name = "MetalVent.StepLeft",
	volume = 1.0,
	level = 75,
	pitch = 100, 
	channel = CHAN_BODY,
	sound = {"player/footsteps/duct1.wav","player/footsteps/duct3.wav","player/footsteps/duct2.wav","player/footsteps/duct4.wav"} 
} )
sound.Add( {
	name = "MetalGrate.StepRight",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/metalgrate2.wav","player/footsteps/metalgrate4.wav","player/footsteps/metalgrate2.wav","player/footsteps/metalgrate1.wav"} 
} )
sound.Add( {
	name = "Rubber.StepRight",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"physics/rubber/rubber_tire_impact_soft1.wav"} 
} )
sound.Add( {
	name = "Rubber.StepLeft",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"physics/rubber/rubber_tire_impact_soft1.wav"} 
} )
sound.Add( {
	name = "Grass.StepLeft",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/grass1.wav","player/footsteps/grass3.wav","player/footsteps/grass2.wav","player/footsteps/grass4.wav"} 
} )
sound.Add( {
	name = "MVM.GiantHeavyStep",
	volume = 1.0,
	level = 150,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"^mvm/giant_common/giant_common_step_01.wav","^mvm/giant_common/giant_common_step_02.wav","^mvm/giant_common/giant_common_step_03.wav","^mvm/giant_common/giant_common_step_04.wav","^mvm/giant_common/giant_common_step_05.wav","^mvm/giant_common/giant_common_step_06.wav","^mvm/giant_common/giant_common_step_07.wav","^mvm/giant_common/giant_common_step_08.wav"} 
} )
sound.Add( {
	name = "Grass.StepRight",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/grass2.wav","player/footsteps/grass4.wav","player/footsteps/grass1.wav","player/footsteps/grass3.wav"} 
} )
sound.Add( {
	name = "Default.StepLeft",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/concrete1.wav","player/footsteps/concrete3.wav","player/footsteps/concrete1.wav","player/footsteps/concrete3.wav"} 
} )
sound.Add( {
	name = "Concrete.StepRight",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/concrete2.wav","player/footsteps/concrete4.wav","player/footsteps/concrete1.wav","player/footsteps/concrete3.wav"} 
} ) 
sound.Add( {
	name = "BoomerFootstep",
	volume = 1.0,
	level = 95,
	pitch = { 100 },
	channel = CHAN_STATIC,
	sound = {"player/footsteps/boomer/run/concrete1.wav","player/footsteps/boomer/run/concrete2.wav","player/footsteps/boomer/run/concrete3.wav","player/footsteps/boomer/run/concrete4.wav"} 
} ) 
sound.Add( {
	name = "TankFootstep",
	volume = 1.0,
	level = 95,
	pitch = { 100 },
	channel = CHAN_STATIC,
	sound = {
		"player/footsteps/tank/walk/tank_walk01.wav",
		"player/footsteps/tank/walk/tank_walk02.wav",
		"player/footsteps/tank/walk/tank_walk03.wav",
		"player/footsteps/tank/walk/tank_walk04.wav",
		"player/footsteps/tank/walk/tank_walk05.wav",
		"player/footsteps/tank/walk/tank_walk06.wav"
	}
} ) 
sound.Add( {
	name = "TankFootstepWater",
	volume = 1.0,
	level = 95,
	pitch = { 100 },
	channel = CHAN_STATIC,
	sound = {
		"player/footsteps/tank/walk/tank_walk_water_01.wav",
		"player/footsteps/tank/walk/tank_walk_water_02.wav",
		"player/footsteps/tank/walk/tank_walk_water_03.wav",
		"player/footsteps/tank/walk/tank_walk_water_04.wav",
		"player/footsteps/tank/walk/tank_walk_water_05.wav",
		"player/footsteps/tank/walk/tank_walk_water_06.wav"
	}
} ) 
sound.Add( {
	name = "CommonZombie.Footstep",
	volume = 1.0,
	level = 95,
	pitch = { 100 },
	channel = CHAN_STATIC,
	sound = {
		"vj_l4d_com/footstep/concrete1.wav",
		"vj_l4d_com/footstep/concrete2.wav",
		"vj_l4d_com/footstep/concrete3.wav",
		"vj_l4d_com/footstep/concrete4.wav",
		"vj_l4d_com/footstep/dirt1.wav",
		"vj_l4d_com/footstep/dirt2.wav",
		"vj_l4d_com/footstep/dirt3.wav",
		"vj_l4d_com/footstep/dirt4.wav"
	}
} ) 
sound.Add( {
	name = "CommonZombie.ClownFootstep",
	volume = 1.0,
	level = 95,
	pitch = { 100 },
	channel = CHAN_STATIC,
	sound = {
		"vj_l4d_com/footstep/clown/concrete1.wav",
		"vj_l4d_com/footstep/clown/concrete2.wav",
		"vj_l4d_com/footstep/clown/concrete3.wav",
		"vj_l4d_com/footstep/clown/concrete4.wav",
		"vj_l4d_com/footstep/clown/concrete5.wav",
		"vj_l4d_com/footstep/clown/concrete6.wav",
		"vj_l4d_com/footstep/clown/concrete7.wav",
		"vj_l4d_com/footstep/clown/concrete8.wav"
	}
} ) 
sound.Add( {
	name = "ChargerFootstep",
	volume = 1.0,
	level = 95,
	pitch = { 100 },
	channel = CHAN_STATIC,
	sound = {
		"player/footsteps/charger/run/charger_run_left_01.wav",
		"player/footsteps/charger/run/charger_run_right_01.wav",
		"player/footsteps/charger/run/charger_run_left_02.wav",
		"player/footsteps/charger/run/charger_run_right_02.wav",
		"player/footsteps/charger/run/charger_run_left_03.wav",
		"player/footsteps/charger/run/charger_run_right_03.wav",
		"player/footsteps/charger/run/charger_run_left_04.wav",
		"player/footsteps/charger/run/charger_run_right_04.wav"
	}
} ) 
sound.Add( {
	name = "Concrete.StepLeft",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/concrete1.wav","player/footsteps/concrete3.wav","player/footsteps/concrete1.wav","player/footsteps/concrete3.wav"} 
} )
sound.Add( {
	name = "Default.StepRight",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/concrete2.wav","player/footsteps/concrete4.wav","player/footsteps/concrete1.wav","player/footsteps/concrete3.wav"} 
} ) 
sound.Add( {
	name = "Wood.StepLeft",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/wood1.wav","player/footsteps/wood3.wav","player/footsteps/wood2.wav","player/footsteps/wood4.wav"} 
} )
sound.Add( {
	name = "Wood.StepRight",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/wood2.wav","player/footsteps/wood4.wav","player/footsteps/wood1.wav","player/footsteps/wood3.wav"} 
} )
sound.Add( {
	name = "SolidMetal.StepLeft",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/metal1.wav","player/footsteps/metal3.wav","player/footsteps/metal2.wav","player/footsteps/metal4.wav",} 
} )
sound.Add( {
	name = "SolidMetal.StepRight",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/metal2.wav","player/footsteps/metal4.wav","player/footsteps/metal1.wav","player/footsteps/metal3.wav"} 
} )
sound.Add( {
	name = "Tile.StepLeft",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/tile1.wav","player/footsteps/tile2.wav","player/footsteps/tile3.wav","player/footsteps/tile4.wav"} 
} )
sound.Add( {
	name = "Tile.StepRight",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/tile1.wav","player/footsteps/tile2.wav","player/footsteps/tile3.wav","player/footsteps/tile4.wav"} 
} )
sound.Add( {
	name = "Grass.StepLeft",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/grass1.wav","player/footsteps/grass2.wav","player/footsteps/grass3.wav","player/footsteps/grass4.wav"} 
} )
sound.Add( {
	name = "Grass.StepRight",
	volume = 1.0,
	level = 75,
	pitch = 100,
	channel = CHAN_BODY,
	sound = {"player/footsteps/grass1.wav","player/footsteps/grass3.wav","player/footsteps/grass3.wav","player/footsteps/grass4.wav"} 
} )
sound.Add( {
	name = "Weapon_FrontierJustice.Single",
	volume = 1.0,
	level = 95,
	pitch = { 100 },
	sound = {"weapons/frontier_justice_shoot.wav"} 
} )
sound.Add( {
	name = "Weapon_FrontierJustice.SingleCrit",
	volume = 1.0,
	level = 95,
	pitch = { 100 },
	sound = {"weapons/frontier_justice_shoot_crit.wav"} 
} )
sound.Add( {
	name = "HalloweenMerasmus.MERLAGMUS",
	volume = 1.0,
	level = 0,
	channel = CHAN_VOICE,
	pitch = { 100 },
	sound = {
		"vo/halloween_merasmus/sf12_found01.wav",
		"vo/halloween_merasmus/sf12_found02.wav",
		"vo/halloween_merasmus/sf12_found03.wav",
		"vo/halloween_merasmus/sf12_found04.wav",
		"vo/halloween_merasmus/sf12_found05.wav",
		"vo/halloween_merasmus/sf12_found07.wav",
		"vo/halloween_merasmus/sf12_found08.wav",
		"vo/halloween_merasmus/sf12_found09.wav",
	}
} )

sound.Add( {
	name = "SappedRobot",
	channel = CHAN_REPLACE,
	volume = 1.0,
	level = 80,
	pitch = { 100 },
	sound = { "weapons/sapper_timer.wav" }
} )
sound.Add( {
	name = "BanjoSong",
	channel = CHAN_REPLACE,
	volume = 1.0,
	level = 80,
	pitch = { 100 },
	sound = { "player/taunt_bumpkins_banjo_music.wav" }
} )
sound.Add( {
	name = "BanjoSongStop",
	channel = CHAN_REPLACE,
	volume = 1.0,
	level = 80,
	pitch = { 100 },
	sound = { "player/taunt_bumpkins_banjo_music_stop.wav" }
} )
sound.Add( {
	name = "GrappledFlesh",
	channel = CHAN_REPLACE,
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = { "weapons/grappling_hook_impact_flesh_loop.wav" }
} )
sound.Add( {
	name = "BusterLoop",
	channel = CHAN_REPLACE,
	volume = 1.0,
	level = 125,
	pitch = { 100 },
	sound = { "mvm/sentrybuster/mvm_sentrybuster_loop.wav" }
} )
sound.Add( {
	name = "TankMusicLoop",
	channel = CHAN_REPLACE,
	volume = 1.0,
	level = 50,
	pitch = { 100 },
	sound = { "music/tank/tank.wav","music/tank/taank.wav","music/tank/tank_metal.wav" }
} )
sound.Add( {
	name = "TankMidnightMusicLoop",
	channel = CHAN_REPLACE,
	volume = 1.0,
	level = 50,
	pitch = { 100 },
	sound = { "music/tank/onebadtank.wav","music/tank/midnighttank.wav" }
} )

 

hook.Add("PlayerFootstep", "RoboStep", function( ply, pos, foot, sound, volume, rf)
	if (GetConVar("tf_enable_server_footsteps"):GetBool() or (CLIENT and !LocalPlayer():IsHL2() and LocalPlayer():ShouldDrawLocalPlayer())) then
		if (SERVER) then
			return false
		else
			return true
		end
	end--[[
	if ply:GetPlayerClass() == "tank_l4d" then
		if SERVER then
			util.ScreenShake( ply:GetPos(), 14, 14, 0.8, 1200 )
		end
	end]]
	if ply:GetPlayerClass() == "l4d_zombie" and ply:GetModel() != "models/cpthazama/l4d2/common/common_male_clown.mdl" then
		if SERVER then
			ply:EmitSound("CommonZombie.Footstep")
		end
	elseif ply:GetPlayerClass() == "l4d_zombie" and ply:GetModel() == "models/cpthazama/l4d2/common/common_male_clown.mdl" then
		
		if SERVER then
			ply:EmitSound("CommonZombie.ClownFootstep")
		end

	elseif ply:GetPlayerClass() == "l4d_zombie" and ply:GetModel() == "models/cpthazama/l4d2/common/common_male_riot.mdl" then
		
		if SERVER then
			ply:EmitSound("vj_l4d_com/footstep/riot/tile"..math.random(1,4)..".wav")
		end
	end
	if ply:GetPlayerClass() == "poisonzombie" then
		ply:EmitSound("NPC_PoisonZombie.FootstepLeft") 
		return true
	end
	if ply:GetPlayerClass() == "zombie" then
		ply:EmitSound("Zombie.FootstepLeft") 
		return true
	end
	if ply:GetPlayerClass() == "zombine" then
		ply:EmitSound("npc/zombine/gear"..math.random(1,3)..".wav") 
		return true
	end
	if ply:GetPlayerClass() == "fastzombie" then
		ply:EmitSound("Zombie.FootstepLeft") 
		return true
	end
	if not ply:IsHL2() and ply:GetInfoNum("jakey_antlionfbii", 0) == 1 then
		ply:EmitSound( "^npc/antlion_guard/antlionguard_foot_heavy"..math.random(1,2)..".wav", 120, math.random(98, 103) ) -- Play the footsteps hunter is using
		return true -- Don't allow default footsteps
	end
	if ply:GetInfoNum("dylan_rageheavy", 0) == 1 then
		ply:EmitSound( "physics/concrete/boulder_impact_hard"..math.random(1,3)..".wav", 150, math.random(70,120) ) -- Play the footsteps hunter is using
		return true -- Don't allow default footsteps
	end
	if not ply:IsHL2() and ply:GetInfoNum("tf_mvm_giant_voodoo", 0) == 1 then
		ply:EmitSound( "MVM.GiantHeavyStep" ) -- Play the footsteps hunter is using
		return true -- Don't allow default footsteps
	end
	if not ply:IsHL2() and ply:GetInfoNum("tf_sentrybuster", 0) == 1 then
		ply:EmitSound( "MVM.SentryBusterStep" ) -- Play the footsteps hunter is using
		return true -- Don't allow default footsteps
	end
	if not ply:IsHL2() and ply:GetPlayerClass() == "merc_dm" and ply:GetInfoNum("tf_silentthirdpersonsteps", 0) == 1 then
		ply:EmitSound("npc/combine_soldier/vo/_period.wav")
		return true
	end 
	
	if ((CLIENT and ply == LocalPlayer()) or ply:IsHL2()) then
		return false
	else
		return true
	end
end)

chats = {}

net.Receive("botVoiceStart", function()
    local ply = net.ReadEntity()
    local soundn = net.ReadString()
    local time = SoundDuration(soundn) -- - 0.1 

    if !IsValid(ply) or !ply:IsBot() or (IsValid(ply.ChattingS) and ply.ChattingS:GetState() == GMOD_CHANNEL_PLAYING) then return end

    -- tts tests
    -- sound.PlayURL([[https://translate.google.com/translate_tts?ie=UTF-8&tl=en-us&client=tw-ob&q="]] .. voiceline .. [["]], "mono", function(station)
    sound.PlayFile("sound/" .. soundn, "mono", function(station)
        if IsValid(station) then
            ply.ChattingS = station
            station:SetPlaybackRate(math.random(95, 105) * 0.01)
            station:Play()
            hook.Call("PlayerStartVoice", gmod.GetGamemode(), ply)

            timer.Simple(time, function()
                if IsValid(ply) then
                    hook.Call("PlayerEndVoice", gmod.GetGamemode(), ply)
                    station:Stop()
                    --ply.ChattingB = false
                end
            end)
        end
    end)
end)
hook.Add("Think", "PlayerStuff", function()	
	for k,pl in ipairs(player.GetAll()) do
	
		if (!pl:Alive()) then
			if (IsValid(pl:GetNWEntity("RagdollEntity"))) then
				pl:SetMoveType(MOVETYPE_NONE)
				pl:SetPos(pl:GetNWEntity("RagdollEntity"):GetPos())
			else
				pl:SetMoveType(MOVETYPE_NONE)
			end
		end
		
		if not pl.anim_Jumping and !pl:IsOnGround() then
			pl.anim_Jumping = true
			pl.anim_FirstJumpFrame = false
			pl.anim_JumpStartTime = 0
			local firstjumpframe = pl.anim_FirstJumpFrame
			
			if pl.anim_FirstJumpFrame then
				pl.anim_FirstJumpFrame = false
				pl:AnimRestartMainSequence()
			end 
			
			if pl:WaterLevel() >= 2 or --[[(CurTime() - pl.anim_JumpStartTime > 0.2 and]] pl:OnGround() --[[)]] then
				pl.anim_Jumping = false
				pl.anim_GroundTime = nil 
				
				if pl:OnGround() then
					pl:AnimRestartGesture(GESTURE_SLOT_JUMP, ACT_MP_JUMP_LAND, true)
				end 
			end
			
			
			if pl.anim_Jumping then
				if pl:GetPlayerClass() == "combinesoldier" or pl:GetPlayerClass() == "rebel" or pl:GetPlayerClass() == "metrocop" then
					if pl.anim_JumpStartTime == 0 then
						if pl.anim_Airwalk then
							pl.anim_CalcIdeal = ACT_GLIDE
						end
					elseif not firstjumpframe and CurTime() - pl.anim_JumpStartTime > pl:SequenceDuration() * pl:GetPlaybackRate() then
						pl.anim_CalcIdeal = ACT_GLIDE
					else
						pl.anim_CalcIdeal = ACT_JUMP
					end
				elseif pl:GetPlayerClass() == "zombie" then
					if pl.anim_JumpStartTime == 0 then
						if pl.anim_Airwalk then
							pl.anim_CalcIdeal = ACT_HL2MP_JUMP_SLAM
						end
					elseif not firstjumpframe and CurTime() - pl.anim_JumpStartTime > pl:SequenceDuration() * pl:GetPlaybackRate() then
						pl.anim_CalcIdeal = ACT_HL2MP_JUMP_SLAM
					else
						pl.anim_CalcIdeal = ACT_HL2MP_JUMP_SLAM
					end
				elseif pl:IsL4D() then								
					if pl.anim_JumpStartTime == 0 then
						if pl.anim_Airwalk then
							pl.anim_CalcIdeal = ACT_JUMP
						end
					elseif not firstjumpframe and CurTime() - pl.anim_JumpStartTime > pl:SequenceDuration() * pl:GetPlaybackRate() then
						pl.anim_CalcIdeal = ACT_JUMP
					else
						pl.anim_CalcIdeal = ACT_JUMP
					end
				elseif pl:GetPlayerClass() == "fastzombie" then
					if pl.anim_JumpStartTime == 0 then
						if pl.anim_Airwalk then
							pl.anim_CalcIdeal = ACT_ZOMBIE_LEAPING
						end
					elseif not firstjumpframe and CurTime() - pl.anim_JumpStartTime > pl:SequenceDuration() * pl:GetPlaybackRate() then
						pl.anim_CalcIdeal = ACT_ZOMBIE_LEAPING
					else
						pl.anim_CalcIdeal = ACT_ZOMBIE_LEAP_START
					end
				elseif pl:GetPlayerClass() == "poisonzombie" then 
					if pl.anim_JumpStartTime == 0 then
						if pl.anim_Airwalk then
							pl.anim_CalcIdeal = ACT_RUN
						end
					elseif not firstjumpframe and CurTime() - pl.anim_JumpStartTime > pl:SequenceDuration() * pl:GetPlaybackRate() then
						pl.anim_CalcIdeal = ACT_RUN
					else
						pl.anim_CalcIdeal = ACT_RUN
					end
				elseif pl:GetPlayerClass() == "zombine" then
					if pl.anim_JumpStartTime == 0 then
						if pl.anim_Airwalk then
							pl.anim_CalcIdeal = ACT_RUN
						end
					elseif not firstjumpframe and CurTime() - pl.anim_JumpStartTime > pl:SequenceDuration() * pl:GetPlaybackRate() then
						pl.anim_CalcIdeal = ACT_RUN
					else
						pl.anim_CalcIdeal = ACT_RUN
					end
				else
					if pl.anim_JumpStartTime == 0 then
						if pl.anim_Airwalk then
							pl.anim_CalcIdeal = ACT_MP_AIRWALK
						end
					elseif not firstjumpframe and CurTime() - pl.anim_JumpStartTime > pl:SequenceDuration() * pl:GetPlaybackRate() then
						pl.anim_CalcIdeal = ACT_MP_JUMP_FLOAT
					else
						pl.anim_CalcIdeal = ACT_MP_JUMP_START
					end
				end
			end
		end
	end
end)
local voice = Material("voice/icntlk_pl")
-- is there no way to force this on?
hook.Add("PostPlayerDraw", "LeadBot_VoiceIcon", function(ply)
    if !IsValid(ply) or !ply:IsPlayer() or !ply:IsBot() or !IsValid(ply.ChattingS) then return end

    local ang = EyeAngles()
    local pos = ply:GetPos() + ply:GetViewOffset() + Vector(0, 0, 14)
    ang:RotateAroundAxis(ang:Up(), -90)
    ang:RotateAroundAxis(ang:Forward(), 90)

    cam.Start3D2D(pos, ang, 1)
        surface.SetMaterial(voice)
        surface.DrawTexturedRect(-8, -8, 16, 16)
    cam.End3D2D()
end)
 
sound.Add( {
	name = "MVM.GiantWTFDemomanLoop",
	channel = CHAN_STATIC,
	volume = 0.6,
	level = 82,
	pitch = { 100 },
	sound = { 
		"music/conga_sketch_167bpm_01-04.wav"
	}
} )
sound.Add( {
	name = "Weapon_Gluon.Start",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 95,
	pitch = { 125 },
	sound = { 
		"weapons/egon_windup2.wav"
	}
} )
sound.Add( {
	name = "Weapon_Gluon.Run",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 95,
	pitch = { 125 },
	sound = { 
		"weapons/egon_run3.wav"
	}
} )
sound.Add( {
	name = "Scientist.Pain",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = { 
		"scientist/sci_pain1.wav",
		"scientist/sci_pain2.wav",
		"scientist/sci_pain3.wav",
		"scientist/sci_pain4.wav",
		"scientist/sci_pain5.wav",
		"scientist/sci_pain6.wav",
		"scientist/sci_pain7.wav",
		"scientist/sci_pain8.wav",
		"scientist/sci_pain9.wav",
		"scientist/sci_pain10.wav",
	}
} )
sound.Add( {
	name = "Ambient.NucleusElectricity",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 105,
	pitch = { 100 },
	sound = { ")ambient/nucleus_electricity.wav" }
} )
sound.Add( {
	name = "Psap.Death",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 105,
	pitch = { 100 },
	sound = { "vo/items/wheatley_sapper/wheatley_player_death01.wav", "vo/items/wheatley_sapper/wheatley_player_death02.wav", "vo/items/wheatley_sapper/wheatley_player_death03.wav", "vo/items/wheatley_sapper/wheatley_player_death04.wav", "vo/items/wheatley_sapper/wheatley_player_death05.wav", "vo/items/wheatley_sapper/wheatley_player_death06.wav", "vo/items/wheatley_sapper/wheatley_player_death08.wav", "vo/items/wheatley_sapper/wheatley_player_death09.wav", "vo/items/wheatley_sapper/wheatley_player_death10.wav", "vo/items/wheatley_sapper/wheatley_player_death12.wav", "vo/items/wheatley_sapper/wheatley_player_death13.wav", "vo/items/wheatley_sapper/wheatley_player_death14.wav", "vo/items/wheatley_sapper/wheatley_player_death15.wav", "vo/items/wheatley_sapper/wheatley_player_death16.wav" , "vo/items/wheatley_sapper/wheatley_player_death17.wav", "vo/items/wheatley_sapper/wheatley_player_death19.wav", "vo/items/wheatley_sapper/wheatley_player_death21.wav", "vo/items/wheatley_sapper/wheatley_player_death22.wav", "vo/items/wheatley_sapper/wheatley_player_death23.wav", "vo/items/wheatley_sapper/wheatley_player_death24.wav", "vo/items/wheatley_sapper/wheatley_player_death25.wav", "vo/items/wheatley_sapper/wheatley_player_death26.wav"}
} )
sound.Add( {
	name = "Grappling",
	channel = CHAN_REPLACE,
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = { "weapons/grappling_hook_reel_start.wav" }
} )
sound.Add( {
	name = "TappedRobot",
	channel = CHAN_REPLACE,
	volume = 1.0,
	level = 80,
	pitch = { 100 },
	sound = { "weapons/spy_tape_01.wav","weapons/spy_tape_02.wav","weapons/spy_tape_03.wav","weapons/spy_tape_04.wav" ,"weapons/spy_tape_05.wav" }
} )


sound.Add( {
	name = "Weapon_Tomislav.Fire",
	volume = 1.0,
	level = 90,
	pitch = { 93 },
	channel = CHAN_WEAPON,
	sound = { "weapons/tomislav_shoot.wav" } 
} )
sound.Add( { 
	name = "Weapon_Tomislav.FireCrit",
	volume = 1.0,
	level = 90,
	pitch = { 93 },
	channel = CHAN_WEAPON,
	sound = { "weapons/tomislav_shoot_crit.wav" } 
} )
sound.Add( {
	name = "Weapon_Tomislav.WindUp",
	volume = 1.0,
	level = 90,
	pitch = { 93 },
	channel = CHAN_WEAPON,
	sound = { "weapons/tomislav_wind_up.wav" } 
} )
sound.Add( {
	name = "Weapon_Tomislav.WindDown",
	volume = 1.0,
	level = 90,
	pitch = { 93 },
	channel = CHAN_WEAPON,
	sound = { "weapons/tomislav_wind_down.wav" } 
} )


sound.Add( {
	name = "ControlPoint.Start",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = { 100 },
	sound = "misc/hologram_start.wav"
} )

sound.Add( {
	name = "ControlPoint.Move",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = { 100 },
	sound = "misc/hologram_move.wav"
} )

sound.Add( {
	name = "ControlPoint.Malfunction",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = { 100 },
	sound = "misc/hologram_malfunction.wav"
} )
sound.Add( {
	name = "ControlPoint.Stop",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = { 100 },
	sound = "misc/hologram_stop.wav"
} )
sound.Add( {
	name = "Player.DrownStart",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 80,
	pitch = { 90,110 },
	sound = {"player/pl_drown1.wav"}
} )
sound.Add( {
	name = "Player.DrownContinue",
	channel = CHAN_VOICE,
	volume = 1.0,
	level = 80,
	pitch = { 95,105 },
	sound = {"player/drown1.wav","player/drown2.wav","player/drown3.wav"}
} )
HOOK_WARNING_THRESHOLD = 0.1

local old_hook_call = hook.Call
function hook.Call(name, gm, ...)
	if HOOK_WARNING_THRESHOLD then
		local time_start = SysTime()
		local res = {old_hook_call(name, gm, ...)}
		local time = SysTime() - time_start
		
		if time > HOOK_WARNING_THRESHOLD then
			MsgFN("Warning: hook '%s' took %f seconds to execute!", name, time)
		end
		
		return unpack(res)
	else
		return old_hook_call(name, gm, ...)
	end
end

if not util.PrecacheModel0 then
	util.PrecacheModel0 = util.PrecacheModel
end

function util.PrecacheModel(mdl)
	if SERVER and game.SinglePlayer() then return end
	return util.PrecacheModel0(mdl)
end

include("particle_manifest.lua")
include("shd_sounds1.lua")
include("shd_sounds2.lua")
include("vmatrix_extension.lua")

include("tf_lang_module.lua")
tf_lang.Load("tf_english.txt")

include("particle_manifest.lua")
include("vmatrix_extension.lua")

include("shd_nwtable.lua")
include("shd_utils.lua")
include("shd_enums.lua")
include("shd_pyrovision.lua")
include("tf_util_module.lua")
include("tf_item_module.lua")
include("tf_timer_module.lua")
include("tf_soundscript_module.lua")


include("shd_objects.lua")
include("shd_attributes.lua")
include("shd_loadout.lua")
include("shd_extras.lua")
include("shd_workshop.lua")
 
include("shd_competitive.lua")
include("shd_spec.lua")

--include("shd_items_temp.lua")

include("shd_maptypes.lua")
include("shd_playeranim.lua")

include("shd_criticals.lua")

include("shd_ragdolls.lua")
include("shd_ragdolls2.lua")

include("shd_items_game.lua")    
include("shd_conflict.lua") 
if (IsMounted("thestanleyparable")) then 
	sound.AddSoundOverrides("scripts/npc_sounds_stanley.txt")
	sound.AddSoundOverrides("scripts/soundscapes_stanley.txt")
end
if (IsMounted("left4dead2")) then 
	sound.AddSoundOverrides("scripts/l4d2_game_sounds_doors.txt")
	sound.AddSoundOverrides("scripts/l4d2_game_sounds_weapons.txt")
	sound.AddSoundOverrides("scripts/l4d2_game_sounds_music.txt")
	sound.AddSoundOverrides("scripts/l4d2_game_sounds_player.txt")
	sound.AddSoundOverrides("scripts/l4d2_game_sounds_infected_common.txt")
	sound.AddSoundOverrides("scripts/l4d2_game_sounds_infected_special.txt")
	player_manager.AddValidModel("infected_smoker","models/infected/smoker.mdl")
	player_manager.AddValidHands("infected_smoker","models/v_models/weapons/v_claw_smoker.mdl")
	player_manager.AddValidModel("infected_smoker_l4d1","models/infected/smoker_l4d1.mdl")
	player_manager.AddValidHands("infected_smoker_l4d1","models/v_models/weapons/v_claw_smoker_l4d1.mdl")
	player_manager.AddValidModel("infected_boomer","models/infected/boomer.mdl")
	player_manager.AddValidHands("infected_boomer","models/v_models/weapons/v_claw_boomer.mdl")
	player_manager.AddValidModel("infected_boomette","models/infected/boomette.mdl")
	player_manager.AddValidHands("infected_boomette","models/v_models/weapons/v_claw_boomer.mdl")
	player_manager.AddValidModel("infected_boomer_l4d1","models/infected/boomer_l4d1.mdl")
	player_manager.AddValidHands("infected_boomer_l4d1","models/v_models/weapons/v_claw_boomer_l4d1.mdl")
	player_manager.AddValidModel("infected_hunter","models/infected/hunter.mdl")
	player_manager.AddValidHands("infected_hunter","models/v_models/weapons/v_claw_hunter.mdl")
	player_manager.AddValidModel("infected_hunter_l4d1","models/infected/hunter_l4d1.mdl")
	player_manager.AddValidHands("infected_hunter_l4d1","models/v_models/weapons/v_claw_hunter_l4d1.mdl")
	player_manager.AddValidModel("infected_tank","models/infected/hulk.mdl")
	player_manager.AddValidHands("infected_tank","models/v_models/weapons/v_claw_hulk.mdl")
	player_manager.AddValidModel("infected_tank_sacrifice","models/infected/hulk_dlc3.mdl")
	player_manager.AddValidHands("infected_tank_sacrifice","models/v_models/weapons/v_claw_hulk_dlc3.mdl")
	player_manager.AddValidModel("infected_tank_l4d1","models/infected/hulk_l4d1.mdl")
	player_manager.AddValidHands("infected_tank_l4d1","models/v_models/weapons/v_claw_hulk_l4d1.mdl")
	player_manager.AddValidModel("infected_witch","models/infected/witch.mdl")
	player_manager.AddValidHands("infected_witch","models/v_models/weapons/v_claw_hunter.mdl")
	player_manager.AddValidModel("infected_witch_bride","models/infected/witch_bride.mdl")
	player_manager.AddValidHands("infected_witch_bride","models/v_models/weapons/v_claw_hunter.mdl")
	player_manager.AddValidModel("infected_jockey","models/infected/jockey.mdl")
	player_manager.AddValidHands("infected_jockey","models/weapons/arms/v_jockey_arms.mdl")
	player_manager.AddValidModel("infected_spitter","models/infected/spitter.mdl")
	player_manager.AddValidHands("infected_spitter","models/weapons/arms/v_spitter_arms.mdl")
	player_manager.AddValidModel("infected_charger","models/infected/charger.mdl")
	player_manager.AddValidHands("infected_charger","models/weapons/arms/v_charger_arms.mdl")
end
if (IsMounted("left4dead")) then 
	sound.AddSoundOverrides("scripts/l4d1_game_sounds_infected_special.txt") 
end
sound.AddSoundOverrides("scripts/game_sounds_mvm.txt") 
sound.AddSoundOverrides("scripts/game_sounds_weapons_tf.txt")
sound.AddSoundOverrides("scripts/game_sounds_weapons_tf2.txt")
sound.AddSoundOverrides("scripts/game_sounds_weapons_l4d1.txt") 
sound.AddSoundOverrides("scripts/game_sounds_player.txt")
sound.AddSoundOverrides("scripts/game_sounds_music.txt")
sound.AddSoundOverrides("scripts/game_sounds_vo.txt")
sound.AddSoundOverrides("scripts/game_sounds_vo_handmade.txt")
sound.AddSoundOverrides("scripts/game_sounds_vo_mvm.txt")
sound.AddSoundOverrides("scripts/game_sounds_vo_merasmus.txt")
sound.AddSoundOverrides("scripts/game_sounds_vo_mvm_handmade.txt")
sound.AddSoundOverrides("scripts/game_sounds_vo_mvm_mighty.txt")
sound.AddSoundOverrides("scripts/game_sounds_vo_pauling.txt")
sound.AddSoundOverrides("scripts/game_sounds_vo_rd_robots.txt")
sound.AddSoundOverrides("scripts/game_sounds_vo_taunts.txt")
sound.AddSoundOverrides("scripts/game_sounds_vo_tough_break.txt")
sound.AddSoundOverrides("scripts/game_sounds_vo_lfce.txt") 
sound.AddSoundOverrides("scripts/game_sounds_vo_tf2c.txt") 
sound.AddSoundOverrides("scripts/game_sounds.txt")


hook.Add("PlayerStepSoundTime", "FootTime", function(ply, iType, iWalking)
	if (ply:GetPlayerClass() == "tank_l4d") then
		if (ply:Crouching() || ply:GetMoveType() == MOVETYPE_LADDER) then
			local speed = 250 + 100
			return speed
		else
			local speed = 250
			return speed
		end
	end
	if (ply:GetPlayerClass() == "boomer") then
		if (ply:Crouching() || ply:GetMoveType() == MOVETYPE_LADDER) then
			local speed = 400 + 100
			return speed
		else
			local speed = 350
			return speed
		end
	end
	if (ply:GetPlayerClass() == "charger") then
		if (ply:Crouching() || ply:GetMoveType() == MOVETYPE_LADDER) then
			local speed = 300 + 100
			return speed
		else
			local speed = 270
			return speed
		end
	end
	if (ply:GetPlayerClass() == "smoker") then
		if (ply:Crouching() || ply:GetMoveType() == MOVETYPE_LADDER) then
			local speed = 400 + 100
			return speed
		else
			local speed = 370
			return speed
		end
	end
	if (ply:GetPlayerClass() == "hunter") then
		if (ply:Crouching() || ply:GetMoveType() == MOVETYPE_LADDER) then
			local speed = 400 + 100
			return speed
		else
			local speed = 360
			return speed
		end
	end
	if (iType == STEPSOUNDTIME_ON_LADDER) then
		local speed = 350
		return speed
	end
	if (iType == STEPSOUNDTIME_NORMAL || iType == STEPSOUNDTIME_WATER_FOOT) then
		if (ply:GetMoveType() == MOVETYPE_LADDER) then
			local speed = math.Remap(ply:GetMaxSpeed(), 200, 450, 400, 200) + 100
			return speed
		else
			if (ply:Crouching()) then
				local speed = math.Remap(ply:GetMaxSpeed(), 200, 450, 400, 200) + 100 + ply:GetVelocity():Length2D() / (ply:GetMaxSpeed() * 0.8)
				return speed
			else
				if (ply:GetWalkSpeed() > 450) then
				
					local speed = 200 + ply:GetVelocity():Length2D() / (ply:GetMaxSpeed() * 0.8)
					return speed
					
				else
					if (ply:GetWalkSpeed() < 229 and !ply:KeyDown(IN_SPEED)) then
					
						local speed = 400 + ply:GetVelocity():Length2D() / (ply:GetMaxSpeed() * 0.8)
						return speed 
						
					else
						local speed = math.Remap(ply:GetMaxSpeed(), 200, 450, 400, 200) + ply:GetVelocity():Length2D() / (ply:GetMaxSpeed() * 0.8)
						return speed
					end
				end
			end
		end
	end
	if (iType == STEPSOUNDTIME_WATER_KNEE) then
		if (ply:Crouching()) then
			local speed = math.Remap(ply:GetMaxSpeed(), 200, 450, 600, 200) + 100
			return speed
		else
			if (ply:GetWalkSpeed() > 450) then
			
				local speed = 200
				return speed
				
			else
				if (ply:GetWalkSpeed() < 229 and !ply:KeyDown(IN_SPEED)) then
					
					local speed = 400
					return speed 
						
				else
					local speed = math.Remap(ply:GetMaxSpeed(), 200, 450, 600, 200)
					return speed
				end
			end
		end
	end
end)


--CreateClientConVar( "snd_soundmixer", "Default_Mix", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_ARCHIVE}, "Become a robot after respawning." )
CreateConVar( "civ2_legs", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_DEVELOPMENTONLY, FCVAR_ARCHIVE}, "LEGS!" )
CreateConVar( "civ2_allow_respawn_with_key_press", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Players will respawn on key press without waiting for the freeze cam to finish." )
CreateConVar( "civ2_smooth_worldmodel_turning", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "" )
CreateConVar( "z_debug", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Whether or not players will have a flashlight as a TF2 Class" )
CreateConVar( "tf_allow_pickup_weapons", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "When enabled, Anyone can pickup weapons." )
CreateConVar( "tf_enable_unused_mvm_sounds", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "When enabled, some sounds will be using some unused sound effects from MVM." )
CreateConVar( "tf_enable_hl2_ragdoll_sounds", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "When enabled, some sounds will be using some HL2 ragdoll sound effects." )
CreateConVar( "tf_enable_l4d2_ragdoll_sounds", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "When enabled, some sounds will be using some L4D2 ragdoll sound effects." )
CreateConVar( "tf_enable_server_footsteps", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "When enabled, some sounds will be using some L4D2 ragdoll sound effects." )
CreateConVar( "civ2_randomizer", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Randomize sounds and NPCs" )
CreateConVar( "tf_use_hl_hull_size", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Whether or not players use the HL2 hull size found on coop." ) 
CreateConVar( "tf_pyrovision", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Whether or not pyrovision may be enabled" )
CreateConVar( "tf_kill_on_change_class", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Whether or not players will die if they change class." )
CreateConVar( "tf_flashlight", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Whether or not players will have a flashlight as a TF2 Class" )
CreateConVar( "tf_muselk_zombies", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Zombies")
CreateConVar( "tf_enable_revive_markers", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Enable/Disable Revive Markers" )
CreateConVar( "tf_crossover_mode", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Enable/Disable Crossover Mode" )
CreateConVar( "tf_disable_nonred_mvm", "1", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Disable BLU and neutral" )
CreateConVar('tf_talkicon_computablecolor', 1, FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE, 'Compute color from location brightness.')
CreateConVar('tf_bot_mvm_max_deaths', 20, FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE, 'Maximum Deaths. Not Functional.')
CreateConVar('tf_grapplinghook_enable', 0, FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE, 'When Enabled: TF2 Players get the Grappling Hook.')
CreateConVar('tf_bot_mvm_has_bots', 0, FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE, 'Automatically set by Lua')
CreateConVar('tf_bot_mvm_giant_max_deaths', 3, FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE, 'Maximum Deaths. Not Functional.')
CreateConVar('tf_talkicon_showtextchat', 1, FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE, 'Show icon on using text chat.')
CreateConVar('tf_talkicon_ignoreteamchat', 1, FCVAR_ARCHIVE + FCVAR_REPLICATED + FCVAR_SERVER_CAN_EXECUTE, 'Disable over-head icon on using team chat.')
CreateConVar("tf_unlimited_buildings", 0, {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CHEAT})
CreateConVar("tf_use_client_ragdolls", 1, {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED})
CreateConVar( "civ2_enable_be_the_bosses", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "!!!EXPERIMENTAL!!! - Port Be the Bosses 2 from TF2 to Garry's Mod" )
hook.Add( "EntityEmitSound", "TimeWarpSounds", function( t )
end )

concommand.Add("tf_spydisguise", function(ply, cmd)
end)


if (SERVER) then

	RunConsoleCommand('mp_show_voice_icons', '0')

	util.AddNetworkString('TalkIconChat')

	net.Receive('TalkIconChat', function(_, ply)
		local bool = net.ReadBool()
		ply:SetNW2Bool('ti_istyping', (bool ~= nil) and bool or false)
	end)

elseif (CLIENT) then

	local computecolor = GetConVar('tf_talkicon_computablecolor')
	local showtextchat = GetConVar('tf_talkicon_showtextchat')
	local noteamchat = GetConVar('tf_talkicon_ignoreteamchat')

	local voice_mat = Material('effects/speech_voice_red')
	local voice_mat2 = Material('effects/speech_voice_blue')
	local text_mat = Material('effects/speech_typing')

	hook.Add('PostPlayerDraw', 'TalkIcon', function(ply)
		if ply == LocalPlayer() and GetViewEntity() == LocalPlayer() and !LocalPlayer():ShouldDrawLocalPlayer() then return end
		if not ply:Alive() then return end
		if not ply:IsSpeaking() then return end

		local pos = ply:GetPos() + Vector(0, 0, ply:GetModelRadius() + 10)
		if (ply:LookupBone("bip_head")) then
			pos = ply:GetBonePosition(ply:LookupBone("bip_head")) + Vector(0, 0, 16)
		elseif (ply:LookupBone("ValveBiped.Bip01_Head1")) then
			pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1")) + Vector(0, 0, 16)
		end

		if ply:Team() == TEAM_BLU then
			render.SetMaterial(ply:IsSpeaking() and voice_mat2 or voice_mat2)
		else
			render.SetMaterial(ply:IsSpeaking() and voice_mat or voice_mat)		
		end

		local color_var = 255

		if computecolor:GetBool() then
			local computed_color = render.ComputeLighting(ply:GetPos(), Vector(0, 0, 1))
			local max = math.max(computed_color.x, computed_color.y, computed_color.z)
			color_var = math.Clamp(max * 255 * 1.11, 0, 255)
		end

		render.DrawSprite(pos, 16, 16, Color(color_var, color_var, color_var, 255))
	end)
	hook.Add('PostPlayerDraw', 'TalkIcon2', function(ply)
		if ply == LocalPlayer() and GetViewEntity() == LocalPlayer() and !LocalPlayer():ShouldDrawLocalPlayer() then return end
		if not ply:Alive() then return end
		if not ply:IsTyping() then return end

		local pos = ply:GetPos() + Vector(0, 0, ply:GetModelRadius() + 10)
		if (ply:LookupBone("bip_head")) then
			pos = ply:GetBonePosition(ply:LookupBone("bip_head")) + Vector(0, 0, 16)
		elseif (ply:LookupBone("ValveBiped.Bip01_Head1")) then
			pos = ply:GetBonePosition(ply:LookupBone("ValveBiped.Bip01_Head1")) + Vector(0, 0, 16)
		end

		render.SetMaterial(Material("effects/speech_typing"))

		local color_var = 255

		if computecolor:GetBool() then
			local computed_color = render.ComputeLighting(ply:GetPos(), Vector(0, 0, 1))
			local max = math.max(computed_color.x, computed_color.y, computed_color.z)
			color_var = math.Clamp(max * 255 * 1.11, 0, 255)
		end

		render.DrawSprite(pos, 16, 16, Color(color_var, color_var, color_var, 255))
	end)


	hook.Add("InitPostEntity", "RemoveChatBubble", function()
		hook.Remove("StartChat", "StartChatIndicator")
		hook.Remove("FinishChat", "EndChatIndicator")

		hook.Remove("PostPlayerDraw", "DarkRP_ChatIndicator")
		hook.Remove("CreateClientsideRagdoll", "DarkRP_ChatIndicator")
		hook.Remove("player_disconnect", "DarkRP_ChatIndicator")
	end)

end

function GM:PostTFLibsLoaded()
end

hook.Call("PostTFLibsLoaded", GM)

GM.Name 		= "Team Fortress 2"
GM.Author 		= "_Kilburn; Fixed by wango911; Ported by Jcw87; Workshopped by Agent Agrimar"
GM.Email 		= "N/A"
GM.Website 		= "N/A"
GM.TeamBased 	= true

GM.Data = {} 

DEFINE_BASECLASS("gamemode_sandbox")
DeriveGamemode("sandbox")
GM.IsSandboxDerived = true 

function GM:GetGameDescription()
	return self.Name
end

local VoiceMenuChatMessage = {
	["TLK_PLAYER_MEDIC"] = 			"#Voice_Menu_Medic",
	["TLK_PLAYER_THANKS"] = 		"#Voice_Menu_Thanks",
	["TLK_PLAYER_GO"] = 			"#Voice_Menu_Go",
	["TLK_PLAYER_MOVEUP"] = 		"#Voice_Menu_MoveUp",
	["TLK_PLAYER_LEFT"] = 			"#Voice_Menu_Left",
	["TLK_PLAYER_RIGHT"] = 			"#Voice_Menu_Right",
	["TLK_PLAYER_YES"] = 			"#Voice_Menu_Yes",
	["TLK_PLAYER_NO"] = 			"#Voice_Menu_No",
	["TLK_PLAYER_INCOMING"] = 		"#Voice_Menu_Incoming",
	["TLK_PLAYER_CLOAKEDSPY"] = 	"#Voice_Menu_CloakedSpy",
	["TLK_MVM_SNIPER_CALLOUT"] = 	"Sniper!",
	["TLK_MVM_ENCOURAGE_UPGRADE"] = 	"Upgrade!",
	["TLK_PLAYER_SENTRYAHEAD"] = 	"#Voice_Menu_SentryAhead",
	["TLK_PLAYER_ACTIVATECHARGE"] = "#Voice_Menu_ActivateCharge",
	["TLK_PLAYER_HELP"] = 			"#Voice_Menu_Help",
}

local VoiceMenuGesture = {
	["TLK_PLAYER_MEDIC"] =			ACT_MP_GESTURE_VC_HANDMOUTH,
	["TLK_PLAYER_THANKS"] =			ACT_MP_GESTURE_VC_THUMBSUP,
	["TLK_PLAYER_GO"] =				ACT_MP_GESTURE_VC_FINGERPOINT,
	["TLK_PLAYER_MOVEUP"] =			ACT_MP_GESTURE_VC_FINGERPOINT,
	["TLK_PLAYER_LEFT"] =			ACT_MP_GESTURE_VC_FINGERPOINT,
	["TLK_PLAYER_RIGHT"] =			ACT_MP_GESTURE_VC_FINGERPOINT,
	["TLK_PLAYER_YES"] =			ACT_MP_GESTURE_VC_NODYES,
	["TLK_PLAYER_NO"] =				ACT_MP_GESTURE_VC_NODNO,
	["TLK_PLAYER_INCOMING"] =		ACT_MP_GESTURE_VC_HANDMOUTH,
	["TLK_PLAYER_CLOAKEDSPY"] =		nil,
	["TLK_PLAYER_SENTRYAHEAD"] =	ACT_MP_GESTURE_VC_FINGERPOINT,
	["TLK_PLAYER_TELEPORTERHERE"] =	nil,
	["TLK_PLAYER_DISPENSERHERE"] =	nil,
	["TLK_PLAYER_SENTRYHERE"] =		nil,
	["TLK_PLAYER_ACTIVATECHARGE"] =	nil,
	["TLK_PLAYER_CHARGEREADY"] =	ACT_MP_GESTURE_VC_THUMBSUP,
	["TLK_PLAYER_HELP"] =			ACT_MP_GESTURE_VC_HANDMOUTH,
	["TLK_PLAYER_BATTLECRY"] =		ACT_MP_GESTURE_VC_FISTPUMP,
	["TLK_PLAYER_CHEERS"] =			ACT_MP_GESTURE_VC_FISTPUMP,
	["TLK_PLAYER_JEERS"] =			nil,
	["TLK_PLAYER_POSITIVE"] =		nil,
	["TLK_PLAYER_NEGATIVE"] =		nil,
	["TLK_PLAYER_NICESHOT"] =		ACT_MP_GESTURE_VC_THUMBSUP,
	["TLK_PLAYER_GOODJOB"] =		ACT_MP_GESTURE_VC_THUMBSUP,
}

concommand.Remove("__svspeak")

--[[concommand.Add( "changeteam", function( pl, cmd, args )
	--if tonumber( args[ 1 ] ) >= 5 then return end
	hook.Call( "PlayerRequestTeam", GAMEMODE, pl, tonumber( args[ 1 ] ) )
	print("changeteam?? to what, oh, team "..tonumber( args[ 1 ] ).."!")
end )]]


if SERVER then

util.AddNetworkString("ActivateTauntCam")
util.AddNetworkString("DeActivateTauntCam")
util.AddNetworkString("DeActivateTauntCamImmediate")

concommand.Add("__svspeak", function(pl,_,args)
	if pl:Speak(args[1]) then
		if VoiceMenuGesture[args[1]] then
			pl:DoAnimationEvent(VoiceMenuGesture[args[1]], true)
		end
		
		umsg.Start("TFPlayerVoice")
			umsg.Entity(pl)
			umsg.String(args[1])
		umsg.End()
	end
end)

concommand.Add("l4d__svspeak", function(pl,_,args)
	if pl:GetPlayerClass() == "tank_l4d" then
		pl:EmitSound("Tank.Yell")
	elseif pl:GetPlayerClass() == "charger" then
		pl:EmitSound("Charger.Idle")
	elseif pl:GetPlayerClass() == "boomer" then
		pl:EmitSound("vj_l4d/boomer/voice/idle/male_boomer_lurk_0"..math.random(1,9)..".wav",90,100,1,CHAN_VOICE)
	elseif pl:GetPlayerClass() == "l4d_zombie" then
		pl:EmitSound("vj_l4d_com/attack_b/male/rage_"..math.random(50,82)..".wav",90,100,1,CHAN_VOICE)
	end
end)

else

usermessage.Hook("TFPlayerVoice", function(msg)
	local pl = msg:ReadEntity()
	local voice = msg:ReadString()
	
	if not IsValid(pl) or not pl:IsPlayer() then return end
	if pl:Team() ~= TEAM_SPECTATOR and pl:Team() ~= LocalPlayer():Team() then return end
	
	local v = VoiceMenuChatMessage[voice]
	if not v then return end
	
	chat.AddText(
		team.GetColor(pl:Team()),
		Format("(%s) %s", tf_lang.GetRaw("#Voice"), pl:GetName()),
		color_white,
		Format(": %s", tf_lang.GetRaw(v))
	)
end)

end

GIBS_DEMOMAN_START	= 1
GIBS_ENGINEER_START	= 7
GIBS_HEAVY_START	= 14
GIBS_MEDIC_START	= 21
GIBS_PYRO_START		= 29
GIBS_SCOUT_START	= 37
GIBS_SNIPER_START	= 46
GIBS_SOLDIER_START	= 53
GIBS_SPY_START		= 61
GIBS_ORGANS_START	= 68
GIBS_SILLY_START	= 69
GIBS_LAST			= 87

GIB_UNKNOWN		= -1
GIB_HAT			= 0
GIB_LEFTLEG		= 1
GIB_RIGHTLEG	= 2
GIB_LEFTARM		= 3
GIB_RIGHTARM	= 4
GIB_TORSO		= 5
GIB_TORSO2		= 6
GIB_EQUIPMENT1	= 7
GIB_EQUIPMENT2	= 8
GIB_HEAD		= 9
GIB_HEADGEAR1	= 10
GIB_HEADGEAR2	= 11
GIB_ORGAN		= 12

TEAM_RED = 1
TEAM_BLU = 2
TEAM_YELLOW = 3
TEAM_GREEN = 4
TEAM_NEUTRAL = 5
TEAM_FRIENDLY = 6
TF_TEAM_PVE_INVADERS = -1
TF_TEAM_PVE_INVADERS_GIANT = -1

TeamSecondaryColors = {}
function SetTeamSecondaryColor(t, c)
	TeamSecondaryColors[t] = c
end
 
function GetTeamSecondaryColor(t)
	return TeamSecondaryColors[t] or team.GetColor(t)
end

function GM:CreateTeams()
	team.SetUp(TEAM_RED, "RED", Color(255, 64, 64))
	SetTeamSecondaryColor(TEAM_RED, Color(180, 92, 77))
	team.SetSpawnPoint(TEAM_RED, "info_player_start")
	
	team.SetUp(TEAM_BLU, "BLU", Color(153, 204, 255))
	SetTeamSecondaryColor(TEAM_BLU, Color(104, 124, 155))
	team.SetSpawnPoint(TEAM_BLU, "info_player_start")
	
	team.SetUp(TEAM_YELLOW, "YLW", Color(255, 255, 0))
	SetTeamSecondaryColor(TEAM_YELLOW, Color(255, 255, 0))
	team.SetSpawnPoint(TEAM_YELLOW, "info_player_start")
	
	team.SetUp(TEAM_GREEN, "GRN", Color(0, 255, 0))
	SetTeamSecondaryColor(TEAM_GREEN, Color(0, 255, 0))
	team.SetSpawnPoint(TEAM_GREEN, "info_player_start")
	
	team.SetUp(TEAM_FRIENDLY, "Friendly", Color(255, 192, 203))
	SetTeamSecondaryColor(TEAM_FRIENDLY, Color(255, 192, 203))
	team.SetSpawnPoint(TEAM_FRIENDLY, "info_player_start")

	team.SetUp(TEAM_NEUTRAL, "Neutral", Color(110, 255, 80))
	SetTeamSecondaryColor(TEAM_NEUTRAL, Color(74, 130, 54))
	team.SetSpawnPoint(TEAM_NEUTRAL, "info_player_start")
	
	team.SetUp(TEAM_FRIENDLY, "Friendly", Color(255, 192, 203))
	SetTeamSecondaryColor(TEAM_FRIENDLY, Color(255, 192, 203))
	team.SetSpawnPoint(TEAM_FRIENDLY, "info_player_start")
	
	team.SetUp(TEAM_SPECTATOR, "Spectator", Color(204, 204, 204))
	SetTeamSecondaryColor(TEAM_SPECTATOR, Color(255, 255, 255))
	team.SetSpawnPoint(TEAM_SPECTATOR, "worldspawn")
end

function GM:EntityName(ent, nolocalize)
	if ent then
		if ent:IsPlayer() and ent:IsValid() then
			return ent:Name()
		elseif ent:IsValid() and list.Get("NPC")[ent:GetClass()] and list.Get("NPC")[ent:GetClass()].Name then
			if (ent:GetClass() == "npc_combine_s" && ent:GetModel() == "models/combine_super_soldier.mdl") then
				return "Combine Elite"
			elseif (ent:GetClass() == "npc_combine_s" && ent:GetSkin() == 1 and IsValid(ent:GetActiveWeapon()) and ent:GetActiveWeapon():GetClass() == "weapon_shotgun" && ent:GetModel() != "models/combine_soldier_prisonguard.mdl") then
				return "Shotgun Soldier"
			elseif (ent:GetClass() == "npc_combine_s" && ent:GetModel() == "models/combine_soldier_prisonguard.mdl" and ent:GetSkin() == 0) then
				return "Prison Guard"
			elseif (ent:GetClass() == "npc_combine_s" && ent:GetModel() == "models/combine_soldier_prisonguard.mdl" and IsValid(ent:GetActiveWeapon()) and ent:GetActiveWeapon():GetClass() == "weapon_shotgun") then
				return "Prison Shotgun Guard"
			elseif (ent:GetClass() == "npc_antlionguard" && ent:GetSkin() == 1) then
				return "Antlion Guardian"
			else
				return list.Get("NPC")[ent:GetClass()].Name
			end
		elseif ent:IsValid() and scripted_ents.GetList()[ent:GetClass()] and scripted_ents.GetList()[ent:GetClass()].t and scripted_ents.GetList()[ent:GetClass()].t.PrintName then
			return scripted_ents.GetList()[ent:GetClass()].t.PrintName
		elseif ent:IsValid() then
			return "#"..ent:GetClass()
		else
			return ""
		end
	end
	return ""
end

function GM:EntityDeathnoticeName(ent, nolocalize)
	if ent:IsWeapon() then
		ent = ent:GetOwner()
	end
	if ent.GetDeathnoticeName then
		return ent:GetDeathnoticeName(nolocalize)
	else
		return self:EntityName(ent, nolocalize)
	end
end

function GM:EntityTargetIDName(ent, nolocalize)
	if ent.GetTargetIDName then
		return ent:GetTargetIDName(nolocalize)
	else
		return self:EntityName(ent, nolocalize)
	end
end

function GM:EntityTeam(ent)
	if not ent or not ent:IsValid() then return TEAM_NEUTRAL end
	
	if type(ent.Team)=="function" then
		return ent:Team()
	elseif isstring(ent.Team) and (ent.Team == "RED" or ent.Team == "BLU" or string.sub(ent:GetModel(), 1, 12) == "models/bots/") then
		if ent.Team == "RED" then
			return TEAM_RED
		elseif ent.Team == "BLU" then
			return TEAM_BLU
		elseif string.sub(ent:GetModel(), 1, 12) == "models/bots/" then
			return TEAM_BLU
		end
	else
		local t = ent:GetNWInt("Team") or 0
		if t>=1 then 
			return t
		else	
			if (ent.PreviousTeam) then
				t = ent.PreviousTeam
			else
				if (ent:GetClass() == "npc_turret_floor" and ent:HasSpawnFlags(512)) then
					t = TEAM_RED
				else
					t = ent:GetNPCData().team
				end
			end
			if not t and IsValid(ent:GetOwner()) then
				return self:EntityTeam(ent:GetOwner())
			else
				if type(t)=="function" then
					return t() or TEAM_NEUTRAL
				else
					return t or TEAM_NEUTRAL
				end
			end
		end
	end
end

function GM:EntityID(ent)
	if ent:IsPlayer() then
		return ent:UserID()
	elseif ent.DeathNoticeEntityID then
		return -ent.DeathNoticeEntityID
	else
		return 0
	end
end

function ParticleSuffix(t)
	if t==TEAM_BLU or t==TF_TEAM_PVE_INVADERS then return "blue"
	else return "red"
	end
end

function GM:ShouldCollide(ent1, ent2)
	if not IsValid(ent1) or not IsValid(ent2) then
		return true
	end
	
	if ent1.ShouldCollide then
		local c = ent1:ShouldCollide(ent2)
		if c ~= nil then return c end
	end
	
	if ent2.ShouldCollide then
		local c = ent2:ShouldCollide(ent1)
		if c ~= nil then return c end
	end
	
	if IsValid(ent1:GetOwner()) and (ent1:GetOwner():IsPlayer() or ent1:GetOwner():IsNPC()) then ent1 = ent1:GetOwner() end
	if IsValid(ent2:GetOwner()) and (ent2:GetOwner():IsPlayer() or ent2:GetOwner():IsNPC()) then ent2 = ent2:GetOwner() end
	
	local t1 = self:EntityTeam(ent1)
	local t2 = self:EntityTeam(ent2)
	--[[
	if (ent1:IsPlayer() or ent2:IsPlayer()) and (t1==TEAM_RED or t1==TEAM_BLU or t1==TF_TEAM_PVE_INVADERS or t1==TEAM_INFECTED) and t1==t2 then
		return false
	end]]
	
	if CLIENT then
		local c1, c2 = ent1:GetClass(), ent2:GetClass()
		
		if c2=="class C_HL2MPRagdoll" then
			c1,c2=c2,c1
		end
		
		if (c1=="class C_HL2MPRagdoll" or c1=="class CLuaEffect") and c2=="class CLuaEffect" then
			return false
		end
	end
	
	--[[
	if ent2:GetClass()=="phys_bone_follower" then
		ent1,ent2 = ent2,ent1
	end]]
	
	return true
end

HumanGibs = {
	"models/player/gibs/demogib001.mdl", -- 1
	"models/player/gibs/demogib002.mdl",
	"models/player/gibs/demogib003.mdl",
	"models/player/gibs/demogib004.mdl",
	"models/player/gibs/demogib005.mdl",
	"models/player/gibs/demogib006.mdl",
	"models/player/gibs/engineergib001.mdl", -- 7
	"models/player/gibs/engineergib002.mdl",
	"models/player/gibs/engineergib003.mdl",
	"models/player/gibs/engineergib004.mdl",
	"models/player/gibs/engineergib005.mdl",
	"models/player/gibs/engineergib006.mdl",
	"models/player/gibs/engineergib007.mdl",
	"models/player/gibs/heavygib001.mdl", -- 14
	"models/player/gibs/heavygib002.mdl",
	"models/player/gibs/heavygib003.mdl",
	"models/player/gibs/heavygib004.mdl",
	"models/player/gibs/heavygib005.mdl",
	"models/player/gibs/heavygib006.mdl",
	"models/player/gibs/heavygib007.mdl",
	"models/player/gibs/medicgib001.mdl", -- 21
	"models/player/gibs/medicgib002.mdl",
	"models/player/gibs/medicgib003.mdl",
	"models/player/gibs/medicgib004.mdl",
	"models/player/gibs/medicgib005.mdl",
	"models/player/gibs/medicgib006.mdl",
	"models/player/gibs/medicgib007.mdl",
	"models/player/gibs/medicgib008.mdl",
	"models/player/gibs/pyrogib001.mdl", -- 29
	"models/player/gibs/pyrogib002.mdl",
	"models/player/gibs/pyrogib003.mdl",
	"models/player/gibs/pyrogib004.mdl",
	"models/player/gibs/pyrogib005.mdl",
	"models/player/gibs/pyrogib006.mdl",
	"models/player/gibs/pyrogib007.mdl",
	"models/player/gibs/pyrogib008.mdl",
	"models/player/gibs/scoutgib001.mdl", -- 37
	"models/player/gibs/scoutgib002.mdl",
	"models/player/gibs/scoutgib003.mdl",
	"models/player/gibs/scoutgib004.mdl",
	"models/player/gibs/scoutgib005.mdl",
	"models/player/gibs/scoutgib006.mdl",
	"models/player/gibs/scoutgib007.mdl",
	"models/player/gibs/scoutgib008.mdl",
	"models/player/gibs/scoutgib009.mdl",
	"models/player/gibs/snipergib001.mdl", -- 46
	"models/player/gibs/snipergib002.mdl",
	"models/player/gibs/snipergib003.mdl",
	"models/player/gibs/snipergib004.mdl",
	"models/player/gibs/snipergib005.mdl",
	"models/player/gibs/snipergib006.mdl",
	"models/player/gibs/snipergib007.mdl",
	"models/player/gibs/soldiergib001.mdl", -- 53
	"models/player/gibs/soldiergib002.mdl",
	"models/player/gibs/soldiergib003.mdl",
	"models/player/gibs/soldiergib004.mdl",
	"models/player/gibs/soldiergib005.mdl",
	"models/player/gibs/soldiergib006.mdl",
	"models/player/gibs/soldiergib007.mdl",
	"models/player/gibs/soldiergib008.mdl",
	"models/player/gibs/spygib001.mdl", -- 61
	"models/player/gibs/spygib002.mdl",
	"models/player/gibs/spygib003.mdl",
	"models/player/gibs/spygib004.mdl",
	"models/player/gibs/spygib005.mdl",
	"models/player/gibs/spygib006.mdl",
	"models/player/gibs/spygib007.mdl",
	"models/player/gibs/random_organ.mdl", -- 68
	"models/player/gibs/gibs_balloon.mdl", -- 69
	"models/player/gibs/gibs_bolt.mdl",
	"models/player/gibs/gibs_boot.mdl",
	"models/player/gibs/gibs_burger.mdl",
	"models/player/gibs/gibs_can.mdl",
	"models/player/gibs/gibs_clock.mdl",
	"models/player/gibs/gibs_duck.mdl",
	"models/player/gibs/gibs_fish.mdl",
	"models/player/gibs/gibs_gear1.mdl",
	"models/player/gibs/gibs_gear2.mdl",
	"models/player/gibs/gibs_gear3.mdl",
	"models/player/gibs/gibs_gear4.mdl",
	"models/player/gibs/gibs_gear5.mdl",
	"models/player/gibs/gibs_hubcap.mdl",
	"models/player/gibs/gibs_licenseplate.mdl",
	"models/player/gibs/gibs_spring1.mdl",
	"models/player/gibs/gibs_spring2.mdl",
	"models/player/gibs/gibs_teeth.mdl",
	"models/player/gibs/gibs_tire.mdl",
	"models/gibs/hgibs.mdl", -- 88
}

RobotGibs = {
	"models/bots/gibs/demobot_gib_leg1.mdl", -- 1
	"models/bots/gibs/demobot_gib_leg2.mdl",
	"models/bots/gibs/demobot_gib_arm1.mdl",
	"models/bots/gibs/demobot_gib_arm2.mdl",
	"models/bots/gibs/demobot_gib_pelvis.mdl",
	"models/bots/gibs/demobot_gib_head.mdl",
	"models/bots/gibs/demobot_gib_leg3.mdl",
	"models/player/gibs/engineergib001.mdl", -- 8
	"models/player/gibs/engineergib002.mdl",
	"models/player/gibs/engineergib003.mdl",
	"models/player/gibs/engineergib004.mdl",
	"models/player/gibs/engineergib005.mdl",
	"models/player/gibs/engineergib006.mdl",
	"models/player/gibs/engineergib007.mdl",
	"models/bots/gibs/heavybot_gib_arm.mdl", -- 15
	"models/bots/gibs/heavybot_gib_arm2.mdl",
	"models/bots/gibs/heavybot_gib_leg.mdl",
	"models/bots/gibs/heavybot_gib_leg2.mdl",
	"models/bots/gibs/heavybot_gib_pelvis.mdl",
	"models/bots/gibs/heavybot_gib_head.mdl",
	"",
	"models/bots/gibs/medicbot_gib_head.mdl", -- 22
	"models/bots/gibs/pyrobot_gib_arm1.mdl", -- 23
	"models/bots/gibs/pyrobot_gib_arm2.mdl",
	"models/bots/gibs/pyrobot_gib_arm3.mdl",
	"models/bots/gibs/pyrobot_gib_chest.mdl",
	"models/bots/gibs/pyrobot_gib_chest2.mdl",
	"models/bots/gibs/pyrobot_gib_leg.mdl",
	"models/bots/gibs/pyrobot_gib_pelvis.mdl",
	"models/bots/gibs/pyrobot_gib_head.mdl",
	"models/bots/gibs/scoutbot_gib_arm1.mdl", -- 38
	"models/bots/gibs/scoutbot_gib_arm2.mdl",
	"models/bots/gibs/scoutbot_gib_chest.mdl",
	"models/bots/gibs/scoutbot_gib_head.mdl",
	"models/bots/gibs/scoutbot_gib_leg1.mdl",
	"models/bots/gibs/scoutbot_gib_leg2.mdl",
	"",
	"",
	"",
	"models/bots/gibs/sniperbot_gib_head.mdl", -- 47
	"models/bots/gibs/soldierbot_gib_arm1.mdl", -- 48
	"models/bots/gibs/soldierbot_gib_arm2.mdl",
	"models/bots/gibs/soldierbot_gib_chest.mdl",
	"models/bots/gibs/soldierbot_gib_head.mdl",
	"models/bots/gibs/soldierbot_gib_leg1.mdl",
	"models/bots/gibs/soldierbot_gib_leg2.mdl",
	"models/bots/gibs/soldierbot_gib_pelvis.mdl",
	"",
	"models/bots/gibs/spybot_gib_head.mdl", -- 56
}

RobotBossGibs = {
	"models/bots/gibs/demobot_gib_boss_leg1.mdl", -- 1
	"models/bots/gibs/demobot_gib_boss_leg2.mdl",
	"models/bots/gibs/demobot_gib_boss_arm1.mdl",
	"models/bots/gibs/demobot_gib_boss_arm2.mdl",
	"models/bots/gibs/demobot_gib_boss_pelvis.mdl",
	"models/bots/gibs/demobot_gib_boss_head.mdl",
	"models/bots/gibs/demobot_gib_boss_leg3.mdl",
	"models/player/gibs/engineergib001.mdl", -- 8
	"models/player/gibs/engineergib002.mdl",
	"models/player/gibs/engineergib003.mdl",
	"models/player/gibs/engineergib004.mdl",
	"models/player/gibs/engineergib005.mdl",
	"models/player/gibs/engineergib006.mdl",
	"models/player/gibs/engineergib007.mdl",
	"models/bots/gibs/heavybot_gib_boss_arm.mdl", -- 15
	"models/bots/gibs/heavybot_gib_boss_arm2.mdl",
	"models/bots/gibs/heavybot_gib_boss_leg.mdl",
	"models/bots/gibs/heavybot_gib_boss_leg2.mdl",
	"models/bots/gibs/heavybot_gib_boss_pelvis.mdl",
	"models/bots/gibs/heavybot_gib_boss_head.mdl",
	"",
	"models/bots/gibs/medicbot_gib_head.mdl", -- 22
	"models/bots/gibs/pyrobot_gib_boss_arm1.mdl", -- 23
	"models/bots/gibs/pyrobot_gib_boss_arm2.mdl",
	"models/bots/gibs/pyrobot_gib_boss_arm3.mdl",
	"models/bots/gibs/pyrobot_gib_boss_chest.mdl",
	"models/bots/gibs/pyrobot_gib_boss_chest2.mdl",
	"models/bots/gibs/pyrobot_gib_boss_leg.mdl",
	"models/bots/gibs/pyrobot_gib_boss_pelvis.mdl",
	"models/bots/gibs/pyrobot_gib_boss_head.mdl",
	"models/bots/gibs/scoutbot_gib_boss_arm1.mdl", -- 38
	"models/bots/gibs/scoutbot_gib_boss_arm2.mdl",
	"models/bots/gibs/scoutbot_gib_boss_chest.mdl",
	"models/bots/gibs/scoutbot_gib_boss_head.mdl",
	"models/bots/gibs/scoutbot_gib_boss_leg1.mdl",
	"models/bots/gibs/scoutbot_gib_boss_leg2.mdl",
	"",
	"",
	"",
	"models/bots/gibs/sniperbot_gib_head.mdl", -- 47
	"models/bots/gibs/soldierbot_gib_boss_arm1.mdl", -- 48
	"models/bots/gibs/soldierbot_gib_boss_arm2.mdl",
	"models/bots/gibs/soldierbot_gib_boss_chest.mdl",
	"models/bots/gibs/soldierbot_gib_boss_head.mdl",
	"models/bots/gibs/soldierbot_gib_boss_leg1.mdl",
	"models/bots/gibs/soldierbot_gib_boss_leg2.mdl",
	"models/bots/gibs/soldierbot_gib_boss_pelvis.mdl",
	"",
	"models/bots/gibs/spybot_gib_head.mdl", -- 56
}

NPCModels = {
	"models/Humans/Group01/female_01.mdl",
	"models/Humans/Group01/female_02.mdl",
	"models/Humans/Group01/female_03.mdl",
	"models/Humans/Group01/female_04.mdl",
	"models/Humans/Group01/female_05.mdl",
	"models/Humans/Group01/female_06.mdl",
	"models/Humans/Group01/female_07.mdl",
	"models/Humans/Group01/male_01.mdl",
	"models/Humans/Group01/male_02.mdl",
	"models/Humans/Group01/male_03.mdl",
	"models/Humans/Group01/male_04.mdl",
	"models/Humans/Group01/male_05.mdl",
	"models/Humans/Group01/male_06.mdl",
	"models/Humans/Group01/male_07.mdl",
	"models/Humans/Group01/male_08.mdl",
	"models/Humans/Group01/male_09.mdl",
	
	"models/Humans/Group02/female_01.mdl",
	"models/Humans/Group02/female_02.mdl",
	"models/Humans/Group02/female_03.mdl",
	"models/Humans/Group02/female_04.mdl",
	"models/Humans/Group02/female_05.mdl",
	"models/Humans/Group02/female_06.mdl",
	"models/Humans/Group02/female_07.mdl",
	"models/Humans/Group02/male_01.mdl",
	"models/Humans/Group02/male_02.mdl",
	"models/Humans/Group02/male_03.mdl",
	"models/Humans/Group02/male_04.mdl",
	"models/Humans/Group02/male_05.mdl",
	"models/Humans/Group02/male_06.mdl",
	"models/Humans/Group02/male_07.mdl",
	"models/Humans/Group02/male_08.mdl",
	"models/Humans/Group02/male_09.mdl",
	
	"models/Humans/Group03/female_01.mdl",
	"models/Humans/Group03/female_02.mdl",
	"models/Humans/Group03/female_03.mdl",
	"models/Humans/Group03/female_04.mdl",
	"models/Humans/Group03/female_05.mdl",
	"models/Humans/Group03/female_06.mdl",
	"models/Humans/Group03/female_07.mdl",
	"models/Humans/Group03/male_01.mdl",
	"models/Humans/Group03/male_02.mdl",
	"models/Humans/Group03/male_03.mdl",
	"models/Humans/Group03/male_04.mdl",
	"models/Humans/Group03/male_05.mdl",
	"models/Humans/Group03/male_06.mdl",
	"models/Humans/Group03/male_07.mdl",
	"models/Humans/Group03/male_08.mdl",
	"models/Humans/Group03/male_09.mdl",
	
	"models/Humans/Group03m/female_01.mdl",
	"models/Humans/Group03m/female_02.mdl",
	"models/Humans/Group03m/female_03.mdl",
	"models/Humans/Group03m/female_04.mdl",
	"models/Humans/Group03m/female_05.mdl",
	"models/Humans/Group03m/female_06.mdl",
	"models/Humans/Group03m/female_07.mdl",
	"models/Humans/Group03m/male_01.mdl",
	"models/Humans/Group03m/male_02.mdl",
	"models/Humans/Group03m/male_03.mdl",
	"models/Humans/Group03m/male_04.mdl",
	"models/Humans/Group03m/male_05.mdl",
	"models/Humans/Group03m/male_06.mdl",
	"models/Humans/Group03m/male_07.mdl",
	"models/Humans/Group03m/male_08.mdl",
	"models/Humans/Group03m/male_09.mdl",
	
	"models/alyx.mdl",
	"models/barney.mdl",
	"models/breen.mdl",
	"models/eli.mdl",
	"models/gman.mdl",
	"models/gman_high.mdl",
	"models/kleiner.mdl",
	"models/monk.mdl",
	"models/mossman.mdl",
	"models/vortigaunt.mdl",
}

--[[
for _,v in pairs(NPCModels) do
	util.PrecacheModel(v)
end]]

PlayerModels = {
	"models/player/demo.mdl",
	"models/player/engineer.mdl",
	"models/player/heavy.mdl",
	"models/player/medic.mdl",
	"models/player/pyro.mdl",
	"models/player/scout.mdl",
	"models/player/sniper.mdl",
	"models/player/soldier.mdl",
	"models/player/spy.mdl",
}

AnimationModels = {
	"models/weapons/c_models/c_demo_animations.mdl",
	"models/weapons/c_models/c_heavy_animations.mdl",
	"models/weapons/c_models/c_medic_animations.mdl",
	"models/weapons/c_models/c_pyro_animations.mdl",
	"models/weapons/c_models/c_scout_animations.mdl",
	"models/weapons/c_models/c_sniper_animations.mdl",
	"models/weapons/c_models/c_soldier_animations.mdl",
	"models/weapons/c_models/c_spy_animations.mdl",
}

include("shd_facefix.lua")    
include("shd_precaches.lua") 
include("shd_movement.lua")
include("shd_npcdata.lua")
include("shd_playerclasses.lua")
include("ply_extension.lua")
include("ent_extension.lua")
include("shd_playerstates.lua")

include("shd_maphooks.lua")
concommand.Add("+inspect", function(pl)
	pl:SetNWString("inspect", "inspecting_start")
end)

concommand.Add("-inspect", function(pl)
	pl:SetNWString("inspect", "inspecting_released")
	timer.Simple( 0.02, function() pl:SetNWString("inspect", "inspecting_done") end )
end)