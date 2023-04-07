local PANEL = {}

local W = ScrW()
local H = ScrH()
local Scale = H/480

local misc_ammo_area = {
	surface.GetTextureID("hud/misc_ammo_area_red"),
	surface.GetTextureID("hud/misc_ammo_area_blue"),
}

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true)
end

function PANEL:PerformLayout()
	self:SetPos(W-162*Scale,H-92*Scale)
	self:SetSize(100*Scale,50*Scale)
end

function PANEL:Paint()
	if not LocalPlayer():Alive() or GetConVar("tf_forcehl2hud"):GetBool() or GetConVarNumber("cl_drawhud")==0 then return end
	
	if not IsCustomHUDVisible("HudItemEffectMeter_Demoman") then
		return
	end
	
	local n = LocalPlayer():GetNWInt("Heads")
	local t = LocalPlayer():Team()
	
	local tex = misc_ammo_area[t] or misc_ammo_area[1]
	surface.SetDrawColor(255,255,255,255)
	
	surface.SetTexture(tex)
	surface.DrawTexturedRect(12*Scale, 1*Scale, 76*Scale, (44-2)*Scale)
	
	draw.Text{
		text="HEADS",
		font="TFFontSmall",
		color=Colors.TanLight,
		pos={(25+20.5)*Scale, (27+7.5)*Scale},
		xalign=TEXT_ALIGN_CENTER,
		yalign=TEXT_ALIGN_CENTER,
	}
	
	draw.Text{
		text=n,
		font="HudFontMedium",
		color=Colors.TanLight,
		pos={(25+21)*Scale, 11*Scale},
		xalign=TEXT_ALIGN_CENTER,
		yalign=TEXT_ALIGN_TOP,
	}
end

if HudItemEffectMeter_Demoman then HudItemEffectMeter_Demoman:Remove() end
HudItemEffectMeter_Demoman = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
