local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local panel = surface.GetTextureID("hud/color_panel_red")

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true)
end

function PANEL:PerformLayout()
	if !IsValid(LocalPlayer()) then return end
	
	self:SetPos(0, 0)
	self:SetSize(W, H)
end

function PANEL:Paint()
	local w, h = tf_draw.TranslateScale(5, 5)
	tf_draw.BorderPanel(panel,10,200,250,100,23,23,w,h)
end

HudTest = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
