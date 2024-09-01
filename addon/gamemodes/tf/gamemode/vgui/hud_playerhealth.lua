local W = ScrW()
local H = ScrH()
local Scale = H/480

local health_bg = surface.GetTextureID("hud/health_bg")
local health_color = surface.GetTextureID("hud/health_color")
local health_over_bg = surface.GetTextureID("hud/health_over_bg")
local health_dead = surface.GetTextureID("hud/health_dead")
local bleed_drop = surface.GetTextureID("vgui/bleed_drop")
local marked_for_death = surface.GetTextureID("vgui/marked_for_death")
local slowed = surface.GetTextureID("vgui/slowed")

local PANEL = {}

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true)
end

function PANEL:PerformLayout()
	self:SetPos(0,(480-120)*Scale)
	self:SetSize(250*Scale,120*Scale)
end

function PANEL:Paint()
	if not LocalPlayer():Alive() or LocalPlayer():IsHL2() or GetConVar("tf_forcehl2hud"):GetBool() or GAMEMODE.ShowScoreboard or GetConVarNumber("cl_drawhud")==0 or LocalPlayer():Team() == TEAM_SPECTATOR or LocalPlayer():GetPlayerClass()=="" then return end
	
	local size, amplitude, frequency
	local health = LocalPlayer():Health()

	if LocalPlayer():GetObserverTarget() and LocalPlayer():GetObserverTarget():IsPlayer() then
		health = LocalPlayer():GetObserverTarget():Health()
	end
	
	if health<=0 then
		surface.SetTexture(health_dead)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect(73*Scale, 33*Scale, 55*Scale, 55*Scale)
		return
	end
	
	--[[local tbl = LocalPlayer():GetPlayerClassTable()
	local maxhealth = 100
	
	if tbl and tbl.Health then
		maxhealth = tbl.Health
	end
	
	maxhealth = maxhealth + LocalPlayer():GetNWInt("PlayerMaxHealthBuff")]]
	local maxhealth = LocalPlayer():GetMaxHealth()
	
	local ratio = math.Clamp(health/maxhealth,0,1)
	
	--local tbl = LocalPlayer():GetPlayerClassTable()
	
	if 2*health<maxhealth then -- Low health warning
		size = (maxhealth - 2*health)/maxhealth
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
	surface.SetDrawColor(255,255,255,255)
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
		font="HudClassHealth",
		pos={(76+25)*Scale, (52+9)*Scale},
		color=Colors.TanDark,
		xalign=TEXT_ALIGN_CENTER,
		yalign=TEXT_ALIGN_CENTER,
	}
	if health and maxhealth then
	----print(health-maxhealth)
		if health <= maxhealth and health ~= maxhealth and GetConVar("tf_maxhealth_hud"):GetInt() ~= 0 then
		--	--print(health-maxhealth+5)
		--	--print(health)
		--	--print(maxhealth)
			draw.Text{
				text=maxhealth,
				font="HudClassHealthMax",
				pos={(75+26)*Scale, (20+9)*Scale},
				color=Colors.TanDark,
				xalign=TEXT_ALIGN_CENTER,
				yalign=TEXT_ALIGN_CENTER,
			}
		end
	end

	local droplet_x = 73*Scale
	
	if LocalPlayer():HasPlayerState(PLAYERSTATE_MARKED) then
		surface.SetTexture(marked_for_death)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect((75+26)*Scale, (20+7)*Scale, 32*Scale, 32*Scale)
		droplet_x = droplet_x + 30 * Scale
	end
	if LocalPlayer():HasPlayerState(PLAYERSTATE_BLEEDING) then
		surface.SetTexture(bleed_drop)
		surface.SetDrawColor(255,0,0,255)
		surface.DrawTexturedRect((75+26)*Scale, (20+7)*Scale, 32*Scale, 32*Scale)
		droplet_x = droplet_x + 30 * Scale
	end
	
	if LocalPlayer():HasPlayerState(PLAYERSTATE_MILK) then
		surface.SetTexture(bleed_drop)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect((75+26)*Scale, (20+7)*Scale, 32*Scale, 32*Scale)
		droplet_x = droplet_x + 30 * Scale
	end
	if LocalPlayer():HasPlayerState(PLAYERSTATE_JARATED) then
		surface.SetTexture(bleed_drop)
		surface.SetDrawColor(255,255,0,255)
		surface.DrawTexturedRect((75+26)*Scale, (20+7)*Scale, 32*Scale, 32*Scale)
		droplet_x = droplet_x + 30 * Scale
	end
	if LocalPlayer():HasPlayerState(PLAYERSTATE_PUKEDON) then
		surface.SetTexture(bleed_drop)
		surface.SetDrawColor(0,100,0,255)
		surface.DrawTexturedRect((75+26)*Scale, (20+7)*Scale, 32*Scale, 32*Scale)
		droplet_x = droplet_x + 30 * Scale
	end
	if LocalPlayer():HasPlayerState(PLAYERSTATE_STUNNED) then
		surface.SetTexture(slowed)
		surface.SetDrawColor(255,255,0,255)
		surface.DrawTexturedRect((75+26)*Scale, (20+7)*Scale, 32*Scale, 32*Scale)
		droplet_x = droplet_x + 30 * Scale
	end
end

if HudPlayerHealth then HudPlayerHealth:Remove() end
HudPlayerHealth = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
