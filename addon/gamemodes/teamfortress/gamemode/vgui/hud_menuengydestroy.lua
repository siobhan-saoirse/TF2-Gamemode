
local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local hud_menu_bg = surface.GetTextureID("hud/eng_build_bg")
local hud_menu_item_bg = surface.GetTextureID("hud/eng_sel_item_active")
local ico_build = surface.GetTextureID("hud/ico_demolish")
local ico_metal = surface.GetTextureID("hud/ico_metal_mask")
local ico_key_blank = surface.GetTextureID("hud/ico_key_blank")

local hud_menu_sentry_build = surface.GetTextureID("hud/hud_obj_status_sentry_1")
local hud_menu_dispenser_build = surface.GetTextureID("hud/hud_obj_status_dispenser")
local hud_menu_tele_entrance_build = surface.GetTextureID("hud/hud_obj_status_tele_entrance")
local hud_menu_tele_exit_build = surface.GetTextureID("hud/hud_obj_status_tele_exit")

local BUILDINGS = { 
	{"#TF_Object_Sentry", 				hud_menu_sentry_build},
	{"#TF_Object_Dispenser", 			hud_menu_dispenser_build},
	{"#TF_Object_Tele_Entrance_360", 	hud_menu_tele_entrance_build},
	{"#TF_Object_Tele_Exit_360", 		hud_menu_tele_exit_build},
}

function PANEL:Init()
	self:SetVisible(true)
	self:SetPaintBackgroundEnabled(false)
end

function PANEL:PerformLayout()
end

function PANEL:Paint(wid, hei)
	if not IsCustomHUDVisible("HudEngyMenuDestroy") then
		return
	end

	if LocalPlayer():GetNWBool("Taunting") then
		return
	end
	
	local slot = self.slot or 1
	
	-- Name
	draw.Text{
		text=tf_lang.GetRaw(BUILDINGS[slot][1]),
		font="TFDefault",
		pos={(6)*Scale, (0+7.5)*Scale},
		color=Colors.TanLight,
		xalign=TEXT_ALIGN_LEFT,
		yalign=TEXT_ALIGN_CENTER,
	}
	
	-- Background
	surface.SetDrawColor(Colors.ProgressOffWhite)

	tf_draw.TexturedQuadPart(hud_menu_item_bg, (4-8)*Scale, (14-8)*Scale, (98+16)*Scale, (105+16)*Scale, 1, 1, 14, 15)

	-- Building blueprint
	surface.SetDrawColor(255,255,255,255)
	surface.SetTexture(BUILDINGS[slot][2])

	local ents = ents.FindByClass("obj_*")

	local sentryd = false 
	local dispd = false 
	local teleed = false 
	local telexd = false 

	for k, v in pairs(ents) do
		if v:GetBuilder() == LocalPlayer() then
			if v:GetClass() == "obj_sentrygun" then
				sentryd = true
			elseif v:GetClass() == "obj_dispenser" then
				dispd = true
			elseif v:GetClass() == "obj_teleporter" and v:IsEntrance() then
				teleed = true
			elseif v:GetClass() == "obj_teleporter" and v:IsExit() then
				telexd = true
			end
		end
	end

	if slot == 1 then -- THIS AINT IT CHIEF
		if sentryd then
			surface.SetDrawColor(255,255,255,255)
			surface.SetTexture(ico_build)
			surface.DrawTexturedRect(12*Scale, 18*Scale, 72*Scale, 72*Scale)
			surface.SetTexture(BUILDINGS[slot][2])
			surface.DrawTexturedRect(12*Scale, 3*Scale, 84*Scale, 84*Scale)
		else
			draw.Text{
				text="Not Built",
				font="TFDefault",
				pos={48*Scale, 52*Scale},
				color=Colors.ProgressOffWhite,
				xalign=TEXT_ALIGN_CENTER,
				yalign=TEXT_ALIGN_CENTER,
			}
		end
	elseif slot == 2 then
		if dispd then
			surface.SetDrawColor(255,255,255,255)
			surface.SetTexture(ico_build)
			surface.DrawTexturedRect(12*Scale, 18*Scale, 72*Scale, 72*Scale)
			surface.SetTexture(BUILDINGS[slot][2])
			surface.DrawTexturedRect(12*Scale, 18*Scale, 78*Scale, 78*Scale)
		else -- yeah this is big brain time
			draw.Text{
				text="Not Built",
				font="TFDefault",
				pos={48*Scale, 52*Scale},
				color=Colors.ProgressOffWhite,
				xalign=TEXT_ALIGN_CENTER,
				yalign=TEXT_ALIGN_CENTER,
			}
		end
	elseif slot == 3 then
		if teleed then
			surface.SetDrawColor(255,255,255,255)
			surface.SetTexture(ico_build)
			surface.DrawTexturedRect(12*Scale, 18*Scale, 72*Scale, 72*Scale)
			surface.SetTexture(BUILDINGS[slot][2])
			surface.DrawTexturedRect(18*Scale, 26*Scale, 64*Scale, 64*Scale)
		else
			draw.Text{
				text="Not Built",
				font="TFDefault",
				pos={48*Scale, 52*Scale},
				color=Colors.ProgressOffWhite,
				xalign=TEXT_ALIGN_CENTER,
				yalign=TEXT_ALIGN_CENTER,
			}
		end
	elseif slot == 4 then
		if telexd then
			surface.SetDrawColor(255,255,255,255)
			surface.SetTexture(ico_build)
			surface.DrawTexturedRect(12*Scale, 18*Scale, 72*Scale, 72*Scale)
			surface.SetTexture(BUILDINGS[slot][2])
			surface.DrawTexturedRect(18*Scale, 26*Scale, 64*Scale, 64*Scale)
		else
			draw.Text{
				text="Not Built",
				font="TFDefault",
				pos={48*Scale, 52*Scale},
				color=Colors.ProgressOffWhite,
				xalign=TEXT_ALIGN_CENTER,
				yalign=TEXT_ALIGN_CENTER,
			}
		end
	end
	
	-- Metal indicator
	surface.SetDrawColor(Colors.TanDarker)
	surface.SetTexture(ico_metal)
	--surface.DrawTexturedRect(10*Scale, 18*Scale, 10*Scale, 10*Scale)
	
	--[[draw.Text{
		text=150,
		font="HudFontSmall",
		pos={(23)*Scale, (17+6.5)*Scale},
		color=Colors.TanDarker,
		xalign=TEXT_ALIGN_LEFT,
		yalign=TEXT_ALIGN_CENTER,
	}]]
	
	-- Key
	surface.SetDrawColor(255,255,255,255)
	surface.SetTexture(ico_key_blank)
	surface.DrawTexturedRect(41*Scale, 99*Scale, 18*Scale, 18*Scale)
	
	draw.Text{
		text=slot,
		font="TFDefault",
		pos={(0+50)*Scale, (98+9)*Scale},
		color=Colors.Black,
		xalign=TEXT_ALIGN_CENTER,
		yalign=TEXT_ALIGN_CENTER,
	}
end

vgui.Register("HudEngyMenuDestroyItem", PANEL)

PANEL = {}

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true)
	
	self.Panels = {}
	for i=1,4 do
		local t = vgui.Create("HudEngyMenuDestroyItem", self)
		t.slot = i
		self.Panels[i] = t
	end
end

function PANEL:PerformLayout()
	self:SetPos(W/2 - 225*Scale, H/2 - 55*Scale)
	self:SetSize(450*Scale, 195*Scale)
	
	for i=1,4 do
		self.Panels[i]:SetPos((25+100*(i-1))*Scale, 47*Scale)
		self.Panels[i]:SetSize(100*Scale, 124*Scale)
	end
end

function PANEL:Paint()
	if not IsCustomHUDVisible("HudEngyMenuDestroy") then
		return
	end

	if LocalPlayer():GetNWBool("Taunting") then
		return
	end
	
	surface.SetDrawColor(255,255,255,255)
	tf_draw.TexturedQuadPart(hud_menu_bg, (0-16)*Scale, (10-16)*Scale, (450+32)*Scale, (170+32)*Scale, 0, 0, 32, 13)
	
	surface.SetTexture(ico_build)
	surface.SetDrawColor(0,0,0,255)
	surface.DrawTexturedRect(-2*Scale, -6*Scale, 64*Scale, 64*Scale)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(-2*Scale, -7*Scale, 64*Scale, 64*Scale)
	
	local txt = {
		text=tf_lang.GetRaw("#Hud_menu_demolish_title"),
		font="HudFontGiantBold",
		pos={29*Scale, 22*Scale},
		color=Colors.Black,
		xalign=TEXT_ALIGN_LEFT,
		yalign=TEXT_ALIGN_CENTER,
	}
	
	draw.Text(txt)
	
	txt.pos = {28*Scale, 20*Scale}
	txt.color = Colors.TanLight
	draw.Text(txt)

	local cantext = tf_lang.GetRaw("#Hud_Menu_Build_Cancel")
	local competitive = GetConVar("tf_competitive"):GetBool()
	if competitive then
		cantext = string.Replace(cantext, "%lastinv%", input.LookupBinding("+menu"))
	else
		cantext = string.Replace(string.Replace(cantext, "%lastinv%", input.LookupBinding("lastinv")), "''", "'UNBOUND'")
	end

	draw.Text{
		text=cantext,
		font="SpectatorKeyHints",
		pos={(218+200)*Scale, (35+6.5)*Scale},
		xalign=TEXT_ALIGN_RIGHT,
		yalign=TEXT_ALIGN_CENTER,
	}
	
end

if HudEngyMenuDestroy then HudEngyMenuDestroy:Remove() end
HudEngyMenuDestroy = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
