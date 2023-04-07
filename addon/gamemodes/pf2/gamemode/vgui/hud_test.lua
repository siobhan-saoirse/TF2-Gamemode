local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480
--[[
local mat = CreateMaterial("sniperscope", "UnlitTwoTexture_DX9", {
	["$basetexture"] = "HUD/sniperscope_numbers",
	["$texture2"] = "HUD/sniperscope_numbers2",
	["$translucent"] = 1,
	["$additive"] = 1,
	["$ignorez"] = 1,
	["$nofog"] = 1,
})

local sniperscope_numbers = surface.GetTextureID("sniperscope")]]

MAT = Material("hud/sniperscope_numbers")

--local sniperscope_numbers = surface.GetTextureID("hud/sniperscope_numbers")
--local sniperscope_numbers_mat = Material("hud/sniperscope_numbers")

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true)
end

function PANEL:PerformLayout()
	if !IsValid(LocalPlayer()) then return end
	
	self:SetPos(10,10)
	self:SetSize(128,256)
end

function PANEL:SetProgress(e)
	local str = "center .5 .5 scale 1 1 rotate 0 translate 0 "..e
	MAT:SetString("$basetexturetransform", str)
end

function PANEL:Paint()
	--surface.SetTexture(sniperscope_numbers)
	surface.SetMaterial(MAT)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(0, 0, 128, 256)
end

if TestHud then TestHud:Remove() end
TestHud = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
