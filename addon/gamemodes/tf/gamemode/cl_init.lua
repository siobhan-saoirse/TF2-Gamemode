

local LOGFILE = "tf/log_client.txt"
file.Delete(LOGFILE)
file.Append(LOGFILE, "Loading clientside script\n")
local load_time = SysTime()
local blacklist = {["Frying Pan"] = true, ["Golden Frying Pan"] = true, ["The PASSTIME Jack"] = true, ["TTG Max Pistol"] = true, ["Sexo de Pene Gay"] = true, ["Team Spirit"] = true,} -- Items that should NEVER show, must be their item.name if a hat/weapon!
local name_blacklist = {["The AK47"] = true,} -- Weapons that have names of other weapons must have their item.name put in here

include("cl_hud.lua")
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

include("cl_loadout.lua")

include("proxies/itemtintcolor.lua")

include("proxies/sniperriflecharge.lua")
include("proxies/weapon_invis.lua")
include("shd_gravitygun.lua")

hook.Add( "PopulateToolMenu", "Civ2Settings1", function()
	spawnmenu.AddToolMenuOption( "Options", "Civilian 2", "TF2GMCiv2Options", "#Settings", "", "", function( panel )
		panel:ClearControls()
		panel:CheckBox( "TF2 CLASSES: Use Minimized Viewmodels", "tf_use_min_viewmodels" )
		panel:CheckBox( "TF2 CLASSES: Give Extra Weapons on Spawn", "tf_give_hl2_weapons" )
		panel:CheckBox( "Enable Pyrovision", "tf_pyrovision" )
		panel:NumSlider( "TF2 SWEPS: Viewmodel FOV", "viewmodel_fov_tf", 52, 120 )
		panel:CheckBox( "TF2 CLASSES: Force HEV Hud", "tf_forcehl2hud" )
		panel:CheckBox( "Enable Debugging for TF Bots", "z_debug" )
		if (IsMounted("left4dead2")) then
			panel:CheckBox( "Enable L4D2 Footsteps for GMOD Player", "civ2_enable_survivor_steps" )
		end
		panel:Button("Toggle Thirdperson","tf_tp_simulation_toggle","")
		panel:Button("Toggle Shoulder Thirdperson","tf_tp_thirdperson_toggle","")
		panel:Button("Toggle Immersive View","tf_tp_immersive_toggle","")
		panel:NumSlider( "SPECIAL: Voice DSP Type", "tf_special_dsp_type", 1, 135 )
		panel:CheckBox( "Right Handed", "tf_righthand" )
		-- Add stuff here
	end )
	spawnmenu.AddToolMenuOption( "Options", "Civilian 2", "TF2GMCiv2Customization", "#Customization Settings", "", "", function( panel )
		panel:ClearControls()
		panel:CheckBox( "Become a Robot", "tf_robot" )
		panel:CheckBox( "Become a Skeleton", "tf_skeleton" )
		panel:CheckBox( "Become an Ordinary Yeti", "tf_yeti" )
		panel:CheckBox( "Use HWM Models", "tf_usehwmmodels" )
		panel:CheckBox( "Use Advanced Character Models (requires an addon)", "tf_useadvhwmmodels" )
	end )
end )

hook.Add( "CalcView", "SetPosToRagdoll", function( ply, pos, angles, fov )
	if (!ply:Alive()) then
		if (IsValid(ply:GetNWEntity("RagdollEntity"))) then
			if ((ply:GetObserverMode() == OBS_MODE_DEATHCAM or (!ply:Alive() and !IsValid(ply:GetObserverTarget()))) and ply:GetObserverMode() != OBS_MODE_FREEZECAM) then
				local ragdoll = ply:GetNWEntity("RagdollEntity")
				local newdist = 115
				local origin = ragdoll:GetPos()
				if GetConVar("cam_collision"):GetBool() then
					if (GetConVar("civ2_first_person_deathcam"):GetBool()) then
						local ang = angles
						if (ragdoll:LookupBone("bip_head") != nil) then
						
							local origin2 = ragdoll:GetBonePosition(ragdoll:LookupBone("bip_head"))
							ang = ragdoll:GetBoneAngles(ragdoll:LookupBone("bip_head"))
														
							local tr = util.TraceHull{
								start = origin2,
								endpos = origin2,
								angles = ang,
								filter = {ply,ragdoll},
								mins = Vector(-3,-3,-3),
								maxs = Vector( 3, 3, 3)
							}
							newdist = 20 * tr.Fraction
							
							local newangles = ang
							local view = {
								origin = origin2,
								angles = newangles,
								fov = fov,
								drawviewer = true
							}	
							return view

						elseif (ragdoll:LookupBone("ValveBiped.Bip01_Head1") != nil) then
						
							local origin2 = ragdoll:GetBonePosition(ragdoll:LookupBone("ValveBiped.Bip01_Head1"))
							ang = ragdoll:GetBoneAngles(ragdoll:LookupBone("ValveBiped.Bip01_Head1"))
							
							local tr = util.TraceHull{
								start = origin2,
								endpos = origin2,
								angles = ang,
								filter = {ply,ragdoll},
								mins = Vector(-3,-3,-3),
								maxs = Vector( 3, 3, 3)
							}
							newdist = 20 * tr.Fraction
							
							local newangles = ang
							local view = {
								origin = origin2,
								angles = newangles,
								fov = fov,
								drawviewer = true
							}	
							return view
						end

					else
						local tr = util.TraceHull{
							start = origin,
							endpos = origin - newdist * angles:Forward(),
							filter = {ply,ragdoll},
							mins = Vector(-3,-3,-3),
							maxs = Vector( 3, 3, 3)
						}
						newdist = 115 * tr.Fraction
						local newangles = angles
						local view = {
							origin = ragdoll:GetPos() - ( angles:Forward() * newdist ),
							angles = newangles,
							fov = fov,
							drawviewer = true
						}	
						return view

					end				
				end
			end
		end
	end
end )
 
if (IsValid(LocalPlayer())) then
	LocalPlayer():PrintMessage(HUD_PRINTTALK, "SERVER IS RELOADING THE GAMEMODE DUE TO AN EDIT IN THE GAMEMODE'S CLIENTSIDE CODE - GRAPHICAL OR GAME-BREAKING GLITCHES MAY OCCUR")
	LocalPlayer():PrintMessage(HUD_PRINTCENTER, "SERVER IS RELOADING THE GAMEMODE DUE TO AN EDIT IN THE GAMEMODE'S CLIENTSIDE CODE - GRAPHICAL OR GAME-BREAKING GLITCHES MAY OCCUR")
end

CreateClientConVar("civ2_enable_survivor_steps", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE})
CreateClientConVar("civ2_first_person_deathcam", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE})
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
CreateClientConVar( "tf_tfc_model_override", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, /*FCVAR_ARCHIVE*/ FCVAR_DEVELOPMENTONLY}, "Become a TFC Merc after respawning." )
CreateClientConVar( "tf_giant_robot", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become a mighty robot after respawning." )
CreateClientConVar( "tf_sentrybuster", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become a mighty bustah after respawning." )
CreateClientConVar( "tf_skeleton", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Spooky... https://youtu.be/fPRMLk3jHX4" )
CreateClientConVar( "tf_yeti", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become a ordinary yeti after respawning." )
CreateClientConVar( "tf_hhh", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become HHH Jr. after respawning." )
CreateClientConVar( "tf_player_use_female_models", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "For testing. Appends '_female' to the model filename loaded. SOLDIER ONLY" )
CreateClientConVar( "tf_give_hl2_weapons", "1", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "If set to 1, HL2 Weapons will be given to you as an TF2 Class when spawned." )
--CreateClientConVar( "civ2_bootleg_charger", "0", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Become a bootleg charger after respawning." )
CreateClientConVar( "tf_dingalingaling_sound", "", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Ding Dong!" )
CreateClientConVar( "tf_dingalingaling_killsound", "", {FCVAR_CLIENTCMD_CAN_EXECUTE, FCVAR_ARCHIVE}, "Diiinnng...." )


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
RunConsoleCommand("snd_restart")
physenv.SetGravity(Vector(0,0,-386))
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

local function DoHealthBonusEffect(ent, positive, islargerthan100)
	if not IsValid(ent) then return end
	if (!islargerthan100) then 
		islargerthan100 = false
	end

	local col = "red"
	if ent:EntityTeam()==TEAM_BLU then col = "blu" end
	if ent:EntityTeam()==TF_TEAM_PVE_INVADERS then col = "blu" end
	
	local pos = ent:GetPos() + Vector(0,0,75) + math.Rand(0,4) * Angle(math.Rand(-180,180),math.Rand(-180,180),0):Forward()
	if (ent:IsPlayer()) then
		pos = ent:GetPos() + ent:GetCurrentViewOffset()
	end

	if (ent:IsMiniBoss()) then
		if positive then
			if (islargerthan100) then
				ParticleEffect("healthgained_"..col.."_giant", pos, Angle(0,0,0))
			else
				ParticleEffect("healthgained_"..col.."_large", pos, Angle(0,0,0))
			end
		else
			if (islargerthan100) then
				ParticleEffect("healthlost_"..col.."_giant", pos, Angle(0,0,0))
			else
				ParticleEffect("healthlost_"..col.."_large", pos, Angle(0,0,0))
			end
		end
	else
		if positive then
			ParticleEffect("healthgained_"..col, pos, Angle(0,0,0))
		else
			ParticleEffect("healthlost_"..col, pos, Angle(0,0,0))
		end
	end
end

local function TransferBones( base, ragdoll ) -- Transfers the bones of one entity to a ragdoll's physics bones (modified version of some of RobotBoy655's code)
	if !IsValid( base ) or !IsValid( ragdoll ) then return end
	for i = 0, ragdoll:GetPhysicsObjectCount() - 1 do
		local bone = ragdoll:GetPhysicsObjectNum( i )
		if ( IsValid( bone ) ) then
			local pos, ang = base:GetBonePosition( ragdoll:TranslatePhysBoneToBone( i ) )
			if ( pos ) then bone:SetPos( pos ) end
			if ( ang ) then bone:SetAngles( ang ) end
		end
	end
end

net.Receive("TauntAnim", function()
    local ply = net.ReadEntity()
    local anim = net.ReadInt(32)
    local autokill = net.ReadBool()
	
	ply:AddVCDSequenceToGestureSlot( GESTURE_SLOT_VCD, anim, 0, autokill )
end)
net.Receive("TFRagdollCreate", function()
    local ply = net.ReadEntity()
	local ragdoll = ClientsideRagdoll( ply:GetModel() )
	if (!IsValid(ragdoll)) then return end
	ply:SetNWEntity("RagdollEntity",ragdoll)
	ply.RagdollEntity = ragdoll
	ragdoll:SetSkin(ply:GetSkin())
	ragdoll:SetNoDraw( false )
	ragdoll:DrawShadow( true )
	TransferBones(ply,ragdoll)
	if (IsValid(ragdoll:GetPhysicsObject())) then
		local phys = ragdoll:GetPhysicsObject()
		phys:SetPos(ply:GetPos() + Vector(0,0,40))
		phys:AddVelocity(net.ReadVector() * 20)
	end
	timer.Simple(15, function()
		ragdoll:SetSaveValue( "m_bFadingOut", true )
	end)
	gamemode.Call("SetupPlayerRagdoll", ply, ragdoll)
end)
usermessage.Hook("PlayerHealthBonusEffect", function(um)
	local ent = GetPlayerByUserID(um:ReadLong())
	local positive = um:ReadBool()
	local healnumber = um:ReadBool()
	
	if ent ~= LocalPlayer() or ent:ShouldDrawLocalPlayer() then
		DoHealthBonusEffect(ent, positive, healnumber)
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
	 
	local TankButton = vgui.Create("DImageButton", ClassFrame)
	TankButton:SetSize(100, 30)
	TankButton:SetPos(10, 35)
	TankButton:SetText("Tank")
	TankButton.OnCursorEntered = function() icon:SetModel( "models/infected/hulk.mdl" ) icon2:GetEntity():SetParent(icon:GetEntity()) icon2:GetEntity():AddEffects(EF_BONEMERGE) icon2:GetEntity():SetModel("models/props_debris/concrete_chunk01a.mdl") local dance = icon:GetEntity():LookupSequence( "throw_02" ) icon:GetEntity():SetSequence( dance ) icon:GetEntity():SetModelScale(0.865) end
	TankButton.DoClick = function()  RunConsoleCommand("changeclass", "tank")  LocalPlayer():EmitSound("music/safe/themonsterswithout.wav") LocalPlayer():StopSound("ClassSelection.ThemeL4D") ClassFrame:Close()  end

	local BoomerButton = vgui.Create("DImageButton", ClassFrame)
	BoomerButton:SetSize(100, 30)
	BoomerButton:SetPos(100, 35)
	BoomerButton:SetText("Boomer") --Set the name of the button
	BoomerButton.OnCursorEntered = function() icon:SetModel( "models/infected/boomer_l4d.mdl" ) icon2:GetEntity():SetParent(icon:GetEntity()) icon2:GetEntity():AddEffects(EF_BONEMERGE) local dance = icon:GetEntity():LookupSequence( "Run_Upper_KNIFE" ) icon:GetEntity():SetSequence( dance ) icon:GetEntity():SetModelScale(0.865) end
	BoomerButton.DoClick = function()  RunConsoleCommand("changeclass", "boomer") ClassFrame:Close() LocalPlayer():EmitSound("music/safe/themonsterswithout.wav") LocalPlayer():StopSound("ClassSelection.ThemeL4D") end
	
	local L4DZombie = vgui.Create("DImageButton", ClassFrame)
	L4DZombie:SetSize(100, 30)
	L4DZombie:SetPos(190, 35)
	L4DZombie:SetText("Male Zombie") --Set the name of the button
	L4DZombie.DoClick = function()  RunConsoleCommand("changeclass", "l4d_zombie") ClassFrame:Close() LocalPlayer():EmitSound("music/safe/themonsterswithout.wav") LocalPlayer():StopSound("ClassSelection.ThemeL4D") LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end
	
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

iconC:SetCamPos( Vector( 90, 0, 40 ) )
iconC:SetPos( 0, 0)
iconC:SetModel( "models/vgui/ui_class01.mdl" ) -- you can only change colors on playermodels
iconC:SetZPos(-2)
iconC:SetFOV(70)
function iconC:LayoutEntity( Entity ) return end
local icon = vgui.Create( "DModelPanel", ClassFrame )
icon:SetSize(ScrW() * 0.412, ScrH() * 0.571)
icon:SetPos(ScrW() * 0.012, ScrH() * 0.301)
icon:SetCamPos( Vector( 140, 0, 40 ) )
if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1  and file.Exists("models/player/tfc_"..(c.ModelName or "scout")..".mdl", "WORKSHOP") ) then
	icon:SetModel( "models/player/tfc_heavy.mdl" ) -- you can only change colors on playermodels
elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
	icon:SetModel( "models/bots/heavy/bot_heavy.mdl" ) -- you can only change colors on playermodels
else
	icon:SetModel( "models/player/heavy.mdl" ) -- you can only change colors on playermodels
end
LocalPlayer():EmitSound( "/music/class_menu_05.wav", 100, 100, 1, CHAN_VOICE ) 
icon:GetEntity():SetModelScale(0.865)
icon:SetZPos(-1)
icon:SetCamPos( Vector( 90, 0, 40 ) )
icon:SetAnimated(true)
icon.AutomaticFrameAdvance = true

local icon2 = vgui.Create( "DModelPanel", ClassFrame )
icon2:SetSize(ScrW() * 0.412, ScrH() * 0.571)
icon2:SetPos(ScrW() * 0.012, ScrH() * 0.301)
icon2:SetZPos(-1)
icon2:SetCamPos( Vector( 90, 0, 40 ) )
icon2:SetModel( "models/weapons/w_models/w_minigun.mdl" ) -- you can only change colors on playermodels
icon2:SetAnimated(true)
icon2:GetEntity():SetParent(icon:GetEntity())
icon2:GetEntity():AddEffects(EF_BONEMERGE)

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
 
local ScoutButton = vgui.Create("DImageButton", ClassFrame)
ScoutButton:SetSize(ScrW() * 0.056, ScrH() * 0.195)
ScoutButton:SetPos(ScrW() * 0.128, ScrH() * -0.015) --ScrW() * 0.088, ScrH() * 0.002
--ScoutButton:SetText("Scout")
ScoutButton.DoClick = function()  RunConsoleCommand("changeclass", "scout") LocalPlayer():EmitSound( "/music/class_menu_01.wav", 100, 100, 1, CHAN_VOICE ) ClassFrame:Close()  end
ScoutButton:SetAlpha(255)
local scout_img = vgui.Create( "DImage", ScoutButton )	-- Add image to Frame
scout_img:SetPos( 0, 0 )	-- Move it into frame
scout_img:SetSize( ScoutButton:GetSize() )	-- Size it to 150x150
ScoutButton:SetImage( "vgui/class_sel_sm_scout_inactive" )
local SoldierButton = vgui.Create("DImageButton", ClassFrame)
SoldierButton:SetSize(ScrW() * 0.056, ScrH() * 0.195)
SoldierButton:SetPos(ScrW() * 0.178, ScrH() * -0.015) --ScrW() * 0.088, ScrH() * 0.002
--SoldierButton:SetText("Soldier") --Set the name of the button
local sol_img = vgui.Create( "DImage", SoldierButton )	-- Add image to Frame
sol_img:SetPos( 0, 0 )	-- Move it into frame
sol_img:SetSize( SoldierButton:GetSize() )	-- Size it to 150x150
SoldierButton:SetImage( "vgui/class_sel_sm_soldier_inactive" )
SoldierButton:SetAlpha(255)
SoldierButton.DoClick = function()  RunConsoleCommand("changeclass", "soldier") LocalPlayer():EmitSound( "/music/class_menu_02.wav", 100, 100, 1, CHAN_VOICE ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM")	end

local PyroButton = vgui.Create("DImageButton", ClassFrame)
PyroButton:SetSize(ScrW() * 0.056, ScrH() * 0.195)
PyroButton:SetPos(ScrW() * 0.248, ScrH() * -0.015)
--PyroButton:SetText("Pyro") --Set the name of the button
local py_img = vgui.Create( "DImage", PyroButton )	-- Add image to Frame
py_img:SetPos( 0, 0 )	-- Move it into frame
py_img:SetSize( PyroButton:GetSize() )	-- Size it to 150x150
PyroButton:SetImage( "vgui/class_sel_sm_pyro_inactive" )
PyroButton:SetAlpha(255)
PyroButton.DoClick = function()  RunConsoleCommand("changeclass", "pyro") LocalPlayer():EmitSound( "/music/class_menu_03.wav", 100, 100, 1, CHAN_VOICE ) ClassFrame:Close()  if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end

local DemomanButton = vgui.Create("DImageButton", ClassFrame)
DemomanButton:SetSize(ScrW() * 0.056, ScrH() * 0.195)
DemomanButton:SetPos(ScrW() * 0.358, ScrH() * -0.015)
--DemomanButton:SetText("Demoman") --Set the name of the button
DemomanButton.DoClick = function()  RunConsoleCommand("changeclass", "demoman") LocalPlayer():EmitSound( "/music/class_menu_04.wav", 100, 100, 1, CHAN_VOICE ) ClassFrame:Close()  if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end
local de_img = vgui.Create( "DImage", DemomanButton )	-- Add image to Frame
de_img:SetPos( 0, 0 )	-- Move it into frame
de_img:SetSize( DemomanButton:GetSize() )	-- Size it to 150x150
DemomanButton:SetImage( "vgui/class_sel_sm_demo_inactive" )
DemomanButton:SetAlpha(255)
local HeavyButton = vgui.Create("DImageButton", ClassFrame)
HeavyButton:SetSize(ScrW() * 0.056, ScrH() * 0.195)
HeavyButton:SetPos(ScrW() * 0.428, ScrH() * -0.015)
--HeavyButton:SetText("Heavy") --Set the name of the button
HeavyButton.DoClick = function()  RunConsoleCommand("changeclass", "heavy") LocalPlayer():EmitSound( "/music/class_menu_05.wav", 100, 100, 1, CHAN_VOICE ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end
local he_img = vgui.Create( "DImage", HeavyButton )	-- Add image to Frame
he_img:SetPos( 0, 0 )	-- Move it into frame
he_img:SetSize( HeavyButton:GetSize() )	-- Size it to 150x150
HeavyButton:SetImage( "vgui/class_sel_sm_heavy_inactive" )
HeavyButton:SetAlpha(255)
local EngineerButton = vgui.Create("DImageButton", ClassFrame)
EngineerButton:SetSize(ScrW() * 0.056, ScrH() * 0.195)
EngineerButton:SetPos(ScrW() * 0.478, ScrH() * -0.015)
--EngineerButton:SetText("Engineer") --Set the name of the button
EngineerButton.DoClick = function()  RunConsoleCommand("changeclass", "engineer") LocalPlayer():EmitSound( "/music/class_menu_06.wav", 100, 100, 1, CHAN_VOICE ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end
local en_img = vgui.Create( "DImage", EngineerButton )	-- Add image to Frame
en_img:SetPos( 0, 0 )	-- Move it into frame
en_img:SetSize( EngineerButton:GetSize() )	-- Size it to 150x150
en_img:SetImage( "vgui/class_sel_sm_engineer_inactive" )
EngineerButton:SetAlpha(255)

local MedicButton = vgui.Create("DImageButton", ClassFrame)
MedicButton:SetSize(ScrW() * 0.056, ScrH() * 0.195)
MedicButton:SetPos(ScrW() * 0.598, ScrH() * -0.015) 
--MedicButton:SetText("Medic") --Set the name of the button
local me_img = vgui.Create( "DImage", MedicButton )	-- Add image to Frame
me_img:SetPos( 0, 0 )	-- Move it into frame
me_img:SetSize( MedicButton:GetSize() )	-- Size it to 150x150
MedicButton:SetImage( "vgui/class_sel_sm_medic_inactive" )
MedicButton:SetAlpha(255)
MedicButton.DoClick = function()  RunConsoleCommand("changeclass", "medic") LocalPlayer():EmitSound( "/music/class_menu_07.wav", 100, 100, 1, CHAN_VOICE ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end

local SniperButton = vgui.Create("DImageButton", ClassFrame)
SniperButton:SetSize(ScrW() * 0.056, ScrH() * 0.195)
SniperButton:SetPos(ScrW() * 0.658, ScrH() * -0.015) 
--SniperButton:SetText("Sniper") --Set the name of the button
local sn_img = vgui.Create( "DImage", SniperButton )	-- Add image to Frame
sn_img:SetPos( 0, 0 )	-- Move it into frame
sn_img:SetSize( SniperButton:GetSize() )	-- Size it to 150x150
SniperButton:SetImage( "vgui/class_sel_sm_sniper_inactive" )
SniperButton:SetAlpha(255)
SniperButton.DoClick = function()  RunConsoleCommand("changeclass", "sniper") LocalPlayer():EmitSound( "/music/class_menu_08.wav", 100, 100, 1, CHAN_VOICE ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end

local SpyButton = vgui.Create("DImageButton", ClassFrame)
SpyButton:SetSize(ScrW() * 0.056, ScrH() * 0.195)
SpyButton:SetPos(ScrW() * 0.718, ScrH() * -0.015) 
--SpyButton:SetText("Spy") --Set the name of the button
local sp_img = vgui.Create( "DImage", SpyButton )	-- Add image to Frame
sp_img:SetPos( 0, 0 )	-- Move it into frame
sp_img:SetSize( SpyButton:GetSize() )	-- Size it to 150x150
SpyButton:SetImage( "vgui/class_sel_sm_spy_inactive" )
SpyButton.DoClick = function()  RunConsoleCommand("changeclass", "spy") LocalPlayer():EmitSound( "/music/class_menu_09.wav", 100, 100, 1, CHAN_VOICE ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end
scout_img:SetImage( "vgui/class_sel_sm_scout_inactive" )
sol_img:SetImage( "vgui/class_sel_sm_soldier_inactive" )
py_img:SetImage( "vgui/class_sel_sm_pyro_inactive" )
de_img:SetImage( "vgui/class_sel_sm_demo_inactive" )
he_img:SetImage( "vgui/class_sel_sm_heavy_inactive" )
en_img:SetImage( "vgui/class_sel_sm_engineer_inactive" )
me_img:SetImage( "vgui/class_sel_sm_medic_inactive" )
sn_img:SetImage( "vgui/class_sel_sm_sniper_inactive" )
sp_img:SetImage( "vgui/class_sel_sm_spy_inactive" )
local Hint = vgui.Create( "DLabel", ClassFrame )
Hint:SetPos( ScrW() * 0.129, ScrH() * 0.18 )
Hint:SetSize(90,12)
Hint:SetZPos(2)
Hint:SetText( "OFFENSE" ) 
Hint:SetFont( "MenuClassBuckets" ) 
Hint:SetColor( Color(117,107,94,255) )
Hint:SizeToContents()
local numscout = vgui.Create( "DLabel", ClassFrame )
numscout:SetPos( ScrW() * 0.131, ScrH() * 0.16 )
numscout:SetSize(90,12)
numscout:SetZPos(2)
numscout:SetText( "1" ) 
numscout:SetFont( "MenuClassBuckets" ) 
numscout:SetColor( Color(117,107,94,255) )
numscout:SizeToContents()

local numsoldier = vgui.Create( "DLabel", ClassFrame )
numsoldier:SetPos( ScrW() * 0.181, ScrH() * 0.16 )
numsoldier:SetSize(90,12)
numsoldier:SetZPos(2)
numsoldier:SetText( "2" ) 
numsoldier:SetFont( "MenuClassBuckets" ) 
numsoldier:SetColor( Color(117,107,94,255) )
numsoldier:SizeToContents()
local numpyro = vgui.Create( "DLabel", ClassFrame )
numpyro:SetPos( ScrW() * 0.251, ScrH() * 0.16 )
numpyro:SetSize(90,12)
numpyro:SetZPos(2)
numpyro:SetText( "3" ) 
numpyro:SetFont( "MenuClassBuckets" ) 
numpyro:SetColor( Color(117,107,94,255) )
numpyro:SizeToContents()
local Hint2 = vgui.Create( "DLabel", ClassFrame )
Hint2:SetPos( ScrW() * 0.362, ScrH() * 0.18 )
Hint2:SetSize(90,12)
Hint2:SetZPos(2)
Hint2:SetText( "DEFENSE" ) 
Hint2:SetFont( "MenuClassBuckets" ) 
Hint2:SetColor( Color(117,107,94,255) )
Hint2:SizeToContents()

local Hint3 = vgui.Create( "DLabel", ClassFrame )
Hint3:SetPos( ScrW() * 0.595, ScrH() * 0.18 )
Hint3:SetSize(90,12)
Hint3:SetZPos(2)
Hint3:SetText( "SUPPORT" ) 
Hint3:SetFont( "MenuClassBuckets" ) 
Hint3:SetColor( Color(117,107,94,255) )
Hint3:SizeToContents()

local numsoldier = vgui.Create( "DLabel", ClassFrame )
numsoldier:SetPos( ScrW() * 0.181, ScrH() * 0.16 )
numsoldier:SetSize(90,12)
numsoldier:SetZPos(2)
numsoldier:SetText( "2" ) 
numsoldier:SetFont( "MenuClassBuckets" ) 
numsoldier:SetColor( Color(117,107,94,255) )
numsoldier:SizeToContents()


local menuname = vgui.Create( "DLabel", ClassFrame )
menuname:SetPos( ScrW() * 0.545, ScrH() * 0.33 )
menuname:SetZPos(2)
menuname:SetText( "HEAVY" ) 
menuname:SetFont( "ChalkboardTitle" ) 
menuname:SizeToContents()

local menutext = vgui.Create( "DLabel", ClassFrame )
menutext:SetPos( ScrW() * 0.545, ScrH() * 0.43 )
menutext:SetZPos(2)
menutext:SetText( [[Spin your minigun without firing to be ready 
for approaching enemies!]] ) 
menutext:SetFont( "ChalkboardText" ) 
menutext:SetColor( Color(178,178,178,255) )
menutext:SizeToContents()

local GmodButton
local gm_img 
if (!GetConVar("tf_disable_fun_classes"):GetBool()) then
	GmodButton = vgui.Create("DImageButton", ClassFrame)
	GmodButton:SetSize(ScrW() * 0.056, ScrH() * 0.195)
	GmodButton:SetPos(ScrW() * 0.814, ScrH() * -0.015) --ScrW() * 0.088, ScrH() * 0.002
	--GmodButton:SetText("GMod Player") --Set the name of the button
	GmodButton:SetImage("vgui/class_sel_sm_random_inactive")
	GmodButton:SetAlpha(255)
	GmodButton.DoClick = function() LocalPlayer():EmitSound( "ui/buttonclick.wav", 100, 100, 1, CHAN_VOICE ) RunConsoleCommand("changeclass", "gmodplayer")  ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM")  end
	
	gm_img = vgui.Create( "DImage", GmodButton )	-- Add image to Frame
	gm_img:SetPos( 0, 0 )	-- Move it into frame
	gm_img:SetSize( SpyButton:GetSize() )	-- Size it to 150x150
	gm_img:SetImage("vgui/class_sel_sm_random_inactive")
	GmodButton.OnCursorEntered = function() 
		icon2:GetEntity():SetModel("models/weapons/w_crowbar.mdl") 
		if LocalPlayer():IsHL2() then 
			icon:SetModel( LocalPlayer():GetModel() ) 
		else 
			icon:SetModel(player_manager.TranslatePlayerModel(GetConVar("cl_playermodel"):GetString())) 
		end  
		icon2:GetEntity():SetParent(icon:GetEntity()) 
		icon2:GetEntity():AddEffects(EF_BONEMERGE) 
		LocalPlayer():EmitSound( "ui/buttonrollover.wav", 100, 100, 1, CHAN_VOICE ) 
		local dance = icon:GetEntity():LookupSequence( "run_melee" )
		icon:GetEntity():SetSequence( dance ) 
		icon:GetEntity():SetModelScale(0.865) 
		icon:GetEntity():SetPoseParameter("move_x",1)  
			
		scout_img:SetImage( "vgui/class_sel_sm_scout_inactive" )
		sol_img:SetImage( "vgui/class_sel_sm_soldier_inactive" )
		py_img:SetImage( "vgui/class_sel_sm_pyro_inactive" )
		de_img:SetImage( "vgui/class_sel_sm_demo_inactive" )
		he_img:SetImage( "vgui/class_sel_sm_heavy_inactive" )
		en_img:SetImage( "vgui/class_sel_sm_engineer_inactive" )
		me_img:SetImage( "vgui/class_sel_sm_medic_inactive" )
		sn_img:SetImage( "vgui/class_sel_sm_sniper_inactive" )
		sp_img:SetImage( "vgui/class_sel_sm_spy_inactive" )
		if LocalPlayer():Team()==1 or LocalPlayer():Team()==5 then
			gm_img:SetImage( "vgui/class_sel_sm_random_red" )
		elseif LocalPlayer():Team()==TEAM_BLU then
			gm_img:SetImage( "vgui/class_sel_sm_random_blu" )
		else
			gm_img:SetImage("vgui/class_sel_sm_random_inactive")
		end
			
		menuname:SetText( "GMOD PLAYER" ) 
		menutext:SetText( [[Become any character you'd like!
		Use Half-Life 2, Day of Defeat, Left 4 Dead 
		and Counter-Strike weapons!
		Do more damage towards TF2 Mercenaries!
		Hold SHIFT to move faster!
		Be mostly resistant to damage from TF2 Mercs!]] ) 
		menuname:SizeToContents()
		menutext:SizeToContents()
	end 
end
ScoutButton.OnCursorEntered = function() 
	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1  and file.Exists("models/player/tfc_"..(c.ModelName or "scout")..".mdl", "WORKSHOP") ) then
		icon:SetModel( "models/player/tfc_scout.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/scout/bot_scout.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/scout.mdl" ) -- you can only change colors on playermodels
	end
	menuname:SetText( "SCOUT" ) 
	menutext:SetText( [[You capture points faster than other classes!
double jump while in the air!]] ) 
		menuname:SizeToContents()
		menutext:SizeToContents()
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	icon2:GetEntity():SetModel("models/weapons/w_models/w_scattergun.mdl") 
	LocalPlayer():EmitSound( "/music/class_menu_01.wav", 100, 100, 1, CHAN_VOICE ) 
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
	if LocalPlayer():Team()==1 or LocalPlayer():Team()==5 then
		scout_img:SetImage( "vgui/class_sel_sm_scout_red" )
	elseif LocalPlayer():Team()==TEAM_BLU then
		scout_img:SetImage( "vgui/class_sel_sm_scout_blu" )
	else
		scout_img:SetImage( "vgui/class_sel_sm_scout_inactive" )
	end
	sol_img:SetImage( "vgui/class_sel_sm_soldier_inactive" )
	py_img:SetImage( "vgui/class_sel_sm_pyro_inactive" )
	de_img:SetImage( "vgui/class_sel_sm_demo_inactive" )
	he_img:SetImage( "vgui/class_sel_sm_heavy_inactive" )
	en_img:SetImage( "vgui/class_sel_sm_engineer_inactive" )
	me_img:SetImage( "vgui/class_sel_sm_medic_inactive" )
	sn_img:SetImage( "vgui/class_sel_sm_sniper_inactive" )
	sp_img:SetImage( "vgui/class_sel_sm_spy_inactive" )
	if (IsValid(GmodButton)) then
		gm_img:SetImage("vgui/class_sel_sm_random_inactive")
	end
end
SoldierButton.OnCursorEntered = function() 

	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1  and file.Exists("models/player/tfc_"..(c.ModelName or "scout")..".mdl", "WORKSHOP") ) then
		icon:SetModel( "models/player/tfc_soldier.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/soldier/bot_soldier.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/soldier.mdl" ) -- you can only change colors on playermodels
	end
	menuname:SetText( "SOLDIER" ) 
	menutext:SetText( [[Shoot your rocket launcher at enemy's feet!
Use your rocket launcher to rocket jump!]] ) 
		menuname:SizeToContents()
		menutext:SizeToContents()
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	icon2:GetEntity():SetModel("models/weapons/w_models/w_rocketlauncher.mdl") 
	LocalPlayer():EmitSound( "/music/class_menu_02.wav", 100, 100, 1, CHAN_VOICE ) 
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim0l" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
	if LocalPlayer():Team()==1 or LocalPlayer():Team()==5 then
		sol_img:SetImage( "vgui/class_sel_sm_soldier_red" )
	elseif LocalPlayer():Team()==TEAM_BLU then
		sol_img:SetImage( "vgui/class_sel_sm_soldier_blu" )
	else
		sol_img:SetImage( "vgui/class_sel_sm_soldier_inactive" )
	end
	scout_img:SetImage( "vgui/class_sel_sm_scout_inactive" )
	py_img:SetImage( "vgui/class_sel_sm_pyro_inactive" )
	de_img:SetImage( "vgui/class_sel_sm_demo_inactive" )
	he_img:SetImage( "vgui/class_sel_sm_heavy_inactive" )
	en_img:SetImage( "vgui/class_sel_sm_engineer_inactive" )
	me_img:SetImage( "vgui/class_sel_sm_medic_inactive" )
	sn_img:SetImage( "vgui/class_sel_sm_sniper_inactive" )
	sp_img:SetImage( "vgui/class_sel_sm_spy_inactive" )
	if (IsValid(GmodButton)) then
		gm_img:SetImage("vgui/class_sel_sm_random_inactive")
	end
end
PyroButton.OnCursorEntered = function() 

	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1  and file.Exists("models/player/tfc_"..(c.ModelName or "scout")..".mdl", "WORKSHOP") ) then
		icon:SetModel( "models/player/tfc_pyro.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/pyro/bot_pyro.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/pyro.mdl" ) -- you can only change colors on playermodels
	end
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	icon2:GetEntity():SetModel("models/weapons/c_models/c_flamethrower/c_flamethrower.mdl") 
	LocalPlayer():EmitSound( "/music/class_menu_03.wav", 100, 100, 1, CHAN_VOICE ) 
	menuname:SetText( "PYRO" ) 
	menutext:SetText( [[Ambush enemies at corners!
Your flamethrower is more effective the 
closer you are to your target!]] ) 
		menuname:SizeToContents()
		menutext:SizeToContents()
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
	if LocalPlayer():Team()==1 or LocalPlayer():Team()==5 then
		py_img:SetImage( "vgui/class_sel_sm_pyro_red" )
	elseif LocalPlayer():Team()==TEAM_BLU then
		py_img:SetImage( "vgui/class_sel_sm_pyro_blu" )
	else
		py_img:SetImage( "vgui/class_sel_sm_pyro_inactive" )
	end
	scout_img:SetImage( "vgui/class_sel_sm_scout_inactive" )
	sol_img:SetImage( "vgui/class_sel_sm_soldier_inactive" )
	de_img:SetImage( "vgui/class_sel_sm_demo_inactive" )
	he_img:SetImage( "vgui/class_sel_sm_heavy_inactive" )
	en_img:SetImage( "vgui/class_sel_sm_engineer_inactive" )
	me_img:SetImage( "vgui/class_sel_sm_medic_inactive" )
	sn_img:SetImage( "vgui/class_sel_sm_sniper_inactive" )
	sp_img:SetImage( "vgui/class_sel_sm_spy_inactive" )
	if (IsValid(GmodButton)) then
		gm_img:SetImage("vgui/class_sel_sm_random_inactive")
	end
end
DemomanButton.OnCursorEntered = function() 

	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1  and file.Exists("models/player/tfc_"..(c.ModelName or "scout")..".mdl", "WORKSHOP") ) then
		icon:SetModel( "models/player/tfc_demo.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/demo/bot_demo.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/demo.mdl" ) -- you can only change colors on playermodels
	end
	menuname:SetText( "DEMOMAN" ) 
	menutext:SetText( [[Remote detonate your stickybombs 
when enemies are near them!
Stickybomb jump by standing on 
a stickybomb and jumping as you detonate it!]] ) 
		menuname:SizeToContents()
		menutext:SizeToContents()
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	icon2:GetEntity():SetModel("models/weapons/c_models/c_grenadelauncher/c_grenadelauncher.mdl") 
	LocalPlayer():EmitSound( "/music/class_menu_04.wav", 100, 100, 1, CHAN_VOICE ) 
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
	scout_img:SetImage( "vgui/class_sel_sm_scout_inactive" )
	sol_img:SetImage( "vgui/class_sel_sm_soldier_inactive" )
	py_img:SetImage( "vgui/class_sel_sm_pyro_inactive" )
	if LocalPlayer():Team()==1 or LocalPlayer():Team()==5 then
		de_img:SetImage( "vgui/class_sel_sm_demo_red" )
	elseif LocalPlayer():Team()==TEAM_BLU then
		de_img:SetImage( "vgui/class_sel_sm_demo_blu" )
	else
		de_img:SetImage( "vgui/class_sel_sm_demo_inactive" )
	end
	he_img:SetImage( "vgui/class_sel_sm_heavy_inactive" )
	en_img:SetImage( "vgui/class_sel_sm_engineer_inactive" )
	me_img:SetImage( "vgui/class_sel_sm_medic_inactive" )
	sn_img:SetImage( "vgui/class_sel_sm_sniper_inactive" )
	sp_img:SetImage( "vgui/class_sel_sm_spy_inactive" )
	if (IsValid(GmodButton)) then
		gm_img:SetImage("vgui/class_sel_sm_random_inactive")
	end
end
HeavyButton.OnCursorEntered = function() 

	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1  and file.Exists("models/player/tfc_"..(c.ModelName or "scout")..".mdl", "WORKSHOP") ) then
		icon:SetModel( "models/player/tfc_heavy.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/heavy/bot_heavy.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/heavy.mdl" ) -- you can only change colors on playermodels
	end
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	icon2:GetEntity():SetModel("models/weapons/c_models/c_minigun/c_minigun.mdl") 
	LocalPlayer():EmitSound( "/music/class_menu_05.wav", 100, 100, 1, CHAN_VOICE ) 
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
	menuname:SetText( "HEAVY" ) 
	menutext:SetText( [[Spin your minigun without firing to be ready 
for approaching enemies!]] ) 
		menuname:SizeToContents()
		menutext:SizeToContents()
	scout_img:SetImage( "vgui/class_sel_sm_scout_inactive" )
	sol_img:SetImage( "vgui/class_sel_sm_soldier_inactive" )
	py_img:SetImage( "vgui/class_sel_sm_pyro_inactive" )
		de_img:SetImage( "vgui/class_sel_sm_demo_inactive" )
		if LocalPlayer():Team()==1 or LocalPlayer():Team()==5 then
			he_img:SetImage( "vgui/class_sel_sm_heavy_red" )
		elseif LocalPlayer():Team()==TEAM_BLU then
			he_img:SetImage( "vgui/class_sel_sm_heavy_blu" )
		else
			he_img:SetImage( "vgui/class_sel_sm_heavy_inactive" )
		end
	en_img:SetImage( "vgui/class_sel_sm_engineer_inactive" )
	me_img:SetImage( "vgui/class_sel_sm_medic_inactive" )
	sn_img:SetImage( "vgui/class_sel_sm_sniper_inactive" )
	sp_img:SetImage( "vgui/class_sel_sm_spy_inactive" )
	if (IsValid(GmodButton)) then
		gm_img:SetImage("vgui/class_sel_sm_random_inactive")
	end
end
EngineerButton.DoClick = function()  RunConsoleCommand("changeclass", "engineer") LocalPlayer():EmitSound( "/music/class_menu_06.wav" ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end

EngineerButton.OnCursorEntered = function() 

	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1  and file.Exists("models/player/tfc_"..(c.ModelName or "scout")..".mdl", "WORKSHOP") ) then
		icon:SetModel( "models/player/tfc_engineer.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/engineer/bot_engineer.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/engineer.mdl" ) -- you can only change colors on playermodels
	end
	menuname:SetText( "ENGINEER" ) 
	menutext:SetText( [[Collect metal from fallen weapons to build with!
Build sentryguns to defend your base! 
Upgrade them to level 3!
Build dispensers to supply your 
teammates with health & ammo!
Build teleporters to help 
team mates get to the front lines!]] ) 
		menuname:SizeToContents()
		menutext:SizeToContents()
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	icon2:GetEntity():SetModel("models/weapons/c_models/c_wrench/c_wrench.mdl") 
	LocalPlayer():EmitSound( "/music/class_menu_06.wav", 100, 100, 1, CHAN_VOICE ) 
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
	scout_img:SetImage( "vgui/class_sel_sm_scout_inactive" )
	sol_img:SetImage( "vgui/class_sel_sm_soldier_inactive" )
	py_img:SetImage( "vgui/class_sel_sm_pyro_inactive" )
	de_img:SetImage( "vgui/class_sel_sm_demo_inactive" )
	he_img:SetImage( "vgui/class_sel_sm_heavy_inactive" )
		if LocalPlayer():Team()==1 or LocalPlayer():Team()==5 then
			en_img:SetImage( "vgui/class_sel_sm_engineer_red" )
		elseif LocalPlayer():Team()==TEAM_BLU then
			en_img:SetImage( "vgui/class_sel_sm_engineer_blu" )
		else
			en_img:SetImage( "vgui/class_sel_sm_engineer_inactive" )
		end
	me_img:SetImage( "vgui/class_sel_sm_medic_inactive" )
	sn_img:SetImage( "vgui/class_sel_sm_sniper_inactive" )
	sp_img:SetImage( "vgui/class_sel_sm_spy_inactive" )
	if (IsValid(GmodButton)) then
		gm_img:SetImage("vgui/class_sel_sm_random_inactive")
	end
end
MedicButton.DoClick = function()  RunConsoleCommand("changeclass", "medic") LocalPlayer():EmitSound( "/music/class_menu_07.wav" ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end

MedicButton.OnCursorEntered = function() 

	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1  and file.Exists("models/player/tfc_"..(c.ModelName or "scout")..".mdl", "WORKSHOP") ) then
		icon:SetModel( "models/player/tfc_medic.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/medic/bot_medic.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/medic.mdl" ) -- you can only change colors on playermodels
	end
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	icon2:GetEntity():SetModel("models/weapons/c_models/c_medigun/c_medigun.mdl") 
	LocalPlayer():EmitSound( "/music/class_menu_07.wav", 100, 100, 1, CHAN_VOICE ) 
	menuname:SetText( "MEDIC" ) 
	menutext:SetText( [[Fill your ÜberCharge by 
	healing your team mates!
Use a full ÜberCharge to 
gain invulnerability for you and 
your medi gun target!]] ) 
		menuname:SizeToContents()
		menutext:SizeToContents()
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
	scout_img:SetImage( "vgui/class_sel_sm_scout_inactive" )
	sol_img:SetImage( "vgui/class_sel_sm_soldier_inactive" )
	py_img:SetImage( "vgui/class_sel_sm_pyro_inactive" )
	de_img:SetImage( "vgui/class_sel_sm_demo_inactive" )
	he_img:SetImage( "vgui/class_sel_sm_heavy_inactive" )
	en_img:SetImage( "vgui/class_sel_sm_engineer_inactive" )
		if LocalPlayer():Team()==1 or LocalPlayer():Team()==5 then
			me_img:SetImage( "vgui/class_sel_sm_medic_red" )
		elseif LocalPlayer():Team()==TEAM_BLU then
			me_img:SetImage( "vgui/class_sel_sm_medic_blu" )
		else
			sn_img:SetImage( "vgui/class_sel_sm_medic_inactive" )
		end
	sn_img:SetImage( "vgui/class_sel_sm_sniper_inactive" )
	sp_img:SetImage( "vgui/class_sel_sm_spy_inactive" )
	if (IsValid(GmodButton)) then
		gm_img:SetImage("vgui/class_sel_sm_random_inactive")
	end
end
SniperButton.DoClick = function()  RunConsoleCommand("changeclass", "sniper") LocalPlayer():EmitSound( "/music/class_menu_08.wav" ) ClassFrame:Close() if string.find(game.GetMap(), "mvm_") then LocalPlayer():EmitSound("music/mvm_class_select.wav") end LocalPlayer():StopSound("ClassSelection.ThemeNonMVM") LocalPlayer():StopSound("ClassSelection.ThemeMVM") end

SniperButton.OnCursorEntered = function() 

	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1  and file.Exists("models/player/tfc_"..(c.ModelName or "scout")..".mdl", "WORKSHOP") ) then
		icon:SetModel( "models/player/tfc_sniper.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/sniper/bot_sniper.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/sniper.mdl" ) -- you can only change colors on playermodels
	end
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	icon2:GetEntity():SetModel("models/weapons/c_models/c_sniperrifle/c_sniperrifle.mdl") 
	LocalPlayer():EmitSound( "/music/class_menu_08.wav", 100, 100, 1, CHAN_VOICE ) 
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
	menuname:SetText( "SNIPER" ) 
	menutext:SetText( [[Your sniper rifle will power up 
	to do more damage while you are zoomed in!
aim for the head to do critical hits!]] ) 
		menuname:SizeToContents()
		menutext:SizeToContents()
	scout_img:SetImage( "vgui/class_sel_sm_scout_inactive" )
	sol_img:SetImage( "vgui/class_sel_sm_soldier_inactive" )
	py_img:SetImage( "vgui/class_sel_sm_pyro_inactive" )
	de_img:SetImage( "vgui/class_sel_sm_demo_inactive" )
	he_img:SetImage( "vgui/class_sel_sm_heavy_inactive" )
	en_img:SetImage( "vgui/class_sel_sm_engineer_inactive" )
	me_img:SetImage( "vgui/class_sel_sm_medic_inactive" )
	if LocalPlayer():Team()==1 or LocalPlayer():Team()==5 then
		sn_img:SetImage( "vgui/class_sel_sm_sniper_red" )
	elseif LocalPlayer():Team()==TEAM_BLU then
		sn_img:SetImage( "vgui/class_sel_sm_sniper_blu" )
	else
		sn_img:SetImage( "vgui/class_sel_sm_sniper_inactive" )
	end
	sp_img:SetImage( "vgui/class_sel_sm_spy_inactive" )
	if (IsValid(GmodButton)) then
		gm_img:SetImage("vgui/class_sel_sm_random_inactive")
	end
end
SpyButton.OnCursorEntered = function() 

	if (LocalPlayer():GetInfoNum("tf_tfc_model_override",0) == 1  and file.Exists("models/player/tfc_"..(c.ModelName or "scout")..".mdl", "WORKSHOP") ) then
		icon:SetModel( "models/player/tfc_spy.mdl" ) -- you can only change colors on playermodels
	elseif (LocalPlayer():GetInfoNum("tf_robot",0) == 1) then
		icon:SetModel( "models/bots/spy/bot_spy.mdl" ) -- you can only change colors on playermodels
	else
		icon:SetModel( "models/player/spy.mdl" ) -- you can only change colors on playermodels
	end
	icon2:GetEntity():SetParent(icon:GetEntity()) 
	icon2:GetEntity():AddEffects(EF_BONEMERGE) 
	icon2:GetEntity():SetModel("models/weapons/c_models/c_knife/c_knife.mdl") 
	LocalPlayer():EmitSound( "/music/class_menu_09.wav", 100, 100, 1, CHAN_VOICE ) 
	local dance = icon:GetEntity():LookupSequence( "selectionMenu_Anim01" ) 
	icon:GetEntity():SetSequence( dance ) 
	icon:GetEntity():SetModelScale(0.865) 
	menuname:SetText( "SPY" ) 
	menutext:SetText( [[Disguise yourself as a enemy and 
infiltrate the enemy base!
cloak yourself to avoid being seen!
Backstab your enemies with 
your knife for an instant kill!
Plant sappers on enemy sentryguns 
to destroy them!]] ) 
		menuname:SizeToContents()
		menutext:SizeToContents()
	scout_img:SetImage( "vgui/class_sel_sm_scout_inactive" )
	sol_img:SetImage( "vgui/class_sel_sm_soldier_inactive" )
	py_img:SetImage( "vgui/class_sel_sm_pyro_inactive" )
	de_img:SetImage( "vgui/class_sel_sm_demo_inactive" )
	he_img:SetImage( "vgui/class_sel_sm_heavy_inactive" )
	en_img:SetImage( "vgui/class_sel_sm_engineer_inactive" )
	me_img:SetImage( "vgui/class_sel_sm_medic_inactive" )
	sn_img:SetImage( "vgui/class_sel_sm_sniper_inactive" )
	if LocalPlayer():Team()==1 or LocalPlayer():Team()==5 then
		sp_img:SetImage( "vgui/class_sel_sm_spy_red" )
	elseif LocalPlayer():Team()==TEAM_BLU then
		sp_img:SetImage( "vgui/class_sel_sm_spy_blu" )
	else
		sp_img:SetImage( "vgui/class_sel_sm_spy_inactive" )
	end
	if (IsValid(GmodButton)) then
		gm_img:SetImage("vgui/class_sel_sm_random_inactive")
	end
end
--[[
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
]]

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
--[[
local tauntlaugh = vgui.Create( "DButton", ClassFrame )
function tauntlaugh.DoClick() RunConsoleCommand( "tf_hatpainter" )  end
tauntlaugh:SetPos( 430, 107 )
tauntlaugh:SetSize( 90, 20 )
tauntlaugh:SetText( "Hat Painter" )
]]
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
		 RunConsoleCommand("changeclass", "scout")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Soldier", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass soldier" ) then
		 RunConsoleCommand("changeclass", "soldier")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Pyro", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass pyro" ) then
		 RunConsoleCommand("changeclass", "pyro")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Demoman", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass demoman" ) then
		 RunConsoleCommand("changeclass", "demoman")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Heavy", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass heavy" ) then
		 RunConsoleCommand("changeclass", "heavy")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Engineer", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass engineer" ) then
		 RunConsoleCommand("changeclass", "engineer")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Medic", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass medic" ) then
		 RunConsoleCommand("changeclass", "medic")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Sniper", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass sniper" ) then
		 RunConsoleCommand("changeclass", "sniper")
		return false
	end
end )

hook.Add( "PlayerSay", "Class Spy", function( ply, text, public )
	text = string.lower( text ) -- Make the chat message entirely lowercase
	if ( string.sub( text, 1 ) == "!changeclass spy" ) then
		 RunConsoleCommand("changeclass", "spy")
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


include("cl_hud.lua")
include("tf_lang_module.lua")
include("shd_items.lua")

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

include("cl_loadout.lua")

include("proxies/itemtintcolor.lua")
include("proxies/yellowlevel.lua")
include("proxies/modelglowcolor.lua")
include("proxies/burnlevel.lua")

include("proxies/sniperriflecharge.lua")
include("proxies/weapon_invis.lua")
include("shd_gravitygun.lua")


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
				RunConsoleCommand( "tf_taunt_directors_vision" )
			end 
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 205, 305 )
			DImageButton:SetTooltip( "Taunt: Gimmie 20" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "backpack/weapons/w_models/w_rocketlauncher_large" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_gimme20" )
			end 
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 305, 305 )
			DImageButton:SetTooltip( "Taunt: Slit Throat" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "sprites/bucket_knife" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_slit_throat" )
			end 
			local DImageButton = pnl:Add( "DImageButton" )
			DImageButton:SetPos( 405, 305 )
			DImageButton:SetTooltip( "Taunt: Come and Get Me" )
			DImageButton:SetSize( 128, 128 )
			DImageButton:SetImage( "vgui/achievements/tf_scout_first_blood" )
			DImageButton.DoClick = function()
				RunConsoleCommand( "tf_taunt_come_and_get_me" )
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

timer.Stop("ForceBosses")
timer.Create("ForceBosses",0,0,function()

	if (GetConVar("civ2_enable_be_the_bosses"):GetBool()) then
		list.Set(
			"DesktopWindows",
			"BeTheBosses",
			{
				title = "Be the Bosses",
				icon = "backpack/player/items/all_class/pumkin_hat",
				width = 1024,
				height = 768,
				onewindow = true,
				init = function(icn, pnl)
					local DImageButton = pnl:Add( "DImageButton" )
					DImageButton:SetPos( 0, 25 )
					DImageButton:SetTooltip( "Horseless Headless Horsemann" )
					DImageButton:SetSize( 128, 128 )
					DImageButton:SetImage( "backpack/player/items/all_class/pumkin_hat" )
					DImageButton.DoClick = function()
						RunConsoleCommand( "changeclass","headless_hatman" )
					end
					local DImageButton = pnl:Add( "DImageButton" )
					DImageButton:SetPos( 128, 25 )
					DImageButton:SetTooltip( "Sentry Buster" )
					DImageButton:SetSize( 128, 128 )
					DImageButton:SetImage( "hud/leaderboard_class_sentry_buster" )
					DImageButton.DoClick = function()
						RunConsoleCommand( "changeclass","sentrybuster" )
					end
					local DImageButton = pnl:Add( "DImageButton" )
					DImageButton:SetPos( 256, 25 )
					DImageButton:SetTooltip( "Giant Robot (Toggle ON)" )
					DImageButton:SetSize( 128, 128 )
					DImageButton:SetImage( "backpack/player/items/mvm_loot/soldier/robot_helmet" )
					DImageButton.DoClick = function()
						RunConsoleCommand( "tf_giant_robot","1" )
					end
					local DImageButton = pnl:Add( "DImageButton" )
					DImageButton:SetPos( 384, 25 )
					DImageButton:SetTooltip( "Giant Robot (Toggle OFF)" )
					DImageButton:SetSize( 128, 128 )
					DImageButton:SetImage( "vgui/achievements/tf_mvm_spy_sap_robots" )
					DImageButton.DoClick = function()
						RunConsoleCommand( "tf_giant_robot","0" )
					end
					local DImageButton = pnl:Add( "DImageButton" )
					DImageButton:SetPos( 512, 25 )
					DImageButton:SetTooltip( "Saxton Hale" )
					DImageButton:SetSize( 128, 128 )
					DImageButton:SetImage( "hud/class_saxtonred" )
					DImageButton.DoClick = function()
						RunConsoleCommand( "changeclass", "saxton" )
					end
					local DImageButton = pnl:Add( "DImageButton" )
					DImageButton:SetPos( 0, 128 )
					DImageButton:SetTooltip( "Telecon" )
					DImageButton:SetSize( 128, 128 )
					DImageButton:SetImage( "hud/class_teleconred" )
					DImageButton.DoClick = function()
						RunConsoleCommand( "changeclass", "telecon" )
					end
					local DImageButton = pnl:Add( "DImageButton" )
					DImageButton:SetPos( 128, 128 )
					DImageButton:SetTooltip( "Mercenary" )
					DImageButton:SetSize( 128, 128 )
					DImageButton:SetImage( "hud/class_mercenaryred" )
					DImageButton.DoClick = function()
						RunConsoleCommand( "changeclass", "mercenary" )
					end
					local DImageButton = pnl:Add( "DImageButton" )
					DImageButton:SetPos( 256, 128 )
					DImageButton:SetTooltip( "Enforcer" )
					DImageButton:SetSize( 128, 128 )
					DImageButton:SetImage( "hud/class_zombiefastred" )
					DImageButton.DoClick = function()
						RunConsoleCommand( "changeclass", "zombine" )
					end
					local DImageButton = pnl:Add( "DImageButton" )
					DImageButton:SetPos( 384, 128 )
					DImageButton:SetTooltip( "John" )
					DImageButton:SetSize( 128, 128 )
					DImageButton:SetImage( "hud/class_rebelred" )
					DImageButton.DoClick = function()
						RunConsoleCommand( "changeclass", "rebel" )
					end
					local DImageButton = pnl:Add( "DImageButton" )
					DImageButton:SetPos( 512, 128 )
					DImageButton:SetTooltip( "Jerry" )
					DImageButton:SetSize( 128, 128 )
					DImageButton:SetImage( "hud/class_antlionred" )
					DImageButton.DoClick = function()
						RunConsoleCommand( "changeclass", "antlion" )
					end
					local DImageButton = pnl:Add( "DImageButton" )
					DImageButton:SetPos( 0, 256 )
					DImageButton:SetTooltip( "Merasmus" )
					DImageButton:SetSize( 128, 128 )
					DImageButton:SetImage( "backpack/player/items/all_class/merasmus_skull" )
					DImageButton.DoClick = function()
						RunConsoleCommand( "changeclass", "merasmus" )
					end
					local DImageButton = pnl:Add( "DImageButton" )
					DImageButton:SetPos( 128, 256 )
					DImageButton:SetTooltip( "Repressor" )
					DImageButton:SetSize( 128, 128 )
					DImageButton:SetImage( "hud/class_combinered" )
					DImageButton.DoClick = function()
						RunConsoleCommand( "changeclass", "combinesoldier" )
					end
					local DImageButton = pnl:Add( "DImageButton" )
					DImageButton:SetPos( 256, 256 )
					DImageButton:SetTooltip( "Civilian" )
					DImageButton:SetSize( 128, 128 )
					DImageButton:SetImage( "hud/class_civred" )
					DImageButton.DoClick = function()
						RunConsoleCommand( "changeclass", "civilian_" )
					end
				end
			}
		)
	end
	
end)
include("cl_hud.lua")

file.Append(LOGFILE, Format("Done loading, time = %f\n", SysTime() - load_time))	