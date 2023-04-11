local mat_MotionBlur	= Material("pp/motionblur")
local mat_Screen		= Material("pp/fb")
local tex_MotionBlur	= render.GetMoBlurTex0()

local cam_collision		= GetConVar("cam_collision")
local cam_idealdist		= GetConVar("cam_idealdist")
local cam_ideallag		= GetConVar("cam_ideallag")
local cam_idealpitch	= GetConVar("cam_idealpitch")
local cam_idealyaw		= GetConVar("cam_idealyaw")
local sensitivity		= GetConVar("sensitivity")

local deathcam_dist					= CreateConVar("deathcam_dist"					, 100)
local deathcam_zoomout_delay		= CreateConVar("deathcam_zoomout_delay"			, 1.5)
local deathcam_lag					= CreateConVar("deathcam_lag"					, 2)
local deathcam_rot_approach_speed	= CreateConVar("deathcam_rot_approach_speed"	, 6)

local freezecam_dist			= CreateConVar("freezecam_dist"				, 100)
local freezecam_dist_variation	= CreateConVar("freezecam_dist_variation"	, 0.5)
local freezecam_delay			= CreateConVar("freezecam_delay"			, 2.0)
local freezecam_timetoarrive	= CreateConVar("freezecam_timetoarrive"		, 0.5)

local tf_thirdperson	= CreateConVar("cam_thirdperson"		, 0)

local taunt_angles				= Angle(0, 0, 0)
local lockangle				= nil

ThirdpersonEndDelay			= 1
SensitivityMultiplier		= 0.0032
LagMultiplier				= 2

FreezecamSpeedMultiplier	= 0.1
FreezecamMinSpeed			= 10
FreezecamMaxSpeed			= 160

--util.PrecacheSound("TFPlayer.FreezeCam")
--util.PrecacheSound("Camera.SnapShot")
util.PrecacheSound("misc/freeze_cam.wav")
util.PrecacheSound("misc/freeze_cam_snapshot.wav")

usermessage.Hook("SetPlayerKiller", function(msg)
	LocalPlayer().Killer = msg:ReadEntity()
	LocalPlayer().KillerName = msg:ReadString()
	LocalPlayer().KillerTeam = msg:ReadShort()
	LocalPlayer().KillerDominationInfo = msg:ReadChar()
	LocalPlayer().KillerPlayer = msg:ReadEntity()
	if not IsValid(LocalPlayer().KillerPlayer) then
		LocalPlayer().KillerPlayer = LocalPlayer().Killer
	end
	LocalPlayer().KillerRagdollEntity = NULL
end)

usermessage.Hook("ExitFreezecam", function()
	StopFreezeCam()
end)

--[[
hook.Add("DoPlayerDeath", "SetPlayerKiller", function(pl, attacker)
	print("penis", attacker)
	if pl==attacker or attacker:IsWorld() or not attacker:IsPlayer() or not attacker:IsNPC() then
		pl.Killer = nil
	else
		pl.Killer = attacker
	end
end)]]

hook.Add("CreateMove", "TauntMove", function(cmd)
	local s = SensitivityMultiplier * sensitivity:GetFloat()
	taunt_angles.pitch = taunt_angles.pitch	+ cmd:GetMouseY() * GetConVar("m_pitch"):GetFloat()
	taunt_angles.yaw = taunt_angles.yaw		- cmd:GetMouseX() * GetConVar("m_yaw"):GetFloat()
	if LocalPlayer():GetNWBool("Taunting") then
		if lockangle == nil then
			lockangle = taunt_angles * 1
		end

		if (LocalPlayer():GetPlayerClass() != "tank_l4d") then
			cmd:SetViewAngles(lockangle)
		end
		cmd:ClearButtons()
		cmd:ClearMovement()
		return true
	end
end)


hook.Add("CreateMove", "SimulateCamera", function(cmd)
	if not LocalPlayer().CameraAngles then
		LocalPlayer().CameraAngles = LocalPlayer():EyeAngles()
	end

	if not LocalPlayer().SimulatedCamera then
		local s = SensitivityMultiplier * sensitivity:GetFloat()
		LocalPlayer().CameraAngles.p = math.Clamp(LocalPlayer().CameraAngles.p + cmd:GetMouseY() * GetConVar("m_side"):GetFloat() * GetConVar("sensitivity"):GetFloat(), -90, 90)
		LocalPlayer().CameraAngles.y = math.NormalizeAngle(LocalPlayer().CameraAngles.y - math.Clamp(cmd:GetMouseX() * GetConVar("m_pitch"):GetFloat() * GetConVar("sensitivity"):GetFloat(), -180, 180))
	end
end)

function GM:OnViewModeChanged(tp)
	LocalPlayer():UpdateStateParticles()
end

function ViewTarget(ent)
	if ent:GetClass()=="class C_ClientRagdoll" or ent:GetClass()=="class C_HL2MPRagdoll" then
		local bone = ent:GetPhysicsObjectNum(0)
		if bone and bone:IsValid() then
			return bone:GetPos()
		end
	end
	
	if ent:IsPlayer() then
		return ent:GetPos() + ent:GetViewOffset()
	elseif ent:IsNPC() then
		return ent:GetPos() + Vector(0, 0, 50)
	end
	return ent:GetPos()
end

function SetDesiredCenteredView(pl, origin, ang, tbl)
	tbl = tbl or {}
	local newang = ang + Angle(cam_idealpitch:GetFloat(), cam_idealyaw:GetFloat(), 0)
	newang.r = 0
	local newdist = tbl.dist or cam_idealdist:GetFloat()
	
	if not pl.CurrentView then
		pl.CurrentView = {
			angles = tbl.defaultang or ang,
			distance = tbl.defaultdist or 0
		}
	end
	
	pl.TargetView = {
		angles = newang,
	}
	
	local lag = LagMultiplier/(LagMultiplier+(tbl.lag or cam_ideallag:GetFloat()))
	
	pl.CurrentView.angles = LerpAngle(lag, pl.CurrentView.angles, pl.TargetView.angles)
	pl.CurrentView.angles.r = 0
	
	if tbl.collision or cam_collision:GetBool() then
		local tr = util.TraceHull{
			start = origin,
			endpos = origin - newdist * pl.CurrentView.angles:Forward(),
			filter = pl,
			mins = Vector(-3,-3,-3),
			maxs = Vector( 3, 3, 3)
		}
		newdist = newdist * tr.Fraction
	end
	pl.TargetView.distance = newdist
	
	if pl.CurrentView.distance>pl.TargetView.distance then
		pl.CurrentView.distance = pl.TargetView.distance
	else
		pl.CurrentView.distance = Lerp(lag, pl.CurrentView.distance, pl.TargetView.distance)
	end
	if pl.FirstReality then
		return {angles = pl.CurrentView.angles, origin = origin, drawviewer = true}
	else
		return {angles = pl.CurrentView.angles, origin = origin - pl.CurrentView.distance * pl.CurrentView.angles:Forward(), drawviewer = true}
	end
end

hook.Add("CalcView", "TFCalcView", function(pl, pos, ang, fov)
	if not IsValid(pl) then
		return
	end
	
	if IsValid(GetViewEntity()) and GetViewEntity() ~= pl then
		return
	end
	--------------------------------------------------------------------------------------------
	-- FREEZECAM
	if pl.FrozenScreen then
		return {origin = pl.FreezeCamPos, angles = pl.FreezeCamAng}
	end
	
	
	--------------------------------------------------------------------------------------------
	-- DEATH CAM
	if not pl:Alive() then
		if not pl.LastDead then
			pl.CurrentView = nil
			pl.NextEndDeathcamZoomOut = CurTime() + deathcam_zoomout_delay:GetFloat()
			pl.NextFreezeCam = CurTime() + freezecam_delay:GetFloat()
			pl.CurrentDeathcamAngle = ang
		end
		
		local killer = pl.Killer
		if IsValid(killer) and IsValid(killer.DeathRagdoll) then
			pl.KillerRagdollEntity = killer.DeathRagdoll
		end
		if IsValid(pl.KillerRagdollEntity) then
			killer = pl.KillerRagdollEntity
		end
		
		if pl.NextFreezeCam and CurTime()>pl.NextFreezeCam && IsValid(killer) then
			pl.NextFreezeCam = nil
			StartFreezeCam(viewpos, killer, pl.LastKillerPos)
		end
		
		local dist
		if CurTime()<pl.NextEndDeathcamZoomOut then
			dist = Lerp((pl.NextEndDeathcamZoomOut-CurTime())/deathcam_zoomout_delay:GetFloat(),deathcam_dist:GetFloat(),0)
		else
			dist = deathcam_dist:GetFloat()
		end
		
		local rag = pl:GetRagdollEntity() or pl.RagdollEntity
		if IsValid(rag) then
			local origin
			local bone = rag:GetPhysicsObjectNum(0)
			if bone and bone:IsValid() then
				origin = bone:GetPos()
			else
				local min,max = rag:WorldSpaceAABB()
				origin = (min+max)*0.5
			end
			
			pl.DeathCamPos = origin + Vector(0,0,20)
		elseif not pl.DeathCamPos then
			pl.DeathCamPos = pl:GetPos() + Vector(0, 0, 10)
		end
		
		pl.LastDead = true
		
		if IsValid(killer) then
			pl.LastKillerPos = ViewTarget(killer)
			local targetang = (pl.LastKillerPos-pl.DeathCamPos):Angle()
			pl.CurrentDeathcamAngle.p = targetang.p
			if math.abs(math.AngleDifference(pl.CurrentDeathcamAngle.y, targetang.y))>deathcam_rot_approach_speed:GetFloat() then
				pl.CurrentDeathcamAngle.y = math.ApproachAngle(pl.CurrentDeathcamAngle.y, targetang.y, deathcam_rot_approach_speed:GetFloat())
			else
				pl.CurrentDeathcamAngle.y = targetang.y
			end
		end
	else
		if pl.LastDead then
			pl.CurrentView = nil
			pl.Killer = nil
			pl.LastKillerPos = nil
		end
		
		pl.DeathCamPos = nil
		pl.LastDead = false
	end
	
	
	--------------------------------------------------------------------------------------------
	-- THIRD PERSON
	if not pl.IsThirdperson and not tf_thirdperson:GetBool() then
		return
	end
	
	if pl.SimulatedCamera and pl.CameraAngles then
		ang = pl.CameraAngles
	end

	if pl.FirstReality and pl:Alive() then
		if pl:IsHL2() then
			pos = pl:GetBonePosition(pl:LookupBone("ValveBiped.Bip01_Head1"))+(ang:Up()*10)+(ang:Forward()*5)
			pl:ManipulateBoneScale(pl:LookupBone("ValveBiped.Bip01_Head1"), Vector(0,0,0))
			pos = pl:GetBonePosition(pl:LookupBone("ValveBiped.Bip01_Head1"))+(ang:Up()*10)+(ang:Forward()*5)
		elseif (pl:IsL4D()) then
			pl:ManipulateBoneScale(0, Vector(0,0,0))
			pos = pl:GetBonePosition(0)+(ang:Up()*10)+(ang:Forward()*5)
		else
			pl:ManipulateBoneScale(pl:LookupBone("bip_head"), Vector(0,0,0))
			pos = pl:GetBonePosition(pl:LookupBone("bip_head"))+(ang:Up()*10)+(ang:Forward()*5)
		end
	end
	
	if pl.TauntingCam then
		ang = taunt_angles
	else
		ang = taunt_angles + pl:GetViewPunchAngles()
		ang = Angle(Angle(math.Clamp(ang.p, -80, 80), ang.y, ang.r))
		local angle = (util.QuickTrace(pos, ang:Forward() * 5024, pl).HitPos - pl:GetShootPos()):Angle()
		pl:SetEyeAngles(Angle(angle.p, angle.y, ang.r))
	end

	if pl.NextEndThirdperson then
		if CurTime()>pl.NextEndThirdperson then
			pl.NextEndThirdperson = nil
			pl.IsThirdperson = false
			pl.SimulatedCamera = false
			pl.FirstReality = false
			pl.TauntingCam = false
			--[[if not IsValid(GetViewEntity()) or GetViewEntity()==LocalPlayer() then
				gamemode.Call("OnViewModeChanged", false)
			end]]
			return
		else
			if pl.CurrentView and not tf_thirdperson:GetBool() then -- stupid bug fix
				if pl.TauntingCam then
					pl:SetEyeAngles(taunt_angles)
				end
				pl.CurrentView.angles = ang
				pl.CurrentView.distance = Lerp((pl.NextEndThirdperson - CurTime())/ThirdpersonEndDelay, 0, pl.TargetView.distance)
				if pl:IsHL2() then
					pl:ManipulateBoneScale(pl:LookupBone("ValveBiped.Bip01_Head1"), Vector(1,1,1)) -- we can't let them see a shrunk head when transferring back!
				elseif pl:IsL4D() then
					pl:ManipulateBoneScale(0, Vector(1,1,1)) -- we can't let them see a shrunk head when transferring back!
				else
					pl:ManipulateBoneScale(pl:LookupBone("bip_head"), Vector(1,1,1))
				end
				return {angles = pl.CurrentView.angles, origin = pos - pl.CurrentView.distance * pl.CurrentView.angles:Forward(), drawviewer = true}
			end
		end
	end
	
	return SetDesiredCenteredView(pl, pos, ang)
end)

function GM:PostProcessPermitted(pp)
	-- Don't apply post processing when freezecam is active
	if LocalPlayer().FrozenScreen and LocalPlayer().FrozenScreenReady then
		return false
	end
	return self.BaseClass:PostProcessPermitted(pp)
end

function GM:RenderScreenspaceEffects()
	self.BaseClass:RenderScreenspaceEffects()
	
	if LocalPlayer().FrozenScreen then
		if not LocalPlayer().FrozenScreenReady then
			-- Capture the screen when every post processing operation is done
			render.UpdateScreenEffectTexture()
			mat_Screen:SetFloat("$alpha", 1)
			
			local OldRT = render.GetRenderTarget()
			render.SetRenderTarget(tex_MotionBlur)
			render.SetMaterial(mat_Screen)
			render.DrawScreenQuad()
			render.SetRenderTarget(OldRT)
			
			LocalPlayer().FrozenScreenReady = true
			CalloutPanel:SetupCalloutPanels()
			return
		end
		
		mat_MotionBlur:SetFloat("$alpha", 1)
		mat_MotionBlur:SetTexture("$basetexture", tex_MotionBlur)
		render.SetMaterial(mat_MotionBlur)
		render.DrawScreenQuad()
	end
end

function GM:ShouldDrawLocalPlayer()
	return LocalPlayer().IsThirdperson
end

function StartThirdperson()
	LocalPlayer().IsThirdperson = true
	LocalPlayer().CurrentView = nil
	
	--[[if not IsValid(GetViewEntity()) or GetViewEntity()==LocalPlayer() then
		gamemode.Call("OnViewModeChanged", true)
	end]]
end

function EndThirdperson(immediate)
	if immediate then
		LocalPlayer().NextEndThirdperson = nil
		LocalPlayer().IsThirdperson = false
	else
		LocalPlayer().NextEndThirdperson = CurTime() + ThirdpersonEndDelay
	end
end

net.Receive("ActivateTauntCam", function()
	if LocalPlayer().FirstReality == true then return end
	LocalPlayer().IsThirdperson = true
	LocalPlayer().CurrentView = nil
	LocalPlayer().TauntingCam = true
	lockangle = LocalPlayer():GetAngles()
	taunt_angles = LocalPlayer():GetAngles()
end)

net.Receive("DeActivateTauntCam", function()
	if LocalPlayer().FirstReality == true then return end
	LocalPlayer().NextEndThirdperson = CurTime() + ThirdpersonEndDelay
end)

function StartSimulatedCamera()
	LocalPlayer().SimulatedCamera = true
	print(LocalPlayer().CameraAngles)
	LocalPlayer().CameraAngles = nil
end

function PrintSimulatedCamera()
	print(LocalPlayer().CameraAngles)
end

function EndSimulatedCamera()
	LocalPlayer().SimulatedCamera = false
end

function StartFirstReality()
	StartThirdperson()
	LocalPlayer().FirstReality = true
end

function EndFirstReality()
	EndThirdperson()
	LocalPlayer().FirstReality = false
end

function StartFreezeScreen()
	LocalPlayer().FrozenScreen = true
	LocalPlayer().FrozenScreenReady = false
end

function StopFreezeScreen()
	LocalPlayer().FrozenScreen = false
end

function StartFreezeCam(startpos, target, defaultpos)
	FreezePanelBase:Show()
end

function StopFreezeCam()
	FreezePanelBase:Hide()
	
	LocalPlayer().FreezeCam = false
	StopFreezeScreen()
	StopScreenshot()
end

function StartScreenshot()
	if LocalPlayer().InScreenshot then return end
	
	GAMEMODE:HideHUDElement("CHudChat")
	LocalPlayer().InScreenshot = true
	FreezePanelBase:InvalidateLayout()
	CalloutPanel:RefreshCalloutPanels()
	LocalPlayer().ScreenshotStage = 0
end

function StopScreenshot()
	GAMEMODE:ShowHUDElement("CHudChat")
	LocalPlayer().InScreenshot = false
	FreezePanelBase:InvalidateLayout()
	LocalPlayer().ScreenshotStage = nil
end

hook.Add("PlayerBindPress", "ScreenshotPress", function(pl, bind)
	if pl==LocalPlayer() and LocalPlayer().FrozenScreen and LocalPlayer().FrozenScreenReady and bind=="jpeg" then
		StartScreenshot()
		return true
	end
end)

hook.Add("Think", "ViewEntityCheck", function()
	local viewent = GetViewEntity()
	local lastviewent = LocalPlayer().LastViewEntity
	
	local shoulddraw = LocalPlayer():ShouldDrawLocalPlayer()
	local lastshoulddraw = LocalPlayer().LastShouldDrawLocalPlayer
	
	--[[
	if lastviewent then
		if viewent ~= lastviewent then
			if (IsValid(viewent) and viewent~=LocalPlayer()) and not (IsValid(lastviewent) and lastviewent~=LocalPlayer()) then
				gamemode.Call("OnViewModeChanged", true)
			elseif not (IsValid(viewent) and viewent~=LocalPlayer()) and (IsValid(lastviewent) and lastviewent~=LocalPlayer()) then
				gamemode.Call("OnViewModeChanged", false)
			end
		end
	end]]
	
	if shoulddraw ~= lastshoulddraw then
		gamemode.Call("OnViewModeChanged", shoulddraw)
	end
	
	LocalPlayer().LastShouldDrawLocalPlayer = shoulddraw
	LocalPlayer().LastViewEntity = viewent
end)

hook.Add("Think", "ScreenshotProcess", function()
	local st = LocalPlayer().ScreenshotStage
	
	if st==0 then
		LocalPlayer().ScreenshotStage = 1
	elseif st==1 then
		RunConsoleCommand("jpeg")
		LocalPlayer().ScreenshotStage = 2
	elseif st==2 then
		CalloutPanel:Flash(0.5)
		LocalPlayer().ScreenshotStage = nil
	end
end)

concommand.Add("tf_firstperson", function(pl)
	if pl.IsThirdperson then
		EndThirdperson()
	end
end)

concommand.Add("tf_thirdperson", function(pl)
	if not pl.IsThirdperson then
		StartThirdperson()
	end
end)

concommand.Add("tf_tp_thirdperson_toggle", function(pl)
	if not pl.IsThirdperson then
		StartThirdperson()
	else
		EndThirdperson()
	end
end)

concommand.Add("tf_tp_simulation_toggle", function(pl)
	if not pl.IsThirdperson then
		StartSimulatedCamera()
		StartThirdperson()
	else
		EndThirdperson()
	end
end)

concommand.Add("tf_simulation_off", function(pl)
	EndSimulatedCamera()
end)

concommand.Add("tf_simulation_on", function(pl)
	StartSimulatedCamera()
end)

concommand.Add("tf_tp_immersive_toggle", function(pl)
	if not pl.IsThirdperson then
		StartThirdperson()
		StartSimulatedCamera()
	else
		EndThirdperson()
	end
end)

concommand.Add("tf_simulation_print", function(pl)
	PrintSimulatedCamera()
end)

concommand.Add("tf_tp_immersive_toggle", function(pl)
	if not pl.IsThirdperson then
		StartFirstReality()
	else
		EndFirstReality()
	end
end)