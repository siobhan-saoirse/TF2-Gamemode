hook.Add( "CalcView", "SetPosToRagdoll", function( ply, pos, angles, fov )
	if (!ply:Alive()) then
		if (IsValid(ply:GetNWEntity("RagdollEntity"))) then
			if (ply:GetObserverMode() == OBS_MODE_DEATHCAM and ply:GetObserverMode() != OBS_MODE_FREEZECAM) then
				local newdist = 115
				local origin = ply:GetNWEntity("RagdollEntity"):GetPos()
				if GetConVar("cam_collision"):GetBool() then
					local tr = util.TraceHull{
						start = origin,
						endpos = origin - newdist * angles:Forward(),
						filter = {ply,ply:GetNWEntity("RagdollEntity")},
						mins = Vector(-3,-3,-3),
						maxs = Vector( 3, 3, 3)
					}
					newdist = newdist * tr.Fraction
				end
				local view = {
					origin = ply:GetNWEntity("RagdollEntity"):GetPos() - ( angles:Forward() * newdist ),
					angles = angles,
					fov = fov,
					drawviewer = true
				}	
				return view
			end
		end
	end
end )
 
if (IsValid(LocalPlayer())) then
	LocalPlayer():PrintMessage(HUD_PRINTTALK, "SERVER IS RELOADING THE GAMEMODE DUE TO AN EDIT IN THE GAMEMODE'S CLIENTSIDE CODE - GRAPHICAL OR GAME-BREAKING GLITCHES MAY OCCUR")
	LocalPlayer():PrintMessage(HUD_PRINTCENTER, "SERVER IS RELOADING THE GAMEMODE DUE TO AN EDIT IN THE GAMEMODE'S CLIENTSIDE CODE - GRAPHICAL OR GAME-BREAKING GLITCHES MAY OCCUR")
end

local LOGFILE = "teamfortress/log_client.txt"
file.Delete(LOGFILE)
file.Append(LOGFILE, "Loading clientside script\n")
local load_time = SysTime()
local blacklist = {["Frying Pan"] = true, ["Golden Frying Pan"] = true, ["The PASSTIME Jack"] = true, ["TTG Max Pistol"] = true, ["Sexo de Pene Gay"] = true, ["Team Spirit"] = true,} -- Items that should NEVER show, must be their item.name if a hat/weapon!
local name_blacklist = {["The AK47"] = true,} -- Weapons that have names of other weapons must have their item.name put in here
CreateClientConVar("civ2_enable_survivor_steps", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE})
include("tf_lang_module.lua")
include("shd_items.lua")
tf_lang.Load("tf_english.txt")

include("cl_proxies.lua")
include("cl_pickteam.lua")

include("cl_conflict.lua")
include("cl_loadout.lua") 
include("shared.lua")
include("cl_entclientinit.lua")
include("cl_deathnotice.lua")
include("cl_scheme.lua")

include("cl_player_other.lua")

include("cl_camera.lua")

include("tf_draw_module.lua")

include("cl_materialfix.lua")

include("cl_pac.lua")

include("proxies/itemtintcolor.lua")

include("proxies/sniperriflecharge.lua")
include("proxies/weapon_invis.lua")
include("proxies/burnlevel.lua")
include("proxies/yellowlevel.lua")
include("proxies/modelglowcolor.lua")
include("proxies/playercolor.lua")
include("shd_gravitygun.lua")

CreateClientConVar( "tf_haltinspect", "1", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Whether or not players can inspect while no-clipping." )
CreateClientConVar( "tf_maxhealth_hud", "1", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Enable maxhealth above health when hurt." )
CreateClientConVar( "tf_robot", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become a robot after respawning." )
CreateClientConVar( "tf_usehwmmodels", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become a higher quality version of your current playermodel after respawning." )
CreateClientConVar( "tf_usehwmvcds", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE} )
CreateClientConVar( "tf_useadvhwmmodels", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become a advanced, higher quality version of your current playermodel after respawning." )
CreateClientConVar( "tank_l4d1_skin", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE} )
CreateClientConVar( "tank_dlc3_skin", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE} )
CreateClientConVar( "tank_use_dark_carnival_finale_music", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE} )
CreateClientConVar( "boomer_l4d1_skin", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE} )
CreateClientConVar( "hunter_l4d1_skin", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE} )
CreateClientConVar( "smoker_l4d1_skin", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE} )
CreateClientConVar( "tf_special_dsp_type", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Set your DSP for your Voice - Example: 154 - Engineer Fly Voice" )
CreateClientConVar( "tf_tfc_model_override", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become a TFC Merc after respawning." )
CreateClientConVar( "tf_giant_robot", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become a mighty robot after respawning." )
CreateClientConVar( "tf_sentrybuster", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become a mighty bustah after respawning." )
CreateClientConVar( "tf_skeleton", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Spooky... https://youtu.be/fPRMLk3jHX4" )
CreateClientConVar( "tf_yeti", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become a ordinary yeti after respawning." )
CreateClientConVar( "tf_hhh", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become HHH Jr. after respawning." )
CreateClientConVar( "tf_player_use_female_models", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "For testing. Appends '_female' to the model filename loaded. SOLDIER ONLY" )
CreateClientConVar( "civ2_bootleg_charger", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become a bootleg charger after respawning." )
CreateClientConVar( "tf_dingalingaling_sound", "", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Ding Dong!" )
CreateClientConVar( "tf_dingalingaling_killsound", "", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Diiinnng...." )




hook.Add( "PopulateToolMenu", "Civ2Settings1", function()
	spawnmenu.AddToolMenuOption( "Civ2Options", "Civilian 2", "Options", "#Civilian 2 Settings", "", "", function( panel )
		panel:ClearControls()
		panel:CheckBox( "Use Minimized Viewmodels", "tf_use_min_viewmodels" )
		panel:CheckBox( "Enable Pyrovision", "tf_pyrovision" )
		panel:NumSlider( "Viewmodel FOV", "viewmodel_fov_tf", 52, 120 )
		panel:CheckBox( "Force HEV Hud", "tf_forcehl2hud" )
		panel:CheckBox( "Enable Debugging for TF Bots", "z_debug" )
		if (IsMounted("left4dead2")) then
			panel:CheckBox( "Enable L4D2 Footsteps for GMOD Player", "civ2_enable_survivor_steps" )
		end
		panel:Button("Toggle Thirdperson","tf_tp_simulation_toggle","")
		panel:Button("Toggle Shoulder Thirdperson","tf_tp_thirdperson_toggle","")
		panel:Button("Toggle Immersive View","tf_tp_immersive_toggle","")
		panel:NumSlider( "Special Voice DSP Type", "tf_special_dsp_type", 1, 135 )
		panel:CheckBox( "Right Handed", "tf_righthand" )
		-- Add stuff here
	end )
	spawnmenu.AddToolMenuOption( "Civ2Customization", "Civilian 2", "Customization", "#Customization Settings", "", "", function( panel )
		panel:ClearControls()
		panel:CheckBox( "Become a Robot", "tf_robot" )
		panel:CheckBox( "Become a TFC Mercnary", "tf_tfc_model_override" )
		panel:CheckBox( "Become a Skeleton", "tf_skeleton" )
		panel:CheckBox( "Become an Ordinary Yeti", "tf_yeti" )
		panel:CheckBox( "Use HWM Models", "tf_usehwmmodels" )
		panel:CheckBox( "Use Advanced Character Models (requires an addon)", "tf_useadvhwmmodels" )
	end )
end )


--[[
timer.Create("lol",0.2,0,function() m=T:GetBoneMatrix(T:LookupBone("bip_head")) m:Translate(Vector(0,-5,0)) local e=EffectData() e:SetOrigin(m:GetTranslation()) e:SetAngles(Angle(180,0,0)) util.Effect("BloodImpact",e) end)

LocalPlayer().BuildBonePositions=function(pl) local m = pl:GetBoneMatrix(pl:LookupBone("bip_neck")) m:Scale(Vector(0,0,0)) m:Translate(Vector(0,0,0)) pl:SetBoneMatrix(pl:LookupBone("bip_neck"),m) end

TBB=function() local m=P:GetBoneMatrix(P:LookupBone("bip_spine_3")) m:Rotate(Angle(-10,0,-20)) m:Translate(Vector(0,-8,-3.5)) T:SetBoneMatrix(T:LookupBone("bip_head"),m) end

]]

--include("vgui/vgui_teammenubg.lua")

--[[
tf_util.AddDebugInfo("move_x", function()
	return "forward : "..tostring(LocalPlayer():GetNWFloat("MoveForward"))
end)

tf_util.AddDebugInfo("move_y", function()
	return "side : "..tostring(LocalPlayer():GetNWFloat("MoveSide"))
end)

tf_util.AddDebugInfo("move_z", function()
	return "up : "..tostring(LocalPlayer():GetNWFloat("MoveUp"))
end)]]

hook.Add("RenderScreenspaceEffects", "RenderPlayerStateOverlay", function()
	if IsValid(LocalPlayer()) then
		LocalPlayer():DrawStateOverlay()
	end
end)


GM.Menu = {}

RunConsoleCommand("snd_restart")

local sndMenu1 = Sound("ui/item_info_mouseover.wav")
local sndMenu2 = Sound("ui/buttonrollover.wav")
local sndMenu3 = Sound("ui/buttonclick.wav")
local sndMenu4 = Sound("ui/item_info_mouseover.wav")

local menuframeColor = Color(20, 20, 20, 200)
local menuTextCol = Color(200, 200, 200, 180)
local menuTextSelected = Color(255, 255, 255, 255)
local buttoncolorDisabled = Color(50, 50, 50, 160)

-- Taken from HL1 COOP Gamemode. Credit goes to the creators! I do not own some of these codes! 
function GM:PreRender()
	if gui.IsGameUIVisible() and self.Menu.MainMenuFrame and self.Menu.MainMenuFrame:IsVisible() then
		self:CloseMenus()
		RunConsoleCommand("pause")
	end
	if input.IsKeyDown(KEY_ESCAPE) and gui.IsGameUIVisible() then
		gui.HideGameUI()
		self:OpenMainMenu()
		return true
	--else
		--showGameUI = false
	end
end 


local t_selected = Material("gui/contenticon-hovered.png")

function GM:VoteMenuOptions()
	local votes = {
		{"Vote Map", function() self:CloseMenus() self:OpenMapVote() end},
		{"Vote Kick Someone", function() self:CloseMenus() self:OpenKickVote() end},
	}
	return votes
end

function GM:VoteMenu()
	if IsValid(self.Menu.voteMenu) and self.Menu.voteMenu:IsVisible() then
		self.Menu.voteMenu:DoHideAnim()
		return
	end
	
	local votes = self:VoteMenuOptions()
	self.Menu.voteMenu = vgui.Create("DPanel", self.Menu.MainMenuFrame)
	local voteMenu = self.Menu.voteMenu
	local mainMenuPosX, mainMenuPosY = self.Menu.MainMenuFrame:GetPos()
	local voteOptionCount = #votes
	for k, v in pairs(votes) do
		if v.available and !v.available() then
			voteOptionCount = voteOptionCount - 1
		end
	end
	voteMenu:SetSize(self.Menu.MainMenuFrame:GetWide() - 88, voteOptionCount * ScrH() / 16.5 + 36)
	local voteMenuStart = 0
	local voteMenuW, voteMenuH = voteMenu:GetSize()
	voteMenu:SetBackgroundColor(menuframeColor)
	voteMenu:MakePopup()
	voteMenu.AnimType = 1
	
	function voteMenu:DoStartAnim()
		self.AnimType = 1
	end
	function voteMenu:DoHideAnim()
		self.AnimType = 2
	end

	for k, v in pairs(votes) do
		if v.available and !v.available() then
			continue
		end
		local tw, th = surface.GetTextSize(v[1])
		tw = tw + 44
		if tw > voteMenuW then
			voteMenuW = tw
		end
		
		local l = vgui.Create("DLabel", voteMenu)
		l:Dock(TOP)
		l:DockMargin(20, 20, 0, -16)
		l:SetTextColor()
		l:SetFont("ItemFontNameLarge")
		l:SetText(v[1])
		l:SizeToContents()
		l:SetMouseInputEnabled(true)
		function l:OnCursorEntered()
			surface.PlaySound(sndMenu2)
			self:SetTextColor(Color(255,255,255,255))
			
			if v[3] then
				local x, y = self:GetPos()
				local vx, vy = voteMenu:GetPos()
				self.hint = vgui.Create("DLabel", voteMenu)
				self.hint:SetPos(vx + voteMenuW + x, vy + y + 8)
				self.hint:SetTextColor(Color(255,255,230,255))
				self.hint:SetFont("ItemFontNameLarge")
				self.hint:SetText(v[3])
				self.hint:SizeToContents()
				self.hint:MakePopup()
			end
		end
		function l:OnCursorExited()
			self:SetTextColor()
			
			if IsValid(self.hint) then
				self.hint:Remove()
			end
		end
		function l:DoClick()
			surface.PlaySound(sndMenu3)
			timer.Simple(0.1, function()
				surface.PlaySound(sndMenu4)
			end)
			v[2]()
		end
	end
	
	function voteMenu:AnimationThink()
		mainMenuPosX, mainMenuPosY = GAMEMODE.Menu.MainMenuFrame:GetPos()
		self:SetPos(mainMenuPosX + GAMEMODE.Menu.MainMenuFrame:GetWide(), ScrH() / 3 - voteMenuH / 6)
	
		local FT = FrameTime()
		if game.SinglePlayer() then
			FT = FT + .01
		end
		if self.AnimType == 1 then
			voteMenuStart = Lerp(FT*50, voteMenuStart, voteMenuW)
			self:SetWidth(voteMenuStart)
			if self:GetWide() == voteMenuW - 1 then
				self.AnimType = nil
			end
		elseif self.AnimType == 2 then
			voteMenuStart = Lerp(FT*50, voteMenuStart, 0)
			self:SetWidth(voteMenuStart)
			if self:GetWide() == 0 then
				self:Remove()
			end
		end
	end
end
	
function GM:OpenMapVote()
	self.Menu.voteMenu = vgui.Create("DPanel")
	local mapVoteMenu = self.Menu.voteMenu
	mapVoteMenu:SetSize(ScrW() / 1.5, ScrH() / 1.3)
	local mapVoteMenuW, mapVoteMenuH = mapVoteMenu:GetSize()
	mapVoteMenu:SetPos(ScrW() / 2 - mapVoteMenuW / 2, ScrH() / 2 - mapVoteMenuH / 2)
	mapVoteMenu:SetBackgroundColor(menuframeColor)
	mapVoteMenu:MakePopup()
	
	local menuTitle = vgui.Create("DLabel", mapVoteMenu)
	menuTitle:SetText("Vote Map")
	menuTitle:SizeToContents()
	menuTitle:SetPos(20, 10)
	menuTitle:SetColor(menuTextCol)
	
	local voteMap = vgui.Create("DScrollPanel", mapVoteMenu)
	voteMap:SetSize(mapVoteMenuW - 40, mapVoteMenuH / 1.5)
	voteMap:SetPos(20, menuTitle:GetTall() + 20)
	voteMap:SetPaintBackground(true)
	voteMap:SetBackgroundColor(Color(100, 100, 100, 180))
	local voteMapW, voteMapH = voteMap:GetSize()
	local mapList = vgui.Create("DIconLayout", voteMap)
	mapList:SetSize(voteMapW, voteMapH)
	mapList:SetPos(voteMapW / 40, voteMapW / 40)
	mapList:SetSpaceY(5)
	mapList:SetSpaceX(5)
	
	local maps = file.Find("maps/*.bsp", "GAME")
	for k, map in pairs(maps) do
		map = string.StripExtension(map)
		if string.find(map, "ctf") or string.find(map, "mvm") or string.find(map, "gm") then
			local ListItem = mapList:Add("DImageButton")
			ListItem:SetSize(mapList:GetWide() / 7.725, mapList:GetWide() / 7.725)
			ListItem:SetImage("maps/thumb/"..map..".png")
			ListItem:SetText(map)
			ListItem.DoClick = function()
				voteMap.SelectedMap = map
			end
			ListItem.PaintOver = function(ListItem, w, h)
				draw.SimpleText(ListItem:GetText(), "default", w / 2, h - 8, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
				if voteMap.SelectedMap == map then
					surface.SetDrawColor(255,255,255,255)
					surface.SetMaterial(t_selected)
					surface.DrawTexturedRect(-2, -2, w+4, h+4)
				end
			end
		end
	end
	
	local VmapButton = vgui.Create("DLabel", mapVoteMenu)
	VmapButton:SetText("Vote Map")
	VmapButton:SizeToContents()
	VmapButton:SetPos(mapVoteMenuW / 2 - VmapButton:GetWide() / 2, mapVoteMenuH - VmapButton:GetTall() - 32)
	VmapButton:SetMouseInputEnabled(true)
	function VmapButton:DoClick()
		if voteMap.SelectedMap then
			RunConsoleCommand("ulx", "votemap2", voteMap.SelectedMap)
			GAMEMODE:CloseMenus()
		end 
	end
end

function GM:OpenKickVote()
	self.Menu.voteMenu = vgui.Create("DPanel")
	local voteKickMenu = self.Menu.voteMenu
	voteKickMenu:SetSize(ScrW() / 3, ScrH() / 1.3)
	local voteKickMenuW, voteKickMenuH = voteKickMenu:GetSize()
	voteKickMenu:SetPos(ScrW() / 2 - voteKickMenuW / 2, ScrH() / 2 - voteKickMenuH / 2)
	voteKickMenu:SetBackgroundColor(menuframeColor)
	voteKickMenu:MakePopup()
	
	local menuTitle = vgui.Create("DLabel", voteKickMenu)
	menuTitle:SetText("Vote Kick")
	menuTitle:SizeToContents()
	menuTitle:SetPos(20, 10)
	menuTitle:SetColor(menuTextCol)

	local players = player.GetAll()
	
	local voteKick = vgui.Create("DPanel", voteKickMenu)
	local voteKickX, voteKickY = 20, menuTitle:GetTall() + 20
	voteKick:SetPos(voteKickX, voteKickY)
	voteKick:SetSize(voteKickMenuW - voteKickX*2, voteKickMenuH - voteKickY - 100)
	voteKick:SetBackgroundColor(Color(100, 100, 100, 180))
	
	local plyList = vgui.Create("DScrollPanel", voteKick)
	plyList:SetPos(25, 25)
	plyList:SetSize(voteKick:GetWide() - 50, voteKick:GetTall() - 50)
	
	local ppos = 0
	for k, ply in pairs(players) do
		k = vgui.Create("DLabel", plyList)
		k:SetPos(0, ppos)
		ppos = ppos + 30
		k:SetFont("DermaLarge")
		k:SetText(ply:Nick())
		//k:SetTextColor(v.col)
		k:SizeToContents()
		k:SetMouseInputEnabled(true)
		function k:DoClick()
			plyList.SelectedPlayer = ply
		end
		k.PaintOver = function(k, w, h)
			if plyList.SelectedPlayer == ply then
				surface.SetDrawColor(255,255,255,255)
				surface.SetMaterial(t_selected)
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end
	end
	
	local kickButton = vgui.Create("DLabel", voteKickMenu)
	
	kickButton:SetText("Vote Kick")
	kickButton:SizeToContents()
	kickButton:SetPos(voteKickMenu:GetWide() / 2 - kickButton:GetWide() / 2, voteKickMenu:GetTall() - kickButton:GetTall() - 32)
	kickButton:SetMouseInputEnabled(true)
	function kickButton:DoClick()
		if plyList.SelectedPlayer and IsValid(plyList.SelectedPlayer) then
			RunConsoleCommand("ulx", "votekick", plyList.SelectedPlayer:Nick())
			GAMEMODE:CloseMenus()
		end
	end
end 

function GM:CloseMenus()
	if game.SinglePlayer() and self.Menu.MainMenuFrame and self.Menu.MainMenuFrame:IsVisible() then
		RunConsoleCommand("unpause")
	end
	for k, v in pairs(self.Menu) do
		if IsValid(v) then
			v:Remove()
		end
	end
end


	hook.Add('StartChat', 'TalkIcon', function(isteam)
		--ParticleEffectAttach( "speech_typing", PATTACH_POINT_FOLLOW, LocalPlayer(), LocalPlayer():LookupAttachment("head") )
	end)

	hook.Add('FinishChat', 'TalkIcon', function()	
		--LocalPlayer():StopParticlesNamed( "speech_typing"  )
	end)
	
	function GM:ShouldDrawLocalPlayer( ply )
		
		if (GetConVar("tf_enable_server_footsteps"):GetBool()) then
			return true
		else
			return player_manager.RunClass( ply, "ShouldDrawLocal" )
		end
	
	end
function GM:OpenMainMenu()
	--showGameUI = false
	
	if IsValid(self.langSettings) and self.langSettings:IsVisible() then
		self.langSettings:Remove()
		return
	end	
	if IsValid(self.quickMenu) and self.quickMenu:IsVisible() then
		self.quickMenu:Remove()
		return
	end
	
	if self.Menu.MainMenuFrame and self.Menu.MainMenuFrame:IsVisible() then
		self:CloseMenus()
		return
	end
	
	local menu = {
		{"Resume Game", function() RunConsoleCommand("pause") self:CloseMenus() end},
		
		{"Mute a Player", function() self:CloseMenus() RunConsoleCommand("pause") RunConsoleCommand("gamemenucommand", "openplayerlistdialog") gui.ActivateGameUI() end},
		
		{"Find Servers", function() self:CloseMenus() gui.ActivateGameUI() RunConsoleCommand("gamemenucommand", "openserverbrowser") end},	
		
		{"Options", function() self:CloseMenus() RunConsoleCommand("pause") RunConsoleCommand("gamemenucommand", "openoptionsdialog") gui.ActivateGameUI() end},
		
		{"Garry's Mod Menu", function() self:CloseMenus() gui.ActivateGameUI() end},
		
		{"Join Official Server", function() 
			local conflict_help_frame = vgui.Create( "DFrame" )
			conflict_help_frame:SetSize(200, 200)
			conflict_help_frame:Center()
			conflict_help_frame:SetTitle("Warning")
			conflict_help_frame:ShowCloseButton(true)
			conflict_help_frame:SetBackgroundBlur(true)
			conflict_help_frame:MakePopup()

			local conflicttext = vgui.Create("RichText", conflict_help_frame)
			conflicttext:Dock(FILL)
			conflicttext:InsertColorChange(255, 255, 255, 255)
			conflicttext:CenterHorizontal(0.5)
			conflicttext:SetVerticalScrollbarEnabled(false)
			conflicttext:AppendText("Are you sure you want to join the Civilian 2 Server?\nThis may not work if the server is offline!")

			local conflictbut = vgui.Create("DButton", conflict_help_frame)
			conflictbut:SetSize(30, 20)
			conflictbut:SetPos(0, 145)
			conflictbut:CenterHorizontal(0.4)
			conflictbut:SetText("Yes")
			
			local conflictbut2 = vgui.Create("DButton", conflict_help_frame)
			conflictbut2:SetSize(30, 20)
			conflictbut2:SetPos(0, 145)
			conflictbut2:CenterHorizontal(0.6)
			conflictbut2:SetText("No")

			function conflictbut.DoClick()
				conflict_help_frame:Close()	
				surface.PlaySound("ui/mm_join.wav")
					LocalPlayer():PrintMessage( HUD_PRINTCENTER, "Joining in 5 seconds" )
				timer.Simple(1, function()
					LocalPlayer():PrintMessage( HUD_PRINTCENTER, "Joining in 4 seconds." )
					timer.Simple(1, function()
						LocalPlayer():PrintMessage( HUD_PRINTCENTER, "Joining in 3 seconds.." )
						timer.Simple(1, function()
							LocalPlayer():PrintMessage( HUD_PRINTCENTER, "Joining in 2 seconds..." )
							timer.Simple(1, function()
								LocalPlayer():PrintMessage( HUD_PRINTCENTER, "Joining in 1 seconds." )				
								timer.Simple(1, function()
									LocalPlayer():PrintMessage( HUD_PRINTCENTER, "Joining.." )
								end)
							end)
						end)
					end)
				end)
				timer.Simple(5, function()
					RunConsoleCommand('connect','p2p:76561198202095595')
				end)
			end
			function conflictbut2.DoClick()
				conflict_help_frame:Close()	
			end 
		end},

		{"Disconnect", function() RunConsoleCommand("gamemenucommand", "disconnect") RunConsoleCommand("cl_wpn_sway_interp","0.1") end},
		{"Quit", function() self:CloseMenus() RunConsoleCommand("pause") RunConsoleCommand("gamemenucommand", "quit") end}
	}

	self.Menu.MainMenuFrame = vgui.Create("DPanel")
	self.Menu.MainMenuFrame:SetPos(ScrW() / 512, 0)
	self.Menu.MainMenuFrame:SetSize(ScrW(), ScrH())
	self.Menu.MainMenuFrame:SetBackgroundColor(menuframeColor)
	self.Menu.MainMenuFrame:MakePopup()
	self.AnimType = 1
	local menuW, menuH = self.Menu.MainMenuFrame:GetSize()
	local menuX, menuY = self.Menu.MainMenuFrame:GetPos()
	local menuStart = 0 - menuW
	function self.Menu.MainMenuFrame:OnCursorEntered()
		if self.Hidden and (!self.NextAnim or self.NextAnim <= RealTime()) then
			self.AnimType = 1
			menuX = 150 - menuW
			self.NextAnim = RealTime() + 1
		end
	end
	function self.Menu.MainMenuFrame:OnCursorExited()
		if self.Hidden then
			self.AnimType = 3
			menuStart = 40 - menuW
			self.NextAnim = RealTime() + 1
		end
	end
	function self.Menu.MainMenuFrame:OnMousePressed(key)
		if self.Hidden and key == MOUSE_FIRST then
			GAMEMODE:CloseSubMenus()
			self:Popup()
		end
	end
	
	local hl1cooplogo = vgui.Create("DImage", self.Menu.MainMenuFrame)
	hl1cooplogo:SetSize(menuH / 2, menuH / 9)
	local hl1cooplogoW, hl1cooplogoH = hl1cooplogo:GetSize()
	hl1cooplogo:SetPos(menuW / 2 - hl1cooplogoW / 2, 15)
	hl1cooplogo:SetImage("gamemodes/teamfortress/logo.png")
	
	local menuEntryPos = ScrH() / 4
	
	for k, v in pairs(menu) do
		local invisible
		if !LocalPlayer():IsSuperAdmin() and v.adminonly then
			invisible = true
		end
		local namefunc = v[3]
		local disabled
		if namefunc and namefunc() == false then
			disabled = true
		end
		menuEntryPos = menuEntryPos + menuH / 24
		k = vgui.Create("DLabel", self.Menu.MainMenuFrame)
		k:SetPos(menuW / 8, menuEntryPos)
		k:SetFont("ItemFontNameLarge")
		k:SetText(v[1])
	
		if namefunc and namefunc() then
			k:SetText(namefunc())
		end
		k:SetTextColor(menuTextCol)
		k:SizeToContents()
		k:SetMouseInputEnabled(true)
		if disabled then
			k:SetMouseInputEnabled(false)
			k:SetTextColor(buttoncolorDisabled)
		elseif invisible then
			k:SetMouseInputEnabled(false)
			k:SetTextColor(Color(0,0,0,0))
		else
			k.OnCursorEntered = function()
				surface.PlaySound(sndMenu4)
				k:SetTextColor(menuTextSelected)
			end
			k.OnCursorExited = function()
				k:SetTextColor(menuTextCol)
			end
			function k:DoClick()
				k:SetTextColor(menuTextCol)
				surface.PlaySound(sndMenu3)
				v[2]()
			end
			function k:Think()
				if GAMEMODE.Menu.MainMenuFrame.Hidden then
					k:SetMouseInputEnabled(false)
				elseif !k:IsMouseInputEnabled() then
					k:SetMouseInputEnabled(true)
				end
			end
		end
	end
end

concommand.Add("muzzlepos", function(pl)
	local att = pl:GetViewModel():GetAttachment(pl:GetViewModel():LookupAttachment("muzzle"))
	if not att then return end
	
	print(att.Pos - pl:GetShootPos())
end)

function GM:PlayerBindPress(pl, bind)
	local w = pl:GetActiveWeapon()
	if w and w:IsValid() and w:GetNWBool("SlotInputEnabled") then
		local num = tonumber(string.match(bind, "^slot(%d)") or "")
		if num then
			pl:ConCommand("select_slot "..num)
			return true
		end
	end
end

function GetPlayerByUserID(id)
	for _,v in pairs(player.GetAll()) do
		if v:UserID()==id then
			return v
		end
	end
	return NULL
end

-- Spawn player gibs
usermessage.Hook("GibPlayer", function(um)
	local pl = GetPlayerByUserID(um:ReadLong())
	if not IsValid(pl) then return end
	
	pl.DeathFlags = um:ReadShort()
	
	local effectdata = EffectData()
		effectdata:SetEntity(pl)
	util.Effect("tf_player_gibbed", effectdata)
end)


usermessage.Hook("GibPlayerHead", function(um)
	local pl = GetPlayerByUserID(um:ReadLong())
	if not IsValid(pl) then return end
	
	pl.DeathFlags = um:ReadShort()
	
	local effectdata = EffectData()
		effectdata:SetEntity(pl)
	util.Effect("tf_tf2_head_gib", effectdata)
end)

usermessage.Hook("GibNPCHead", function(um)
	local npc = um:ReadEntity()
	if not IsValid(npc) then return end
	
	npc.DeathFlags = um:ReadShort()
	
	local effectdata = EffectData()
		effectdata:SetEntity(npc)
		effectdata:SetOrigin(npc:GetPos())
	util.Effect("tf_hl2_head_gib", effectdata)
end)

usermessage.Hook("GibNPC", function(um)
	local npc = um:ReadEntity()
	if not IsValid(npc) then return end
	
	npc.DeathFlags = um:ReadShort()
	
	local effectdata = EffectData()
		effectdata:SetEntity(npc)
	util.Effect("tf_player_gibbed", effectdata)
end)

usermessage.Hook("SilenceNPC", function(um)
	local npc = um:ReadEntity()
	if not IsValid(npc) then return end
	
	timer.Simple(0, function() npc:EmitSound("AI_BaseNPC.SentenceStop") end)
	timer.Simple(0.1, function() npc:EmitSound("AI_BaseNPC.SentenceStop") end)
end)

-- Critical hit notifications
usermessage.Hook("CriticalHit", function(um)
	local pos = um:ReadVector()
	LocalPlayer():EmitSound("TFPlayer.CritHit")
	ParticleEffect("crit_text", pos, Angle(0,0,0))
end)

usermessage.Hook("CriticalHitMini", function(um)
	local pos = um:ReadVector()
	LocalPlayer():EmitSound("TFPlayer.CritHit")
	ParticleEffect("minicrit_text", pos, Angle(0,0,0))
end)

usermessage.Hook("CriticalHitMiniOther", function(um)
	local pos = um:ReadVector()
	sound.Play("TFPlayer.CritHitMini", pos)
	ParticleEffect("minicrit_text", pos, Angle(0,0,0))
end)

usermessage.Hook("CriticalHitReceived", function(um)
	LocalPlayer():EmitSound("TFPlayer.CritPain", 100, 100)
end)

-- Domination notifications
usermessage.Hook("PlayerDomination", function(um)
	local victim = um:ReadEntity()
	local attacker = um:ReadEntity()
	if not IsValid(victim) or not IsValid(attacker) then
		return
	end
	
	if victim == LocalPlayer() then
		local data = EffectData()
			data:SetOrigin(attacker:GetPos())
			data:SetEntity(attacker)
		util.Effect("tf_nemesis_icon", data)
		LocalPlayer():EmitSound("Game.Nemesis")
	elseif attacker == LocalPlayer() then
		LocalPlayer():EmitSound("Game.Domination")
	end
	
	if not victim.NemesisesList then victim.NemesisesList = {} end
	if not attacker.DominationsList then attacker.DominationsList = {} end
	
	victim.NemesisesList[attacker] = true
	attacker.DominationsList[victim] = true
end)

usermessage.Hook("PlayerRevenge", function(um)
	local victim = um:ReadEntity()
	local attacker = um:ReadEntity()
	if not IsValid(victim) or not IsValid(attacker) then
		return
	end
	
	if attacker == LocalPlayer() then
		if IsValid(victim.NemesisEffect) and victim.NemesisEffect.Destroy then
			victim.NemesisEffect:Destroy()
		end
		LocalPlayer():EmitSound("Game.Revenge")
	elseif victim == LocalPlayer() then
		LocalPlayer():EmitSound("Game.Revenge")
	end
	
	if attacker.NemesisesList then
		attacker.NemesisesList[victim] = nil
	end
	
	if victim.DominationsList then
		victim.DominationsList[attacker] = nil
	end
end)

usermessage.Hook("PlayerResetDominations", function(um)
	local pl = um:ReadEntity()
	if not IsValid(pl) then return end
	
	pl.NemesisesList = nil
	pl.DominationsList = nil
	
	if IsValid(pl.NemesisEffect) and pl.NemesisEffect.Destroy then
		pl.NemesisEffect:Destroy()
	end
	
	for _,v in pairs(player.GetAll()) do
		if v ~= pl then
			if v.NemesisesList then
				v.NemesisesList[pl] = nil
			end
			if v.DominationsList then
				v.DominationsList[pl] = nil
			end
		end
	end
end)

usermessage.Hook("SendPlayerDominations", function(um)
	local pl = um:ReadEntity()
	if not IsValid(pl) then return end
	
	local num = um:ReadChar()
	if num <= 0 then return end
	
	pl.DominationsList = {}
	for i=1,num do
		local k = um:ReadEntity()
		if IsValid(pl) then
			pl.DominationsList[k] = true
		end
	end
end)

local function DoHealthBonusEffect(ent, positive)
	if not IsValid(ent) then return end
	
	local col = "red"
	if ent:EntityTeam()==TEAM_BLU then col = "blu" end
	if ent:EntityTeam()==TF_TEAM_PVE_INVADERS then col = "blu" end
	
	local pos = ent:GetPos() + Vector(0,0,75) + math.Rand(0,4) * Angle(math.Rand(-180,180),math.Rand(-180,180),0):Forward()
	
	if positive then
		ParticleEffect("healthgained_"..col, pos, Angle(0,0,0))
	else
		ParticleEffect("healthlost_"..col, pos, Angle(0,0,0))
	end
end

usermessage.Hook("PlayerHealthBonusEffect", function(um)
	local ent = GetPlayerByUserID(um:ReadLong())
	local positive = um:ReadBool()
	
	if ent ~= LocalPlayer() or ent:ShouldDrawLocalPlayer() then
		DoHealthBonusEffect(ent, positive)
	end
end)

usermessage.Hook("EntityHealthBonusEffect", function(um)
	local ent = um:ReadEntity()
	local positive = um:ReadBool()
	DoHealthBonusEffect(ent, positive)
end)

usermessage.Hook("PlayerRocketJumpEffect", function(um)
	local ent = GetPlayerByUserID(um:ReadLong())
	
	if ent ~= LocalPlayer() or ent:ShouldDrawLocalPlayer() then
		ParticleEffectAttach("rocketjump_smoke", PATTACH_POINT_FOLLOW, ent, ent:LookupAttachment("foot_L"))
		ParticleEffectAttach("rocketjump_smoke", PATTACH_POINT_FOLLOW, ent, ent:LookupAttachment("foot_R"))
	end
end)

usermessage.Hook("PlayChargeReadySound", function(um)
	LocalPlayer():EmitSound("TFPlayer.ReCharged")
end)


list.Set(
	"DesktopWindows",
	"TauntMenu",
	{
		title = "TF2 Taunt Menu (BETA!)",
		icon = "backpack/player/items/all_class/taunt_russian_large",
		width = 960,
		height = 700,
		onewindow = true,
		init = function(icn, pnl)
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 0, 25 )
			DImageButton:SetTooltip( "Taunt: Conga (Start)" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_conga_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_conga_start" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 0, 105 )
			DImageButton:SetTooltip( "Taunt: Conga (Stop)" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_conga_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_conga_stop" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 105, 25 )
			DImageButton:SetTooltip( "Taunt: Square Dance" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_dosido_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_squaredance_intro" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 105, 105 )
			DImageButton:SetTooltip( "Taunt: Square Dance ( Undo )" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_dosido_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_squaredance_intro_stop" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 205, 25 )
			DImageButton:SetTooltip( "Taunt: Skullcracker" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_skullcracker_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_skullcracker" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 305, 25 )
			DImageButton:SetTooltip( "Taunt: Rock, Paper, Scissors!" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_rps_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_rockpaperscissors_intro" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 305, 105 )
			DImageButton:SetTooltip( "Taunt: Rock, Paper, Scissors! ( Undo )" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_rps_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_rockpaperscissors_intro_stop" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 405, 25 )
			DImageButton:SetTooltip( "Taunt: Flippin' Awesome" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_flip_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_flipping_intro" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 405, 105 )
			DImageButton:SetTooltip( "Taunt: Flippin' Awesome ( Undo )" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_flip_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_squaredance_intro_stop" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 505, 25 )
			DImageButton:SetTooltip( "Taunt: Kazotsky Kick (Start)" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_russian_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_russian_start" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 505, 105 )
			DImageButton:SetTooltip( "Taunt: Kazotsky Kick (Stop)" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_russian_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_russian_stop" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 605, 25 )
			DImageButton:SetTooltip( "Taunt: Thriller (Scream Fortress)" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/sniper/sniper_zombie_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_thriller" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 705, 25 )
			DImageButton:SetTooltip( "Taunt: High Five!" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_highfive_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_highfive_success" ) 
			end 
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 805, 25 )
			DImageButton:SetTooltip( "Taunt: Bumpkins Banjo (Start)" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/workshop/player/items/engineer/taunt_bumpkins_banjo/taunt_bumpkins_banjo_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_banjo_start" ) 
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 805, 105 )
			DImageButton:SetTooltip( "Taunt: Bumpkins Banjo (Stop)" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/workshop/player/items/engineer/taunt_bumpkins_banjo/taunt_bumpkins_banjo_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_banjo_stop" ) 
			end
			
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 0, 205 )
			DImageButton:SetTooltip( "Taunt: Party Trick" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_party_trick_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_pyro_partytrick" ) 
			end			
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 105, 205 )
			DImageButton:SetTooltip( "Taunt: Schadenfreude" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/all_laugh_taunt_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_laugh" ) 
			end
			 
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 205, 205 )
			DImageButton:SetTooltip( "Taunt: Meet the Medic" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/medic/medic_heroic_taunt_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_heroric" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 305, 205 )
			DImageButton:SetTooltip( "Taunt: Introduction" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/weapons/w_models/w_minigun_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_introduction" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 405, 205 )
			DImageButton:SetTooltip( "Taunt: Brutal Legend" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/workshop_partner/player/items/taunts/brutal_guitar/brutal_guitar_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_brutallegend" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 505, 205 )
			DImageButton:SetTooltip( "Taunt: Luxury Lounge (Start)" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/workshop/player/items/spy/taunt_luxury_lounge/taunt_luxury_lounge_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_chair" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 505, 305 )
			DImageButton:SetTooltip( "Taunt: Luxury Lounge (Stop)" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/workshop/player/items/spy/taunt_luxury_lounge/taunt_luxury_lounge_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_chair_stop" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 605, 205 )
			DImageButton:SetTooltip( "Taunt: Yeti Smash" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_yeti_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_yeti" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 705, 205 )
			DImageButton:SetTooltip( "Taunt: Rancho Relaxo (Start)" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_rancho_relaxo_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_chair2" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 705, 305 )
			DImageButton:SetTooltip( "Taunt: Rancho Relaxo (Stop)" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_rancho_relaxo_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_chair2_stop" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 805, 205 )
			DImageButton:SetTooltip( "Taunt: Oblooterated" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_oblooterated_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_woohoo" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 0, 305 )
			DImageButton:SetTooltip( "Taunt: Maggot's Condolence" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/workshop/player/items/soldier/taunt_maggots_condolence/taunt_maggots_condolence_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_rip_rick_may_you_will_be_forever_missed" )
			end
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 105, 305 )
			DImageButton:SetTooltip( "Taunt: Director's Vision" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/player/items/all_class/taunt_replay_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_replay" )
			end 
			local Hint = pnl:Add( "DLabel" )
			Hint:SetPos( 0, 605 )
			Hint:SetText(  ("Taunts in this gamemode are in WIP stages and may not work properly. Make sure you hover over the icons for information." ) )
			Hint:SizeToContents()
			local Hint2 = pnl:Add( "DLabel" )
			Hint2:SetPos( 0, 625 )
			Hint2:SetText(  ("To stop looping taunts, press the button below the one you've just pressed." ) )
			Hint2:SizeToContents()
		end
	}
)

include("cl_hud.lua")

file.Append(LOGFILE, Format("Done loading, time = %f\n", SysTime() - load_time))
local load_time = SysTime()


function GetImprovedItemName(name)
for k, v in pairs(tf_items.ReturnItems()) do
	if v and istable(v) and v["used_by_classes"] and v["name"] and v["name"] == name and v["used_by_classes"][LocalPlayer():GetPlayerClass()] and v["item_slot"] and not blacklist[v["name"]] and v["prefab"] ~= "tournament_medal" then
		if (v["item_slot"] == "primary" or v["item_slot"] == "secondary" or v["item_slot"] == "melee") then
			if name_blacklist[v["name"]] then
				return "wep"..v["name"]
			elseif string.sub(v["name"], 1, 10) == "Australium" then
				return "wep".."Australium "..tf_lang.GetRaw(v["item_name"]) or v["name"]
			elseif v["item_name"] and string.sub(v["item_name"], 1, 10) == "#TF_Weapon" and string.sub(v["name"], 1, 9) ~= "TF_WEAPON" then
				return "wep"..v["name"]
			else
				return "wep"..tf_lang.GetRaw(v["item_name"]) or v["name"]
			end
		elseif v and v["item_slot"] and v["item_slot"] == "head" then
			return "hat"..v["name"]
		elseif v and v["item_slot"] and v["item_slot"] == "misc" then
			return "hat"..v["name"]
		end
	end
end
end


list.Set(
	"DesktopWindows",
	"BotMenu",
	{
		title = "Bot Panel (Beta)",
		icon = "hud/scoreboard_ping_bot_red",
		width = 960,
		height = 700,
		onewindow = true,
		init = function(icn, pnl)
			local DImageButton = pnl:Add( "DButton" )
			DImageButton:SetPos( 0, 25 )
			DImageButton:SetText( "Add Bot" )
			DImageButton:SetSize( 128, 128 )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_bot_add" )
			end
			local DImageButton = pnl:Add( "DButton" )
			DImageButton:SetPos( 305, 25 )
			DImageButton:SetText( "Start Wave" )
			DImageButton:SetSize( 128, 128 )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_mvm_wave_start" )
			end
			local DImageButton = pnl:Add( "DButton" )
			DImageButton:SetPos( 505, 25 )
			DImageButton:SetText( "Start Middle Wave" )
			DImageButton:SetSize( 128, 128 )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_mvm_wave_start_mid" )
			end
			local DImageButton = pnl:Add( "DButton" )
			DImageButton:SetPos( 605, 25 )
			DImageButton:SetText( "Start Tank Wave" )
			DImageButton:SetSize( 128, 128 )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_mvm_wave_start_tank" )
			end
			local DImageButton = pnl:Add( "DButton" )
			DImageButton:SetPos( 705, 25 )
			DImageButton:SetText( "Start Final Wave" )
			DImageButton:SetSize( 128, 128 )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_mvm_wave_start_final" )
			end
			local DImageButton = pnl:Add( "DButton" )
			DImageButton:SetPos( 105, 25 )
			DImageButton:SetText( "Modify Loadout (Not Functional)" )
			DImageButton:SetSize( 128, 128 )
			DImageButton.DoClick = function()
			end
			local DImageButton = pnl:Add( "DButton" )
			DImageButton:SetPos( 205, 25 )
			DImageButton:SetText( "Change Name (Not Functional)" )
			DImageButton:SetSize( 128, 128 )
			DImageButton.DoClick = function()
			end
		end
	}
)

include("cl_hud.lua")

file.Append(LOGFILE, Format("Done loading, time = %f\n", SysTime() - load_time))
local load_time = SysTime()


function GetImprovedItemName(name)
for k, v in pairs(tf_items.ReturnItems()) do
	if v and istable(v) and v["used_by_classes"] and v["name"] and v["name"] == name and v["used_by_classes"][LocalPlayer():GetPlayerClass()] and v["item_slot"] and not blacklist[v["name"]] and v["prefab"] ~= "tournament_medal" then
		if (v["item_slot"] == "primary" or v["item_slot"] == "secondary" or v["item_slot"] == "melee") then
			if name_blacklist[v["name"]] then
				return "wep"..v["name"]
			elseif string.sub(v["name"], 1, 10) == "Australium" then
				return "wep".."Australium "..tf_lang.GetRaw(v["item_name"]) or v["name"]
			elseif v["item_name"] and string.sub(v["item_name"], 1, 10) == "#TF_Weapon" and string.sub(v["name"], 1, 9) ~= "TF_WEAPON" then
				return "wep"..v["name"]
			else
				return "wep"..tf_lang.GetRaw(v["item_name"]) or v["name"]
			end
		elseif v and v["item_slot"] and v["item_slot"] == "head" then
			return "hat"..v["name"]
		elseif v and v["item_slot"] and v["item_slot"] == "misc" then
			return "hat"..v["name"]
		end
	end
end
end


function UpgradeGUI()
	if !string.find(game.GetMap(), "mvm_") then return end
	-- code goes here
end

-- USELESS!


function L4DClassSelection()


	local ply = LocalPlayer()
	local ClassFrame = vgui.Create("DFrame") --create a frame
	ClassFrame:SetSize(ScrW() * 0.5, ScrH() * 0.5 ) --set its size
	ClassFrame:Center() --position it at the center of the screen
	ClassFrame:SetTitle("L4D Menu") --set the title of the menu 
	ClassFrame:SetDraggable(true) --can you move it around
	ClassFrame:SetSizable(false) --can you resize it?
	if ply:GetPlayerClass() ~= "" then
		ClassFrame:ShowCloseButton(true) --can you close it
	else
		ClassFrame:ShowCloseButton(false)
	end
		
	ClassFrame.OnClose = function()
		LocalPlayer():StopSound("ClassSelection.ThemeMVM") 
		LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") 
		if string.find(game.GetMap(), "mvm_") then 
			LocalPlayer():EmitSound("music/mvm_class_select.wav") 
		end
	end
	LocalPlayer():EmitSound("ClassSelection.ThemeL4D")	

	local icon = vgui.Create( "DModelPanel", ClassFrame )
	icon:SetSize(ScrW() * 0.412 * 0.5, ScrH() * 0.571 * 0.5)
	icon:SetPos(ScrW() * 0.012 * 0.5, ScrH() * 0.301 * 0.5)
	icon:SetCamPos( Vector( 90, 0, 45 ) )
	icon:SetModel( "models/infected/hulk.mdl" ) -- you can only change colors on playermodels
	icon:SetZPos(-8)
	icon:SetAnimated(true)
	icon.AutomaticFrameAdvance = true
	
	local icon2 = vgui.Create( "DModelPanel", ClassFrame )
	icon2:SetSize(ScrW() * 0.412 * 0.5, ScrH() * 0.571 * 0.5)
	icon2:SetPos(ScrW() * 0.012 * 0.5, ScrH() * 0.301 * 0.5)
	icon2:SetCamPos( Vector( 90, 0, 45 ) )
	icon2:SetModel( "models/empty.mdl" ) -- you can only change colors on playermodels
	icon2:SetZPos(-8)
	icon2:SetAnimated(true)
	icon2:GetEntity():SetParent(icon:GetEntity())
	icon2:GetEntity():AddEffects(EF_BONEMERGE)
	
	
	local spectate = vgui.Create("DModelPanel", ClassFrame)
	spectate:SetPos( 625, 65 )
	spectate:SetSize( 75, 100 )
	spectate:SetModel( "models/vgui/ui_team01_spectate.mdl" )
	
	spectate:SetFOV(75)
	icon2:SetZPos(8)
	spectate:SetCamPos(Vector(90, 50, 35))
	spectate:SetLookAt(Vector(-1.883671, -12.644326, 30.984015))
	
	function spectate.DoClick() RunConsoleCommand( "tf_spectate" ) ClassFrame:Close() end
	
	function spectate:LayoutEntity()
		self.Hov = self.Hov or false
		if self:IsHovered() and !self.Hov then
			self.Entity:SetBodygroup(1, 1)
			local random = math.random(3)
			if random == 1 then
				surface.PlaySound("ui/tv_tune.wav")
			else
				surface.PlaySound("ui/tv_tune"..random..".wav")
			end
			self.Hov = true
		elseif !self:IsHovered() and self.Hov then
			self.Entity:SetBodygroup(1, 0)
			self.Hov = false
		end
	end
	
	function icon:LayoutEntity( ent )
		self:RunAnimation()
	end
	function icon2:LayoutEntity( ent )
		return
	end
	local dance = icon:GetEntity():LookupSequence( "idle" )
	icon:GetEntity():SetSequence( dance )
		
	ClassFrame.OnClose = function()
		LocalPlayer():StopSound("ClassSelection.ThemeMVM") 
		LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") 
		LocalPlayer():StopSound("ClassSelection.ThemeL4D") 
	end
	ClassFrame:MakePopup() --make it appear
	 
	local TankButton = vgui.Create("DButton", ClassFrame)
	TankButton:SetSize(100, 30)
	TankButton:SetPos(10, 35)
	TankButton:SetText("Tank")
	TankButton.OnCursorEntered = function() icon:SetModel( "models/infected/hulk.mdl" ) icon2:GetEntity():SetParent(icon:GetEntity()) icon2:GetEntity():AddEffects(EF_BONEMERGE) icon2:GetEntity():SetModel("models/empty.mdl") local dance = icon:GetEntity():LookupSequence( "idle" ) icon:GetEntity():SetSequence( dance ) icon:GetEntity():SetModelScale(1) end
	TankButton.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "tank_l4d")  LocalPlayer():EmitSound("music/safe/themonsterswithout.wav") LocalPlayer():StopSound("ClassSelection.ThemeL4D") ClassFrame:Close()  end

	local BoomerButton = vgui.Create("DButton", ClassFrame)
	BoomerButton:SetSize(100, 30)
	BoomerButton:SetPos(100, 35)
	BoomerButton:SetText("Boomer") --Set the name of the button
	BoomerButton.OnCursorEntered = function() icon:SetModel( "models/infected/boomer.mdl" ) icon2:GetEntity():SetParent(icon:GetEntity()) icon2:GetEntity():AddEffects(EF_BONEMERGE) local dance = icon:GetEntity():LookupSequence( "Idle_Standing" ) icon:GetEntity():SetSequence( dance ) icon:GetEntity():SetModelScale(1) end
	BoomerButton.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "boomer") ClassFrame:Close() LocalPlayer():EmitSound("music/safe/themonsterswithout.wav") LocalPlayer():StopSound("ClassSelection.ThemeL4D") end
	
	local L4DZombie = vgui.Create("DButton", ClassFrame)
	L4DZombie:SetSize(100, 30)
	L4DZombie:SetPos(200, 35)
	L4DZombie:SetText("Smoker") --Set the name of the button
	L4DZombie.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "smoker") ClassFrame:Close() LocalPlayer():EmitSound("music/safe/themonsterswithout.wav") LocalPlayer():StopSound("ClassSelection.ThemeL4D") LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM")end
	
	L4DZombie.OnCursorEntered = function() icon:SetModel( "models/infected/smoker.mdl" ) icon2:GetEntity():SetParent(icon:GetEntity()) icon2:GetEntity():AddEffects(EF_BONEMERGE)icon2:GetEntity():SetModel("models/empty.mdl")  local dance = icon:GetEntity():LookupSequence( "Idle_Upper_KNIFE" ) icon:GetEntity():SetSequence( dance ) icon:GetEntity():SetModelScale(1) end

	local Hunter = vgui.Create("DButton", ClassFrame)
	Hunter:SetSize(100, 30)
	Hunter:SetPos(300, 35)
	Hunter:SetText("Hunter") --Set the name of the button
	Hunter.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "hunter") ClassFrame:Close() LocalPlayer():EmitSound("music/safe/themonsterswithout.wav") LocalPlayer():StopSound("ClassSelection.ThemeL4D") LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end
	
	Hunter.OnCursorEntered = function() icon:SetModel( "models/infected/hunter.mdl" ) icon2:GetEntity():SetParent(icon:GetEntity()) icon2:GetEntity():AddEffects(EF_BONEMERGE)icon2:GetEntity():SetModel("models/empty.mdl")  local dance = icon:GetEntity():LookupSequence( "Idle_Upper_KNIFE" ) icon:GetEntity():SetSequence( dance ) icon:GetEntity():SetModelScale(1) end
	local Charger = vgui.Create("DButton", ClassFrame)
	Charger:SetSize(100, 30)
	Charger:SetPos(400, 35)
	Charger:SetText("Charger") --Set the name of the button
	Charger.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "charger") ClassFrame:Close() LocalPlayer():EmitSound("music/safe/themonsterswithout.wav") LocalPlayer():StopSound("ClassSelection.ThemeL4D") LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end
	
	Charger.OnCursorEntered = function() icon:SetModel( "models/infected/charger.mdl" ) icon2:GetEntity():SetParent(icon:GetEntity()) icon2:GetEntity():AddEffects(EF_BONEMERGE)icon2:GetEntity():SetModel("models/empty.mdl")  local dance = icon:GetEntity():LookupSequence( "charger_run" ) icon:GetEntity():SetSequence( dance ) icon:GetEntity():SetModelScale(1) end
	local Jockey = vgui.Create("DButton", ClassFrame)
	Jockey:SetSize(100, 30)
	Jockey:SetPos(500, 35)
	Jockey:SetText("Jockey") --Set the name of the button
	Jockey.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "jockey") ClassFrame:Close() LocalPlayer():EmitSound("music/safe/themonsterswithout.wav") LocalPlayer():StopSound("ClassSelection.ThemeL4D") LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end
	
	Jockey.OnCursorEntered = function() icon:SetModel( "models/infected/jockey.mdl" ) icon2:GetEntity():SetParent(icon:GetEntity()) icon2:GetEntity():AddEffects(EF_BONEMERGE)icon2:GetEntity():SetModel("models/empty.mdl")  local dance = icon:GetEntity():LookupSequence( "standing_idle" ) icon:GetEntity():SetSequence( dance ) icon:GetEntity():SetModelScale(1) end
	local Spitter = vgui.Create("DButton", ClassFrame)
	Spitter:SetSize(100, 30)
	Spitter:SetPos(600, 35)
	Spitter:SetText("Spitter") --Set the name of the button
	Spitter.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "spitter") ClassFrame:Close() LocalPlayer():EmitSound("music/safe/themonsterswithout.wav") LocalPlayer():StopSound("ClassSelection.ThemeL4D") LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end
	
	Spitter.OnCursorEntered = function() icon:SetModel( "models/infected/spitter.mdl" ) icon2:GetEntity():SetParent(icon:GetEntity()) icon2:GetEntity():AddEffects(EF_BONEMERGE)icon2:GetEntity():SetModel("models/empty.mdl")  local dance = icon:GetEntity():LookupSequence( "standing_idle" ) icon:GetEntity():SetSequence( dance ) icon:GetEntity():SetModelScale(1) end

end
function DoorClose()
local ply = LocalPlayer()local ClassFrame = vgui.Create("DFrame") --create a frame
ClassFrame:SetSize( ScrW() * 1, ScrH() * 1 ) --set its size
ClassFrame:Center() --position it at the center of the screen
ClassFrame:SetTitle("TF2 Door") --set the title of the menu 
ClassFrame:SetDraggable(false) --can you move it around
ClassFrame:SetSizable(false) --can you resize it?
ClassFrame:ShowCloseButton(true) --can you close it
ClassFrame:MakePopup() --make it appear
--models/vgui/ui_class01.mdl
local iconC = vgui.Create( "DModelPanel", ClassFrame )
icon:SetSize(ScrW() * 0.412, ScrH() * 0.571)

iconC:SetCamPos( Vector( 90, 0, 40 ) )
iconC:SetPos(ScrW() * 0.012, ScrH() * 0.301)
iconC:SetModel( "models/vgui/versus_doors.mdl" ) -- you can only change colors on playermodels
iconC:SetZPos(-1)
iconC:SetAnimated(true)
function iconC:LayoutEntity( Entity ) return end
local dance = iconC:GetEntity():LookupSequence( "close" )
iconC:GetEntity():SetSequence( dance )
surface.PlaySound("ui/mm_door_close.wav")
end

--[[function GM:PlayerBindPress(pl, bind, pressed)
	if (bind == "+menu") then
		RunConsoleCommand("lastinv")
	end
end]]

function paintcanTohex(dec) -- code from https://stackoverflow.com/a/37797380
	return string.sub(string.format("%x", dec * 256), 1, 6)
end

function hex2color(hex) -- code from https://gist.github.com/jasonbradley/4357406
    hex = hex:gsub("#","")
    local r, g, b = tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
    return string.ToColor(r.." "..g.." "..b.." 255")
end


-- wouldn't mind a hex to rgb in glua by default
concommand.Add("tf_upgradewep03clientonly", function(ply)
	ply:GetActiveWeapon().Primary.Delay = 0.3
end)
concommand.Add("tf_upgradewep05clientonly", function(ply)
	ply:GetActiveWeapon().Primary.Delay = 0.5
end)
concommand.Add("tf_upgradewep04clientonly", function(ply)
	ply:GetActiveWeapon().Primary.Delay = 0.4
end)
concommand.Add("tf_upgradeweprapidfireclientonly", function(ply)
	ply:GetActiveWeapon().Primary.Delay = 0.15 
end)
concommand.Add("tf_upgradeweprapidfire2clientonly", function(ply)
	ply:GetActiveWeapon().Primary.Delay = 0.07
end)
concommand.Add("l4d_changeclass", L4DClassSelection)
concommand.Add("l4d2_changeclass", L4DClassSelection)
concommand.Add("tf_changeclass", ClassSelection)
concommand.Add("tf_door", DoorClose)
concommand.Add("tf_hatpainter", HatPicker)
concommand.Add("tf_menu", ClassSelection)
concommand.Add("tf_itempicker", function(_, _, args) local type = args[1] if args[1] == "weapons" then type = "wep" elseif args[1] == "hats" then type = "hat" end itemSelector(type) end)
--spawnmenu.AddCreationTab( "Team Fortress 2", function()

	--local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	--return ctrl

--end, "icon16/control_repeat_blue.png", 200 )

--[[function GM:OnSpawnMenuOpen()
	return --ply:IsAdmin()
end]]

hook.Add( "PlayerSay", "Change class", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass" ) then
		RunConsoleCommand("tf_changeclass")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Scout", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass scout" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "scout")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Soldier", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass soldier" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "soldier")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Pyro", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass pyro" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "pyro")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Demoman", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass demoman" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "demoman")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Heavy", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass heavy" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "heavy")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Engineer", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass engineer" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "engineer")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Medic", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass medic" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "medic")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Sniper", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass sniper" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "sniper")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Spy", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass spy" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "spy")
		return false
	end
end )

hook.Add( "PlayerSay", "Change Team Red", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeteam red" ) then
		RunConsoleCommand("changeteam", "1")
		return false
	end
end )

hook.Add( "PlayerSay", "Change Team Blu", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeteam blu" ) then
		RunConsoleCommand("changeteam", "2")
		return false
	end
end )

hook.Add( "PlayerSay", "Change Team Blu", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeteam blu" ) then
		RunConsoleCommand("changeteam", "2")
		return false
	end
end )

local LOGFILE = "teamfortress/log_client.txt"
file.Delete(LOGFILE)
file.Append(LOGFILE, "Loading clientside script\n")
local load_time = SysTime()
local blacklist = {["Frying Pan"] = true, ["Golden Frying Pan"] = true, ["The PASSTIME Jack"] = true, ["TTG Max Pistol"] = true, ["Sexo de Pene Gay"] = true, ["Team Spirit"] = true,} -- Items that should NEVER show, must be their item.name if a hat/weapon!
local name_blacklist = {["The AK47"] = true,} -- Weapons that have names of other weapons must have their item.name put in here

include("tf_lang_module.lua")
include("shd_items.lua")
tf_lang.Load("tf_english.txt")

include("cl_proxies.lua")
include("cl_pickteam.lua")

include("cl_conflict.lua")

include("shared.lua")
include("cl_entclientinit.lua")
include("cl_deathnotice.lua")
include("cl_scheme.lua")

include("cl_player_other.lua")

include("cl_camera.lua")

include("tf_draw_module.lua")

include("cl_materialfix.lua")

include("cl_pac.lua")

include("proxies/itemtintcolor.lua")

include("proxies/sniperriflecharge.lua")
include("proxies/weapon_invis.lua")
include("shd_gravitygun.lua")

CreateClientConVar( "tf_haltinspect", "1", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Whether or not players can inspect while no-clipping." )
CreateClientConVar( "tf_maxhealth_hud", "1", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Enable maxhealth above health when hurt." )
CreateClientConVar( "tf_robot", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become a robot after respawning." )
CreateClientConVar( "tf_giant_robot", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become a mighty robot after respawning." )
CreateClientConVar( "tf_dingalingaling_sound", "hitsound", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become a mighty robot after respawning." )






--[[
timer.Create("lol",0.2,0,function() m=T:GetBoneMatrix(T:LookupBone("bip_head")) m:Translate(Vector(0,-5,0)) local e=EffectData() e:SetOrigin(m:GetTranslation()) e:SetAngles(Angle(180,0,0)) util.Effect("BloodImpact",e) end)

LocalPlayer().BuildBonePositions=function(pl) local m = pl:GetBoneMatrix(pl:LookupBone("bip_neck")) m:Scale(Vector(0,0,0)) m:Translate(Vector(0,0,0)) pl:SetBoneMatrix(pl:LookupBone("bip_neck"),m) end

TBB=function() local m=P:GetBoneMatrix(P:LookupBone("bip_spine_3")) m:Rotate(Angle(-10,0,-20)) m:Translate(Vector(0,-8,-3.5)) T:SetBoneMatrix(T:LookupBone("bip_head"),m) end

]]

--include("vgui/vgui_teammenubg.lua")

--[[
tf_util.AddDebugInfo("move_x", function()
	return "forward : "..tostring(LocalPlayer():GetNWFloat("MoveForward"))
end)

tf_util.AddDebugInfo("move_y", function()
	return "side : "..tostring(LocalPlayer():GetNWFloat("MoveSide"))
end)

tf_util.AddDebugInfo("move_z", function()
	return "up : "..tostring(LocalPlayer():GetNWFloat("MoveUp"))
end)]]

hook.Add("RenderScreenspaceEffects", "RenderPlayerStateOverlay", function()
	if IsValid(LocalPlayer()) then
		LocalPlayer():DrawStateOverlay()
	end
end)

concommand.Add("muzzlepos", function(pl)
	local att = pl:GetViewModel():GetAttachment(pl:GetViewModel():LookupAttachment("muzzle"))
	if not att then return end
	
	print(att.Pos - pl:GetShootPos())
end)

function GM:PlayerBindPress(pl, bind)
	local w = pl:GetActiveWeapon()
	if w and w:IsValid() and w:GetNWBool("SlotInputEnabled") then
		local num = tonumber(string.match(bind, "^slot(%d)") or "")
		if num then
			pl:ConCommand("select_slot "..num)
			return true
		end
	end
end

function GetPlayerByUserID(id)
	for _,v in pairs(player.GetAll()) do
		if v:UserID()==id then
			return v
		end
	end
	return NULL
end

-- Spawn player gibs
usermessage.Hook("GibPlayer", function(um)
	local pl = GetPlayerByUserID(um:ReadLong())
	if not IsValid(pl) then return end
	
	pl.DeathFlags = um:ReadShort()
	
	local effectdata = EffectData()
		effectdata:SetEntity(pl)
	util.Effect("tf_player_gibbed", effectdata)
end)


usermessage.Hook("GibPlayerHead", function(um)
	local pl = GetPlayerByUserID(um:ReadLong())
	if not IsValid(pl) then return end
	
	pl.DeathFlags = um:ReadShort()
	
	local effectdata = EffectData()
		effectdata:SetEntity(pl)
	util.Effect("tf_tf2_head_gib", effectdata)
end)

usermessage.Hook("GibNPCHead", function(um)
	local npc = um:ReadEntity()
	if not IsValid(npc) then return end
	
	npc.DeathFlags = um:ReadShort()
	
	local effectdata = EffectData()
		effectdata:SetEntity(npc)
		effectdata:SetOrigin(npc:GetPos())
	util.Effect("tf_hl2_head_gib", effectdata)
end)

usermessage.Hook("GibNPC", function(um)
	local npc = um:ReadEntity()
	if not IsValid(npc) then return end
	
	npc.DeathFlags = um:ReadShort()
	
	local effectdata = EffectData()
		effectdata:SetEntity(npc)
	util.Effect("tf_player_gibbed", effectdata)
end)

usermessage.Hook("SilenceNPC", function(um)
	local npc = um:ReadEntity()
	if not IsValid(npc) then return end
	
	timer.Simple(0, function() npc:EmitSound("AI_BaseNPC.SentenceStop") end)
	timer.Simple(0.1, function() npc:EmitSound("AI_BaseNPC.SentenceStop") end)
end)

-- Critical hit notifications
usermessage.Hook("CriticalHit", function(um)
	local pos = um:ReadVector()
	LocalPlayer():EmitSound("TFPlayer.CritHit")
	ParticleEffect("crit_text", pos, Angle(0,0,0))
end)

usermessage.Hook("CriticalHitMini", function(um)
	local pos = um:ReadVector()
	LocalPlayer():EmitSound("TFPlayer.CritHit")
	ParticleEffect("minicrit_text", pos, Angle(0,0,0))
end)

usermessage.Hook("CriticalHitMiniOther", function(um)
	local pos = um:ReadVector()
	sound.Play("TFPlayer.CritHitMini", pos)
	ParticleEffect("minicrit_text", pos, Angle(0,0,0))
end)

usermessage.Hook("CriticalHitReceived", function(um)
	LocalPlayer():EmitSound("TFPlayer.CritPain", 100, 100)
end)

-- Domination notifications
usermessage.Hook("PlayerDomination", function(um)
	local victim = um:ReadEntity()
	local attacker = um:ReadEntity()
	if not IsValid(victim) or not IsValid(attacker) then
		return
	end
	
	if victim == LocalPlayer() then
		local data = EffectData()
			data:SetOrigin(attacker:GetPos())
			data:SetEntity(attacker)
		util.Effect("tf_nemesis_icon", data)
		LocalPlayer():EmitSound("Game.Nemesis")
	elseif attacker == LocalPlayer() then
		LocalPlayer():EmitSound("Game.Domination")
	end
	
	if not victim.NemesisesList then victim.NemesisesList = {} end
	if not attacker.DominationsList then attacker.DominationsList = {} end
	
	victim.NemesisesList[attacker] = true
	attacker.DominationsList[victim] = true
end)

usermessage.Hook("PlayerRevenge", function(um)
	local victim = um:ReadEntity()
	local attacker = um:ReadEntity()
	if not IsValid(victim) or not IsValid(attacker) then
		return
	end
	
	if attacker == LocalPlayer() then
		if IsValid(victim.NemesisEffect) and victim.NemesisEffect.Destroy then
			victim.NemesisEffect:Destroy()
		end
		LocalPlayer():EmitSound("Game.Revenge")
	elseif victim == LocalPlayer() then
		LocalPlayer():EmitSound("Game.Revenge")
	end
	
	if attacker.NemesisesList then
		attacker.NemesisesList[victim] = nil
	end
	
	if victim.DominationsList then
		victim.DominationsList[attacker] = nil
	end
end)

concommand.Add("joinclass", function(pl, cmd, args)
	RunConsoleCommand("changeclass "..args)
end, function() return GAMEMODE.PlayerClassesAutoComplete end)

usermessage.Hook("PlayerResetDominations", function(um)
	local pl = um:ReadEntity()
	if not IsValid(pl) then return end
	
	pl.NemesisesList = nil
	pl.DominationsList = nil
	
	if IsValid(pl.NemesisEffect) and pl.NemesisEffect.Destroy then
		pl.NemesisEffect:Destroy()
	end
	
	for _,v in pairs(player.GetAll()) do
		if v ~= pl then
			if v.NemesisesList then
				v.NemesisesList[pl] = nil
			end
			if v.DominationsList then
				v.DominationsList[pl] = nil
			end
		end
	end
end)

usermessage.Hook("SendPlayerDominations", function(um)
	local pl = um:ReadEntity()
	if not IsValid(pl) then return end
	
	local num = um:ReadChar()
	if num <= 0 then return end
	
	pl.DominationsList = {}
	for i=1,num do
		local k = um:ReadEntity()
		if IsValid(pl) then
			pl.DominationsList[k] = true
		end
	end
end)

local function DoHealthBonusEffect(ent, positive)
	if not IsValid(ent) then return end
	
	local col = "red"
	if ent:EntityTeam()==TEAM_BLU then col = "blu" end
	if ent:EntityTeam()==TF_TEAM_PVE_INVADERS then col = "blu" end
	
	local pos = ent:GetPos() + Vector(0,0,75) + math.Rand(0,4) * Angle(math.Rand(-180,180),math.Rand(-180,180),0):Forward()
	
	if positive then
		ParticleEffect("healthgained_"..col, pos, Angle(0,0,0))
	else
		ParticleEffect("healthlost_"..col, pos, Angle(0,0,0))
	end
end

usermessage.Hook("PlayerHealthBonusEffect", function(um)
	local ent = GetPlayerByUserID(um:ReadLong())
	local positive = um:ReadBool()
	
	if ent ~= LocalPlayer() or ent:ShouldDrawLocalPlayer() then
		DoHealthBonusEffect(ent, positive)
	end
end)

usermessage.Hook("EntityHealthBonusEffect", function(um)
	local ent = um:ReadEntity()
	local positive = um:ReadBool()
	DoHealthBonusEffect(ent, positive)
end)

usermessage.Hook("PlayerRocketJumpEffect", function(um)
	local ent = GetPlayerByUserID(um:ReadLong())
	
	if ent ~= LocalPlayer() or ent:ShouldDrawLocalPlayer() then
		ParticleEffectAttach("rocketjump_smoke", PATTACH_POINT_FOLLOW, ent, ent:LookupAttachment("foot_L"))
		ParticleEffectAttach("rocketjump_smoke", PATTACH_POINT_FOLLOW, ent, ent:LookupAttachment("foot_R"))
	end
end)

usermessage.Hook("PlayChargeReadySound", function(um)
	LocalPlayer():EmitSound("TFPlayer.ReCharged")
end)
include("cl_hud.lua")

file.Append(LOGFILE, Format("Done loading, time = %f\n", SysTime() - load_time))
local load_time = SysTime()


function GetImprovedItemName(name)
for k, v in pairs(tf_items.ReturnItems()) do
	if v and istable(v) and v["used_by_classes"] and v["name"] and v["name"] == name and v["used_by_classes"][LocalPlayer():GetPlayerClass()] and v["item_slot"] and not blacklist[v["name"]] and v["prefab"] ~= "tournament_medal" then
		if (v["item_slot"] == "primary" or v["item_slot"] == "secondary" or v["item_slot"] == "melee") then
			if name_blacklist[v["name"]] then
				return "wep"..v["name"]
			elseif string.sub(v["name"], 1, 10) == "Australium" then
				return "wep".."Australium "..tf_lang.GetRaw(v["item_name"]) or v["name"]
			elseif v["item_name"] and string.sub(v["item_name"], 1, 10) == "#TF_Weapon" and string.sub(v["name"], 1, 9) ~= "TF_WEAPON" then
				return "wep"..v["name"]
			else
				return "wep"..tf_lang.GetRaw(v["item_name"]) or v["name"]
			end
		elseif v and v["item_slot"] and v["item_slot"] == "head" then
			return "hat"..v["name"]
		elseif v and v["item_slot"] and v["item_slot"] == "misc" then
			return "hat"..v["name"]
		end
	end
end
end


include("cl_hud.lua")

file.Append(LOGFILE, Format("Done loading, time = %f\n", SysTime() - load_time))
local load_time = SysTime()


function GetImprovedItemName(name)
for k, v in pairs(tf_items.ReturnItems()) do
	if v and istable(v) and v["used_by_classes"] and v["name"] and v["name"] == name and v["used_by_classes"][LocalPlayer():GetPlayerClass()] and v["item_slot"] and not blacklist[v["name"]] and v["prefab"] ~= "tournament_medal" then
		if (v["item_slot"] == "primary" or v["item_slot"] == "secondary" or v["item_slot"] == "melee") then
			if name_blacklist[v["name"]] then
				return "wep"..v["name"]
			elseif string.sub(v["name"], 1, 10) == "Australium" then
				return "wep".."Australium "..tf_lang.GetRaw(v["item_name"]) or v["name"]
			elseif v["item_name"] and string.sub(v["item_name"], 1, 10) == "#TF_Weapon" and string.sub(v["name"], 1, 9) ~= "TF_WEAPON" then
				return "wep"..v["name"]
			else
				return "wep"..tf_lang.GetRaw(v["item_name"]) or v["name"]
			end
		elseif v and v["item_slot"] and v["item_slot"] == "head" then
			return "hat"..v["name"]
		elseif v and v["item_slot"] and v["item_slot"] == "misc" then
			return "hat"..v["name"]
		end
	end
end
end

-- USELESS!

--[[
function L4DClassSelection()


	local ply = LocalPlayer()
	local ClassFrame = vgui.Create("DFrame") --create a frame
	ClassFrame:SetSize(ScrW() * 1, ScrH() * 1 ) --set its size
	ClassFrame:Center() --position it at the center of the screen
	ClassFrame:SetTitle("L4D Menu") --set the title of the menu 
	ClassFrame:SetDraggable(true) --can you move it around
	ClassFrame:SetSizable(false) --can you resize it?
	if ply:GetPlayerClass() ~= "" then
		ClassFrame:ShowCloseButton(true) --can you close it
	else
		ClassFrame:ShowCloseButton(false)
	end
		
	ClassFrame.OnClose = function()
		LocalPlayer():StopSound("ClassSelection.ThemeMVM") 
		LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") 
		if string.find(game.GetMap(), "mvm_") then 
			LocalPlayer():EmitSound("music/mvm_class_select.wav") 
		end
	end
	LocalPlayer():EmitSound("ClassSelection.ThemeL4D")	
	
	
	local iconC = vgui.Create( "DModelPanel", ClassFrame )
	iconC:SetSize( ScrW() * 1, ScrH() * 1 )
	
	iconC:SetCamPos( Vector( 90, 0, 40 ) )
	iconC:SetPos( 0, 0)
	iconC:SetModel( "models/vgui/ui_class01.mdl" ) -- you can only change colors on playermodels
	iconC:SetZPos(-4)
	function iconC:LayoutEntity( Entity ) return end
	local icon = vgui.Create( "DModelPanel", ClassFrame )
	icon:SetSize(ScrW() * 0.412, ScrH() * 0.571)
	icon:SetPos(ScrW() * 0.012, ScrH() * 0.301)
	icon:SetCamPos( Vector( 90, 0, 45 ) )
	icon:SetModel( "models/infected/hulk.mdl" ) -- you can only change colors on playermodels
	icon:SetZPos(-8)
	icon:SetAnimated(true)
	icon.AutomaticFrameAdvance = true
	
	local icon2 = vgui.Create( "DModelPanel", ClassFrame )
	icon2:SetSize(ScrW() * 0.412, ScrH() * 0.571)
	icon2:SetPos(ScrW() * 0.012, ScrH() * 0.301)
	icon2:SetCamPos( Vector( 90, 0, 45 ) )
	icon2:SetModel( "models/props_debris/concrete_chunk01a.mdl" ) -- you can only change colors on playermodels
	icon2:SetZPos(-8)
	icon2:SetAnimated(true)
	icon2:GetEntity():SetParent(icon:GetEntity())
	icon2:GetEntity():AddEffects(EF_BONEMERGE)
	
	
	local spectate = vgui.Create("DModelPanel", ClassFrame)
	spectate:SetPos( 625, 65 )
	spectate:SetSize( 75, 100 )
	spectate:SetModel( "models/vgui/ui_team01_spectate.mdl" )
	
	spectate:SetFOV(75)
	icon2:SetZPos(	8)
	spectate:SetCamPos(Vector(90, 50, 35))
	spectate:SetLookAt(Vector(-1.883671, -12.644326, 30.984015))
	
	function spectate.DoClick() RunConsoleCommand( "tf_spectate" ) ClassFrame:Close() end
	
	function spectate:LayoutEntity()
		self.Hov = self.Hov or false
		if self:IsHovered() and !self.Hov then
			self.Entity:SetBodygroup(1, 1)
			local random = math.random(3)
			if random == 1 then
				surface.PlaySound("ui/tv_tune.wav")
			else
				surface.PlaySound("ui/tv_tune"..random..".wav")
			end
			self.Hov = true
		elseif !self:IsHovered() and self.Hov then
			self.Entity:SetBodygroup(1, 0)
			self.Hov = false
		end
	end
	
	function icon:LayoutEntity( ent )
		self:RunAnimation()
	end
	function icon2:LayoutEntity( ent )
		return
	end
	local dance = icon:GetEntity():LookupSequence( "throw_02" )
	icon:GetEntity():SetSequence( dance )
		
	ClassFrame.OnClose = function()
		LocalPlayer():StopSound("ClassSelection.ThemeMVM") 
		LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") 
		LocalPlayer():StopSound("ClassSelection.ThemeL4D") 
	end
	ClassFrame:MakePopup() --make it appear
	 
	local TankButton = vgui.Create("DButton", ClassFrame)
	TankButton:SetSize(100, 30)
	TankButton:SetPos(10, 35)
	TankButton:SetText("Tank")
	TankButton.OnCursorEntered = function() icon:SetModel( "models/infected/hulk.mdl" ) icon2:GetEntity():SetParent(icon:GetEntity()) icon2:GetEntity():AddEffects(EF_BONEMERGE) icon2:GetEntity():SetModel("models/props_debris/concrete_chunk01a.mdl") local dance = icon:GetEntity():LookupSequence( "throw_02" ) icon:GetEntity():SetSequence( dance ) icon:GetEntity():SetModelScale(0.865) end
	TankButton.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "tank")  LocalPlayer():EmitSound("music/safe/themonsterswithout.wav") LocalPlayer():StopSound("ClassSelection.ThemeL4D") ClassFrame:Close()  end

	local BoomerButton = vgui.Create("DButton", ClassFrame)
	BoomerButton:SetSize(100, 30)
	BoomerButton:SetPos(100, 35)
	BoomerButton:SetText("Boomer") --Set the name of the button
	BoomerButton.OnCursorEntered = function() icon:SetModel( "models/infected/boomer_l4d.mdl" ) icon2:GetEntity():SetParent(icon:GetEntity()) icon2:GetEntity():AddEffects(EF_BONEMERGE) local dance = icon:GetEntity():LookupSequence( "Run_Upper_KNIFE" ) icon:GetEntity():SetSequence( dance ) icon:GetEntity():SetModelScale(0.865) end
	BoomerButton.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "boomer") ClassFrame:Close() LocalPlayer():EmitSound("music/safe/themonsterswithout.wav") LocalPlayer():StopSound("ClassSelection.ThemeL4D") end
	
	local L4DZombie = vgui.Create("DButton", ClassFrame)
	L4DZombie:SetSize(100, 30)
	L4DZombie:SetPos(190, 35)
	L4DZombie:SetText("Male Zombie") --Set the name of the button
	L4DZombie.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "l4d_zombie") ClassFrame:Close() LocalPlayer():EmitSound("music/safe/themonsterswithout.wav") LocalPlayer():StopSound("ClassSelection.ThemeL4D") LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end
	
	L4DZombie.OnCursorEntered = function() icon:SetModel( "models/cpthazama/l4d1/common/male_01.mdl" ) icon2:GetEntity():SetParent(icon:GetEntity()) icon2:GetEntity():AddEffects(EF_BONEMERGE)icon2:GetEntity():SetModel("models/empty.mdl")  local dance = icon:GetEntity():LookupSequence( "Run_01" ) icon:GetEntity():SetSequence( dance ) icon:GetEntity():SetModelScale(0.865) end

end]]
function DoorClose()
local ply = LocalPlayer()local ClassFrame = vgui.Create("DFrame") --create a frame
ClassFrame:SetSize( ScrW() * 1, ScrH() * 1 ) --set its size
ClassFrame:Center() --position it at the center of the screen
ClassFrame:SetTitle("TF2 Door") --set the title of the menu 
ClassFrame:SetDraggable(false) --can you move it around
ClassFrame:SetSizable(false) --can you resize it?
ClassFrame:ShowCloseButton(true) --can you close it
ClassFrame:MakePopup() --make it appear
--models/vgui/ui_class01.mdl
local iconC = vgui.Create( "DModelPanel", ClassFrame )
icon:SetSize(ScrW() * 0.412, ScrH() * 0.571)

iconC:SetCamPos( Vector( 90, 0, 40 ) )
iconC:SetPos(ScrW() * 0.012, ScrH() * 0.301)
iconC:SetModel( "models/vgui/versus_doors.mdl" ) -- you can only change colors on playermodels
iconC:SetZPos(-1)
iconC:SetAnimated(true)
function iconC:LayoutEntity( Entity ) return end
local dance = iconC:GetEntity():LookupSequence( "close" )
iconC:GetEntity():SetSequence( dance )
surface.PlaySound("ui/mm_door_close.wav")
end
function ClassSelection()


local ply = LocalPlayer()
local ClassFrame = vgui.Create("DFrame") --create a frame
ClassFrame:SetSize(ScrW() * 1, ScrH() * 1 ) --set its size
ClassFrame:Center() --position it at the center of the screen
ClassFrame:SetTitle("TF2 Menu") --set the title of the menu 
ClassFrame:SetDraggable(true) --can you move it around
ClassFrame:SetSizable(true) --can you resize it?
if ply:GetPlayerClass() ~= "" then
	ClassFrame:ShowCloseButton(true) --can you close it
else
	ClassFrame:ShowCloseButton(false)
end
	
ClassFrame.OnClose = function()
	LocalPlayer():StopSound("ClassSelection.ThemeMVM") 
	LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") 
	if string.find(game.GetMap(), "mvm_") then 
		LocalPlayer():EmitSound("music/mvm_class_select.wav") 
	end
end
if string.find(game.GetMap(), "mvm_") then
	LocalPlayer():EmitSound("ClassSelection.ThemeMVM")
else
	LocalPlayer():EmitSound("ClassSelection.ThemeNonMVM")	
end


local iconC = vgui.Create( "DModelPanel", ClassFrame )
iconC:SetSize( ScrW() * 1, ScrH() * 1 )

iconC:SetCamPos( Vector( 160, 0, 40 ) )
iconC:SetSize(ScrW(), ScrH())
iconC:SetPos(ScrW(), ScrH())
iconC:SetPos( 0, 0)
iconC:SetModel( "models/vgui/ui_class01.mdl" ) -- you can only change colors on playermodels
iconC:SetZPos(-9)
iconC:SetFOV(40)
function iconC:LayoutEntity( Entity ) return end
local icon = vgui.Create( "DModelPanel", ClassFrame )
icon:SetSize(ScrW() * 0.412, ScrH() * 0.571)
icon:SetPos(ScrW() * 0.012, ScrH() * 0.301)
icon:SetCamPos( Vector( 140, 0, 40 ) )
if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1) then
	icon:SetModel( "models/player/tfc_heavy.mdl" ) -- you can only change colors on playermodels
elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
	icon:SetModel( "models/bots/heavy/bot_heavy.mdl" ) -- you can only change colors on playermodels
else
	icon:SetModel( "models/player/heavy.mdl" ) -- you can only change colors on playermodels
end
surface.PlaySound( "/music/class_menu_05.wav" )
icon:GetEntity():SetModelScale(0.865)
icon:SetZPos(-8)
icon:SetFOV(54)
icon:SetAnimated(true)
icon.AutomaticFrameAdvance = true

local icon2 = vgui.Create( "DModelPanel", ClassFrame )
icon2:SetSize(ScrW() * 0.412, ScrH() * 0.571)
icon2:SetPos(ScrW() * 0.012, ScrH() * 0.301)
icon2:SetCamPos( Vector( 140, 0, 40 ) )
icon2:SetModel( "models/weapons/w_models/w_minigun.mdl" ) -- you can only change colors on playermodels
icon2:SetZPos(-8)
icon2:SetFOV(54)
icon2:SetAnimated(true)
icon2:GetEntity():SetParent(icon:GetEntity())
icon2:GetEntity():AddEffects(EF_BONEMERGE)


local spectate = vgui.Create("DModelPanel", ClassFrame)
spectate:SetPos( 625, 65 )
spectate:SetSize( 75, 100 )
spectate:SetModel( "models/vgui/ui_team01_spectate.mdl" )

spectate:SetFOV(50)
icon2:SetZPos(8)
spectate:SetCamPos(Vector(90, 50, 35))
spectate:SetLookAt(Vector(-1.883671, -12.644326, 30.984015))

function spectate.DoClick() RunConsoleCommand( "tf_spectate" ) ClassFrame:Close() end

function spectate:LayoutEntity()
	self.Hov = self.Hov or false
	if self:IsHovered() and !self.Hov then
		self.Entity:SetBodygroup(1, 1)
		local random = math.random(3)
		if random == 1 then
			surface.PlaySound("ui/tv_tune.wav")
		else
			surface.PlaySound("ui/tv_tune"..random..".wav")
		end
		self.Hov = true
	elseif !self:IsHovered() and self.Hov then
		self.Entity:SetBodygroup(1, 0)
		self.Hov = false
	end
end

function icon:LayoutEntity( ent )
    self:RunAnimation()
end
function icon2:LayoutEntity( ent )
    return
end
	timer.Create("SetSkinForClassModels", 0.01, 0, function()
		if LocalPlayer():Team() == TEAM_BLU or LocalPlayer():Team() == TF_TEAM_PVE_INVADERS then
			if (IsValid(icon) and IsValid(icon2)) then
				icon:GetEntity():SetSkin(1)
				icon2:GetEntity():SetSkin(1)
			else
				return
			end
		end
	end)
local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" )
icon:GetEntity():SetSequence( dance )

ClassFrame:MakePopup() --make it appear
 
local ScoutButton = vgui.Create("DButton", ClassFrame)
ScoutButton:SetSize(100, 30)
ScoutButton:SetPos(10, 35)
ScoutButton:SetText("Scout")
ScoutButton.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "scout") surface.PlaySound( "/music/class_menu_01.wav" ) ClassFrame:Close()  end
if (IsMounted("left4dead2")) then
	local L4DButton = vgui.Create("DButton", ClassFrame)
	L4DButton:SetSize(100, 30)
	L4DButton:SetPos(930, 35)
	L4DButton:SetText("Left 4 Dead Classes")
	L4DButton.DoClick = function() RunConsoleCommand("l4d2_changeclass") ClassFrame:Close()  end
end
local SoldierButton = vgui.Create("DButton", ClassFrame)
SoldierButton:SetSize(100, 30)
SoldierButton:SetPos(100, 35)
SoldierButton:SetText("Soldier") --Set the name of the button
SoldierButton.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "soldier") surface.PlaySound( "/music/class_menu_02.wav" ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM")	end

local PyroButton = vgui.Create("DButton", ClassFrame)
PyroButton:SetSize(100, 30)
PyroButton:SetPos(190, 35)
PyroButton:SetText("Pyro") --Set the name of the button
PyroButton.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "pyro") surface.PlaySound( "/music/class_menu_03.wav" ) ClassFrame:Close()  if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end

local DemomanButton = vgui.Create("DButton", ClassFrame)
DemomanButton:SetSize(100, 30)
DemomanButton:SetPos(280, 35)
DemomanButton:SetText("Demoman") --Set the name of the button
DemomanButton.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "demoman") surface.PlaySound( "/music/class_menu_04.wav" ) ClassFrame:Close()  if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end

local HeavyButton = vgui.Create("DButton", ClassFrame)
HeavyButton:SetSize(100, 30)
HeavyButton:SetPos(370, 35)
HeavyButton:SetText("Heavy") --Set the name of the button
HeavyButton.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "heavy") surface.PlaySound( "/music/class_menu_05.wav" ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end

local EngineerButton = vgui.Create("DButton", ClassFrame)
EngineerButton:SetSize(100, 30)
EngineerButton:SetPos(460, 35)
EngineerButton:SetText("Engineer") --Set the name of the button
EngineerButton.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "engineer") surface.PlaySound( "/music/class_menu_06.wav" ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end

local MedicButton = vgui.Create("DButton", ClassFrame)
MedicButton:SetSize(100, 30)
MedicButton:SetPos(550, 35)
MedicButton:SetText("Medic") --Set the name of the button
MedicButton.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "medic") surface.PlaySound( "/music/class_menu_07.wav" ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end

local SniperButton = vgui.Create("DButton", ClassFrame)
SniperButton:SetSize(100, 30)
SniperButton:SetPos(640, 35)
SniperButton:SetText("Sniper") --Set the name of the button
SniperButton.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "sniper") surface.PlaySound( "/music/class_menu_08.wav" ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end

local SpyButton = vgui.Create("DButton", ClassFrame)
SpyButton:SetSize(100, 30)
SpyButton:SetPos(730, 35)
SpyButton:SetText("Spy") --Set the name of the button
SpyButton.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "spy") surface.PlaySound( "/music/class_menu_09.wav" ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end


ScoutButton.OnCursorEntered = function() 
	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1) then
		icon:SetModel( "models/player/tfc_scout.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/scout/bot_scout.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/scout.mdl" ) -- you can only change colors on playermodels
	end
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	if LocalPlayer():GetPlayerClass() == "scout" then 
		icon2:GetEntity():SetModel(LocalPlayer():GetWeapons()[1]:GetItemData().model_player)
	else 
		icon2:GetEntity():SetModel("models/weapons/w_models/w_scattergun.mdl") 
	end 
	LocalPlayer():EmitSound( "/music/class_menu_01.wav", 100, 100, 1, CHAN_VOICE ) 
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
end
SoldierButton.OnCursorEntered = function() 

	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1) then
		icon:SetModel( "models/player/tfc_soldier.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/soldier/bot_soldier.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/soldier.mdl" ) -- you can only change colors on playermodels
	end
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	if LocalPlayer():GetPlayerClass() == "soldier" then 
		icon2:GetEntity():SetModel(LocalPlayer():GetWeapons()[1]:GetItemData().model_player)
	else 
		icon2:GetEntity():SetModel("models/weapons/w_models/w_rocketlauncher.mdl") 
	end 
	LocalPlayer():EmitSound( "/music/class_menu_02.wav", 100, 100, 1, CHAN_VOICE ) 
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim0l" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
end
PyroButton.OnCursorEntered = function() 

	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1) then
		icon:SetModel( "models/player/tfc_pyro.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/pyro/bot_pyro.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/pyro.mdl" ) -- you can only change colors on playermodels
	end
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	if LocalPlayer():GetPlayerClass() == "pyro" then 
		icon2:GetEntity():SetModel(LocalPlayer():GetWeapons()[1]:GetItemData().model_player)
	else 
		icon2:GetEntity():SetModel("models/weapons/c_models/c_flamethrower/c_flamethrower.mdl") 
	end 
	LocalPlayer():EmitSound( "/music/class_menu_03.wav", 100, 100, 1, CHAN_VOICE ) 
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
end
DemomanButton.OnCursorEntered = function() 

	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1) then
		icon:SetModel( "models/player/tfc_demo.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/demo/bot_demo.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/demo.mdl" ) -- you can only change colors on playermodels
	end
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	if LocalPlayer():GetPlayerClass() == "demoman" then 
		icon2:GetEntity():SetModel(LocalPlayer():GetWeapons()[1]:GetItemData().model_player)
	else 
		icon2:GetEntity():SetModel("models/weapons/c_models/c_grenadelauncher/c_grenadelauncher.mdl") 
	end 
	LocalPlayer():EmitSound( "/music/class_menu_04.wav", 100, 100, 1, CHAN_VOICE ) 
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
end
HeavyButton.OnCursorEntered = function() 

	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1) then
		icon:SetModel( "models/player/tfc_heavy.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/heavy/bot_heavy.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/heavy.mdl" ) -- you can only change colors on playermodels
	end
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	if LocalPlayer():GetPlayerClass() == "heavy" then 
		icon2:GetEntity():SetModel(LocalPlayer():GetWeapons()[1]:GetItemData().model_player)
	else 
		icon2:GetEntity():SetModel("models/weapons/c_models/c_minigun/c_minigun.mdl") 
	end 
	LocalPlayer():EmitSound( "/music/class_menu_05.wav", 100, 100, 1, CHAN_VOICE ) 
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
end
EngineerButton.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "engineer") surface.PlaySound( "/music/class_menu_06.wav" ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end

EngineerButton.OnCursorEntered = function() 

	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1) then
		icon:SetModel( "models/player/tfc_engineer.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/engineer/bot_engineer.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/engineer.mdl" ) -- you can only change colors on playermodels
	end
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	if LocalPlayer():GetPlayerClass() == "engineer" then 
		icon2:GetEntity():SetModel(LocalPlayer():GetWeapons()[3]:GetItemData().model_player)
	else 
		icon2:GetEntity():SetModel("models/weapons/c_models/c_wrench/c_wrench.mdl") 
	end 
	LocalPlayer():EmitSound( "/music/class_menu_06.wav", 100, 100, 1, CHAN_VOICE ) 
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
end
MedicButton.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "medic") surface.PlaySound( "/music/class_menu_07.wav" ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end

MedicButton.OnCursorEntered = function() 

	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1) then
		icon:SetModel( "models/player/tfc_medic.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/medic/bot_medic.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/medic.mdl" ) -- you can only change colors on playermodels
	end
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	if LocalPlayer():GetPlayerClass() == "medic" then 
		icon2:GetEntity():SetModel(LocalPlayer():GetWeapons()[2]:GetItemData().model_player)
	else 
		icon2:GetEntity():SetModel("models/weapons/c_models/c_medigun/c_medigun.mdl") 
	end 
	LocalPlayer():EmitSound( "/music/class_menu_07.wav", 100, 100, 1, CHAN_VOICE ) 
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
end
SniperButton.DoClick = function() RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "sniper") surface.PlaySound( "/music/class_menu_08.wav" ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end

SniperButton.OnCursorEntered = function() 

	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1) then
		icon:SetModel( "models/player/tfc_sniper.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/sniper/bot_sniper.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/sniper.mdl" ) -- you can only change colors on playermodels
	end
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	if LocalPlayer():GetPlayerClass() == "sniper" then 
		icon2:GetEntity():SetModel(LocalPlayer():GetWeapons()[1]:GetItemData().model_player)
	else 
		icon2:GetEntity():SetModel("models/weapons/c_models/c_sniperrifle/c_sniperrifle.mdl") 
	end 
	LocalPlayer():EmitSound( "/music/class_menu_08.wav", 100, 100, 1, CHAN_VOICE ) 
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
end
SpyButton.OnCursorEntered = function() 

	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1) then
		icon:SetModel( "models/player/tfc_spy.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/spy/bot_spy.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/spy.mdl" ) -- you can only change colors on playermodels
	end
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	if LocalPlayer():GetPlayerClass() == "spy" then 
		icon2:GetEntity():SetModel(LocalPlayer():GetWeapons()[3]:GetItemData().model_player)
	else 
		icon2:GetEntity():SetModel("models/weapons/c_models/c_knife/c_knife.mdl") 
	end 
	LocalPlayer():EmitSound( "/music/class_menu_09.wav", 100, 100, 1, CHAN_VOICE ) 
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
end

local Hint = vgui.Create( "DLabel", ClassFrame )
Hint:SetPos( 10, 70 )
Hint:SetText(  ("Press the key ".. string.upper(",").." to open this menu" ) ) 
Hint:SizeToContents()

local Hint = vgui.Create( "DLabel", ClassFrame )
Hint:SetPos( 10, 82 )
Hint:SetText(  ( string.upper(input.LookupBinding( "gm_showspare1" )) or "F3" ).." to open the hat picker" )
Hint:SizeToContents() 

local Hint = vgui.Create( "DLabel", ClassFrame )
Hint:SetPos( 10, 94 )
Hint:SetText(  ( string.upper(input.LookupBinding( "gm_showspare2" )) or "F4" ).." to open the weapon picker" )
Hint:SizeToContents()

local Option1 = vgui.Create( "DCheckBox", ClassFrame )
Option1:SetPos( 10, 110 )
Option1:SetValue( GetConVar("tf_righthand"):GetInt() )

function Option1:OnChange(new)
	if new == false then
		RunConsoleCommand("tf_righthand", 0)
	else
		RunConsoleCommand("tf_righthand", 1)
	end
end

local Option1text = vgui.Create( "DLabel", ClassFrame )
Option1text:SetPos( 30, 110 )
Option1text:SetText( "Right handed" )
Option1text:SizeToContents()

local Option2 = vgui.Create( "DCheckBox", ClassFrame )
Option2:SetPos( 100, 110 )
Option2:SetValue( GetConVar("tf_autoreload"):GetInt() )
if (!GetConVar("tf_disable_fun_classes"):GetBool()) then
	local GmodButton = vgui.Create("DButton", ClassFrame)
	GmodButton:SetSize(100, 30)
	GmodButton:SetPos(366, 70)
	GmodButton:SetText("GMod Player") --Set the name of the button
	GmodButton.DoClick = function() RunConsoleCommand("changeclass", "gmodplayer") RunConsoleCommand("cl_wpn_sway_interp","0.1") ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM")  end
	GmodButton.OnCursorEntered = function() 
		icon2:GetEntity():SetModel("models/weapons/w_crowbar.mdl") if LocalPlayer():IsHL2() then icon:SetModel( LocalPlayer():GetModel() ) else icon:SetModel(player_manager.TranslatePlayerModel(GetConVar("cl_playermodel"):GetString())) end  icon2:GetEntity():SetParent(icon:GetEntity()) icon2:GetEntity():AddEffects(EF_BONEMERGE) LocalPlayer():EmitSound( "/music/class_menu_07db.wav", 100, 100, 1, CHAN_VOICE ) local dance = icon:GetEntity():LookupSequence( "run_melee" ) icon:GetEntity():SetSequence( dance ) icon:GetEntity():SetModelScale(0.865) icon:GetEntity():SetPoseParameter("move_x",1)  
	end 
end
function Option2:OnChange(new)
	if new == false then
		RunConsoleCommand("tf_autoreload", 0)
	else
		RunConsoleCommand("tf_autoreload", 1)
	end
end

local Option2text = vgui.Create( "DLabel", ClassFrame )
Option2text:SetPos( 120, 110 )
Option2text:SetText( "Autoreload" )
Option2text:SizeToContents()

local Option3 = vgui.Create( "DCheckBox", ClassFrame )
Option3:SetPos( 180, 110 )
Option3:SetValue( GetConVar("tf_robot"):GetInt() )

local Option4 = vgui.Create( "DCheckBox", ClassFrame )
Option4:SetPos( 180, 140 )
Option4:SetValue( GetConVar("tf_tfc_model_override"):GetInt() )

local Option5 = vgui.Create( "DCheckBox", ClassFrame )
Option5:SetPos( 180, 170 )
Option5:SetValue( GetConVar("cl_hud_playerclass_use_playermodel"):GetInt() )
 
function Option3:OnChange(new)
	RunConsoleCommand("kill")
	if new == false then
		RunConsoleCommand("tf_robot", 0)
	else
		RunConsoleCommand("tf_robot", 1)
	end
end

local Option3text = vgui.Create( "DLabel", ClassFrame )
Option3text:SetPos( 200, 110 )
Option3text:SetText( "Become a Robot" )
Option3text:SizeToContents()

local Option4text = vgui.Create( "DLabel", ClassFrame )
Option4text:SetPos( 200, 140 )
Option4text:SetText( "Become a TFC Mercenary" )
Option4text:SizeToContents()

function Option4:OnChange(new)
	RunConsoleCommand("kill")
	if new == false then
		RunConsoleCommand("tf_tfc_model_override", 0)
	else
		RunConsoleCommand("tf_tfc_model_override", 1)
	end
end
local Option5text = vgui.Create( "DLabel", ClassFrame )
Option5text:SetPos( 200, 170 )
Option5text:SetText( "Toggle 3D Class Icon" )
Option5text:SizeToContents()

function Option5:OnChange(new)
	if new == false then
		RunConsoleCommand("cl_hud_playerclass_use_playermodel", 0)
	else
		RunConsoleCommand("cl_hud_playerclass_use_playermodel", 1)
	end
end


--[[
local tauntlaugh = vgui.Create( "DButton", ClassFrame )
function tauntlaugh.DoClick() RunConsoleCommand( "tf_taunt_laugh" ) ClassFrame:Close() end
tauntlaugh:SetPos( 430, 107 )
tauntlaugh:SetSize( 90, 20 )
tauntlaugh:SetText( "Schadenfreude" )

local taunt1 = vgui.Create( "DButton", ClassFrame )
function taunt1.DoClick() RunConsoleCommand( "tf_taunt", "1" ) ClassFrame:Close() end
taunt1:SetPos( 310, 107 )
taunt1:SetSize( 20, 20 )
taunt1:SetText( "1" )

local taunt2 = vgui.Create( "DButton", ClassFrame )
function taunt2.DoClick() RunConsoleCommand( "tf_taunt", "2" ) ClassFrame:Close() end
taunt2:SetPos( 340, 107 )
taunt2:SetSize( 20, 20 )
taunt2:SetText( "2" )

local taunt3 = vgui.Create( "DButton", ClassFrame )
function taunt3.DoClick() RunConsoleCommand( "tf_taunt", "3" ) ClassFrame:Close() end
taunt3:SetPos( 380, 107 )
taunt3:SetSize( 20, 20 )
taunt3:SetText( "3" )
]]

--[[local tauntlaugh = vgui.Create( "DButton", ClassFrame )
function tauntlaugh.DoClick() RunConsoleCommand( "tf_tp_immersive_toggle" ) ClassFrame:Close() end
tauntlaugh:SetPos( 590, 107 )
tauntlaugh:SetSize( 90, 20 )
tauntlaugh:SetText( "Immersive Toggle" )]]

local tauntlaugh = vgui.Create( "DButton", ClassFrame )
function tauntlaugh.DoClick() RunConsoleCommand( "tf_hatpainter" )  end
tauntlaugh:SetPos( 430, 107 )
tauntlaugh:SetSize( 90, 20 )
tauntlaugh:SetText( "Hat Painter" )

--[[local function select_item(selector, data, item)
	print(item)
	if data and selector:GetOptionData(data) then
		ply:ConCommand( "giveitem "..selector:GetOptionData(data) )
	else
		ply:ConCommand( "giveitem "..item )
	end
end

local weaponselector = vgui.Create( "DComboBox", ClassFrame )
weaponselector:SetValue( "Weapons" )
weaponselector:Center()
weaponselector:SetPos( 590, 107 )
weaponselector:SetSize( 100, 20 )
function weaponselector.OnSelect( _, data, weapon )
	select_item( weaponselector, data, weapon )

	weaponselector:CloseMenu()
	weaponselector:SetValue( "Weapons" )
	weaponselector:SetTooltip("test")
end

local miscselector = vgui.Create( "DComboBox", ClassFrame )
miscselector:SetValue( "Miscs" )
miscselector:Center()
miscselector:SetPos( 590, 86 )
miscselector:SetSize( 100, 20 )
function miscselector.OnSelect( _, data, misc )
	select_item( miscselector, data, misc )

	miscselector:CloseMenu()
	miscselector:SetValue( "Miscs" )
end

local hatselector = vgui.Create( "DComboBox", ClassFrame )
hatselector:SetValue( "Hats" )
hatselector:Center()
hatselector:SetPos( 590, 65 )
hatselector:SetSize( 100, 20 )
function hatselector.OnSelect( _, data, hat )
	select_item( hatselector, data, hat )

	hatselector:CloseMenu()
	hatselector:SetValue( "Hats" )
end

for k, v in pairs(tf_items.ReturnItems()) do
	if v and istable(v) and v["name"] and GetImprovedItemName(v["name"]) then
		if string.sub(GetImprovedItemName(v["name"]), 1, 3) == "wep" then
			weaponselector:AddChoice(string.sub(GetImprovedItemName(v["name"]), 4), v["name"])
		elseif string.sub(GetImprovedItemName(v["name"]), 1, 3) == "hat" then
			hatselector:AddChoice(string.sub(GetImprovedItemName(v["name"]), 4), v["name"])
		end
	end
end]]

end

--[[function GM:PlayerBindPress(pl, bind, pressed)
	if (bind == "+menu") then
		RunConsoleCommand("lastinv")
	end
end]]

function paintcanTohex(dec) -- code from https://stackoverflow.com/a/37797380
	return string.sub(string.format("%x", dec * 256), 1, 6)
end

function hex2color(hex) -- code from https://gist.github.com/jasonbradley/4357406
    hex = hex:gsub("#","")
    local r, g, b = tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
    return string.ToColor(r.." "..g.." "..b.." 255")
end

function itemSelector(type, weapons)
    local Scale = ScrH() / 480
    local loadout_rect = surface.GetTextureID("vgui/loadout_rect")
    local loadout_rect_mouseover = surface.GetTextureID("vgui/loadout_rect_mouseover")

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Item Picker")
    frame:SetSize(1300, 650)
    frame:Center()
    frame:SetDraggable(true)
    frame:SetMouseInputEnabled(true)
    frame:MakePopup() 

    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:Dock(FILL)

    local itemicons = vgui.Create("DIconLayout", scroll)
    itemicons:Dock(FILL)

    local attr = vgui.Create("ItemAttributePanel")
    attr:SetSize(168 * Scale, 300 * Scale)
    attr:SetPos(0, 0)
    attr.text_ypos = 20
    attr:SetMouseInputEnabled(false)

    for k, v in pairs(weapons) do
        local model = vgui.Create("ItemModelPanel", frame)
        model:SetSize(140 * Scale, 75 * Scale)
        model:SetCursor("hand")
        model:SetQuality(v.item_quality and string.upper(string.sub(v.item_quality, 1, 1)) .. string.sub(v.item_quality, 2) or 0)
        model.activeImage = loadout_rect_mouseover
        model.inactiveImage = loadout_rect
        model.number = type
        model.model_xpos = 0
        model.model_ypos = 5
        model.model_tall = 55
        model.text_xpos = -5
        model.text_wide = 150
        model.text_ypos = 60
        model.itemImage_low = nil
        model.text = tf_lang.GetRaw(v.item_name) or v.name
        model.centerytext = true
        model.disabled = false
        if !isstring(v.image_inventory) or Material(v.image_inventory):IsError() then
            model.FallbackModel = v.model_player
            model.itemImage = surface.GetTextureID("backpack/weapons/c_models/c_bat")
        elseif isstring(v.image_inventory) then
            model.itemImage = surface.GetTextureID(v.image_inventory)
        end

        if v.attributes and v.attributes["material override"] and v.attributes["material override"].value then
            model.overridematerial = v.attributes["material override"].value
        end

        model.DoClick = function()
            nextLoadoutUpdate = 0
            updateLoadout(type, v.id)
            surface.PlaySound(v.mouse_pressed_sound or "ui/item_hat_pickup.wav")
            frame:Close()
        end

        if istable(v.attributes) then
            model.attributes = v.attributes
        end

        itemicons:Add(model)
    end

    attr:MoveToFront()
end

-- wouldn't mind a hex to rgb in glua by default

local function HatPicker() -- inb4 someone modifies this menu without using #suggestions in the first place
-- lol ~ Seamus
local ply = LocalPlayer()
local Frame = vgui.Create( "DFrame" )
Frame:SetTitle( "Hat Painter" )
Frame:SetSize( 300, 385 )
Frame:Center()
Frame:MakePopup()

local function add_hats(paintlist, convar, colorpicker)
	local paintlistc = paintlist:AddNode("None")
	paintlistc:SetIcon("icon16/cancel.png")
	paintlistc.DoClick = function()
		local color = Color(0, 0, 0, 255)
		colorpicker:SetColor(Color(0, 0, 0)) -- hack!!
		ply:ConCommand(convar.." "..tostring(color))
	end
	for k, v in pairs(tf_items.ReturnItems()) do
		if v and istable(v) and v["name"] and v["item_name"] and v["item_class"] and v["attributes"] and v["attributes"]["set item tint rgb"] and v["attributes"]["set item tint rgb"]["value"] and not blacklist[tf_lang.GetRaw(v["item_name"])] then
			if (v["item_class"] == "tool" and string.sub(v["name"], 1, 5) == "Paint") then
				local paintlistn = paintlist:AddNode(tf_lang.GetRaw(v["item_name"])) --.." ("..v["attributes"]["set item tint rgb"]["value"]..")")
				paintlistn:SetIcon("backpack/player/items/crafting/paintcan")
				paintlistn:SetTooltip(tf_lang.GetRaw(v["item_name"]).." ("..tostring(hex2color(paintcanTohex(v["attributes"]["set item tint rgb"]["value"])))..")")
				if ply:GetInfo(convar) == tostring(hex2color(paintcanTohex(v["attributes"]["set item tint rgb"]["value"]))) then
					paintlist:SetSelectedItem(paintlistn)
				end
				paintlistn.DoClick = function()
					local color = tostring(hex2color(paintcanTohex(v["attributes"]["set item tint rgb"]["value"])))
					colorpicker:SetColor(hex2color(paintcanTohex(v["attributes"]["set item tint rgb"]["value"]))) -- hack!!
					ply:ConCommand(convar.." "..color)
				end
			end
		end
	end
	if not paintlist:GetSelectedItem() then
		paintlist:SetSelectedItem(paintlistc)
	end
end

local ColorPicker = vgui.Create( "DColorMixer", Frame )
ColorPicker:SetSize( 150, 150 )
ColorPicker:SetPos( 5, 30 )
ColorPicker:SetPalette( false )
ColorPicker:SetAlphaBar( false )
ColorPicker:SetWangs( true )
ColorPicker:SetColor(string.ToColor(ply:GetInfo("tf_hatcolor")))
ColorPicker.ValueChanged = function()
	local ChosenColor = ColorPicker:GetColor()
	local color = Color(ChosenColor.r, ChosenColor.g, ChosenColor.b, ChosenColor.a)
	ply:ConCommand("tf_hatcolor "..tostring(color))
end

local ColorPicker2 = vgui.Create( "DColorMixer", Frame )
ColorPicker2:SetSize( 150, 150 )
ColorPicker2:SetPos( 5, 230 )
ColorPicker2:SetPalette( false )
ColorPicker2:SetAlphaBar( false )
ColorPicker2:SetWangs( true )
ColorPicker2:SetColor(string.ToColor(ply:GetInfo("tf_misccolor")))
ColorPicker2.ValueChanged = function()
	local ChosenColor = ColorPicker2:GetColor()
	local color = Color(ChosenColor.r, ChosenColor.g, ChosenColor.b, ChosenColor.a)
	ply:ConCommand("tf_misccolor "..tostring(color))
end

local paintlist = vgui.Create( "DTree", Frame )
paintlist:SetPos( 170, 30 )
paintlist:SetSize( 125, 150 )

local paintlist2 = vgui.Create( "DTree", Frame )
paintlist2:SetPos( 170, 230 )
paintlist2:SetSize( 125, 150 )

add_hats(paintlist, "tf_hatcolor", ColorPicker)
add_hats(paintlist2, "tf_misccolor", ColorPicker2)
end


concommand.Add("tf_upgradewep03clientonly", function(ply)
	ply:GetActiveWeapon().Primary.Delay = 0.3
end)
concommand.Add("check_save_table", function(ply)
	PrintTable(ply:GetSaveTable())
end)
concommand.Add("tf_upgradewep05clientonly", function(ply)
	ply:GetActiveWeapon().Primary.Delay = 0.5
end)
concommand.Add("tf_upgradewep04clientonly", function(ply)
	ply:GetActiveWeapon().Primary.Delay = 0.4
end)
concommand.Add("tf_upgradeweprapidfireclientonly", function(ply)
	ply:GetActiveWeapon().Primary.Delay = 0.15 
end)
concommand.Add("tf_upgradeweprapidfire2clientonly", function(ply)
	ply:GetActiveWeapon().Primary.Delay = 0.07
end)
concommand.Add("l4d_changeclass", L4DClassSelection)
concommand.Add("l4d2_changeclass", L4DClassSelection)
concommand.Add("tf_changeclass", ClassSelection)
concommand.Add("tf_door", DoorClose)
concommand.Add("tf_hatpainter", HatPicker)
concommand.Add("tf_menu", ClassSelection)
--spawnmenu.AddCreationTab( "Team Fortress 2", function()

	--local ctrl = vgui.Create( "SpawnmenuContentPanel" )
	--return ctrl

--end, "icon16/control_repeat_blue.png", 200 )

--[[function GM:OnSpawnMenuOpen()
	return --ply:IsAdmin()
end]]

hook.Add( "PlayerSay", "Change class", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass" ) then
		RunConsoleCommand("tf_changeclass")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Scout", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass scout" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "scout")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Soldier", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass soldier" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "soldier")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Pyro", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass pyro" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "pyro")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Demoman", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass demoman" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "demoman")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Heavy", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass heavy" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "heavy")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Engineer", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass engineer" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "engineer")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Medic", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass medic" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "medic")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Sniper", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass sniper" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "sniper")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Spy", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass spy" ) then
		RunConsoleCommand("cl_wpn_sway_interp","0.0") RunConsoleCommand("changeclass", "spy")
		return false
	end
end )

hook.Add( "PlayerSay", "Change Team Red", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeteam red" ) then
		RunConsoleCommand("changeteam", "1")
		return false
	end
end )

hook.Add( "PlayerSay", "Change Team Blu", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeteam blu" ) then
		RunConsoleCommand("changeteam", "2")
		return false
	end
end )

hook.Add( "PlayerSay", "Change Team Blu", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeteam blu" ) then
		RunConsoleCommand("changeteam", "2")
		return false
	end
end )
