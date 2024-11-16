local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true)
	self.Progress = 0
end

function PANEL:PerformLayout()
	self:SetPos(W-80*Scale,H-21*Scale)
	self:SetSize(60*Scale,8*Scale)
end

function PANEL:SetProgress(p)
	self.Progress = math.Clamp(p, 0, 1)
end

function PANEL:Paint()
	if not LocalPlayer():Alive() or GetConVar("tf_forcehl2hud"):GetBool() or GetConVarNumber("cl_drawhud")==0 then return end
	
	if not IsCustomHUDVisible("HudBowCharge") then
		return
	end
	
	surface.SetDrawColor(Colors.TransparentYellow)
	surface.DrawRect(0, 0, 53*Scale, 6*Scale)
	
	if self.Progress > 0 then
		surface.SetDrawColor(Colors.Yellow)
		surface.DrawRect(0, 0, 53*Scale*self.Progress, 6*Scale)
	end
end

if HudBowCharge then HudBowCharge:Remove() end
HudBowCharge = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
