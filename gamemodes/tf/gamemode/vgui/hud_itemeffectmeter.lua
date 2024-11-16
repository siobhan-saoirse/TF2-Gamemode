local PANEL = {}

local W = ScrW()
local H = ScrH()
local Scale = H/480

local misc_ammo_area = {
	surface.GetTextureID("hud/misc_ammo_area_horiz1_red"),
	surface.GetTextureID("hud/misc_ammo_area_horiz1_blue"),
}

local MeterLabel = {
	text="",
	font="TFFontSmall",
	pos={62.5*Scale, 37.5*Scale},
	xalign=TEXT_ALIGN_CENTER,
	yalign=TEXT_ALIGN_CENTER,
}

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true)
end

function PANEL:PerformLayout()
	self:SetPos(W-174*Scale,H-62*Scale)
	self:SetSize(100*Scale,50*Scale)
end

function PANEL:Paint()
	if not LocalPlayer():Alive() or GetConVar("tf_forcehl2hud"):GetBool() or GetConVarNumber("cl_drawhud")==0 then return end
	
	local item
	for _,v in pairs(LocalPlayer():GetTFItems()) do
		if v.GetHUDMeterName and v.GetHUDMeterValue then
			item = v
			break
		end
	end
	
	if not IsValid(item) then
		return
	end
	
	local t = LocalPlayer():Team()
	
	local tex = misc_ammo_area[t] or misc_ammo_area[1]
	surface.SetDrawColor(255,255,255,255)
	
	surface.SetTexture(tex)
	surface.DrawTexturedRect(12*Scale, 6*Scale, 100*Scale, 50*Scale)
	
	MeterLabel.text = tf_lang.GetRaw(item:GetHUDMeterName())
	draw.Text(MeterLabel)
	
	local progress = math.Clamp(item:GetHUDMeterValue(), 0, 1)
	surface.SetDrawColor(Colors.TransparentYellow)
	surface.DrawRect(47*Scale, 28*Scale, 30*Scale, 5*Scale)
	
	if progress > 0 then
		surface.SetDrawColor(Colors.Yellow)
		surface.DrawRect(47*Scale, 28*Scale, 30*Scale*progress, 5*Scale)
	end
end

if HudItemEffectMeter then HudItemEffectMeter:Remove() end
HudItemEffectMeter = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
