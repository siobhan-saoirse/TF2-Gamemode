local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

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
	local v
	for _,flag in pairs(ents.FindByClass("item_teamflag")) do
		if (flag:GetNWInt("FlagTeamNum",0) == TEAM_BLU) then
			v = flag
		end
	end
	
	if (IsValid(v)) then
		local vecFlag = v:WorldSpaceCenter() - LocalPlayer():GetPos()
		vecFlag.z = 0
		vecFlag:Normalize()
		local forward = LocalPlayer():GetForward()
		local right = LocalPlayer():GetRight()
		forward.z = 0
		right.z = 0
		forward:Normalize()
		right:Normalize()
		local dot = vecFlag:DotProduct( forward )
		local angleBetween = math.acos( dot )

		dot = vecFlag:DotProduct( right )

		if ( dot < 0.0 ) then
			angleBetween = angleBetween * -1
		end
		
		local flRetVal = math.deg( angleBetween )
		surface.SetTexture(surface.GetTextureID("hud/objectives_flagpanel_compass_blue"))
		surface.DrawTexturedRectRotated((340*WScale-30*Scale) - 120, (480-85)*Scale, 104*Scale, 104*Scale, flRetVal or 0)
		surface.SetTexture(surface.GetTextureID("hud/objectives_flagpanel_briefcase"))
		surface.DrawTexturedRect((340*WScale-50*Scale) - 120, (480-105)*Scale, 42*Scale, 42*Scale)
	end

end

if HudObjectiveFlagPanelBlue then HudObjectiveFlagPanelBlue:Remove() end
HudObjectiveFlagPanelBlue = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))