local W = ScrW()
local H = ScrH()
local Scale = H/480


--local tbl = LocalPlayer():GetPlayerClassTable()

local PANEL = {}

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true) 
end

function PANEL:PerformLayout() 
	self:SetPos(0+102,(480-120)*Scale)
	self:SetSize(250*Scale,120*Scale) 
end

function PANEL:Paint()
	if not LocalPlayer():Alive() or LocalPlayer():IsHL2() or GetConVar("tf_forcehl2hud"):GetBool() or GAMEMODE.ShowScoreboard or GetConVarNumber("cl_drawhud")==0 or LocalPlayer():Team() == TEAM_SPECTATOR or LocalPlayer():GetPlayerClass()=="" then return end
	
	local size, amplitude, frequency
	local health_bg, health_color, health_over_bg
	local health = LocalPlayer():Armor()
	if LocalPlayer():GetObserverTarget() and LocalPlayer():GetObserverTarget():IsPlayer() then
		health = LocalPlayer():GetObserverTarget():Armor()
	end
	
	if (LocalPlayer():GetMaxArmor() > 100) then
		health_bg = surface.GetTextureID("hud/armor_heavy_bg")
		health_color = surface.GetTextureID("hud/armor_heavy_red")
		health_over_bg = surface.GetTextureID("hud/armor_heavy_bg")
	elseif (LocalPlayer():GetMaxArmor() > 51 and LocalPlayer():GetMaxArmor() < 100) then
		health_bg = surface.GetTextureID("hud/armor_medium_bg")
		health_color = surface.GetTextureID("hud/armor_medium_red")
		health_over_bg = surface.GetTextureID("hud/armor_medium_bg")
	else
		health_bg = surface.GetTextureID("hud/armor_light_bg")
		health_color = surface.GetTextureID("hud/armor_light_red")
		health_over_bg = surface.GetTextureID("hud/armor_light_bg")
	end
	--[[local tbl = LocalPlayer():GetPlayerClassTable()
	local maxhealth = 100
	
	if tbl and tbl.Health then
		maxhealth = tbl.Health
	end
	
	maxhealth = maxhealth + LocalPlayer():GetNWInt("PlayerMaxHealthBuff")]]
	local maxhealth = LocalPlayer():GetMaxArmor()
	
	local ratio = math.Clamp(health/maxhealth,0,1)
	
	if 2*health<maxhealth then -- Low health warning
		size = (health-maxhealth)/maxhealth
		frequency = 20
		amplitude = math.Clamp(size*127, 0, 127)
		
		surface.SetTexture(health_over_bg)
		surface.SetDrawColor(255,0,0,128+amplitude*math.sin(frequency*CurTime()))
		surface.DrawTexturedRect((73-size*27.5)*Scale, (33-size*27.5)*Scale, (1+size)*55*Scale, (1+size)*55*Scale)
	elseif health>maxhealth then -- Overheal
		size = (health-maxhealth)/maxhealth
		frequency = 20
		amplitude = math.Clamp(size*127, 0, 127)
		
		surface.SetTexture(health_over_bg)
		surface.SetDrawColor(255,255,255,128+amplitude*math.sin(frequency*CurTime()))
		surface.DrawTexturedRect((73-size*27.5)*Scale, (33-size*27.5)*Scale, (1+size)*55*Scale, (1+size)*55*Scale)
	end
	
	surface.SetTexture(health_bg)
	surface.SetDrawColor(53,51,48,255)
	surface.DrawTexturedRect(73*Scale, 33*Scale, 55*Scale, 55*Scale)
	
	local x,y,w,h = math.floor(75*Scale), math.floor(35*Scale), math.floor(51*Scale), math.floor(51*Scale)
	surface.SetTexture(health_color)
	
	if 2*health<maxhealth then
		surface.SetDrawColor(255,0,0,255)
	else
		surface.SetDrawColor(255,255,255,255)
	end
	
	local y2 = y+h*(1-ratio)
	
	tf_draw.TexturedQuadPart(health_color, x, y2, w, (y+h)-y2, 0, 128*(1-ratio), 128, 128*ratio)
	
	--[[
	render.SetViewPort(x0+x,y0+y2,w,(y+h)-y2)
	cam.Start2D()
		surface.DrawTexturedRect(0,y-y2,w,h)
	cam.End2D()
	render.SetViewPort(0,0,W,H)]]
	
	draw.Text{
		text=health,
		font="ScoreboardMediumSmall",
		pos={(76+25)*Scale, (52+9)*Scale},
		color=Colors.White,
		xalign=TEXT_ALIGN_CENTER,
		yalign=TEXT_ALIGN_CENTER,
	}

	local droplet_x = 104*Scale
end

if HudPlayerArmor then HudPlayerArmor:Remove() end
HudPlayerArmor = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
