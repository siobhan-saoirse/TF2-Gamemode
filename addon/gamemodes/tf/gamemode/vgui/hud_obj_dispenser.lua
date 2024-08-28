
local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local obj_status_ammo = surface.GetTextureID("hud/hud_obj_status_ammo_64")
local ico_metal = surface.GetTextureID("hud/ico_metal_mask")

local PANEL = {}

PANEL.PanelType = 1
PANEL.BuildingClass = "obj_dispenser"
PANEL.ObjectIcon = {
	surface.GetTextureID("hud/hud_obj_status_dispenser");
}

PANEL.Lang_NotBuilt = "#Building_hud_dispenser_not_built"

function PANEL:PaintActive()
	local level = self.TargetEntity:GetLevel()
	
	-- active
	surface.SetDrawColor(Colors.TransparentYellow)
	surface.DrawRect(72*Scale, 6*Scale, 38*Scale, 8*Scale)
	surface.DrawRect(72*Scale, 17*Scale, 38*Scale, 8*Scale)
	
	progress = self.TargetEntity:GetAmmoPercentage()
	if progress > 0 then
		surface.SetDrawColor(Colors.Yellow)
		surface.DrawRect(72*Scale, 6*Scale, 38*Scale*progress, 8*Scale)
	end
	
	progress = self.TargetEntity:GetMetal() / 200
	if progress > 0 then
		surface.SetDrawColor(Colors.Yellow)
		surface.DrawRect(72*Scale, 17*Scale, 38*Scale*progress, 8*Scale)
	end
	
	surface.SetDrawColor(Colors.ProgressOffWhite)
	
	surface.SetTexture(obj_status_ammo)
	surface.DrawTexturedRect(60*Scale, 5*Scale, 10*Scale, 10*Scale)
	
	surface.SetTexture(ico_metal)
	surface.DrawTexturedRect(60*Scale, 16*Scale, 10*Scale, 10*Scale)
end

if HudObjDispenser then HudObjDispenser:Remove() end
HudObjDispenser = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "HudObjBase"))
