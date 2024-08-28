local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local class_sel_sm = {}
local classes = {"scout", "soldier", "pyro", "demo", "heavy", "engineer", "medic", "sniper", "spy"}
local classnames = {"SCOUT", "SOLDIER", "PYRO", "DEMOMAN", "HEAVY", "ENGINEER", "MEDIC", "SNIPER", "SPY"}

local class_ypos = 40
local class_xdelta = 5
local class_wide_min = 60
local class_wide_max = 100
local class_tall_min = 120
local class_tall_max = 200
local class_distance_min = 7
local class_distance_max = 100

local class_size_speed = 10

for k,v in ipairs(classes) do
	class_sel_sm[k] = {
		surface.GetTextureID("vgui/class_sel_sm_"..v.."_red"),
		surface.GetTextureID("vgui/class_sel_sm_"..v.."_inactive")
	}
end

local backpack_01 = surface.GetTextureID("hud/backpack_01")
local backpack_01_grey = surface.GetTextureID("hud/backpack_01_grey")

function PANEL:SelectClassLoadout(c)
	if c>=1 and c<=10 then
		FullLoadoutPanel:SetVisible(true)
		self:ResetButtons()
		self:SetVisible(false)
	else
		FullLoadoutPanel:SetVisible(false)
		self:SetVisible(true)
	end
end

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:SetVisible(true)
	self:SetParent(CharInfoPanel)
	
	-- Class loadout buttons
	self.ClassButtons = {}
	local x = (W/2)/Scale - (4.5 * class_wide_min + 4 * class_xdelta)
	for k,_ in ipairs(classes) do
		local t = vgui.Create("TFButton")
		t:SetParent(self)
		t:SetPos(x*Scale, (28+class_ypos)*Scale)
		t:SetSize(class_wide_min*Scale,class_tall_min*Scale)
		t.activeImage = class_sel_sm[k][1]
		t.inactiveImage = class_sel_sm[k][2]
		
		t.xcenter = Scale * (x+class_wide_min/2)
		t.ycenter = Scale * (28+class_ypos+class_tall_min/2)
		
		function t:DoClick()
			self:GetParent():SelectClassLoadout(k)
			self:GetParent().char_model = "models/player/medic.mdl"
		end
		
		self.ClassButtons[k] = t
		
		x = x + class_wide_min + class_xdelta
	end
	
	--[[-- Backpack
	local t = vgui.Create("TFButton")
	t:SetParent(self)
	t:SetPos(W/2-30*Scale, 254*Scale)
	t:SetSize(60*Scale,60*Scale)
	t.activeImage = backpack_01
	t.inactiveImage = backpack_01_grey]]
end

function PANEL:ResetButtons()
	local w, h = Scale*class_wide_min, Scale*class_tall_min
	for k,v in ipairs(self.ClassButtons) do
		v:SetPos(v.xcenter-w/2, v.ycenter-h/2)
		v:SetSize(w, h)
	end
end

function PANEL:PerformLayout()
	self:SetPos(0, 40*Scale)
	self:SetSize(W, H)
	
	if not self.ClassButtons then return end
	
	local active = false
	for _,v in ipairs(self.ClassButtons) do
		if v.Hover then
			active = true
			break
		end
	end
	
	if active then
		local x, y = self:CursorPos()
		for k,v in ipairs(self.ClassButtons) do
			local dist = math.Clamp(math.abs(v.xcenter - x) / Scale, class_distance_min, class_distance_max)
			local r = 1 - (dist - class_distance_min) / (class_distance_max - class_distance_min)
			
			local w, h = Scale*Lerp(r, class_wide_min, class_wide_max), Scale*Lerp(r, class_tall_min, class_tall_max)
			v.TargetSize = Vector(w, h, 0)
		end
	else
		for k,v in ipairs(self.ClassButtons) do
			local w, h = Scale*class_wide_min, Scale*class_tall_min
			v.TargetSize = Vector(w, h, 0)
		end
	end
	
	for k,v in ipairs(self.ClassButtons) do
		if v.TargetSize then
			local w0, h0 = v:GetSize()
			local dw, dh = (v.TargetSize.x - w0) * RealFrameTime() * class_size_speed, (v.TargetSize.y - h0) * RealFrameTime() * class_size_speed
			local w, h = w0 + dw, h0 + dh
			
			v:SetPos(v.xcenter-w/2, v.ycenter-h/2)
			v:SetSize(w, h)
		end
	end
end

function PANEL:Think()
	self:InvalidateLayout()
end

function PANEL:Paint()
	draw.Text{
		text="SELECT A CLASS TO MODIFY LOADOUT",
		font="HudFontSmallBold",
		pos={W/2, 330*Scale},
		color=Color(117, 107, 94, 255),
		xalign=TEXT_ALIGN_CENTER,
		yalign=TEXT_ALIGN_TOP,
	}
	
	for k,v in ipairs(self.ClassButtons) do
		if v.Hover then
			draw.Text{
				text=classnames[k],
				font="HudFontSmallBold",
				pos={v.xcenter, 226*Scale},
				color=Color(235, 226, 202, 255),
				xalign=TEXT_ALIGN_CENTER,
				yalign=TEXT_ALIGN_TOP,
			}
			
			draw.Text{
				text="(NO ITEM FOUND YET)",
				font="HudFontSmall",
				pos={v.xcenter, 242*Scale},
				color=Color(117, 107, 94, 255),
				xalign=TEXT_ALIGN_CENTER,
				yalign=TEXT_ALIGN_TOP,
			}
			--[[
			draw.Text{
				text="(2 ITEMS IN INVENTORY)",
				font="HudFontSmall",
				pos={v.xcenter, 242*Scale},
				color=Color(200, 80, 60, 255),
				xalign=TEXT_ALIGN_CENTER,
				yalign=TEXT_ALIGN_TOP,
			}]]
		end
	end
end

if CharInfoLoadoutSubPanel then CharInfoLoadoutSubPanel:Remove() end
CharInfoLoadoutSubPanel = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
