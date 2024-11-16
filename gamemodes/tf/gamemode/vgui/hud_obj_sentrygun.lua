
local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local obj_status_kill = surface.GetTextureID("hud/hud_obj_status_kill_64")
local obj_status_ammo = surface.GetTextureID("hud/hud_obj_status_ammo_64")
local obj_status_rockets = surface.GetTextureID("hud/hud_obj_status_rockets_64")
local ico_metal = surface.GetTextureID("hud/ico_metal_mask")

local KillsLabel = {
	x=72*Scale,y=13*Scale,
	w=200*Scale,h=22*Scale,
	font="TFDefaultSmall",
	align="north-west",
	col="TanLight",
}

local PANEL = {}

PANEL.PanelType = 2
PANEL.BuildingClass = "obj_sentrygun"
PANEL.ObjectIcon = {
	surface.GetTextureID("hud/hud_obj_status_sentry_1");
	surface.GetTextureID("hud/hud_obj_status_sentry_2");
	surface.GetTextureID("hud/hud_obj_status_sentry_3");
}

PANEL.Lang_NotBuilt = "#Building_hud_sentry_not_built"

function PANEL:PaintActive()
	local level = self.TargetEntity:GetLevel()
	
	-- active
	tf_lang.SetGlobal("numkills", self.TargetEntity:GetKills())
	tf_lang.SetGlobal("numassists", self.TargetEntity:GetAssists())
	KillsLabel.text = tf_lang.GetFormatted("#Building_hud_sentry_kills_assists")
	tf_draw.LabelTextWrap(KillsLabel)
	
	surface.SetDrawColor(Colors.TransparentYellow)
	surface.DrawRect(72*Scale, 26*Scale, 38*Scale, 8*Scale)
	surface.DrawRect(72*Scale, 39*Scale, 38*Scale, 8*Scale)
	
	progress = self.TargetEntity:GetAmmo1Percentage()
	if progress > 0 then
		if progress < 0.25 then
			surface.SetDrawColor(Colors.LowHealthRed)
		else
			surface.SetDrawColor(Colors.Yellow)
		end
		surface.DrawRect(72*Scale, 26*Scale, 38*Scale*progress, 8*Scale)
	end
	
	if level == 3 then
		progress = self.TargetEntity:GetAmmo2Percentage()
	else
		progress = self.TargetEntity:GetMetal() / 200
	end
	
	if progress > 0 then
		if level == 3 and progress < 0.25 then
			surface.SetDrawColor(Colors.LowHealthRed)
		else
			surface.SetDrawColor(Colors.Yellow)
		end
		surface.DrawRect(72*Scale, 39*Scale, 38*Scale*progress, 8*Scale)
	end
	
	surface.SetDrawColor(Colors.ProgressOffWhite)
	
	surface.SetTexture(obj_status_kill)
	surface.DrawTexturedRect(60*Scale, 12*Scale, 10*Scale, 10*Scale)
	surface.SetTexture(obj_status_ammo)
	surface.DrawTexturedRect(60*Scale, 25*Scale, 10*Scale, 10*Scale)
	
	if level == 3 then
		surface.SetTexture(obj_status_rockets)
	else
		surface.SetTexture(ico_metal)
	end
	surface.DrawTexturedRect(60*Scale, 38*Scale, 10*Scale, 10*Scale)
end

if HudObjSentrygun then HudObjSentrygun:Remove() end
HudObjSentrygun = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "HudObjBase"))
