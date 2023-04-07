
local PANEL = {}

local W = ScrW()
local H = ScrH()
local Scale = H/480

local objectives_timepanel_bg = {
	surface.GetTextureID("hud/objectives_timepanel_red_bg"),
	surface.GetTextureID("hud/objectives_timepanel_blue_bg")
}
local objectives_timepanel_progressbar = surface.GetTextureID("hud/objectives_timepanel_progressbar")
local objectives_timepanel_suddendeath = surface.GetTextureID("hud/objectives_timepanel_suddendeath")

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true)
end

function PANEL:PerformLayout()
	if not IsValid(LocalPlayer()) then return end
	
	self:SetPos(W/2-55*Scale,0*Scale)
	self:SetSize(110*Scale,150*Scale)
end

function PANEL:GetTime()
	if GAMEMODE.RoundTimePaused then
		return GAMEMODE.RoundTimePaused
	else
		return math.Clamp(GAMEMODE.RoundTimeReference - (CurTime() - GAMEMODE.RoundTimeLastUpdated), 0, math.huge)
	end
end

function PANEL:GetFormattedTime()
	local sec = math.ceil(self:GetTime())
	local min = math.floor(sec/60)
	sec = sec - 60*min
	
	if sec<10 then sec = "0"..sec end
	return min..":"..sec
end

function PANEL:Paint()
	if not GAMEMODE.RoundTimeReference and not GAMEMODE.RoundTimePaused then return end
	
	surface.SetDrawColor(255,255,255,255)
	if GAMEMODE.RoundTimeIsSetupPhase then
		surface.SetTexture(objectives_timepanel_suddendeath)
		surface.DrawTexturedRect(16*Scale, 31*Scale, 78*Scale, 20*Scale)
		
		draw.Text{
			text="Setup",
			font="ClockSubText",
			pos={(16+39)*Scale, (33+9.5)*Scale},
			xalign=TEXT_ALIGN_CENTER,
			yalign=TEXT_ALIGN_CENTER,
		}
	end
	
	local t = LocalPlayer():Team()
	local tex = objectives_timepanel_bg[t] or objectives_timepanel_bg[1]
	
	surface.SetTexture(tex)
	surface.DrawTexturedRect(16*Scale, 9*Scale, 78*Scale, 33*Scale)
	
	draw.Text{
		text=self:GetFormattedTime(),
		font="HudFontMediumSmall",
		pos={(23+22.2)*Scale, (11+15.5)*Scale},
		color=Colors.TanLight,
		xalign=TEXT_ALIGN_CENTER,
		yalign=TEXT_ALIGN_CENTER,
	}
	
	local progress = 1
	if GAMEMODE.MaxRoundTime and GAMEMODE.MaxRoundTime>0 then
		progress = math.Clamp(math.ceil(self:GetTime()) / GAMEMODE.MaxRoundTime, 0, 1)
	end
	
	local bgcolor = Colors.HudTimerProgressInActive
	local fgcolor = Colors.HudTimerProgressActive
	
	if progress<0.25 then
		fgcolor = Colors.HudTimerProgressWarning
	end
	
	tf_draw.CircularProgressBar(67*Scale, 16*Scale, 20*Scale, 20*Scale,
		objectives_timepanel_progressbar, objectives_timepanel_progressbar,
		fgcolor, bgcolor,
		progress
	)
end

if HudObjectiveTimePanel then HudObjectiveTimePanel:Remove() end
HudObjectiveTimePanel = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
