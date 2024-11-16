local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local medic_charge_bg = {
	surface.GetTextureID("hud/medic_charge_red_bg"),
	surface.GetTextureID("hud/medic_charge_blue_bg"),
}

local ico_health_cluster = surface.GetTextureID("hud/ico_health_cluster")

local function LerpColor(r,a,b)
	return Color(
		Lerp(r,a.r,b.r),
		Lerp(r,a.g,b.g),
		Lerp(r,a.b,b.b),
		Lerp(r,a.a,b.a)
	)
end

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true)
end

function PANEL:PerformLayout()
	self:SetPos(W-138*Scale,H-69*Scale)
	self:SetSize(200*Scale,100*Scale)
end

function PANEL:Paint()
	if not LocalPlayer():Alive() or GetConVar("tf_forcehl2hud"):GetBool() or GetConVarNumber("cl_drawhud")==0 or LocalPlayer():GetPlayerClass() == "merc_dm" then return end
	if not IsCustomHUDVisible("HudMedicChargeMachinery") then
		return
	end
	
	local n = LocalPlayer():GetNWInt("Ubercharge") or 0
	local t = LocalPlayer():Team()
	
	local tex = medic_charge_bg[t] or medic_charge_bg[1]
	surface.SetDrawColor(255,255,255,255)
	
	surface.SetTexture(tex)
	surface.DrawTexturedRect(0, 0, 130*Scale, 65*Scale)
	
	surface.SetTexture(ico_health_cluster)
	surface.DrawTexturedRect(2*Scale, 17*Scale, 36*Scale, 36*Scale)
	
	local ubercolor
	if n>=200 then
		if not self.FullChargeTime then
			self.FullChargeTime = CurTime()
		end
		ubercolor = LerpColor(math.abs(math.cos(6*(CurTime()-self.FullChargeTime))), Colors.Black, Colors.Yellow)
	else
		self.FullChargeTime = nil
	end
	
	tf_lang.SetGlobal("charge", n)
	
	local param = {
		text=tf_lang.GetFormatted("TF_Ubercharge"),
		font="HudFontSmallest",
		pos={30*Scale, (24+7)*Scale},
		color=ubercolor or Colors.Yellow,
		xalign=TEXT_ALIGN_LEFT,
		yalign=TEXT_ALIGN_CENTER,
	}
	draw.Text(param)
	
	if ubercolor then
		surface.SetDrawColor(ubercolor)
		surface.DrawRect(30*Scale, 38*Scale, 86*Scale, 8*Scale)
	else
		surface.SetDrawColor(Colors.TransparentYellow)
		surface.DrawRect(30*Scale, 38*Scale, 86*Scale, 8*Scale)
		
		surface.SetDrawColor(Colors.Yellow)
		surface.DrawRect(30*Scale, 38*Scale, Lerp(n/100,0,86)*Scale, 8*Scale)
	end
end

if HudMedicChargeMachinery then HudMedicChargeMachinery:Remove() end
HudMedicChargeMachinery = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
