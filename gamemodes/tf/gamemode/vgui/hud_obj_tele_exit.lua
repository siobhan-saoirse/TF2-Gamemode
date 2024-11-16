
local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local obj_status_teleport = surface.GetTextureID("hud/hud_obj_status_teleport_64")
local ico_metal = surface.GetTextureID("hud/ico_metal_mask")

local PANEL = {}

PANEL.PanelType = 1
PANEL.BuildingClass = "obj_teleporter"
PANEL.ObjectIcon = {
	surface.GetTextureID("hud/hud_obj_status_tele_exit");
}

PANEL.Lang_NotBuilt = "#Building_hud_tele_exit_not_built"

function PANEL:FindTargetCondition(ent)
	return ent:IsExit()
end

function PANEL:PaintActive()
	local level = self.TargetEntity:GetLevel()
	
	-- active
	surface.SetDrawColor(Colors.TransparentYellow)
	surface.DrawRect(72*Scale, 17*Scale, 38*Scale, 8*Scale)
	
	progress = self.TargetEntity:GetMetal() / 200
	if progress > 0 then
		surface.SetDrawColor(Colors.Yellow)
		surface.DrawRect(72*Scale, 17*Scale, 38*Scale*progress, 8*Scale)
	end
	
	surface.SetDrawColor(Colors.ProgressOffWhite)
	
	surface.SetTexture(ico_metal)
	surface.DrawTexturedRect(60*Scale, 16*Scale, 10*Scale, 10*Scale)
end

if HudObjTeleExit then HudObjTeleExit:Remove() end
HudObjTeleExit = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "HudObjBase"))
