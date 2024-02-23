
include("sv_clientfiles.lua")
include("sv_resource.lua")
include("sv_response_rules.lua")
include("sv_ctf_bots.lua")
include("shared.lua")
include("sv_gamelogic.lua")
include("sv_hl2replace.lua")
include("sv_damage.lua")
include("sv_death.lua")
include("shd_gravitygun.lua")
include("sv_chat.lua")  
include("sv_loadout.lua")   
include("shd_taunts.lua")
resource.AddFile("scenes/scenes.image")
local LOGFILE = "teamfortress/log_server.txt" 
file.Delete(LOGFILE) 
file.Append(LOGFILE, "Loading serverside script\n")
local load_time = SysTime() 

include("sv_npc_relationship.lua")   
include("sv_ent_substitute.lua")  

CreateConVar("grapple_distance", -1, false)  
response_rules.Load("talker/tf_response_rules.lua")
response_rules.Load("talker/demoman_custom.lua")  
response_rules.Load("talker/heavy_custom.lua") 

util.AddNetworkString("TFRagdollCreate")
util.AddNetworkString("TauntAnim")

CreateConVar('tf_opentheorangebox', 0, FCVAR_ARCHIVE + FCVAR_SERVER_CAN_EXECUTE, 'Enables 2007 mode')
-- Quickfix for Valve's typo in tf_reponse_rules.txt
response_rules.AddCriterion([[criterion "WeaponIsScattergunDouble" "item_name" "The Force-a-Nature" "required" weight 10]])

--concommand.Add("lua_pick", function(pl, cmd, args)
--	getfenv()[args[1]] = pl:GetEyeTrace().Entity	
--end) 

hook.Add("Think", "NoAttackPuppet", function()
		for k,v in ipairs(player.GetAll()) do 
			if (v:WaterLevel() < 2 and !v.IsDrowning) then
				timer.Stop("Drown"..v:EntIndex())
				timer.Stop("DrownContinue"..v:EntIndex())
			end
		end 
end) 


concommand.Add("voicemenu_gesture", function(pl, cmd, args)
	local a, b = tonumber(args[1]), tonumber(args[2])
	if not a or not b then return end
		if a == 0 and b == 0 then
			if (pl:GetPlayerClass() == "hl1scientist") then
				EmitSentence( "SC_PHELLO" .. math.random( 0, 6 ), pl:GetPos(), pl:EntIndex()	, CHAN_AUTO, 1, 75, 0, 100 )
			end
		elseif a == 0 and b == 1 then
			if (pl:GetPlayerClass() == "hl1scientist") then
				EmitSentence( table.Random({"SC_GOODWORK","SC_HARDLYNOTICE"}), pl:GetPos(), pl:EntIndex()	, CHAN_AUTO, 1, 75, 0, 100 )
			end
		elseif a == 0 and b == 2 then
			if (pl:GetPlayerClass() == "hl1scientist") then
				EmitSentence( table.Random({"SC_ZOMBIE1A","SC_GETAWAY"}), pl:GetPos(), pl:EntIndex()	, CHAN_AUTO, 1, 75, 0, 100 )
			end
		elseif a == 0 and b == 3 then
			if (pl:GetPlayerClass() == "hl1scientist") then
				EmitSentence( table.Random({"SC_ZOMBIE1A"}), pl:GetPos(), pl:EntIndex(), CHAN_VOICE, 1, 75, 0, 100 )
			end
		elseif a == 0 and b == 6 then
			if (pl:GetPlayerClass() == "hl1scientist") then
				EmitSentence( table.Random({"SC_ANSWER10","SC_ANSWER16","SC_ANSWER14","SC_ANSWER8","SC_ANSWER9"}), pl:GetPos(), pl:EntIndex(), CHAN_VOICE, 1, 75, 0, 100 )
			end
		elseif a == 0 and b == 7 then
			if (pl:GetPlayerClass() == "hl1scientist") then
				EmitSentence( table.Random({"SC_ANSWER19","SC_ANSWER17","SC_ANSWER18","SC_ANSWER20","SC_ANSWER25"}), pl:GetPos(), pl:EntIndex(), CHAN_VOICE, 1, 75, 0, 100 )
			end
		elseif a == 2 and b == 8 then
			NextSpeak = CurTime() + 1.5
			if not NextSpeak and CurTime()>=NextSpeak then
				if pl:GetPlayerClass() == "heavy" or pl:GetPlayerClass() == "scout" then
					pl:EmitSound("vo/"..pl:GetPlayerClass().."_mvm_loot_godlike0"..math.random(1,3)..".wav")
				else
					pl:EmitSound("vo/"..pl:GetPlayerClass().."_mvm_loot_godlike0"..math.random(1,3)..".wav")
				end
			end
		elseif a == 1 and b == 0 then
			if (pl:GetPlayerClass() == "hl1scientist") then
				EmitSentence( "SC_HEAR"..math.random(0,2), pl:GetPos(), pl:EntIndex(), CHAN_VOICE, 1, 75, 0, 100 )
			end
		elseif a == 1 and b == 1 then
			if (pl:GetPlayerClass() == "hl1scientist") then
				EmitSentence( "SC_QUESTION"..math.random(0,26), pl:GetPos(), pl:EntIndex(), CHAN_VOICE, 1, 75, 0, 100 )
			end
		elseif a == 1 and b == 2 then
			if (pl:GetPlayerClass() == "hl1scientist") then
				EmitSentence( "SC_ANSWER"..math.random(0,29), pl:GetPos(), pl:EntIndex(), CHAN_VOICE, 1, 75, 0, 100 )
			end
		end
		if pl:GetPlayerClass() == "zombie" then
			pl:EmitSound("Zombie.Alert")
		end
end)

concommand.Add("addcond", function(pl, cmd, args)
	local a, b = tonumber(args[1]), tonumber(args[2])
	if !GetConVar("sv_cheats"):GetBool() then return end
	if not a then return end
		if a == 5 then
			pl:GodEnable()
			if pl:Team() == TEAM_RED or pl:Team() != TEAM_BLU then
				pl:SetSkin(2)
			else
				pl:SetSkin(3)
			end
		end
		if a == 11 or a == 37 or a == 35 then
			GAMEMODE:StartCritBoost(pl)
		end
		if a == 91 then
			pl:GetWeapons()[1].Primary.ClipSize = pl:GetWeapons()[1].Primary.ClipSize + 6
			pl:GetWeapons()[2].Primary.ClipSize = pl:GetWeapons()[1].Primary.ClipSize + 6
			pl:GetWeapons()[1].ReloadTime = pl:GetWeapons()[1].ReloadTime - 0.6 
			pl:GetWeapons()[2].ReloadTime = pl:GetWeapons()[2].ReloadTime - 0.6
			pl:GetWeapons()[1].Primary.Delay = pl:GetWeapons()[1].Primary.Delay - 0.4
			pl:GetWeapons()[2].Primary.Delay = pl:GetWeapons()[2].Primary.Delay - 0.4
			pl:GetWeapons()[3].Primary.Delay = pl:GetWeapons()[3].Primary.Delay - 0.4
			pl:EmitSound("items/powerup_pickup_haste.wav")
			timer.Create("Haste1"..pl:EntIndex(), 0.00, 0, function()
				if !pl:Alive() then timer.Stop("Haste1"..pl:EntIndex()) return end
			
				pl:SetClassSpeed(pl:GetPlayerClassTable().Speed + 60)

			end)
		end 
		if a == 66691 then
			pl:GetWeapons()[1].Primary.ClipSize = pl:GetWeapons()[1].Primary.ClipSize + 200
			pl:GetWeapons()[2].Primary.ClipSize = pl:GetWeapons()[1].Primary.ClipSize + 200
			pl:GetWeapons()[1].ReloadTime = pl:GetWeapons()[1].ReloadTime - 200
			pl:GetWeapons()[2].ReloadTime = pl:GetWeapons()[2].ReloadTime - 200
			pl:GetWeapons()[1].Primary.Delay = pl:GetWeapons()[1].Primary.Delay - 200
			pl:GetWeapons()[2].Primary.Delay = pl:GetWeapons()[2].Primary.Delay - 200
			pl:GetWeapons()[3].Primary.Delay = pl:GetWeapons()[3].Primary.Delay - 200
			pl:EmitSound("items/powerup_pickup_haste.wav",150,200)
			pl:EmitSound("items/powerup_pickup_haste.wav",150,200)
			pl:EmitSound("items/powerup_pickup_haste.wav",150,200)
			pl:EmitSound("items/powerup_pickup_haste.wav",150,200)
			pl:EmitSound("items/powerup_pickup_haste.wav",150,200)
			pl:SetMaxHealth(pl:Health() + 10000)
			pl:SetHealth(pl:GetMaxHealth())
			timer.Create("Haste1"..pl:EntIndex(), 0.00, 0, function()
				if !pl:Alive() then timer.Stop("Haste1"..pl:EntIndex()) return end
			
				pl:SetClassSpeed(pl:GetPlayerClassTable().Speed + 200)

			end)
		end 
		if a == 666 then
			pl:GetWeapons()[3].DamageType = DMG_DISSOLVE
		end 
		if a == 72 then
			pl:GetWeapons()[1].Primary.Delay = pl:GetWeapons()[1].Primary.Delay - 0.1
			pl:GetWeapons()[2].Primary.Delay = pl:GetWeapons()[2].Primary.Delay - 0.1
			pl:GetWeapons()[3].Primary.Delay = pl:GetWeapons()[3].Primary.Delay - 0.1
			pl:EmitSound("items/powerup_pickup_haste.wav", 95, 110)
			timer.Create("Haste2"..pl:EntIndex(), 0.00, 0, function()
				if !pl:Alive() then timer.Stop("Haste2"..pl:EntIndex()) return end
			
				pl:SetClassSpeed(pl:GetPlayerClassTable().Speed + 70)

			end)
		end 
end)
concommand.Add("taunt", function(pl)
	GAMEMODE:PlayerStartTaunt(pl, ACT_DIESIMPLE, 1 )
end)

concommand.Add("select_slot", function(pl, cmd, args)
	local n = tonumber(args[1] or "")
	local w = pl:GetActiveWeapon()
	if n and w and w:IsValid() and w.OnSlotSelected then
		w:OnSlotSelected(n)
	end
end)

concommand.Add("decapme", function(pl, cmd, args)
--	pl:SetNWBool("ShouldDropDecapitatedRagdoll", true)
	pl:AddDeathFlag(DF_DECAP)
	pl:Kill()
end)

concommand.Add("tf_stripme", function(pl, cmd, args)
	pl:StripWeapons()
end)


hook.Add("PlayerSelectSpawn", "PlayerSelectTeamSpawn", function(pl)
	if !string.find(game.GetMap(), "mvm_") then
		for k,v in pairs(ents.FindByClass("info_player_redspawn"), ents.FindByClass("info_player_bluspawn")) do
			if v:IsValid() then
				local spawns1 = ents.FindByClass( "info_player_redspawn" )
				local random_entry = math.random( #spawns1 ) 
				local spawns2 = ents.FindByClass( "info_player_bluspawn" )
				local random_entry2 = math.random( #spawns2 )
				if pl:Team() == TEAM_RED or pl:Team() == TEAM_NEUTRAL then
					return spawns1[ random_entry ]
				elseif pl:Team() == TEAM_BLU or pl:Team() == TF_TEAM_PVE_INVADERS then
					return spawns2[ random_entry2 ]
				end
			end
		end
	else
		for k,v in pairs( ents.FindByClass("info_player_bluspawn")) do
			if v:IsValid() then
				local spawns1 = ents.FindByClass( "info_player_bluspawn" )
				local random_entry = math.random( #spawns1 )
				if pl:Team() == TEAM_BLU then
					return spawns1[ random_entry ] 
				end
			end
		end
	end
end)

hook.Add("PlayerHurt", "RoboIsHurt", function( ply, pos, foot, sound, volume, rf )
	local dmginfo = DamageInfo()
	if ply:Alive() and ply:GetModel() == "models/l4d2/survivor_mechanic.mdl" then
		if ply:Health() >= 50 then
			ply:EmitSound("player/survivor/voice/mechanic/hurtminor0"..math.random(1,7)..".wav")
		else
			ply:EmitSound("player/survivor/voice/mechanic/hurtcritical0"..math.random(2,5)..".wav")
		end 
	end
	if ply:GetPlayerClass() == "combinesoldier" then
		EmitSentence( "COMBINE_PAIN" .. math.random( 0, 3 ), ply:GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
	end
	if ply:GetPlayerClass() == "metrocop" then
		EmitSentence( "METROPOLICE_PAIN" .. math.random( 0, 3 ), ply:GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
	end
	
	if not ply:IsHL2() and ply:GetInfoNum("tf_hhh", 0) == 1 then
		ply:EmitSound( "Halloween.HeadlessBossPain" ) -- Play the footsteps hunter is using
	end

	if ply:GetPlayerClass() == "merc_dm" then
		if ( shouldOccur ) then
			if ply:Health() <= 50 then
				ply:EmitSound("vo/mercenary_painsevere0"..math.random(1,6)..".wav")
			elseif dmginfo:IsFallDamage() then
				ply:EmitSound("vo/mercenary_painsevere0"..math.random(1,6)..".wav")
			else
				ply:EmitSound("vo/mercenary_painsharp0"..math.random(1,8)..".wav")
			end
			shouldOccur = false
			timer.Simple( hurtdelay, function() shouldOccur = true end )
		end
	end
	
	
	if not ply:IsHL2() and ply:GetInfoNum("jakey_antlionfbii", 0) == 1 then
		ply:EmitSound("npc/antlion/shell_impact"..math.random(1,4)..".wav", 80, 100)
		if ( shouldOccur ) then
			ply:EmitSound( "npc/antlion_guard/antlion_guard_pain"..math.random(1,2)..".wav", 150, math.random(87, 103) )
			shouldOccur = false
			timer.Simple( hurtdelay, function() shouldOccur = true end )
		end
	end
	if ply:GetInfoNum("dylan_rageheavy", 0) == 1 then
		ply:EmitSound("vo/heavy_paincrticialdeath0"..math.random(1,3)..".wav", 150, 100)
		if ply:GetInfoNum("tf_giant_robot", 0) == 1 then
				ply:SetModelScale(6) 
				ply:EmitSound("music/stingers/hl1_stinger_song28.wav", 0, 80)
				ply:EmitSound("music/stingers/hl1_stinger_song28.wav", 0, 75)
		 end
	end
	if (ply:IsHL2()) then
		ply:GetViewModel():SetMaterial("")
	else
		ply:GetViewModel():SetMaterial("color")
	end
	if not ply:IsHL2() and ply:GetInfoNum("tf_robot", 0) == 1 then
		ply:EmitSound( "MVM_Giant.BulletImpact" )
	end 
	if not ply:IsHL2() and ply:GetInfoNum("tf_mvm_giant_voodoo", 0) == 1 then
		ply:EmitSound( "MVM_Giant.BulletImpact" )
	end	
	if ply:GetPlayerClass() == "spy" then
		for k,v in pairs(ents.FindByClass("tf_weapon_invis_dringer")) do
			if v.Owner == ply and v.dt.Ready == true then
				v:StartCloaking()
				ply:CreateRagdoll()
			end
		end
	end
end)


concommand.Add("voicemenu_combine", function(pl, cmd, args)
	local a, b = tonumber(args[1]), tonumber(args[2])
	if not a or not b then return end

	if a == 0 and b == 6 then
		if pl:GetPlayerClass() == "combinesoldier" then
			EmitSentence( "COMBINE_ANSWER" .. math.random( 0, 4 ), pl:GetPos(), 1, CHAN_AUTO, 1, 95, 0, 100 )
		end
	end
	if a == 0 and b == 2 then
		if pl:GetPlayerClass() == "combinesoldier" then
			EmitSentence( "METROPOLICE_IDLE_HARASS_PLAYER1", pl:GetPos(), 1, CHAN_AUTO, 1, 95, 0, 100 )
		end
	end
	if a == 0 and b == 3 then
		if pl:GetPlayerClass() == "combinesoldier" then
			EmitSentence( "METROPOLICE_IDLE_HARASS_PLAYER0", pl:GetPos(), 1, CHAN_AUTO, 1, 95, 0, 100 )
		end
	end
	if a == 2 and b == 5 then
		if pl:GetPlayerClass() == "combinesoldier" then
			EmitSentence( "COMBINE_LAST_OF_SQUAD" .. math.random( 0, 7 ), pl:GetPos(), 1, CHAN_AUTO, 1, 95, 0, 100 )
		end
	end
	if a == 1 and b == 0 then
		if pl:GetPlayerClass() == "combinesoldier" then
			EmitSentence( "COMBINE_ALERT" .. math.random( 0, 9 ), pl:GetPos(), 1, CHAN_AUTO, 1, 95, 0, 100 )
		end
	end
	if a == 1 and b == 1 then
		if pl:GetPlayerClass() == "combinesoldier" then
			EmitSentence( "COMBINE_TAUNT" .. math.random( 0, 2 ), pl:GetPos(), 1, CHAN_AUTO, 1, 95, 0, 100 )
		end
	end
	if a == 1 and b == 2 then
		if pl:GetPlayerClass() == "combinesoldier" then
			EmitSentence( "COMBINE_QUEST" .. math.random( 0, 5 ), pl:GetPos(), 1, CHAN_AUTO, 1, 95, 0, 100 )
		end
	end
end)


hook.Add("PlayerDeath", "PlayerRobotDeath", function( ply, attacker, inflictor)
	local dmginfo = DamageInfo()
	ply:SetParent()
	for k,v in pairs(ents.FindInSphere(ply:GetPos(), 110)) do
		if v:IsPlayer() then
			v:SetParent()
		end
	end
	
	if attacker:IsPlayer() and !attacker:IsFriendly(ply) and attacker:GetPlayerClass() == "combinesoldier" then
		EmitSentence( "COMBINE_PLAYER_DEAD" .. math.random( 0, 6 ), attacker:GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
	end
	
	for k,v in ipairs(team.GetPlayers(ply:Team())) do
		if v:Alive() and v:Nick() != ply:Nick() and v:GetPlayerClass() == "combinesoldier" then
			EmitSentence( "COMBINE_MAN_DOWN" .. math.random( 0, 4 ), v:GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
		end
	end	
	
	for k,v in ipairs(team.GetPlayers(ply:Team())) do
		if v:Alive() and v:Nick() != ply:Nick() and v:GetPlayerClass() == "metrocop" then
			EmitSentence( "METROPOLICE_MAN_DOWN" .. math.random( 0, 3 ), v:GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
		end
	end

	if ply:IsHL2() then
		if ply:GetPlayerClass() == "gmodplayer" then
			if ply:GetModel() == "models/l4d2/survivor_mechanic.mdl" then
				ply:EmitSound("player/survivor/voice/mechanic/deathscream0"..math.random(1,6)..".wav")
			elseif ply:GetModel() == "models/l4d2/survivor_namvet.mdl" then
				ply:EmitSound("player/survivor/voice/namvet/deathscream0"..math.random(1,8)..".wav")
			elseif ply:GetModel() == "models/l4d2/survivor_manager.mdl" then
				ply:EmitSound("player/survivor/voice/manager/deathscream0"..math.random(1,9)..".wav")
			elseif ply:GetModel() == "models/l4d2/survivor_biker.mdl" then
				ply:EmitSound("player/survivor/voice/biker/deathscream0"..math.random(1,9)..".wav")
			end
		end
	end
	if ply:GetPlayerClass() == "charger" then
		ply:EmitSound("ChargerZombie.Death")
	end
	if ply:GetPlayerClass() == "combinesoldier" then
		EmitSentence( "COMBINE_DIE" .. math.random( 0, 3 ), ply:GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
	end
 
	if ply:GetPlayerClass() == "metrocop" then
		EmitSentence( "METROPOLICE_DIE" .. math.random( 0, 4 ), ply:GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
	end
	
	if ply:GetPlayerClass() == "tank_l4d" then
		for k,v in ipairs(player.GetAll()) do
			v:StopSound("TankMusicLoop")
			v:StopSound("TankMidnightMusicLoop")
		end
		
		if (string.find(ply:GetModel(),"l4d1")) then
			ply:EmitSound("L4D1_HulkZombie.Death")
		else
			ply:EmitSound("HulkZombie.Death")
		end
	end
	if ply:GetPlayerClass() == "jockey" then
		ply:EmitSound("JockeyZombie.Death")
	end
	if not ply:IsHL2() and ply:GetInfoNum("tf_sentrybuster", 0) == 1 then			
		for k,v in pairs(player.GetAll()) do
			if not v:IsFriendly(ply) and v:Alive() and not v:IsHL2() then
				if v:GetPlayerClass() == "heavy" then
					v:EmitSound("vo/heavy_mvm_sentry_buster02.wav", 85, 100, 1, CHAN_REPLACE)
				elseif v:GetPlayerClass() == "medic" then
					v:EmitSound("vo/medic_mvm_sentry_buster02.wav", 85, 100, 1, CHAN_REPLACE)
				elseif v:GetPlayerClass() == "soldier" then
					v:EmitSound("vo/soldier_mvm_sentry_buster02.wav", 85, 100, 1, CHAN_REPLACE)
				elseif v:GetPlayerClass() == "engineer" then
					v:EmitSound("vo/engineer_mvm_sentry_buster02.wav", 85, 100, 1, CHAN_REPLACE)
				end
			end
		end
	end
	if not ply:IsHL2() and ply:GetInfoNum("jakey_antlionfbii", 0) == 1 then			
		ply:EmitSound("npc/antlion_guard/antlion_guard_die"..math.random(1,2)..".wav", 120, 100)
	end
	if not ply:IsHL2() and ply:GetInfoNum("tf_merasmus", 0) == 1 then
		ply:EmitSound("Halloween.MerasmusBanish")
		ply:EmitSound("Halloween.HeadlessBossDeath")
		ply:PrecacheGibs()
		ply:GibBreakClient( Vector(math.random(1,4), math.random(1,4), math.random(1,4)) )
		ply:GetRagdollEntity():Remove()
	end
	if attacker:IsPlayer() and victim ~= attacker and attacker:GetInfoNum("tf_merasmus", 0) == 1 then
		attacker:EmitSound("Halloween.MerasmusBombTaunt")
	end
	if attacker:IsPlayer() and victim ~= attacker and attacker:GetInfoNum("tf_saxxy", 0) == 1 then
		attacker:EmitSound("SaxtonHale.KillVictim")
	end
	if attacker:IsPlayer() and victim ~= attacker and attacker:GetInfoNum("tf_merasmus", 0) == 1 and victim:IsNPC() then
		attacker:EmitSound("Halloween.MerasmusBombTaunt")
	end
	if not ply:IsHL2() and ply:GetInfoNum("tf_robot", 0) == 1 then
		if eyeparticle1:IsValid() then
			eyeparticle1:Fire("kill", 0.001)
		end
		if eyeparticle2:IsValid() then
			eyeparticle2:Fire("kill", 0.001)
		end
		if ply:GetPlayerClass() == "scout" then
			ply:EmitSound("vo/mvm/norm/scout_mvm_painsevere0"..math.random(1,6)..".mp3", 95, 100, 1, CHAN_VOICE)
		elseif ply:GetPlayerClass() == "soldier" then
			ply:EmitSound("vo/mvm/norm/soldier_mvm_painsevere0"..math.random(1,6)..".mp3", 95, 100, 1, CHAN_VOICE)
		elseif ply:GetPlayerClass() == "pyro" then
			ply:EmitSound("vo/mvm/norm/pyro_mvm_painsevere0"..math.random(1,6)..".mp3", 95, 100, 1, CHAN_VOICE)
		elseif ply:GetPlayerClass() == "demoman" then
			ply:EmitSound("vo/mvm/norm/demoman_mvm_painsevere0"..math.random(1,4)..".mp3", 95, 100, 1, CHAN_VOICE)
		elseif ply:GetPlayerClass() == "heavy" then
			ply:EmitSound("vo/mvm/norm/heavy_mvm_painsevere0"..math.random(1,3)..".mp3", 95, 100, 1, CHAN_VOICE)
		elseif ply:GetPlayerClass() == "engineer" then
			ply:EmitSound("vo/mvm/norm/engineer_mvm_painsevere0"..math.random(1,7)..".mp3", 95, 100, 1, CHAN_VOICE)
		elseif ply:GetPlayerClass() == "medic" then
			ply:EmitSound("vo/mvm/norm/medic_mvm_painsevere0"..math.random(1,4)..".mp3", 95, 100, 1, CHAN_VOICE)
		elseif ply:GetPlayerClass() == "sniper" then
			ply:EmitSound("vo/mvm/norm/sniper_mvm_painsevere0"..math.random(1,4)..".mp3", 95, 100, 1, CHAN_VOICE)
		elseif ply:GetPlayerClass() == "spy" then
			ply:EmitSound("vo/mvm/norm/spy_mvm_painsevere0"..math.random(1,5)..".mp3", 95, 100, 1, CHAN_VOICE)
		end
	end
	ply:StopSound("BusterLoop")
	if not ply:IsHL2() and ply:GetPlayerClass() == "sentrybuster" then
		ply:EmitSound("MVM.SentryBusterExplode")
	end
	if not ply:IsHL2() and ply:GetInfoNum("tf_sentrybuster", 0) == 1 then
		ply:EmitSound("MVM.SentryBusterExplode")
	end
	if ply:GetPlayerClass() == "giantheavyheater" and ply:GetPlayerClass() == "giantheavyshotgun" and ply:GetPlayerClass() == "giantsoldierrapidfire" and ply:GetPlayerClass() == "giantsoldiercharged" then
		ply:EmitSound( "MVM.GiantCommonExplodes" ) -- Play the footsteps hunter is using
		ply:EmitSound( "MVM.GiantCommonExplodes" ) -- Play the footsteps hunter is using
		ply:PrecacheGibs()
		ply:GibBreakClient( Vector(math.random(1,4), math.random(1,4), math.random(1,4)) )
		ply:GetRagdollEntity():Remove()	
		for k,v in pairs(player.GetAll()) do
			if not v:IsFriendly(ply) and v:Alive() and not v:IsHL2() then
				if v:GetPlayerClass() == "heavy" then
					v:EmitSound("vo/heavy_mvm_giant_robot02.wav", 85, 100, 1, CHAN_REPLACE)
				elseif v:GetPlayerClass() == "medic" then
					v:EmitSound("vo/medic_mvm_giant_robot02.wav", 85, 100, 1, CHAN_REPLACE)
				end
			end
		end
	end
	if not ply:IsHL2() and ply:GetInfoNum("tf_mvm_giant_voodoo", 0) == 1 then
		ply:EmitSound( "MVM.GiantCommonExplodes" ) -- Play the footsteps hunter is using
		ply:PrecacheGibs()
		ply:GibBreakClient( Vector(math.random(1,4), math.random(1,4), math.random(1,4)) )
		ply:GetRagdollEntity():Remove()	
		for k,v in pairs(player.GetAll()) do
			if not v:IsFriendly(ply) and v:Alive() and not v:IsHL2() then
				if ply:GetPlayerClass() == "heavy" then
					ply:EmitSound("vo/heavy_mvm_giant_robot02.wav", 85, 100, 1, CHAN_REPLACE)
				elseif ply:GetPlayerClass() == "medic" then
					ply:EmitSound("vo/medic_mvm_giant_robot02.wav", 85, 100, 1, CHAN_REPLACE)
				end
			end
		end
	end
end)



hook.Remove("PlayerFootstep", "TA:Paint_Footsteps")

local function CopyPoseParams(pEntityFrom, pEntityTo)
	if (SERVER) then
		for i = 0, pEntityFrom:GetNumPoseParameters() - 1 do
			local sPose = pEntityFrom:GetPoseParameterName(i)
			pEntityTo:SetPoseParameter(sPose, pEntityFrom:GetPoseParameter(sPose))
		end
	else
		for i = 0, pEntityFrom:GetNumPoseParameters() - 1 do
			local flMin, flMax = pEntityFrom:GetPoseParameterRange(i)
			local sPose = pEntityFrom:GetPoseParameterName(i)
			pEntityTo:SetPoseParameter(sPose, math.Remap(pEntityFrom:GetPoseParameter(sPose), 0, 1, flMin, flMax))
		end
	end
end
hook.Add("Think", "CanYouSetMovea_XParameterToThePlayers?", function()
	if (math.random(1,3+(table.Count(player.GetAll())*0.4)) == 1) then 
		for k,pl in ipairs(player.GetAll()) do
			if (pl.IsL4DZombie) then
				pl:SetSaveValue("m_iClass",CLASS_ZOMBIE)
			elseif (pl:Team() == TEAM_BLU and !pl.IsL4DZombie) then
				pl:SetSaveValue("m_iClass",CLASS_COMBINE)
			elseif (pl:Team() == TEAM_RED and !pl.IsL4DZombie) then
				pl:SetSaveValue("m_iClass",CLASS_PLAYER)
			else
				pl:SetSaveValue("m_iClass",CLASS_HUMAN_MILITARY)
			end
			local vm = pl:GetViewModel()
			if (pl:IsL4D()) then
				CopyPoseParams(pl,vm)
			end
			
			if SERVER then
				if (pl:IsHL2()) then
					vm:SetPoseParameter("ver_aims", math.Remap(pl:GetPoseParameter("aim_pitch"),90,-45,1,-1))
					vm:SetPoseParameter("hor_aims", math.Remap(pl:GetPoseParameter("aim_yaw"),45,-45,-1,1))
				else
					vm:SetPoseParameter("ver_aims", math.Remap(pl:GetPoseParameter("body_pitch"),90,-45,1,-1))
					vm:SetPoseParameter("hor_aims", math.Remap(pl:GetPoseParameter("body_yaw"),45,-45,-1,1))
				end
			end
			if (pl:WaterLevel() > 1) then
				if (pl:IsOnFire()) then
					pl:Extinguish()
				end
			end
		end
	end
end)

concommand.Add( "tf_sentrybuster_explode", function( ply, cmd )

	if (ply:GetPlayerClass() == "sentrybuster") then
	ply:SetNoDraw(true)
	ply:EmitSound("MVM.SentryBusterSpin")
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	local animent = ents.Create( 'base_gmodentity' ) -- The entity used as a reference for the bone positioning
	animent:SetModel( ply:GetModel() )
	animent:SetModelScale( ply:GetModelScale() )
	timer.Create("SetAnimPos", 0.01, 0, function()
		if not animent:IsValid() then timer.Stop("SetAnimPos") return end
		animent:SetPos( ply:GetPos() )
		animent:SetAngles( ply:GetAngles() )
	end )
	animent:SetNoDraw( false ) -- The ragdoll is the thing getting seen
	animent:Spawn()
	
	animent:SetSequence( "sentry_buster_preexplode" ) -- If the sequence isn't valid, the sequence length is 0, so the timer takes care of things
	animent:SetPlaybackRate( 1 )
	animent.AutomaticFrameAdvance = true
	
	animent:SetSolid( SOLID_OBB ) -- This stuff isn't really needed, but just for physics
	animent:PhysicsInit( SOLID_OBB )
	animent:SetMoveType( MOVETYPE_FLYGRAVITY )
	animent:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	animent:PhysWake()
	
	function animent:Think() -- This makes the animation work
		self:NextThink( CurTime() )
		return true
	end
	timer.Simple(2.5, function()
		ParticleEffect("asplode_hoodoo_shockwave", ply:GetPos() + Vector(0,0,35), ply:GetAngles())
		ParticleEffect("asplode_hoodoo_shockwave", ply:GetPos() + Vector(0,0,35), ply:GetAngles())
		ParticleEffect("asplode_hoodoo_shockwave", ply:GetPos() + Vector(0,0,35), ply:GetAngles())
		ParticleEffect("asplode_hoodoo_shockwave", ply:GetPos() + Vector(0,0,35), ply:GetAngles())
	
		ParticleEffect("cinefx_goldrush_flash", ply:GetPos(), ply:GetAngles())
		ParticleEffect("fireSmoke_Collumn_mvmAcres", ply:GetPos(), Angle())
		ParticleEffect("fluidSmokeExpl_ring_mvm", ply:GetPos() + Vector(50,50,25), ply:GetAngles())
		ParticleEffect("fluidSmokeExpl_ring_mvm", ply:GetPos() + Vector(-50,-50,25), ply:GetAngles())
		ParticleEffect("fluidSmokeExpl_ring_mvm", ply:GetPos() + Vector(-50,50,25), ply:GetAngles())
		ParticleEffect("fluidSmokeExpl_ring_mvm", ply:GetPos() + Vector(50,-50,25), ply:GetAngles())

		ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", ply:GetPos() + Vector(50,50,25), ply:GetAngles())
		ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", ply:GetPos() + Vector(-50,-50,25), ply:GetAngles())
		ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", ply:GetPos() + Vector(-50,50,25), ply:GetAngles())
		ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", ply:GetPos() + Vector(50,-50,25), ply:GetAngles())

		if animent:IsValid() then
			animent:Remove() 
		end
	
		ply:EmitSound("MvM.SentryBusterExplode")
		ply:SetNoDraw(false)

		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
		if ply:GetRagdollEntity():IsValid() then
			ply:GetRagdollEntity():Remove()
		end
		for k,v in pairs(ents.FindInSphere(ply:GetPos(), 800)) do 
			if !v:IsPlayer() and v:Health() >= 0 and not v:IsFriendly(ply) then
				v:TakeDamage( v:Health(), ply, ply:GetActiveWeapon() )
			elseif v:IsPlayer() and not v:IsFriendly(ply) and v:Alive() and v:Nick() != ply:Nick() then
				v:TakeDamage( v:Health(), ply, ply:GetActiveWeapon() )
			end
		end
		ply:TakeDamage( ply:Health(), ply, ply:GetActiveWeapon() )
	end)
	end
end)


hook.Add( "DoAnimationEvent" , "AnimEventTest" , function( ply , event , data )
	if event == PLAYERANIMEVENT_ATTACK_GRENADE then
		if data == 123 then
			ply:AnimRestartGesture( GESTURE_SLOT_GRENADE, ACT_GMOD_GESTURE_ITEM_THROW, true )
			return ACT_INVALID
		end

		if data == 321 then
			ply:AnimRestartGesture( GESTURE_SLOT_GRENADE, ACT_GMOD_GESTURE_ITEM_DROP, true )
			return ACT_INVALID
		end
	end
end )

concommand.Add("merc_impulse101", function(ply)
	if ply:GetPlayerClass() == "merc_dm" then
		ply:Give("tf_weapon_pistol_merc")
		ply:Give("tf_weapon_shotgun_merc")
		ply:Give("tf_weapon_rocketlauncher_merc")
		ply:Give("tf_weapon_rocketlauncher_rapidfire") 
		ply:Give("tf_weapon_nailgun_merc")
		ply:Give("tf_weapon_revolver_merc")
		ply:Give("tf_weapon_grenadelauncher_merc")
		ply:Give("tf_weapon_smg_dm_merc")
		ply:Give("tf_weapon_smg_merc")
		ply:Give("tf_weapon_gatlinggun")
		ply:Give("tf_weapon_supershotgun_merc")
		ply:Give("tf_weapon_sniperrifle_merc")
		ply:Give("tf_weapon_medigun_merc")
		ply:Give("tf_weapon_flamethrower_merc")
		ply:Give("tf_weapon_knife_merc")
		ply:Give("tf_weapon_railgun_merc")
		ply:Give("tf_weapon_minigun_merc")
		ply:Give("tf_weapon_pda_engineer_destroy_merc")
		ply:Give("tf_weapon_pda_engineer_build_merc")
		ply:Give("tf_weapon_wrench_merc")
		ply:Give("tf_weapon_scattergun_merc")
		ply:Give("tf_weapon_pipebomblauncher_merc")
		ply:GiveItem("TF_WEAPON_BUILDER")
		ply:EmitSound("items/spawn_item.wav")
	end
end)

concommand.Add("tf_givegravitygun", function(ply) 
	if not ply:IsHL2() then
		ply:Give("tf_weapon_physcannon") 
		ply:EmitSound("weapons/physcannon/physcannon_charge.wav")
	end
end)



concommand.Add("tf_givemegagravitygun", function(ply) 
	if not ply:IsHL2() then
		ply:Give("tf_weapon_superphyscannon") 
		ply:EmitSound("weapons/physcannon/superphys_chargeup.wav")
	end
end)


local function PlayerGiantBotSpawn( ply, mv )
	if (!IsValid(ply)) then return end
	-- dun dun dun dun dun dun dun dun DO THE LOSKY ~ seamusmario
	-- oh hell no boy, don't you be mentioning that leafer ~ future seamusmario
	--[[
	if ply:GetModel() == "models/player/loskybasics/losky_pm.mdl" then
		ply:EmitSound("vo/losky_respawn01.wav")
	end]]
	timer.Simple(0.4, function()
		if ply:GetInfoNum("tf_lazyzombie", 0) == 1 then
			if ply:GetPlayerClass() != "demoman" then
				ply:SetModel("models/lazy_zombies_v2/"..ply:GetPlayerClass()..".mdl")
			else
				ply:SetModel("models/lazy_zombies_v2/demo.mdl")
			end
		end
		if GetConVar("tf_muselk_zombies"):GetBool() then
			if ply:Team() == TEAM_RED then
				ply:SetPlayerClass("engineer")
				
				ply:PrintMessage(HUD_PRINTCENTER, "You are now defending! You must find a place to hide! If the zombies team doesn't do it in the next 5 minutes, YOU WIN!")
					
			elseif ply:Team() == TEAM_NEUTRAL then
				ply:SetTeam(TEAM_RED)
				ply:SetPlayerClass("engineer")
				
				ply:PrintMessage(HUD_PRINTCENTER, "You are now defending! You must find a place to hide! If the zombies team doesn't do it in the next 5 minutes, YOU WIN!")
			elseif ply:Team() == TEAM_BLU then
				ply:GetWeapons()[1]:Remove()
				ply:GetWeapons()[2]:Remove()
				ply:SetPos(Vector(9086.43, 10060.49, -10786.25)) 
				ply:PrintMessage(HUD_PRINTCENTER, "You are now attacking! You must find the engineers and infect them! If your team doesn't do it in the next 5 minutes, YOU LOSE!")
				timer.Simple(0.4, function()
					if ply:GetPlayerClass() != "demoman" then
						ply:SetModel("models/lazy_zombies_v2/"..ply:GetPlayerClass()..".mdl")
					else
						ply:SetModel("models/lazy_zombies_v2/demo.mdl")
					end
				end)
			end
		end
	end)
	timer.Simple(0.3, function()
		if (IsValid(ply)) then
			if not ply:IsHL2() and ply:GetInfoNum("tf_sentrybuster", 0) == 1 then
				if ply:GetPlayerClass() != "demoman" then ply:SetPlayerClass("demoman") end
				for k,v in pairs(player.GetAll()) do
					if not v:IsFriendly(ply) and v:Alive() and not v:IsHL2() then
						if v:GetPlayerClass() == "heavy" then
							v:EmitSound("vo/heavy_mvm_sentry_buster01.wav", 85, 100, 1, CHAN_REPLACE)
						elseif v:GetPlayerClass() == "medic" then
							v:EmitSound("vo/medic_mvm_sentry_buster01.wav", 85, 100, 1, CHAN_REPLACE)
						elseif v:GetPlayerClass() == "soldier" then
							v:EmitSound("vo/soldier_mvm_sentry_buster01.wav", 85, 100, 1, CHAN_REPLACE)
						elseif v:GetPlayerClass() == "engineer" then
							v:EmitSound("vo/engineer_mvm_sentry_buster01.wav", 85, 100, 1, CHAN_REPLACE)
						end
					end
				end
				for k,v in ipairs(player.GetAll()) do
					v:EmitSound("Announcer.MVM_Sentry_Buster_Alert")
				end
				ply:EmitSound("MVM.SentryBusterIntro")
				ply:EmitSound("BusterLoop")
				ply:SetModel("models/bots/demo/bot_sentry_buster.mdl")
				ply:SetHealth(3600)
				ply:StripWeapon("tf_weapon_grenadelauncher")
				ply:StripWeapon("tf_weapon_pipebomblauncher")
				ply:SetModelScale(1.75)
				ply:SetClassSpeed(400)

				timer.Create("SentryBusterIntroLoop", 4, 0, function()
					if not ply:Alive() then timer.Stop("HHHSpeed2") return end
					if ply:GetInfoNum("tf_sentrybuster", 0) == 0 then timer.Stop("HHHSpeed2") return end
					ply:EmitSound("MVM.SentryBusterIntro")
				end)
			
				timer.Create("SentryBusterExplodeNearSentry"..ply:EntIndex(), 0.1, 0, function()
					if !ply:Alive() then timer.Stop("SentryBusterExplodeNearSentry"..ply:EntIndex()) return end
					if ply:GetInfoNum("tf_sentrybuster",0) != 1 then timer.Stop("SentryBusterExplodeNearSentry"..ply:EntIndex()) return end
					if ply:GetInfoNum("tf_sentrybuster",0) != 1 then return end
					for _,building in pairs(ents.FindInSphere(ply:GetPos(), 80)) do
						if building:GetClass() == "obj_sentrygun" then	
						ply:SetNoDraw(true)
						ply:EmitSound("MVM.SentryBusterSpin")
						ply:SetNWBool("Taunting", true)
						ply:SetNWBool("NoWeapon", true)
						net.Start("ActivateTauntCam")
						net.Send(ply)
						local animent = ents.Create( 'base_gmodentity' ) -- The entity used as a reference for the bone positioning
						animent:SetModel( ply:GetModel() )
						animent:SetModelScale( ply:GetModelScale() )
						timer.Create("SetAnimPos", 0.01, 0, function()
							if not animent:IsValid() then timer.Stop("SetAnimPos") return end
							animent:SetPos( ply:GetPos() )
							animent:SetAngles( ply:GetAngles() )
						end )
						animent:SetNoDraw( false ) -- The ragdoll is the thing getting seen
						animent:Spawn()
											
						animent:SetSequence( "sentry_buster_preexplode" ) -- If the sequence isn't valid, the sequence length is 0, so the timer takes care of things
						animent:SetPlaybackRate( 1 )
						animent.AutomaticFrameAdvance = true
												
						animent:SetSolid( SOLID_OBB ) -- This stuff isn't really needed, but just for physics
						animent:PhysicsInit( SOLID_OBB )
						animent:SetMoveType( MOVETYPE_FLYGRAVITY )
						animent:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
						animent:PhysWake()
											
						function animent:Think() -- This makes the animation work
							self:NextThink( CurTime() )
							return true
						end
						timer.Simple(2.5, function()
							ParticleEffect("asplode_hoodoo_shockwave", ply:GetPos() + Vector(0,0,35), ply:GetAngles())
							ParticleEffect("asplode_hoodoo_shockwave", ply:GetPos() + Vector(0,0,35), ply:GetAngles())
							ParticleEffect("asplode_hoodoo_shockwave", ply:GetPos() + Vector(0,0,35), ply:GetAngles())
							ParticleEffect("asplode_hoodoo_shockwave", ply:GetPos() + Vector(0,0,35), ply:GetAngles())
											
							ParticleEffect("cinefx_goldrush_flash", ply:GetPos(), ply:GetAngles())
								ParticleEffect("fireSmoke_Collumn_mvmAcres", ply:GetPos(), Angle())
							ParticleEffect("fluidSmokeExpl_ring_mvm", ply:GetPos() + Vector(50,50,25), ply:GetAngles())
							ParticleEffect("fluidSmokeExpl_ring_mvm", ply:GetPos() + Vector(-50,-50,25), ply:GetAngles())
							ParticleEffect("fluidSmokeExpl_ring_mvm", ply:GetPos() + Vector(-50,50,25), ply:GetAngles())
							ParticleEffect("fluidSmokeExpl_ring_mvm", ply:GetPos() + Vector(50,-50,25), ply:GetAngles())

							ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", ply:GetPos() + Vector(50,50,25), ply:GetAngles())
							ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", ply:GetPos() + Vector(-50,-50,25), ply:GetAngles())
							ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", ply:GetPos() + Vector(-50,50,25), ply:GetAngles())
							ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", ply:GetPos() + Vector(50,-50,25), ply:GetAngles())

							if animent:IsValid() then
								animent:Remove() 
							end

							ply:EmitSound("MvM.SentryBusterExplode")
							ply:EmitSound("MvM.SentryBusterExplode")
							ply:EmitSound("MvM.SentryBusterExplode")
							ply:SetNoDraw(false)

							ply:SetNWBool("Taunting", false)
							ply:SetNWBool("NoWeapon", false)
							net.Start("DeActivateTauntCam")
							net.Send(ply)
							if ply:GetRagdollEntity():IsValid() then
								ply:GetRagdollEntity():Remove()
							end
							for k,v in pairs(ents.FindInSphere(ply:GetPos(), 800)) do 
								if !v:IsPlayer() and v:Health() >= 0 and not v:IsFriendly(ply) then
									v:TakeDamage( v:Health(), ply, ply:GetActiveWeapon() )
								elseif v:IsPlayer() and not v:IsFriendly(ply) and v:Alive() and v:Nick() != ply:Nick() then
									v:TakeDamage( v:Health(), ply, ply:GetActiveWeapon() )
								end
							end
							ply:TakeDamage( ply:Health(), ply, ply:GetActiveWeapon() )
						end)
						timer.Stop("SentryBusterExplodeNearSentry"..ply:EntIndex())
						end
					end
				end)
				timer.Create("SentryBusterExplodeOnDeath", 0.1, 0, function()
					if !ply:Alive() then timer.Stop("SentryBusterExplodeOnDeath"..ply:EntIndex()) return end
					if ply:GetInfoNum("tf_sentrybuster",0) != 1 then timer.Stop("SentryBusterExplodeOnDeath"..ply:EntIndex()) return end
					if ply:GetInfoNum("tf_sentrybuster",0) != 1 then return end
					if ply:Health() <= 30 then
					ply:EmitSound("MVM.SentryBusterSpin")
					timer.Simple(0.1, function()
					ply:GodEnable()
					ply:SetNoDraw(true)
					ply:SetNWBool("Taunting", true)
					ply:SetNWBool("NoWeapon", true)
					net.Start("ActivateTauntCam")
					local animent = ents.Create( 'base_gmodentity' ) -- The entity used as a reference for the bone positioning
					animent:SetModel( ply:GetModel() )
					animent:SetModelScale( ply:GetModelScale() )
					timer.Create("SetAnimPos", 0.01, 0, function()
						if not animent:IsValid() then timer.Stop("SetAnimPos") return end
						animent:SetPos( ply:GetPos() )
						animent:SetAngles( ply:GetAngles() )
					end )
					animent:SetNoDraw( false ) -- The ragdoll is the thing getting seen
					animent:Spawn()
		
					animent:SetSequence( "sentry_buster_preexplode" ) -- If the sequence isn't valid, the sequence length is 0, so the timer takes care of things
					animent:SetPlaybackRate( 1 )
					animent.AutomaticFrameAdvance = true
		
					animent:SetSolid( SOLID_OBB ) -- This stuff isn't really needed, but just for physics
					animent:PhysicsInit( SOLID_OBB )
					animent:SetMoveType( MOVETYPE_FLYGRAVITY )
					animent:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
					animent:PhysWake()
		
					function animent:Think() -- This makes the animation work
						self:NextThink( CurTime() - 5 )
						return true
					end
					timer.Simple(2, function()
						ParticleEffect("asplode_hoodoo_shockwave", ply:GetPos() + Vector(0,0,35), ply:GetAngles())
						ParticleEffect("asplode_hoodoo_shockwave", ply:GetPos() + Vector(0,0,35), ply:GetAngles())
						ParticleEffect("asplode_hoodoo_shockwave", ply:GetPos() + Vector(0,0,35), ply:GetAngles())
						ParticleEffect("asplode_hoodoo_shockwave", ply:GetPos() + Vector(0,0,35), ply:GetAngles())
		
						ParticleEffect("cinefx_goldrush_flash", ply:GetPos(), ply:GetAngles())
						ParticleEffect("fireSmoke_Collumn_mvmAcres", ply:GetPos(), Angle())
						ParticleEffect("fluidSmokeExpl_ring_mvm", ply:GetPos() + Vector(50,50,25), ply:GetAngles())
						ParticleEffect("fluidSmokeExpl_ring_mvm", ply:GetPos() + Vector(-50,-50,25), ply:GetAngles())
						ParticleEffect("fluidSmokeExpl_ring_mvm", ply:GetPos() + Vector(-50,50,25), ply:GetAngles())
						ParticleEffect("fluidSmokeExpl_ring_mvm", ply:GetPos() + Vector(50,-50,25), ply:GetAngles())

						ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", ply:GetPos() + Vector(50,50,25), ply:GetAngles())
						ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", ply:GetPos() + Vector(-50,-50,25), ply:GetAngles())
						ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", ply:GetPos() + Vector(-50,50,25), ply:GetAngles())
						ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", ply:GetPos() + Vector(50,-50,25), ply:GetAngles())
			
						if animent:IsValid() then
							animent:Remove()
						end
		
						ply:EmitSound("MvM.SentryBusterExplode")
						ply:SetNoDraw(false)
						ply:GodDisable()

						ply:SetNWBool("Taunting", false)
						ply:SetNWBool("NoWeapon", false)
						net.Start("DeActivateTauntCam")
						if ply:GetRagdollEntity():IsValid() then
							ply:GetRagdollEntity():Remove()
						end
						for k,v in pairs(ents.FindInSphere(ply:GetPos(), 800)) do 
							if v:IsNPC() and not v:IsFriendly(ply) then
								v:TakeDamage( v:Health(), ply, ply:GetActiveWeapon() )
							elseif v:IsPlayer() and not v:IsFriendly(ply) and ply:Alive() then
								v:TakeDamage( v:Health(), ply, ply:GetActiveWeapon() )
							end
						end
						ply:Kill()
					end)
					end)
					timer.Stop("SentryBusterExplodeOnDeath")
					end
				end)
			end
			if not ply:IsHL2() and ply:GetInfoNum("tf_robot", 0) == 1 then
				local ID = ply:LookupAttachment( "eye_1" )
				local Attachment = ply:GetAttachment( ID )
				if (Attachment == nil) then return end

				eyeparticle1 = ents.Create( "info_particle_system" )
				eyeparticle1:SetPos( Attachment.Pos )
				eyeparticle1:SetAngles( Attachment.Ang )
				eyeparticle1:SetName("eyeparticle1")
				eyeparticle1:SetOwner(ply)
				ply:DeleteOnRemove(eyeparticle1)

				PrecacheParticleSystem("bot_eye_glow")
				eyeparticle1:SetKeyValue( "effect_name", "bot_eye_glow" )
				eyeparticle1:SetKeyValue( "start_active", "1")

				local colorcontrol = ents.Create( "info_particle_system" )
				if (ply.Difficulty == 3) then
					colorcontrol:SetPos( Vector(255,180,36) )
				else
					if ply:Team() == TEAM_RED then
						colorcontrol:SetPos( Vector(204,0,0) )
					elseif ply:Team() == TEAM_BLU then
						colorcontrol:SetPos( Vector(51,255,255) )
					end
				end
				eyeparticle1:DeleteOnRemove(colorcontrol)
				colorcontrol:SetKeyValue( "effect_name", "bot_eye_glow" )
				--colorcontrol:SetKeyValue( "globalname", "colorcontrol_".. eyeparticle1:EntIndex())
				colorcontrol:SetName("colorcontrol_".. eyeparticle1:EntIndex())
				colorcontrol:Spawn()

				eyeparticle1:SetParent(ply)
				eyeparticle1:Fire("setparentattachment", "eye_1", 0.01)
				eyeparticle1:SetKeyValue( "cpoint1", "colorcontrol_".. eyeparticle1:EntIndex() ) --the color is controlled by the position of this entity - 
															--if the colorcontroller's position is 255, 255, 255, 
															--the color of the particle becomes white (255 255 255)
				eyeparticle1:Spawn()
				eyeparticle1:Activate()
				--now for eye two
				local ID = ply:LookupAttachment( "eye_2" )
				local Attachment = ply:GetAttachment( ID )
				if (Attachment != nil) then 
					eyeparticle2 = ents.Create( "info_particle_system" )
					eyeparticle2:SetPos( Attachment.Pos )
					eyeparticle2:SetAngles( Attachment.Ang )
					eyeparticle1:DeleteOnRemove(eyeparticle2)
					eyeparticle2:SetKeyValue( "effect_name", "bot_eye_glow" )
					eyeparticle2:SetKeyValue( "start_active", "1")
					eyeparticle2:SetParent(ply)
					eyeparticle2:SetName("eyeparticle2")
					eyeparticle2:Fire("setparentattachment", "eye_2", 0.01)
					eyeparticle2:SetKeyValue( "cpoint1", "colorcontrol_".. eyeparticle1:EntIndex() )
					eyeparticle2:Spawn()
					eyeparticle2:Activate()							

				end
				timer.Create("KillParticlesOnDeath", 0.001, 0, function()
					if ply:Alive() then
						return true
					else
						for k,v in pairs(ents.FindByName("eyeparticle1")) do 
							if v:GetOwner() == ply then
								v:Remove()
							end
						end
						timer.Stop("KillParticlesOnDeath")
						return false
					end
				end)
			end
			
			if not ply:IsHL2() and ply:GetInfoNum("tf_giant_robot", 0) == 1 then

				for k,v in pairs(player.GetAll()) do
					if not v:IsFriendly(ply) and v:Alive() and not v:IsHL2() then
						if v:GetPlayerClass() == "heavy" then
							v:EmitSound("vo/heavy_mvm_giant_robot04.wav", 85, 100, 1, CHAN_REPLACE)
						elseif v:GetPlayerClass() == "medic" then
							v:EmitSound("vo/medic_mvm_giant_robot01.wav", 85, 100, 1, CHAN_REPLACE)
						elseif v:GetPlayerClass() == "soldier" then
							v:EmitSound("vo/soldier_mvm_giant_robot0"..math.random(1,2)..".wav", 85, 100, 1, CHAN_REPLACE)
						elseif v:GetPlayerClass() == "engineer" then
							v:EmitSound("vo/engineer_mvm_giant_robot0"..math.random(1,2)..".wav", 85, 100, 1, CHAN_REPLACE)
						end
					end
				end
				if ply:GetPlayerClass() == "scout" then
					timer.Create("GiantRobotSpeed"..ply:EntIndex(), 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
					end)
					ply:SetModel("models/bots/scout_boss/bot_scout_boss.mdl")
					ply:SetModelScale(1.75)
					ply:SetHealth(1600)
					ply:SetMaxHealth(1600)
				elseif ply:GetPlayerClass() == "soldier" then
					timer.Create("GiantRobotSpeed"..ply:EntIndex(), 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
						if ply:GetInfoNum("tf_giant_robot", 0) == 0 then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
					end)
					ply:SetModel("models/bots/soldier_boss/bot_soldier_boss.mdl")
					ply:SetModelScale(1.75)
					ply:SetHealth(3600)
					ply:SetMaxHealth(3600)
				elseif ply:GetPlayerClass() == "demoman" then
					timer.Create("GiantRobotSpeed"..ply:EntIndex(), 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
						if ply:GetInfoNum("tf_giant_robot", 0) == 0 then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
						//ply:SetPoseParameter("move_x", 1)
					end)
					ply:SetModel("models/bots/demo_boss/bot_demo_boss.mdl")
					ply:SetModelScale(1.75)
					ply:SetHealth(3600)
					ply:SetMaxHealth(3600)
				elseif ply:GetPlayerClass() == "heavy" then
					timer.Create("GiantRobotSpeed"..ply:EntIndex(), 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
						if ply:GetInfoNum("tf_giant_robot", 0) == 0 then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
						//ply:SetPoseParameter("move_x", 1)
					end)
					ply:EmitSound("MVM.GiantHeavyEntrance")
					ply:SetModel("models/bots/heavy_boss/bot_heavy_boss.mdl")
					ply:SetModelScale(1.75)
					ply:SetHealth(5000)
				elseif ply:GetPlayerClass() == "pyro" then
					timer.Create("GiantRobotSpeed"..ply:EntIndex(), 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
						if ply:GetInfoNum("tf_giant_robot", 0) == 0 then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
						//ply:SetPoseParameter("move_x", 1)
					end)
					ply:SetModel("models/bots/pyro_boss/bot_pyro_boss.mdl")
					ply:SetModelScale(1.75)
					ply:SetHealth(3600)
					ply:SetMaxHealth(3600)
				elseif ply:GetPlayerClass() == "medic" then
					timer.Create("GiantRobotSpeed"..ply:EntIndex(), 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
						if ply:GetInfoNum("tf_giant_robot", 0) == 0 then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
						//ply:SetPoseParameter("move_x", 1)
					end)
					ply:SetModel("models/bots/medic/bot_medic.mdl")
					ply:SetModelScale(1.75)
					ply:SetHealth(3600)
					ply:SetMaxHealth(3600)
				elseif ply:GetPlayerClass() == "engineer" then
					timer.Create("GiantRobotSpeed"..ply:EntIndex(), 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
						if ply:GetInfoNum("tf_giant_robot", 0) == 0 then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
						//ply:SetPoseParameter("move_x", 1)
					end)
					ply:SetModel("models/bots/engineer/bot_engineer.mdl")
					ply:SetModelScale(1.75)
					ply:SetHealth(1600)
					ply:SetMaxHealth(1600)
				elseif ply:GetPlayerClass() == "sniper" then
					timer.Create("GiantRobotSpeed"..ply:EntIndex(), 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
						if ply:GetInfoNum("tf_giant_robot", 0) == 0 then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
						//ply:SetPoseParameter("move_x", 1)
					end)
					ply:SetModel("models/bots/sniper/bot_sniper.mdl")
					ply:SetModelScale(1.75)
					ply:SetHealth(1800)
					ply:SetMaxHealth(1800)
				elseif ply:GetPlayerClass() == "spy" then
					timer.Create("GiantRobotSpeed"..ply:EntIndex(), 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
						if ply:GetInfoNum("tf_giant_robot", 0) == 0 then timer.Stop("GiantRobotSpeed"..ply:EntIndex()) return end
						//ply:SetPoseParameter("move_x", 1)
					end)
					ply:SetModel("models/bots/spy/bot_spy.mdl")
					ply:SetModelScale(1.75)
					ply:SetHealth(1200)
					ply:SetMaxHealth(1200)
				end
			end
			if ply:GetInfoNum("tf_zombie", 0) == 1 then
				if ply:GetPlayerClass() == "scout" then
					ply:SetModel("models/lazy_zombies_v2/scout.mdl")
					ply:StripWeapon("tf_weapon_scattergun")
					ply:StripWeapon("tf_weapon_pistol_scout")
				elseif ply:GetPlayerClass() == "gmodplayer" then
					timer.Create("GiantRobotSpeed2", 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed2") return end
						if ply:GetInfoNum("tf_zombie", 0) == 0 then timer.Stop("GiantRobotSpeed2") return end
						ply:SetWalkSpeed(65)
						ply:SetRunSpeed(105)
					end)
					ply:SetModel( table.Random(zombiemodel) )
					ply:StripWeapons()
					ply:Give("weapon_fists")	
				elseif ply:GetPlayerClass() == "soldier" then
					ply:SetModel("models/lazy_zombies_v2/soldier.mdl")
					ply:StripWeapon("tf_weapon_rocketlauncher")
					ply:StripWeapon("tf_weapon_shotgun_soldier")
				elseif ply:GetPlayerClass() == "demoman" then
					ply:SetModel("models/lazy_zombies_v2/demo.mdl")
					ply:StripWeapon("tf_weapon_grenadelauncher")
					ply:StripWeapon("tf_weapon_pipebomblauncher")
				elseif ply:GetPlayerClass() == "heavy" then
					ply:SetModel("models/lazy_zombies_v2/heavy.mdl")
					ply:StripWeapon("tf_weapon_minigun")
					ply:StripWeapon("tf_weapon_shotgun_heavy")
				elseif ply:GetPlayerClass() == "pyro" then
					ply:SetModel("models/lazy_zombies_v2/pyro.mdl")
					ply:StripWeapon("tf_weapon_flamethrower")
					ply:StripWeapon("tf_weapon_shotgun_pyro")
				elseif ply:GetPlayerClass() == "medic" then
					ply:SetModel("models/lazy_zombies_v2/medic.mdl")
					ply:StripWeapon("tf_weapon_syringegun")
					ply:StripWeapon("tf_weapon_medigun")
				elseif ply:GetPlayerClass() == "engineer" then
					ply:SetModel("models/lazy_zombies_v2/engineer.mdl")
					ply:StripWeapon("tf_weapon_shotgun_primary")
					ply:StripWeapon("tf_weapon_pistol")
				elseif ply:GetPlayerClass() == "sniper" then
					ply:SetModel("models/lazy_zombies_v2/sniper.mdl")
					ply:StripWeapon("tf_weapon_sniperrifle")
					ply:StripWeapon("tf_weapon_smg")
				elseif ply:GetPlayerClass() == "spy" then
					ply:SetModel("models/lazy_zombies_v2/spy.mdl")
					ply:StripWeapon("tf_weapon_revolver")
					ply:StripWeapon("tf_weapon_builder")
					ply:StripWeapon("tf_weapon_pda_spy")
				end
			end
			if not ply:IsHL2() and ply:GetInfoNum("tf_voodoo", 0) == 1 then
				if ply:GetPlayerClass() == "scout" then
					ply:SetModel("models/lazy_zombies_v2/scout.mdl")	
				elseif ply:GetPlayerClass() == "soldier" then
					ply:SetModel("models/lazy_zombies_v2/soldier.mdl")
				elseif ply:GetPlayerClass() == "demoman" then
					ply:SetModel("models/lazy_zombies_v2/demo.mdl")
				elseif ply:GetPlayerClass() == "heavy" then
					ply:SetModel("models/lazy_zombies_v2/heavy.mdl")
				elseif ply:GetPlayerClass() == "pyro" then
					ply:SetModel("models/lazy_zombies_v2/pyro.mdl")
				elseif ply:GetPlayerClass() == "medic" then
					ply:SetModel("models/lazy_zombies_v2/medic.mdl")
				elseif ply:GetPlayerClass() == "engineer" then
					ply:SetModel("models/lazy_zombies_v2/engineer.mdl")
					ply:StripWeapon("tf_weapon_pistol")
				elseif ply:GetPlayerClass() == "sniper" then
					ply:SetModel("models/lazy_zombies_v2/sniper.mdl")
				elseif ply:GetPlayerClass() == "spy" then
					ply:SetModel("models/lazy_zombies_v2/spy.mdl")
				end
			end
			if not ply:IsHL2() and ply:GetInfoNum("tf_bigzombie", 0) == 1 then
				ply:SetModelScale(1.85)
				if ply:GetPlayerClass() == "scout" then
					ply:SetModel("models/lazy_zombies_v2/scout.mdl")
					ply:StripWeapon("tf_weapon_scattergun")
					ply:StripWeapon("tf_weapon_pistol_scout")
				elseif ply:GetPlayerClass() == "soldier" then
					ply:SetModel("models/lazy_zombies_v2/soldier.mdl")
					ply:StripWeapon("tf_weapon_rocketlauncher")
					ply:StripWeapon("tf_weapon_shotgun_soldier")
				elseif ply:GetPlayerClass() == "demoman" then
					ply:SetModel("models/lazy_zombies_v2/demo.mdl")
					ply:StripWeapon("tf_weapon_grenadelauncher")
					ply:StripWeapon("tf_weapon_pipebomblauncher")
				elseif ply:GetPlayerClass() == "heavy" then
					ply:SetModel("models/lazy_zombies_v2/heavy.mdl")
					ply:StripWeapon("tf_weapon_minigun")
					ply:StripWeapon("tf_weapon_shotgun_heavy")
				elseif ply:GetPlayerClass() == "pyro" then
					ply:SetModel("models/lazy_zombies_v2/pyro.mdl")
					ply:StripWeapon("tf_weapon_flamethrower")
					ply:StripWeapon("tf_weapon_shotgun_pyro")
				elseif ply:GetPlayerClass() == "medic" then
					ply:SetModel("models/lazy_zombies_v2/medic.mdl")
					ply:StripWeapon("tf_weapon_syringegun")
					ply:StripWeapon("tf_weapon_medigun")
				elseif ply:GetPlayerClass() == "engineer" then
					ply:SetModel("models/lazy_zombies_v2/engineer.mdl")
					ply:StripWeapon("tf_weapon_shotgun_primary")
					ply:StripWeapon("tf_weapon_pistol")
				elseif ply:GetPlayerClass() == "sniper" then
					ply:SetModel("models/lazy_zombies_v2/sniper.mdl")
					ply:StripWeapon("tf_weapon_sniperrifle")
					ply:StripWeapon("tf_weapon_smg")
				elseif ply:GetPlayerClass() == "spy" then
					ply:SetModel("models/lazy_zombies_v2/spy.mdl")
					ply:StripWeapon("tf_weapon_revolver")
					ply:StripWeapon("tf_weapon_builder")
					ply:StripWeapon("tf_weapon_pda_spy")
				end
			end
		
			if not ply:IsHL2() and ply:GetInfoNum("jakey_antlionfbii", 0) == 1 then
				if ply:GetPlayerClass() != "heavy" then ply:SetPlayerClass("heavy") end
				ply:SetModel("models/player/antlion_fbi/antlion_guard.mdl")
				ply:SetHealth(5200)
				ply:SetMaxHealth(5000)
				ply:StripWeapon("tf_weapon_minigun")
				ply:StripWeapon("tf_weapon_shotgun_hwg") 
				ply:SetWalkSpeed(600)
				ply:SetRunSpeed(600)
			end
			if ply:GetInfoNum("dylan_rageheavy", 0) == 1 then
				if !ply:IsAdmin() then return end
				if ply:GetPlayerClass() != "heavy" then ply:SetPlayerClass("heavy") end
				ply:SetHealth(1000000000000)
				ply:SetMaxHealth(1000000000000) 
				timer.Create("GiantRobotSpeed", 0.01, 0, function()
					if not ply:Alive() then timer.Stop("GiantRobotSpeed") return end
					if ply:GetInfoNum("dylan_rageheavy", 0) == 0 then timer.Stop("GiantRobotSpeed") return end
					ply:SetWalkSpeed(1250)
					ply:SetMaxSpeed(1250) 
					ply:SetRunSpeed(1250)
				end)
			end
			if ply:GetInfoNum("hahahahahahahahaowneronly_ragespy", 0) == 1 then
				if !ply:IsAdmin() then return end
				if ply:GetPlayerClass() != "spy" then ply:SetPlayerClass("spy") end
				ply:SetHealth(1000000000000)
				ply:SetMaxHealth(1000000000000)
				timer.Create("GiantRobotSpeed", 0.01, 0, function()
					if not ply:Alive() then timer.Stop("GiantRobotSpeed") return end
					if ply:GetInfoNum("hahahahahahahahaowneronly_ragespy", 0) == 0 then timer.Stop("GiantRobotSpeed") return end
					ply:SetWalkSpeed(1250)
					ply:SetMaxSpeed(1250)
					ply:SetRunSpeed(1250)
				end)
			end

			if not ply:IsHL2() and ply:GetPlayerClass() == "sniper" and ply:GetInfoNum("tf_skeleton", 0) == 1 then
				ply:SetModel("models/bots/skeleton_sniper/skeleton_sniper.mdl")
			elseif not ply:IsHL2() and ply:GetPlayerClass() == "heavy" and ply:GetInfoNum("tf_yeti", 0) == 1 then
				ply:SetModel("models/player/yeti.mdl")
			elseif not ply:IsHL2() and ply:GetPlayerClass() == "demoman" and ply:GetInfoNum("tf_hhh", 0) == 1 then
				ply:SetModel("models/bots/small_headless_hatman.mdl")
			elseif not ply:IsHL2() and ply:GetPlayerClass() == "heavy" and ply:GetInfoNum("civ2_bootleg_charger", 0) == 1 then
				ply:SetModel("models/infected/not_a_charger.mdl")
			end
			if not ply:IsHL2() and ply:GetInfoNum("tf_mvm_giant_voodoo", 0) == 1 then
				ply:SetModelScale(1.75)
				if ply:GetPlayerClass() == "scout" then
					timer.Create("GiantRobotSpeed", 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed") return end
						if ply:GetInfoNum("tf_mvm_giant_voodoo", 0) == 0 then timer.Stop("GiantRobotSpeed") return end
						ply:SetWalkSpeed(500)
						ply:SetMaxSpeed(500)
						ply:SetRunSpeed(500)
					end)
					ply:SetModel("models/lazy_zombies_v2/scout.mdl")
				elseif ply:GetPlayerClass() == "soldier" then
					timer.Create("GiantRobotSpeed", 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed") return end
						if ply:GetInfoNum("tf_mvm_giant_voodoo", 0) == 0 then timer.Stop("GiantRobotSpeed") return end
						ply:SetWalkSpeed(150)
						ply:SetMaxSpeed(150)
						ply:SetRunSpeed(150)
					end)
					ply:SetModel("models/lazy_zombies_v2/soldier.mdl")
				elseif ply:GetPlayerClass() == "demoman" then
					timer.Create("GiantRobotSpeed", 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed") return end
						if ply:GetInfoNum("tf_mvm_giant_voodoo", 0) == 0 then timer.Stop("GiantRobotSpeed") return end
						ply:SetWalkSpeed(150)
						ply:SetMaxSpeed(150)
						ply:SetRunSpeed(150)
					end)
					ply:SetModel("models/lazy_zombies_v2/demo.mdl")
				elseif ply:GetPlayerClass() == "heavy" then
					timer.Create("GiantRobotSpeed", 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed") return end
						if ply:GetInfoNum("tf_mvm_giant_voodoo", 0) == 0 then timer.Stop("GiantRobotSpeed") return end
						ply:SetWalkSpeed(150)
						ply:SetMaxSpeed(150)
						ply:SetRunSpeed(150)
					end)
					ply:SetModel("models/lazy_zombies_v2/heavy.mdl")
				elseif ply:GetPlayerClass() == "pyro" then
					timer.Create("GiantRobotSpeed", 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed") return end
						if ply:GetInfoNum("tf_mvm_giant_voodoo", 0) == 0 then timer.Stop("GiantRobotSpeed") return end
						ply:SetWalkSpeed(150)
						ply:SetMaxSpeed(150)
						ply:SetRunSpeed(150)
					end)
					ply:SetModel("models/lazy_zombies_v2/pyro.mdl")
				elseif ply:GetPlayerClass() == "medic" then
					timer.Create("GiantRobotSpeed", 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed") return end
						if ply:GetInfoNum("tf_mvm_giant_voodoo", 0) == 0 then timer.Stop("GiantRobotSpeed") return end
						ply:SetWalkSpeed(150)
						ply:SetMaxSpeed(150)
						ply:SetRunSpeed(150)
					end)
					ply:SetModel("models/lazy_zombies_v2/medic.mdl")
				elseif ply:GetPlayerClass() == "engineer" then
					timer.Create("GiantRobotSpeed", 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed") return end
						if ply:GetInfoNum("tf_mvm_giant_voodoo", 0) == 0 then timer.Stop("GiantRobotSpeed") return end
						ply:SetWalkSpeed(150)
						ply:SetMaxSpeed(150)
						ply:SetRunSpeed(150)
					end)
					ply:SetModel("models/lazy_zombies_v2/engineer.mdl")
				elseif ply:GetPlayerClass() == "sniper" then
					timer.Create("GiantRobotSpeed", 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed") return end
						if ply:GetInfoNum("tf_mvm_giant_voodoo", 0) == 0 then timer.Stop("GiantRobotSpeed") return end
						ply:SetWalkSpeed(150)
						ply:SetMaxSpeed(150)
						ply:SetRunSpeed(150)
					end)
					ply:SetModel("models/lazy_zombies_v2/sniper.mdl")
				elseif ply:GetPlayerClass() == "spy" then
					timer.Create("GiantRobotSpeed", 0.01, 0, function()
						if not ply:Alive() then timer.Stop("GiantRobotSpeed") return end
						if ply:GetInfoNum("tf_mvm_giant_voodoo", 0) == 0 then timer.Stop("GiantRobotSpeed") return end
						ply:SetWalkSpeed(150)
						ply:SetMaxSpeed(150)
						ply:SetRunSpeed(150)
					end) 
					ply:SetModel("models/lazy_zombies_v2/spy.mdl")
				end
			end
			if not ply:IsHL2() and ply:GetInfoNum("tf_mvm_voodoo", 0) == 1 then
				if ply:GetPlayerClass() == "scout" then
					ply:SetModel("models/lazy_zombies_v2/scout.mdl")
				elseif ply:GetPlayerClass() == "soldier" then
					ply:SetModel("models/lazy_zombies_v2/soldier.mdl")
				elseif ply:GetPlayerClass() == "demoman" then
					ply:SetModel("models/lazy_zombies_v2/demo.mdl")
				elseif ply:GetPlayerClass() == "heavy" then
					ply:SetModel("models/lazy_zombies_v2/heavy.mdl")
				elseif ply:GetPlayerClass() == "pyro" then
					ply:SetModel("models/lazy_zombies_v2/pyro.mdl")
				elseif ply:GetPlayerClass() == "medic" then
					ply:SetModel("models/lazy_zombies_v2/medic.mdl")
				elseif ply:GetPlayerClass() == "engineer" then
					ply:SetModel("models/lazy_zombies_v2/engineer.mdl")
				elseif ply:GetPlayerClass() == "sniper" then
					ply:SetModel("models/lazy_zombies_v2/sniper.mdl")
				elseif ply:GetPlayerClass() == "spy" then
					ply:SetModel("models/lazy_zombies_v2/spy.mdl")
				end
			end
		end
	end)
end 

concommand.Add("check_save_table_for_entity", function(ply)
	PrintTable(ply:GetEyeTrace().Entity:GetSaveTable())
end)
hook.Add( "OnEntityWaterLevelChanged", "UnderwaterAmbience", function(ent,old,new)
	if (new > 0 and !ent:IsFlagSet(FL_INWATER)) then
		if (ent:IsPlayer()) then
			ent:EmitSound("Physics.WaterSplash")
		end
	end
	if (new > 2) then
		if (ent:IsPlayer()) then
			ent:SendLua('LocalPlayer():StopSound("Player.AmbientUnderWater")')
			ent:SetDSP(14)
			ent:SendLua('LocalPlayer():EmitSound("Player.AmbientUnderWater")')
			timer.Create("Drown"..ent:EntIndex(), 12, 1, function()
				if (ent:WaterLevel() > 2) then
					ent.IsDrowning = true
					ent:EmitSound("Player.DrownContinue")
					ent:TakeDamage(8)
					ent:ScreenFade( SCREENFADE.IN, Color( 0, 0, 100, 128 ), 1, 0 )
					timer.Create("DrownContinue"..ent:EntIndex(), 1, 0, function()
						if (!ent:Alive()) then
							ent.IsDrowning = false
						end
						ent:TakeDamage(8)
						ent:EmitSound("Player.DrownContinue")
						ent:ScreenFade( SCREENFADE.IN, Color( 0, 0, 100, 128 ), 1, 0 )
					end)
				end
			end)
		end
	else
		if (ent:IsPlayer()) then
			if (new < 3) then
				if (ent.IsDrowning) then
					timer.Stop("Drown"..ent:EntIndex())
					timer.Stop("DrownContinue"..ent:EntIndex())
					ent:SetHealth(ent:Health() + ent:GetMaxHealth() * 0.5)
					ent:EmitSound("Player.DrownStart")
					ent.IsDrowning = false
				end
				ParticleEffectAttach("water_playeremerge", PATTACH_ABSORIGIN_FOLLOW, ent, 0)
			end
			ent:SetDSP(0)
			ent:SendLua('LocalPlayer():StopSound("Player.AmbientUnderWater")')
		end
	end
end)
hook.Add( "PlayerSpawn", "PlayerGiantRoBotSpawn", PlayerGiantBotSpawn)


concommand.Add( "random_team", function( ply, cmd, args )

	local nDiffBetweenTeams = 0;
	local m_iLightestTeam = 0;
	local m_iHeaviestTeam = 0;
	local iMostPlayers = 0;
	local iLeastPlayers = game.MaxPlayers() + 1;
	local i = 1; 
	for k,v in ipairs(team.GetAllTeams()) do
			local iNumPlayers = team.NumPlayers(v);

			if ( iNumPlayers < iLeastPlayers ) then
				iLeastPlayers = iNumPlayers;
				m_iLightestTeam = k; 
			end

			if ( iNumPlayers > iMostPlayers ) then
				iMostPlayers = iNumPlayers;
				m_iHeaviestTeam = k; 
			end
	end 

	nDiffBetweenTeams = ( iMostPlayers - iLeastPlayers );
	if (team.NumPlayers(1) > team.NumPlayers(2)) then
		ply:SetTeam(2)	
	elseif (team.NumPlayers(1) < team.NumPlayers(2)) then
		ply:SetTeam(1)	
	else
		ply:SetTeam(table.Random({TEAM_RED,TEAM_BLU}))	
	end
	if ply:Alive() and ply:Team() != TEAM_SPECTATOR then ply:Kill() end 

end)
concommand.Add( "changeteam", function( pl, cmd, args )
	--if ( tonumber( args[ 1 ] ) >= 5 and args[ 1 ] ~= 1002 ) then return end
	if ( tonumber( args[ 1 ] ) == 0 or tonumber( args[ 1 ] ) < 0 or tonumber( args[ 1 ] ) > TEAM_FRIENDLY) then pl:ChatPrint("Invalid Team!") return end
	if ( !GetConVar("tf_competitive"):GetBool() and pl:Team() == tonumber( args[ 1 ] ) ) then pl:PrintMessage(HUD_PRINTTALK,"You are already in this team!") return false end
	if ( GetConVar("tf_competitive"):GetBool() and tonumber( args[ 1 ] ) == 4 ) then pl:ChatPrint("Competitive mode is on!") return end
	if ( string.find(game.GetMap(), "mvm_") and tonumber( args[ 1 ] ) == 6 ) then pl:ChatPrint("Friendly Team is disabled!") return end
	if ( string.find(game.GetMap(), "mvm_") and !pl:IsAdmin() and tonumber( args[ 1 ] ) == 5 ) then pl:ChatPrint("Neutral Team is disabled!") return end
	if ( GetConVar("tf_competitive"):GetBool() and tonumber( args[ 1 ] ) == 6 ) then pl:ChatPrint("Friendly Team is disabled!") return end
	if ( GetConVar("tf_competitive"):GetBool() and tonumber( args[ 1 ] ) == 5 ) then pl:ChatPrint("Neutral Team is disabled!") return end
	if ( GetConVar("tf_competitive"):GetBool() and tonumber( args[ 1 ] ) == 4 ) then pl:ChatPrint("Green Team is disabled!") return end
	if ( GetConVar("tf_competitive"):GetBool() and tonumber( args[ 1 ] ) == 3 ) then pl:ChatPrint("Yellow Team is disabled!") return end

	if ( GetConVar("tf_competitive"):GetBool() ) then
		local theteam = tonumber( args[ 1 ] )
		local nDiffBetweenTeams = 0;
		local m_iLightestTeam = 0;
		local m_iHeaviestTeam = 0;
		local iMostPlayers = 0;
		local iLeastPlayers = game.MaxPlayers() + 1;
		local i = 1; 
		for k,v in ipairs(team.GetAllTeams()) do
				local iNumPlayers = team.NumPlayers(v);

				if ( iNumPlayers < iLeastPlayers ) then
					iLeastPlayers = iNumPlayers;
					m_iLightestTeam = k; 
				end

				if ( iNumPlayers > iMostPlayers ) then
					iMostPlayers = iNumPlayers;
					m_iHeaviestTeam = k; 
				end
		end 

		nDiffBetweenTeams = ( iMostPlayers - iLeastPlayers );
		if (team.NumPlayers(1) > team.NumPlayers(2) and theteam == 1) then
			pl:PrintMessage(HUD_PRINTTALK,"The team is full. Press the dot key to change teams again.")
			return false
		elseif (team.NumPlayers(1) < team.NumPlayers(2) and theteam == 2) then
			pl:PrintMessage(HUD_PRINTTALK,"The team is full. Press the dot key to change teams again.")
			return false
		else
			if (pl:Team() == theteam) then
				pl:PrintMessage(HUD_PRINTTALK,"You are already in this team!")
				return false
			else
				pl:SetTeam( tonumber( args[ 1 ] ) )  
			end
		end
	else
		pl:SetTeam( tonumber( args[ 1 ] ) )  
	end
	pl:ConCommand("tf_changeclass")
	timer.Simple(0.3, function() if !IsValid(pl) then return end PrintMessage(HUD_PRINTTALK, 'Player '.. pl:Nick() ..	' joined team '.. team.GetName(pl:Team()) ) end) 
	if pl:Alive() and pl:Team() != TEAM_SPECTATOR then pl:Kill() end 
	if pl:Alive() and pl:Team() == TEAM_SPECTATOR then pl:Spawn() end 
end )


local SpawnableItems = {
	"item_ammopack_small",
	"item_ammopack_medium",
	"item_ammopack_full",
	"item_healthkit_small",
	"item_healthkit_medium",
	"item_healthkit_full",
	"item_duck",
}

hook.Add("InitPostEntity", "TF_InitSpawnables", function()
	local base = scripted_ents.GetStored("item_base")
	if not base or not base.t or not base.t.SpawnFunction then return end
	
	for _,v in ipairs(SpawnableItems) do
		local ent = scripted_ents.GetStored(v)
		if ent and ent.t then
			ent.t.SpawnFunction = base.t.SpawnFunction
		end
	end
end) 
local function GetFirstObserverPoint()
	local tbl = {}
	for k,v in ipairs(ents.FindByClass("info_observer_point")) do
		if (IsValid(v)) then
			table.insert(tbl, v)
		end
	end
	return table.Random(tbl)
end
function GM:PlayerInitialSpawn(ply)
	if (!ply:IsBot()) then
		ply:SetTeam(TEAM_SPECTATOR)	
		ply:Spectate(OBS_MODE_IN_EYE)
		if (GetFirstObserverPoint() != nil) then
			ply:SpectateEntity(GetFirstObserverPoint())
		end
	else
	
		local nDiffBetweenTeams = 0;
		local m_iLightestTeam = 0;
		local m_iHeaviestTeam = 0;
		local iMostPlayers = 0;
		local iLeastPlayers = game.MaxPlayers() + 1;
		local i = 1; 
		for k,v in ipairs(team.GetAllTeams()) do
				local iNumPlayers = team.NumPlayers(v);

				if ( iNumPlayers < iLeastPlayers ) then
					iLeastPlayers = iNumPlayers;
					m_iLightestTeam = k; 
				end

				if ( iNumPlayers > iMostPlayers ) then
					iMostPlayers = iNumPlayers;
					m_iHeaviestTeam = k; 
				end
		end 

		nDiffBetweenTeams = ( iMostPlayers - iLeastPlayers );
		if (team.NumPlayers(1) > team.NumPlayers(2)) then
			ply:SetTeam(2)	
		elseif (team.NumPlayers(1) < team.NumPlayers(2)) then
			ply:SetTeam(1)	
		else
			ply:SetTeam(table.Random({TEAM_RED,TEAM_BLU}))	
		end
		
	end
	-- Wait until InitPostEntity has been called
	if not self.PostEntityDone then
		timer.Simple(0.05, function() self:PlayerInitialSpawn(ply) end)
		return
	end
	
	-- Msg("PlayerInitialSpawn : "..ply:GetName().." "..tostring(self.Landmark).."\n")
	if self.Landmark then--and self.Landmark:IsValidMap() then
		--self.Landmark:LoadPlayerData(ply)
	end
end

function GM:OnPlayerChangedTeam(ply, oldteam, newteam)
	if newteam == TEAM_SPECTATOR then
		local Pos = ply:EyePos()
		ply:Spawn()
		ply:SetPos( Pos )
	elseif oldteam == TEAM_SPECTATOR then
		ply:Spawn()
	end
 
	PrintMessage(HUD_PRINTTALK, Format("%s joined '%s'", ply:Nick(), team.GetName(newteam)))
	
	self:ClearDominations(ply)
	self:UpdateEntityRelationship(ply)
end

local function CanSpawn(ply) if (ply:Team() == TEAM_SPECTATOR && !ply:IsAdmin()) or GetConVar("tf_competitive"):GetBool() && !ply:IsAdmin() then return false end return true end

function GM:CanPlayerSuicide(ply)
	if ply:Team() == TEAM_SPECTATOR then return false end
	return true
end

function GM:PlayerSpawnSWEP(ply)
	return CanSpawn(ply)
end
hook.Add("CanArmDupe","ArmDupe?",function(ply)
	return CanSpawn(ply)
end)

function GM:PlayerSpawnVehicle(ply)
	return CanSpawn(ply)
end

function GM:PlayerSpawnNPC(ply)
	return CanSpawn(ply)
end

function GM:PlayerSpawnSENT(ply)
	return CanSpawn(ply)
end

function GM:PlayerSpawnObject(ply)
	return CanSpawn(ply)
end

function GM:PlayerSpawnProp(ply)
	return CanSpawn(ply)
end

function GM:PlayerSpawnRagdoll(ply)
	return CanSpawn(ply)
end

function GM:PlayerSpawnEffect(ply)
	return CanSpawn(ply)
end

function RandomWeapon(ply, wepslot)
	local weps = tf_items.ReturnItems()
	local validweapons = {}
	for k, v in pairs(weps) do
		if v and istable(v) and isstring(wepslot) and v["name"] and v["item_slot"] == wepslot and !string.StartWith(v["name"], "Australium") and v["craft_class"] == "weapon" then
			PrintTable(v)
			table.insert(validweapons, v["name"])
		end
	end

	local wep = table.Random(validweapons)

	ply:PrintMessage(HUD_PRINTTALK, "You were given " .. wep .. "!")
	ply:EquipInLoadout(wep)
end

-- by hl2 campaign https:--github.com/daunknownfox2010/half-life-2-campaign/blob/master/gamemode/init.lua but edited
function GM:EntityKeyValue( ent, key, value )

	if ( ( ent:GetClass() == "trigger_changelevel" ) && ( key == "map" ) ) then
	
		ent.map = value
	
	end

	if ( ( ent:GetClass() == "npc_combine_s" ) && ( key == "additionalequipment" ) && ( value == "weapon_shotgun" ) ) then
	
		ent:SetSkin( 1 )
	 
	end

end

concommand.Add("changelevel2", function(ply,com,arg) 
    if ply:IsValid() then return end --only let server console access this command
    RunConsoleCommand("changelevel", arg[1])
end)


if ( file.Exists( "teamfortress/gamemode/maps/"..game.GetMap()..".lua", "LUA" ) ) then

	include( "maps/"..game.GetMap()..".lua" )

end
  
-- Called by GoToNextLevel
function GM:GrabAndSwitch()

	changingLevel = true

	game.ConsoleCommand( "changelevel "..NEXT_MAP.."\n" )
 
end


hook.Add( "PlayerButtonDown", "PlayerButtonDownTF", function( pl, key )
	if key == KEY_G then 
		if (pl:GetPlayerClass() == "sentrybuster") then
			pl:ConCommand("tf_sentrybuster_explode")         
		else
			for k,v in ipairs(ents.FindInSphere(pl:GetPos(), 300)) do
				if (v:IsPlayer() and v:GetNWBool("Congaing") and !pl:GetNWBool("Congaing",false)) then
					pl:ConCommand("tf_taunt_conga_start")
					return
				elseif (v:IsPlayer() and v:GetNWBool("Russian") and !pl:GetNWBool("Russian",false)) then
					pl:ConCommand("tf_taunt_russian_start")
					return
				end
			end
			timer.Simple(0.05, function()
			
				if (pl:GetNWBool("Congaing",false)) then
					pl:ConCommand("tf_taunt_conga_stop")
					return
				end
				if (pl:GetNWBool("Russian",false)) then
					pl:ConCommand("tf_taunt_russian_stop")
					return
				end

				if (pl:GetActiveWeapon():GetClass() == "weapon_physcannon") then
					if (pl:GetPlayerClass() == "scout") then
						pl:ConCommand("tf_taunt_come_and_get_me")
					else
						pl:ConCommand("tf_taunt_laugh")
					end
				elseif (pl:GetActiveWeapon():GetClass() == "weapon_physgun") then
					pl:ConCommand("tf_taunt_directors_vision")
				else
					pl:ConCommand("tf_taunt "..pl:GetActiveWeapon():GetSlot() + 1)         
				end
				print("taunt")
				print(pl:GetWeapon(pl:GetActiveWeapon():GetClass()):GetSlot() + 1)

			end)
		end
	end
	if key == KEY_SPACE then
		if (!pl:Alive() and pl:GetObserverMode() != OBS_MODE_DEATHCAM and pl:Team() != TEAM_SPECTATOR and !pl.IsSpectating) then
			pl:SetObserverMode(OBS_MODE_CHASE)
			pl:ConCommand("tf_spectate_respawn")
		end
	end
	if key == KEY_H and GetConVar("tf_grapplinghook_enable"):GetBool() then
		pl:SelectWeapon("tf_weapon_grapplinghook")
		timer.Simple(0.1, function()
			if (pl:GetActiveWeapon():GetClass() == "tf_weapon_grapplinghook") then
				pl:ConCommand("+attack") 
			end
		end)
	end
	if key == KEY_Z then 
		pl:ConCommand("voice_menu_1") 
	end
	if pl:GetPlayerClass() == "fastzombie" then
		if key == KEY_SPACE and pl:OnGround() then 
			pl:EmitSound("NPC_FastZombie.Scream") 
			pl:SetJumpPower(600) 
		end
	end
	if key == KEY_X then  
		pl:ConCommand("voice_menu_2")   
	end
	if key == KEY_L then
		pl:ConCommand("gmod_undo")   
	end
	if key == KEY_C then
		pl:ConCommand("voice_menu_3") 
	end
	if key == KEY_COMMA then
		pl:ConCommand("tf_changeclass")
	end
	if key == KEY_M then
		pl:ConCommand("gm_showspare2")
	end  	
	if key == KEY_N then
		pl:ConCommand("gm_showspare1")
	end
	if key == KEY_PERIOD then
		pl:ConCommand("tf_changeteam")
	end
		
end)

hook.Add( "PlayerButtonUp", "PlayerButtonUpTF", function( pl, key )
	if key == KEY_H and GetConVar("tf_grapplinghook_enable"):GetBool() then
		if (pl:GetActiveWeapon():GetClass() == "tf_weapon_grapplinghook") then
			pl:GetActiveWeapon():EndAttack(true)
		end
		pl:ConCommand("-attack")
		pl:ConCommand("lastinv") 
		pl:StopSound("Grappling")
	end  
end)	 
 
  
concommand.Add("changeclass", function(pl, cmd, args)
	if SERVER then
		if pl:Team()==TEAM_SPECTATOR then return end
		if pl:GetObserverMode() ~= OBS_MODE_NONE then pl:Spectate(OBS_MODE_NONE) end
		if (!pl:Alive()) then 
			timer.Simple(0.1, function() 
				pl:Spawn() 
			end) 
		end
		if pl:Alive() and GetConVar("tf_kill_on_change_class"):GetInt() ~= 0 then pl:Kill() end	
		--if GetConVar("tf_kill_on_change_class"):GetInt() ~= 0 then pl:SetPlayerClass("gmodplayer") end
		pl:SetPlayerClass(args[1])
	end
end, function() return GAMEMODE.PlayerClassesAutoComplete end)

concommand.Add("join_class", function(pl, cmd, args)
	if SERVER then
		if pl:Team()==TEAM_SPECTATOR then return end
		if pl:GetObserverMode() ~= OBS_MODE_NONE then pl:Spectate(OBS_MODE_NONE) end
		if pl:Alive() and GetConVar("tf_kill_on_change_class"):GetInt() ~= 0 then pl:Kill() end	
		--if GetConVar("tf_kill_on_change_class"):GetInt() ~= 0 then pl:SetPlayerClass("gmodplayer") end
		pl:SetPlayerClass(args[1])
	end
end, function() return GAMEMODE.PlayerClassesAutoComplete end)	

function RandomWeapon2(ply, wepslot)
	local weps = tf_items.ReturnItems()
	local class = ply:GetPlayerClass()
	local validweapons = {}
	for k, v in pairs(weps) do
		if v and istable(v) and isstring(wepslot) and v["name"] and v["item_slot"] == wepslot and v["used_by_classes"] and v["used_by_classes"][class] and !string.StartWith(v["name"], "Australium") and v["craft_class"] == "weapon" then
			table.insert(validweapons, v["name"])
		end 
	end

	local wep = table.Random(validweapons)
	ply:EquipInLoadout(wep)
end 

function RandomCosmetic(ply, wepslot)
	local weps = tf_items.ReturnItems()
	local class = ply:GetPlayerClass()
	local validweapons = {}
	for k, v in pairs(weps) do
		if v and istable(v) and isstring(wepslot) and v["name"] and v["item_slot"] == wepslot and v["used_by_classes"] and v["used_by_classes"][class] and !string.StartWith(v["name"], "Australium") and (v["item_class"] == "tf_wearable" || !IsValid(v["item_class"]) ) then
			table.insert(validweapons, v["name"])
		end
	end

	local wep = table.Random(validweapons)
	ply:EquipInLoadout(wep)
end

function RandomWeapon(ply, wepslot)
	local weps = tf_items.ReturnItems()
	local validweapons = {}
	for k, v in pairs(weps) do
		if v and istable(v) and isstring(wepslot) and v["name"] and v["item_slot"] == wepslot and !string.StartWith(v["name"], "Australium") and v["craft_class"] == "weapon" then
			PrintTable(v)
			table.insert(validweapons, v["name"])
		end 
	end

	local wep = table.Random(validweapons)  

	ply:PrintMessage(HUD_PRINTTALK, "You were given " .. wep .. "!")
	ply:ConCommand("giveitem " .. wep)
end
 
concommand.Add("randomweapon", function(ply, _, args)
	if !args[1] then
		local random = math.random(1, 3)
		if random == 1 then
			RandomWeapon(ply, "primary")
		elseif random == 2 then
			RandomWeapon(ply, "secondary")
		elseif random == 3 then
			RandomWeapon(ply, "melee")
		end 
	else
		RandomWeapon(ply, args[1])
	end
end)
  
function GM:PlayerSpawn(ply)
	--[[
	if (string.StartWith(game.GetMap(),"c1m") or string.StartWith(game.GetMap(),"c2m") or string.StartWith(game.GetMap(),"c3m") or string.StartWith(game.GetMap(),"c4m") 
	or string.StartWith(game.GetMap(),"c5m") or string.StartWith(game.GetMap(),"c6m") or string.StartWith(game.GetMap(),"c7m") or string.StartWith(game.GetMap(),"c8m")
	or string.StartWith(game.GetMap(),"c9m") or string.StartWith(game.GetMap(),"c10m") or string.StartWith(game.GetMap(),"c11m") or string.StartWith(game.GetMap(),"c12m")
	or string.StartWith(game.GetMap(),"c13m") or string.StartWith(game.GetMap(),"c14m")) then
		if (!IsValid(GAMEMODE.Director)) then
			local director = ents.Create("ai_director")
			director:SetPos(ply:GetPos())
			director:SetAngles(ply:EyeAngles())
			director:Spawn()
			director:Activate()
			GAMEMODE.Director = director
		end
	end]]
	for k,v in ipairs(ents.GetAll()) do
		if (v:IsNPC()) then
			GAMEMODE:UpdateEntityRelationship(v)
		end
	end
	-- engage a rare chance of getting the hacker bot's fake aim (derp)
	if (ply:IsBot() and math.random(1,1000) == 1) then
		ply:SetNWBool("IsDerpAim",true)
	else
		ply:SetNWBool("IsDerpAim",false)
	end
	for k,v in ipairs(player.GetAll()) do
		if (player.GetCount() == 1) then

			if (!GAMEMODE.round_active and ply:Team() != TEAM_SPECTATOR) then
				RunConsoleCommand("gmod_admin_cleanup")
				GAMEMODE.round_active = true
				timer.Simple(0.1, function()
						local roundtimer = ents.Create("team_round_timer")
						roundtimer.Properties = {
							start_paused = 0,
							timer_length = 15,
							max_length = 15,
							auto_countdown = 1, 
							show_in_hud = 1,
							setup_length = 0,
						}
						roundtimer:Spawn()
						roundtimer:Activate()
						timer.Simple(1, function()
							roundtimer:SetAndResumeTimer2(15,false)
							roundtimer.WaitingForPlayers = true
						end)
					
					for k,v in ipairs(player.GetAll()) do
						v:Spawn()
						v:SetNWBool("Taunting",true)
						timer.Create("SlowGuydown"..v:EntIndex(), 0.1, 48, function()
							v:SetWalkSpeed(1)
							v:SetRunSpeed(1)
						end)
						timer.Simple(5, function()
							v:SetNWBool("Taunting",false)
							v:ResetClassSpeed()
						end)
					end
					timer.Stop("WaitingForPlayers",18,1)
					timer.Create("WaitingForPlayers",18,1,function()
						timer.Simple(0.1, function()
						
							GAMEMODE.round_active = true
							RunConsoleCommand("gmod_admin_cleanup") 
							for k,v in ipairs(player.GetAll()) do
								v:Spawn()
								v:SetNWBool("Taunting",true)
								timer.Create("SlowGuydown"..v:EntIndex(), 0.1, 48, function()
									v:SetWalkSpeed(1)
									v:SetRunSpeed(1)
								end) 
								timer.Simple(5, function()
									v:SetNWBool("Taunting",false)
									v:ResetClassSpeed()
									v:Speak("TLK_ROUND_START")
								end)
							end
		  
						end)
					end) 
				end)  
			end 

		end
	end
	ply:PrecacheGibs()
	
	ply:DoAnimationEvent(ACT_MP_ATTACK_STAND_POSTFIRE, true)
	--ply:ScreenFade( SCREENFADE.IN, Color( 0, 0, 0, 255 ), 0.01, 0 ) 

	-- Fix the blackness glitch in TSP maps 
	if (game.GetMap() == "map1") then
		for k,v in ipairs(ents.GetAll()) do
			if (v:GetName() == "cam_black") then
				v:Fire("Disable","",0)
			end
		end 
	end
	ply:SetGravity(0) 
	if ply.CPPos and ply.CPAng then
		ply:SetPos(ply.CPPos) 
		ply:SetEyeAngles(ply.CPAng)
	end 
	ply.anim_Deployed = false
	if (ply:Team() != TEAM_NEUTRAL && ply:Team() != TEAM_FRIENDLY) then
		ply:SetNoCollideWithTeammates(true)
	else
		ply:SetNoCollideWithTeammates(false)
	end
	if string.find(game.GetMap(), "mvm_") then
		timer.Simple(0.4, function()
			for k,v in ipairs(ents.FindByClass("obj_teleporter")) do
				if GAMEMODE:EntityTeam(v) == TEAM_BLU then
					if ply:Team() == TEAM_BLU then
						ply:SetPos(v:GetPos())
						v:Teleport(ply)
						v:EmitSound("MVM.Robot_Teleporter_Deliver")
					end
				end
			end
		end)
	end 	 
	if ply:GetPlayerClass() == "engineer" and ply.TFBot then 
		timer.Simple(0.1, function()
			ply:SelectWeapon("tf_weapon_wrench")
		end) 
		timer.Simple(0.8, function() 
			ply:Build(2,0)
		end)
	end
	timer.Simple(0.5, function()
		if ply:GetPlayerClass() == "engineer" and (string.find(ply:GetModel(),"/bot_") or (bot.TFBot and bot:Team() == TEAM_BLU and string.find(game.GetMap(),"mvm_"))) then 
			ply:EmitSound("MVM.Robot_Engineer_Spawn")
			
			umsg.Start("TF_PlayGlobalSound")
				umsg.String("Announcer.MVM_First_Engineer_Teleport_Spawned")
			umsg.End()
		end
	end)
	if (ply:IsHL2()) then
		ply:ShouldDropWeapon(true)
	else
		ply:ShouldDropWeapon(false)
	end
	--[[ply:SetNWBool("ShouldDropBurningRagdoll", false)
	ply:SetNWBool("ShouldDropDecapitatedRagdoll", false)
	ply:SetNWBool("DeathByHeadshot", false)]]
	ply:ResetDeathFlags()
	ply:SetNoCollideWithTeammates( true ) 
	ply.LastWeapon = nil
	if GetConVar("tf_crossover_mode"):GetBool() then
		if ply:IsHL2() then
			if ply:Team() == TEAM_RED then
				ply:SetPlayerClass(table.Random({"bill","louis","zoey","francis","nick","coach"}))
			else
				ply:SetPlayerClass(table.Random({"charger","hunter","boomer","smoker","tank"}))
			end
		elseif !ply:IsHL2() then
			if ply:IsL4D() then return end
			if ply:Team() == TEAM_RED then
				ply:SetPlayerClass(table.Random({"bill","louis","zoey","francis","nick","coach"}))
			else
				ply:SetPlayerClass(table.Random({"charger","hunter","boomer","smoker","tank"})) 
			end
		end
	end
	self:ResetKills(ply)
	self:ResetDamageCounter(ply)
	self:ResetCooperations(ply)
	self:StopCritBoost(ply)
	for k,v in ipairs(ents.FindByClass("trigger_weapon_strip")) do
		if IsValid(v) then
			v:Fire("Kill", "", 0.1)
		end
	end
	for k,v in ipairs(ents.FindByClass("player_weaponstrip")) do
		if IsValid(v) then
			v:Fire("Kill", "", 0.1)
		end
	end
	ply:UnSpectate()
	-- Reinitialize class
	if ply:GetPlayerClass()=="" and ply:Team() != TEAM_SPECTATOR then
		ply:ConCommand("tf_changeclass")
		ply:SetPlayerClass("gmodplayer")
		--ply:Spectate(OBS_MODE_FIXED)
		--ply:StripWeapons()
	--[[elseif ply:GetPlayerClass()=="sniper" then -- dumb hack wtf??
		ply:SetPlayerClass("scout")
		timer.Simple(0.1, function()
			if IsValid(ply) then
				ply:SetPlayerClass("sniper")
			end
		end)
		if ply:GetObserverMode() ~= OBS_MODE_NONE then
			ply:UnSpectate()
		end]]	
	elseif ply:GetPlayerClass()=="" and ply:Team() == TEAM_SPECTATOR then
		ply:ConCommand("tf_changeteam")
		ply:ConCommand("tf_spectate","2")
		--ply:Spectate(OBS_MODE_FIXED)
		--ply:StripWeapons()
	--[[elseif ply:GetPlayerClass()=="sniper" then -- dumb hack wtf??
		ply:SetPlayerClass("scout")
		timer.Simple(0.1, function()
			if IsValid(ply) then
				ply:SetPlayerClass("sniper")
			end
		end)
		if ply:GetObserverMode() ~= OBS_MODE_NONE then
			ply:UnSpectate()
		end]]	
	elseif ply:GetPlayerClass()=="sniper" then
		ply:SetPlayerClass("scout")
		ply:SetPlayerClass("sniper")
		timer.Simple(0.1, function()

			if ply:GetInfoNum("tf_skeleton", 0) == 1 then
				ply:SetModel("models/bots/skeleton_sniper/skeleton_sniper.mdl")
			end
			ply:SetPlayerClass("sniper")
		end)
	elseif ply:GetPlayerClass()=="heavy" then
		timer.Simple(0.1, function()

			if ply:GetInfoNum("tf_yeti", 0) == 1 then
				ply:SetModel("models/player/yeti.mdl")
			end
		end)
	end

	timer.Simple(0.02, function() -- god i'm such a timer whore
		-- are you sure about that
		ply:SetPlayerClass(ply:GetPlayerClass())
		
	end)
	timer.Simple(0.3, function()
	
		local v = ply
		if (v:Alive()) then
			if (v:IsHL2()) then		  
				v:SetViewOffset(Vector(0,0,64 * v:GetModelScale()))
				v:SetViewOffsetDucked(Vector(0, 0, 28 * v:GetModelScale()))
			else
				if (v.playerclass == "Scout") then
					v:SetViewOffset(Vector(0, 0, 65 * v:GetModelScale()))
					v:SetViewOffsetDucked(Vector(0, 0, 65 * (0.5 * v:GetModelScale())))
				elseif (v.playerclass == "Soldier") then
					v:SetViewOffset(Vector(0, 0, 68 * v:GetModelScale()))
					v:SetViewOffsetDucked(Vector(0, 0, 68 * (0.5 * v:GetModelScale())))
				elseif (v.playerclass == "Pyro") then
					v:SetViewOffset(Vector(0, 0, 68 * v:GetModelScale()))
					v:SetViewOffsetDucked(Vector(0, 0, 68 * (0.5 * v:GetModelScale())))
				elseif (v.playerclass == "Demoman") then
					v:SetViewOffset(Vector(0, 0, 68 * v:GetModelScale()))
					v:SetViewOffsetDucked(Vector(0, 0, 68 * (0.5 * v:GetModelScale())))
				elseif (v.playerclass == "Heavy") then
					v:SetViewOffset(Vector(0, 0, 75 * v:GetModelScale()))
					v:SetViewOffsetDucked(Vector(0, 0, 75 * (0.5 * v:GetModelScale())))
				elseif (v.playerclass == "Engineer") then
					v:SetViewOffset(Vector(0, 0, 68 * v:GetModelScale()))
					v:SetViewOffsetDucked(Vector(0, 0, 68 * (0.5 * v:GetModelScale())))
				elseif (v.playerclass == "Medic") then
					v:SetViewOffset(Vector(0, 0, 75 * v:GetModelScale()))
					v:SetViewOffsetDucked(Vector(0, 0, 75 * (0.5 * v:GetModelScale())))
				elseif (v.playerclass == "Sniper") then
					v:SetViewOffset(Vector(0, 0, 75 * v:GetModelScale()))
					v:SetViewOffsetDucked(Vector(0, 0, 75 * (0.5 * v:GetModelScale())))
				elseif (v.playerclass == "Spy") then
					v:SetViewOffset(Vector(0, 0, 75 * v:GetModelScale()))
					v:SetViewOffsetDucked(Vector(0, 0, 75 * (0.5 * v:GetModelScale())))
				else
					v:SetViewOffset(Vector(0, 0, 68 * v:GetModelScale()))
					v:SetViewOffsetDucked(Vector(0, 0, 48 * v:GetModelScale()))
				end
			end
		end
		
	end)
	if ply:GetObserverMode() ~= OBS_MODE_NONE then
		ply:UnSpectate()
	end

	if ply:Team()==TEAM_SPECTATOR then
		GAMEMODE:PlayerSpawnAsSpectator( ply )
	end
	ply:SetupHands()
	
	if ply:IsHL2() then
		ply:EquipSuit()
		ply:AllowFlashlight(true)
	end
	
	if !ply:IsHL2() then
		ply:AllowFlashlight(GetConVar("tf_flashlight"):GetBool())

		if ply:Team()==TEAM_BLU or ply:Team()==TEAM_GREEN then
			ply:SetSkin(1)
		else
			ply:SetSkin(0)
		end

		for k, v in pairs(ents.FindByClass('tf_wearable_item')) do
			if v:GetClass() == 'tf_wearable_item' then
				if v:GetOwner() == ply and string.find(v:GetModel(), "zombie") then
					if ply:Team()==TEAM_BLU then
						ply:SetSkin(5)
					else
						ply:SetSkin(4)
					end
				end
			end
		end
	end
	if (GetConVar("tf_grapplinghook_enable"):GetBool()) then
		ply:ConCommand("giveitem Grappling Hook")
	end
	ply:Speak("TLK_PLAYER_EXPRESSION", true)  
	ply.Warned = false
	
	local playercolorconv = ply:GetInfo("cl_playercolor") 
	local weaponcolorconv = ply:GetInfo("cl_weaponcolor") 
	local playercolor = Vector(string.sub(playercolorconv, 1, 8), string.sub(playercolorconv, 10, 17), string.sub(playercolorconv, 19, 26))
	local weaponcolor = Vector(string.sub(weaponcolorconv, 1, 8), string.sub(weaponcolorconv, 10, 17), string.sub(weaponcolorconv, 19, 26))

	local groups = ply:GetInfo( "cl_playerbodygroups" )
	if ( groups == nil ) then groups = "" end
	local groups = string.Explode( " ", groups )
	ply:SetCustomCollisionCheck(true)
	if (ply:Team() != TEAM_NEUTRAL and ply:Team() != TEAM_FRIENDLY) then

		ply:SetPlayerColor(Vector(team.GetColor(ply:Team()).r / 255,team.GetColor(ply:Team()).g / 255,team.GetColor(ply:Team()).b / 255))
		ply:SetWeaponColor(Vector(team.GetColor(ply:Team()).r / 255,team.GetColor(ply:Team()).g / 255,team.GetColor(ply:Team()).b / 255))
		for k = 0, ply:GetNumBodyGroups() - 1 do
			ply:SetBodygroup( k, tonumber( groups[ k + 1 ] ) or 0 )
		end

	else
		for k = 0, ply:GetNumBodyGroups() - 1 do
			ply:SetBodygroup( k, tonumber( groups[ k + 1 ] ) or 0 )
		end
		ply:SetPlayerColor(playercolor)
		ply:SetWeaponColor(weaponcolor)
	end
	ply:SetAvoidPlayers(true)  
	
	if !ply:IsHL2() then
		timer.Simple(0.1, function()
			
			ply:GiveLoadout()
		
		end)
	end

	timer.Simple(0.3, function()
	
		if (ply:IsBot() and !ply.TFBot) then
			ply:SetPlayerClass(table.Random({"scout","soldier","pyro","demoman","heavy","engineer","medic","sniper","spy"}))
		end
		for k,v in ipairs(team.GetPlayers(TEAM_RED)) do
			if ply:IsMiniBoss() then
				v:Speak("TLK_MVM_GIANT_CALLOUT")
			end
		end

	end)
	umsg.Start("ExitFreezecam", ply)
	umsg.End()

	net.Start("TF_PlayerSpawn")
	net.WriteEntity(ply)
	net.Broadcast()
	ply:SetMaterial("")
	timer.Simple(0.5, function()
		if (ply:IsBot()) then
			if (ply:GetWeapons()[2]:GetClass() == "tf_weapon_lunchbox_drink" or ply:GetWeapons()[1]:GetClass() == "tf_weapon_lunchbox_drink") then

					ply:SelectWeapon("tf_weapon_lunchbox_drink")
					timer.Simple(0.8, function()
						ply:GetActiveWeapon():PrimaryAttack()
						timer.Simple(0.95, function()
							ply:SelectWeapon("tf_weapon_bat")	
						end)
					end)
			end
		end
	end)
end

function GM:PlayerSetHandsModel( ply, ent )
	local simplemodel = player_manager.TranslateToPlayerModelName( ply:GetModel() )
	local info = player_manager.TranslatePlayerHands( simplemodel )
	if (!IsValid(ent)) then return end
	if ( info ) then
		if ply:IsHL2() then
			ent:SetModel( info.model )
			ent:SetSkin( info.skin )
			ent:SetBodyGroups( info.body )
		else
				if (ply.IsL4DZombie and !ply:IsL4D()) then
					local class = ply.playerclass
					if (string.find(class,"demoman")) then
						class = "demo"
					elseif (string.find(class,"Demoman")) then
						class = "demo"
					elseif (string.find(class,"demoknight")) then
						class = "demo"
					end
					ent:SetModel("models/weapons/c_models/c_"..class.."_arms.mdl")
				elseif (ply:GetPlayerClass() == "demoman") then
					if ((IsValid(ply:GetActiveWeapon()) and string.find(ply:GetActiveWeapon():GetClass(),"tf_weapon")) or !IsValid(ply:GetActiveWeapon())) then

						ent:SetModel( "models/weapons/c_models/c_demo_arms.mdl" )

					else
						
						if (file.Exists("models/player/demomanplayer/demonstrationman_hands.mdl", "WORKSHOP")) then
							ent:SetModel( "models/player/demomanplayer/demonstrationman_hands.mdl" )
						else
							ent:SetModel("models/weapons/v_hands.mdl")
						end

					end
				elseif (ply:GetPlayerClass() == "mercenary") then
					if ((IsValid(ply:GetActiveWeapon()) and string.find(ply:GetActiveWeapon():GetClass(),"tf_weapon")) or !IsValid(ply:GetActiveWeapon())) then

						ent:SetModel( "models/weapons/c_models/c_merc_arms.mdl" )

					else
						
						ent:SetModel("models/weapons/v_hands.mdl")

					end
				elseif (ply:GetPlayerClass() == "civilian_") then
					ent:SetModel( "models/weapons/c_models/c_civilian_arms.mdl" )
				elseif (ply:GetPlayerClass() == "civilian") then
					ent:SetModel( "models/weapons/c_models/c_scout_arms.mdl" )
				elseif (ply:GetPlayerClass() == "medicshotgun") then
					ent:SetModel( "models/weapons/c_models/c_medic_arms.mdl" )
				else
					local t = ply:GetPlayerClassTable()
					if (ply:IsL4D()) then
						if (ply:GetPlayerClass() == "charger" or ply:GetPlayerClass() == "jockey" or ply:GetPlayerClass() == "spitter") then
							ent:SetModel( "models/weapons/arms/v_"..ply:GetPlayerClass().."_arms.mdl" )
						else
							local class = ply:GetPlayerClass()
							if (ply:GetPlayerClass() == "tank_l4d") then
								class = "hulk"
							end
							if (string.find(ply:GetModel(),"l4d1")) then
								ent:SetModel( "models/v_models/weapons/v_claw_"..class.."_l4d1.mdl" )
							elseif (string.find(ply:GetModel(),"dlc3")) then
								ent:SetModel( "models/v_models/weapons/v_claw_"..class.."_dlc3.mdl" )
							else
								ent:SetModel( "models/v_models/weapons/v_claw_"..class..".mdl" )
							end
						end
					else 
						
						if ((IsValid(ply:GetActiveWeapon()) and string.find(ply:GetActiveWeapon():GetClass(),"tf_weapon")) or !IsValid(ply:GetActiveWeapon())) then
	
							if (file.Exists("models/weapons/c_models/c_"..ply:GetPlayerClass().."_arms.mdl", "GAME")) then
								ent:SetModel( "models/weapons/c_models/c_"..ply:GetPlayerClass().."_arms.mdl" )
							else
								ent:SetModel( "models/weapons/c_models/c_sniper_arms.mdl" )
							end

						else

							ent:SetModel("models/weapons/v_hands.mdl")

						end
					end
				end
				if (ply:Team() == TEAM_BLU or ply:Team() == TEAM_GREEN) then
					ent:SetSkin( 1 )
				else
					ent:SetSkin( 0 )
				end
		end
	end
end

-- Fixing spawning at the wrong spawnpoint on HL2 maps
function GM:PlayerSelectSpawn(pl)
	if self.MasterSpawn==nil then
		self.MasterSpawn = false
		for _,v in pairs(ents.FindByClass("info_player_start")) do
			if v.IsMasterSpawn then
				self.MasterSpawn = v
				break
			end
		end
	end
	
	if self.MasterSpawn then
		return self.MasterSpawn
	end

	local spawnsred = {}
	local spawnsblu = {}

	for k, v in pairs(ents.FindByClass("info_player_teamspawn")) do
		--print(v, "says")
		if v:GetKeyValues()["StartDisabled"] == 0 then
		if v:GetKeyValues()["TeamNum"] == 3 then
			table.insert(spawnsblu, v)
		elseif v:GetKeyValues()["TeamNum"] == 2 then
			table.insert(spawnsred, v)
		end
		end
	end


	if pl:Team() == TEAM_RED and IsValid(spawnsred[1]) then
		return table.Random(spawnsred)
	elseif pl:Team() == TEAM_BLU and IsValid(spawnsblu[1]) then
		return table.Random(spawnsblu)
	elseif pl:Team() == TF_TEAM_PVE_INVADERS and IsValid(spawnsblu[1]) then
		return table.Random(spawnsblu)
	end
	
	return self.BaseClass:PlayerSelectSpawn(pl)
end
hook.Add( "PlayerGiveSWEP", "BlockPlayerSWEPs", function( ply, class, swep )
	if ( ply:Team() == TEAM_BLU and string.find(game.GetMap(), "mvm_") ) then
		return false
	end
end )   
local PlayerGiveAmmoTypes = {TF_PRIMARY, TF_SECONDARY, TF_METAL}
function GM:GiveAmmoPercent(pl, pc, nometal)
	--Msg("Giving "..pc.."% ammo to "..pl:GetName().." : ")
	local ammo_given = false 
	
	for _,v in ipairs(PlayerGiveAmmoTypes) do 
		if not nometal or v ~= TF_METAL then
			if pl:GiveTFAmmo(pc * 0.01, v, true) then
				ammo_given = true
			end
		end
	end
	
	--Msg("\n")
	if ammo_given then
		if pl:GetActiveWeapon().CheckAutoReload then
			pl:GetActiveWeapon():CheckAutoReload()
		end
	end
	
	return ammo_given
end

function GM:GiveAmmoPercentNoMetal(pl, pc)
	return self:GiveAmmoPercent(pl, pc, true)
end

function GM:GiveHealthPercent(pl, pc)
	return pl:GiveHealth(pc * 0.01, true)
end

function GM:ShowHelp(ply)
	ply:ConCommand("tf_hatpainter")
end

function GM:ShowTeam(ply)
	ply:ConCommand("tf_menu")
end

function GM:ShowSpare1(ply)
	ply:ConCommand("tf_itempicker hat")
end

function GM:ShowSpare2(ply)
	ply:ConCommand("open_charinfo_direct")
end

function GM:HealPlayer(healer, pl, h, effect, allowoverheal)
	local health_given = pl:GiveHealth(h, false, allowoverheal)
	--print(health_given)
	if effect then
		if pl:IsPlayer() then
			umsg.Start("PlayerHealthBonus", pl)
				umsg.Short(h)
			umsg.End()
			
			umsg.Start("PlayerHealthBonusEffect")
				umsg.Long(pl:UserID())
				umsg.Bool(h>0)
				umsg.Bool(h>100)
			umsg.End()
		else
			umsg.Start("EntityHealthBonusEffect")
				umsg.Entity(pl)
				umsg.Bool(h>0)
				umsg.Bool(h>100)
			umsg.End()
		end
	end
	
	if health_given <= 0 then return end
	if not healer or not healer:IsPlayer() then return end
	
	healer.AddedHealing = (healer.AddedHealing or 0) + health_given
	healer.HealingScoreProgress = (healer.HealingScoreProgress or 0) + health_given
end

-- Deprecated, use HealPlayer instead
function GM:GiveHealthBonus(pl, h, allowoverheal)
	pl:GiveHealth(h, false, allowoverheal)
	
	if pl:IsPlayer() then
		umsg.Start("PlayerHealthBonus", pl)
			umsg.Short(h)
		umsg.End()
		
		umsg.Start("PlayerHealthBonusEffect")
			umsg.Long(pl:UserID())
			umsg.Bool(h>0)
		umsg.End()
	else
		umsg.Start("EntityHealthBonusEffect")
			umsg.Entity(pl)
			umsg.Bool(h>0)
		umsg.End()
	end
	
	return true
end

file.Append(LOGFILE, Format("Done loading, time = %f\n", SysTime() - load_time))
local load_time = SysTime()

--Half-Life 2 Campaign

-- Include the configuration for this map
function GM:GrabAndSwitch()
	for _, pl in pairs(player.GetAll()) do
		local plInfo = {}
		local plWeapons = pl:GetWeapons()
		
		plInfo.predicted_map = NEXT_MAP
		plInfo.health = pl:Health()
		plInfo.armor = pl:Armor()
		plInfo.score = pl:Frags()
		plInfo.deaths = pl:Deaths()
		plInfo.model = pl.modelName
		
		if plWeapons && #plWeapons > 0 then
			plInfo.loadout = {}
			
			for _, wep in pairs(plWeapons) do
				plInfo.loadout[wep:GetClass()] = {pl:GetAmmoCount(wep:GetPrimaryAmmoType()), pl:GetAmmoCount(wep:GetSecondaryAmmoType())}
			end
		end
		
		file.Write("tf2_userid_info/tf2_userid_info_"..pl:UniqueID()..".txt", util.TableToKeyValues(plInfo))
	end
	
	-- Crash Recovery --
	if game.IsDedicated(true) then
		local savedMap = {}
		
		savedMap.predicted_crash = NEXT_MAP
		
		file.Write("tf2_data/tf2_crash_recovery.txt", util.TableToKeyValues(savedMap))
	end
	-- End --
	
	-- Switch maps
	game.ConsoleCommand("changelevel "..NEXT_MAP.."\n")
end

if file.Exists("tf2/maps/"..game.GetMap()..".lua", "LUA") then
	include("tf2/maps/"..game.GetMap()..".lua")
elseif file.Exists("maps/"..game.GetMap()..".lua", "LUA") then
	include("maps/"..game.GetMap()..".lua")
end

RunConsoleCommand("sk_player_head", "1")
RunConsoleCommand("sv_friction", "8")
RunConsoleCommand("sv_stopspeed", "10")
--Disables use key on objects (Can Be Re-enabled)
-- WHAT WERE YOU THINKING
RunConsoleCommand("sv_playerpickupallowed", "1")
--Sets the gravity to 800 (Can be set back to default "600")
RunConsoleCommand("sv_gravity", "800")
--Sets to a impact force similar to TF2 so things to go flying balls of the walls!
RunConsoleCommand("phys_impactforcescale", "0.05")
--Ditto
RunConsoleCommand("phys_pushscale", "0.10")

function GM:PlayerNoClip( pl )
	if GetConVar("sbox_noclip"):GetInt() <= 0 then 
		return
	end

	if pl:Team() == TEAM_SPECTATOR then
		return false
	else
		return true
	end
end

function GM:EntityRemoved(ent, ply)
	if ent:GetClass() == "item_battery" then
		ent:Remove("item_battery")
	end
end

function GM:PlayerRequestTeam( ply, teamid )
	-- This team isn't joinable
	if ( !team.Joinable( teamid ) or teamid == 0 or teamid == 3 ) then
		ply:ChatPrint( "You can't join that team" )
	return end

	-- This team isn't joinable
	if ( !GAMEMODE:PlayerCanJoinTeam( ply, teamid ) ) then
		-- Messages here should be outputted by this function
	return end

	GAMEMODE:PlayerJoinTeam( ply, teamid )
end

function GM:PlayerCanJoinTeam( ply, teamid )
	--print("Requested "..teamid.." for "..ply:GetName().."!".." (aka team "..team.GetName(teamid).."!)")
	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 5
	if ( ply.LastTeamSwitch && RealTime()-ply.LastTeamSwitch < TimeBetweenSwitches ) then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 1
		ply:ChatPrint( Format( "Please wait %i more seconds before trying to change team again!", ( TimeBetweenSwitches - ( RealTime() - ply.LastTeamSwitch ) ) + 1 ) )
		return false
	end

	-- Already on this team!
	if ( ply:Team() == teamid ) then
		ply:ChatPrint( "You're already on that team" )
		return false
	end

	return true
end

-- Networking
util.AddNetworkString("UpdateLoadout")
util.AddNetworkString("TF_PlayerSpawn")

function GM:PlayerDroppedWeapon(ply)
	if IsValid(ply) and ply:IsPlayer() and !ply:IsHL2() then
		net.Start("UpdateLoadout")
		net.Send(ply)
	end
end