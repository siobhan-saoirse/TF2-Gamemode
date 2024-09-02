local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

CreateConVar("hud_show_ctf_as_hl2", "1", {FCVAR_ARCHIVE}, "Show CTF hud as GMod Player")

local objectives_flagpanel_bg_left = surface.GetTextureID("hud/objectives_flagpanel_bg_left")
local objectives_flagpanel_bg_right = surface.GetTextureID("hud/objectives_flagpanel_bg_right")
local objectives_flagpanel_bg_outline = surface.GetTextureID("hud/objectives_flagpanel_bg_outline")
local objectives_flagpanel_carried_outline = surface.GetTextureID("hud/objectives_flagpanel_carried_outline")
local objectives_flagpanel_carried_red = surface.GetTextureID("hud/objectives_flagpanel_carried_red")
local objectives_flagpanel_carried_blue = surface.GetTextureID("hud/objectives_flagpanel_carried_blue")
local objectives_flagpanel_bg_playingto = surface.GetTextureID("hud/objectives_flagpanel_bg_playingto")
local objectives_flagpanel_bg_mvm_bombcompass = surface.GetTextureID("hud/objectives_flagpanel_compass_grey")
local objectives_flagpanel_bg_mvm_bombdropped = surface.GetTextureID("hud/bomb_dropped")
local objectives_flagpanel_bg_mvm_bombcarried = surface.GetTextureID("hud/bomb_carried")

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true)
end 

function PANEL:PerformLayout()
	self:SetPos(0,0)
	self:SetSize(W,H)
end

function PANEL:Paint()
	local param
	
	if not LocalPlayer():Alive() or (LocalPlayer():IsHL2() and !GetConVar("hud_show_ctf_as_hl2"):GetBool()) or GetConVar("tf_forcehl2hud"):GetBool() or GetConVarNumber("cl_drawhud")==0 or GAMEMODE.ShowScoreboard or !string.find(game.GetMap(), "ctf_") then return end
	
	surface.SetDrawColor(255,255,255,255)
	
	surface.SetTexture(objectives_flagpanel_bg_left)
	surface.DrawTexturedRect(320*WScale-140*Scale, (480-75)*Scale, 280*Scale, 80*Scale)
	
	surface.SetTexture(objectives_flagpanel_bg_right)
	surface.DrawTexturedRect(320*WScale-140*Scale, (480-75)*Scale, 280*Scale, 80*Scale)
	
	surface.SetTexture(objectives_flagpanel_bg_outline)
	surface.DrawTexturedRect(320*WScale-140*Scale, (480-75)*Scale, 280*Scale, 80*Scale)
	
	surface.SetTexture(objectives_flagpanel_bg_playingto)
	surface.DrawTexturedRect(320*WScale-75*Scale, (480-31)*Scale, 150*Scale, 38*Scale)
	
	-- Blue score
	param = {
		text=team.GetScore(TEAM_BLU),
		font="HudFontBig",
		pos={320*WScale-128*Scale, (480-46+17.5)*Scale},
		color=Colors.Black,
		xalign=TEXT_ALIGN_LEFT,
		yalign=TEXT_ALIGN_CENTER,
	}
	draw.Text(param)
	param.pos[1] = param.pos[1]-2*WScale
	param.pos[2] = param.pos[2]-Scale
	param.color=Colors.TanLight
	draw.Text(param)
	
	-- Red score
	param = {
		text=team.GetScore(TEAM_RED),
		font="HudFontBig",
		pos={320*WScale+132*Scale, (480-46+17.5)*Scale},
		color=Colors.Black,
		xalign=TEXT_ALIGN_RIGHT,
		yalign=TEXT_ALIGN_CENTER,
	}
	
	draw.Text(param)
	param.pos[1] = param.pos[1]-2*WScale
	param.pos[2] = param.pos[2]-Scale
	param.color=Colors.TanLight
	draw.Text(param)
	
	-- Playing to :
	param = {
		text="Playing to: ∞",
		font="HudFontSmall",
		pos={320*WScale, (480-28+15)*Scale},
		color=Colors.TanLight,
		xalign=TEXT_ALIGN_CENTER,
		yalign=TEXT_ALIGN_CENTER,
	}
	
	draw.Text(param)
	local v
	for _,flag in pairs(ents.FindByClass("item_teamflag")) do
		if (flag:GetNWInt("FlagTeamNum",0) == TEAM_RED) then
			v = flag
		end
	end
	if (IsValid(v)) then
		local vecFlag = v:WorldSpaceCenter() - LocalPlayer():GetPos()
		vecFlag.z = 0
		vecFlag:Normalize()
		local forward = LocalPlayer():EyeAngles():Forward()
		local right = LocalPlayer():EyeAngles():Right()
		forward.z = 0
		right.z = 0
		forward:Normalize()
		right:Normalize()
		local dot = vecFlag:Dot( forward )
		local angleBetween = math.acos( dot )

		dot = vecFlag:Dot( right )

		if ( dot < 0.0 ) then
			angleBetween = angleBetween * -1
		end 
		
		local flRetVal = math.deg( angleBetween )
		surface.SetTexture(surface.GetTextureID("hud/objectives_flagpanel_compass_red"))
		surface.DrawTexturedRectRotated((340*WScale-30*Scale) + 130, (480-85)*Scale, 104*Scale, 104*Scale, flRetVal or 0)
		surface.SetTexture(surface.GetTextureID("hud/objectives_flagpanel_briefcase"))
		surface.DrawTexturedRect((340*WScale-50*Scale) + 130, (480-105)*Scale, 42*Scale, 42*Scale)
	end
end

if HudObjectiveFlagPanel then HudObjectiveFlagPanel:Remove() end
HudObjectiveFlagPanel = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))