

function IsCustomHUDVisible(name)
	for _,v in pairs(LocalPlayer():GetTFItems()) do
		local gch = v.GlobalCustomHUD
		local ch = v.CustomHUD
		
		if gch and gch[name] then
			gch = gch[name]
			if type(gch)=="function" then gch = gch(v) end
		else
			gch = nil
		end
		
		if ch and ch[name] then
			ch = ch[name]
			if type(ch)=="function" then ch = ch(v) end
		else
			ch = nil
		end
		
		if gch or (v==LocalPlayer():GetActiveWeapon() and ch) then
			return true
		end
	end
	
	return false
end

local VGUIFiles = {
	"vgui_circularprogressbar";
	"vgui_spectatorhealth";
	"vgui_tfbutton";
	"vgui_itemmodelpanel";
	"vgui_classmodelpanel";
	"vgui_itemattributepanel";
	"vgui_buildinghealth";
	--"vgui_teammenubg";

	"hud_sniperchargemeter";
	
	"hud_obj_base";
	"hud_obj_sentrygun";
	"hud_obj_dispenser";
	"hud_obj_tele_entrance";
	"hud_obj_tele_exit";
	
	"hud_buildingstatus";
	
	"hud_playerclass";
	"hud_playerhealth";
	"hud_ammoweapons";
	"hud_bowcharge";
	"hud_itemeffectmeter";
	"hud_itemeffectmeter_demoman";
	
	"hud_weaponselection";
	"hud_inspectpanel";
	"hud_objectiveflagpanel";
	"hud_objectiveflagpanel_blue";
	"hud_objectivebombpanel";
	
	"hud_demomanpipes";
	"hud_mediccharge";
	
	"hud_healthaccount";
	"hud_accountpanel";
	
	"hud_targetid";
	"hud_freezepanel";
	
	"hud_cptest";
	"hud_roundtimer";
	"hud_menuengybuild";
	"hud_menuengydestroy";
	"hud_voicemenu";
	
	"menu_charinfopanel";
	"menu_charinfoloadoutsubpanel";
	"menu_fullloadoutpanel";
	
	"scoreboard_playerlist"; 
	"mvmbotlist";
	"scoreboard_localstats";
	"scoreboard_main";
}

function LoadVGUI()
	local path
	if GM then
		path = "vgui/%s.lua"
	else
		path = string.gsub(GAMEMODE.Folder, "gamemodes/", "").."/gamemode/vgui/%s.lua"
		GAMEMODE:DestroyScoreboard()
	end
	
	for _,v in ipairs(VGUIFiles) do
		include(Format(path, v))
	end
end

concommand.Add("reload_vgui", function()
	LoadVGUI()
end)

LoadVGUI()
include("cl_crosshairs.lua")
include("cl_scoreboard.lua")
include("cl_chatprefix.lua")
 
local W = ScrW()
local H = ScrH()
local WScale = ScrW()/640
local Scale = ScrH()/480

if T then T:Remove() end
--[[
T = vgui.Create("ItemAttributePanel")
T:SetPos(50,50)
T:SetSize(168*Scale,300*Scale)
T.text_ypos = 20
T.text = "THE CRAB-WALKING KIT"
T.attributes = {
{"Level 0 Cigarette Case", 1},
{"It will change your skeleton!", 2},
{"Excrutiatingly painful . . .", 4},
{". . . but worth it", 3},
}
T:SetQuality("rarity3")]]

local hud_targetid_anyteam = CreateConVar("hud_targetid_anyteam", "0", {FCVAR_CHEAT})
local hud_defaultweaponselect = CreateConVar("hud_defaultweaponselect", "0")
local hl2hudtf = CreateConVar("tf_forcehl2hud", "0")

local HiddenHudElements = {
	CHudDamageIndicator = 1,
	CHudHealth = 1,
	--CHudBattery = 1,
	CHudAmmo = 1,
	CHudSecondaryAmmo = 1,
	CHudCrosshair = 1,
	CHudSuitPower = 1,
	CHudSquadStatus = 1,
	CHudPoisonDamageIndicator = 1,
	CHudHistoryResource = 1,
}
function GM:HideHUDElement(e)
	HiddenHudElements[e] = 1
end

function GM:ShowHUDElement(e)
	HiddenHudElements[e] = nil
end

function GM:HUDAmmoPickedUp(item, amount) end
function GM:HUDItemPickedUp(item, amount) end

function GM:HUDWeaponPickedUp(wep)
	HudWeaponSelection:UpdateLoadout()
end

net.Receive("UpdateLoadout", function()
	HudWeaponSelection:UpdateLoadout()
	--print("kk")
end)

-- Weapon selection

function GM:InitWeaponSelection(class)
	local tbl = GAMEMODE.PlayerClasses[class]
	
	if tbl and not tbl.IsHL2 then
		--HudWeaponSelection:SetLoadout(tbl.Loadout)
		HudWeaponSelection:UpdateLoadout()
	end
end

-- Using concommands to make sure weapon selection is done properly in demos

concommand.Add("tf_selectslot", function(pl, cmd, args)
	GAMEMODE:ShowWeaponSelection()
	pl:EmitSound("Player.WeaponSelectionMoveSlot")
	HudWeaponSelection:Select(tonumber(args[1]))
end)

concommand.Add("tf_useweapon", function(pl, cmd, args)
	GAMEMODE:HideWeaponSelection()
	RunConsoleCommand("use", args[1])
end)

function GM:PlayerSlotSelected(slot)
	
end

function GM:PlayerBindPress(pl, cmd, down)
	if ( string.find( cmd, "gmod_undo" ) ) then return true end 
	if pl:IsHL2() or hud_defaultweaponselect:GetBool() or hl2hudtf:GetBool() or GetConVar("hud_fastswitch"):GetBool() then return end
	if not down then return end
	
	local n = tonumber(string.match(cmd, "slot(%d+)"))
	if n then
		if not pl:Alive() then return true end
		
		if not HudWeaponSelection.NumSlots then
			self:InitWeaponSelection(pl:GetPlayerClass())
		end
		
		local r = gamemode.Call("PlayerSlotSelected", n)
		
		if not r and HudWeaponSelection:CanSelectSlot(n) then
			if LocalPlayer().ShouldUpdateWeaponSelection then
				HudWeaponSelection:UpdateLoadout()
				LocalPlayer().ShouldUpdateWeaponSelection = false
			end
			
			RunConsoleCommand("tf_selectslot", n)
		end
		
		return true
	end
	
	if string.find(cmd, "^invnext") then
		if not pl:Alive() then return true end
		
		if not HudWeaponSelection.NumSlots then
			self:InitWeaponSelection(pl:GetPlayerClass())
		end
		
		if LocalPlayer().ShouldUpdateWeaponSelection then
			HudWeaponSelection:UpdateLoadout()
			LocalPlayer().ShouldUpdateWeaponSelection = false
		end
		
		local n
		if HudWeaponSelection:IsVisible() then	n = HudWeaponSelection.CurrentSlot
		else									n = self:GetCurrentWeaponSlot() or 0
		end
		
		n = HudWeaponSelection:GetNextSlot(n)
		RunConsoleCommand("tf_selectslot", n)
		return true
	elseif string.find(cmd, "^invprev") then
		if not pl:Alive() then return true end
		
		if not HudWeaponSelection.NumSlots then
			self:InitWeaponSelection(pl:GetPlayerClass())
		end
		
		if LocalPlayer().ShouldUpdateWeaponSelection then
			HudWeaponSelection:UpdateLoadout()
			LocalPlayer().ShouldUpdateWeaponSelection = false
		end
		
		local n
		if HudWeaponSelection:IsVisible() then	n = HudWeaponSelection.CurrentSlot
		else									n = self:GetCurrentWeaponSlot() or 2
		end
		
		n = HudWeaponSelection:GetPreviousSlot(n)
		RunConsoleCommand("tf_selectslot", n)
		return true
	elseif HudWeaponSelection:IsVisible() and string.find(cmd, "^+attack") then
		if not pl:Alive() then return true end
		
		if HudWeaponSelection:CanSelectWeapon() then
			RunConsoleCommand("tf_useweapon", HudWeaponSelection:CurrentWeapon())
		end
		return true
	end
end

function GM:GetCurrentWeaponSlot()
	return HudWeaponSelection:CalcCurrentWeaponSlot()
end

function GM:ShowWeaponSelection()
	if not HudWeaponSelection:IsVisible() then
		HudWeaponSelection:SetVisible(true)
	end
	HudWeaponSelection.NextHide = CurTime() + 2
end

function GM:HideWeaponSelection()
	if HudWeaponSelection:IsVisible() then
		HudWeaponSelection:SetVisible(false)
	end
	HudWeaponSelection.NextHide = nil
end

function GM:WeaponSelectionThink()
	if HudWeaponSelection.NextHide and CurTime()>HudWeaponSelection.NextHide then
		self:HideWeaponSelection()
	end
end

-- Using a custom TargetID system

function GM:HUDDrawTargetID()
	if (LocalPlayer():IsHL2()) then
		
		local tr = util.GetPlayerTrace( LocalPlayer() )
		local trace = util.TraceLine( tr )
		if ( !trace.Hit ) then return end
		if ( !trace.HitNonWorld ) then return end
		
		local text = "ERROR"
		local font = "TargetID"
		
		if ( trace.Entity:IsTFPlayer() ) then
			text = GAMEMODE:EntityTargetIDName(trace.Entity)
		else
			return
			--text = trace.Entity:GetClass()
		end
		
		surface.SetFont( font )
		local w, h = surface.GetTextSize( text )
		
		local MouseX, MouseY = gui.MousePos()
		
		if ( MouseX == 0 && MouseY == 0 ) then
		
			MouseX = ScrW() / 2
			MouseY = ScrH() / 2
		
		end
		
		local x = MouseX
		local y = MouseY
		
		x = x - w / 2
		y = y + 30
		
		-- The fonts internal drop shadow looks lousy with AA on
		draw.SimpleText( text, font, x + 1, y + 1, Color( 0, 0, 0, 120 ) )
		draw.SimpleText( text, font, x + 2, y + 2, Color( 0, 0, 0, 50 ) )
		draw.SimpleText( text, font, x, y, team.GetColor( GAMEMODE:EntityTeam(trace.Entity) ) )
		
		y = y + h + 5
		
		local text = trace.Entity:Health() .. "%"
		local font = "TargetIDSmall"
		
		surface.SetFont( font )
		local w, h = surface.GetTextSize( text )
		local x = MouseX - w / 2
		
		draw.SimpleText( text, font, x + 1, y + 1, Color( 0, 0, 0, 120 ) )
		draw.SimpleText( text, font, x + 2, y + 2, Color( 0, 0, 0, 50 ) )
		draw.SimpleText( text, font, x, y, team.GetColor( GAMEMODE:EntityTeam(trace.Entity) ) )

	else
    	return false
	end
end

local function targetid_trace_condition(tr,ply)
	ply = ply or LocalPlayer()
	return !ply:IsHL2() and IsValid(tr.Entity) and (tr.Entity:IsTFPlayer() ) and (GAMEMODE:EntityTeam(tr.Entity)==LocalPlayer():Team()) and tr.Entity:GetMaterial() != "color" and tr.Entity:GetMaterial() != "models/shadertest/shader3" and tr.Entity:GetMaterial() != "models/props_combine/tprings_globe"
end

function GM:TargetIDThink()
	local ply = LocalPlayer()

	if LocalPlayer():GetObserverTarget() and LocalPlayer():GetObserverTarget():IsPlayer() then
		ply = LocalPlayer():GetObserverTarget()
	end

	if not ply:Alive() then
		return
	end
	
	--local ent = ply:GetEyeTrace().Entity
	
	local start = ply:GetShootPos()
	local endpos = start + ply:GetAimVector() * 10000
	
	local tr = tf_util.MixedTrace({
		start = start,
		endpos = endpos,
		filter = ply,
		mins = Vector(-5, -5, -5),
		maxs = Vector(5, 5, 5),
	}, targetid_trace_condition)
	
	if targetid_trace_condition(tr, ply) then
		HudTargetID:SetTargetEntity(tr.Entity)
		HudTargetID:SetVisible(true)
	else
		HudTargetID:SetVisible(false)
	end
end

function GM:HUDShouldDraw(n)
	if IsValid(LocalPlayer()) and (LocalPlayer():IsHL2() or hl2hudtf:GetBool()) then
		return self.BaseClass:HUDShouldDraw(n)
	end
	
	if HiddenHudElements[n] then return false end
	return true
end

function GM:HUDPaint()
	self.BaseClass:HUDPaint()
	if LocalPlayer():Alive() and not LocalPlayer():IsHL2() and not hl2hudtf:GetBool() then
		self:DrawDamageNotifiers()
		self:DrawDamageIndicators()
		self:DrawCrosshair()
	end
end

function GM:Think()
	self.BaseClass:Think()
	self:TargetIDThink()
	self:WeaponSelectionThink()
	
	hook.Add( "PreDrawHalos", "AddWeaponHalos", function()
		if (LocalPlayer():GetNWBool("SpawnGlows",false) == true) then
			if (LocalPlayer():Team() == TEAM_RED) then 
				halo.Add( team.GetPlayers(TEAM_RED), Color(0.74 * 255, 0.23 * 255, 0.23 * 255), 0, 0, 2, true, true )
			elseif (LocalPlayer():Team() == TEAM_BLU) then 
				halo.Add( team.GetPlayers(TEAM_BLU), Color(0.49 * 255, 0.66 * 255, 0.77 * 255), 0, 0, 2, true, true )
			else
				halo.Add( team.GetPlayers(TEAM_RED), Color(0.74 * 255, 0.23 * 255, 0.23 * 255), 0, 0, 2, true, true )
				halo.Add( team.GetPlayers(TEAM_BLU), Color(0.49 * 255, 0.66 * 255, 0.77 * 255), 0, 0, 2, true, true )
			end
		end
	end)
end


DamageIndicators = {}
--local indicator_radius = CreateClientConVar("hud_dmgindicator_radius", 0.3)
--local indicator_duration = CreateClientConVar("hud_dmgindicator_duration", 1)
local indicator_tex = surface.GetTextureID("vgui/damageindicator")

local W = ScrW()
local H = ScrH()
local WScale = ScrW()/640
local Scale = ScrH()/480

BaseScaleX = 16
BaseScaleY = 16
MaxScale = 6
MaxDamage = 150 

function GM:DrawDamageIndicators()
	--local radius = ScrH() * indicator_radius:GetFloat()
	local radius = ScrH() * 0.3
	--local duration = indicator_duration:GetFloat()
	local duration = 1
	local cx, cy = ScrW()/2, ScrH()/2
	
	surface.SetTexture(indicator_tex)
	
	-- Iterating backwards, so we can remove items without fucking everything up
	for i=#DamageIndicators,1,-1 do
		local ind = DamageIndicators[i]
		
		local v = ind[1]
		local ang = v:Angle()
		ang.p = 0
		ang.y = ang.y - LocalPlayer():EyeAngles().y
		
		v = ang:Forward()
		
		local alpha = 255
		local dt = CurTime() - ind[3]
		if dt>duration then
			dt = dt - duration
			alpha = math.Clamp(255-100*dt, 0, 255)
		end
		
		local mul = 1 + MaxScale * math.Clamp(ind[2]/MaxDamage,0,1)
		local scalex = BaseScaleX * Scale * mul
		local scaley = BaseScaleY * Scale * mul
		
		surface.SetDrawColor(255,255,255,alpha)
		--surface.DrawRect(cx-radius*v.y-2, cy-radius*v.x-2, 4, 4)
		surface.DrawTexturedRectRotated(cx-radius*v.y, cy-radius*v.x, scalex, scaley, ang.y)
		
		if alpha<=0 then
			table.remove(DamageIndicators, i)
		end
	end
end

usermessage.Hook("PushDamageIndicator", function(um)
	local last = DamageIndicators[1]
	if last and CurTime() - last[3]<0.02 then
		-- For damage received from several sources at the same time
		last[0] = (last[0] or 1) + 1
		last[1] = (last[1] + um:ReadVector()) / last[0]
		last[2] = last[2] + um:ReadFloat()
	else
		table.insert(DamageIndicators, 1, {um:ReadVector(), um:ReadFloat(), CurTime()})
	end
end)



DamageNotifiers = {}
local notifier_enabled = CreateClientConVar("hud_showdamagenotifier", 0)

function GM:DrawDamageNotifiers()
	-- Iterating backwards, so we can remove items without fucking everything up
	for i=#DamageNotifiers,1,-1 do
		local ind = DamageNotifiers[i]
		
		local v = ind[1]:ToScreen()
		
		local diff = CurTime() - ind[4]
		local r = math.Clamp(diff / 1.5, 0, 1)
		
		if v.visible then
			local alpha = Lerp(r, 255, 0)
			v.y = Lerp(r, v.y, v.y - 48 * Scale)
			
			draw.Text{
				text = "-"..math.floor(ind[2]),
				pos = {v.x, v.y},
				font = "HudFontMediumSmall",
				xalign = TEXT_ALIGN_CENTER,
				yalign = TEXT_ALIGN_CENTER,
				color = Color(255, 0, 0, alpha),
			}
		end
		
		if r>=1 then
			table.remove(DamageNotifiers, i)
		end
	end
end

usermessage.Hook("PushDamageNotifier", function(um)
	local clock = um:ReadFloat()
	local pos = um:ReadVector()
	local dmg = um:ReadFloat()
	
	for _,v in ipairs(DamageNotifiers) do
		if	math.abs(v[3]-clock)<0.02 and
			math.abs(v[1].x - pos.x)<0.2 and
			math.abs(v[1].y - pos.y)<0.2 and
			math.abs(v[1].z - pos.z)<0.2 then
			v[2] = v[2] + dmg
			return
		end
	end
	
	if pos:Distance(EyePos()) < 80 then return end
	
	table.insert(DamageNotifiers, 1, {pos, dmg, clock, CurTime()})
end)
