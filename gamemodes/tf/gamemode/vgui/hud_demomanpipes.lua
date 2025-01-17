local PANEL = {}

local W = ScrW()
local H = ScrH()
local Scale = H/480

local ChargeMeterHigh = Color(155,221,149,255)
local ChargeMeterMedium = Color(244,175,11,255)
local ChargeMeterLow = Color(255,67,16,255)

local misc_ammo_area = {
	surface.GetTextureID("hud/misc_ammo_area_blue"),
	surface.GetTextureID("hud/misc_ammo_area_red"),
	surface.GetTextureID("hud/misc_ammo_area_blue"),
}

local ico_stickybomb = {
	surface.GetTextureID("hud/ico_stickybomb_blue"),
	surface.GetTextureID("hud/ico_stickybomb_red"),
	surface.GetTextureID("hud/ico_stickybomb_blue"),
}

local ico_stickybomb_faded = {
	surface.GetTextureID("hud/ico_stickybomb_blue_faded"),
	surface.GetTextureID("hud/ico_stickybomb_red_faded"),
	surface.GetTextureID("hud/ico_stickybomb_blue_faded"),
}

local ChargeLabel = {
	text="",
	font="TFFontSmall",
	pos={45.5*Scale, 34.5*Scale},
	xalign=TEXT_ALIGN_CENTER,
	yalign=TEXT_ALIGN_CENTER,
}

local NumPipes = {
	text="",
	font="HudFontMedium",
	pos={50*Scale, 28*Scale},
	color=Colors.TanLight,
	xalign=TEXT_ALIGN_LEFT,
	yalign=TEXT_ALIGN_CENTER,
}

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true)
	self.Progress = 0
	self.MeterColor = Colors.Yellow
end

function PANEL:PerformLayout()
	self:SetPos(W-162*Scale,H-52*Scale)
	self:SetSize(100*Scale,50*Scale)
end

function PANEL:SetChargeStatus(s)
	if s==1 then
		self.MeterColor = ChargeMeterHigh
	elseif s==2 then
		self.MeterColor = ChargeMeterMedium
	elseif s==3 then
		self.MeterColor = ChargeMeterLow
	else
		self.MeterColor = Colors.Yellow
	end
end

function PANEL:SetProgress(p)
	self.Progress = math.Clamp(p, 0, 1)
end

function PANEL:Paint()
	if not LocalPlayer():Alive() or GetConVar("tf_forcehl2hud"):GetBool() or GetConVarNumber("cl_drawhud")==0 then return end
	
	local vis_pipes = IsCustomHUDVisible("HudDemomanPipes")
	local vis_charge = IsCustomHUDVisible("HudDemomanCharge")
	local vis_cloak = IsCustomHUDVisible("HudSpyCloak")
	
	if not vis_pipes and not vis_charge and not vis_cloak then return end
	
	local t = LocalPlayer():Team()
	
	local tex = misc_ammo_area[t] or misc_ammo_area[1]
	surface.SetDrawColor(255,255,255,255)
	
	surface.SetTexture(tex)
	surface.DrawTexturedRect(12*Scale, 6*Scale, 76*Scale, 38*Scale)
	
	if vis_pipes then
		local n = LocalPlayer():GetNWInt("NumBombs") or 0
		
		if n==0 then
			tex = ico_stickybomb_faded[t] or ico_stickybomb_faded[1]
			surface.SetTexture(tex)
		else
			tex = ico_stickybomb[t] or ico_stickybomb[1]
			surface.SetTexture(tex)
		end
		surface.DrawTexturedRect(26*Scale, 16*Scale, 20*Scale, 20*Scale)
		
		NumPipes.text = n
		tf_draw.ShadedText(NumPipes)
	elseif vis_charge then
		ChargeLabel.text = tf_lang.GetRaw("#TF_Charge")
		draw.Text(ChargeLabel)
		
		surface.SetDrawColor(Colors.TransparentYellow)
		surface.DrawRect(25*Scale, 23*Scale, 40*Scale, 6*Scale)
		
		if self.Progress > 0 then
			surface.SetDrawColor(self.MeterColor)
			surface.DrawRect(25*Scale, 23*Scale, 40*Scale*self.Progress, 6*Scale)
		end
	elseif vis_cloak then
		ChargeLabel.text = "CLOAK"
		draw.Text(ChargeLabel)
		
		surface.SetDrawColor(Colors.TransparentYellow)
		surface.DrawRect(25*Scale, 23*Scale, 40*Scale, 6*Scale)
		
		if self.Progress > 0 then
			surface.SetDrawColor(self.MeterColor)
			surface.DrawRect(25*Scale, 23*Scale, 40*Scale*self.Progress, 6*Scale)
		end
	end
end

if HudDemomanPipes then HudDemomanPipes:Remove() end
HudDemomanPipes = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
