local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local hud_targetid_numerichealth = CreateConVar("hud_targetid_numerichealth", "1")

local color_panel = {
	[0]=surface.GetTextureID("hud/color_panel_brown"),
	surface.GetTextureID("hud/color_panel_red"),
	surface.GetTextureID("hud/color_panel_blu"),
	surface.GetTextureID("hud/color_panel_ylw"),
	surface.GetTextureID("hud/color_panel_grn"),
}

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(false)
end

function PANEL:PerformLayout()
	if not IsValid(self.Target) then
		self:SetPos(W/2-126*WScale,250*Scale)
		self:SetSize(252*WScale,50*Scale)
	else
		local slot = self.Slot
			while HudTargetIDs[slot-1] and not HudTargetIDs[slot-1]:IsVisible() do
				slot = slot - 1
			end
		surface.SetFont("HudFontMediumSmallSecondary")
		local w = surface.GetTextSize(GAMEMODE:EntityTargetIDName(self.Target)) + 44*Scale
		if self.Text then
			w = w + surface.GetTextSize(self.Text)
		end
		
		self:SetSize(w, 50*Scale)
		self:SetPos((W-w)/2, (250 + 50 * (slot-1))*Scale)
	end
end

function PANEL:SetTargetEntity(e)
	self.Target = e
	
	if not self.HealthCounter then
		self.HealthCounter = vgui.Create("SpectatorGUIHealth")
		self.HealthCounter:SetParent(self)
		self.HealthCounter:SetPos(3*Scale,2*Scale)

	end
	
	for _,v in ipairs(HudTargetIDs) do v:InvalidateLayout() end
	self.HealthCounter:SetTargetEntity(e)
end

function PANEL:Paint()
	if GetConVarNumber("cl_drawhud")==0 then return end
	
	if not IsValid(self.Target) then
		return
	end
	
	local health = self.Target:GetNWFloat("Health") or self.Target:Health() or 0
	local maxhealth = self.Target:GetNWFloat("MaxHealth") or 1
	surface.SetDrawColor(255,255,255,255)
		tf_draw.BorderPanel(color_panel[self.Target:EntityTeam()] or color_panel[0],0,0,self:GetWide(),35*Scale,23,23,5*Scale,5*Scale)
	
	local tbl = {
		font="HudFontMediumSmallSecondary",
		pos={34*Scale, 4*Scale},
		color=Colors.TanLight,
		x_align=TEXT_ALIGN_LEFT,
		y_align=TEXT_ALIGN_TOP,
	}
	if self.Text then
		tbl.text = self.Text
		draw.Text(tbl)
		
		surface.SetFont(tbl.font)
		tbl.pos[1] = tbl.pos[1] + surface.GetTextSize(self.Text)
	end
	
	--tbl.text = GAMEMODE:EntityName(self.Target)
	if self.Target:GetClass() == "reviver" then
		tbl.text = GAMEMODE:EntityTargetIDName(self.Target:GetOwner())
		draw.Text(tbl)
	elseif self.Target:IsNextBot() then
		tbl.text = GAMEMODE:EntityTargetIDName(self.Target)
		draw.Text(tbl)	
	else
		tbl.text = GAMEMODE:EntityTargetIDName(self.Target)
		draw.Text(tbl)	
	end
	if hud_targetid_numerichealth:GetBool() then
		local health
		local maxhealth = 100
		
		--[[
		if self.Target:IsPlayer() then
			health = self.Target:Health()
			
			local tbl = self.Target:GetPlayerClassTable()
		
			if tbl and tbl.Health then
				maxhealth = tbl.Health
			end
		else
			health = self.Target:GetNWFloat("Health") or 0
			maxhealth = self.Target:GetNWFloat("MaxHealth") or 1
		end
		
		if maxhealth==0 then
			health, maxhealth = 1,1
		end]]
		
		health, maxhealth = self.Target:Health(), self.Target:GetMaxHealth()
		
		draw.Text{
			text=health.."/"..maxhealth,
			font="TFFontMedium",
			pos={34*Scale, (17+3.5)*Scale},
			color=Colors.TanLight,
			x_align=TEXT_ALIGN_LEFT,
			y_align=TEXT_ALIGN_CENTER,
			
		}
	elseif self.Target.IsTFBuilding then
		draw.Text{
			text=self.Target:GetTargetIDSubText(),
			font="TFFontMedium",
			pos={34*Scale, (17+3.5)*Scale},
			color=Colors.TanLight,
			x_align=TEXT_ALIGN_LEFT,
			y_align=TEXT_ALIGN_CENTER,
		}
	end
end

if HudTargetID then HudTargetID:Remove() end
HudTargetID = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
HudTargetID.Slot = 1

if HudHealingTargetID then HudHealingTargetID:Remove() end
HudHealingTargetID = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
HudHealingTargetID.Text = "Healing : "
HudHealingTargetID.Slot = 2

if HudHealerTargetID then HudHealerTargetID:Remove() end
HudHealerTargetID = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
HudHealerTargetID.Text = "Healer : "
HudHealerTargetID.Slot = 3

HudTargetIDs = {HudTargetID, HudHealingTargetID, HudHealerTargetID}
