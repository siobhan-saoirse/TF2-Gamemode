local PANEL = {}

local W = ScrW()
local H = ScrH()
local Scale = H/480

local delta_item_x = 28
local delta_item_start_y = 90
local delta_item_end_y = 70
local PositiveColor = Color(0, 255, 0, 255)
local NegativeColor = Color(255, 0, 0, 255)
local delta_lifetime = 1.5
local delta_item_font = "HudFontMedium"

local misc_ammo_area = {
	surface.GetTextureID("hud/misc_ammo_area_red"),
	surface.GetTextureID("hud/misc_ammo_area_blue"),
}
local ico_metal = surface.GetTextureID("hud/ico_metal_mask")

local AccountValue = {
	pos = {47.5*Scale, 125*Scale},
	font = "HudFontMediumSmall",
	color = Colors.TanLight,
	xalign = TEXT_ALIGN_CENTER,
	yalign = TEXT_ALIGN_CENTER,
}

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true)
	self.Items = {}
end

function PANEL:AddItem(value)
	if value~=0 then
		if self.Items[1] and CurTime() + delta_lifetime - self.Items[1][2] < 0.001 then
			self.Items[1][1] = self.Items[1][1] + value
		else
			table.insert(self.Items, 1, {value, CurTime() + delta_lifetime})
		end
	end
end

function PANEL:PerformLayout()
	self:SetPos(W-162*Scale,H-152*Scale)
	self:SetSize(116*Scale,180*Scale)
end

function PANEL:Paint()
	if not LocalPlayer():Alive() or GetConVarNumber("cl_drawhud")==0 then return end
	
	if not IsCustomHUDVisible("HudAccountPanel") then
		return
	end
	
	local n = LocalPlayer():GetAmmoCount(TF_METAL)
	local t = LocalPlayer():Team()
	
	local tex = misc_ammo_area[t] or misc_ammo_area[1]
	surface.SetDrawColor(color_white)
	
	surface.SetTexture(tex)
	surface.DrawTexturedRect(5*Scale, 103*Scale, 84*Scale, 42*Scale)
	
	surface.SetTexture(ico_metal)
	surface.SetDrawColor(Colors.ProgressOffWhite)
	surface.DrawTexturedRect(19*Scale, 116*Scale, 10*Scale, 10*Scale)
	surface.SetDrawColor(color_white)
	
	AccountValue.text = n
	draw.Text(AccountValue)
	
	for k,v in ipairs(self.Items) do
		local diff = v[2] - CurTime()
		if diff<=0 then
			self.Items[k] = nil
		else
			local ratio = math.Clamp(diff / delta_lifetime, 0, 1)
			local alpha = Lerp(ratio, 0, 255)
			local y = Lerp(ratio, delta_item_end_y, delta_item_start_y)
			local col, txt
			
			if v[1]>0 then
				txt = "+"..tostring(v[1])
				col = Color(PositiveColor.r, PositiveColor.g, PositiveColor.b, alpha)
			else
				txt = tostring(v[1])
				col = Color(NegativeColor.r, NegativeColor.g, NegativeColor.b, alpha)
			end
			
			draw.Text{
				text=txt,
				font=delta_item_font,
				pos={delta_item_x*Scale, y*Scale},
				color=col,
				xalign=TEXT_ALIGN_LEFT,
				yalign=TEXT_ALIGN_TOP,
			}
		end
	end
end

if HudAccountPanel then HudAccountPanel:Remove() end
HudAccountPanel = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))

usermessage.Hook("PlayerMetalBonus", function(msg)
	HudAccountPanel:AddItem(msg:ReadShort())
end)
