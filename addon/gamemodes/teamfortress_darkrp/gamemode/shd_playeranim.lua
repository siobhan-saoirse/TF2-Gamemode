
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
		
		if pl:WaterLevel() >= 2 or --[[(CurTime() - pl.anim_JumpStartTime > 0.2 and]] pl:OnGround() --[[)]] then
			pl.anim_Jumping = false
			pl.anim_GroundTime = nil
			pl:AnimRestartMainSequence()
			
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
			elseif pl:GetPlayerClass() == "tank" or pl:GetPlayerClass() == "boomer" or pl:GetPlayerClass() == "boomette" or pl:GetPlayerClass() == "charger" or pl:GetPlayerClass() == "hunter" or pl:GetPlayerClass() == "l4d_zombie" or pl:GetPlayerClass() == 'smoker' or pl:GetPlayerClass() == 'jockey' or pl:GetPlayerClass() == 'spitter' then								
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
	
	if pl:WaterLevel() >= 2 then
		pl:SetPlaybackRate( 1 )
		if pl.anim_FirstSwimFrame then
			pl:AnimRestartMainSequence()
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
	GAMEMODE:MouthMoveAnimation( pl )
	if (pl:IsHL2()) then		  
		pl:SetViewOffset(Vector(0,0,64 * pl:GetModelScale()))
		pl:SetViewOffsetDucked(Vector(0, 0, 28 * pl:GetModelScale()))
	else
		pl:SetViewOffset(Vector(0, 0, 68 * pl:GetModelScale()))
		pl:SetViewOffsetDucked(Vector(0, 0, 48 * pl:GetModelScale()))
	end
	if pl:IsHL2() then
		return self.BaseClass:UpdateAnimation(pl, velocity, maxseqgroundspeed)
	end   
	local c = pl:GetPlayerClassTable()
	local maxspeed = 100
	if pl:IsSprinting() then
		pl:SetPlaybackRate(1.3)
		if SERVER then
		pl:SetLaggedMovementValue( 1.3 )
		end
	elseif pl:KeyDown(IN_SPEED) and pl:GetNWBool("Taunting") == true then
		pl:SetPlaybackRate(1.3)
		if SERVER then
		pl:SetLaggedMovementValue( 1.3 )
		end
	elseif pl:KeyDown(IN_WALK) and !pl:IsL4D() then
		pl:SetPlaybackRate(0.8)
		if SERVER then
		pl:SetLaggedMovementValue( 0.8 )
		end
	else
		pl:SetPlaybackRate(1)
		if SERVER then
		pl:SetLaggedMovementValue( 1 )
		end
	end
 	
	maxspeed = pl:GetRealClassSpeed()
	if c and c.Speed then 
	if (pl:OnGround() and pl:Crouching()) then
		maxspeed = c.Speed
	end
	
		maxspeed = maxspeed * 0.3
	elseif pl:WaterLevel() > 1 then
		maxspeed = maxspeed * 0.8
	end
	
	if c and c.ModifyMaxAnimSpeed then
		maxspeed = c.ModifyMaxAnimSpeed(pl, maxspeed)
	end
	maxspeed = maxspeed * 3 
		
	local vel = 1 * velocity
	vel:Rotate(Angle(0,-pl:EyeAngles().y,0))
	vel:Rotate(Angle(-vel:Angle().p,0,0))
		
	local maxspeed2 =  pl:GetClassSpeed()
		
	
	local pitch = math.Clamp(math.NormalizeAngle(-pl:EyeAngles().p), -45, 90)
	local pitch2 = math.Clamp(math.NormalizeAngle(pl:EyeAngles().p), -90, 90)
	if (string.StartWith(pl:GetModel(), "models/infected/")) then
		pl:SetPoseParameter("body_pitch", pitch2)
	else
		pl:SetPoseParameter("body_pitch", pitch)
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
	if d > 180 then
		pl.PlayerBodyYaw = math.NormalizeAngle(Lerp(FrameTime() * 3, pl.PlayerBodyYaw+360, pl.TargetBodyYaw))
	elseif d < -180 then
		pl.PlayerBodyYaw = math.NormalizeAngle(Lerp(FrameTime() * 3, pl.PlayerBodyYaw-360, pl.TargetBodyYaw))
	else
		pl.PlayerBodyYaw = Lerp(0.2, pl.PlayerBodyYaw, pl.TargetBodyYaw)
	end
	if (string.StartWith(pl:GetModel(), "models/infected/") || pl:GetPlayerClass() == "rebel" || pl:GetPlayerClass() == "combinesoldier") then
		pl:SetPoseParameter("body_yaw", -diff)
	else
		pl:SetPoseParameter("body_yaw", diff)
	end
	 
	
	
		local flMin, flMax = pl:GetPoseParameterRange(pl:LookupPoseParameter("head_pitch"))
		local flMin2, flMax2 = pl:GetPoseParameterRange(pl:LookupPoseParameter("aim_pitch"))
		local flMin3, flMax3 = pl:GetPoseParameterRange(pl:LookupPoseParameter("head_yaw"))
		local flMin4, flMax4 = pl:GetPoseParameterRange(pl:LookupPoseParameter("aim_yaw"))
		
		if (flMin and flMax) then
			local dpitch = math.Clamp(math.NormalizeAngle(-pl:EyeAngles().p), flMin, flMax)
			pl:SetPoseParameter("head_pitch", dpitch)
		end
		if (flMin2 and flMax2) then
			local dpitch = math.Clamp(math.NormalizeAngle(-pl:EyeAngles().p), flMin2, flMax2)
			pl:SetPoseParameter("head_pitch", dpitch)
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
			pl.dPlayerBodyYaw = math.NormalizeAngle(Lerp(FrameTime() * 3, pl.dPlayerBodyYaw+360, pl.dTargetBodyYaw))
			pl.dPlayerBodyYaw2 = math.NormalizeAngle(Lerp(FrameTime() * 3, pl.dPlayerBodyYaw2+360, pl.dTargetBodyYaw2))
		elseif dd < -180 then
			pl.dPlayerBodyYaw = math.NormalizeAngle(Lerp(FrameTime() * 3, pl.dPlayerBodyYaw-360, pl.dTargetBodyYaw))
			pl.dPlayerBodyYaw2 = math.NormalizeAngle(Lerp(FrameTime() * 3, pl.dPlayerBodyYaw2-360, pl.dTargetBodyYaw2))
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
		pl:SetRenderAngles(Angle(0, pl.PlayerBodyYaw, 0))
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
	[ACT_COVER_MED] = "gesture_melee_help",
	[ACT_DOD_PRONE_DEPLOYED] = "melee_pounce",
	[ACT_DOD_IDLE_ZOOMED] = "gesture_primary_cheer",
	[ACT_DOD_PRONE_ZOOMED] = "gesture_primary_go",
	[ACT_DOD_PRONE_FORWARD_ZOOMED] = "gesture_primary_help",
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
		return ACT_DOD_RELOAD_DEPLOYED or act
	end
	
	return pl:TranslateWeaponActivity(act)
end

function GM:DoAnimationEvent(pl, event, data, taunt)
	if pl:IsHL2() then
		return self.BaseClass:DoAnimationEvent(pl, event, data)
	end 
	
	local w = pl:GetActiveWeapon()
	if event == PLAYERANIMEVENT_ATTACK_PRIMARY then
		if pl:IsHL2() then
			pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_STAND_PRIMARYFIRE, true)
		else
			if pl.anim_InSwim then
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_SWIM_PRIMARYFIRE, true)
			elseif pl:Crouching() then
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_CROUCH_PRIMARYFIRE, true)
			else
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_ATTACK_STAND_PRIMARYFIRE, true)
			end
		end
		
		--return ACT_INVALID
		if IsValid(w) and w.GetPrimaryFireActivity then
			return w:GetPrimaryFireActivity()
		else
			return ACT_INVALID
		end
	elseif event == PLAYERANIMEVENT_RELOAD then
		if pl:IsHL2() then
			pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_PRIMARYFIRE, true)
		else
			if pl.anim_InSwim then
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_SWIM, true)
			elseif pl:Crouching() then
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_CROUCH, true)
			else
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_STAND, true)
			end
		end
		
		return ACT_INVALID
	elseif event == PLAYERANIMEVENT_CUSTOM_GESTURE then
		if data == ACT_MP_DOUBLEJUMP then
			-- Double jump
			pl:AnimRestartGesture(GESTURE_SLOT_JUMP, ACT_MP_DOUBLEJUMP, true)
		elseif data == ACT_MP_GESTURE_FLINCH_CHEST then
			-- Flinch
			if (pl:IsL4D()) then
				pl:AnimRestartGesture(GESTURE_SLOT_FLINCH, ACT_FLINCH_CHEST, true)
			else
				pl:AnimRestartGesture(GESTURE_SLOT_FLINCH, ACT_MP_GESTURE_FLINCH_CHEST, true)
			end
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
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_SWIM, true)
			elseif pl:Crouching() then
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_CROUCH, true)
			else
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_STAND, true)
			end
		elseif data == ACT_MP_RELOAD_STAND_LOOP then
			-- Reload loop
			if pl.anim_InSwim then
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_SWIM_LOOP, true)
			elseif pl:Crouching() then
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_CROUCH_LOOP, true)
			else
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_STAND_LOOP, true)
			end
		elseif data == ACT_MP_RELOAD_STAND_END then
			-- Reload end
			if pl.anim_InSwim then
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_SWIM_END, true)
			elseif pl:Crouching() then
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_CROUCH_END, true)
			else
				pl:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_STAND_END, true)
			end
		elseif data == ACT_MP_ATTACK_STAND_PREFIRE then
			-- Prefire gesture
			local act
			--MsgN("Restarting prefire gesture")
			if pl.anim_InSwim then
				pl:AnimRestartGesture(GESTURE_SLOT_VCD, ACT_MP_ATTACK_SWIM_PREFIRE, true)
			elseif pl:Crouching() then
				pl:AnimRestartGesture(GESTURE_SLOT_VCD, ACT_MP_ATTACK_CROUCH_PREFIRE, true)
			else
				pl:AnimRestartGesture(GESTURE_SLOT_VCD, ACT_MP_ATTACK_STAND_PREFIRE, true)
			end
			pl.anim_Deployed = true
		elseif data == ACT_MP_ATTACK_STAND_POSTFIRE then
			-- Postfire gesture
			if pl.anim_InSwim then
				pl:AnimRestartGesture(GESTURE_SLOT_VCD, ACT_MP_ATTACK_SWIM_POSTFIRE, true)
			elseif pl:Crouching() then
				pl:AnimRestartGesture(GESTURE_SLOT_VCD, ACT_MP_ATTACK_CROUCH_POSTFIRE, true)
			else
				pl:AnimRestartGesture(GESTURE_SLOT_VCD, ACT_MP_ATTACK_STAND_POSTFIRE, true)
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
			if (pl:IsBot()) then
				pl.anim_Deployed = false
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
			if (pl:IsBot()) then
				pl.anim_Deployed = false
			end
		elseif data == ACT_MP_DEPLOYED then
			-- Enter deployed state
			if (pl:IsBot()) then
				pl.anim_Deployed = false
			end	
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
			pl:AnimRestartGesture(GESTURE_SLOT_VCD, data, true)
		elseif TauntGestures[data] then -- laugh
			if (string.StartWith(TauntGestures[data], "gesture_primary_") || string.StartWith(TauntGestures[data], "gesture_secondary_") || string.StartWith(TauntGestures[data], "gesture_melee_")) then
				pl:AddVCDSequenceToGestureSlot(GESTURE_SLOT_VCD, pl:LookupSequence(TauntGestures[data]), 0, true)
			else
				pl:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, pl:LookupSequence(TauntGestures[data]), 0, true)
			end
		else
			-- just let us do custom ones man
			pl:AnimRestartGesture(GESTURE_SLOT_VCD, data, true)
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

local meta = FindMetaTable("Weapon")

local OldSendWeaponAnim = meta.SendWeaponAnim

function meta:SendWeaponAnim(act)
	if not act or act == -1 then return end
	--MsgN(Format("SendWeaponAnim %d %s",act,tostring(self)))
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

-- Porting from Latest TF2 GM Builds, and edited.
hook.Add("EntityEmitSound", "MouthFix", function(snd)
	local p = snd.Pitch

	if ( game.GetTimeScale() != 1 ) then
		p = p * game.GetTimeScale()
	end

	if ( GetConVarNumber( "host_timescale" ) != 1 && GetConVarNumber( "sv_cheats" ) >= 1 ) then
		p = p * GetConVarNumber( "host_timescale" )
	end

	if ( p != snd.Pitch ) then
		snd.Pitch = math.Clamp( p, 0, 255 )
		return true
	end

	if ( CLIENT && engine.GetDemoPlaybackTimeScale() != 1 ) then
		snd.Pitch = math.Clamp( snd.Pitch * engine.GetDemoPlaybackTimeScale(), 0, 255 )
		return true
	end
	if CLIENT and !IsValid(snd.Entity) then return end
	if (IsValid(snd.Entity)) then
		if (GetConVar("civ2_randomizer"):GetBool()) then	
			if (!snd.Entity.IsRandomized) then
				for i=0,snd.Entity:GetBoneCount() do
					snd.Entity:ManipulateBoneJiggle( i, 1 )	
				end
			snd.Entity.IsRandomized = true
			end
		elseif (!GetConVar("civ2_randomizer"):GetBool()) then
			if (snd.Entity.IsRandomized) then
				for i=0,snd.Entity:GetBoneCount() do
					snd.Entity:ManipulateBoneJiggle( i, 0 )	
				end
				snd.Entity.IsRandomized = false
			end
		end
	end
	if (GetConVar("civ2_randomizer"):GetBool()) then
			snd.DSP = table.Random({0,0,0,0,134,135})
		if (IsMounted("hl1") and math.random(1,5) == 1) then
			if (math.random(1,42) == 1) then
				snd.SoundName = table.Random({"agrunt/"..table.Random(file.Find("sound/agrunt/*","hl1"))})
			elseif (math.random(1,42) == 2) then
				snd.SoundName = table.Random({"ambience/"..table.Random(file.Find("sound/ambience/*","hl1"))})
			elseif (math.random(1,42) == 3) then
				snd.SoundName = table.Random({"apache/"..table.Random(file.Find("sound/apache/*","hl1"))})
			elseif (math.random(1,42) == 4) then
				snd.SoundName = table.Random({"aslave/"..table.Random(file.Find("sound/aslave/*","hl1"))})
			elseif (math.random(1,42) == 5) then
				snd.SoundName = table.Random({"barnacle/"..table.Random(file.Find("sound/barnacle/*","hl1"))})
			elseif (math.random(1,42) == 6) then
				snd.SoundName = table.Random({"barney/"..table.Random(file.Find("sound/barney/*","hl1"))})
			elseif (math.random(1,42) == 7) then
				snd.SoundName = table.Random({"boid/"..table.Random(file.Find("sound/boid/*","hl1"))})
			elseif (math.random(1,42) == 8) then
				snd.SoundName = table.Random({"bullchicken/"..table.Random(file.Find("sound/bullchicken/*","hl1"))})
			elseif (math.random(1,42) == 9) then
				snd.SoundName = table.Random({"buttons/"..table.Random(file.Find("sound/buttons/*","hl1"))})
			elseif (math.random(1,42) == 10) then
				snd.SoundName = table.Random({"common/"..table.Random(file.Find("sound/common/*","hl1"))})
			elseif (math.random(1,42) == 11) then
				snd.SoundName = table.Random({"controller/"..table.Random(file.Find("sound/controller/*","hl1"))})
			elseif (math.random(1,42) == 12) then
				snd.SoundName = table.Random({"debris/"..table.Random(file.Find("sound/debris/*","hl1"))})
			elseif (math.random(1,42) == 13) then
				snd.SoundName = table.Random({"doors/"..table.Random(file.Find("sound/doors/*","hl1"))})
			elseif (math.random(1,42) == 14) then
				snd.SoundName = table.Random({"fans/"..table.Random(file.Find("sound/fans/*","hl1"))})
			elseif (math.random(1,42) == 15) then
				snd.SoundName = table.Random({"fvox/"..table.Random(file.Find("sound/fvox/*","hl1"))})
			elseif (math.random(1,42) == 16) then
				snd.SoundName = table.Random({"garg/"..table.Random(file.Find("sound/garg/*","hl1"))})
			elseif (math.random(1,42) == 17) then
				snd.SoundName = table.Random({"gman/"..table.Random(file.Find("sound/gman/*","hl1"))})
			elseif (math.random(1,42) == 18) then
				snd.SoundName = table.Random({"gonarch/"..table.Random(file.Find("sound/gonarch/*","hl1"))})
			elseif (math.random(1,42) == 19) then
				snd.SoundName = table.Random({"hassault/"..table.Random(file.Find("sound/hassault/*","hl1"))})
			elseif (math.random(1,42) == 20) then
				snd.SoundName = table.Random({"headcrab/"..table.Random(file.Find("sound/headcrab/*","hl1"))})
			elseif (math.random(1,42) == 21) then
				snd.SoundName = table.Random({"hgrunt/"..table.Random(file.Find("sound/hgrunt/*","hl1"))})
			elseif (math.random(1,42) == 22) then
				snd.SoundName = table.Random({"holo/"..table.Random(file.Find("sound/holo/*","hl1"))})
			elseif (math.random(1,42) == 23) then
				snd.SoundName = table.Random({"hornet/"..table.Random(file.Find("sound/hornet/*","hl1"))})
			elseif (math.random(1,42) == 24) then
				snd.SoundName = table.Random({"houndeye/"..table.Random(file.Find("sound/houndeye/*","hl1"))})
			elseif (math.random(1,42) == 25) then
				snd.SoundName = table.Random({"ichy/"..table.Random(file.Find("sound/ichy/*","hl1"))})
			elseif (math.random(1,42) == 26) then
				snd.SoundName = table.Random({"items/"..table.Random(file.Find("sound/items/*","hl1"))})
			elseif (math.random(1,42) == 27) then
				snd.SoundName = table.Random({"misc/"..table.Random(file.Find("sound/misc/*","hl1"))})
			elseif (math.random(1,42) == 28) then
				snd.SoundName = table.Random({"plats/"..table.Random(file.Find("sound/plats/*","hl1"))})
			elseif (math.random(1,42) == 29) then
				snd.SoundName = table.Random({"player/"..table.Random(file.Find("sound/player/*","hl1"))})
			elseif (math.random(1,42) == 30) then
				snd.SoundName = table.Random({"roach/"..table.Random(file.Find("sound/roach/*","hl1"))})
			elseif (math.random(1,42) == 31) then
				snd.SoundName = table.Random({"scientist/"..table.Random(file.Find("sound/scientist/*","hl1"))})
			elseif (math.random(1,42) == 32) then
				snd.SoundName = table.Random({"squeek/"..table.Random(file.Find("sound/squeek/*","hl1"))})
			elseif (math.random(1,42) == 33) then
				snd.SoundName = table.Random({"tentacle/"..table.Random(file.Find("sound/tentacle/*","hl1"))})
			elseif (math.random(1,42) == 34) then
				snd.SoundName = table.Random({"tride/"..table.Random(file.Find("sound/tride/*","hl1"))})
			elseif (math.random(1,42) == 35) then
				snd.SoundName = table.Random({"turret/"..table.Random(file.Find("sound/turret/*","hl1"))})
			elseif (math.random(1,42) == 36) then
				snd.SoundName = table.Random({"ui/"..table.Random(file.Find("sound/ui/*","hl1"))})
			elseif (math.random(1,42) == 37) then
				snd.SoundName = table.Random({"vox/"..table.Random(file.Find("sound/vox/*","GAME"))})
			elseif (math.random(1,42) == 38) then
				snd.SoundName = table.Random({"weapons/"..table.Random(file.Find("sound/weapons/*","hl1"))})
			elseif (math.random(1,42) == 39) then
				snd.SoundName = table.Random({"x/"..table.Random(file.Find("sound/x/*","hl1"))})
			elseif (math.random(1,42) == 40) then
				snd.SoundName = table.Random({"zombie/"..table.Random(file.Find("sound/zombie/*","hl1"))})
			else
				snd.SoundName = table.Random({"hgrunt/"..table.Random(file.Find("sound/hgrunt/*","hl1"))})
			end
			return true
		else
			local theTable = table.Random(sound.GetTable())
			snd.SoundName = sound.GetProperties(theTable).sound
			return true
		end
	end
	if (snd.Entity:IsPlayer() and !snd.Entity:IsHL2()) then
		if CLIENT then
			if !IsValid(snd.Entity) then return end
			if (snd.Entity.playerclass == "medicshotgun") then	
				snd.Entity:SetupPhonemeMappings( "player/medic/phonemes/phonemes" )
			elseif (snd.Entity.playerclass == "heavy") then
				snd.Entity:SetupPhonemeMappings( "player/heavy/phonemes/phonemes" )
			elseif (snd.Entity.playerclass == "scout") then
				snd.Entity:SetupPhonemeMappings( "player/scout/phonemes/phonemes" )
			elseif (snd.Entity.playerclass == "soldier") then
				snd.Entity:SetupPhonemeMappings( "player/soldier/phonemes/phonemes" )
			elseif (snd.Entity.playerclass == "demoman") then
				snd.Entity:SetupPhonemeMappings( "player/demo/phonemes/phonemes" )
			elseif (snd.Entity.playerclass == "engineer") then
				snd.Entity:SetupPhonemeMappings( "player/engineer/phonemes/phonemes" )
			elseif (snd.Entity.playerclass == "medic") then
				snd.Entity:SetupPhonemeMappings( "player/medic/phonemes/phonemes" )
			elseif (snd.Entity.playerclass == "sniper") then
				snd.Entity:SetupPhonemeMappings( "player/sniper/phonemes/phonemes" )
			elseif (snd.Entity.playerclass == "spy") then
				snd.Entity:SetupPhonemeMappings( "player/spy/phonemes/phonemes" )
			else
				snd.Entity:SetupPhonemeMappings( "player/heavy/phonemes/phonemes" )
			end
		end
	elseif (snd.Entity:IsPlayer() and snd.Entity:IsHL2()) then
		if CLIENT then
			if !IsValid(snd.Entity) then return end
			snd.Entity:SetupPhonemeMappings("phonemes")
		end
	elseif (!snd.Entity:IsPlayer()) then
		if CLIENT then
			if !IsValid(snd.Entity) then return end
			if (string.find(snd.Entity:GetModel(),"player/heavy")) then
				snd.Entity:SetupPhonemeMappings( "player/heavy/phonemes/phonemes" )
			elseif (string.find(snd.Entity:GetModel(),"player/scout")) then
				snd.Entity:SetupPhonemeMappings( "player/scout/phonemes/phonemes" )
			elseif (string.find(snd.Entity:GetModel(),"player/soldier")) then
				snd.Entity:SetupPhonemeMappings( "player/soldier/phonemes/phonemes" )
			elseif (string.find(snd.Entity:GetModel(),"player/demoman")) then
				snd.Entity:SetupPhonemeMappings( "player/demo/phonemes/phonemes" )
			elseif (string.find(snd.Entity:GetModel(),"player/engineer")) then
				snd.Entity:SetupPhonemeMappings( "player/engineer/phonemes/phonemes" )
			elseif (string.find(snd.Entity:GetModel(),"player/medic")) then
				snd.Entity:SetupPhonemeMappings( "player/medic/phonemes/phonemes" )
			elseif (string.find(snd.Entity:GetModel(),"player/sniper")) then
				snd.Entity:SetupPhonemeMappings( "player/sniper/phonemes/phonemes" )
			elseif (string.find(snd.Entity:GetModel(),"player/spy")) then
				snd.Entity:SetupPhonemeMappings( "player/spy/phonemes/phonemes" )
			end
		end
	end
end)

timer.Create("FixImprovedNPCsConflict",0.1,0, function()
	hook.Remove("TranslateActivity", "TF2PMStuff")
	hook.Remove("Think","DeviantartistThink")
	hook.Remove("Think","DeviantartistThink2")
	hook.Remove("EntityTakeDamage", "DamageShit")
end)

hook.Add("EntityEmitSound", "MVMVoices", function(snd)
	
	local p = snd.Pitch

	if ( game.GetTimeScale() != 1 ) then
		p = p * game.GetTimeScale()
	end

	if ( GetConVarNumber( "host_timescale" ) != 1 && GetConVarNumber( "sv_cheats" ) >= 1 ) then
		p = p * GetConVarNumber( "host_timescale" )
	end

	if ( p != snd.Pitch ) then
		snd.Pitch = math.Clamp( p, 0, 255 )
	end

	if ( CLIENT && engine.GetDemoPlaybackTimeScale() != 1 ) then
		snd.Pitch = math.Clamp( snd.Pitch * engine.GetDemoPlaybackTimeScale(), 0, 255 )
	end
	if CLIENT and !IsValid(snd.Entity) then return end
	if IsValid(snd.Entity) and string.find(snd.Entity:GetModel(),"bot_") and !string.find(snd.Entity:GetModel(),"boss") and snd.Entity:GetModelScale() < 1.75 and string.find(snd.SoundName, "step") then
		
		if (string.find(snd.Entity:GetModel(),"demo") and string.find(snd.Entity:GetModel(),"buster")) then
			snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/sentrybuster/mvm_sentrybuster_step_0"..math.random(1,4)..".wav")
			snd.SoundLevel = 95
			snd.Channel = CHAN_BODY
			snd.Pitch = 100
			snd.Volume = 1
		else
			snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "mvm/player/footsteps/robostep_"..table.Random({
				"01",
				"02",
				"03",
				"04",
				"05",
				"06",
				"07",
				"08",
				"09",
				"10",
				"11",
				"12",
				"13",
				"14",
				"15",
				"16",
				"17",
				"18",
			})..".wav")
			
			snd.Channel = CHAN_BODY
			snd.Pitch = math.random(95,100)
			snd.Volume = 0.35
		end
		return true
	elseif IsValid(snd.Entity) and string.find(snd.Entity:GetModel(),"infected") and (string.find(snd.SoundName, "fallpain") or string.find(snd.SoundName, "damage")) then
		return false
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and snd.Entity:IsHL2() and (string.find(snd.SoundName, "fallpain") or string.find(snd.SoundName, "damage")) then
		snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/pl_fallpain"..table.Random({1,3})..".wav")
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and (snd.Entity:GetPlayerClass() == "hl1scientist" || snd.Entity:GetPlayerClass() == "hl1barney") and (string.find(snd.SoundName, "fallpain") or string.find(snd.SoundName, "damage")) then
		snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "hl1/player/pl_fallpain"..math.random(1,3)..".wav")
		return true
	elseif IsValid(snd.Entity) and string.find(snd.Entity:GetModel(),"bot_") and string.find(snd.Entity:GetModel(),"buster") and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/sentrybuster/mvm_sentrybuster_step_0"..math.random(1,4)..".wav")
		snd.SoundLevel = 95
		snd.Channel = CHAN_BODY
		snd.Pitch = 100
		snd.Volume = 1
		return true
	elseif IsValid(snd.Entity) and string.StartWith(snd.Entity:GetModel(), "models/player") and !string.find(snd.Entity:GetModel(), "tfc") and snd.Entity:LookupBone("bip_head") and !string.find(snd.Entity:GetModel(), "bot") and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
			snd.Channel = CHAN_BODY
		local speed = snd.Entity:GetVelocity():Length()
		local groundspeed = snd.Entity:GetVelocity():Length2DSqr()
		if (snd.Entity:GetMoveType() == MOVETYPE_LADDER) then
			snd.Volume = 0.5
		end
		if (snd.Entity:IsPlayer() and snd.Entity:Crouching()) then
			snd.Volume = 0.65
		end
			local flMin, flMax = snd.Entity:GetPoseParameterRange(snd.Entity:GetPoseParameter("move_x"))
			if (math.Remap(snd.Entity:GetPoseParameter("move_x"), 0, 1, flMin, flMax) <= 0) then
				snd.Volume = snd.Volume * -math.Remap(snd.Entity:GetPoseParameter("move_x"), 0, 1, flMin, flMax) * 0.4
			else
				snd.Volume = snd.Volume * math.Remap(snd.Entity:GetPoseParameter("move_x"), 0, 1, flMin, flMax) * 0.4
			end
		if (snd.Entity:WaterLevel() < 1) then
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "tf/player/footsteps/")
		elseif (snd.Entity:WaterLevel() < 2) then
			snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "tf/player/footsteps/slosh"..math.random(1,4)..".wav")
		else
			snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "tf/player/footsteps/wade"..math.random(1,4)..".wav")
		end
		snd.Pitch = math.random(90,105)
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and snd.Entity:IsHL2() and string.find(snd.SoundName, "step")  and snd.Entity:GetInfoNum("civ2_enable_survivor_steps",0) == 1 then
		if (snd.Entity:KeyDown(IN_WALK)) then
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/survivor/walk/")
		else
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/survivor/run/")
		end
		if (GetConVar("tf_enable_server_footsteps"):GetBool()) then
			sound.Play(snd.SoundName,snd.Entity:GetPos(),snd.SoundLevel,snd.Pitch,snd.Volume)
			return false
		end
		return true
	elseif string.StartWith(snd.SoundName,"physics/body/") and string.find(snd.SoundName, "impact") and GetConVar("tf_enable_l4d2_ragdoll_sounds"):GetBool() then
		snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "l4d2/physics/body/body_medium_impact_soft"..table.Random({"1","2","5","6","7"})..".wav")
		snd.Volume = 0.6
		return true
	elseif string.StartWith(snd.SoundName,"physics/body/") and string.find(snd.SoundName, "impact") and GetConVar("tf_enable_hl2_ragdoll_sounds"):GetBool() == false then
		snd.SoundName = string.Replace(snd.SoundName, "physics/", "tf/physics/")
		return true
	elseif IsValid(snd.Entity) and string.find(snd.SoundName,"female") and string.find(snd.Entity:GetModel(),"boomer") then
		snd.SoundName = string.Replace(snd.SoundName, "female", "male")
		return true
	elseif IsValid(snd.Entity) and string.find(snd.SoundName,"/male") and string.find(snd.Entity:GetModel(),"boomette") then
		snd.SoundName = string.Replace(snd.SoundName, "male", "female")
		return true
	elseif IsValid(snd.Entity) and string.StartWith(snd.Entity:GetModel(), "models/player") and string.find(snd.Entity:GetModel(), "tfc") and !string.find(snd.Entity:GetModel(), "bot") and snd.Entity:LookupBone("bip_head") and string.find(snd.SoundName, "step") and (IsMounted("hl1") || IsMounted("hl1mp")) then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
		snd.Channel = CHAN_BODY
		if (snd.Entity:WaterLevel() < 1) then
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/pl_") 
			snd.SoundName = string.Replace(snd.SoundName, "concrete", "step")
			snd.SoundName = string.Replace(snd.SoundName, "grass", "step")
			snd.SoundName = string.Replace(snd.SoundName, "sand", "step")
			snd.SoundName = string.Replace(snd.SoundName, "metalgrate", "grate")
			snd.SoundName = string.Replace(snd.SoundName, "tile4", "tile"..math.random(4,5))
		elseif (snd.Entity:WaterLevel() < 2) then
			snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/pl_slosh"..math.random(1,4)..".wav")
		else
			snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/pl_wade"..math.random(1,4)..".wav")
		end
		snd.Pitch = 100
		return true
	elseif IsValid(snd.Entity) and (snd.Entity:GetModel() == "models/infected/hulk.mdl" or snd.Entity:GetModel() == "models/infected/hulk_l4d1.mdl" or snd.Entity:GetModel() == "models/infected/hulk_dlc3.mdl") and string.find(snd.SoundName, "step") then
		if (snd.Entity:WaterLevel() > 0) then
			snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/tank/walk/tank_walk_water_0"..math.random(1,6)..".wav")
		else
			snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/tank/walk/tank_walk0"..math.random(1,6)..".wav")
		end
		snd.Channel = CHAN_STATIC
		snd.Pitch = math.random(95,105)
		snd.SoundLevel = 80
		return true
	elseif IsValid(snd.Entity) and (snd.Entity:GetModel() == "models/infected/boomer.mdl" or snd.Entity:GetModel() == "models/infected/boomer_l4d1.mdl" or snd.Entity:GetModel() == "models/infected/boomette.mdl") and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
		snd.SoundName = string.Replace(snd.SoundName, "1", math.random(1,4))
		snd.SoundName = string.Replace(snd.SoundName, "2", math.random(1,4))
		snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/boomer/run/")
		
		snd.Pitch = math.random(95,105)
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and snd.Entity:GetPlayerClass() == "jockey" and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
		snd.SoundName = string.Replace(snd.SoundName, "1", math.random(1,4))
		snd.SoundName = string.Replace(snd.SoundName, "2", math.random(1,4))
		snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/boomer/run/")
		
		snd.Pitch = math.random(95,105)
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and snd.Entity:GetPlayerClass() == "hunter" and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
		snd.SoundName = string.Replace(snd.SoundName, "1", math.random(1,4))
		snd.SoundName = string.Replace(snd.SoundName, "2", math.random(1,4))
		
		if (snd.Entity:KeyDown(IN_WALK)) then
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/infected/walk/")
		else
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/infected/run/")
		end
		
		snd.Pitch = math.random(95,105)
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and snd.Entity:GetPlayerClass() == "smoker" and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
		snd.SoundName = string.Replace(snd.SoundName, "1", math.random(1,4))
		snd.SoundName = string.Replace(snd.SoundName, "2", math.random(1,4))
		if (snd.Entity:KeyDown(IN_WALK)) then
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/infected/walk/")
		else
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/infected/run/")
		end
		snd.Pitch = math.random(95,105)
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and snd.Entity:GetPlayerClass() == "spitter" and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
		snd.SoundName = string.Replace(snd.SoundName, "1", math.random(1,4))
		snd.SoundName = string.Replace(snd.SoundName, "2", math.random(1,4))
		if (snd.Entity:KeyDown(IN_WALK)) then
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/infected/walk/")
		else
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/infected/run/")
		end
		snd.Pitch = math.random(95,105)
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and snd.Entity:GetPlayerClass() == "charger" and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
		snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/charger/run/charger_run_"..table.Random({"left","right"}).."_0"..math.random(1,4)..".wav")
		
		snd.Pitch = math.random(95,105)
		return true
	elseif IsValid(snd.Entity) and string.find(snd.Entity:GetModel(),"bot_") and (!snd.Entity:IsPlayer() and string.find(snd.Entity:GetModel(),"boss") or (snd.Entity:IsPlayer() and snd.Entity:GetInfoNum("tf_giant_robot",0) == 1 or (string.find(snd.Entity:GetModel(),"bot") and string.find(snd.Entity:GetModel(),"boss")))) and string.find(snd.SoundName, "step") then
		if (GetConVar("tf_enable_unused_mvm_sounds"):GetBool()) then
			if (string.find(snd.Entity:GetModel(),"scout") || string.find(snd.Entity:GetModel(),"superscout") || string.find(snd.Entity:GetModel(),"superscoutfan") || string.find(snd.Entity:GetModel(),"gianscout")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_scout/giant_scout_step_0"..math.random(1,4)..".wav")
				snd.SoundLevel = 87
			elseif (string.find(snd.Entity:GetModel(),"soldier")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_soldier/giant_soldier_step0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			elseif (string.find(snd.Entity:GetModel(),"pyro")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_pyro/giant_pyro_step_0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			elseif (string.find(snd.Entity:GetModel(),"demo") and !string.find(snd.Entity:GetModel(),"buster")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_demoman/giant_demoman_step_0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			elseif (string.find(snd.Entity:GetModel(),"demo") and string.find(snd.Entity:GetModel(),"buster")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/sentrybuster/mvm_sentrybuster_step_0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			elseif (string.find(snd.Entity:GetModel(),"heavy")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_heavy/giant_heavy_step0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			elseif (string.find(snd.Entity:GetModel(),"engineer")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_heavy/giant_heavy_step0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			elseif (string.find(snd.Entity:GetModel(),"medic")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_soldier/giant_soldier_step0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			elseif (string.find(snd.Entity:GetModel(),"sniper")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_heavy/giant_heavy_step0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			elseif (string.find(snd.Entity:GetModel(),"spy")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_scout/giant_scout_step_0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			end
		else
			if (string.find(snd.Entity:GetModel(),"buster")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/sentrybuster/mvm_sentrybuster_step_0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			else
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_common/giant_common_step_0"..math.random(1,8)..".wav")
				if (string.find(snd.Entity:GetModel(),"scout") || string.find(snd.Entity:GetModel(),"superscout") || string.find(snd.Entity:GetModel(),"superscoutfan") || string.find(snd.Entity:GetModel(),"gianscout")) then
					snd.SoundLevel = 87
				elseif (string.find(snd.Entity:GetModel(),"soldier")) then
					snd.SoundLevel = 95
				elseif (string.find(snd.Entity:GetModel(),"pyro")) then
					snd.SoundLevel = 95
				elseif (string.find(snd.Entity:GetModel(),"demo")) then
					snd.SoundLevel = 95
				elseif (string.find(snd.Entity:GetModel(),"heavy")) then
					snd.SoundLevel = 95
				elseif (string.find(snd.Entity:GetModel(),"engineer")) then
					snd.SoundLevel = 95
				elseif (string.find(snd.Entity:GetModel(),"medic")) then
					snd.SoundLevel = 95
				elseif (string.find(snd.Entity:GetModel(),"sniper")) then
					snd.SoundLevel = 95
				elseif (string.find(snd.Entity:GetModel(),"spy")) then
					snd.SoundLevel = 87
				end
			end
		end
		snd.Volume = 1
		snd.Channel = CHAN_BODY
		snd.Pitch = 100
		return true
	elseif IsValid(snd.Entity) and string.StartWith(snd.SoundName, "player/")  and snd.Entity:IsPlayer() then
		if (snd.Entity:GetInfoNum("tf_special_dsp_type",-1) > -1) then
			snd.DSP = snd.Entity:GetInfoNum("tf_special_dsp_type",-1);
		end
		return true
	elseif IsValid(snd.Entity) and string.StartWith(snd.SoundName, "npc/") and snd.Entity:IsPlayer() then
		if (snd.Entity:GetInfoNum("tf_special_dsp_type",-1) > -1) then
			snd.DSP = snd.Entity:GetInfoNum("tf_special_dsp_type",-1);
		end
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and snd.Entity:GetInfoNum("tf_robot",0) == 1 or (string.find(snd.Entity:GetModel(),"bot_") and !string.find(snd.Entity:GetModel(),"boss")) and string.StartWith(snd.SoundName, "vo/") then
		if (snd.Entity:IsPlayer() and snd.Entity:GetInfoNum("tf_special_dsp_type",-1) > -1) then
			snd.DSP = snd.Entity:GetInfoNum("tf_special_dsp_type",-1);
		end
		
		if (snd.Entity:IsPlayer() and snd.Entity:GetPlayerClass() == "wtfdemoman") then
			snd.Pitch = 130
		else
			if (GetConVar("tf_pyrovision"):GetBool()) then
				snd.SoundName = string.Replace(snd.SoundName, "PainCrticialDeath", "laughlong")
				snd.SoundName = string.Replace(snd.SoundName, "PainSharp", "laughshort")
				snd.SoundName = string.Replace(snd.SoundName, "PainSevere", "laughhappy")
				snd.SoundName = string.Replace(snd.SoundName, "AutoOnFire", "PositiveVocalization")
				snd.SoundName = string.Replace(snd.SoundName, "heavy_laughshort04", "heavy_laughshort01")
				snd.SoundName = string.Replace(snd.SoundName, "heavy_laughshort05", "heavy_laughshort02")
				snd.SoundName = string.Replace(snd.SoundName, "heavy_laughlong03", "heavy_laughlong02")
			end
			snd.SoundName = string.Replace(snd.SoundName, "vo/scout", "vo/mvm/norm/scout_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/soldier", "vo/mvm/norm/soldier_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/pyro", "vo/mvm/norm/pyro_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/demoman", "vo/mvm/norm/demoman_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/heavy", "vo/mvm/norm/heavy_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/engineer", "vo/mvm/norm/engineer_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/medic", "vo/mvm/norm/medic_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/sniper", "vo/mvm/norm/sniper_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/spy", "vo/mvm/norm/spy_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/scout", "vo/mvm/norm/taunts/scout_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/soldier", "vo/mvm/norm/taunts/soldier_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/pyro", "vo/mvm/norm/taunts/pyro_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/demoman", "vo/mvm/norm/taunts/demoman_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/heavy", "vo/mvm/norm/taunts/heavy_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/engineer", "vo/mvm/norm/taunts/engineer_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/medic", "vo/mvm/norm/taunts/medic_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/sniper", "vo/mvm/norm/taunts/sniper_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/spy", "vo/mvm/norm/taunts/spy_mvm")
			snd.SoundName = string.Replace(snd.SoundName, ".wav", ".mp3")
		end
		return true
	elseif IsValid(snd.Entity) and string.find(snd.SoundName, "vo/") and GetConVar("tf_pyrovision"):GetBool() then
		if (snd.Entity:GetInfoNum("tf_special_dsp_type",-1) > -1) then
			snd.DSP = snd.Entity:GetInfoNum("tf_special_dsp_type",-1);
		end
		snd.SoundName = string.Replace(snd.SoundName, "PainCrticialDeath", "laughlong")
		snd.SoundName = string.Replace(snd.SoundName, "PainSharp", "laughshort")
		snd.SoundName = string.Replace(snd.SoundName, "PainSevere", "laughhappy")
		snd.SoundName = string.Replace(snd.SoundName, "AutoOnFire", "PositiveVocalization")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughshort02", "pyro_laughshort01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughshort03", "pyro_laughshort01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughshort04", "pyro_laughshort01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughshort05", "pyro_laughshort01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughshort06", "pyro_laughshort01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughshort07", "pyro_laughshort01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughhappy02", "pyro_laughhappy01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughhappy03", "pyro_laughhappy01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughhappy04", "pyro_laughhappy01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughhappy05", "pyro_laughhappy01")
		snd.SoundName = string.Replace(snd.SoundName, "heavy_laughshort04", "heavy_laughshort01")
		snd.SoundName = string.Replace(snd.SoundName, "heavy_laughshort05", "heavy_laughshort02")
		snd.SoundName = string.Replace(snd.SoundName, "heavy_laughlong03", "heavy_laughlong02")
		snd.SoundName = string.Replace(snd.SoundName, ".mp3", ".wav")
		snd.Pitch = 100 * 1.3
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and !snd.Entity:IsHL2() and (snd.Entity:GetInfoNum("tf_giant_robot",0) == 1 or (string.find(snd.Entity:GetModel(),"bot") and string.find(snd.Entity:GetModel(),"boss"))) and string.StartWith(snd.SoundName, "vo/") then
		if (snd.Entity:GetInfoNum("tf_special_dsp_type",-1) > -1) then
			snd.DSP = snd.Entity:GetInfoNum("tf_special_dsp_type",-1)
		end
		if (string.find(snd.Entity:GetModel(),"boss")) then
			snd.SoundName = string.Replace(snd.SoundName, "vo/", "vo/mvm/mght/")
			snd.SoundName = string.Replace(snd.SoundName, "scout", "scout_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, "soldier", "soldier_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, "pyro", "pyro_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, "demoman", "demoman_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, "heavy", "heavy_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, "engineer", "engineer_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, "medic", "medic_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, "sniper", "sniper_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, "spy", "spy_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, ".wav", ".mp3")
		else
			snd.SoundName = string.Replace(snd.SoundName, "vo/", "vo/mvm/norm/")
			snd.SoundName = string.Replace(snd.SoundName, "scout", "scout_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "soldier", "soldier_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "pyro", "pyro_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "demoman", "demoman_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "heavy", "heavy_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "engineer", "engineer_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "medic", "medic_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "sniper", "sniper_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "spy", "spy_mvm")
			snd.SoundName = string.Replace(snd.SoundName, ".wav", ".mp3")
			snd.DSP = 38
			snd.Pitch = 100 * 0.8
		end
		return true
	elseif IsValid(snd.Entity) and string.StartWith(snd.SoundName, "vo/") and snd.Entity:IsPlayer() and !snd.Entity:IsHL2() and string.StartWith(snd.Entity:GetModel(),"models/player/") and snd.Entity.playerclass != "spy"  then
		if (snd.Entity:GetInfoNum("tf_special_dsp_type",-1) > -1) then
			snd.DSP = snd.Entity:GetInfoNum("tf_special_dsp_type",-1);
		end
		if (GetConVar("tf_pyrovision"):GetBool()) then
			snd.SoundName = string.Replace(snd.SoundName, "PainCrticialDeath", "laughlong")
			snd.SoundName = string.Replace(snd.SoundName, "PainSharp", "laughshort")
			snd.SoundName = string.Replace(snd.SoundName, "PainSevere", "laughhappy")
			snd.SoundName = string.Replace(snd.SoundName, "AutoOnFire", "PositiveVocalization")
			snd.SoundName = string.Replace(snd.SoundName, "heavy_laughshort04", "heavy_laughshort01")
			snd.SoundName = string.Replace(snd.SoundName, "heavy_laughshort05", "heavy_laughshort02")
			snd.SoundName = string.Replace(snd.SoundName, "heavy_laughlong03", "heavy_laughlong02")
		end
		if (!string.find(snd.SoundName,"announcer_") && !string.find(snd.SoundName,"mvm_") && !string.find(snd.SoundName,"burp")) then
			snd.SoundName = string.Replace(snd.SoundName, ".mp3", ".wav")
		end
		return true	
	elseif IsValid(snd.Entity) and string.StartWith(snd.SoundName, "vo/") and snd.Entity:IsPlayer() and snd.Entity.playerclass == "spy" then
		if (string.find(snd.Entity:GetModel(), "scout")) then
			snd.SoundName = string.Replace(snd.SoundName, "spy_", "scout_")
		elseif (string.find(snd.Entity:GetModel(), "soldier")) then
			snd.SoundName = string.Replace(snd.SoundName, "spy_", "soldier_")
		elseif (string.find(snd.Entity:GetModel(), "pyro")) then
			snd.SoundName = string.Replace(snd.SoundName, "spy_", "pyro_")
		elseif (string.find(snd.Entity:GetModel(), "demo")) then
			snd.SoundName = string.Replace(snd.SoundName, "spy_", "demoman_")
		elseif (string.find(snd.Entity:GetModel(), "heavy")) then
			snd.SoundName = string.Replace(snd.SoundName, "spy_", "heavy_")
		elseif (string.find(snd.Entity:GetModel(), "engineer")) then
			snd.SoundName = string.Replace(snd.SoundName, "spy_", "engineer_")
		elseif (string.find(snd.Entity:GetModel(), "medic")) then
			snd.SoundName = string.Replace(snd.SoundName, "spy_", "medic_")
		elseif (string.find(snd.Entity:GetModel(), "sniper")) then
			snd.SoundName = string.Replace(snd.SoundName, "spy_", "sniper_")
		end
		if (snd.Entity:GetInfoNum("tf_special_dsp_type",-1) > -1) then
			snd.DSP = snd.Entity:GetInfoNum("tf_special_dsp_type",-1);
		end
		if (GetConVar("tf_pyrovision"):GetBool()) then
			snd.SoundName = string.Replace(snd.SoundName, "painsharp", "laughshort")
			snd.SoundName = string.Replace(snd.SoundName, "painsevere", "laughhappy")
			snd.SoundName = string.Replace(snd.SoundName, "paincrticialdeath", "laughlong")
			snd.SoundName = string.Replace(snd.SoundName, "autoonfire", "laughhappy")
		end
		if (!string.find(snd.SoundName,"announcer_") && !string.find(snd.SoundName,"mvm_")) then
			snd.SoundName = string.Replace(snd.SoundName, ".mp3", ".wav")
		end
		return true
	elseif IsValid(snd.Entity) and string.StartWith(snd.SoundName, "vo/") and snd.Entity:IsPlayer() and snd.Entity:Team() == TEAM_BLU and string.find(game.GetMap(), "mvm") then
		snd.SoundName = string.Replace(snd.SoundName, "vo/", "vo/mvm/norm/")
		snd.SoundName = string.Replace(snd.SoundName, "scout", "scout_mvm")
		snd.SoundName = string.Replace(snd.SoundName, "soldier", "soldier_mvm")
		snd.SoundName = string.Replace(snd.SoundName, "pyro", "pyro_mvm")
		snd.SoundName = string.Replace(snd.SoundName, "demoman", "demoman_mvm")
		snd.SoundName = string.Replace(snd.SoundName, "heavy", "heavy_mvm")
		snd.SoundName = string.Replace(snd.SoundName, "engineer", "engineer_mvm")
		snd.SoundName = string.Replace(snd.SoundName, "medic", "medic_mvm")
		snd.SoundName = string.Replace(snd.SoundName, "sniper", "sniper_mvm")
		snd.SoundName = string.Replace(snd.SoundName, "spy", "spy_mvm")
		snd.SoundName = string.Replace(snd.SoundName, ".wav", ".mp3")
		return true 
	end
end)