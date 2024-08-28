local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local loadout_rect = surface.GetTextureID("vgui/loadout_rect")
local loadout_rect_mouseover = surface.GetTextureID("vgui/loadout_rect_mouseover")
local loadout_dotted_line = surface.GetTextureID("vgui/loadout_dotted_line")

local loadout_round_rect = surface.GetTextureID("vgui/loadout_round_rect")
local loadout_round_rect_selected = surface.GetTextureID("vgui/loadout_round_rect_selected")

local w_machete_large = surface.GetTextureID("backpack/weapons/w_models/w_machete_large")
local w_cigarette_case = surface.GetTextureID("backpack/weapons/w_models/w_cigarette_case_large")
local c_leather_watch = surface.GetTextureID("backpack/weapons/c_models/c_leather_watch/parts/c_leather_watch_large")
local w_knife = surface.GetTextureID("backpack/weapons/w_models/w_knife_large")
local w_revolver = surface.GetTextureID("backpack/weapons/w_models/w_revolver_large")
local all_halo = surface.GetTextureID("backpack/player/items/all_class/all_halo_large")

local item_center_xoffset1 = -310
local item_center_xoffset2 = 165
local attributes_xoffset1 = 140
local attributes_xoffset2 = -168
local attributes_yoffset = 10

--[[
local ATT_TEST = {
{"Level 0 Cigarette Case", 1},
{"+900% health", 3},
{"No weapon when equipped", 4},
{"-66% speed", 4},
}]]

local ATT1 = {
{"Level 1 Revolver", 1},
}

local ATT2 = {
{"Level 5 Invisibility Watch", 1},
{"Cloak Type: Motion Sensitive", 2},
}

local ATT3 = {
{"Level 0 Cigarette Case", 1},
{"It will change your skeleton!", 2},
{"Excrutiatingly painful . . .", 4},
{". . . but worth it", 3},
}

local ATT4 = {
{"Level 42 Shitstorm Generator", 1},
}

local Items = {
	{"REVOLVER", "Normal", w_revolver, ATT1},
	{"THE CLOAK AND DAGGER", "Unique", c_leather_watch, ATT2},
	{"THE CRAB-WALKING KIT", "rarity3", w_cigarette_case, ATT3},
	{"FAGGOT'S SHINEY RING", "Unique", all_halo, ATT4},
	{"MISC", "", nil},
}

function PANEL:Init()
	self:SetPaintBackgroundEnabled(true)
	self:SetVisible(false)
	self:SetParent(CharInfoPanel)
end

function PANEL:PerformLayout()
	self:SetPos(0, 67*Scale)
	self:SetSize(W, H)
	
	-- The attribute panel, which displays the name and attributes of each item
	if not self.AttributePanel then
		local t = vgui.Create("ItemAttributePanel")
		t:SetParent(self)
		t:SetSize(168*Scale,300*Scale)
		t.text_ypos = 20
		
		self.AttributePanel = t
	end
	
	-- The item panels, with the name and a picture of each item currently equipped
	if not self.ItemPanels then
		self.ItemPanels = {}
		local x, y = W/2+item_center_xoffset1*Scale, 60*Scale
		local xoffset, yoffset = attributes_xoffset1*Scale, attributes_yoffset*Scale
		for k,v in ipairs(Items) do
			local t = vgui.Create("ItemModelPanel")
			t:SetParent(self)
			t:SetPos(x, y)
			t:SetSize(140*Scale, 75*Scale)
			t.model_ypos = 5
			t.model_tall = 55
			t.activeImage = loadout_rect_mouseover
			t.inactiveImage = loadout_rect
			t.itemImage = v[3]
			t.text = v[1]
			t.text_ypos = 60
			t.attributes = v[4]
			t:SetQuality(v[2])
			
			t:SetAttributePanel(self.AttributePanel, xoffset, yoffset)
			
			self.ItemPanels[k] = t
			
			if k==3 then
				x = W/2+item_center_xoffset2*Scale
				xoffset = attributes_xoffset2*Scale
				y = 60*Scale
			else
				y = y + 80*Scale
			end
		end
	end
	
	-- The class panel, shows the current class selected holding the last weapon equipped
	if not self.ClassPanel then
		local t = vgui.Create("ClassModelPanel")
		t:SetParent(self)
		t:SetPos(W/2-100*Scale, 20*Scale)
		t:SetSize(200*Scale, 340*Scale)
		t.FOV = 50
		t.spotlight = true
		
		t:AddModel(1,"models/player/spy.mdl",{
			Pos = Vector(190, 0, -36),
			Ang = Angle(0, 200, 0),
		})
		t:AddModel(2,"models/weapons/w_models/w_cigarette_case.mdl",{
			Parent = 1,
		})
		t:AddModel(3,"models/player/items/all_class/all_halo.mdl",{
			Parent = 1,
		})
		t:StartAnimation(1, ACT_MP_CROUCHWALK_PDA)
		t:GetModelEntity(1):SetPoseParameter("move_x",1)
		t:GetModelEntity(1):SetPoseParameter("body_pitch",90)
		self.ClassPanel = t
	end
	
	-- Move the attribute panel in front of everything
	self.AttributePanel:MoveToFront()
	
	-- And finally, the button to go back to the main loadout menu
	if not self.BackButton then
		self.BackButton = vgui.Create("TFButton")
		self.BackButton:SetParent(self)
		self.BackButton:SetPos(W/2 - 310*Scale,320*Scale)
		self.BackButton:SetSize(100*Scale,25*Scale)
		self.BackButton.labelText = "<< BACK"
		self.BackButton.font = "HudFontSmallBold"
		function self.BackButton:DoClick()
			CharInfoLoadoutSubPanel:SelectClassLoadout(0)
		end
	end
end

function PANEL:Paint()
	-- Header lines
	
	surface.SetDrawColor(255,255,255,255)	
	tf_draw.TexturedQuadTiled(loadout_dotted_line, W/2-305*Scale, 40*Scale, 610*Scale, 10*Scale, {y=false})
	
	-- Labels
	tf_draw.LabelText(
		W/2-300*Scale,
		20*Scale,
		20*Scale,
		15*Scale,
		">>",
		Color(200, 80, 60, 255),
		"HudFontSmallestBold",
		"west"
	)
	
	tf_draw.LabelText(
		W/2-280*Scale,
		15*Scale,
		240*Scale,
		25*Scale,
		"SPY",
		"TanLight",
		"HudFontMediumBold",
		"west"
	)
	
	tf_draw.LabelText(
		W/2-55*Scale,
		22*Scale,
		180*Scale,
		15*Scale,
		"CURRENTLY EQUIPPED:",
		"TanLight",
		"HudFontSmallestBold",
		"south-west"
	)
end

if FullLoadoutPanel then FullLoadoutPanel:Remove() end
FullLoadoutPanel = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
