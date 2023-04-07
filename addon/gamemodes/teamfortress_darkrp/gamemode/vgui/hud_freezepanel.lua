local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local color_panel = {
	[0]=surface.GetTextureID("hud/color_panel_brown"),
	surface.GetTextureID("hud/color_panel_red"),
	surface.GetTextureID("hud/color_panel_blu"),
}
local color_panel_browner = surface.GetTextureID("hud/color_panel_browner")

local default_avatar = surface.GetTextureID("vgui/av_default")

local freezecam_black_bg = surface.GetTextureID("hud/freezecam_black_bg")
local ico_camera = surface.GetTextureID("hud/ico_camera")
local freezecam_callout_arrow = surface.GetTextureID("hud/freezecam_callout_arrow")

local freezecam_black_bg = surface.GetTextureID("hud/freezecam_black_bg")
local leaderboard_nemesis_freezecam = surface.GetTextureID("hud/leaderboard_nemesis_freezecam")

local NemesisLabel = {
	text="",font="HudFontMediumSmall",color=Colors.TanLight,xalign=TEXT_ALIGN_LEFT,yalign=TEXT_ALIGN_CENTER,
	pos={44*Scale, 19*Scale},
}

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(false)
	self.Speed = 400
	self.TargetY = 5
end

function PANEL:PerformLayout()
	self:SetPos(W/2-83*Scale,-50*Scale)
	self:SetSize(166*Scale,40*Scale)
end

function PANEL:Show(delay)
	self:SetVisible(true)
	self.DropDownStart = CurTime() + delay
end

function PANEL:Hide()
	self:SetVisible(false)
	self.DropDownStart = nil
end

function PANEL:Think()
	if self.DropDownStart and CurTime()>self.DropDownStart then
		local y = math.Clamp(-50 + self.Speed * (CurTime()-self.DropDownStart), -50, self.TargetY)
		self:SetPos(W/2-83*Scale, y*Scale)
	end
end

function PANEL:Paint()
	if LocalPlayer().InScreenshot then return end
	
	surface.SetDrawColor(255,255,255,255)
	surface.SetTexture(freezecam_black_bg)
	surface.DrawTexturedRect(0, 8*Scale, 166*Scale, 38*Scale)
	surface.SetTexture(ico_camera)
	surface.DrawTexturedRect(0, 3*Scale, 36*Scale, 36*Scale)
	
	draw.Text{
		text="[F5] Save this moment!",
		font="SpectatorKeyHints",
		pos={40*Scale, (25+6)*Scale},
		xalign=TEXT_ALIGN_LEFT,
		yalign=TEXT_ALIGN_CENTER,
	}
end

if ScreenshotPanel then ScreenshotPanel:Remove() end
ScreenshotPanel = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))

local FreezePanelText = {
	font="TFDefaultSmall",
	pos={40*Scale, 62*Scale},
}

local FreezePanelKillerName = {
	font="HudFontSmall",
	pos={61*Scale, (73+9)*Scale},
	xalign=TEXT_ALIGN_LEFT,
	yalign=TEXT_ALIGN_CENTER,
}
	
function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(false)
	
	self.Avatar = vgui.Create("AvatarImage", self)
	self.HealthCounter = vgui.Create("SpectatorGUIHealth", self)
end

function PANEL:PerformLayout()
	if LocalPlayer().InScreenshot then
		if HudInspectPanel:IsVisible() and HudInspectPanel.Panel then
			local _, height = HudInspectPanel.Panel:GetSize()
			self:SetPos(W-267*Scale,H-height-100*Scale)
		else
			self:SetPos(W-267*Scale,H-100*Scale)
		end
	else
		self:SetPos(W/2-38*Scale,193*Scale)
	end
	self:SetSize(267*Scale,100*Scale)
	
	self.Avatar:SetSize(14*Scale, 14*Scale)
	self.Avatar:SetPos(49*Scale, 74*Scale)
	
	self.HealthCounter:SetPos(8*Scale, 60*Scale)
	
	HudInspectPanel:InvalidateLayout()
end

function PANEL:Show()
	self:CreateFreezeData()
	
	local ent = self.FreezeData.killer
	local killer = self.FreezeData.killerplayer
	
	if killer:IsPlayer() then
		self.Avatar:SetPlayer(killer)
		self.Avatar:SetVisible(true)
		self.CustomAvatarID = nil
	else
		self.Avatar:SetPlayer(NULL)
		self.Avatar:SetVisible(false)
		self.CustomAvatarID = 0
	end
	
	self.HealthCounter:SetTargetEntity(ent, true)
	
	HudInspectPanel:Show()
	
	ScreenshotPanel:PerformLayout()
	ScreenshotPanel:Show(2)
	
	CalloutPanel:Show(2)
	
	self:SetVisible(true)
end

function PANEL:Hide()
	ScreenshotPanel:Hide()
	CalloutPanel:Hide()
	
	HudInspectPanel:Hide()
	
	self:SetVisible(false)
end

function PANEL:CreateFreezeData()
	local death_by_object = (LocalPlayer().Killer ~= LocalPlayer().KillerPlayer)
	
	self.FreezeData = {}
	self.FreezeData.killer = LocalPlayer().Killer or NULL
	self.FreezeData.killerplayer = LocalPlayer().KillerPlayer or NULL
	
	if death_by_object then
		self.FreezeData.killername = GAMEMODE:EntityName(self.FreezeData.killerplayer) or "???"
		if IsValid(self.FreezeData.killer) then
			self.FreezeData.objname = self.FreezeData.killer.ObjectName
		end
	else
		self.FreezeData.killername = LocalPlayer().KillerName or "???"
	end
	self.FreezeData.killerteam = LocalPlayer().KillerTeam or 0
	self.FreezeData.killertype = LocalPlayer().KillerDominationInfo
	if NULL then return false else
		self.FreezeData.alive = self.FreezeData.killerplayer:Health() > 0
	end
end

function PANEL:Paint()
	local killertxt = "#FreezePanel_NoKiller"
	local fd = self.FreezeData
	
	tf_lang.SetGlobal("killername", tf_lang.GetRaw(fd.killername))
	tf_lang.SetGlobal("objectkiller", tf_lang.GetRaw(fd.objname))
	
	if fd.objname then
		if self.FreezeData.killerplayer:Health() > 0 then
			killertxt = "#FreezePanel_KillerObject"
		else
			killertxt = "#FreezePanel_KillerObject_Dead"
		end
	elseif fd.killertype == 1 or fd.killertype == 2 then
		if self.FreezeData.killerplayer:Health() > 0 then
			killertxt = "#FreezePanel_Nemesis"
		else
			killertxt = "#FreezePanel_Nemesis_Dead"
		end
	else
		if self.FreezeData.killerplayer:Health() > 0 then
			killertxt = "#FreezePanel_Killer"
		else
			killertxt = "#FreezePanel_Killer_Dead"
		end
	end
	
	surface.SetDrawColor(255,255,255,255)
	tf_draw.BorderPanel(color_panel[fd.killerteam] or color_panel[0],8*Scale,60*Scale,256*Scale,33*Scale,23,23,5*Scale,5*Scale)
	
	FreezePanelText.text = tf_lang.GetFormatted(killertxt)
	draw.Text(FreezePanelText)
	
	surface.SetFont("HudFontSmall")
	local space = surface.GetTextSize(" ")
	
	FreezePanelKillerName.text = fd.killername
	FreezePanelKillerName.pos[1] = space+61*Scale
	
	draw.Text(FreezePanelKillerName)
	
	if self.CustomAvatarID then
		surface.SetDrawColor(255,255,255,255)
		surface.SetTexture(default_avatar)
		surface.DrawTexturedRect(49*Scale, 74*Scale, 14*Scale, 14*Scale)
	end
end

if FreezePanelBase then FreezePanelBase:Remove() end
FreezePanelBase = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true)
	self:SetParent(FreezePanelBase)
end

function PANEL:PerformLayout()
	self:SetPos(83*Scale, 30*Scale)
	self:SetSize(166*Scale, 38*Scale)
end

function PANEL:Show()
end

function PANEL:Hide()
end

function PANEL:Think()
end

function PANEL:Paint()
	local killertype = LocalPlayer().KillerDominationInfo
	
	if killertype == 0 then return end
	
	if killertype == 1 then
		NemesisLabel.text = tf_lang.GetRaw("#TF_NewNemesis")
	elseif killertype == 2 then
		NemesisLabel.text = tf_lang.GetRaw("#TF_FreezeNemesis")
	elseif killertype == 3 then
		NemesisLabel.text = tf_lang.GetRaw("#TF_GotRevenge")
	end
	
	surface.SetFont(NemesisLabel.font)
	local w = surface.GetTextSize(NemesisLabel.text)
	NemesisLabel.pos[1] = 155*Scale - w
	local x0 = 115*Scale - w
	
	surface.SetDrawColor(color_white)
	--surface.SetTexture(freezecam_black_bg)
	--surface.DrawTexturedRect(x0, 0, 166*Scale - x0, 38*Scale)
	tf_draw.BorderPanel(color_panel_browner, x0, 4*Scale, 166*Scale - x0, 30*Scale,23,23,5*Scale,5*Scale)
	
	surface.SetTexture(leaderboard_nemesis_freezecam)
	surface.DrawTexturedRect(x0, -1*Scale, 36*Scale, 36*Scale)
	
	draw.Text(NemesisLabel)
end

if NemesisSubPanel then NemesisSubPanel:Remove() end
NemesisSubPanel = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))

local GibText = {
	[GIB_RIGHTLEG]		= {"Your foot!"},
	[GIB_RIGHTARM]		= {"Your hand!"},
	[GIB_TORSO]			= {"Your torso!"},
	[GIB_HEAD]			= {"Your head!"},
	[GIB_ORGAN]			= {"Your spleen!", "Your lungs!", "Your pancreas!", "Your kidney!"},
}

CalloutOffsetX = -30
CalloutOffsetY = -60

local function RectangleContains(a, x, y)
	return x > a.x and x < a.x+a.w and y > a.y and y < a.y+a.h
end

local function RectangleIntersects(a, b)
	return
		RectangleContains(b, a.x, a.y) or
		RectangleContains(b, a.x+a.w, a.y) or
		RectangleContains(b, a.x, a.y+a.h) or
		RectangleContains(b, a.x+a.w, a.y+a.h)
end

local function RectangleOverlaps(a, b)
	return
		RectangleContains(b, a.x, a.y) and
		RectangleContains(b, a.x+a.w, a.y) and
		RectangleContains(b, a.x, a.y+a.h) and
		RectangleContains(b, a.x+a.w, a.y+a.h)
end

local function DrawRect(r, col)
	surface.SetDrawColor(col or Color(255,255,255,255))
	surface.DrawLine(r.x, r.y, r.x+r.w, r.y)
	surface.DrawLine(r.x+r.w, r.y, r.x+r.w, r.y+r.h)
	surface.DrawLine(r.x+r.w, r.y+r.h, r.x, r.y+r.h)
	surface.DrawLine(r.x, r.y+r.h, r.x, r.y)
end

local rect_Screen = {x = 0,y = 0,w = W,h = H}
local rect_Panel1a = {x = W/2-38*Scale,y = (193+52)*Scale,w = 267*Scale,h = 48*Scale}
local rect_Panel1b = {x = W-267*Scale,y = H-(100-52)*Scale,w = 267*Scale,h = 48*Scale}
local rect_Panel2 = {x = W/2-83*Scale,y = 5*Scale,w = 166*Scale,h = 40*Scale}

function PANEL:IsVisiblePos(v)
	local tr = util.TraceLine{
		start = EyePos(),
		endpos = v,
	}
	return not tr.Hit
end

function PANEL:IsValidPosition(x, y)
	local box = {
		x = x+(CalloutOffsetX+12)*Scale,
		y = y+(CalloutOffsetY+13)*Scale,
		w = 76*Scale,
		h = (24+10)*Scale,
	}
	
	table.insert(self.DebugRects, box)
	
	local rect_Panel1
	if LocalPlayer().InScreenshot then	rect_Panel1 = rect_Panel1b
	else								rect_Panel1 = rect_Panel1a
	end
	
	if RectangleOverlaps(box, rect_Screen)
	and not RectangleIntersects(box, rect_Panel1)
	and not RectangleIntersects(box, rect_Panel2) then
		local box2
		for _,v in ipairs(self.CalloutPanels) do
			if v.ok then
				box2 = {
					x = v.x+(CalloutOffsetX+12)*Scale,
					y = v.y+(CalloutOffsetY+13)*Scale,
					w = 76*Scale,
					h = (24+10)*Scale,
				}
				if RectangleIntersects(box, box2) then return false end
			end
		end
		return true
	end
	
	return false
end

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(false)
	self.CalloutPanels = {}
	self.DebugRects = {}
end

function PANEL:PerformLayout()
	self:SetPos(0, 0)
	self:SetSize(W, H)
end

function PANEL:Show(delay)
	self.NextShow = CurTime() + (delay or 0)
	self:SetVisible(true)
end

function PANEL:Hide()
	self.Ready = false
	self:SetVisible(false)
end

function PANEL:Think()
	if self.NextShow and CurTime()>self.NextShow then
		self.NextShow = nil
		self.Ready = true
	end
end

function PANEL:SetupCalloutPanels()
	self.CalloutPanels = {}
	self.DebugRects = {}
	
	local rag = LocalPlayer():GetRagdollEntity()
	if IsValid(rag) then
		local pos = rag:GetBoneMatrix(0):GetTranslation()
		if self:IsVisiblePos(pos) then
			local v = pos:ToScreen()
			if v.visible then
				table.insert(self.CalloutPanels, {x=v.x, y=v.y, t="You!", ok=self:IsValidPosition(v.x, v.y)})
			end
		end
	end
	
	for _,ent in pairs(ents.FindByClass("class CLuaEffect")) do
		if not ent.Done and ent.GibOwner==LocalPlayer() and ent.GibType and GibText[ent.GibType] then
			local att = ent:GetAttachment(ent:LookupAttachment("bloodpoint"))
			if att and self:IsVisiblePos(att.Pos) then
				local t = GibText[ent.GibType]
				local v = att.Pos:ToScreen()
				if v.visible then
					table.insert(self.CalloutPanels, {x=v.x, y=v.y, t=t[math.random(1,#t)], ok=self:IsValidPosition(v.x, v.y)})
				end
			end
			ent.Done = true
		end
	end
	
	--PrintTable(self.CalloutPanels)
end

function PANEL:RefreshCalloutPanels()
	for _,v in ipairs(self.CalloutPanels) do
		v.ok = self:IsValidPosition(v.x, v.y)
	end
end

function PANEL:Flash(dur)
	self.FlashDuration = dur
	self.NextFlashEnd = CurTime() + dur
	LocalPlayer():EmitSound("Camera.SnapShot")
end

function PANEL:Paint()
	--[[
	DrawRect(rect_Panel1a, Color(255,0,0,255))
	DrawRect(rect_Panel1b, Color(255,0,0,255))
	DrawRect(rect_Panel2, Color(0,255,0,255))
	
	for _,v in ipairs(self.DebugRects) do
		DrawRect(v, Color(0,0,255,255))
	end]]
	
	if not self.Ready then return end
	
	local killerteam = LocalPlayer().KillerTeam or 0
	
	for _,v in ipairs(self.CalloutPanels) do
		if v.ok then
			local x = v.x + CalloutOffsetX*Scale
			local y = v.y + CalloutOffsetY*Scale
			
			surface.SetDrawColor(255,255,255,255)
			tf_draw.BorderPanel(color_panel[killerteam] or color_panel[0],x+12*Scale,y+13*Scale,76*Scale,24*Scale,23,23,5*Scale,5*Scale)
			
			surface.SetTexture(freezecam_callout_arrow)
			surface.DrawTexturedRect(x+20*Scale, y+35*Scale, 20*Scale, 10*Scale)
			
			draw.Text{
				text=v.t,
				font="HudFontSmall",
				pos={x+(15+35)*Scale, y+(15+10)*Scale},
				xalign=TEXT_ALIGN_CENTER,
				yalign=TEXT_ALIGN_CENTER,
			}
		end
	end
	
	if self.NextFlashEnd then
		if CurTime()>self.NextFlashEnd then
			self.NextFlashEnd = nil
		else
			local a = 255 * (self.NextFlashEnd - CurTime())/self.FlashDuration
			surface.SetDrawColor(255,255,255,a)
			surface.DrawRect(0, 0, W, H)
		end
	end
end

if CalloutPanel then CalloutPanel:Remove() end
CalloutPanel = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))