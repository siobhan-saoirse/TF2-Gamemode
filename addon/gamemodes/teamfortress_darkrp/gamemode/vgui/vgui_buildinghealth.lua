
local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local PANEL = {}

function PANEL:Init()
	self:SetVisible(true)
	self.Value = 1
	self.BarHeight = 3
	self.BarSpacing = 1
end

function PANEL:SetValue(v)
	self.Value = v
end

function PANEL:Paint()
	local w, h = self:GetSize()
	
	local dy = math.floor((self.BarHeight+self.BarSpacing)*Scale)
	local bh = math.floor(self.BarHeight * Scale)
	
	local num_divs = math.floor((h-bh) / dy) + 1
	local div_fill = math.ceil(num_divs * self.Value)
	
	surface.SetDrawColor(Colors.HealthBgGrey)
	
	for i=0, num_divs-div_fill-1 do
		surface.DrawRect(0, i*dy, w, bh)
	end
	
	if self.Value < 0.5 then
		surface.SetDrawColor(Colors.LowHealthRed)
	else
		surface.SetDrawColor(Colors.TanLight)
	end
	
	for i=num_divs-div_fill, num_divs-1 do
		surface.DrawRect(0, i*dy, w, bh)
	end
end

vgui.Register("TFBuildingHealthBar", PANEL)
