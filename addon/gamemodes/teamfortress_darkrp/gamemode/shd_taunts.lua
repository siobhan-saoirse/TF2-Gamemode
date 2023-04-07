local allowedtaunts = {
"1",
"2",
"3",
}

rockpaperscissors = {
	"taunt_rps_scissors_win",
	"taunt_rps_scissors_lose",
	"taunt_rps_paper_win",
	"taunt_rps_paper_lose",
	"taunt_rps_rock_win",
	"taunt_rps_rock_lose",
}
rockpaperscissors2 = {
	"taunt_rps_scissors_lose",
	"taunt_rps_scissors_win",
	"taunt_rps_paper_lose",
	"taunt_rps_paper_win",
	"taunt_rps_rock_lose",
	"taunt_rps_rock_win",
}
rockpaperscissorsact = {
	ACT_DOD_SPRINT_IDLE_BAR,
	ACT_DOD_PRONEWALK_IDLE_BAR,
	ACT_DOD_ZOOMLOAD_BAZOOKA,
	ACT_DOD_RELOAD_PSCHRECK,
	ACT_DOD_ZOOMLOAD_PSCHRECK,
	ACT_DOD_RELOAD_DEPLOYED_FG42,
}

local class_hidewep = {
"scout",
"soldier",
"pyro",
"engineer",
"medic",
}

local wep = {
"tf_weapon_medigun",
"tf_weapon_pistol_scout",
"tf_weapon_rocketlauncher",
"tf_weapon_shotgun_pyro",
"tf_weapon_shotgun_primary",
"tf_weapon_syringegun_medic",
}


concommand.Add("tf_red_wins", function(ply, cmd)
		for k,v in pairs( player.GetAll() ) do
			if v:Team() == TEAM_RED then
				v:SendLua([[surface.PlaySound("misc/your_team_won.wav")]])
				GAMEMODE:StartCritBoost(v)
				timer.Simple(10, function() 
					RunConsoleCommand("gmod_admin_cleanup")
					v:Spawn()
					v:SetMoveType(MOVETYPE_NONE)
				end)
				timer.Simple(11, function() 
					v:SendLua([[surface.PlaySound("ui/mm_round_start_casual.wav")]])
				end)
				timer.Simple(20, function() 
					v:SetMoveType(MOVETYPE_WALK)
				end)
				timer.Simple(22, function() 
					v:SendLua([[surface.PlaySound("vo/compmode/cm_admin_compbeginsstart_0"..math.random(1,7)..".wav")]])
				end)
			else
				v:SendLua([[surface.PlaySound("misc/your_team_lost.wav")]])
				v:StripWeapons()	
				timer.Simple(10, function() 
					v:Spawn()
					v:SetMoveType(MOVETYPE_NONE)
				end)
				timer.Simple(11, function() 
					v:SendLua([[surface.PlaySound("ui/mm_round_start_casual.wav")]])
				end)
				timer.Simple(20, function() 
					v:SetMoveType(MOVETYPE_WALK)
				end)
				timer.Simple(22, function() 
					v:SendLua([[surface.PlaySound("vo/compmode/cm_admin_compbeginsstart_0"..math.random(1,7)..".wav")]])
				end)
			end
		end
end)
concommand.Add("tf_neutral_nope", function(ply, cmd)
		for k,v in pairs( player.GetAll() ) do
			if v:Team() == TEAM_NEUTRAL then
				v:EmitSound("vo/engineer_no01.wav", 1, 100)
				timer.Simple(10, function() 
					v:EmitSound("vo/engineer_laughlong01.wav", 1, 100)
				end)
			end
		end
end)

concommand.Add("tf_blue_wins", function(ply, cmd)
		for k,v in pairs( player.GetAll() ) do
			if v:Team() == TEAM_BLU then
				v:SendLua([[surface.PlaySound("misc/your_team_won.wav")]])
				GAMEMODE:StartCritBoost(v)
				timer.Simple(10, function() 
					RunConsoleCommand("gmod_admin_cleanup")
					v:Spawn()
					v:SetMoveType(MOVETYPE_NONE)
				end)
				timer.Simple(11, function() 
					v:SendLua([[surface.PlaySound("ui/mm_round_start_casual.wav")]])
				end)
				timer.Simple(20, function() 
					v:SetMoveType(MOVETYPE_WALK)
				end)
				timer.Simple(22, function() 
					v:SendLua([[surface.PlaySound("vo/compmode/cm_admin_compbeginsstart_0"..math.random(1,7)..".wav")]])
				end)
			else	
				v:SendLua([[surface.PlaySound("misc/your_team_lost.wav")]])
				v:StripWeapons()	
				timer.Simple(10, function() 
					v:Spawn()
					v:SetMoveType(MOVETYPE_NONE)
				end)
				timer.Simple(11, function() 
					v:SendLua([[surface.PlaySound("ui/mm_round_start_casual.wav")]])
				end)
				timer.Simple(20, function() 
					v:SetMoveType(MOVETYPE_WALK)
				end)
				timer.Simple(22, function() 
					v:SendLua([[surface.PlaySound("vo/compmode/cm_admin_compbeginsstart_0"..math.random(1,7)..".wav")]])
				end)
			end
		end
end)
concommand.Add("tf_no_one_wins", function(ply, cmd)
		for k,v in pairs( player.GetAll() ) do
			if v:Team() == TEAM_NEUTRAL then
				v:SendLua([[surface.PlaySound("misc/your_team_won.wav")]])
				GAMEMODE:StartCritBoost(v)
				timer.Simple(10, function() 
					RunConsoleCommand("gmod_admin_cleanup")
					v:Spawn()
					v:SetMoveType(MOVETYPE_NONE)
				end)
				timer.Simple(11, function() 
					v:SendLua([[surface.PlaySound("ui/mm_round_start_casual.wav")]])
				end)
				timer.Simple(20, function() 
					v:SetMoveType(MOVETYPE_WALK)
				end)
				timer.Simple(22, function() 
					v:SendLua([[surface.PlaySound("vo/compmode/cm_admin_compbeginsstart_0"..math.random(1,7)..".wav")]])
				end)
			else	
				v:SendLua([[surface.PlaySound("misc/your_team_lost.wav")]])
				v:StripWeapons()	
				timer.Simple(10, function() 
					v:Spawn()
					v:SetMoveType(MOVETYPE_NONE)
				end)
				timer.Simple(11, function() 
					v:SendLua([[surface.PlaySound("ui/mm_round_start_casual.wav")]])
				end)
				timer.Simple(20, function() 
					v:SetMoveType(MOVETYPE_WALK)
				end)
				timer.Simple(22, function() 
					v:SendLua([[surface.PlaySound("vo/compmode/cm_admin_compbeginsstart_0"..math.random(1,7)..".wav")]])
				end)
			end
		end
end) 
concommand.Add("tf_mvm_wins", function(ply, cmd)
	for k,v in pairs( player.GetAll() ) do
		if v:Team() != TEAM_BLU then
			if v:Team() == TEAM_SPECTATOR then
				v:SendLua([[surface.PlaySound("misc/your_team_lost.wav")]])
				v:PrintMessage( HUD_PRINTCENTER, "The robots deployed the bomb! Game over for Mann Co!" )
			else
				v:SendLua([[surface.PlaySound("music/mvm_lost_wave.wav")]])
				v:StripWeapons()	
				timer.Simple(5, function() 
					v:Spawn()
	 

					v:SendLua([[surface.PlaySound("vo/mvm_get_to_upgrade01.wav")]])
				end)
				for k,v in pairs(ents.FindByName("gate1_spawn_door")) do
					v:Fire("SetSpeed", "80")
					v:Fire("Close")
				end
				for k,v in pairs(ents.FindByName("gate2_spawn_door")) do
					v:Fire("SetSpeed", "80")
					v:Fire("Close")
				end
				for k,v in pairs(ents.FindByName("gate0_entrance_door")) do
					v:Fire("SetSpeed", "80")
					v:Fire("Open")
				end
				for k,v in pairs(ents.FindByClass("info_player_bluspawn")) do
					v:Fire("Kill")
				end
			end
		end
		if v:Team() == TEAM_BLU then 
			v:SendLua([[surface.PlaySound("misc/your_team_won.wav")]])
			timer.Simple(5, function() 
				v:Spawn() 
			end) 
		end
		if v:GetObserverMode() == OBS_MODE_ROAMING then 
			v:SendLua([[surface.PlaySound("misc/your_team_lost.wav")]])
			v:PrintMessage( HUD_PRINTCENTER, "The robots deployed the bomb! Game over for Mann Co!" )
		end
	end
end)

concommand.Add("tf_mvm_wave_end_bonus", function(ply, cmd)
	if !ply:IsAdmin() then return end
	ply:EmitSound("vo/mvm_wave_end0"..math.random(1,8)..".wav", 0, 100)
	ply:EmitSound("music/mvm_end_wave.wav", 0, 100)
	timer.Create("HaveABonus", 4, 1, function()
		ply:EmitSound("vo/mvm_bonus0"..math.random(1,3)..".wav", 0, 100)
	end)
	RunConsoleCommand("tf_bot_kick_all")
end)
concommand.Add("tf_help_cap_flag", function(ply, cmd)
	local HelpMeCapture = CurTime() + 3
	if HelpMeCapture or CurTime()>HelpMeCapture then
		if ply:GetPlayerClass() == "scout" then
			ply:EmitSound("vo/scout_helpmecapture0"..math.random(1,3)..".wav", 80, 100)
		elseif ply:GetPlayerClass() == "soldier" then
			ply:EmitSound("vo/soldier_helpmecapture0"..math.random(1,3)..".wav", 80, 100)
		elseif ply:GetPlayerClass() == "pyro" then
			ply:EmitSound("vo/pyro_standonthepoint01.wav", 80, 100)
		elseif ply:GetPlayerClass() == "demoman" then
			ply:EmitSound("vo/demoman_helpmecapture0"..math.random(1,3)..".wav", 80, 100)
		elseif ply:GetPlayerClass() == "heavy" then
			ply:EmitSound("vo/heavy_helpmecapture0"..math.random(1,3)..".wav", 80, 100)
		elseif ply:GetPlayerClass() == "engineer" then
			ply:EmitSound("vo/engineer_helpmecapture0"..math.random(1,3)..".wav", 80, 100)
		elseif ply:GetPlayerClass() == "medic" then
			ply:EmitSound("vo/medic_helpmecapture0"..math.random(1,2)..".wav", 80, 100)
		elseif ply:GetPlayerClass() == "sniper" then
			ply:EmitSound("vo/sniper_helpmecapture0"..math.random(1,3)..".wav", 80, 100)
		elseif ply:GetPlayerClass() == "spy" then
			ply:EmitSound("vo/spy_helpmecapture0"..math.random(1,3)..".wav", 80, 100)
		end
	end
end)
concommand.Add("tf_mvm_wave_end", function(ply, cmd)
	if !ply:IsAdmin() then return end
	ply:EmitSound("vo/mvm_wave_end0"..math.random(1,8)..".wav", 0, 100)
	ply:EmitSound("music/mvm_end_wave.wav", 0, 100)
	RunConsoleCommand("tf_bot_kick_all")
end)
concommand.Add("tf_mvm_wave_mid_end", function(ply, cmd)
	if !ply:IsAdmin() then return end
	ply:EmitSound("vo/mvm_wave_end0"..math.random(1,8)..".wav", 0, 100)
	ply:EmitSound("music/mvm_end_mid_wave.wav", 0, 100)
	RunConsoleCommand("tf_bot_kick_all")
end)
concommand.Add("tf_mvm_wave_end_tank", function(ply, cmd)
	if !ply:IsAdmin() then return end
	ply:EmitSound("vo/mvm_wave_end0"..math.random(1,8)..".wav", 0, 100)
	ply:EmitSound("music/mvm_end_tank_wave.wav", 0, 100)
	RunConsoleCommand("tf_bot_kick_all")
end)
concommand.Add("tf_mvm_wave_end_final", function(ply, cmd)
	if !ply:IsAdmin() then return end
	ply:EmitSound("vo/mvm_final_wave_end0"..math.random(1,6)..".wav", 0, 100)
	ply:EmitSound("music/mvm_end_last_wave.wav", 0, 100)
	RunConsoleCommand("tf_bot_kick_all")
end)
concommand.Add("tf_mvm_wave_start", function(ply, cmd)
	if !ply:IsAdmin() then return end
	ply:EmitSound("vo/mvm_wave_start0"..math.random(1,9)..".wav", 0, 100)
	ply:EmitSound("music/mvm_start_wave.wav", 0, 100)

	timer.Create("WaveStart1", 4, 1, function() ply:EmitSound("vo/announcer_begins_5sec.wav", 0, 100) end )
	timer.Create("WaveStart2", 5, 1, function() ply:EmitSound("vo/announcer_begins_4sec.wav", 0, 100) end )
	timer.Create("WaveStart3", 6, 1, function() ply:EmitSound("vo/announcer_begins_3sec.wav", 0, 100) end )
	timer.Create("WaveStart4", 7, 1, function() ply:EmitSound("vo/announcer_begins_2sec.wav", 0, 100) end )
	timer.Create("WaveStart5", 8, 1, function() ply:EmitSound("vo/announcer_begins_1sec.wav", 0, 100) end )
	timer.Create("WaveStart6", 10, 1, function() RunConsoleCommand("tf_bot_add") RunConsoleCommand("tf_bot_add") RunConsoleCommand("tf_bot_add") RunConsoleCommand("tf_bot_add")  end )
end)


concommand.Add("tf_mvm_wave_666_start", function(ply, cmd)
	if !ply:IsAdmin() then return end
	ply:EmitSound("vo/mvm_wave_start0"..math.random(1,9)..".wav", 0, 100)
	ply:EmitSound("music/mvm_start_wave.wav", 0, 80)

	timer.Create("WaveStart1", 4, 1, function() ply:EmitSound("vo/announcer_begins_5sec.wav", 0, 100) end )
	timer.Create("WaveStart2", 5, 1, function() ply:EmitSound("vo/announcer_begins_4sec.wav", 0, 100) end )
	timer.Create("WaveStart3", 6, 1, function() ply:EmitSound("vo/announcer_begins_3sec.wav", 0, 100) end )
	timer.Create("WaveStart4", 7, 1, function() ply:EmitSound("vo/announcer_begins_2sec.wav", 0, 100) end )
	timer.Create("WaveStart5", 8, 1, function() ply:EmitSound("vo/announcer_begins_1sec.wav", 0, 100) end )
	timer.Create("WaveStart6", 10, 1, function() RunConsoleCommand("tf_bot_add") RunConsoleCommand("tf_bot_add") RunConsoleCommand("tf_bot_add") RunConsoleCommand("tf_bot_add")  end )
end)

concommand.Add("tf_mvm_wave_start_mid", function(ply, cmd)
	if !ply:IsAdmin() then return end
	ply:EmitSound("vo/mvm_wave_start0"..math.random(1,9)..".wav", 0, 100)
	ply:EmitSound("music/mvm_start_mid_wave.wav", 0, 100)

	timer.Create("WaveStart1", 4, 1, function() ply:EmitSound("vo/announcer_begins_5sec.wav", 0, 100) end )
	timer.Create("WaveStart2", 5, 1, function() ply:EmitSound("vo/announcer_begins_4sec.wav", 0, 100) end )
	timer.Create("WaveStart3", 6, 1, function() ply:EmitSound("vo/announcer_begins_3sec.wav", 0, 100) end )
	timer.Create("WaveStart4", 7, 1, function() ply:EmitSound("vo/announcer_begins_2sec.wav", 0, 100) end )
	timer.Create("WaveStart5", 8, 1, function() ply:EmitSound("vo/announcer_begins_1sec.wav", 0, 100) end )
	timer.Create("WaveStart6", 10, 1, function() RunConsoleCommand("tf_bot_add") RunConsoleCommand("tf_bot_add") RunConsoleCommand("tf_bot_add") RunConsoleCommand("tf_bot_add")  end )
end)
concommand.Add("tf_mvm_wave_start_tank", function(ply, cmd)
	if !ply:IsAdmin() then return end
	ply:EmitSound("vo/mvm_wave_start0"..math.random(1,9)..".wav", 0, 100)
	ply:EmitSound("music/mvm_start_tank_wave.wav", 0, 100)

	timer.Create("WaveStart1", 4, 1, function() ply:EmitSound("vo/announcer_begins_5sec.wav", 0, 100) end )
	timer.Create("WaveStart2", 5, 1, function() ply:EmitSound("vo/announcer_begins_4sec.wav", 0, 100) end )
	timer.Create("WaveStart3", 6, 1, function() ply:EmitSound("vo/announcer_begins_3sec.wav", 0, 100) end )
	timer.Create("WaveStart4", 7, 1, function() ply:EmitSound("vo/announcer_begins_2sec.wav", 0, 100) end )
	timer.Create("WaveStart5", 8, 1, function() ply:EmitSound("vo/announcer_begins_1sec.wav", 0, 100) end ) 
	timer.Create("WaveStart55", 10, 1, function() local tank = ents.Create("npc_mvm_tank") tank:SetPos(Vector(75.86, 2707.76, 256.04)) tank:Spawn()  end )

	timer.Create("WaveStart6", 30, 1, function() RunConsoleCommand("tf_bot_add") RunConsoleCommand("tf_bot_add") RunConsoleCommand("tf_bot_add") RunConsoleCommand("tf_bot_add")  end )
end)
concommand.Add("tf_mvm_wave_start_final", function(ply, cmd)
	if !ply:IsAdmin() then return end
	ply:EmitSound("vo/mvm_final_wave_start0"..math.random(1,9)..".wav", 0, 100)
	ply:EmitSound("music/mvm_start_last_wave.wav", 0, 100)

	timer.Create("WaveStart1", 4, 1, function() ply:EmitSound("vo/announcer_begins_5sec.wav", 0, 100) end )
	timer.Create("WaveStart2", 5, 1, function() ply:EmitSound("vo/announcer_begins_4sec.wav", 0, 100) end )
	timer.Create("WaveStart3", 6, 1, function() ply:EmitSound("vo/announcer_begins_3sec.wav", 0, 100) end )
	timer.Create("WaveStart4", 7, 1, function() ply:EmitSound("vo/announcer_begins_2sec.wav", 0, 100) end )
	timer.Create("WaveStart5", 8, 1, function() ply:EmitSound("vo/announcer_begins_1sec.wav", 0, 100) end )
	timer.Create("WaveStart6", 10, 1, function() RunConsoleCommand("tf_bot_add") RunConsoleCommand("tf_bot_add") RunConsoleCommand("tf_bot_add") RunConsoleCommand("tf_bot_add")  end )
end)

concommand.Add("tf_taunt_laugh", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end	
	local time = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_laugh.vcd", 0)	
	ply:DoAnimationEvent(ACT_DOD_HS_CROUCH_KNIFE, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	if ply:GetPlayerClass() == "merc_dm" then
		ply:EmitSound("vo/mercenary_laughevil01.wav", 80, 100)
		timer.Create("Laugh", 2, 1, function()
			if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
			ply:SetNWBool("Taunting", false)
			ply:SetNWBool("NoWeapon", false)
			net.Start("DeActivateTauntCam")
			net.Send(ply)
		end)
	else
		timer.Create("Laugh", time, 1, function()
			if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
			ply:SetNWBool("Taunting", false)
			ply:SetNWBool("NoWeapon", false)
			net.Start("DeActivateTauntCam")
			net.Send(ply)
		end)
	end
end)
concommand.Add("tf_taunt_woohoo", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end
	if ply:GetPlayerClass() != "demoman" then ply:ChatPrint("You're not demoman!") return end
	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end	
	local time = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/woohoo.vcd", 0)	
	ply:DoAnimationEvent(ACT_SIGNAL_GROUP, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	local animent2 = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
	animent2:SetModel("models/player/items/taunts/beer_crate/beer_crate.mdl") 
	animent2:SetAngles(ply:GetAngles())
	animent2:SetPos(ply:GetPos())
	animent2:Spawn()
	animent2:Activate()
	animent2:SetParent(ply)
	animent2:AddEffects(EF_BONEMERGE)
	animent2:SetName("BanjoModel"..ply:EntIndex())
	if ply:GetPlayerClass() == "merc_dm" then
		ply:EmitSound("vo/mercenary_laughevil01.wav", 80, 100)
		timer.Create("Laugh", 2, 1, function()
			if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
			ply:SetNWBool("Taunting", false)
			ply:SetNWBool("NoWeapon", false)
			net.Start("DeActivateTauntCam")
			net.Send(ply)
		end)
	else
		timer.Create("Laugh", time, 1, function()
			if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
			ply:SetNWBool("Taunting", false)
			ply:SetNWBool("NoWeapon", false)
			net.Start("DeActivateTauntCam")
			net.Send(ply)
			animent2:Fire("Kill", "", 0.01)
		end)
	end
end)
concommand.Add("tf_taunt_rip_rick_may_you_will_be_forever_missed", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end
	if ply:GetPlayerClass() != "soldier" then ply:ChatPrint("You're not Soldier!") return end
	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end	
	local time = ply:PlayScene("scenes/workshop/player/"..ply:GetPlayerClass().."/low/taunt_maggots_condolence.vcd", 0)	
	ply:DoAnimationEvent(ACT_BARNACLE_HIT, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	local animent2 = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
	animent2:SetModel("models/workshop/player/items/soldier/taunt_maggots_condolence/taunt_maggots_condolence.mdl") 
	animent2:SetAngles(ply:GetAngles())
	animent2:SetPos(ply:GetPos())
	animent2:Spawn()
	animent2:Activate()
	animent2:SetParent(ply)
	animent2:AddEffects(EF_BONEMERGE)
	animent2:SetName("BanjoModel"..ply:EntIndex())
	if ply:GetPlayerClass() == "merc_dm" then
		ply:EmitSound("vo/mercenary_laughevil01.wav", 80, 100)
		timer.Create("Laugh", 2, 1, function()
			if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
			ply:SetNWBool("Taunting", false)
			ply:SetNWBool("NoWeapon", false)
			net.Start("DeActivateTauntCam")
			net.Send(ply)
		end)
	else
		timer.Create("Laugh", time, 1, function()
			if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
			ply:SetNWBool("Taunting", false)
			ply:SetNWBool("NoWeapon", false)
			net.Start("DeActivateTauntCam")
			net.Send(ply)
			animent2:Fire("Kill", "", 0.01)
		end)
	end
end)
concommand.Add("tf_taunt_disco", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end	
	local time = ply:SequenceDuration(ACT_DOD_DEPLOYED)	
	ply:DoAnimationEvent(ACT_DOD_DEPLOYED, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	ply:EmitSound("player/taunt_disco.wav")
	net.Start("ActivateTauntCam")
	net.Send(ply)
	timer.Create("LoopAnimConga"..ply:EntIndex(), ply:SequenceDuration(ply:LookupSequence("disco_fever")), 1, function()
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
end)
concommand.Add("tf_taunt_conga_start", function(ply)
	if ply:GetNWBool("NoWeapon") == true then return end
	
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	ply:DoAnimationEvent(ACT_DOD_CROUCHWALK_IDLE_PISTOL, false)
	ply:EmitSound("CongaSong")	
	local time 
	if ply:IsHL2() then
		time = ply:PlayScene("scenes/player/sniper/low/conga.vcd", 0)		
		ply:SetColor( Color( 255, 255, 255, 0 ) ) 
		ply:SetRenderMode( RENDERMODE_TRANSALPHA ) 
	else
		time = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/conga.vcd", 0)		
	end 
	timer.Create("LoopSlowTauntSpeed"..ply:EntIndex(), 0.01, 0, function()
		ply:SetClassSpeed(3 * 25)
	end)
	timer.Create("LoopTauntSpeakingConga"..ply:EntIndex(), 5, 0, function()
		if ply:GetNWBool("NoWeapon") == false then timer.Stop("LoopAnimConga"..ply:EntIndex()) timer.Stop("LoopSlowTauntSpeed"..ply:EntIndex()) timer.Stop("LoopTauntSpeakingConga"..ply:EntIndex()) return end
	end)
	ply:SetNWBool("NoWeapon", true)
	ply:SetNWBool("Bonked", true)
	ply:ConCommand("tf_tp_simulation_toggle ")
	net.Send(ply)
	
	timer.Create("LoopAnimConga"..ply:EntIndex(), time, 0, function()
		ply:StopSound("CongaSong")	
		ply:EmitSound("CongaSong")
		ply:DoAnimationEvent(ACT_DOD_CROUCHWALK_IDLE_PISTOL, false)
		ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/conga.vcd", 0)	
		if ply:IsHL2() then
			ply:PlayScene("scenes/player/sniper/low/conga.vcd", 0)		
			ply:SetColor( Color( 255, 255, 255, 0 ) ) 
			ply:SetRenderMode( RENDERMODE_TRANSALPHA )
		else
			ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/conga.vcd", 0)		
		end
	end)
	timer.Create("LoopSetAngles"..ply:EntIndex(), 0.001, 0, function()
		if ply:IsHL2() then
			animent2:SetAngles(ply:EyeAngles())
			animent2:SetPos(ply:GetPos())
		end
	end)
end)
concommand.Add("tf_taunt_conga_stop", function(ply)
	if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("NoWeapon")) then return end
	ply:SetNWBool("NoWeapon", false)
	ply:SetNWBool("Bonked", false)
	ply:StopSound("CongaSong")
	timer.Stop("LoopAnimConga"..ply:EntIndex()) 
	timer.Stop("LoopSlowTauntSpeed"..ply:EntIndex()) 
	timer.Stop("LoopTauntSpeakingConga"..ply:EntIndex())
	ply:ConCommand("tf_firstperson")
	ply:ResetClassSpeed()
	net.Send(ply)
	ply:SetColor( Color( 255, 255, 255, 255 ) ) 
	ply:SetRenderMode( RENDERMODE_TRANSALPHA ) 
	if IsValid(animent2) and IsValid(animent3) then
		animent2:Fire("Kill", "", 0.01)
		animent3:Fire("Kill", "", 0.01)
	end
end)
concommand.Add("tf_taunt_russian_start", function(ply)
	if ply:GetNWBool("Taunting2") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	ply:DoAnimationEvent(ACT_DI_ALYX_ZOMBIE_TORSO_MELEE, false)
	ply:EmitSound("RussianSong")
	local time = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_russian.vcd", 0)
	timer.Create("LoopSlowTauntSpeed2"..ply:EntIndex(), 0.01, 0, function()
		ply:SetClassSpeed(3 * 25)
	end)
	timer.Create("LoopTauntSpeakingConga2"..ply:EntIndex(), 0.001, 0, function()
		if ply:GetNWBool("NoWeapon") == false then timer.Stop("LoopAnimRussian"..ply:EntIndex()) timer.Stop("LoopSlowTauntSpeed2"..ply:EntIndex()) timer.Stop("LoopTauntSpeakingConga2"..ply:EntIndex()) timer.Stop("LoopMusic"..ply:EntIndex()) return end
	end)
	ply:SetNWBool("NoWeapon", true)
	ply:SetNWBool("Bonked", true)
	ply:ConCommand("tf_tp_simulation_toggle")
	net.Send(ply)
	timer.Create("LoopMusic"..ply:EntIndex(), 66.24, 0, function()
		ply:EmitSound("RussianSong")
	end)
	timer.Create("LoopAnimRussian"..ply:EntIndex(), time, 0, function()
		ply:DoAnimationEvent(ACT_DI_ALYX_ZOMBIE_TORSO_MELEE, false)
		ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_russian.vcd", 0)
	end)
end)
concommand.Add("tf_taunt_russian_stop", function(ply)
	if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("NoWeapon")) then return end
	ply:SetNWBool("NoWeapon", false)
	ply:SetNWBool("Bonked", false)
	ply:StopSound("RussianSong")
	ply:ResetClassSpeed()
	ply:ConCommand("tf_firstperson")
	timer.Stop("LoopAnimRussian"..ply:EntIndex())
	timer.Stop("LoopSlowTauntSpeed2"..ply:EntIndex())
	timer.Stop("LoopTauntSpeakingConga2"..ply:EntIndex())
	timer.Stop("LoopMusic"..ply:EntIndex())

	net.Send(ply)
end)
concommand.Add("tf_taunt_banjo_start", function(ply)
	if ply:GetNWBool("Taunting2") == true then return end
	if ply:GetNWBool("Taunting2") == true then return end
	if ply:GetPlayerClass() != "engineer" then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	ply:DoAnimationEvent(ACT_SIGNAL3, false)
	ply:EmitSound("BanjoSong")
	local time = ply:SequenceDuration("taunt_bumpkins_banjo_fastloop")
	timer.Create("LoopAnimBanjo2"..ply:EntIndex(), 0.001, 0, function()
		if ply:GetNWBool("NoWeapon") == false then timer.Stop("LoopAnimBanjo"..ply:EntIndex()) timer.Stop("LoopAnimBanjo2"..ply:EntIndex()) timer.Stop("LoopTauntSpeakingConga2"..ply:EntIndex()) timer.Stop("LoopMusic"..ply:EntIndex()) return end
	end)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_russian.vcd", 0)
	local animent2 = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
	animent2:SetModel("models/workshop/player/items/engineer/taunt_bumpkins_banjo/taunt_bumpkins_banjo.mdl") 
	animent2:SetAngles(ply:GetAngles())
	animent2:SetPos(ply:GetPos())
	animent2:Spawn()
	animent2:Activate()
	animent2:SetParent(ply)
	animent2:AddEffects(EF_BONEMERGE)
	animent2:SetName("BanjoModel"..ply:EntIndex())
	timer.Create("LoopAnimBanjo"..ply:EntIndex(), 10, 0, function()
		ply:DoAnimationEvent(ACT_SIGNAL3, false)
		ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_russian.vcd", 0)
	end)
end)
concommand.Add("tf_taunt_chair", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:GetNWBool("Taunting2") == true then return end
	if ply:GetPlayerClass() != "spy" then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	ply:DoAnimationEvent(ACT_WALK_CROUCH_AIM, false)
	ply:DoAnimationEvent(ACT_WALK_CROUCH_AIM, false)
	local time = ply:SequenceDuration(ply:LookupSequence("taunt_luxury_lounge"))
	timer.Create("LoopAnimBanjo2"..ply:EntIndex(), 0.001, 0, function()
		if ply:GetNWBool("Taunting") == false then timer.Stop("LoopAnimBook"..ply:EntIndex()) timer.Stop("LoopAnimBanjo2"..ply:EntIndex()) timer.Stop("LoopTauntSpeakingConga2"..ply:EntIndex()) timer.Stop("LoopMusic"..ply:EntIndex()) return end
	end)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	local animent2 = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
	animent2:SetModel("models/workshop/player/items/spy/taunt_luxury_lounge/taunt_luxury_lounge.mdl") 
	animent2:SetAngles(ply:GetAngles())
	animent2:SetPos(ply:GetPos())
	animent2:Spawn()
	animent2:SetSkin(ply:GetSkin())
	animent2:Activate()
	animent2:SetParent(ply)
	animent2:AddEffects(EF_BONEMERGE)
	animent2:SetName("BanjoModel"..ply:EntIndex())
	timer.Create("LoopAnimBook"..ply:EntIndex(), 27, 0, function()
		ply:DoAnimationEvent(ACT_WALK_CROUCH_AIM, false)
	end)
end)
concommand.Add("tf_taunt_weight", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:GetNWBool("Taunting2") == true then return end
	if ply:GetPlayerClass() != "heavy" then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local npc = ents.Create("base_entity")
	npc:SetPos(ply:GetPos())
	npc:SetAngles(ply:GetAngles())
	npc:Spawn()
	npc:Activate()
	npc:SetName("Heavy")
	npc:ResetSequence("taunt_soviet_strongarm_intro_loop")
	npc:SetModel("models/player/heavy.mdl")
	local time = npc:PlayScene("scenes/workshop/player/heavy/low/taunt_soviet_strongarm.vcd", 0)
	timer.Create("LoopAnimBanjo2"..ply:EntIndex(), 0.001, 0, function()
		if ply:GetNWBool("Taunting") == false then timer.Stop("LoopAnimBook"..ply:EntIndex()) timer.Stop("LoopAnimBanjo2"..ply:EntIndex()) timer.Stop("LoopTauntSpeakingConga2"..ply:EntIndex()) timer.Stop("LoopMusic"..ply:EntIndex()) return end
	end)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)

	local animent2 = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
	animent2:SetModel("models/workshop/player/items/heavy/taunt_soviet_strongarm/taunt_soviet_strongarm.mdl") 
	animent2:SetAngles(npc:GetAngles())
	animent2:SetPos(npc:GetPos())
	animent2:Spawn()
	animent2:SetSkin(npc:GetSkin())
	animent2:Activate()
	animent2:SetParent(npc)
	animent2:AddEffects(EF_BONEMERGE)
	animent2:SetName("BanjoModel"..ply:EntIndex())
	timer.Create("LoopAnimBook"..ply:EntIndex(), time, 0, function()
		ply:DoAnimationEvent(ACT_WALK_CROUCH_AIM, false)
	end)
end)
concommand.Add("tf_taunt_chair2", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:GetNWBool("Taunting2") == true then return end
	if ply:GetPlayerClass() != "engineer" then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	ply:DoAnimationEvent(ACT_FLY, false)
	local time = ply:SequenceDuration(ply:LookupSequence("taunt_luxury_lounge"))
	timer.Create("LoopAnimBanjo2"..ply:EntIndex(), 0.001, 0, function()
		if ply:GetNWBool("Taunting") == false then timer.Stop("LoopAnimBook"..ply:EntIndex()) timer.Stop("LoopAnimBanjo2"..ply:EntIndex()) timer.Stop("LoopTauntSpeakingConga2"..ply:EntIndex()) timer.Stop("LoopMusic"..ply:EntIndex()) return end
	end)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	local animent2 = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
	animent2:SetModel("models/player/items/taunts/engys_new_chair/engys_new_chair_articlulated.mdl") 
	animent2:SetAngles(ply:GetAngles())
	animent2:SetPos(ply:GetPos())
	animent2:SetSkin(ply:GetSkin())
	animent2:Spawn()
	animent2:Activate()
	animent2:ResetSequence("chair_intro_qcistyle")
	animent2.AutomaticFrameAdvance = true
	animent2:SetPlaybackRate(1)
	animent2:SetName("BanjoModel"..ply:EntIndex()) 
	function animent2:Think() -- This makes the animation work
		self:NextThink( CurTime() )
		return true
	end
		ply:EmitSound("vo/taunts/engy/taunt_engineer_lounge_button_press.mp3")
		timer.Simple(0.2, function()
			ply:EmitSound("vo/taunts/engy/taunt_engineer_lounge_toolbox_open.mp3")
		end)
		timer.Simple(4.3, function()
			ply:EmitSound("engy_taunt_killertime_4_drink")
		end)
		timer.Simple(11.5, function()
			ply:EmitSound("engy_taunt_killertime_4_2_drink_long")
		end)
		timer.Simple(23, function()
			ply:EmitSound("vo/taunts/demo/taunt_demo_burp_03.mp3")
		end)
		timer.Simple(24.3, function()
			ply:EmitSound("vo/taunts/engy/eng_guzzle_05.wav")
		end)
	animent2:SetName("BanjoModel"..ply:EntIndex())
	timer.Create("LoopAnimBook"..ply:EntIndex(), 28, 0, function()
		ply:DoAnimationEvent(ACT_FLY, false)
		animent2:SetCycle(0)
		ply:EmitSound("vo/taunts/engy/taunt_engineer_lounge_button_press.mp3")
		timer.Simple(0.2, function()
			ply:EmitSound("vo/taunts/engy/taunt_engineer_lounge_toolbox_open.mp3")
		end)
		timer.Simple(4.3, function()
			ply:EmitSound("vo/taunts/engy/eng_guzzle_02.wav")
		end)
		timer.Simple(11.5, function()
			ply:EmitSound("vo/taunts/engy/eng_guzzle_06.wav")
		end)
		timer.Simple(23, function()
			ply:EmitSound("vo/taunts/demo/taunt_demo_burp_03.mp3")
		end)
		timer.Simple(24.3, function()
			ply:EmitSound("vo/taunts/engy/eng_guzzle_05.wav")
		end)
	end)
end)


concommand.Add("tf_taunt_pyro_partytrick", function(ply)
	if ply:GetNWBool("Taunting2") == true then return end
	if ply:GetNWBool("Taunting2") == true then return end
	if ply:GetPlayerClass() != "pyro" then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	ply:DoAnimationEvent(ACT_WALK_SCARED, false)
	local time = ply:PlayScene("scenes/player/pyro/low/taunt_party_trick.vcd", 0)
	timer.Simple(1.5, function()
		ply:EmitSound("player/taunt_party_trick.wav", 80, 100)
	end)
	timer.Create("LoopAnimBanjo2"..ply:EntIndex(), 0.001, 0, function()
		if ply:GetNWBool("NoWeapon") == false then timer.Stop("LoopAnimBanjo"..ply:EntIndex()) timer.Stop("LoopAnimBanjo2"..ply:EntIndex()) timer.Stop("LoopTauntSpeakingConga2"..ply:EntIndex()) timer.Stop("LoopMusic"..ply:EntIndex()) return end
	end)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	local animent2 = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
	animent2:SetModel("models/player/items/taunts/balloon_animal_pyro/balloon_animal_pyro.mdl") 
	animent2:SetAngles(ply:GetAngles())
	animent2:SetPos(ply:GetPos())
	animent2:Spawn()
	animent2:Activate()
	animent2:SetParent(ply)
	animent2:AddEffects(EF_BONEMERGE)
	animent2:SetName("BanjoModel"..ply:EntIndex())
	timer.Create("LoopAnimBanjo"..ply:EntIndex(), time - 0.5, 1, function()
		for k,v in ipairs(ents.FindByName("BanjoModel"..ply:EntIndex())) do
			v:Remove()
			ply:SetNWBool("NoWeapon", false)
			ply:SetNWBool("Taunting", false)
			net.Start("DeActivateTauntCam")
			net.Send(ply)	
		end
	end)
end)


concommand.Add("tf_taunt_introduction", function(ply)
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	if ply:GetPlayerClass() == "soldier" then
		ply:DoAnimationEvent(ACT_DOD_PRIMARYATTACK_BOLT, false)
		ply:SetNWBool("Taunting", true)
		net.Start("ActivateTauntCam")
		net.Send(ply)
		timer.Create("LoopAnimBanjo"..ply:EntIndex(), ply:SequenceDuration(ply:LookupSequence("selectionMenu_Anim0l")), 1, function()
			ply:SetNWBool("Taunting", false)
			net.Start("DeActivateTauntCam")
			net.Send(ply)	
		end)
	else
		ply:DoAnimationEvent(ACT_DOD_RELOAD_PRONE_DEPLOYED, false)
		ply:SetNWBool("Taunting", true)
		net.Start("ActivateTauntCam")
		net.Send(ply)
		timer.Create("LoopAnimBanjo"..ply:EntIndex(), ply:SequenceDuration(ply:LookupSequence("selectionMenu_Anim01")), 1, function()
			ply:SetNWBool("Taunting", false)
			net.Start("DeActivateTauntCam")
			net.Send(ply)	
		end)
	end
end)
concommand.Add("tf_taunt_banjo_stop", function(ply)
	if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("NoWeapon")) then return end
	if ply:GetPlayerClass() != "engineer" then return end
	ply:StopSound("BanjoSong")
	ply:EmitSound("BanjoSongStop")
	ply:ResetClassSpeed()
	ply:DoAnimationEvent(ACT_SIGNAL_ADVANCE, false)
	local time = ply:SequenceDuration(ply:LookupSequence("taunt_bumpkins_banjo_outro"))
	timer.Create("OutroBanjo"..ply:EntIndex(), 2.5, 1, function()
		for k,v in ipairs(ents.FindByName("BanjoModel"..ply:EntIndex())) do
			v:Remove()
			ply:SetNWBool("NoWeapon", false)
			ply:SetNWBool("Taunting", false)
			net.Start("DeActivateTauntCam")
			net.Send(ply)	
		end
	end)
end)
concommand.Add("tf_taunt_chair_stop", function(ply)
	if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("NoWeapon")) then return end
	ply:ResetClassSpeed()
	ply:DoAnimationEvent(ACT_RUN_CROUCH_AIM)
	timer.Simple(3.2, function()
		for k,v in ipairs(ents.FindByName("BanjoModel"..ply:EntIndex())) do
			v:Remove()
			ply:SetNWBool("NoWeapon", false)
			ply:SetNWBool("Taunting", false)
			net.Start("DeActivateTauntCam")
			net.Send(ply)	
		end
	end)
end)
concommand.Add("tf_taunt_weight_stop", function(ply)
	if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("NoWeapon")) then return end
	ply:ResetClassSpeed()
		for k,v in ipairs(ents.FindByName("BanjoModel"..ply:EntIndex())) do
			v:Remove()
			ply:SetNWBool("NoWeapon", false)
			ply:SetNWBool("Taunting", false)
			net.Start("DeActivateTauntCam")
			net.Send(ply)	
		end
		for k,v in ipairs(ents.FindByName("Heavy")) do
			v:Remove()
		end
end)
concommand.Add("tf_taunt_chair2_stop", function(ply)
	if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("NoWeapon")) then return end
	ply:ResetClassSpeed()
		for k,v in ipairs(ents.FindByName("BanjoModel"..ply:EntIndex())) do
			v:Remove()
			ply:SetNWBool("NoWeapon", false)
			ply:SetNWBool("Taunting", false)
			net.Start("DeActivateTauntCam")
			net.Send(ply)	
		end
end)
concommand.Add("tf_taunt_thriller", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt06.vcd", 0)
	ply:DoAnimationEvent(ACT_DOD_CROUCH_IDLE_TOMMY, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	timer.Simple(time, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
end)
concommand.Add("tf_taunt_directors_vision", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end
	local act = ACT_BARNACLE_PULL
	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_replay.vcd", 0)
	if (ply:GetPlayerClass() == "pyro") then
		if (math.random(1,3) == 2) then
			local time = ply:PlayScene("scenes/player/pyro/low/taunt_replay2.vcd", 0)
			ply:DoTauntEvent(ply:LookupSequence("pyro_taunt_replay2"), true)
		else
			ply:DoTauntEvent(ply:LookupSequence("pyro_taunt_replay2"), true)
		end
	else
		ply:DoTauntEvent(ply:LookupSequence("heavy_taunt_replay"), true)
	end
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	timer.Simple(time, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
end)
concommand.Add("tf_taunt_yeti", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/yeti_taunt.vcd", 0)
	ply:DoAnimationEvent(ACT_RUN_PROTECTED, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	local animent2 = ents.Create( 'base_gmodentity' ) -- The entity used for the taunt
	animent2:SetModel("models/player/items/taunts/yeti/yeti.mdl") 
	animent2:SetModelScale(ply:GetModelScale())
	animent2:SetAngles(Angle(ply:GetAngles().x, ply:GetAngles().y, 0))
	animent2:SetPos(ply:GetPos())
	animent2:Spawn()
	animent2:Activate()
	animent2.AutomaticFrameAdvance = true
	animent2:ResetSequence("taunt_yeti")
	animent2:SetPlaybackRate(1)
	animent2:SetName("BanjoModel"..ply:EntIndex()) 
	function animent2:Think() -- This makes the animation work
		self:NextThink( CurTime() )
		return true
	end
	ply:SetColor( Color( 255, 255, 255, 0 ) ) 
	ply:SetRenderMode( RENDERMODE_TRANSALPHA ) 
	timer.Simple(0.8, function()
		timer.Create("ChestThump", 0.01, 5, function()
			local mad = animent2:GetFlexIDByName("AH")
			animent2:SetFlexWeight(mad, animent2:GetFlexWeight(mad) + 0.08/1)
				local mad2 = animent2:GetFlexIDByName("mad")
				animent2:SetFlexWeight(mad2, animent2:GetFlexWeight(mad2) + 0.2/1)
		end)
		timer.Simple(0.5, function()
			timer.Create("ChestThump", 0.01, 5, function()
				local mad = animent2:GetFlexIDByName("AH")
				animent2:SetFlexWeight(mad, animent2:GetFlexWeight(mad) - 0.1/1)
				local mad2 = animent2:GetFlexIDByName("mad")
				animent2:SetFlexWeight(mad2, animent2:GetFlexWeight(mad2) /1)
			end)
		end)
	end)
	timer.Simple(1.8, function()
		timer.Create("ChestThump2", 0.01, 20, function()
			local mad = animent2:GetFlexIDByName("mad")
			animent2:SetFlexWeight(mad, animent2:GetFlexWeight(mad) + 0.08/1)
		end)
		timer.Create("ChestThump", 0.01, 5, function()
			local mad = animent2:GetFlexIDByName("AH")
			animent2:SetFlexWeight(mad, animent2:GetFlexWeight(mad) + 0.08/1)
		end)
		timer.Simple(1.5, function()
			timer.Create("ChestThump", 0.01, 5, function()
				local mad = animent2:GetFlexIDByName("AH")
				animent2:SetFlexWeight(mad, animent2:GetFlexWeight(mad) - 0.1/1)
			end)
		end)
	end)
	timer.Simple(4, function()
		timer.Create("ChestThump3", 0.01, 20, function()
			local mad = animent2:GetFlexIDByName("mad")
			animent2:SetFlexWeight(mad, animent2:GetFlexWeight(mad) - 0.1/1)
			local roar = animent2:GetFlexIDByName("actionfire02")
			animent2:SetFlexWeight(roar, animent2:GetFlexWeight(roar) + 0.1/1)
		end)
	end)
	timer.Simple(5.4, function()
		animent2:Remove()
		ply:SetColor( Color( 255, 255, 255, 255 ) ) 
		ply:SetRenderMode( RENDERMODE_NORMAL ) 
	end)
	timer.Simple(time, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
end)
concommand.Add("tf_taunt_yetipunch", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_yetipunch.vcd", 0)
	ply:DoAnimationEvent(ACT_BARNACLE_CHOMP, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	timer.Simple(time, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
end)
concommand.Add("tf_taunt_highfive", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_highfivesuccess.vcd", 0)	
	if not ply:GetPlayerClass() == "spy" or ply:GetPlayerClass() == "engineer" then
		ply:DoAnimationEvent(ACT_DOD_STAND_ZOOM_BOLT, true)
	else
		ply:DoAnimationEvent(ACT_DOD_CROUCH_ZOOM_BOLT, true)
	end
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	ply:EmitSound("misc/high_five.wav")
	net.Start("ActivateTauntCam")
	net.Send(ply)
	timer.Simple(time, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
	for k,v in pairs(ents.FindInSphere(ply:GetPos(), 120) ) do 
		if v:IsPlayer() then
			if v:GetNWBool("Taunting") == true then return end
			if v:IsHL2() then v:ConCommand("act laugh") return end
			if not v:IsOnGround() then return end
			if v:WaterLevel() ~= 0 then return end
			if v:GetInfoNum("tf_robot", 0) == 1 then v:ChatPrint("You can't taunt as a robot!") return end
			if v:GetInfoNum("tf_giantrobot", 0) == 1 then v:ChatPrint("You can't taunt as a mighty robot!") return end
			local time = v:PlayScene("scenes/player/"..v:GetPlayerClass().."/low/taunt_highfivesuccess.vcd", 0)
			v:DoAnimationEvent(ACT_DOD_STAND_ZOOM_BOLT, true)
			v:SetNWBool("Taunting", true)
			v:SetNWBool("NoWeapon", true)
			net.Start("ActivateTauntCam")
			net.Send(v)
			timer.Simple(time, function()
				if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
				v:SetNWBool("Taunting", false)
				v:SetNWBool("NoWeapon", false)
				net.Start("DeActivateTauntCam")
				net.Send(v)
			end)
		end
		if v:IsBot() then
			if v:GetNWBool("Taunting") == true then return end
			if v:IsHL2() then v:ConCommand("act laugh") return end
			if not v:IsOnGround() then return end
			if v:WaterLevel() ~= 0 then return end
			if v:GetInfoNum("tf_robot", 0) == 1 then v:ChatPrint("You can't taunt as a robot!") return end
			if v:GetInfoNum("tf_giantrobot", 0) == 1 then v:ChatPrint("You can't taunt as a mighty robot!") return end
			local time = v:PlayScene("scenes/player/"..v:GetPlayerClass().."/low/taunt_highfivesuccess.vcd", 0)
			v:DoAnimationEvent(ACT_DOD_STAND_ZOOM_BOLT, true)
			v:SetNWBool("Taunting", true)
			v:SetNWBool("NoWeapon", true)
			net.Start("ActivateTauntCam")
			net.Send(v)
			timer.Simple(time, function()
				if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
				v:SetNWBool("Taunting", false)
				v:SetNWBool("NoWeapon", false)
				net.Start("DeActivateTauntCam")
				net.Send(v)
			end)
		end
		if v.Base == "npc_tf2base" or v.Base == "npc_soldier_red" or v.Base == "npc_hwg_red" or v.Base == "npc_pyro_red" or v.Base == "npc_scout_red" then
			if v:GetNWBool("Taunting") == true then return end
			local time = v:PlayScene("scenes/player/"..v.TF2Class.."/low/taunt_highfivesuccess.vcd", 0)
			v:SetCycle(0)
			v:ResetSequence("taunt_hifivesuccess")
			v:SetNWBool("Taunting", true)
			v:SetNWBool("NoWeapon", true)
			timer.Simple(time, function()
				if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
				v:SetNWBool("Taunting", false)
				v:SetNWBool("NoWeapon", false)
				net.Start("DeActivateTauntCam")
				net.Send(v)
			end)
		end
	end
end)
concommand.Add("tf_taunt_highfive_fail", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_hifivefailfull.vcd", 0)	
	if not ply:GetPlayerClass() == "spy" or ply:GetPlayerClass() == "engineer" then
		ply:DoAnimationEvent(ACT_DOD_STAND_ZOOM_BOLT, true)
	else
		ply:DoAnimationEvent(ACT_DOD_CROUCH_ZOOM_BOLT, true)
	end
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	ply:EmitSound("misc/high_five.wav")
	net.Start("ActivateTauntCam")
	net.Send(ply)
	timer.Simple(time, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
	for k,v in pairs(ents.FindInSphere(ply:GetPos(), 120) ) do 
		if v:IsPlayer() then
			if v:GetNWBool("Taunting") == true then return end
			if v:IsHL2() then v:ConCommand("act laugh") return end
			if not v:IsOnGround() then return end
			if v:WaterLevel() ~= 0 then return end
			if v:GetInfoNum("tf_robot", 0) == 1 then v:ChatPrint("You can't taunt as a robot!") return end
			if v:GetInfoNum("tf_giantrobot", 0) == 1 then v:ChatPrint("You can't taunt as a mighty robot!") return end
			local time = v:PlayScene("scenes/player/"..v:GetPlayerClass().."/low/taunt_highfivefailfull.vcd", 0)
			v:DoAnimationEvent(ACT_DOD_STAND_ZOOM_BOLT, true)
			v:SetNWBool("Taunting", true)
			v:SetNWBool("NoWeapon", true)
			net.Start("ActivateTauntCam")
			net.Send(v)
			timer.Simple(time, function()
				if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
				v:SetNWBool("Taunting", false)
				v:SetNWBool("NoWeapon", false)
				net.Start("DeActivateTauntCam")
				net.Send(v)
			end)
		end
		if v:IsBot() then
			if v:GetNWBool("Taunting") == true then return end
			if v:IsHL2() then v:ConCommand("act laugh") return end
			if not v:IsOnGround() then return end
			if v:WaterLevel() ~= 0 then return end
			if v:GetInfoNum("tf_robot", 0) == 1 then v:ChatPrint("You can't taunt as a robot!") return end
			if v:GetInfoNum("tf_giantrobot", 0) == 1 then v:ChatPrint("You can't taunt as a mighty robot!") return end
			local time = v:PlayScene("scenes/player/"..v:GetPlayerClass().."/low/taunt_highfivefailfull.vcd", 0)
			v:DoAnimationEvent(ACT_DOD_STAND_ZOOM_BOLT, true)
			v:SetNWBool("Taunting", true)
			v:SetNWBool("NoWeapon", true)
			net.Start("ActivateTauntCam")
			net.Send(v)
			timer.Simple(time, function()
				if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
				v:SetNWBool("Taunting", false)
				v:SetNWBool("NoWeapon", false)
				net.Start("DeActivateTauntCam")
				net.Send(v)
			end)
		end
		if v.Base == "npc_tf2base" or v.Base == "npc_soldier_red" or v.Base == "npc_hwg_red" or v.Base == "npc_pyro_red" or v.Base == "npc_scout_red" then
			if v:GetNWBool("Taunting") == true then return end
			local time = v:PlayScene("scenes/player/"..v.TF2Class.."/low/taunt_highfivefailfull.vcd", 0)
			v:SetCycle(0)
			v:ResetSequence("taunt_hifivesuccess")
			v:SetNWBool("Taunting", true)
			v:SetNWBool("NoWeapon", true)
			timer.Simple(time, function()
				if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
				v:SetNWBool("Taunting", false)
				v:SetNWBool("NoWeapon", false)
				net.Start("DeActivateTauntCam")
				net.Send(v)
			end)
		end
	end
end)
concommand.Add("tf_taunt_skullcracker", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_headbutt_success.vcd", 0)
	ply:DoAnimationEvent(ACT_DOD_RUN_IDLE_MG, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	timer.Simple(time, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
	for k,v in pairs(ents.FindInSphere(ply:GetPos(), 120) ) do 
		if v:IsPlayer() then
			if v:IsHL2() then v:ConCommand("act laugh") return end
			if not v:IsOnGround() then return end
			if v:WaterLevel() ~= 0 then return end
			if v:GetInfoNum("tf_robot", 0) == 1 then v:ChatPrint("You can't taunt as a robot!") return end
			if v:GetInfoNum("tf_giantrobot", 0) == 1 then v:ChatPrint("You can't taunt as a mighty robot!") return end
			local time = v:PlayScene("scenes/player/"..v:GetPlayerClass().."/low/taunt_headbutt_success.vcd", 0)
			v:DoAnimationEvent(ACT_DOD_RUN_IDLE_MG, true)
			v:SetNWBool("Taunting", true)
			v:SetNWBool("NoWeapon", true)
			net.Start("ActivateTauntCam")
			net.Send(v)
			timer.Simple(time, function()
				if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
				v:SetNWBool("Taunting", false)
				v:SetNWBool("NoWeapon", false)
				net.Start("DeActivateTauntCam")
				net.Send(v)
			end)
		end
	end
end)
concommand.Add("tf_taunt_robot_stun", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end
	if ply:GetInfoNum("tf_robot", 0) == 0 and ply:GetInfoNum("tf_giantrobot", 0) == 0 then ply:ChatPrint("You can't use this command as a human!") return end
	ply:EmitSound("mvm/mvm_robo_stun.wav", 95, 100)
	timer.Create("StunRobot25", 0.001, 1, function()
		ply:DoAnimationEvent(ACT_MP_STUN_BEGIN,2)
		timer.Create("StunRobotloop3", 0.5, 0, function()
			if not ply:Alive() then timer.Stop("StunRobotloop") return end
			timer.Create("StunRobotloop4", 0.22, 0, function()
				if not ply:Alive() then timer.Stop("StunRobotloop4") return end
				ply:DoAnimationEvent(ACT_MP_STUN_MIDDLE,2)
			end)
		end)
	end)
	ply:DoAnimationEvent(ACT_DOD_SECONDARYATTACK_BOLT, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	timer.Simple(23, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:EmitSound("misc/cp_harbor_red_whistle.wav", 95, 100)
		timer.Stop("StunRobotloop3")
		timer.Stop("StunRobotloop4")
		ply:DoAnimationEvent(ACT_MP_STUN_END,2)
		timer.Simple(1, function()
			ply:SetNWBool("Taunting", false)
			ply:SetNWBool("NoWeapon", false)
			net.Start("DeActivateTauntCam")
			net.Send(ply)
		end)
	end)
	for k,v in pairs(ents.FindInSphere(ply:GetPos(), 200) ) do	
		if v:GetNWBool("Taunting") == true then return end
		if v:IsHL2() then v:ConCommand("act laugh") return end
		if not v:IsOnGround() then return end
		if v:WaterLevel() ~= 0 then return end
		if v:GetInfoNum("tf_robot", 0) == 0 and v:GetInfoNum("tf_giantrobot", 0) == 0 then v:ChatPrint("You can't use this command as a human!") return end
		v:EmitSound("mvm/mvm_robo_stun.wav", 95, 100)
		timer.Create("StunRobot4", 0.001, 1, function()
			v:DoAnimationEvent(ACT_MP_STUN_BEGIN,2)
			timer.Create("StunRobotloop5", 0.5, 0, function()
				if not v:Alive() then timer.Stop("StunRobotloop") return end
				timer.Create("StunRobotloop6", 0.22, 0, function()
					if not v:Alive() then timer.Stop("StunRobotloop4") return end
					v:DoAnimationEvent(ACT_MP_STUN_MIDDLE,2)
				end)
			end)
		end)
		v:DoAnimationEvent(ACT_DOD_SECONDARYATTACK_BOLT, true)
		v:SetNWBool("Taunting", true)
		v:SetNWBool("NoWeapon", true)
		net.Start("ActivateTauntCam")
		net.Send(v)
		timer.Simple(23, function()
			if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
			v:EmitSound("misc/cp_harbor_red_whistle.wav", 95, 100)
			timer.Stop("StunRobotloop3")
			timer.Stop("StunRobotloop4")
			v:DoAnimationEvent(ACT_MP_STUN_END,2)
			timer.Simple(1, function()
				v:SetNWBool("Taunting", false)
				v:SetNWBool("NoWeapon", false)
				net.Start("DeActivateTauntCam")
				net.Send(v)
			end)
		end)
	end
end)
concommand.Add("tf_stun_me", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end
	timer.Create("StunRobot25"..ply:EntIndex(), 0.001, 1, function()
		ply:DoAnimationEvent(ACT_MP_STUN_BEGIN,2)
		timer.Create("StunRobotloop3"..ply:EntIndex(), 0.6, 0, function()
			if not ply:Alive() then timer.Stop("StunRobotloop"..ply:EntIndex()) return end 
			timer.Create("StunRobotloop4"..ply:EntIndex(), 0.8, 6, function()
				if not ply:Alive() then timer.Stop("StunRobotloop4"..ply:EntIndex()) return end
				ply:DoAnimationEvent(ACT_MP_STUN_MIDDLE,2)
			end)
		end)
	end) 
	ply:DoAnimationEvent(ACT_DOD_SECONDARYATTACK_BOLT, true)
	ply:SetNWBool("Taunting", true)  
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	timer.Simple(5, function()
		if not IsValid(ply) then return end
		timer.Stop("StunRobotloop3"..ply:EntIndex())
		timer.Stop("StunRobotloop4"..ply:EntIndex())
		ply:DoAnimationEvent(ACT_MP_STUN_END,2)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
	end)
end)
concommand.Add("tf_taunt_flipping_start", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/flip_success_initiator0.vcd", 0)
	ply:DoAnimationEvent(ACT_DOD_SECONDARYATTACK_BOLT, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	timer.Simple(time, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
	timer.Simple(0.1, function()
	for k,v in pairs(ents.FindInSphere(ply:GetPos(), 120) ) do 
		if v:IsPlayer() and v:Nick() != ply:Nick() then
			if v:GetInfoNum("tf_robot", 0) == 1 then v:ChatPrint("You can't taunt as a robot!") return end
			if v:GetInfoNum("tf_giantrobot", 0) == 1 then v:ChatPrint("You can't taunt as a mighty robot!") return end
			local time = v:PlayScene("scenes/player/"..v:GetPlayerClass().."/low/flip_success_receiver0.vcd", 0)
			v:DoAnimationEvent(ACT_DOD_PRIMARYATTACK_PRONE_BOLT, true)
			v:SetNWBool("Taunting", true)
			v:SetNWBool("NoWeapon", true)
			net.Start("ActivateTauntCam")
			net.Send(v)
			timer.Simple(time, function()
				if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
				v:SetNWBool("Taunting", false)
				v:SetNWBool("NoWeapon", false)
				net.Start("DeActivateTauntCam")
				net.Send(v)
			end)
		end
	end
	end)
end)
concommand.Add("tf_taunt_heroric", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end
	if ply:GetPlayerClass() != "medic" then 
		ply:ChatPrint("You're not medic!")
		return 
	end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:PlayScene("scenes/player/medic/low/taunt09.vcd", 0)
	ply:DoAnimationEvent(ACT_DOD_STAND_AIM_KNIFE, true)
	ply:EmitSound("player/taunt_medic_heroic.wav", 90, 100)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	timer.Simple(time, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
end)
concommand.Add("tf_taunt_highfive_success", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_highfivesuccessfull.vcd", 0)
	if ply:GetPlayerClass() != "spy" and ply:GetPlayerClass() != "engineer" then
		ply:DoAnimationEvent(ACT_DOD_CROUCHWALK_ZOOM_BOLT, true) 
	else
		ply:DoAnimationEvent(ACT_DOD_WALK_ZOOM_BOLT, true)
	end
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	ply:EmitSound("misc/high_five.wav")
	net.Start("ActivateTauntCam")
	net.Send(ply)
	timer.Simple(time, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
	for k,v in pairs(ents.FindInSphere(ply:GetPos(), 120) ) do 
		if v:IsPlayer() and v:Nick() != ply:Nick() then
			if v:IsHL2() then v:ConCommand("act laugh") return end
			if v:WaterLevel() ~= 0 then return end
			if v:GetInfoNum("tf_robot", 0) == 1 then v:ChatPrint("You can't taunt as a robot!") return end
			if v:GetInfoNum("tf_giantrobot", 0) == 1 then v:ChatPrint("You can't taunt as a mighty robot!") return end
			local time = v:PlayScene("scenes/player/"..v:GetPlayerClass().."/low/taunt_highfivesuccessfull.vcd", 0)
			if not v:GetPlayerClass() != "spy" and ply:GetPlayerClass() != "engineer" then
				v:DoAnimationEvent(ACT_DOD_CROUCHWALK_ZOOM_BOLT, true)
			else
				v:DoAnimationEvent(ACT_DOD_WALK_ZOOM_BOLT, true)
			end
			v:SetNWBool("Taunting", true)
			v:SetNWBool("NoWeapon", true)
			net.Start("ActivateTauntCam")
			net.Send(v)
			timer.Simple(time, function()
				if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
				v:SetNWBool("Taunting", false)
				v:SetNWBool("NoWeapon", false)
				net.Start("DeActivateTauntCam")
				net.Send(v)
			end)
		end
		if v.Base == "npc_tf2base" or v.Base == "npc_soldier_red" or v.Base == "npc_hwg_red" or v.Base == "npc_pyro_red" or v.Base == "npc_scout_red" then
			if v:GetNWBool("Taunting") == true then return end

			local time = v:PlayScene("scenes/player/"..v.TF2Class.."/low/taunt_highfivesuccessfull.vcd", 0)
			v:SetCycle(0)
			v:ResetSequence("taunt_hifivesuccessfull")
			v:SetNWBool("Taunting", true)
			v:SetNWBool("NoWeapon", true)
			timer.Simple(time, function()
				if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
				v:SetNWBool("Taunting", false)
				v:SetNWBool("NoWeapon", false)
				net.Start("DeActivateTauntCam")
				net.Send(v)
			end)
		end
	end
end)
concommand.Add("tf_taunt_squaredance", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_dosido_dance00.vcd", 0)
	ply:DoAnimationEvent(ACT_DOD_SECONDARYATTACK_PRONE_BOLT, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	ply:EmitSound("music/fortress_reel.wav")
	net.Start("ActivateTauntCam")
	net.Send(ply)
	timer.Simple(9, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
	for k,v in pairs(ents.FindInSphere(ply:GetPos(), 120) ) do 
		if v:IsPlayer() then
			if v:IsHL2() then v:ConCommand("act laugh") return end
			if v:GetInfoNum("tf_robot", 0) == 1 then v:ChatPrint("You can't taunt as a robot!") return end
			if v:GetInfoNum("tf_giantrobot", 0) == 1 then v:ChatPrint("You can't taunt as a mighty robot!") return end
			local time = v:PlayScene("scenes/player/"..v:GetPlayerClass().."/low/taunt_dosido_dance01.vcd", 0)
			v:DoAnimationEvent(ACT_DOD_SECONDARYATTACK_PRONE_BOLT, true)
			v:SetNWBool("Taunting", true)
			v:SetNWBool("NoWeapon", true)
			net.Start("ActivateTauntCam")
			net.Send(v)
			timer.Simple(9, function()
				if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
				v:SetNWBool("Taunting", false)
				v:SetNWBool("NoWeapon", false)
				net.Start("DeActivateTauntCam")
				net.Send(v)
			end)
		end
	end
end)
concommand.Add("tf_taunt_squaredance_intro", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:SequenceDuration("taunt_dosido_intro")
	ply:DoAnimationEvent(ACT_RUN_AIM, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	ply:EmitSound("DosidoIntro")
	net.Start("ActivateTauntCam")
	net.Send(ply)
	ply:EmitSound(""..ply:GetPlayerClass().."_taunt_dosido_intro_rand")
	timer.Create("squaredancewaiting"..ply:EntIndex(), 2, 0, function()
		ply:EmitSound(""..ply:GetPlayerClass().."_taunt_dosido_intro_wait_rand")
	end)
	timer.Create("squaredanceintro"..ply:EntIndex(), 3, 0, function()
		ply:DoAnimationEvent(ACT_RUN_AIM, true)
	end)
	timer.Create("squaredancestart"..ply:EntIndex(), 0.1, 0, function()
		if ply:KeyDown(IN_USE) then
			ply:ConCommand("tf_taunt_squaredance_intro_stop")
		end
		for k,v in ipairs(ents.FindInSphere(ply:GetPos(), 80)) do
			if v:IsPlayer() and v:Nick() != ply:Nick() then
				ply:StopSound("DosidoIntro")
				local sceusermessageime = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_dosido_dance00.vcd", 0)
				local sceusermessageime2 = v:PlayScene("scenes/player/"..v:GetPlayerClass().."/low/taunt_dosido_dance00.vcd", 0)
				ply:DoAnimationEvent(ACT_DOD_SECONDARYATTACK_PRONE_BOLT, true)
				v:DoAnimationEvent(ACT_DOD_SECONDARYATTACK_PRONE_BOLT, true)
				ply:SetNWBool("Taunting", true)
				ply:SetNWBool("NoWeapon", true)
				v:SetNWBool("Taunting", true)
				v:SetNWBool("NoWeapon", true)
				ply:EmitSound("music/fortress_reel.wav")
				net.Start("ActivateTauntCam")
				net.Send(ply)
				net.Start("ActivateTauntCam")
				net.Send(v)
				timer.Simple(sceusermessageime, function()
					if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
					ply:SetNWBool("Taunting", false)
					ply:SetNWBool("NoWeapon", false)
					net.Start("DeActivateTauntCam")
					net.Send(ply)
				end)
				timer.Simple(sceusermessageime2, function()
					if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
					v:SetNWBool("Taunting", false)
					v:SetNWBool("NoWeapon", false)
					net.Start("DeActivateTauntCam")
					net.Send(v)
				end)
				timer.Stop("squaredanceintro"..ply:EntIndex())
				timer.Stop("squaredancewaiting"..ply:EntIndex())
				timer.Stop("squaredancestart"..ply:EntIndex())
			end
		end
	end)
end)
concommand.Add("tf_taunt_flipping_intro", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:SequenceDuration(ply:LookupSequence("taunt_flip_start"))
	ply:DoAnimationEvent(ACT_COVER, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply) 
	timer.Create("squaredanceintro"..ply:EntIndex(), time, 0, function()
		ply:DoAnimationEvent(ACT_COVER, true)
	end)
	timer.Create("squaredancestart"..ply:EntIndex(), 0.1, 0, function()
		if ply:KeyDown(IN_USE) then
			ply:ConCommand("tf_taunt_squaredance_intro_stop")
		end
		for k,v in ipairs(ents.FindInSphere(ply:GetPos(), 80)) do
			if v:IsPlayer() and v:Nick() != ply:Nick() then 
				local time2 = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/flip_success_initiator0.vcd", 0)
				local time3 = v:PlayScene("scenes/player/"..v:GetPlayerClass().."/low/flip_success_receiver0.vcd", 0)
				ply:DoAnimationEvent(ACT_DOD_SECONDARYATTACK_BOLT, true)
				v:DoAnimationEvent(ACT_DOD_PRIMARYATTACK_PRONE_BOLT, true)
				ply:SetNWBool("Taunting", true)
				ply:SetNWBool("NoWeapon", true)
				v:SetNWBool("Taunting", true)
				v:SetNWBool("NoWeapon", true)
				net.Start("ActivateTauntCam")
				net.Send(ply)
				net.Start("ActivateTauntCam")
				net.Send(v)
				timer.Simple(time2, function()
					if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
					ply:SetNWBool("Taunting", false)
					ply:SetNWBool("NoWeapon", false)
					net.Start("DeActivateTauntCam")
					net.Send(ply)
				end)
				timer.Simple(time3, function()
					if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
					v:SetNWBool("Taunting", false)
					v:SetNWBool("NoWeapon", false)
					net.Start("DeActivateTauntCam")
					net.Send(v)
				end)
				timer.Stop("squaredanceintro"..ply:EntIndex())
				timer.Stop("squaredancewaiting"..ply:EntIndex())
				timer.Stop("squaredancestart"..ply:EntIndex())
			end
			if v.Base == "npc_tf2base" or v.Base == "npc_soldier_red" or v.Base == "npc_hwg_red" or v.Base == "npc_pyro_red" or v.Base == "npc_scout_red" then
				local time2 = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/flip_success_initiator0.vcd", 0)
				local time3 = v:PlayScene("scenes/player/"..v.TF2Class.."/low/flip_success_receiver0.vcd", 0)
				ply:DoAnimationEvent(ACT_DOD_SECONDARYATTACK_BOLT, true)
				v:SetCycle(0)
				v:ResetSequence("taunt_flip_success_receiver")
				ply:SetNWBool("Taunting", true)
				ply:SetNWBool("NoWeapon", true)
				timer.Simple(time2, function()
					if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
					ply:SetNWBool("Taunting", false)
					ply:SetNWBool("NoWeapon", false)
					net.Start("DeActivateTauntCam")
					net.Send(ply)
				end)
				timer.Stop("squaredanceintro"..ply:EntIndex())
				timer.Stop("squaredancewaiting"..ply:EntIndex())
				timer.Stop("squaredancestart"..ply:EntIndex())
			end
		end
	end)
end)
concommand.Add("tf_taunt_squaredance_intro", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:SequenceDuration("taunt_dosido_intro")
	ply:DoAnimationEvent(ACT_RUN_AIM, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	ply:EmitSound("DosidoIntro")
	net.Start("ActivateTauntCam")
	net.Send(ply)
	ply:EmitSound(""..ply:GetPlayerClass().."_taunt_dosido_intro_rand")
	timer.Create("squaredancewaiting"..ply:EntIndex(), 2, 0, function()
		ply:EmitSound(""..ply:GetPlayerClass().."_taunt_dosido_intro_wait_rand")
	end)
	timer.Create("squaredanceintro"..ply:EntIndex(), 3, 0, function()
		ply:DoAnimationEvent(ACT_RUN_AIM, true)
	end)
	timer.Create("squaredancestart"..ply:EntIndex(), 0.1, 0, function()
		if ply:KeyDown(IN_USE) then
			ply:ConCommand("tf_taunt_squaredance_intro_stop")
		end
		for k,v in ipairs(ents.FindInSphere(ply:GetPos(), 80)) do
			if v:IsPlayer() and v:Nick() != ply:Nick() then
				ply:StopSound("DosidoIntro")
				local sceusermessageime = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_dosido_dance00.vcd", 0)
				local sceusermessageime2 = v:PlayScene("scenes/player/"..v:GetPlayerClass().."/low/taunt_dosido_dance00.vcd", 0)
				ply:DoAnimationEvent(ACT_DOD_SECONDARYATTACK_PRONE_BOLT, true)
				v:DoAnimationEvent(ACT_DOD_SECONDARYATTACK_PRONE_BOLT, true)
				ply:SetNWBool("Taunting", true)
				ply:SetNWBool("NoWeapon", true)
				v:SetNWBool("Taunting", true)
				v:SetNWBool("NoWeapon", true)
				ply:EmitSound("music/fortress_reel.wav")
				net.Start("ActivateTauntCam")
				net.Send(ply)
				net.Start("ActivateTauntCam")
				net.Send(v)
				timer.Simple(sceusermessageime, function()
					if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
					ply:SetNWBool("Taunting", false)
					ply:SetNWBool("NoWeapon", false)
					net.Start("DeActivateTauntCam")
					net.Send(ply)
				end)
				timer.Simple(sceusermessageime2, function()
					if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
					v:SetNWBool("Taunting", false)
					v:SetNWBool("NoWeapon", false)
					net.Start("DeActivateTauntCam")
					net.Send(v)
				end)
				timer.Stop("squaredanceintro"..ply:EntIndex())
				timer.Stop("squaredancewaiting"..ply:EntIndex())
				timer.Stop("squaredancestart"..ply:EntIndex())
			end
		end
	end)
end)
concommand.Add("tf_taunt_rockpaperscissors_intro", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	ply:DoAnimationEvent(ACT_RUN_CROUCH, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("IWantToTaunt", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	ply:EmitSound(""..ply:GetPlayerClass().."_taunt_rps_start_rand")
	timer.Create("rpsintro"..ply:EntIndex(), 5, 0, function()
		ply:DoAnimationEvent(ACT_RUN_CROUCH, true)
	end)
	timer.Create("rpswaiting"..ply:EntIndex(), 3, 0, function()
		ply:EmitSound(""..ply:GetPlayerClass().."_taunt_rps_intro_wait_rand")
	end)
	timer.Create("rpsstart"..ply:EntIndex(), 0.1, 0, function()
		if ply:KeyDown(IN_USE) then
			ply:ConCommand("tf_taunt_squaredance_intro_stop")
		end
		for k,v in ipairs(ents.FindInSphere(ply:GetPos(), 80)) do
			if v:IsPlayer() and v:Nick() != ply:Nick() and v:GetNWBool("IWantToTauntToo") == true then
				if math.random(1,4) == 1 then
					local sceusermessageime = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_rps_paper_lose.vcd", 0)
					ply:DoAnimationEvent(ACT_DOD_RELOAD_DEPLOYED_FG42, true)
					ply:SetNWBool("Taunting", true)
					ply:SetNWBool("NoWeapon", true)
					net.Start("ActivateTauntCam")
					net.Send(ply)
					ply:SetNWBool("IWantToTaunt", false)
					v:SetNWBool("IWantToTauntToo", false)
					local sceusermessageime2 = v:PlayScene("scenes/player/"..v:GetPlayerClass().."/low/taunt_rps_scissors_win.vcd", 0)
					v:DoAnimationEvent(ACT_DOD_PRONEWALK_IDLE_BAR, true)
					v:SetNWBool("Taunting", true)
					v:SetNWBool("NoWeapon", true)
					net.Start("ActivateTauntCam")
					net.Send(v)
					timer.Simple(sceusermessageime, function()
						if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
						ply:SetNWBool("Taunting", false)
						ply:SetNWBool("NoWeapon", false)
						net.Start("DeActivateTauntCam")
						net.Send(ply)
					end)
					timer.Simple(sceusermessageime2, function()
						if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
						v:SetNWBool("Taunting", false)
						v:SetNWBool("NoWeapon", false)
						net.Start("DeActivateTauntCam")
						net.Send(v)
					end)
					timer.Stop("rpsintro"..ply:EntIndex())
					timer.Stop("rpsstart"..ply:EntIndex())
					timer.Stop("rpswaiting"..ply:EntIndex())
				end
				if math.random(1,4) == 2 then
					local sceusermessageime = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_rps_scissors_win.vcd", 0)
					ply:DoAnimationEvent(ACT_DOD_RELOAD_DEPLOYED_FG42, true)
					ply:SetNWBool("Taunting", true)
					ply:SetNWBool("NoWeapon", true)
					net.Start("ActivateTauntCam")
					net.Send(ply)
					ply:SetNWBool("IWantToTaunt", false)
					v:SetNWBool("IWantToTauntToo", false)
					local sceusermessageime2 = v:PlayScene("scenes/player/"..v:GetPlayerClass().."/low/taunt_rps_paper_lose.vcd", 0)
					v:DoAnimationEvent(ACT_DOD_PRONEWALK_IDLE_BAR, true)
					v:SetNWBool("Taunting", true)
					v:SetNWBool("NoWeapon", true)
					net.Start("ActivateTauntCam")
					net.Send(v)
					timer.Simple(sceusermessageime, function()
						if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
						ply:SetNWBool("Taunting", false)
						ply:SetNWBool("NoWeapon", false)
						net.Start("DeActivateTauntCam")
						net.Send(ply)
						if !v:IsFriendly(ply) then
							v:Explode()
						end
					end)
					timer.Simple(sceusermessageime2, function()
						if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
						v:SetNWBool("Taunting", false)
						v:SetNWBool("NoWeapon", false)
						net.Start("DeActivateTauntCam")
						net.Send(v)
					end)
					timer.Stop("rpsintro"..ply:EntIndex())
					timer.Stop("rpsstart"..ply:EntIndex())
					timer.Stop("rpswaiting"..ply:EntIndex())
				end
				if math.random(1,4) == 3 then
					local sceusermessageime = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_rps_rock_lose.vcd", 0)
					ply:DoAnimationEvent(ACT_DOD_RELOAD_DEPLOYED_FG42, true)
					ply:SetNWBool("Taunting", true)
					ply:SetNWBool("NoWeapon", true)
					net.Start("ActivateTauntCam")
					net.Send(ply)
					ply:SetNWBool("IWantToTaunt", false)
					v:SetNWBool("IWantToTauntToo", false)
					local sceusermessageime2 = v:PlayScene("scenes/player/"..v:GetPlayerClass().."/low/taunt_rps_paper_win.vcd", 0)
					v:DoAnimationEvent(ACT_DOD_PRONEWALK_IDLE_BAR, true)
					v:SetNWBool("Taunting", true)
					v:SetNWBool("NoWeapon", true)
					net.Start("ActivateTauntCam")
					net.Send(v)
					timer.Simple(sceusermessageime, function()
						if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
						ply:SetNWBool("Taunting", false)
						ply:SetNWBool("NoWeapon", false)
						net.Start("DeActivateTauntCam")
						net.Send(ply)
						if !ply:IsFriendly(v) then
							ply:Explode()
						end
					end)
					timer.Simple(sceusermessageime2, function()
						if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
						v:SetNWBool("Taunting", false)
						v:SetNWBool("NoWeapon", false)
						net.Start("DeActivateTauntCam")
						net.Send(v)
					end)
					timer.Stop("rpsintro"..ply:EntIndex())
					timer.Stop("rpsstart"..ply:EntIndex())
					timer.Stop("rpswaiting"..ply:EntIndex())
				end
			end
			if v.Base == "npc_tf2base" or v.Base == "npc_soldier_red" or v.Base == "npc_hwg_red" or v.Base == "npc_pyro_red" or v.Base == "npc_scout_red" then
				if math.random(1,4) == 1 then
					local sceusermessageime = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_rps_paper_lose.vcd", 0)
					ply:DoAnimationEvent(ACT_DOD_RELOAD_DEPLOYED_FG42, true)
					ply:SetNWBool("Taunting", true)
					ply:SetNWBool("NoWeapon", true)
					net.Start("ActivateTauntCam")
					net.Send(ply)
					ply:SetNWBool("IWantToTaunt", false)
					v:SetNWBool("IWantToTauntToo", false)
					local sceusermessageime2 = v:PlayScene("scenes/player/"..v.TF2Class.."/low/taunt_rps_scissors_win.vcd", 0)
					v:SetCycle(0)
					v:ResetSequence("taunt_rps_scissors_win")
					timer.Simple(sceusermessageime, function()
						if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
						ply:SetNWBool("Taunting", false)
						ply:SetNWBool("NoWeapon", false)
						net.Start("DeActivateTauntCam")
						net.Send(ply)
					end)
					timer.Simple(sceusermessageime2, function()
						if !v:IsFriendly(ply) then
							ply:Explode()
						end
					end)
					timer.Stop("rpsintro"..ply:EntIndex()) 
					timer.Stop("rpsstart"..ply:EntIndex())
					timer.Stop("rpswaiting"..ply:EntIndex())
				end
				if math.random(1,4) == 2 then
					local sceusermessageime = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_rps_scissors_win.vcd", 0)
					ply:DoAnimationEvent(ACT_DOD_RELOAD_DEPLOYED_FG42, true)
					ply:SetNWBool("Taunting", true)
					ply:SetNWBool("NoWeapon", true)
					net.Start("ActivateTauntCam")
					net.Send(ply)
					ply:SetNWBool("IWantToTaunt", false)
					v:SetNWBool("IWantToTauntToo", false)
					local sceusermessageime2 = v:PlayScene("scenes/player/"..v.TF2Class.."/low/taunt_rps_paper_lose.vcd", 0)
					v:ResetSequence("taunt_rps_scissors_win")
					v:SetCycle(0)
					timer.Simple(sceusermessageime, function()
						if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
						ply:SetNWBool("Taunting", false)
						ply:SetNWBool("NoWeapon", false)
						net.Start("DeActivateTauntCam")
						net.Send(ply)
					end)
					timer.Simple(sceusermessageime2, function()
						if !ply:IsFriendly(v) then
							v:Splatter()
						end
					end)
					timer.Stop("rpsintro"..ply:EntIndex())
					timer.Stop("rpsstart"..ply:EntIndex())
					timer.Stop("rpswaiting"..ply:EntIndex())
				end
				if math.random(1,4) == 3 then
					local sceusermessageime = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_rps_rock_lose.vcd", 0)
					ply:DoAnimationEvent(ACT_DOD_RELOAD_DEPLOYED_FG42, true)
					ply:SetNWBool("Taunting", true)
					ply:SetNWBool("NoWeapon", true)
					net.Start("ActivateTauntCam")
					net.Send(ply)
					ply:SetNWBool("IWantToTaunt", false)
					v:SetNWBool("IWantToTauntToo", false)
					local sceusermessageime2 = v:PlayScene("scenes/player/"..v.TF2Class.."/low/taunt_rps_paper_win.vcd", 0)
					v:ResetSequence("taunt_rps_scissors_win")
					v:SetCycle(0)
					timer.Simple(sceusermessageime, function()
						if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
						ply:SetNWBool("Taunting", false)
						ply:SetNWBool("NoWeapon", false)
						net.Start("DeActivateTauntCam")
						net.Send(ply)
					end)
					timer.Simple(sceusermessageime2, function()
						if !v:IsFriendly(ply) then
							ply:Explode()
						end
					end)
					timer.Stop("rpsintro"..ply:EntIndex())
					timer.Stop("rpsstart"..ply:EntIndex())
					timer.Stop("rpswaiting"..ply:EntIndex())
				end
			end
		end
	end)
end)
concommand.Add("tf_taunt_squaredance_intro_stop", function(ply)
	if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
	ply:SetNWBool("Taunting", false)
	ply:SetNWBool("NoWeapon", false)
	net.Start("DeActivateTauntCam")
	ply:StopSound("DosidoIntro")
	net.Send(ply)
	timer.Stop("squaredanceintro"..ply:EntIndex())
	timer.Stop("squaredancestart"..ply:EntIndex())
	timer.Stop("squaredancewaiting"..ply:EntIndex())
end)
concommand.Add("tf_taunt_rockpaperscissors_intro_stop", function(ply)
	if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
	ply:SetNWBool("Taunting", false)
	ply:SetNWBool("NoWeapon", false)
	net.Start("DeActivateTauntCam")
	ply:StopSound("DosidoIntro")
	net.Send(ply)
	timer.Stop("rpsintro"..ply:EntIndex())
	timer.Stop("rpswaiting"..ply:EntIndex())
	timer.Stop("rpsstart"..ply:EntIndex())
end)
concommand.Add("tf_taunt_rockpaperscissors", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giant_robot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/"..table.Random(rockpaperscissors)..".vcd", 0)
	ply:DoAnimationEvent(table.Random(rockpaperscissorsact), true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	timer.Simple(7, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
	for k,v in pairs(ents.FindInSphere(ply:GetPos(), 120) ) do 
		if v:IsPlayer() and v:Nick() != ply:Nick() then
			if v:IsHL2() then v:ConCommand("act laugh") return end
			if v:GetInfoNum("tf_robot", 0) == 1 then v:ChatPrint("You can't taunt as a robot!") return end
			if v:GetInfoNum("tf_giantrobot", 0) == 1 then v:ChatPrint("You can't taunt as a mighty robot!") return end
			local time = v:PlayScene("scenes/player/"..v:GetPlayerClass().."/low/"..table.Random(rockpaperscissors)..".vcd", 0)
			v:DoAnimationEvent(table.Random(rockpaperscissorsact), true)
			v:SetNWBool("Taunting", true)
			v:SetNWBool("NoWeapon", true)
			net.Start("ActivateTauntCam")
			net.Send(v)
			timer.Simple(7, function()
				if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then return end
				v:SetNWBool("Taunting", false)
				v:SetNWBool("NoWeapon", false)
				net.Start("DeActivateTauntCam")
				net.Send(v)
			end)
		end
	end
end)

concommand.Add("tf_taunt", function(ply,cmd,args)
	if ply:IsHL2() then return end
	if ply:GetNWBool("Taunting") == true then return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetPlayerClass() == "combinesoldier" then
		EmitSentence( "COMBINE_THROW_GRENADE" .. math.random( 0, 4 ), ply:GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
	end
	--[[if ply:GetInfoNum("tf_robot", 0) == 1 then ply:ChatPrint("You can't taunt as a robot!") return end
	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end]]
	if not table.HasValue(allowedtaunts, args[1]) then return end
	for k,v in ipairs(ents.FindInSphere(ply:GetPos(), 120)) do
		if v:GetNWBool("IWantToTaunt") ==  true then
			v:SetNWBool("IWantToTauntToo", true)
		end
	end
	if ply:GetPlayerClass() != "spy" then
		if table.KeyFromValue(allowedtaunts,args[1]) == 1 then
	
			if ply:GetWeapons()[1]:GetClass() == "weapon_crowbar" then
			
				ply:SelectWeapon(ply:GetWeapons()[1]:GetClass())
				ply:DoAnimationEvent(ACT_GMOD_TAUNT_LAUGH, true)
	
			elseif ply:GetPlayerClass() == "combinesoldier" then
				ply:DoAnimationEvent(ACT_SPECIAL_ATTACK1, true)
				ply:SetNWBool("Taunting", true)
				ply:SetNWBool("NoWeapon", true) 
				local frag = ents.Create("npc_grenade_frag")
				net.Start("ActivateTauntCam")
				net.Send(ply)
				frag:SetPos(ply:EyePos() + ( ply:GetAimVector() * 16 ) )
				frag:SetAngles( ply:EyeAngles() )
				frag:SetOwner(ply)

				timer.Simple(0.6, function()
					frag:Spawn()
					
					local phys = frag:GetPhysicsObject()
						if ( !IsValid( phys ) ) then frag:Remove() return end
						
						
						
						local velocity = ply:GetAimVector()
						velocity = velocity * 1000
						velocity = velocity + ( VectorRand() * 10 ) -- a random element
						phys:ApplyForceCenter( velocity )
						frag:Fire("SetTimer",5,0)
						frag:SetOwner(ply)
						--timer.Simple(3.5,function() frag:Ignite() end)
				end)
				timer.Simple(1.2, function()
					if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
					ply:SetNWBool("Taunting", false)
					ply:SetNWBool("NoWeapon", false)
					print("Taunt Finished")
					net.Start("DeActivateTauntCam")
					net.Send(ply)
				end)
					
			end
			
			if ply:GetPlayerClass() == "pyro" then
				if ply:GetWeapons()[1]:GetItemData().model_player == "models/weapons/c_models/c_rainblower/c_rainblower.mdl" then
					ply:SelectWeapon(ply:GetWeapons()[1]:GetClass())
					ply:DoAnimationEvent(ACT_90_RIGHT, true)
					ply:EmitSound("player/taunt_pyro_hellicorn.wav", 100)
					timer.Simple(3.15, function()
						ply:EmitSound("tf/weapons/explode1.wav")
						for k,v in pairs(ents.FindInSphere(ply:GetPos(), 90)) do 
							if v:IsTFPlayer() and not v:IsFriendly(ply) then
								v:TakeDamage(500, ply, ply)
							end
						end
					end)
				else
				
					ply:SelectWeapon(ply:GetWeapons()[1]:GetClass())
					ply:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)		
				end

			elseif ply:GetPlayerClass() == "sniper" then
				if ply:GetWeapons()[1]:GetClass() == "tf_weapon_compound_bow" then
					ply:SelectWeapon(ply:GetWeapons()[1]:GetClass())
					ply:DoAnimationEvent(ACT_DOD_CROUCH_IDLE_PISTOL, true)
					ply:SetNWBool("Taunting", true)
					ply:SetNWBool("NoWeapon", true)
					ply:GetActiveWeapon().NameOverride = "taunt_sniper" 
					timer.Simple(0.8, function()
						for k,v in pairs(ents.FindInSphere(ply:GetPos(), 90)) do 
							if v:IsTFPlayer() and not v:IsPlayer() and not v:IsFriendly(ply) then
								v:TakeDamage(50, ply, ply)
							elseif v:IsPlayer() and not v:IsFriendly(ply) then
								v:ConCommand("tf_stun_me")
								v:TakeDamage(50, ply, ply)
							end
						end
					end)
					timer.Simple(2.3, function()
						for k,v in pairs(ents.FindInSphere(ply:GetPos(), 90)) do 
							if v:IsTFPlayer() and not v:IsPlayer() and not v:IsFriendly(ply) then
								v:TakeDamage(500, ply, ply)
							elseif v:IsPlayer() and not v:IsFriendly(ply) then
								v:TakeDamage(500, ply, ply)
							end
						end
					end)
				else					
					ply:SelectWeapon(ply:GetWeapons()[1]:GetClass())
					ply:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)
				end
			elseif ply:GetPlayerClass() == "heavy" then
				if ply:GetInfoNum("tf_robot", 0) == 1 and table.KeyFromValue(allowedtaunts,args[1]) == 1 then
					timer.Simple(2, function()
						ply:EmitSound("vo/mvm/norm/heavy_mvm_goodjob0"..math.random(1,3)..".wav", 95, 100)
					end)
					timer.Simple(8, function()
						if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
						ply:SetNWBool("Taunting", false)
						ply:SetNWBool("NoWeapon", false)
						print("Taunt Finished")
						net.Start("DeActivateTauntCam")
						net.Send(ply)
					end)
				else
			ply:SelectWeapon(ply:GetWeapons()[1]:GetClass())
			ply:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)				
				end
			elseif ply:GetPlayerClass() == "medic" then
				if ply:GetInfoNum("tf_robot", 0) == 1 and table.KeyFromValue(allowedtaunts,args[1]) == 1 then
					timer.Simple(0.1, function()
						ply:EmitSound("vo/mvm/norm/medic_mvm_specialcompleted01.wav", 95, 100)
					end)
					timer.Simple(3, function()
						ply:EmitSound("player/taunt_rubberglove_snap.wav")
					end)
					timer.Simple(1, function()
						ply:EmitSound("player/taunt_rubberglove_stretch.wav")
					end)
					timer.Simple(6, function()
						if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
						ply:SetNWBool("Taunting", false)
						ply:SetNWBool("NoWeapon", false)
						print("Taunt Finished")
						net.Start("DeActivateTauntCam")
						net.Send(ply)
					end)
				else				
					ply:SelectWeapon(ply:GetWeapons()[1]:GetClass())
					ply:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)		
			end
			elseif ply:GetPlayerClass() == "soldier" then
				if ply:GetInfoNum("tf_robot", 0) == 1 and table.KeyFromValue(allowedtaunts,args[1]) == 1 then
					timer.Simple(1.6, function()
						ply:EmitSound("vo/mvm/norm/taunts/soldier_mvm_taunts01.wav", 95, 100)
					end)
					timer.Simple(3, function()
						if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
						ply:SetNWBool("Taunting", false)
						ply:SetNWBool("NoWeapon", false)
						print("Taunt Finished")
						net.Start("DeActivateTauntCam")
						net.Send(ply)
					end)
				elseif ply:GetInfoNum("tf_robot", 0) == 1 and table.KeyFromValue(allowedtaunts,args[1]) == 2 then
					timer.Simple(3, function()
						ply:EmitSound("vo/mvm/norm/soldier_mvm_cheers0"..math.random(5,6)..".wav", 95, 100)
					end)
					timer.Simple(5, function()
						if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
						ply:SetNWBool("Taunting", false)
						ply:SetNWBool("NoWeapon", false)
						print("Taunt Finished")
						net.Start("DeActivateTauntCam")
						net.Send(ply)
					end)
				elseif ply:GetInfoNum("tf_robot", 0) == 1 and table.KeyFromValue(allowedtaunts,args[1]) == 3 then
					timer.Simple(0.1, function()
						ply:EmitSound("vo/mvm/norm/soldier_mvm_directhittaunt02.wav", 95, 100)
					end)
					timer.Simple(5, function()
						if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
						ply:SetNWBool("Taunting", false)
						ply:SetNWBool("NoWeapon", false)
						print("Taunt Finished")
						net.Start("DeActivateTauntCam")
						net.Send(ply)
					end)
				else
					if ply:GetWeapons()[1]:GetClass() == "tf_weapon_rocketlauncher_dh" then
						ply:SelectWeapon(ply:GetWeapons()[1]:GetClass())
						ply:DoAnimationEvent(ACT_DOD_RELOAD_DEPLOYED, true)	
					else
						ply:SelectWeapon(ply:GetWeapons()[1]:GetClass())
						ply:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)		
					end
				end
			
			elseif ply:GetPlayerClass() == "demoman" then
				if ply:GetWeapons()[1]:GetClass() == "tf_weapon_grenadelauncher" then
					ply:PlayScene("scenes/player/demoman/low/taunt08.vcd")
					ply:DoAnimationEvent(ACT_DOD_CROUCHWALK_AIM_MP40, true)
					ply:SelectWeapon(ply:GetWeapons()[1]:GetClass())
				else
					ply:DoAnimationEvent(ACT_DOD_CROUCHWALK_AIM_MP40, true)
					ply:SelectWeapon(ply:GetWeapons()[1]:GetClass())				
				end
			elseif ply:GetPlayerClass() == "engineer" then
				if ply:GetWeapons()[1]:GetClass() == "tf_weapon_sentry_revenge" then
					ply:SelectWeapon(ply:GetWeapons()[1]:GetClass())
					ply:DoAnimationEvent(ACT_DOD_RELOAD_DEPLOYED, true)
					ply:PlayScene("scenes/player/engineer/low/taunt07.vcd")
					ply:SetNWBool("Taunting", true)
					ply:SetNWBool("NoWeapon", true)
					ply:GetActiveWeapon().NameOverride = "taunt_guitar_kill"
					local animent2 = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
					animent2:SetModel("models/player/items/engineer/guitar.mdl") 
					animent2:SetAngles(ply:GetAngles())
					animent2:SetPos(ply:GetPos())
					animent2:Spawn()
					animent2:Activate()
					animent2:SetParent(ply)
					animent2:AddEffects(EF_BONEMERGE)
					animent2:SetName("GuitarModel"..ply:EntIndex())
					timer.Simple(1.5, function()
						ply:EmitSound("player/taunt_eng_strum.wav")
					end)
					timer.Simple(4.2, function()
						if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
						ply:SetNWBool("Taunting", false)
						ply:SetNWBool("NoWeapon", false)
						print("Taunt Finished")
						net.Start("DeActivateTauntCam")
						net.Send(ply)
						animent2:Fire("Kill", "", 0.1)
					end)
					timer.Simple(3.7, function()
						ply:EmitSound("player/taunt_eng_smash"..math.random(1,3)..".wav")
						for k,v in pairs(ents.FindInSphere(ply:GetPos(), 90)) do 
							if v:IsNPC() and not v:IsFriendly(ply) then
								v:TakeDamage(500, ply, ply)
							elseif v:IsPlayer() and not v:IsFriendly(ply) then
								v:TakeDamage(500, ply, ply)
							end
						end
					end)
				else					
					ply:SelectWeapon(ply:GetWeapons()[1]:GetClass())
					ply:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)
				end
			else
			
			ply:SelectWeapon(ply:GetWeapons()[1]:GetClass())
			ply:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)
			end
		elseif table.KeyFromValue(allowedtaunts,args[1]) == 2 then
	
			if ply:GetPlayerClass() == "combinesoldier" then
				ply:DoAnimationEvent(ACT_SPECIAL_ATTACK1, true)
				ply:SetNWBool("Taunting", true)
				ply:SetNWBool("NoWeapon", true) 
				local frag = ents.Create("npc_grenade_frag")
				net.Start("ActivateTauntCam")
				net.Send(ply)
				frag:SetPos(ply:EyePos() + ( ply:GetAimVector() * 16 ) )
				frag:SetAngles( ply:EyeAngles() )
				frag:SetOwner(ply)
				timer.Simple(0.6, function()
					frag:Spawn()
					
					local phys = frag:GetPhysicsObject()
						if ( !IsValid( phys ) ) then frag:Remove() return end
						
						
						
						local velocity = ply:GetAimVector()
						velocity = velocity * 1000
						velocity = velocity + ( VectorRand() * 10 ) -- a random element
						phys:ApplyForceCenter( velocity )
						frag:Fire("SetTimer",5,0)
						frag:SetOwner(ply)
						--timer.Simple(3.5,function() frag:Ignite() end)
				end)
				timer.Simple(1.2, function()
					if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
					ply:SetNWBool("Taunting", false)
					ply:SetNWBool("NoWeapon", false)
					print("Taunt Finished")
					net.Start("DeActivateTauntCam")
					net.Send(ply)
				end)
					 

			elseif ply:GetPlayerClass() == "demoman" then
				if ply:GetWeapons()[2]:GetItemData().model_player == "models/weapons/c_models/c_scottish_resistance/c_scottish_resistance.mdl" then
					ply:SelectWeapon(ply:GetWeapons()[2]:GetClass())
					ply:DoAnimationEvent(ACT_SIGNAL2)
				else
					ply:SelectWeapon(ply:GetWeapons()[2]:GetClass())
					ply:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)
				end
			elseif ply:GetPlayerClass() == "soldier" then
				ply:SelectWeapon(ply:GetWeapons()[2]:GetClass())
				ply:DoAnimationEvent(ACT_DOD_SPRINT_AIM_SPADE, true)
			elseif ply:GetPlayerClass() == "pyro" then
				if ply:GetWeapons()[2]:GetClass() == "tf_weapon_flaregun" then
					ply:SelectWeapon(ply:GetWeapons()[2]:GetClass())
					ply:DoAnimationEvent(ACT_RUN_HURT,true)
					timer.Simple(2, function()
						ply:GetWeapons()[2]:PrimaryAttack()
						ply:GetWeapons()[2]:ShootEffects()
					end)
					timer.Simple(4, function()
						if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
						ply:SetNWBool("Taunting", false)
						ply:SetNWBool("NoWeapon", false)
						print("Taunt Finished")
						net.Start("DeActivateTauntCam")
						net.Send(ply)
					end)
				else
					ply:GetActiveWeapon().NameOverride = "taunt_pyro"
					timer.Simple(1.8, function()
						for k,v in pairs(ents.FindInSphere(ply:GetPos(), 90)) do 
							if v:IsTFPlayer() and not v:IsFriendly(ply) then
								GAMEMODE:IgniteEntity(v, ply:GetActiveWeapon(), ply, 10)
							end
						end
					end)
					timer.Simple(2, function()
						for k,v in pairs(ents.FindInSphere(ply:GetPos(), 90)) do 
							if v:IsTFPlayer() and not v:IsFriendly(ply) then
								v:TakeDamage(500, ply, ply)
							end
						end
					end)
				
				ply:SelectWeapon(ply:GetWeapons()[2]:GetClass())
				ply:DoAnimationEvent(ACT_DOD_CROUCHWALK_AIM_MP40, true)
				
				end
			else
			ply:SelectWeapon(ply:GetWeapons()[2]:GetClass())
			ply:DoAnimationEvent(ACT_DOD_CROUCHWALK_AIM_MP40, true)
			end
		elseif table.KeyFromValue(allowedtaunts,args[1]) == 3 then	
			if ply:GetPlayerClass() == "pyro" then
				if ply:GetWeapons()[3]:GetClass() == "tf_weapon_neonsign" then
					ply:EmitSound("player/sign_bass_solo.wav", 95, 100)
				end
				ply:SelectWeapon(ply:GetWeapons()[3]:GetClass())
				ply:DoAnimationEvent(ACT_DOD_STAND_AIM_30CAL, true)
			end
			if ply:GetPlayerClass() == "soldier" then
				if ply:GetWeapons()[3]:GetClass() == "tf_weapon_pickaxe" then
					ply:GetWeapons()[3].NameOverride = "taunt_soldier"
					timer.Simple(3.5, function()
						if !ply:Alive() then return end
						for k,v in pairs(ents.FindInSphere(ply:GetPos(), 90)) do 
							if v:IsNPC() and not v:IsFriendly(ply) then
								local d = DamageInfo()
								d:SetDamage( v:Health() )
								d:SetAttacker( ply )
								d:SetInflictor( ply:GetWeapons()[3] )
								d:SetDamageType( DMG_BLAST )
								v:TakeDamageInfo( d )
								v:EmitSound("BaseExplosionEffect.Sound")
							elseif v:IsPlayer() and not v:IsFriendly(ply) then
								local d = DamageInfo()
								d:SetDamage( v:Health() )
								d:SetAttacker( ply )
								d:SetInflictor( ply:GetWeapons()[3] )
								d:SetDamageType( DMG_BLAST )
								v:TakeDamageInfo( d )
								v:EmitSound("BaseExplosionEffect.Sound")
							end
						end
						timer.Simple(0.3, function()
						
							ply:EmitSound("BaseExplosionEffect.Sound")
							local dmg = DamageInfo()
							dmg:SetDamage( ply:Health() )
							dmg:SetAttacker( ply )
							dmg:SetInflictor( ply:GetWeapons()[3] )
							dmg:SetDamageType( DMG_BLAST )
							ply:TakeDamageInfo( dmg )
						end)
					end)
					ply:SelectWeapon(ply:GetWeapons()[3]:GetClass())
					ply:DoAnimationEvent(ACT_COVER_LOW, true)
				else
					ply:SelectWeapon(ply:GetWeapons()[3]:GetClass())
					ply:DoAnimationEvent(ACT_DOD_STAND_AIM_30CAL, true)
				end
			elseif ply:GetPlayerClass() == "heavy" then
				ply:GetActiveWeapon().NameOverride = "taunt_heavy"
				timer.Simple(1.7, function()
					if ply:GetEyeTrace().Entity:IsNPC() and not ply:GetEyeTrace().Entity:IsFriendly(ply) then
						ply:GetEyeTrace().Entity:TakeDamage(500, ply, ply)
					elseif ply:GetEyeTrace().Entity:IsPlayer() and not ply:GetEyeTrace().Entity:IsFriendly(ply) then
						ply:GetEyeTrace().Entity:TakeDamage(500, ply, ply)
					end
				end)
				
				ply:SelectWeapon(ply:GetWeapons()[3]:GetClass())
				ply:DoAnimationEvent(ACT_DOD_STAND_AIM_30CAL, true)
			elseif ply:GetPlayerClass() == "scout" then
				if ply:GetWeapons()[3]:GetClass() == "tf_weapon_bat_wood" then
					ply:GetActiveWeapon().NameOverride = "taunt_scout"
					timer.Simple(4.2, function()
						for k,v in pairs(ents.FindInSphere(ply:GetPos(), 90)) do 
							if v:IsTFPlayer() and not v:IsFriendly(ply) then
								v:TakeDamage(500, ply, ply)
								v:EmitSound("player/pl_impact_stun_range.wav", 95)
							end
						end
					end)
					ply:SelectWeapon(ply:GetWeapons()[3]:GetClass())
					ply:DoAnimationEvent(ACT_COVER_LOW, true)
				else
					ply:SelectWeapon(ply:GetWeapons()[3]:GetClass())
					ply:DoAnimationEvent(ACT_DOD_STAND_AIM_30CAL, true)				
				end
			elseif ply:GetPlayerClass() == "medic" then
				timer.Simple(0.3, function()
				if ply:GetWeapons()[3]:GetItemData().model_player == "models/weapons/c_models/c_uberneedle/c_uberneedle.mdl" then
					ply:EmitSound("player/ubertaunt_v0"..math.random(1,7)..".wav", 95, 100)
				elseif ply:GetWeapons()[3]:GetItemData().model_player != "models/weapons/c_models/c_ubersaw/c_ubersaw.mdl" then
					ply:EmitSound("player/taunt_v0"..math.random(1,7)..".wav", 95, 100)
				end
				end)

				if ply:GetWeapons()[3]:GetItemData().model_player == "models/weapons/c_models/c_ubersaw/c_ubersaw.mdl" then
					timer.Simple(2, function()
						ply:GetActiveWeapon().NameOverride = "taunt_sniper"
						for k,v in pairs(ents.FindInSphere(ply:GetPos(), 90)) do 
							if v:IsTFPlayer() and not v:IsPlayer() and not v:IsFriendly(ply) then
								local d = DamageInfo()
								d:SetDamage( 50 )
								d:SetAttacker( ply )
								d:SetInflictor( ply:GetActiveWeapon() )
								d:SetDamageType( DMG_CLUB )
								v:TakeDamage( d )
							elseif v:IsPlayer() and not v:IsFriendly(ply) then
								local d = DamageInfo()
								d:SetDamage( 50 )
								d:SetAttacker( ply )
								d:SetInflictor( ply:GetActiveWeapon() )
								d:SetDamageType( DMG_CLUB )
								v:TakeDamageInfo( d )
								v:ConCommand("tf_stun_me")
							end
						end
					end)

					timer.Simple(2.89, function()
						for k,v in pairs(ents.FindInSphere(ply:GetPos(), 90)) do 
							if v:IsTFPlayer() and not v:IsPlayer() and not v:IsFriendly(ply) then
								local d = DamageInfo()
								d:SetDamage( 500 )
								d:SetAttacker( ply )
								d:SetInflictor( ply:GetActiveWeapon() )
								d:SetDamageType( DMG_CLUB )
								v:TakeDamageInfo( d )
							elseif v:IsPlayer() and not v:IsFriendly(ply) then
								local d = DamageInfo()
								d:SetDamage( 500 )
								d:SetAttacker( ply )
								d:SetInflictor( ply:GetActiveWeapon() )
								d:SetDamageType( DMG_CLUB )
								v:TakeDamageInfo( d )
							end
						end
					end)
					ply:PlayScene("scenes/player/medic/low/taunt08.vcd")
					ply:SelectWeapon(ply:GetWeapons()[3]:GetClass())
					ply:DoAnimationEvent(ACT_SIGNAL2, true)
				else
					
					ply:SelectWeapon(ply:GetWeapons()[3]:GetClass())
					ply:DoAnimationEvent(ACT_DOD_STAND_AIM_30CAL, true)

				end
			elseif ply:GetPlayerClass() == "demoman" then
				if ply:GetWeapons()[3]:GetClass() == "tf_weapon_sword" or ply:GetWeapons()[3]:GetClass() == "tf_weapon_katana" then
					ply:GetActiveWeapon().NameOverride = "taunt_demoman"
					timer.Simple(2.5, function()
						for k,v in pairs(ents.FindInSphere(ply:GetPos(), 90)) do 
							if v:IsTFPlayer() and not v:IsFriendly(ply) then
								v:AddDeathFlag(DF_DECAP)
								v:TakeDamage(500, ply, ply)
							end
						end
					end)
					ply:SelectWeapon(ply:GetWeapons()[3]:GetClass())
					ply:DoAnimationEvent(ACT_DOD_STAND_AIM_KNIFE, true)
				else
					ply:SelectWeapon(ply:GetWeapons()[3]:GetClass())
					ply:DoAnimationEvent(ACT_DOD_STAND_AIM_30CAL, true)
				end
			else
				
				ply:SelectWeapon(ply:GetWeapons()[3]:GetClass())
				ply:DoAnimationEvent(ACT_DOD_STAND_AIM_30CAL, true)
				
			end
		end
		
	else
		if table.KeyFromValue(allowedtaunts,args[1]) == 1 then
			ply:SelectWeapon(ply:GetWeapons()[1]:GetClass())
			ply:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)
		elseif table.KeyFromValue(allowedtaunts,args[1]) == 3 then
			timer.Simple(2, function()
				for k,v in pairs(ents.FindInSphere(ply:GetPos(), 90)) do 
					if v:IsTFPlayer() and not v:IsFriendly(ply) then
						v:TakeDamage(10, ply, ply)
						ply:GetActiveWeapon().NameOverride = "taunt_spy"
					end
				end
			end)		
			timer.Simple(2.5, function()
				for k,v in pairs(ents.FindInSphere(ply:GetPos(), 90)) do 
					if v:IsTFPlayer() and not v:IsFriendly(ply) then
						v:TakeDamage(10, ply, ply)
						ply:GetActiveWeapon().NameOverride = "taunt_spy"
					end
				end
			end)	
			timer.Simple(4, function()
				for k,v in pairs(ents.FindInSphere(ply:GetPos(), 90)) do 
					if v:IsTFPlayer() and not v:IsFriendly(ply) then
						v:TakeDamage(500, ply, ply)
						ply:GetActiveWeapon().NameOverride = "taunt_spy"
					end
				end
			end)			
			ply:SelectWeapon(ply:GetWeapons()[2]:GetClass())
			ply:DoAnimationEvent(ACT_DOD_STAND_AIM_30CAL, true)
		elseif table.KeyFromValue(allowedtaunts,args[1]) == 4 then
			ply:SelectWeapon(ply:GetWeapons()[3]:GetClass())
			ply:DoAnimationEvent(ACT_DOD_SPRINT_AIM_SPADE, true)
		end		
	end
	ply:Taunt("TLK_PLAYER_TAUNT")
	ply:SetNWBool("Taunting", true)
	if IsValid(ply:GetActiveWeapon()) and table.HasValue(wep, ply:GetActiveWeapon():GetClass()) then ply:SetNWBool("NoWeapon", true) end
	net.Start("ActivateTauntCam")
	net.Send(ply)
	
	if ply:GetPlayerClass() != "combinesoldier" then
		print(ply:GetNWBool("SpeechTime"))
		timer.Simple(ply:GetNWBool("SpeechTime"), function()
			if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
			ply:SetNWBool("Taunting", false)
			ply:SetNWBool("NoWeapon", false)
			print("Taunt Finished")
			net.Start("DeActivateTauntCam")
			net.Send(ply)
			if !ply:IsHL2() then
				ply:GetActiveWeapon().NameOverride = ply:GetActiveWeapon():GetItemData().item_iconname
			end
		end)
	end
end)
concommand.Add("tf_taunt_scary", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:PlayScene("scenes/player/heavy/low/taunt07_halloween.vcd", 0)
	ply:DoAnimationEvent(ACT_DOD_CROUCH_AIM_RIFLE, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	timer.Simple(time, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
end)
concommand.Add("tf_taunt_drg", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end
	local time = CurTime() + 3.5
	ply:DoAnimationEvent(ACT_DOD_PRIMARYATTACK_BOLT, true)
	ply:SetNWBool("Taunting", true)
	ply:SelectWeapon(ply:GetWeapons()[3])
	net.Start("ActivateTauntCam")
	net.Send(ply)
	ply:EmitSound("weapons/drg_wrench_teleport.wav", 100, 100)
	timer.Simple(2, function()
		ParticleEffect("teleportedin_red", ply:GetPos(), ply:GetAngles(), ply)
		ply:SetFOV(50)		
		ply:ScreenFade( SCREENFADE.IN, Color( 255, 255, 255, 150 ), 0.8, 0.65 )
		ply:EmitSound("weapons/teleporter_send.wav", 100, 100)
	end)
	timer.Simple(2.02, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		for k,v in ipairs(ents.FindByClass("obj_teleporter")) do
			if string.find(game.GetMap(), "mvm_") then
				if v:GetOwner() == ply then
					ply:SetPos(v:GetPos() + Vector(0, 30, 0))
					ply:SetFOV(0, 0.3)
				end
			else
				if v:IsExit() and v:GetOwner() == ply then
					ply:SetPos(v:GetPos() + Vector(0, 30, 0))
					ply:SetFOV(0, 0.3)
				end
			end
		end
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
end)
concommand.Add("tf_taunt_drg_spawn", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end
	local time = CurTime() + 3.5
	ply:DoAnimationEvent(ACT_DOD_PRIMARYATTACK_BOLT, true)
	ply:SetNWBool("Taunting", true)
	ply:SelectWeapon(ply:GetWeapons()[3])
	net.Start("ActivateTauntCam")
	net.Send(ply)
	ply:EmitSound("weapons/drg_wrench_teleport.wav", 100, 100)
	timer.Simple(2, function()
		ParticleEffect("teleportedin_red", ply:GetPos(), ply:GetAngles(), ply)
		ply:SetFOV(50)		
		ply:ScreenFade( SCREENFADE.IN, Color( 255, 255, 255, 150 ), 0.8, 0.65 )
		ply:EmitSound("weapons/teleporter_send.wav", 100, 100)
	end)
	timer.Simple(2.02, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		ply:SetFOV(0, 0.3)
		for k,v in ipairs(ents.FindByClass("info_player_teamspawn")) do
			if ply:Team() == TEAM_BLU then
				if v:GetKeyValues()["TeamNum"] == 3 then
					ply:SetPos(v:GetPos())
				end
			elseif ply:Team() == TEAM_RED then
				if v:GetKeyValues()["TeamNum"] == 2 then
					ply:SetPos(v:GetPos())
				end
			elseif ply:Team() == TEAM_NEUTRAL then
				if v:GetKeyValues()["TeamNum"] == 2 then
					ply:SetPos(v:GetPos())
				end
			else
				if v:GetKeyValues()["TeamNum"] == 3 then
					ply:SetPos(v:GetPos())
				end
			end
		end
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
end)
concommand.Add("tf_taunt_scary_demo", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:PlayScene("scenes/player/demoman/low/taunt11.vcd", 0)
	ply:DoAnimationEvent(ACT_DOD_WALK_IDLE_MP44, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	net.Start("ActivateTauntCam")
	net.Send(ply)
	timer.Simple(time, function()
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
end)
concommand.Add("tf_taunt_brutallegend", function(ply)
	if ply:GetNWBool("Taunting") == true then return end
	if ply:IsHL2() then ply:ConCommand("act laugh") return end
	if not ply:IsOnGround() then return end
	if ply:WaterLevel() ~= 0 then return end

	if ply:GetInfoNum("tf_giantrobot", 0) == 1 then ply:ChatPrint("You can't taunt as a mighty robot!") return end
	local time = ply:PlayScene("scenes/player/"..ply:GetPlayerClass().."/low/taunt_brutallegend.vcd", 0)
	ply:DoAnimationEvent(ACT_DOD_WALK_AIM_PSCHRECK, true)
	ply:SetNWBool("Taunting", true)
	ply:SetNWBool("NoWeapon", true)
	ply:EmitSound("player/brutal_legend_taunt.wav")
	net.Start("ActivateTauntCam")
	net.Send(ply)
	local animent2 = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
	if ply:GetPlayerClass() == "heavy" then
	animent2:SetModel("models/player/items/heavy/brutal_guitar_xl.mdl") 
	else
	animent2:SetModel("models/workshop_partner/player/items/taunts/brutal_guitar/brutal_guitar.mdl") 	
	end
	animent2:SetAngles(ply:GetAngles())
	animent2:SetPos(ply:GetPos())
	animent2:Spawn()
	animent2:Activate()
	animent2:SetParent(ply)
	animent2:AddEffects(EF_BONEMERGE)
	animent2:SetName("BanjoModel"..ply:EntIndex())
	timer.Simple(time, function()
		for k,v in ipairs(ents.FindByName("BanjoModel"..ply:EntIndex())) do
			v:Remove()
		end
		if not IsValid(ply) or (not ply:Alive() and not ply:GetNWBool("Taunting")) then return end
		ply:SetNWBool("Taunting", false)
		ply:SetNWBool("NoWeapon", false)
		net.Start("DeActivateTauntCam")
		net.Send(ply)
	end)
end)


concommand.Add("tf_taunt1_var", function(ply,cmd,args)
	if ply:IsHL2() then return end
	if SERVER and ply:IsSuperAdmin() then
	ply:Taunt("TLK_PLAYER_TAUNT")
	end
end)