local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true)
	
	self.Panels = {
		HudObjSentrygun;
		HudObjDispenser;
		HudObjTeleEntrance;
		HudObjTeleExit;
	}
	
	for k,v in ipairs(self.Panels) do
		v:SetParent(self)
	end
	
	self.InitialX = math.ceil(8*Scale)
	self.InitialY = math.ceil(8*Scale)
	self.YSpacing = math.ceil(-1*Scale)
end

function PANEL:PerformLayout()
	self:SetPos(0,0)
	self:SetSize(W,H)
	
	local x, y = self.InitialX, self.InitialY
	
	for k,v in ipairs(self.Panels) do
		v:PerformLayout()
		v:SetPos(x, y)
		local w, h = v:GetSize()
		y = y + math.ceil(h) + self.YSpacing
	end
end

function PANEL:ShouldDraw()
	-- MEGA gay temporary quickfix
	if LocalPlayer():IsValid() and LocalPlayer():GetPlayerClass() != nil then
	if LocalPlayer():GetPlayerClass() == "spy" then return false end
	
	return GetConVarNumber("cl_drawhud")~=0 and IsCustomHUDVisible("HudBuildingStatus")
	end
end

function PANEL:Think()
	local shoulddraw = self:ShouldDraw()
	if shoulddraw ~= self.LastShouldDraw then
		for _,v in ipairs(self.Panels) do
			v:SetVisible(shoulddraw)
		end
		
		self.LastShouldDraw = shoulddraw
	end
	
	if shoulddraw then
		local maxalert = 0
		for k,v in ipairs(self.Panels) do
			if v.AlertType and v.AlertType > maxalert then
				maxalert = v.AlertType
			end
		end
		
		if maxalert ~= self.LastAlertLevel then
			self.LastAlertLevel = maxalert
			
			if maxalert == 3 then
				self.WarningBeepsRemaining = 2
				self.WarningBeepsPeriod = 2
				self.NextWarningBeep = RealTime()
			elseif maxalert == 4 then
				self.WarningBeepsRemaining = -1
				self.WarningBeepsPeriod = 1
				self.NextWarningBeep = RealTime()
			else
				self.WarningBeepsRemaining = 0
			end
			
			if self.AlertSoundPatch then
				self.AlertSoundPatch:Stop()
			end
		end
		
		if self.WarningBeepsRemaining and self.WarningBeepsRemaining ~= 0 and RealTime() >= self.NextWarningBeep then
			self.WarningBeepsRemaining = self.WarningBeepsRemaining - 1
			self.NextWarningBeep = RealTime() + self.WarningBeepsPeriod
			if not self.AlertSoundPatch then
				self.AlertSoundPatch = CreateSound(LocalPlayer(), "misc/hud_warning.wav")
			end
			self.AlertSoundPatch:Stop()
			self.AlertSoundPatch:Play()
		end
	else
		self.LastAlertLevel = 0
	end
end

function PANEL:Paint()
end

if HudBuildingStatus then HudBuildingStatus:Remove() end
HudBuildingStatus = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
