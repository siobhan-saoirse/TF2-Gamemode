
local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local SNIPERSCOPE_MIN = -0.75
local SNIPERSCOPE_MAX = -2.782
local SNIPERSCOPE_SCALE = 0.4
local sniperscope_mat = Material("hud/sniperscope_numbers")
local sniperscope_mat2 = Material("hud/sniperscope_numbers_jar")

local scope_sniper_ul = surface.GetTextureID("HUD/scope_sniper_ul")
local scope_sniper_ur = surface.GetTextureID("HUD/scope_sniper_ur")
local scope_sniper_ll = surface.GetTextureID("HUD/scope_sniper_ll")
local scope_sniper_lr = surface.GetTextureID("HUD/scope_sniper_lr")

local cx, cy = ScrW()/2, ScrH()/2
local w, h = 320*Scale, 240*Scale

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(false)
	self:SetProgress(0)
end

function PANEL:PerformLayout()
	if not IsValid(LocalPlayer()) then return end
	
	self:SetPos(0,0)
	self:SetSize(W,H)
end

function PANEL:SetProgress(e)
	if e < 0 then
		self.HideCharge = true
	else
		self.HideCharge = false
		
		if not matproxy then
			local m = Matrix()
			m:Scale(Vector(1,SNIPERSCOPE_SCALE,1))
			m:Translate(Vector(0,Lerp(e/100,SNIPERSCOPE_MIN,SNIPERSCOPE_MAX),0))
			sniperscope_mat:SetMatrix("$basetexturetransform", m)
			sniperscope_mat2:SetMatrix("$basetexturetransform", m)
		end
	end
	
	LocalPlayer().ProxySniperCharge = e
end

function PANEL:Paint()
	if self.HideCharge then return end
	
	surface.SetDrawColor(255,255,255,255)
	
	local w = LocalPlayer():GetActiveWeapon()

	if LocalPlayer():GetObserverTarget() and LocalPlayer():GetObserverTarget():IsPlayer() then
		w = LocalPlayer():GetObserverTarget():GetActiveWeapon()
	end

	if IsValid(w) and w.UsesJarateChargeMeter then
		surface.SetMaterial(sniperscope_mat2)
	else
		surface.SetMaterial(sniperscope_mat)
	end
	
	surface.DrawTexturedRect(cx+64*Scale, cy-64*Scale, 64*Scale, 128*Scale)
end

if HudSniperChargeMeter then HudSniperChargeMeter:Remove() end
HudSniperChargeMeter = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))

hook.Add("HUDPaintBackground", "SniperScopeDraw", function()
	if IsValid(HudSniperChargeMeter) and HudSniperChargeMeter:IsVisible() then
		if cx-w>0 then
			surface.SetDrawColor(0,0,0,255)
			surface.DrawRect(0, 0, cx-w, H)
			surface.DrawRect(cx+w, 0, cx-w, H)
		end
		
		render.UpdateRefractTexture()
		surface.SetDrawColor(255,255,255,255)
		surface.SetTexture(scope_sniper_ul) surface.DrawTexturedRect(cx - w, cy - h, w, h)
		surface.SetTexture(scope_sniper_ur) surface.DrawTexturedRect(cx    , cy - h, w, h)
		surface.SetTexture(scope_sniper_ll) surface.DrawTexturedRect(cx - w, cy    , w, h)
		surface.SetTexture(scope_sniper_lr) surface.DrawTexturedRect(cx    , cy    , w, h)
	end
end)
