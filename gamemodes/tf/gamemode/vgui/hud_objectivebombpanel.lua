local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

CreateConVar("hud_show_mvm_as_hl2", "1", {FCVAR_ARCHIVE}, "Show MVM hud as GMod Player")

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
	
	if not LocalPlayer():Alive() or (LocalPlayer():IsHL2() and !GetConVar("hud_show_ctf_as_hl2"):GetBool()) or GetConVar("tf_forcehl2hud"):GetBool() or GetConVarNumber("cl_drawhud")==0 or GAMEMODE.ShowScoreboard or !string.find(game.GetMap(), "mvm_") then return end
	
	surface.SetDrawColor(255,255,255,255)
	
	surface.SetTexture(objectives_flagpanel_bg_left)
	surface.DrawTexturedRect(320*WScale-140*Scale, (480-75)*Scale, 280*Scale, 80*Scale)
	
	surface.SetTexture(objectives_flagpanel_bg_right)
	surface.DrawTexturedRect(320*WScale-140*Scale, (480-75)*Scale, 280*Scale, 80*Scale)
	
	surface.SetTexture(objectives_flagpanel_bg_outline)
	surface.DrawTexturedRect(320*WScale-140*Scale, (480-75)*Scale, 280*Scale, 80*Scale)
	
	surface.SetTexture(objectives_flagpanel_bg_playingto)
	surface.DrawTexturedRect(320*WScale-75*Scale, (480-31)*Scale, 150*Scale, 38*Scale)
	
	surface.SetTexture(objectives_flagpanel_bg_mvm_bombcompass)
	surface.DrawTexturedRect(340*WScale-75*Scale, (485-120)*Scale, 104*Scale, 104*Scale)

	
	for k,v in pairs(ents.FindByClass("item_teamflag_mvm")) do
		if v.Carrier then
			surface.SetTexture(objectives_flagpanel_bg_mvm_bombcarried)
			surface.DrawTexturedRect(340*WScale-50*Scale, (480-89)*Scale, 52*Scale, 52*Scale)
		else
			surface.SetTexture(objectives_flagpanel_bg_mvm_bombdropped)
			surface.DrawTexturedRect(340*WScale-50*Scale, (480-89)*Scale, 52*Scale, 52*Scale)
		end
	end
				
	
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
		text="Playing to: 1",
		font="HudFontSmall",
		pos={320*WScale, (480-28+15)*Scale},
		color=Colors.TanLight,
		xalign=TEXT_ALIGN_CENTER,
		yalign=TEXT_ALIGN_CENTER,
	}
	
	draw.Text(param)
end

if HudObjectiveBombPanel then HudObjectiveBombPanel:Remove() end
HudObjectiveBombPanel = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
