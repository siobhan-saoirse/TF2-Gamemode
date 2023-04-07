local hud_showloadout = CreateConVar("hud_showloadout", "0", {FCVAR_ARCHIVE})

cvars.AddChangeCallback("hud_showloadout", function(cvar, old, new)
	if not CharInfoPanel then return end
	
	if tonumber(new)==0 then
		gui.EnableScreenClicker(false)
		CharInfoPanel:Hide(true)
	else
		gui.EnableScreenClicker(true)
		CharInfoPanel:Show(true)
	end
end)

local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local loadout_header = surface.GetTextureID("vgui/loadout_header")
local loadout_bottom_gradient = surface.GetTextureID("vgui/loadout_bottom_gradient")
local loadout_solid_line = surface.GetTextureID("vgui/loadout_solid_line")

local loadout_round_rect = surface.GetTextureID("vgui/loadout_round_rect")
local loadout_round_rect_selected = surface.GetTextureID("vgui/loadout_round_rect_selected")

local Tabs = {"LOADOUT", "STATS"}
local TabPanels = {"CharInfoLoadoutSubPanel", ""}

local tabx = 80*Scale
local taby = 33.5*Scale
local tabw = 240*Scale
local tabh = 34*Scale
local tabd = 10*Scale

local ColorTabSelected = Color(200, 187, 161, 255)
local ColorTabUnselected = Color(130, 120, 104, 255)

function PANEL:Init()
	self:SetPaintBackgroundEnabled(true)
	self:SetVisible(false)
	
	self.CurrentTab = 1
end

function PANEL:Open()
	if self:IsVisible() then return end
	
	self:MakePopup()
	self:SetVisible(true)
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(true)
	self:InvalidateLayout(true)
end

function PANEL:Close()
	if not self:IsVisible() then return end
	
	self:SetVisible(false)
	self:SetKeyboardInputEnabled(false)
	self:SetMouseInputEnabled(false)
end

function PANEL:SetCurrentTab(t)
	self.CurrentTab = t
	for k,v in ipairs(TabPanels) do
		v = getfenv()[v]
		if v then
			if t==k then
				v:SetVisible(true)
			else
				v:SetVisible(false)
			end
		end
	end
end

function PANEL:PerformLayout()
	self:SetPos(0, 0)
	self:SetSize(W, H)
	
	-- Close button
	self.CloseButton = vgui.Create("TFButton")
	self.CloseButton:SetParent(self)
	self.CloseButton:SetPos(W/2 + 200*Scale,437*Scale)
	self.CloseButton:SetSize(100*Scale,25*Scale)
	self.CloseButton.labelText = "CLOSE"
	self.CloseButton.font = "HudFontSmallBold"
	function self.CloseButton:DoClick()
		self:GetParent():Close()
	end
	
	-- Tab buttons
	self.TabButtons = {}
	local x, y = tabx, taby
	
	for k,_ in ipairs(Tabs) do
		local t = vgui.Create("TFButton")
		t:SetParent(self)
		t:SetPos(x,y)
		t:SetSize(tabw,tabh)
		t.invisible = true
		
		function t:DoClick()
			self:GetParent():SetCurrentTab(k)
		end
		
		self.TabButtons[k] = t
		
		x = x + tabw + tabd
	end
end

function PANEL:DrawTab(x, y, txt, active)
	local mat, col
	if active then
		mat = loadout_round_rect_selected
		col = ColorTabSelected
	else
		mat = loadout_round_rect
		col = ColorTabUnselected
	end
	
	tf_draw.BorderPanel(mat,
		x,y,tabw,tabh,
		26,26,12*Scale,12*Scale
	)
	draw.Text{
		text=txt,
		font="HudFontMediumBold",
		pos={x + 18*Scale,y + tabh/2},
		color=col,
		xalign=TEXT_ALIGN_LEFT,
		yalign=TEXT_ALIGN_CENTER,
	}
end

function PANEL:Paint()
	-- Header and footer
	surface.SetDrawColor(255,255,255,255)
	
	tf_draw.TexturedQuadTiled(loadout_header, 0, 0, W, 65*Scale)
	
	-- Inactive tabs
	local x, y = tabx, taby
	for k,v in ipairs(Tabs) do
		if k~=self.CurrentTab then
			self:DrawTab(x+Scale, y+Scale, v, false)
		end
		x = x + tabw + tabd
	end
	
	-- Background
	surface.SetDrawColor(46, 43, 42, 255)
	surface.DrawRect(0,65*Scale,W,H)
	
	-- Header separation line
	surface.SetDrawColor(255,255,255,255)
	
	surface.SetTexture(loadout_solid_line)
	surface.DrawTexturedRect(0, 65*Scale, W, 10*Scale)
	
	-- Active tabs
	local x, y = tabx, taby
	for k,v in ipairs(Tabs) do
		if k==self.CurrentTab then
			self:DrawTab(x, y, v, true)
			break
		end
		x = x + tabw + tabd
	end
	
	-- Footer separation line
	surface.SetDrawColor(255,255,255,255)
	
	tf_draw.TexturedQuadTiled(loadout_bottom_gradient, 0, 422*Scale, W, 60*Scale)
	surface.SetTexture(loadout_solid_line)
	surface.DrawTexturedRect(0, 422*Scale, W, 10*Scale)
	
	-- Labels
	draw.Text{
		text=">>",
		font="HudFontSmallestBold",
		pos={85*Scale, 18*Scale},
		color=Color(200, 80, 60, 255),
		xalign=TEXT_ALIGN_LEFT,
		yalign=TEXT_ALIGN_CENTER,
	}
	
	draw.Text{
		text="CHARACTER INFO AND SETUP (CURRENTLY ISNT FUNCTIONAL)",
		font="HudFontSmallestBold",
		pos={100*Scale, 18*Scale},
		color=Color(117, 107, 94, 255),
		xalign=TEXT_ALIGN_LEFT,
		yalign=TEXT_ALIGN_CENTER,
	}
end

if CharInfoPanel then CharInfoPanel:Remove() end
CharInfoPanel = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
