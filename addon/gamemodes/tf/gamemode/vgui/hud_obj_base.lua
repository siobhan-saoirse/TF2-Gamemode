
local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local obj_status_background_disabled = {
	texture = surface.GetTextureID("hud/eng_status_area_tele_disabled"),
	x=1,
	y=1,
	w=243,
	h=64,
}

local obj_status_background_red = {
	texture = surface.GetTextureID("hud/eng_status_area_tele_red"),
	x=1,
	y=1,
	w=243,
	h=64,
}

local obj_status_background_blue = {
	texture = surface.GetTextureID("hud/eng_status_area_tele_blue"),
	x=1,
	y=1,
	w=243,
	h=64,
}

local obj_status_alert_background = {
	texture	= surface.GetTextureID("hud/eng_status_area_tele_alrt"),
	x=0,
	y=0,
	w=80,
	h=64,
}

local obj_status_background_tall_disabled = {
	texture = surface.GetTextureID("hud/eng_status_area_sentry_disabled"),
	x=1,
	y=1,
	w=243,
	h=110,
}

local obj_status_background_tall_red = {
	texture = surface.GetTextureID("hud/eng_status_area_sentry_red"),
	x=1,
	y=1,
	w=243,
	h=110,
}

local obj_status_background_tall_blue = {
	texture = surface.GetTextureID("hud/eng_status_area_sentry_blue"),
	x=1,
	y=1,
	w=243,
	h=110,
}

local obj_status_alert_background_tall = {
	texture	= surface.GetTextureID("hud/eng_status_area_sentry_alrt"),
	x=0,
	y=0,
	w=80,
	h=110,
}

local obj_status_schemes = {
	-- Normal
	[1] = {
		background = {
			[0] = obj_status_background_disabled;
			[1] = obj_status_background_red;
			[2] = obj_status_background_blue;
		};
		alert = obj_status_alert_background;
		alert_p = {
			x = 113,
			y = -0.5,
			w = 34,
			h = 31,
		};
		alert_mat = Material("hud/eng_status_area_tele_alrt");
		
		alert_icon_p = {
			x=121,
			y=5,
			w=19,
			h=19,
		};
		
		bg_p = {
			x=0,
			y=0,
			w=120,
			h=31,
		};
		
		objicon_p = {
			x=24,
			y=1,
			w=28,
			h=28,
		};
		
		label_notbuilt = {
			x=60*Scale,y=0,
			w=200*Scale,h=31*Scale,
			font="TFDefaultVerySmall",
			align="west",
			col="TanLight",
		};
		
		label_building = {
			x=60*Scale,y=5*Scale,
			w=200*Scale,h=12*Scale,
			font="TFDefaultSmall",
			align="west",
			col="TanLight",
		};
		
		build_progress = {
			x=60,
			y=16,
			w=50,
			h=8,
		};
	};
	
	-- Tall
	[2] = {
		background = {
			[0] = obj_status_background_tall_disabled;
			[1] = obj_status_background_tall_red;
			[2] = obj_status_background_tall_blue;
		};
		alert = obj_status_alert_background_tall;
		alert_p = {
			x = 114,
			y = -0.5,
			w = 44,
			h = 60,
		};
		alert_mat = Material("hud/eng_status_area_sentry_alrt");
		
		alert_icon_p = {
			x=121,
			y=18,
			w=27,
			h=27,
		};
		
		bg_p = {
			x=0,
			y=0,
			w=120,
			h=60,
		};
		
		objicon_p = {
			x=22,
			y=12,
			w=36,
			h=36,
		};
		
		label_notbuilt = {
			x=60*Scale,y=0,
			w=200*Scale,h=60*Scale,
			font="TFDefaultVerySmall",
			align="west",
			col="TanLight",
		};
		
		label_building = {
			x=60*Scale,y=18*Scale,
			w=200*Scale,h=12*Scale,
			font="TFDefaultSmall",
			align="west",
			col="TanLight",
		};
		
		build_progress = {
			x=60,
			y=29,
			w=50,
			h=8,
		};
	};
}

local temp_mat = Material("hud/eng_status_area_tele_alrt")
temp_mat:SetInt("$separatedetailuvs", 0)
temp_mat:SetInt("$detailscale", 1)

local temp_mat = Material("hud/eng_status_area_sentry_alrt")
temp_mat:SetInt("$separatedetailuvs", 0)
temp_mat:SetInt("$detailscale", 1)

local obj_status_upgrade_1 = surface.GetTextureID("hud/hud_upgrade_1")
local obj_status_upgrade_2 = surface.GetTextureID("hud/hud_upgrade_2")
local obj_status_upgrade_3 = surface.GetTextureID("hud/hud_upgrade_3")
local obj_status_upgrade = {
	obj_status_upgrade_1,
	obj_status_upgrade_2,
	obj_status_upgrade_3
}

local obj_status_icon_wrench = surface.GetTextureID("hud/eng_status_alert_ico_wrench")
local obj_status_icon_sapper = surface.GetTextureID("hud/hud_obj_status_sapper")

local PANEL = {}

function PANEL:Init()
	self:SetVisible(false)
	self:SetPaintBackgroundEnabled(false)
	
	if not self.HealthBar then
		self.HealthBar = vgui.Create("TFBuildingHealthBar", self)
		self.HealthBar:SetValue(0)
	end
	
	self.AlertType = 0
end

function PANEL:PerformLayout()
	if self.PanelType == 1 then
		self:SetSize(150*Scale, 31*Scale)
		self.HealthBar:SetPos(13*Scale, 4*Scale)
		self.HealthBar:SetSize(8*Scale, 24*Scale)
	else
		self:SetSize(160*Scale, 60*Scale)
		self.HealthBar:SetPos(13*Scale, 3*Scale)
		self.HealthBar:SetSize(8*Scale, 53*Scale)
	end
end

function PANEL:FindTargetCondition(ent)
	return true
end

function PANEL:FindTargetEntity()
	self.TargetEntity = nil
	for _,v in pairs(ents.FindByClass(self.BuildingClass)) do
		if v:IsBuilding() and v:GetBuilder() == LocalPlayer() and self:FindTargetCondition(v) then
			self.TargetEntity = v
			return
		end
	end
end

local AlertPanelCloseTime = 0.3
local AlertPanelOpenTime = 0.2

local AlertPanelColor = Color(255, 255, 255, 255)

function PANEL:OpenAlertPanel()
	if self.NextAlertPanelOpen then return end
	self.NextAlertPanelOpen = CurTime() + AlertPanelOpenTime
	self.NextAlertPanelClose = nil
end

function PANEL:CloseAlertPanel()
	if self.NextAlertPanelClose then return end
	self.NextAlertPanelOpen = nil
	self.NextAlertPanelClose = CurTime() + AlertPanelCloseTime
end

function PANEL:DrawAlertPanel()
	local schm = obj_status_schemes[self.PanelType] or obj_status_schemes[1]
	
	-- Alert panel
	local alert = self.TargetEntity:HUDAlertStatus()
	
	if alert and self.AlertType ~= alert then
		if alert == 0 and self.AlertType and self.AlertType > 0 then
			self:CloseAlertPanel()
		elseif alert > 0 then
			self:OpenAlertPanel()
			self.AlertType = alert
		end
	end
	


	if self.AlertType == 0 and self.NextAlertPanelOpen then
		self:CloseAlertPanel()
	end
	
	local m = Matrix()
	local p = 0
	
	if self.NextAlertPanelClose then
		p = math.Clamp((self.NextAlertPanelClose - CurTime()) / AlertPanelCloseTime, 0, 1)
	elseif self.NextAlertPanelOpen then
		p = math.Clamp(1 - (self.NextAlertPanelOpen - CurTime()) / AlertPanelOpenTime, 0, 1)
	end
	
	m:Translate(Vector((1-p) * 0.6, 0, 0))
	schm.alert_mat:SetMatrix("$basetexturetransform", m)
	
	if p > 0 then
		if self.AlertType and self.AlertType > 1 then
			local red = 0.5 * (1 + math.sin(CurTime() * 2))
			AlertPanelColor.g = 255 * (1-red)
			AlertPanelColor.b = 255 * (1-red)
			surface.SetDrawColor(AlertPanelColor)
		else
			surface.SetDrawColor(color_white)
		end
		
		tf_draw.ModTexture(schm.alert,
			schm.alert_p.x*Scale,
			schm.alert_p.y*Scale,
			schm.alert_p.w*Scale,
			schm.alert_p.h*Scale
		)
		
		surface.SetDrawColor(color_white)
		
		if p >= 1 then
			if self.AlertType == 4 then
				surface.SetTexture(obj_status_icon_sapper)
			else
				surface.SetTexture(obj_status_icon_wrench)
			end
			
			surface.DrawTexturedRect(
				schm.alert_icon_p.x*Scale,
				schm.alert_icon_p.y*Scale,
				schm.alert_icon_p.w*Scale,
				schm.alert_icon_p.h*Scale
			)
		end
	else
		self.AlertType = 0
	end
end

function PANEL:PaintActive()
	
end

function PANEL:Paint()
	local schm = obj_status_schemes[self.PanelType] or obj_status_schemes[1]
	
	if 	!IsValid(self.TargetEntity) then
		self:FindTargetEntity()
	end
	
	surface.SetDrawColor(color_white)
	


	if !IsValid(self.TargetEntity) or self.TargetEntity:GetState() == 0 then
		-- not built
		self.HealthBar:SetVisible(false)
		
		self.NextAlertPanelOpen = nil
		self.NextAlertPanelClose = nil
		
		tf_draw.ModTexture(schm.background[0],
			schm.bg_p.x*Scale,
			schm.bg_p.y*Scale,
			schm.bg_p.w*Scale,
			schm.bg_p.h*Scale
		)
		
		surface.SetTexture(self.ObjectIcon[1])
		surface.DrawTexturedRect(
			schm.objicon_p.x*Scale,
			schm.objicon_p.y*Scale,
			schm.objicon_p.w*Scale,
			schm.objicon_p.h*Scale
		)
		
		schm.label_notbuilt.text = tf_lang.GetRaw(self.Lang_NotBuilt)
		tf_draw.LabelTextWrap(schm.label_notbuilt)
		
		self.AlertType = 0
	else

		self.HealthBar:SetVisible(true)
		self.HealthBar:SetValue(self.TargetEntity:Health() / self.TargetEntity:GetObjectHealth())
		
		local level = self.TargetEntity:GetLevel()
		local state = self.TargetEntity:GetState()
		if IsValid(self.TargetEntity) and self.TargetEntity.Sapped == true then
			self.AlertType = 4
		else
			self.AlertType = 0
		end
		if not self.No and state > 1 then
			self:DrawAlertPanel()
		else
			self.AlertType = 0
		end


		
		tf_draw.ModTexture((LocalPlayer():Team() == TEAM_BLU and schm.background[2]) or schm.background[1],
			schm.bg_p.x*Scale,
			schm.bg_p.y*Scale,
			schm.bg_p.w*Scale,
			schm.bg_p.h*Scale
		)
		
		surface.SetTexture(self.ObjectIcon[level] or self.ObjectIcon[1])
		surface.DrawTexturedRect(
			schm.objicon_p.x*Scale,
			schm.objicon_p.y*Scale,
			schm.objicon_p.w*Scale,
			schm.objicon_p.h*Scale
		)
		
		local progress
		if state <= 1 then
			-- Building
			schm.label_building.text = tf_lang.GetRaw("#Building_hud_building")
			tf_draw.LabelTextWrap(schm.label_building)
			
			surface.SetDrawColor(Colors.TransparentYellow)
			surface.DrawRect(
				schm.build_progress.x*Scale,
				schm.build_progress.y*Scale,
				schm.build_progress.w*Scale,
				schm.build_progress.h*Scale
			)
			
			progress = self.TargetEntity:GetBuildProgress()
			if progress > 0 then
				surface.SetDrawColor(Colors.Yellow)
				
				surface.DrawRect(
					schm.build_progress.x*Scale,
					schm.build_progress.y*Scale,
					schm.build_progress.w*Scale*progress,
					schm.build_progress.h*Scale
				)
			end
		else
			-- Active
			surface.SetDrawColor(color_white)
			self:PaintActive()
		end
		
		surface.SetDrawColor(color_white)
		-- Upgrade status
		if obj_status_upgrade[level] then
			surface.SetTexture(obj_status_upgrade[level])
			surface.DrawTexturedRect(46*Scale, 4*Scale, 8*Scale, 8*Scale)
		end
	end
end

vgui.Register("HudObjBase", PANEL)
