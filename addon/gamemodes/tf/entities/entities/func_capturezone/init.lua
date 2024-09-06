ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()
	local pos = self:GetPos()
	local mins, maxs = self:WorldSpaceAABB() -- https://forum.facepunch.com/gmoddev/lmcw/Brush-entitys-ent-GetPos/1/#postdwfmq
	pos = (mins + maxs) * 0.5

	self.Team = self.Team or 0		
	self.TeamNum = self.TeamNum or 0
	self.Pos = pos
	SetGlobalFloat("tf_ctf_red", 0)
	SetGlobalFloat("tf_ctf_blu", 0)
	--SetGlobalFloat("tf_ctf_red_lastcap", CurTime() - 120)
	--SetGlobalFloat("tf_ctf_blu_lastcap", CurTime() - 120)
end

function ENT:KeyValue(key,value)
	key = string.lower(key)
	
	if key=="teamnum" then
		local t = tonumber(value)
		
		if t==0 then
			self.TeamNum = 0
		elseif t==2 then
			self.TeamNum = TEAM_RED
		elseif t==3 then
			self.TeamNum = TEAM_BLU
		end

		self.Team = tonumber(value)
	end
	--print(key, value, tonumber(value), self.Team)
end

function ENT:StartTouch(ply)
	if ply:GetClass() == "npc_mvm_tank" then
		ply:DeployBomb()
		timer.Create("Tank", 0.001, 0, function()
			ply:SetThrottle(0)
		end)
		timer.Simple(7.5, function()
			ply:Explode()
			RunConsoleCommand("tf_mvm_wins")
		end)
	end
	for _,v in pairs(ents.FindByClass("item_teamflag")) do
		----print(self.Team, v.te, self.Pos:Distance(ply) <= 50)
		----print(self.Team ~= v.te, v.Carrier == ply, v:GetPos():Distance(ply:GetPos()) <= 50)
		if v.Carrier==ply and self.Team ~= v.te and v.Prop:GetPos():Distance(ply:GetPos()) <= 100 then
			if game.GetMap() == "mvm_terroristmission_v7_1" then
				RunConsoleCommand("tf_red_wins")
			end
			
			ply:Speak("TLK_FLAGCAPTURED")
			v:Capture()
			--team.AddScore(v.TeamNum, 1)
			if v.TeamNum == TEAM_RED then
				team.AddScore(TEAM_BLU, 1)
				if (team.GetScore(TEAM_BLU) > GetConVarNumber("tf_flag_caps_per_round") - 1 and !GAMEMODE.RoundHasWinner) then
					GAMEMODE:RoundWin(TEAM_BLU)
					return
				end
				--SetGlobalFloat("tf_ctf_blu", GetGlobalFloat("tf_ctf_blu") + 1)
			else
				team.AddScore(TEAM_RED, 1)
				if (team.GetScore(TEAM_RED) > GetConVarNumber("tf_flag_caps_per_round") - 1 and !GAMEMODE.RoundHasWinner) then
					GAMEMODE:RoundWin(TEAM_RED)
					return
				end
				--SetGlobalFloat("tf_ctf_red", GetGlobalFloat("tf_ctf_red") + 1)
			end

			--SetGlobalFloat("tf_ctf_red_lastcap", CurTime())
			--SetGlobalFloat("tf_ctf_blu_lastcap", CurTime())

			for _, ply in pairs(player.GetAll()) do
				if ply:Team() ~= v.TeamNum then
					ply:SendLua([[surface.PlaySound("vo/intel_teamcaptured.mp3")]])
					GAMEMODE:StartCritBoost(ply)
					if (!GAMEMODE.RoundHasWinner) then
						timer.Simple(10, function()
							if IsValid(ply) then
								GAMEMODE:StopCritBoost(ply)
							end
						end)
					end
				else
					ply:SendLua([[surface.PlaySound("vo/intel_enemycaptured.mp3")]])
				end
			end
		end
	end
	for _,v in pairs(ents.FindByClass("item_teamflag_mvm")) do
		----print(self.Team, v.te, self.Pos:Distance(ply) <= 50)
		----print(self.Team ~= v.te, v.Carrier == ply, v:GetPos():Distance(ply:GetPos()) <= 50)
		if v.Carrier==ply and self.Team ~= v.Team then
				timer.Simple(0.1, function()
					if string.find(v.Carrier:GetModel(),"_boss.mdl") then
						v:EmitSound("mvm/mvm_deploy_giant.wav", 95, 100)
					else
						v:EmitSound("mvm/mvm_deploy_small.wav", 95, 100)
					end
					for _, player in ipairs(player.GetAll()) do
						player:SendLua([[LocalPlayer():EmitSound("Announcer.MVM_Bomb_Alert_Deploying")]])
					end
					v.Carrier:SetNWBool("Taunting",true) 
					v.Carrier:DoAnimationEvent(v.Carrier:LookupSequence("primary_deploybomb"))
				end)
				timer.Simple(3, function()
					if not v.Carrier:Alive() then v.Carrier:Freeze(false) return end
					for _,pl in pairs(player.GetAll()) do
						if pl:Team() == TEAM_RED then
							pl:SendLua([[LocalPlayer():EmitSound("Announcer.MVM_Wave_Lose")]])
						end
					end
					RunConsoleCommand("tf_mvm_wins")
					for k,v in pairs(ents.FindByClass("obj_sentrygun")) do
						if !v:IsFriendly(ent) then
							v:Remove()
						end
					end
				end)
				timer.Simple(5, function()
					if not v.Carrier:Alive() then v.Carrier:Freeze(false) return end
					v.WModel2:SetNoDraw(false)
					v.Carrier:Freeze(false)
					v.Carrier:SetNoDraw(false)
					v.Carrier:ConCommand("tf_firstperson")
				end)
				timer.Simple(5.3, function()
					if not v.Carrier:Alive() then v.Carrier:Freeze(false) return end
					v.Carrier:Kill() 
					v:Capture()
				end)
		end
	end
end

function ENT:EndTouch(ent)
end