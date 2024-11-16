
local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

HBAR_SCALE = Vector(0.75, 1, 1)
HBAR_MIN = Vector(1, 0, 0)
HBAR_MAX = Vector(0.1, 0, 0)

VBAR_SCALE = Vector(1, 0.75, 1)
VBAR_MIN = Vector(0, 0.1, 0)
VBAR_MAX = Vector(0, 1, 0)

CPICON_PULSESPEED = 5
YOFFSET = -256

local cp_white = surface.GetTextureID("sprites/obj_icons/icon_obj_white")
local cp_highlight = surface.GetTextureID("sprites/obj_icons/capture_highlight")

local cp_hbar_2 = Material("sprites/obj_icons/icon_obj_cap_red")
cp_hbar_2:SetInt("$separatedetailuvs", 0)
cp_hbar_2:SetInt("$detailscale", 1)
local cp_hbar_3 = Material("sprites/obj_icons/icon_obj_cap_blu")
cp_hbar_3:SetInt("$separatedetailuvs", 0)
cp_hbar_3:SetInt("$detailscale", 1)
local cp_hbars = {[2]=cp_hbar_2, [3]=cp_hbar_3}

local cp_vbar_2 = Material("sprites/obj_icons/icon_obj_cap_red_up")
cp_vbar_2:SetInt("$separatedetailuvs", 0)
cp_vbar_2:SetInt("$detailscale", 1)
local cp_vbar_3 = Material("sprites/obj_icons/icon_obj_cap_blu_up")
cp_vbar_3:SetInt("$separatedetailuvs", 0)
cp_vbar_3:SetInt("$detailscale", 1)
local cp_vbars = {[2]=cp_vbar_2, [3]=cp_vbar_3}



local progress_bar					= surface.GetTextureID("vgui/progress_bar")
local progress_bar_red				= surface.GetTextureID("vgui/progress_bar_red")
local progress_bar_blu				= surface.GetTextureID("vgui/progress_bar_blu")
local progress_bar_noCap			= surface.GetTextureID("vgui/progress_bar_noCap")
local progress_bar_pointer			= surface.GetTextureID("vgui/progress_bar_pointer")
local progress_bar_pointer_left		= surface.GetTextureID("vgui/progress_bar_pointer_left")
local progress_bar_pointer_right	= surface.GetTextureID("vgui/progress_bar_pointer_right")

PROGRESS_OFFSET_X = -34
PROGRESS_OFFSET_Y = -65
PROGRESS_OFFSET_LEFT_X = -77
PROGRESS_OFFSET_LEFT_Y = -54
PROGRESS_OFFSET_RIGHT_X = 10
PROGRESS_OFFSET_RIGHT_Y = -54

local function FindCPLayoutPosition(n)
	for j,v in ipairs(GAMEMODE.ControlPointLayout) do
		for i,w in ipairs(v) do
			if w == n then
				return j,i
			end
		end
	end
end

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true)
end

function PANEL:PerformLayout()
	if not IsValid(LocalPlayer()) then return end
	
	self:SetPos(0,0)
	self:SetSize(W,H)
end

function PANEL:UpdateProgress(i)
	local m = Matrix()
	m:Translate(LerpVector(self.ControlPoints[i], HBAR_MIN, HBAR_MAX))
	m:Scale(HBAR_SCALE)
	cp_hbar:SetMaterialMatrix("$basetexturetransform", m)
end

function PANEL:DrawControlPoint(i, x, y)
	local cp = GAMEMODE.ControlPoints[i]
	if not cp then return end
	
	surface.SetDrawColor(255,255,255,255)
	
	if cp.tex_icon>=0 then
		surface.SetTexture(cp.tex_icon)
		surface.DrawTexturedRect(x, y, 33*Scale, 33*Scale)
	end
	
	if cp.tex_overlay>=0 then
		surface.SetTexture(cp.tex_overlay)
		surface.DrawTexturedRect(x+19*Scale, y, 14*Scale, 14*Scale)
	end
end

function PANEL:DrawControlPointProgress(i, x, y)
	local pos = 0
	surface.SetDrawColor(255,255,255,255)
	
	local p, q = FindCPLayoutPosition(i)
	if p then
		if GAMEMODE.ControlPointLayout[p-1] then
			pos = 1
			if GAMEMODE.ControlPointLayout[p][q+1] then
				pos = -1
			end
		end
	end
	
	if pos==0 then
		x = x + PROGRESS_OFFSET_X*Scale
		y = y + PROGRESS_OFFSET_Y*Scale
		
		surface.SetTexture(progress_bar_pointer)
		surface.DrawTexturedRect(x+24*Scale, y, 54*Scale, 108*Scale)
		surface.SetTexture(progress_bar_noCap)
		surface.DrawTexturedRect(x+26*Scale, y+3*Scale, 50*Scale, 50*Scale)
	elseif pos<0 then
		x = x + PROGRESS_OFFSET_LEFT_X*Scale
		y = y + PROGRESS_OFFSET_LEFT_Y*Scale
		surface.SetTexture(progress_bar_pointer_left)
		surface.DrawTexturedRect(x+24*Scale, y, 54*Scale, 54*Scale)
		
		y = y-1.5*Scale
		surface.SetTexture(progress_bar_noCap)
		surface.DrawTexturedRect(x+26*Scale, y+3*Scale, 50*Scale, 50*Scale)
	else
		x = x + PROGRESS_OFFSET_RIGHT_X*Scale
		y = y + PROGRESS_OFFSET_RIGHT_Y*Scale
		surface.SetTexture(progress_bar_pointer_right)
		surface.DrawTexturedRect(x+24*Scale, y, 54*Scale, 54*Scale)
		
		y = y-1.5*Scale
		surface.SetTexture(progress_bar_noCap)
		surface.DrawTexturedRect(x+26*Scale, y+3*Scale, 50*Scale, 50*Scale)
	end
	
	tf_draw.LabelTextWrap{
		x=x+15*Scale,y=y+8*Scale,
		w=75*Scale,h=40*Scale,
		font="TFDefaultSmall",
		text="Defend\nthis point.",
		align="center",
	}
end

function PANEL:Paint()
	--[[
	tf_draw.LabelTextWrap{
		x=10,y=10,
		w=400,h=200,
		font="HudFontSmall",
		text="Once upon a time, there was a huge cumming penis and it went kaboom. The End.",
		align="center",
	}
	tf_draw.LabelTextWrap{
		x=10+420,y=10,
		w=400,h=200,
		font="HudFontSmall",
		text="Once upon a time\nthere was a huge cumming penis and it went kaboom.\nThe End.",
		align="center",
	}]]
	
	if not GAMEMODE.ControlPoints or not GAMEMODE.ControlPointLayout then return end
	
	local progress_x, progress_y, progress_n
	
	local y = H
	for j=#(GAMEMODE.ControlPointLayout),1,-1 do
		local v = GAMEMODE.ControlPointLayout[j]
		x = W/2 - (#v*33*Scale + (#v-1)*7*Scale)/2
		y = y - (33+7)*Scale
		for _,n in ipairs(v) do
			self:DrawControlPoint(n, x, y)
			if n==LocalPlayer().CurrentControlPoint then
				progress_x, progress_y, progress_n = x, y, n
			end
			x = x + (33+7)*Scale
		end
	end
	
	if progress_n then
		self:DrawControlPointProgress(progress_n, progress_x, progress_y)
	end
		
	
	--[[for i,v in ipairs(self.ControlPoints) do
		local x = 10+(128+10)*(i-1)
		local y = 800
		
		
		surface.SetDrawColor(255,255,255,255)
		surface.SetTexture(cp_blu)
		surface.DrawTexturedRect(x, y, 128, 128)
		
		surface.SetDrawColor(255,255,255,math.abs(math.sin(CPICON_PULSESPEED * CurTime()))*255)
		surface.SetTexture(cp_white)
		surface.DrawTexturedRect(x, y, 128, 128)
		
		render.SetScissorRect(x+7, y-512, x+7+128-14, y+110, true)
		surface.SetDrawColor(255,255,255,255)
		surface.SetTexture(cp_highlight)
		surface.DrawTexturedRect(x+7, y+YOFFSET, 128-14, 512)
		render.SetScissorRect(0, 0, 0, 0, false)
		
		surface.SetDrawColor(255,255,255,255)
		self:UpdateProgress(i)
		surface.SetMaterial(cp_hbar)
		surface.DrawTexturedRect(x, y, 128, 128)
	end]]
end

if ControlPointTest then ControlPointTest:Remove() end
ControlPointTest = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
