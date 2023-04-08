if CLIENT then return end

function getNPCs()
	local npcs = {}
	for k,v in ipairs(ents.GetAll()) do
		if (v:IsNPC() or v:IsNextBot()) then
			if (v:Health() > 1) then
				table.insert(npcs, v)
			end
		end
	end
	return npcs
end
function getAllPlayersButNotThisGuy(ply)
	local npcs = {}
	for k,v in ipairs(ents.GetAll()) do
		if (v:IsTFPlayer() and v:EntIndex() != ply:EntIndex()) then
			if (v:Health() > 1) then
				table.insert(npcs, v)
			end
		end
	end
	return npcs
end
function lookForNextPlayer(ply,bot)
	local npcs = {}
	for k,v in ipairs(ents.GetAll()) do
		if (v:IsTFPlayer() and v:EntIndex() != ply:EntIndex() and v:EntIndex() != bot:EntIndex()) then
			if (v:Health() > 1) then
				table.insert(npcs, v)
			end
		end
	end
	return npcs
end

concommand.Add("tf_spectate", function(ply, _, args)
	if (!ply:Alive()) then return end
	for k,v in ipairs(player.GetAll()) do
		if (k < 2 and v:Team() == TEAM_SPECTATOR) then
			GAMEMODE.round_active = false
		end
	end
	if args[1] == "2" then ply:Spectate(OBS_MODE_CHASE) ply.SpectateMode = 2 return
	elseif args[1] == "1" then ply:Spectate(OBS_MODE_IN_EYE) ply.SpectateMode = 1 return
	elseif args[1] == "3" then ply:Spectate(OBS_MODE_ROAMING) ply.SpectateMode = 3 return
	elseif args[1] == "-1" then ply:UnSpectate() ply:SetTeam(TEAM_RED) ply.IsSpectating = false ply:KillSilent() ply:Spawn() return end

	ply:StripWeapons()

	--if SERVER then
		--PrintMessage(HUD_PRINTTALK, 'Player '.. ply:Nick() ..	' joined team SPECTATOR')
	--end
	
	local bot = table.Random(getAllPlayersButNotThisGuy(ply),getNPCs())
	if (IsValid(bot)) then
		if (bot:EntIndex() == ply:EntIndex()) then
			bot = table.Random(getAllPlayersButNotThisGuy(ply),getNPCs())
		end
		if (ply:GetObserverTarget():EntIndex() == bot:EntIndex()) then
			bot = table.Random(lookForNextPlayer(ply,ply:GetObserverTarget()),getNPCs())
		end
	end
	ply:SetTeam(TEAM_SPECTATOR)
	--ply:Kill()
	if (IsValid(bot)) then
		ply:SpectateEntity(bot)
		if (bot:IsPlayer()) then
			if (IsValid(bot)) then
				ply:SetupHands(bot)
			end
			ply:SetPlayerColor(bot:GetPlayerColor())
		end
	end
	ply.IsSpectating = true
	ply:SetModel("models/weapons/c_arms_animations.mdl") -- anti ragdoll on death
	end)
	concommand.Add("tf_spectate2", function(ply, _, args)
	if args[1] == "2" then ply:Spectate(OBS_MODE_CHASE) ply.SpectateMode = 2 return
	elseif args[1] == "1" then ply:Spectate(OBS_MODE_IN_EYE) ply.SpectateMode = 1 return
	elseif args[1] == "3" then ply:Spectate(OBS_MODE_ROAMING) ply.SpectateMode = 3 return
	elseif args[1] == "-1" then ply:UnSpectate() ply:SetTeam(TEAM_RED) ply.IsSpectating = false ply:KillSilent() ply:Spawn() return end

	ply:StripWeapons()
	ply:SetTeam(TEAM_SPECTATOR)
	--ply:Kill()
	ply:SpectateEntity(bot)
	ply.IsSpectating = true
	ply:SetModel("models/weapons/c_arms_animations.mdl") -- anti ragdoll on death
end)

concommand.Add("tf_spectate_respawn", function(ply, _, args)
	if (ply:Alive()) then return end
	if args[1] == "2" then ply:Spectate(OBS_MODE_CHASE) ply.SpectateMode = 2 umsg.Start("ExitFreezecam", ply) umsg.End() return
	elseif args[1] == "1" then ply:Spectate(OBS_MODE_IN_EYE) ply.SpectateMode = 1 umsg.Start("ExitFreezecam", ply) umsg.End() return
	elseif args[1] == "3" then ply:Spectate(OBS_MODE_ROAMING) ply.SpectateMode = 3 umsg.Start("ExitFreezecam", ply) umsg.End() return end

	ply:StripWeapons()

	local bot = table.Random(getAllPlayersButNotThisGuy(ply),getNPCs())
	if (bot:EntIndex() == ply:EntIndex()) then
		bot = table.Random(getAllPlayersButNotThisGuy(ply),getNPCs())
	end
	if (ply:GetObserverTarget():EntIndex() == bot:EntIndex()) then
		bot = table.Random(lookForNextPlayer(ply,ply:GetObserverTarget()),getNPCs())
	end
	--ply:Kill()
	ply:SpectateEntity(bot)
	if (bot:IsPlayer()) then
		ply:SetupHands(bot)
		ply:SetPlayerColor(bot:GetPlayerColor())
	end
	ply.IsSpectating = true
	umsg.Start("ExitFreezecam", ply)
	umsg.End()
	if CLIENT then
		if LocalPlayer().LastDead then
			LocalPlayer().CurrentView = nil
			LocalPlayer().Killer = nil
			LocalPlayer().LastKillerPos = nil
		end
		LocalPlayer().FreezeCam = false
		LocalPlayer().DeathCamPos = nil
		LocalPlayer().LastDead = false
	end
	ply:SetModel("models/weapons/c_arms_animations.mdl") -- anti ragdoll on death
end)

concommand.Add("tf_spectate_respawn2", function(ply, _, args)
	if (ply:Alive()) then return end
	if args[1] == "2" then ply:Spectate(OBS_MODE_CHASE) ply.SpectateMode = 2 umsg.Start("ExitFreezecam", ply) umsg.End() return
	elseif args[1] == "1" then ply:Spectate(OBS_MODE_IN_EYE) ply.SpectateMode = 1 umsg.Start("ExitFreezecam", ply) umsg.End() return
	elseif args[1] == "3" then ply:Spectate(OBS_MODE_ROAMING) ply.SpectateMode = 3 umsg.Start("ExitFreezecam", ply) umsg.End() return end
	
	ply:StripWeapons()
	
	local bot = table.Random(getNPCs())
	if (!IsValid(bot)) then return end	
	if (bot:EntIndex() == ply:EntIndex()) then
		bot = table.Random(getAllPlayersButNotThisGuy(ply),getNPCs())
		if (!IsValid(bot)) then return end	
	end
	if (ply:GetObserverTarget():EntIndex() == bot:EntIndex()) then
		bot = table.Random(lookForNextPlayer(ply,ply:GetObserverTarget()),getNPCs())
		if (!IsValid(bot)) then return end	
	end
	--ply:Kill()
	ply:SpectateEntity(bot)
	ply.IsSpectating = true
	umsg.Start("ExitFreezecam", ply)
	umsg.End()
	if CLIENT then
		if LocalPlayer().LastDead then
			LocalPlayer().CurrentView = nil
			LocalPlayer().Killer = nil
			LocalPlayer().LastKillerPos = nil
		end
		LocalPlayer().FreezeCam = false
		LocalPlayer().DeathCamPos = nil
		LocalPlayer().LastDead = false
	end
	ply:SetModel("models/weapons/c_arms_animations.mdl") -- anti ragdoll on death
end)
	
hook.Add("PlayerDeath", "tf_Spectate_", function(ply)
	if ply.IsSpectating then
		ply:UnSpectate()
		ply.IsSpectating = false
		if ply:Team() == TEAM_SPECTATOR then 
			ply:SetTeam(TEAM_RED)
		end
	end
end)

hook.Add("PlayerSpawn", "tf_Spectate_", function(ply)
	if (ply:Team() != TEAM_SPECTATOR) then
		ply:SendLua('RunConsoleCommand("snd_soundmixer","Default_Mix")')
		ply.IsSpectating = false
		ply:UnSpectate()
	else
		ply:ConCommand("tf_spectate")
	end
end)

hook.Add("KeyPress", "tf_Spectate_", function(ply, key)
	if (key == IN_ZOOM && ply.ControllingPlayer != nil) then
		local oldpos = ply:GetPos()
		local oldangles = ply:EyeAngles()
		ply:UnSpectate()
		ply:Spawn()
		ply:SetEyeAngles(oldangles)
		ply:EmitSound("weapons/stunstick/alyx_stunner1.wav", 80, 100)
		ply:SetPos(oldpos + Vector(0,0,120))
		timer.Simple(0.25, function()
		
			ply:Give("tf_weapon_berserk")
			ply:SelectWeapon("tf_weapon_berserk")

		end)
		if (ply.ControllingPlayer.WasTFBot) then
			ply.ControllingPlayer.WasTFBot = false
			ply.ControllingPlayer.TFBot = true
		end
		ply.ControllingPlayer.BeingControlled = false
		ply.ControllingPlayer.BeingControlledBy = nil
		ply.ControllingPlayer = nil
	end
	if ply.IsSpectating and ply:Team() == TEAM_SPECTATOR then
		if key == IN_ATTACK and !ply:Crouching() then
			ply:ConCommand("tf_spectate")
		elseif key == IN_ATTACK2 and !ply:Crouching() then
			ply:ConCommand("tf_spectate")
		elseif key == IN_JUMP and !ply:Crouching() then
			local number = 1
			local mode = ply.SpectateMode
			if ply.SpectateMode == 1 then number = 2
			elseif ply.SpectateMode == 2 then number = 3
			elseif ply.SpectateMode == 3 then number = 1
			end
			ply:ConCommand("tf_spectate "..number)
		elseif key == IN_ATTACK and ply:Crouching() then
			ply:ConCommand("tf_spectate2")
		elseif key == IN_ATTACK2 and ply:Crouching() then
			ply:ConCommand("tf_spectate2")
		elseif key == IN_JUMP and ply:Crouching() then
			local number = 1
			local mode = ply.SpectateMode
			if ply.SpectateMode == 1 then number = 2
			elseif ply.SpectateMode == 2 then number = 3
			elseif ply.SpectateMode == 3 then number = 1
			end
			ply:ConCommand("tf_spectate2 "..number)
		end
		--cmd:ClearMovement()
		--cmd:ClearButtons()
	elseif ply.IsSpectating and ply:Team() != TEAM_SPECTATOR then
		if key == IN_ATTACK and !ply:Crouching() then
			ply:ConCommand("tf_spectate_respawn")
		elseif key == IN_ATTACK2 and !ply:Crouching() then
			ply:ConCommand("tf_spectate_respawn")
		elseif key == IN_JUMP and !ply:Crouching() then
			local number = 1
			local mode = ply.SpectateMode
			if ply.SpectateMode == 1 then number = 2
			elseif ply.SpectateMode == 2 then number = 3
			elseif ply.SpectateMode == 3 then number = 1
			end
			ply:ConCommand("tf_spectate_respawn "..number)
		elseif key == IN_ATTACK and ply:KeyDown(IN_DUCK) then
			ply:ConCommand("tf_spectate_respawn2")
		elseif key == IN_ATTACK2 and ply:KeyDown(IN_DUCK) then
			ply:ConCommand("tf_spectate_respawn2")
		elseif key == IN_JUMP and ply:KeyDown(IN_DUCK) then
			local number = 1
			local mode = ply.SpectateMode
			if ply.SpectateMode == 1 then number = 2
			elseif ply.SpectateMode == 2 then number = 3
			elseif ply.SpectateMode == 3 then number = 1
			end
			ply:ConCommand("tf_spectate_respawn2 "..number)
		end
		--cmd:ClearMovement()
		--cmd:ClearButtons()
	end
end)

hook.Add("SetupPlayerVisibility", "tf_Spectate_HackyAreaPortalyFixing", function(ply)
	if IsValid(ply:GetObserverTarget()) then
		AddOriginToPVS(ply:GetObserverTarget():EyePos())
	end
end)