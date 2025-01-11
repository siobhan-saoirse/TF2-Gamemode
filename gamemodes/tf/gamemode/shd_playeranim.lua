
function GM:HandlePlayerJumping(pl)
	if pl:IsHL2() then
		return self.BaseClass:HandlePlayerJumping(pl)
	end
	pl:SetPlaybackRate( 1 )
	if not pl.anim_Jumping and not pl:OnGround() and pl:WaterLevel() <= 0 then
			pl.anim_Jumping = true
			pl.anim_FirstJumpFrame = true
			pl.anim_JumpStartTime = CurTime()
			
			pl:AnimRestartMainSequence()
	end
	
	if pl.anim_Jumping then
		local firstjumpframe = pl.anim_FirstJumpFrame
		
		if pl.anim_FirstJumpFrame then
			pl.anim_FirstJumpFrame = false
			pl:AnimRestartMainSequence()
		end 
		
		if pl:WaterLevel() >= 3 or --[[(CurTime() - pl.anim_JumpStartTime > 0.2 and]] pl:OnGround() --[[)]] then
			pl.anim_Jumping = false
			pl.anim_GroundTime = nil
			
			if pl:OnGround() then
				if pl:IsL4D() then
					pl:AnimRestartGesture(GESTURE_SLOT_JUMP, ACT_LAND, true)
				else
					pl:AnimRestartGesture(GESTURE_SLOT_JUMP, ACT_MP_JUMP_LAND, true)
				end
			end 
		end
		
		
		if pl.anim_Jumping and !pl.anim_Deployed then
			if pl:GetPlayerClass() == "combinesoldier" or pl:GetPlayerClass() == "rebel" or pl:GetPlayerClass() == "metrocop" then
				if pl.anim_JumpStartTime == 0 then
					if pl.anim_Airwalk then
						pl.anim_CalcIdeal = ACT_GLIDE
					else
						return false
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
					else
						return false
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
					else
						return false
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
					else
						return false
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
					else
						return false
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
					else
						return false
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
					else
						return false
					end
				elseif not firstjumpframe and CurTime() - pl.anim_JumpStartTime > pl:SequenceDuration() * pl:GetPlaybackRate() then
					pl.anim_CalcIdeal = ACT_MP_JUMP_FLOAT
				else
					pl.anim_CalcIdeal = ACT_MP_JUMP_START
				end
			end
			return true
		end
	end
	
	pl.anim_Airwalk = false
	return false
end

function GM:HandlePlayerDucking(pl, vel)
	if pl:IsHL2() then
		return self.BaseClass:HandlePlayerDucking(pl, vel)
	end
	
	pl:SetPlaybackRate( 1 )
	if pl:Crouching() then
		local len2d = vel:Length2D()
		
		-- fucking shit garry, you broke GetCrouchedWalkSpeed
		local cl = pl:GetPlayerClassTable()
		
		
		if len2d > 0.5 and (not cl or not cl.NoDeployedCrouchwalk) then
			pl.anim_CalcIdeal = (pl.anim_Deployed and ACT_MP_CROUCH_DEPLOYED) or ACT_MP_CROUCHWALK
		else
			pl.anim_CalcIdeal = (pl.anim_Deployed and ACT_MP_CROUCH_DEPLOYED_IDLE) or ACT_MP_CROUCH_IDLE
		end
		
		return true
	end
	
	return false
end

function GM:HandlePlayerSwimming(pl)
	if pl:IsHL2() then
		return self.BaseClass:HandlePlayerSwimming(pl)
	end
	
	if pl:WaterLevel() >= 3 then
		pl:SetPlaybackRate( 1 )
		if pl.anim_FirstSwimFrame then
			pl.anim_FirstSwimFrame = false
		end
		
		pl.anim_InSwim = true
		pl.anim_CalcIdeal = (pl.anim_Deployed and ACT_MP_SWIM_DEPLOYED) or ACT_MP_SWIM
		
		return true
	else
		pl.anim_InSwim = false
		if not pl.anim_FirstSwimFrame then
			pl.anim_FirstSwimFrame = true
		end
	end
	
	return false
end

function GM:HandlePlayerDriving(pl)
	if pl:IsHL2() then
		return self.BaseClass:HandlePlayerDriving(pl)
	end

	return false
end

function GM:MouthMoveAnimation( ply )
	if (ply:IsHL2()) then

		local flexes = {
			ply:GetFlexIDByName( "jaw_drop" ),
			ply:GetFlexIDByName( "left_part" ),
			ply:GetFlexIDByName( "right_part" ),
			ply:GetFlexIDByName( "left_mouth_drop" ),
			ply:GetFlexIDByName( "right_mouth_drop" )
		}
		if CLIENT then
			local weight = ply:IsSpeaking() && math.Clamp( ply:VoiceVolume() * 2, 0, 2 ) || 0
	
			for k, v in pairs( flexes ) do
				if ply:IsSpeaking() then
					ply:SetFlexWeight( v, weight )
				end		
			end
		end
	else

		local flexes = {
			ply:GetFlexIDByName( "AH" )
		}
		if CLIENT then
			local weight = ply:IsSpeaking() && math.Clamp( ply:VoiceVolume() * 2, 0, 2 ) || 0
	
			for k, v in pairs( flexes ) do
				if ply:IsSpeaking() then
					ply:SetFlexWeight( v, weight )
				end		
			end
		end
	end
end

function GM:UpdateAnimation(pl, velocity, maxseqgroundspeed)		
	if (pl:IsL4D() and pl.TFBot) then
		if (pl:GetModel() != pl:GetNWString("L4DModel")) then
			pl:SetModel(pl:GetNWString("L4DModel"))
		end
	end
	GAMEMODE:MouthMoveAnimation( pl )
	if pl:IsHL2() then
		
		local vel = 1 * velocity
		vel:Rotate(Angle(0,-pl:EyeAngles().y,0))
		vel:Rotate(Angle(-vel:Angle().p,0,0))
			
		local maxspeed = pl:GetRunSpeed()
		
		if SERVER then
			//pl:SetPoseParameter("move_x", vel.x / maxspeed)
			//pl:SetPoseParameter("move_y", -vel.y / maxspeed)
		end

		if not pl.PlayerBodyYaw or not pl.TargetBodyYaw then
			pl.TargetBodyYaw = pl:EyeAngles().y
			pl.PlayerBodyYaw = pl.TargetBodyYaw
		end
		
		local diff
		diff = pl.PlayerBodyYaw - pl:EyeAngles().y
		if velocity:Length2D() > 0.5 or diff > 45 or diff < -45 then
			pl.TargetBodyYaw = pl:EyeAngles().y
		end
		
		local d = pl.TargetBodyYaw - pl.PlayerBodyYaw
		return self.BaseClass:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	end   
	local c = pl:GetPlayerClassTable()
	local maxspeed = 100
	pl:SetPlaybackRate(1)
 	
	maxspeed = pl:GetRealClassSpeed()
	if c and c.Speed then 
		if (pl:OnGround() and pl:Crouching()) then
			maxspeed = c.Speed
			maxspeed = maxspeed * 0.3 
		end
	elseif pl:WaterLevel() > 1 then
		maxspeed = maxspeed * 0.8
	end
	
	if c and c.ModifyMaxAnimSpeed then
		maxspeed = c.ModifyMaxAnimSpeed(pl, maxspeed)
	end
	maxspeed = maxspeed
		
	local vel = 1 * velocity
	vel:Rotate(Angle(0,-pl:EyeAngles().y,0))
	vel:Rotate(Angle(-vel:Angle().p,0,0))
	if SERVER then
		pl:SetPoseParameter("move_x", vel.x / maxspeed)
		pl:SetPoseParameter("move_y", -vel.y / maxspeed)
	end

	local maxspeed2 =  pl:GetClassSpeed()
		
	
	local pitch = math.Clamp(math.NormalizeAngle(-pl:EyeAngles().p), -45, 90)
	local pitch2 = math.Clamp(math.NormalizeAngle(pl:EyeAngles().p), -90, 90)
	if (string.StartWith(pl:GetModel(), "models/infected/")) then
		pl:SetPoseParameter("body_pitch", pitch2)
	else
		if (pl:GetNWBool("IsDerpAim",false) == true) then
			if (math.random(1,2) == 1) then
				pl:SetPoseParameter("body_pitch", table.Random({-90,90,90,90,90,-90}))
			end
		else
			pl:SetPoseParameter("body_pitch", pitch)
		end
	end 
	
	if not pl.PlayerBodyYaw or not pl.TargetBodyYaw then
		pl.TargetBodyYaw = pl:EyeAngles().y
		pl.PlayerBodyYaw = pl.TargetBodyYaw
	end
	
	local diff
	diff = pl.PlayerBodyYaw - pl:EyeAngles().y
		if velocity:Length2D() > 0.5 or diff > 45 or diff < -45 then
			pl.TargetBodyYaw = pl:EyeAngles().y
		end
		
	local d = pl.TargetBodyYaw - pl.PlayerBodyYaw
	if (pl:IsL4D() or GetConVar("civ2_smooth_worldmodel_turning"):GetBool()) then

		if d > 180 then
			pl.PlayerBodyYaw = math.NormalizeAngle(Lerp(FrameTime() * 0.6, pl.PlayerBodyYaw+360, pl.TargetBodyYaw))
		elseif d < -180 then
			pl.PlayerBodyYaw = math.NormalizeAngle(Lerp(FrameTime() * 0.6, pl.PlayerBodyYaw-360, pl.TargetBodyYaw))
		else
			pl.PlayerBodyYaw = Lerp(FrameTime() * 0.6, pl.PlayerBodyYaw, pl.TargetBodyYaw)
		end

	else
		if d > 180 then
			pl.PlayerBodyYaw = math.NormalizeAngle(Lerp(0.2, pl.PlayerBodyYaw+360, pl.TargetBodyYaw))
		elseif d < -180 then
			pl.PlayerBodyYaw = math.NormalizeAngle(Lerp(0.2, pl.PlayerBodyYaw-360, pl.TargetBodyYaw))
		else
			pl.PlayerBodyYaw = Lerp(0.2, pl.PlayerBodyYaw, pl.TargetBodyYaw)
		end
	end
	if (string.StartWith(pl:GetModel(), "models/infected/") || pl:GetPlayerClass() == "rebel" || pl:GetPlayerClass() == "combinesoldier") then
		pl:SetPoseParameter("body_yaw", -diff)
	else
		if (pl:GetNWBool("IsDerpAim",false) == true) then
			pl:SetPoseParameter("body_yaw", math.random(-45,45))
		else
			pl:SetPoseParameter("body_yaw", diff)
		end
	end
	 
	
	
		local flMin, flMax = pl:GetPoseParameterRange(pl:LookupPoseParameter("head_pitch"))
		local flMin2, flMax2 = pl:GetPoseParameterRange(pl:LookupPoseParameter("aim_pitch"))
		local flMin3, flMax3 = pl:GetPoseParameterRange(pl:LookupPoseParameter("head_yaw"))
		local flMin4, flMax4 = pl:GetPoseParameterRange(pl:LookupPoseParameter("aim_yaw"))
		
		if (flMin and flMax) then
			local dpitch = math.Clamp(math.NormalizeAngle(-pl:EyeAngles().p), flMin, flMax)
			pl:SetPoseParameter("head_pitch", -dpitch)
		end
		if (flMin2 and flMax2) then
			local dpitch = math.Clamp(math.NormalizeAngle(-pl:EyeAngles().p), flMin2, flMax2)
			pl:SetPoseParameter("aim_pitch", -dpitch)
		end
		if not pl.dPlayerBodyYaw or not pl.dTargetBodyYaw then
			pl.dTargetBodyYaw = pl:EyeAngles().y
			pl.dPlayerBodyYaw = pl.dTargetBodyYaw
		end
		if not pl.dPlayerBodyYaw2 or not pl.dTargetBodyYaw2 then
			pl.dTargetBodyYaw2 = pl:EyeAngles().y
			pl.dPlayerBodyYaw2 = pl.dTargetBodyYaw2
		end
		
		local ddiff
		ddiff = pl.dPlayerBodyYaw - pl:EyeAngles().y
		if (flMin3 and flMax3) then
			if velocity:Length2D() > 0.5 or ddiff > flMax3 or ddiff < flMin3 then
				pl.dTargetBodyYaw = pl:EyeAngles().y
			end
		end
		local ddiff2
		ddiff2 = pl.dPlayerBodyYaw2 - pl:EyeAngles().y
		if (flMin4 and flMax4) then
			if velocity:Length2D() > 0.5 or ddiff2 > flMax4 or ddiff2 < flMin4 then
				pl.dTargetBodyYaw2 = pl:EyeAngles().y
			end
		end
			
		local dd = pl.dTargetBodyYaw - pl.dPlayerBodyYaw
		if dd > 180 then
			pl.dPlayerBodyYaw = math.NormalizeAngle(Lerp(0.2, pl.dPlayerBodyYaw+360, pl.dTargetBodyYaw))
			pl.dPlayerBodyYaw2 = math.NormalizeAngle(Lerp(0.2, pl.dPlayerBodyYaw2+360, pl.dTargetBodyYaw2))
		elseif dd < -180 then
			pl.dPlayerBodyYaw = math.NormalizeAngle(Lerp(0.2, pl.dPlayerBodyYaw-360, pl.dTargetBodyYaw))
			pl.dPlayerBodyYaw2 = math.NormalizeAngle(Lerp(0.2, pl.dPlayerBodyYaw2-360, pl.dTargetBodyYaw2))
		else
			pl.dPlayerBodyYaw = Lerp(0.2, pl.dPlayerBodyYaw, pl.dTargetBodyYaw)
			pl.dPlayerBodyYaw2 = Lerp(0.2, pl.dPlayerBodyYaw2, pl.dTargetBodyYaw2)
		end
		if (flMin and flMax) then
			pl:SetPoseParameter("head_pitch", math.Clamp(math.NormalizeAngle(pl:EyeAngles().p), flMin, flMax))
		end
		if (flMin2 and flMax2) then
			pl:SetPoseParameter("aim_pitch", math.Clamp(math.NormalizeAngle(pl:EyeAngles().p), flMin2, flMax2))
		end
		pl:SetPoseParameter("head_yaw", -ddiff)
		
		if (flMin4 and flMax4) then
			pl:SetPoseParameter("aim_yaw", -ddiff2)	
		end
		
	if CLIENT then
		GAMEMODE:GrabEarAnimation( pl )
		if (pl:GetNWBool("IsDerpAim",false) == true) then
			pl:SetRenderAngles(Angle(0, math.random(-179,179), 0))
		else
			pl:SetRenderAngles(Angle(0, pl.PlayerBodyYaw, 0))
		end
		--pl:SetRenderAngles(Angle(0, pl:EyeAngles().y, 0))
	end
end


function GM:GrabEarAnimation( ply )

	if ply:IsHL2() then
		return self.BaseClass:GrabEarAnimation(ply)
	end
	ply.ChatGestureWeight = ply.ChatGestureWeight || 0

	-- Don't show this when we're playing a taunt!
	if ( ply:IsPlayingTaunt() ) then return end

	if ( ply.ChatGestureWeight > 0 ) then

		ply:AnimRestartGesture( GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, true )
		ply:AnimSetGestureWeight( GESTURE_SLOT_VCD, ply.ChatGestureWeight )

	end

end

function GM:HandlePlayerLanding( ply, velocity, onGround )
	return self.BaseClass:HandlePlayerLanding(ply, velocity, onGround)
end

function GM:CalcMainActivity(pl, vel)
	self:HandlePlayerLanding(pl, vel, pl:IsOnGround())
	if pl:IsHL2() then
		return self.BaseClass:CalcMainActivity(pl, vel)
	end
	
	pl.anim_CalcIdeal = (pl.anim_Deployed and ACT_MP_DEPLOYED_IDLE) or ACT_MP_STAND_IDLE
	pl.anim_CalcSeqOverride = -1
	if
		self:HandlePlayerDriving(pl) or
		self:HandlePlayerSwimming(pl) or
		self:HandlePlayerJumping(pl) or
		self:HandlePlayerDucking(pl, vel) then 
		-- do nothing
	else
		local len2d = vel:Length2D()
		if len2d > 0.5 then
			if (pl:IsL4D()) then
				if (pl:KeyDown(IN_WALK)) then
					pl.anim_CalcIdeal = ACT_MP_WALK
				else
					pl.anim_CalcIdeal = ACT_MP_RUN
				end
			else
				pl.anim_CalcIdeal = (pl.anim_Deployed and ACT_MP_DEPLOYED) or ACT_MP_RUN
			end
		end
	end
	
	return pl.anim_CalcIdeal, pl.anim_CalcSeqOverride
end

local LoserStateActivityTranslate = {}

local VoiceCommandGestures = {
	[ACT_MP_GESTURE_VC_HANDMOUTH] = true,
	[ACT_MP_GESTURE_VC_THUMBSUP] = true,
	[ACT_MP_GESTURE_VC_FINGERPOINT] = true,
	[ACT_MP_GESTURE_VC_FISTPUMP] = true,
	[ACT_MP_GESTURE_VC_NODYES] = true,
	[ACT_MP_GESTURE_VC_NODNO] = true,
}

local TauntGestures = {
	[ACT_DOD_HS_CROUCH_KNIFE] = "taunt_laugh",
	[ACT_DOD_CROUCH_AIM_C96] = "taunt01",
	[ACT_SIGNAL_HALT] = "releasecrab",
	[ACT_SIGNAL_GROUP] = "taunt_woohoo",
	[ACT_BARNACLE_HIT] = "taunt_maggots_condolence",
	[ACT_BARNACLE_CHOMP] = "taunt_yetipunch",
	[ACT_DOD_CROUCHWALK_AIM_MP40] = "taunt02",
	[ACT_DOD_STAND_AIM_30CAL] = "taunt03",
	[ACT_DOD_SPRINT_AIM_SPADE] = "taunt04",
	[ACT_DOD_CROUCH_AIM_RIFLE] = "gesture_melee_cheer",
	[ACT_COVER_MED] = "taunt_lollichop",
	[ACT_DOD_PRONE_DEPLOYED] = "melee_pounce",
	[ACT_DOD_IDLE_ZOOMED] = "taunt05", 
	[ACT_DOD_PRONE_ZOOMED] = "throw_fire",
	[ACT_DOD_PRONE_FORWARD_ZOOMED] = "SECONDARY_fire_alt",
	[ACT_DOD_PRIMARYATTACK_DEPLOYED] = "gesture_secondary_positive",
	[ACT_DOD_PRIMARYATTACK_PRONE_DEPLOYED] = "gesture_secondary_go",
	[ACT_DOD_WALK_IDLE_MP44] = "gesture_secondary_cheer",
	[ACT_SIGNAL1] = "gesture_secondary_help",
	[ACT_DOD_CROUCHWALK_AIM_30CAL] = "gesture_melee_positive",
	[ACT_DOD_STAND_ZOOM_BOLT] = "taunt_hifivesuccess",
	[ACT_DOD_CROUCH_ZOOM_BOLT] = "taunt_highfivesuccess",
	[ACT_DOD_CROUCHWALK_ZOOM_BOLT] = "taunt_highfivesuccessfull",
	[ACT_DOD_WALK_ZOOM_BOLT] = "taunt_hifivesuccessfull",
	[ACT_DOD_SECONDARYATTACK_PRONE_BOLT] = "taunt_dosido_dance",
	[ACT_DOD_PRONEWALK_IDLE_BAR] = "taunt_rps_scissors_win",
	[ACT_DOD_SPRINT_IDLE_BAR] = "taunt_rps_scissors_lose",
	[ACT_DOD_PRIMARYATTACK_BOLT] = "selectionMenu_Anim0l",
	[ACT_DOD_SECONDARYATTACK_BOLT] = "taunt_flip_success_initiator",
	[ACT_WALK_SCARED] = "taunt_party_trick",
	[ACT_DOD_PRIMARYATTACK_PRONE_BOLT] = "taunt_flip_success_receiver",
	[ACT_DOD_RUN_IDLE_MG] = "taunt_headbutt_success",
	[ACT_DOD_CROUCH_IDLE_TOMMY] = "taunt06",
	[ACT_DOD_STAND_AIM_KNIFE] = "taunt09",
	[ACT_BARNACLE_PULL] = "taunt_replay",
	[ACT_BARNACLE_CHEW] = "taunt_replay2",
	[ACT_COVER] = "taunt_flip_start",
	[ACT_COVER_LOW] = "taunt05",
	[ACT_VM_UNLOAD] = "FastAttack",
	[ACT_VM_FIDGET] = "ThrowWarning",
	[ACT_DOD_CROUCHWALK_IDLE_PISTOL] = "taunt_conga",
	[ACT_DI_ALYX_ZOMBIE_TORSO_MELEE] = "taunt_russian",
	[ACT_DOD_CROUCH_IDLE_PISTOL] = "taunt04",
	[ACT_DOD_WALK_AIM_PSCHRECK] = "taunt_brutallegend",
	[ACT_DOD_ZOOMLOAD_BAZOOKA] = "taunt_rps_rock_win",
	[ACT_DOD_RELOAD_PSCHRECK] = "taunt_rps_rock_lose",
	[ACT_DOD_ZOOMLOAD_PSCHRECK] = "taunt_rps_paper_win",
	[ACT_DOD_DEPLOYED] = "Shoved_Backward",
	[ACT_DOD_RELOAD_DEPLOYED_FG42] = "Shoved_Backward_01",
	[ACT_DOD_WALK_ZOOMED] = "a_grapple_pull_idle",
	[ACT_DOD_CROUCH_ZOOMED] = "a_grapple_SHOOT",
	[ACT_DOD_CROUCHWALK_ZOOMED] = "a_grapple_pull_start",
	[ACT_SIGNAL2] = "taunt08",
	[ACT_RUN_HURT] = "taunt_scorch_shot",
	[ACT_DOD_RELOAD_DEPLOYED] = "taunt07",
	[ACT_WALK_CROUCH_AIM] = "taunt_luxury_lounge",
	[ACT_RUN_CROUCH_AIM] = "taunt_luxury_lounge_outro",
	[ACT_GESTURE_TURN_LEFT90] = "Charger_punch",
	[ACT_RUN_PROTECTED] = "taunt_yeti",
	[ACT_DOD_RELOAD_PRONE_DEPLOYED] = "selectionMenu_Anim01",
	[ACT_SMG2_IDLE2] = "ReloadStand_PRIMARY_end",
	[ACT_SMG2_FIRE2] = "ReloadStand_SECONDARY_end",
	[ACT_SMG2_DRAW2] = "PRIMARY_reload_end",
	[ACT_SMG2_RELOAD2] = "a_SECONDARY_reload_end",
	[ACT_SMG2_DRYFIRE2] = "a_primary_reload_end",
	[ACT_RUN_AIM] = "taunt_dosido_intro",
	[ACT_90_RIGHT] = "taunt_bubbles",
	[ACT_FLY] = "taunt_killer_time_intro",
	[ACT_RUN_CROUCH] = "taunt_rps_start",
	[ACT_SIGNAL3] = "taunt_bumpkins_banjo_fastloop",
	[ACT_SIGNAL_ADVANCE] = "taunt_bumpkins_banjo_outro",
}

function GM:TranslateActivity(pl, act)
	if pl:IsHL2() then
		return self.BaseClass:TranslateActivity(pl, act)
	end
	
	if pl:IsLoser() then
		if LoserStateActivityTranslate[ACT_MP_STAND_IDLE] ~= ACT_MP_STAND_LOSERSTATE then
			LoserStateActivityTranslate[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_LOSERSTATE
			LoserStateActivityTranslate[ACT_MP_RUN] 							= ACT_MP_RUN_LOSERSTATE
			LoserStateActivityTranslate[ACT_MP_CROUCH_IDLE] 					= ACT_MP_CROUCH_LOSERSTATE
			LoserStateActivityTranslate[ACT_MP_CROUCHWALK] 						= ACT_MP_CROUCH_LOSERSTATE
			LoserStateActivityTranslate[ACT_MP_SWIM] 							= ACT_MP_SWIM_LOSERSTATE
			LoserStateActivityTranslate[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_LOSERSTATE

			LoserStateActivityTranslate[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_LOSERSTATE
			LoserStateActivityTranslate[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_LOSERSTATE
			LoserStateActivityTranslate[ACT_MP_JUMP_LAND] 						= ACT_MP_JUMP_LAND_LOSERSTATE
		end
		
		return LoserStateActivityTranslate[act] or act
	end
	
	if pl:InVehicle() then
		return pl:GetSequenceActivity(pl:LookupSequence("kart_idle")) or pl:TranslateWeaponActivity(act)
	end
	
	return pl:TranslateWeaponActivity(act)
end

function GM:DoAnimationEvent(pl, event, data, taunt)
	
	if pl:IsHL2() then
		return self.BaseClass:DoAnimationEvent(pl, event, data)
	end
	
	local w = pl:GetActiveWeapon()
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		if pl.anim_InSwim then
			pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_SWIM_PRIMARYFIRE, true)
		elseif pl:Crouching() then
			pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_CROUCH_PRIMARYFIRE, true)
		else
			pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_STAND_PRIMARYFIRE, true)
		end
		
		--return ACT_INVALID
		if IsValid(w) and w.GetPrimaryFireActivity then
			return w:GetPrimaryFireActivity()
		else
			return ACT_INVALID
		end
	elseif event == PLAYERANIMEVENT_RELOAD then
		if pl.anim_InSwim then
			pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_SWIM, true)
		elseif pl:Crouching() then
			pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_CROUCH, true)
		else
			pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_STAND, true)
		end
		
		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_CUSTOM_GESTURE then
		if data == ACT_MP_DOUBLEJUMP then
			-- Double jump
			pl:AnimRestartGesture(GESTURE_SLOT_FLINCH, ACT_MP_DOUBLEJUMP, true)
		elseif data == ACT_MP_GESTURE_FLINCH_CHEST then
			-- Flinch
			pl:AnimRestartGesture(GESTURE_SLOT_FLINCH, ACT_MP_GESTURE_FLINCH_CHEST, true)
			--pl.RgChatActiveGesture = ACT_MP_GESTURE_FLINCH_CHEST
		elseif data == ACT_MP_AIRWALK then
			-- Go into airwalk animation
			if pl.anim_Jumping then
				pl.anim_Jumping = false
			end
			pl.anim_Airwalk = true
			pl:AnimRestartMainSequence()
		elseif data == ACT_MP_RELOAD_STAND then
			-- Reload loop
			if pl.anim_InSwim then
				--pl.RgChatActiveGesture = _G["ACT_MP_RELOAD_SWIM_"..pl:GetActiveWeapon().HoldType]
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_SWIM, true)
			elseif pl:Crouching() then
				--pl.RgChatActiveGesture = _G["ACT_MP_RELOAD_CROUCH_"..pl:GetActiveWeapon().HoldType]
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_CROUCH, true)
			else
				--pl.RgChatActiveGesture = _G["ACT_MP_RELOAD_STAND_"..pl:GetActiveWeapon().HoldType]
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_STAND, true)
			end
		elseif data == ACT_MP_RELOAD_STAND_LOOP then
			-- Reload loop
			if pl.anim_InSwim then
				--pl.RgChatActiveGesture = _G["ACT_MP_RELOAD_STAND_"..pl:GetActiveWeapon().HoldType.."_LOOP"]
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_SWIM_LOOP, true)
			elseif pl:Crouching() then
				--pl.RgChatActiveGesture = _G["ACT_MP_RELOAD_STAND_"..pl:GetActiveWeapon().HoldType.."_LOOP"]
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_CROUCH_LOOP, true)
			else
				--pl.RgChatActiveGesture = _G["ACT_MP_RELOAD_STAND_"..pl:GetActiveWeapon().HoldType.."_LOOP"]
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_STAND_LOOP, true)
			end
		elseif data == ACT_MP_RELOAD_STAND_END then
			-- Reload end
			if pl.anim_InSwim then
				--pl.RgChatActiveGesture = _G["ACT_MP_RELOAD_STAND_"..pl:GetActiveWeapon().HoldType.."_END"]
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_SWIM_END, true)
			elseif pl:Crouching() then
				--pl.RgChatActiveGesture = _G["ACT_MP_RELOAD_STAND_"..pl:GetActiveWeapon().HoldType.."_END"]
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_CROUCH_END, true)
			else
				--pl.RgChatActiveGesture = _G["ACT_MP_RELOAD_STAND_"..pl:GetActiveWeapon().HoldType.."_END"]
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_STAND_END, true)
			end
		elseif data == ACT_MP_ATTACK_STAND_PREFIRE then
			-- Prefire gesture
			local act
			----MsgN("Restarting prefire gesture")
			if pl.anim_InSwim then
				--pl.RgChatActiveGesture = ACT_MP_ATTACK_SWIM_PREFIRE
				pl:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_MP_ATTACK_SWIM_PREFIRE, true)
			elseif pl:Crouching() then
				--pl.RgChatActiveGesture = ACT_MP_ATTACK_CROUCH_PREFIRE
				pl:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_MP_ATTACK_CROUCH_PREFIRE, true)
			else
				--pl.RgChatActiveGesture = ACT_MP_ATTACK_STAND_PREFIRE
				pl:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_MP_ATTACK_STAND_PREFIRE, true)
			end
			pl.anim_Deployed = true
		elseif data == ACT_MP_ATTACK_STAND_POSTFIRE then
			-- Postfire gesture
			if pl.anim_InSwim then
				--pl.RgChatActiveGesture = ACT_MP_ATTACK_SWIM_POSTFIRE
				pl:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_MP_ATTACK_SWIM_POSTFIRE, true)
			elseif pl:Crouching() then
				--pl.RgChatActiveGesture = ACT_MP_ATTACK_CROUCH_POSTFIRE
				pl:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_MP_ATTACK_CROUCH_POSTFIRE, true)
			else
				--pl.RgChatActiveGesture = ACT_MP_ATTACK_STAND_POSTFIRE
				pl:AnimRestartGesture(GESTURE_SLOT_CUSTOM, ACT_MP_ATTACK_STAND_POSTFIRE, true)
			end
			pl.anim_Deployed = false
		elseif data == ACT_MP_ATTACK_STAND_SECONDARYFIRE then
			-- Secondary attack gesture
			if pl.anim_InSwim then
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_SWIM_SECONDARYFIRE, true)
			elseif pl:Crouching() then
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_CROUCH_SECONDARYFIRE, true)
			else
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_STAND_SECONDARYFIRE, true)
			end
		elseif data == ACT_MP_ATTACK_STAND_PRIMARY_DEPLOYED then
			-- Deployed attack gesture
			if pl.anim_InSwim then
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_SWIM_PRIMARY_DEPLOYED, true)
			elseif pl:Crouching() then
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_CROUCH_PRIMARY_DEPLOYED, true)
			else
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_STAND_PRIMARY_DEPLOYED, true)
			end
		elseif data == ACT_MP_DEPLOYED then
			-- Enter deployed state
			if not pl.anim_Deployed then
				pl.anim_Deployed = true
				pl:AnimRestartMainSequence()
			end
		elseif data == ACT_MP_STAND_PRIMARY then
			-- Leave deployed state
			if pl.anim_Deployed then
				pl.anim_Deployed = false
				pl:AnimRestartMainSequence()
			end
		elseif VoiceCommandGestures[data] then
			pl:AnimRestartGesture(GESTURE_SLOT_FLINCH, data, true)
		elseif TauntGestures[data] then -- laugh
			pl:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, pl:LookupSequence(TauntGestures[data]), 0, true)
		else
			-- just let us do custom ones man
			if (isstring(data)) then
				pl:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, pl:LookupSequence(data), 0, true)
			elseif (isnumber(data)) then
				pl:AnimRestartGesture(GESTURE_SLOT_FLINCH, data, true)
			end
		end
		
		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_JUMP then
		pl.anim_Jumping = true
		pl.anim_FirstJumpFrame = true
		pl.anim_JumpStartTime = CurTime()
		
		pl:AnimRestartMainSequence()
		
		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_CANCEL_RELOAD then
		pl:AnimResetGestureSlot(GESTURE_SLOT_ATTACK_AND_RELOAD)
		return ACT_INVALID
	end
end
local plyr = FindMetaTable("Player")

function plyr:DoTauntEvent(anim,autokill)
	if (self:IsPlayer()) then
		if (autokill == nil) then
			autokill = true
		end 
		if (isnumber(anim)) then
			self:AnimRestartGesture( GESTURE_SLOT_VCD, self:SelectWeightedSequence(anim), autokill )
			if SERVER then

				self:AddVCDSequenceToGestureSlot( GESTURE_SLOT_VCD, self:SelectWeightedSequence(anim), 0, autokill )
				net.Start("TauntAnim")
					net.WriteEntity(self)
					net.WriteInt(self:SelectWeightedSequence(anim),32)
					net.WriteBool(autokill)
				net.Broadcast()
			end
		elseif (isstring(anim)) then
			self:AnimRestartGesture( GESTURE_SLOT_VCD, self:LookupSequence(anim), autokill )
			if SERVER then

				self:AddVCDSequenceToGestureSlot( GESTURE_SLOT_VCD, self:LookupSequence(anim), 0, autokill )
				net.Start("TauntAnim")
					net.WriteEntity(self)
					net.WriteInt(self:LookupSequence(anim),32)
					net.WriteBool(autokill)
				net.Broadcast()
			end
		end
	end
end

local meta = FindMetaTable("Weapon")

local OldSendWeaponAnim = meta.SendWeaponAnim

function meta:SendWeaponAnim(act)
	if not act or act == -1 then return end
	----MsgN(Format("SendWeaponAnim %d %s",act,tostring(self)))
	if IsValid(self.Owner) and self.Owner:IsPlayer() and IsValid(self.Owner:GetViewModel()) and self.ViewModelOverride then
		for k, v in pairs(self.Owner:GetWeapons()) do
			if IsValid(v) and v:GetClass() == "tf_weapon_robot_arm" and v.IsRoboArm then
				--self.ViewModelOverride = "models/weapons/c_models/c_engineer_gunslinger.mdl"
			elseif IsValid(v) and v:GetClass() == "tf_weapon_shortcircuit" and v.IsRoboArm then
				self.Owner:GetViewModel():SetBodygroup(2, 1)
			end
		end
		if (!string.StartWith(self.Owner:GetModel(),"models/infected/")) then
			self:SetModel(self.ViewModelOverride)
			self.Owner:GetViewModel():SetModel(self.ViewModelOverride)
		end
	end

	OldSendWeaponAnim(self,act)
end
