ENT.Base = "base_brush"
ENT.Type = "brush"

ENT.FullyOpenGate1 = false
ENT.FullyOpenGate2 = false

function ENT:Initialize()
	self.Team = 0
	self.Players = {}
	self.Opened = false
	local pos = self:GetPos()
	local mins, maxs = self:WorldSpaceAABB() -- https://forum.facepunch.com/gmoddev/lmcw/Brush-entitys-ent-GetPos/1/#postdwfmq
	pos = (mins + maxs) * 0.5

	self.Pos = pos
end

function ENT:KeyValue(key,value)
	key = string.lower(key)
	
	if key=="teamnum" then
		self.Team = tonumber(value)
	elseif key=="associatedmodel" then
		self.ResupplyLockerName = value
	end
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() then
		self.Players[ent] = -1
		if ent:Team() == TEAM_BLU or ent:Team() == TF_TEAM_PVE_INVADERS then
		if self:GetName() == "gate1_door_trigger" then
			if self.FullyOpenGate1 != false then return end
			for k,v in pairs(ents.FindByName("gate1_spawn_door")) do
				v:Fire("SetSpeed", "15")
				v:Fire("Open")
				for _,alarm in pairs (ents.FindByName("gate1_alarm_yellow_flash")) do
					alarm:Fire("Start")
				end
				for _,light in pairs (ents.FindByName("gate1_emergency_light")) do
					light:Fire("Skin", "3")
					light:Fire("SetAnimation", "spin")
				end
			end
			timer.Create("CloseGate0Door", 14, 1, function()
			ent:EmitSound("mvm/mvm_robo_stun.wav", 0, 100)

			timer.Simple(21.519, function()
				ent:EmitSound("misc/cp_harbor_red_whistle.wav", 0, 100)
				
				for k,v in pairs(ents.FindByName("gate0_entrance_door")) do
					v:Fire("SetSpeed", "15")
					v:Fire("Close")
				end
			end)
			for k,v in pairs(team.GetPlayers(2)) do
				if v:GetNWBool("Taunting") == true then return end
				timer.Create("StunRobot100"..v:EntIndex(), 0.001, 1, function()
					v:DoAnimationEvent(ACT_MP_STUN_BEGIN)
					timer.Create("StunRobotloop103"..v:EntIndex(), v:SequenceDuration(v:LookupSequence("primary_stun_begin")), 0, function()
						timer.Create("StunRobotloop104"..v:EntIndex(), v:SequenceDuration(v:LookupSequence("primary_stun_middle")), 0, function()
							v:DoAnimationEvent(ACT_MP_STUN_MIDDLE)
						end)
					end)
				end)
				v:SetNWBool("Taunting", true)
				v:SetNWBool("NoWeapon", true)
				v:Freeze(true)
				net.Start("ActivateTauntCam") 
				net.Send(v)
				v:StopParticles()
				timer.Simple(21.519, function()
					if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then v:Freeze(false) return end
					timer.Stop("StunRobotloop103"..v:EntIndex())
					timer.Stop("StunRobotloop104"..v:EntIndex())
					v:DoAnimationEvent(ACT_MP_STUN_END)
					net.Start("DeActivateTauntCam")
					net.Send(v)
					v:Freeze(false)
					v:SetNWBool("NoWeapon", false)
					v:SetNWBool("Taunting", false)
				end)
			end
			for _,alarm in pairs (ents.FindByName("gate1_alarm_yellow_flash")) do
				alarm:Fire("Stop")
			end
			for _,light in pairs (ents.FindByName("gate1_emergency_light")) do
				light:Fire("Skin", "1")
				light:Fire("SetAnimation", "idle")
			end
			for _,blockedbitch in pairs	(ents.FindByName("gate1_bot_blocker")) do
				blockedbitch:Fire("Disable")
			end
			self.FullyOpenGate1 = true
			end)
		end
		if self:GetName() == "gate2_door_trigger" then
			if self.FullyOpenGate2 != false then return end
			for k,v in pairs(ents.FindByName("gate2_spawn_door")) do
				v:Fire("SetSpeed", "15")
				v:Fire("Open")
				for _,alarm in pairs (ents.FindByName("gate2_alarm_yellow_flash")) do
					alarm:Fire("Start")
				end
				for _,light in pairs (ents.FindByName("gate2_emergency_light")) do
					light:Fire("Skin", "3")
					light:Fire("SetAnimation", "spin")
				end
			end
			timer.Create("CloseGate1Door", 14, 1, function()
				for k,v in pairs(ents.FindByName("gate1_entrance_door")) do
					v:Fire("Close")
				end
				for _,alarm in pairs (ents.FindByName("gate2_alarm_yellow_flash")) do
					alarm:Fire("Stop")
				end	
				ent:EmitSound("mvm/mvm_robo_stun.wav", 0, 100)
	
				timer.Simple(21.519, function()
					ent:EmitSound("misc/cp_harbor_red_whistle.wav", 0, 100)
				end)
				for k,v in pairs(team.GetPlayers(2)) do
					if v:GetNWBool("Taunting") == true then return end
					timer.Create("StunRobot100"..v:EntIndex(), 0.001, 1, function()
						v:DoAnimationEvent(ACT_MP_STUN_BEGIN)
						timer.Create("StunRobotloop103"..v:EntIndex(), v:SequenceDuration(v:LookupSequence("primary_stun_begin")), 0, function()
							timer.Create("StunRobotloop104"..v:EntIndex(), v:SequenceDuration(v:LookupSequence("primary_stun_middle")), 0, function()
								v:DoAnimationEvent(ACT_MP_STUN_MIDDLE)
							end)
						end)
					end)
					v:SetNWBool("Taunting", true)
					v:SetNWBool("NoWeapon", true)
					v:StopParticles()
					v:Freeze(true)
					net.Start("ActivateTauntCam")
					net.Send(v)
					timer.Simple(21.519, function()
						if not IsValid(v) or (not v:Alive() and not v:GetNWBool("Taunting")) then v:Freeze(false) return end
						timer.Stop("StunRobotloop103"..v:EntIndex())
						timer.Stop("StunRobotloop104"..v:EntIndex())
						v:DoAnimationEvent(ACT_MP_STUN_END)
						net.Start("DeActivateTauntCam")
						net.Send(v)
						v:Freeze(false)
						v:SetNWBool("NoWeapon", false)
						v:SetNWBool("Taunting", false)
					end)
				end
				for _,light in pairs (ents.FindByName("gate2_emergency_light")) do
					light:Fire("Skin", "1")
					light:Fire("SetAnimation", "idle")
				end
				for _,blockedbitch in pairs	(ents.FindByName("gate1_bot_blocker")) do
					blockedbitch:Fire("Enable")
				end
				for _,blockedbitch in pairs	(ents.FindByName("gate2_bot_blocker")) do
					blockedbitch:Fire("Disable")
				end
				self.FullyOpenGate2	= true
			end)
			timer.Create("OpenGate4Door", 25, 1, function()
				for k,v in pairs(ents.FindByName("gate2_fence_door")) do
					v:Fire("SetSpeed", "15")
					v:Fire("Open")
				end
			end)
		end
		end
	end
end

function ENT:EndTouch(ent)
	if ent:IsPlayer() then
		self.Players[ent] = nil
		if ent:Team() == TEAM_BLU or ent:Team() == TF_TEAM_PVE_INVADERS then
		if self:GetName() == "gate1_door_trigger" then
			for k,v in pairs(ents.FindByName("gate1_spawn_door")) do
				if self.FullyOpenGate1 == true then return end
				timer.Stop("CloseGate0Door")
				v:Fire("SetSpeed", "15")
				v:Fire("Close")
				for _,alarm in pairs (ents.FindByName("gate1_alarm_yellow_flash")) do
					alarm:Fire("Stop")
				end
				for _,light in pairs (ents.FindByName("gate1_emergency_light")) do
					light:Fire("Skin", "1")
					light:Fire("SetAnimation", "idle")
				end
			end
		end
		if self:GetName() == "gate2_door_trigger" then
			for k,v in pairs(ents.FindByName("gate2_spawn_door")) do
				if self.FullyOpenGate2 == true then return end
				timer.Stop("CloseGate1Door")
				timer.Stop("OpenGate4Door")
				v:Fire("SetSpeed", "25")
				v:Fire("Close")
				for _,alarm in pairs (ents.FindByName("gate2_alarm_yellow_flash")) do
					alarm:Fire("Stop")
				end
				for _,light in pairs (ents.FindByName("gate2_emergency_light")) do
					light:Fire("Skin", "1")
					light:Fire("SetAnimation", "idle")
				end
			end
		end
		end
	end
end 
