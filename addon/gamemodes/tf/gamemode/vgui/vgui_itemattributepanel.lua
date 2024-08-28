local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local loadout_popup = surface.GetTextureID("vgui/loadout_popup")
local bordersize = 26

local attribcolors = {
	"ItemAttribLevel",
	"ItemAttribNeutral",
	"ItemAttribPositive",
	"ItemAttribNegative",
	"ItemSetName",
	"ItemSetItemMissing",
	"ItemSetItemEquipped",
}

function PANEL:Init()
	self:SetVisible(false)
	self:NoClipping(true)
	self:SetPaintBackgroundEnabled(false)
end

function PANEL:SetQuality(q)
	q = "QualityColor"..q
	if Colors[q] then
		self.qualitycolor = q
	end
end

function PANEL:Paint()
	if self.invisible then return end
	
	local w, h = self:GetSize()
	local h2 = (self.text_ypos+28+11*#(self.attributes or {})+31-2*bordersize)*Scale
	
	surface.SetDrawColor(255,255,255,255)

	self:SetPos(gui.MouseX(), gui.MouseY())
	
	local b = bordersize*Scale
	
	tf_draw.BorderPanel(loadout_popup,
		-b,-b,w+2*b,h2+2*b,
		36,36,b,b
	)
	
	tf_draw.LabelText(
		0, (self.text_ypos-bordersize)*Scale,
		w, 20*Scale,
		self.text,
		self.qualitycolor or "QualityColorNormal",
		"ItemFontNameLarge",
		"south"
	)
	--self.attributes = {["crit mod disabled hidden"] = {["attribute_class"] = "mult_crit_chance", ["name"] = "crit mod disabled hidden", ["value"] = 0}}
	local name

	if self.attributes then
		--PrintTable(self.attributes)
	end
	
	local y = (self.text_ypos+28-bordersize)*Scale
	for k,v in pairs(self.attributes or {}) do
		local name = v["name"]
		if v["value"] ~= 0 and v["value"] ~= 1 and isnumber(v["value"]) then
			name = string.sub(v["value"], 1, 3) .. " " .. v["name"]
		end
		tf_draw.LabelText(
			0, y,
			w, 0,
			name,
			attribcolors[v[2] or 2] or attribcolors[2],
			"ItemFontAttribLarge",
			"north"
		)

		--[[			0, y,
			w, 0,
			v[1],
			attribcolors[v[2] or 2] or attribcolors[2],]]
		y = y + 11*Scale
	end
end

vgui.Register("ItemAttributePanel", PANEL)
