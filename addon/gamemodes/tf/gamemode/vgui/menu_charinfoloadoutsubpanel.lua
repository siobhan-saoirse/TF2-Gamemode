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


function PANEL:Init()
	self:SetPaintBackgroundEnabled(true)
	self:SetVisible(false)
	self:SetParent(CharInfoPanel)
end

local function updateLoadout(type, id, update, class)
    local convar = GetConVar("loadout_" .. class)
    local split = string.Split(convar:GetString(), ",")

    if #split == 6 then
        split[type] = id
    else
        split = {-1, -1, -1, -1, -1, -1}
        split[type] = id
    end

    convar:SetString(table.concat(split, ","))
    if update then
        timer.Simple(0.3, function()
            RunConsoleCommand("loadout_update")
        end)
    end
end

function PANEL:PerformLayout()
	self:SetPos(0, 67*Scale)
	self:SetSize(W, H)
	
	local ply = LocalPlayer()
	local oldclass = "scout"
	if (GetConVar("tf_hud_loadout_class"):GetInt() == 1) then
		oldclass = "scout"
	elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 2) then
		oldclass = "soldier"
	elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 3) then
		oldclass = "pyro"
	elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 4) then
		oldclass = "demoman"
	elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 5) then
		oldclass = "heavy"
	elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 6) then
		oldclass = "engineer"
	elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 7) then
		oldclass = "medic"
	elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 8) then
		oldclass = "sniper"
	elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 9) then
		oldclass = "spy"
	end
	local convar = GetConVar("loadout_" .. oldclass)
	
	local weapons = {{}, {}, {}, {}}

	for id, item in pairs(tf_items.Items) do
		if istable(item) and item.used_by_classes and item.used_by_classes[oldclass] then
			if GetConVar("tf_hud_loadout_class"):GetInt() != 4 && GetConVar("tf_hud_loadout_class"):GetInt() != 9 then
				if item.item_slot == "primary" then
					weapons[1][id] = item -- table.insert(weapons[1], ) --id) -- weapon1:AddChoice(item.name, item.id)
				elseif item.item_slot == "secondary" then
					weapons[2][id] = item -- weapon2:AddChoice(item.name, item.id)
				elseif item.item_slot == "melee" then
					weapons[3][id] = item -- weapon3:AddChoice(item.name, item.id)
				elseif item.item_slot == "head" or item.item_slot == "misc" then
					weapons[4][id] = item -- weapon3:AddChoice(item.name, item.id)
				end
			else
				if item.item_slot == "primary" then
					weapons[2][id] = item -- table.insert(weapons[1], ) --id) -- weapon1:AddChoice(item.name, item.id)
				elseif item.item_slot == "secondary" then
					weapons[1][id] = item -- weapon2:AddChoice(item.name, item.id)
				elseif item.item_slot == "melee" then
					weapons[3][id] = item -- weapon3:AddChoice(item.name, item.id)
				elseif item.item_slot == "head" or item.item_slot == "misc" then
					weapons[4][id] = item -- weapon3:AddChoice(item.name, item.id)
				end
			end
		end
	end
	
	loadout = string.Split(convar:GetString(), ",")

	-- The attribute panel, which displays the name and attributes of each item
	if not self.AttributePanel then
		local t = vgui.Create("ItemAttributePanel")
		t:SetParent(self)
		t:SetSize(168*Scale,300*Scale)
		t.text_ypos = 20
		
		self.AttributePanel = t
	end
	
		
	local Items = {
		{"NONE", "Normal", surface.GetTextureID(""), ATT4},
		{"NONE", "Normal", surface.GetTextureID(""), ATT4},
		{"NONE", "Normal", surface.GetTextureID(""), ATT4},
		{"NONE", "Normal", surface.GetTextureID(""), ATT4},
		{"NONE", "Normal", surface.GetTextureID(""), ATT4},
		{"NONE", "Normal", surface.GetTextureID(""), ATT4},
	}

	for name, wep in pairs(tf_items.Items) do
		if istable(wep) then	
			if GetConVar("tf_hud_loadout_class"):GetInt() != 4 && GetConVar("tf_hud_loadout_class"):GetInt() != 9 then
				if wep.id == tonumber(loadout[1]) then
					Items[1] = {tf_lang.GetRaw(wep.item_name), "Unique", surface.GetTextureID(wep.image_inventory), {}}
				elseif wep.id == tonumber(loadout[2]) then
					Items[2] = {tf_lang.GetRaw(wep.item_name), "Unique", surface.GetTextureID(wep.image_inventory), {}}
				elseif wep.id == tonumber(loadout[3]) then
					Items[3] = {wep.name, "Unique", surface.GetTextureID(wep.image_inventory), {}}
				elseif wep.id == tonumber(loadout[4]) then
					Items[4] = {wep.name, "Unique", surface.GetTextureID(wep.image_inventory), {}}
				elseif wep.id == tonumber(loadout[5]) then
					Items[5] = {wep.name, "Unique", surface.GetTextureID(wep.image_inventory), {}}
				elseif wep.id == tonumber(loadout[6]) then
					Items[6] = {wep.name, "Unique", surface.GetTextureID(wep.image_inventory), {}}
				end
			else
				if wep.id == tonumber(loadout[1]) then
					Items[2] = {tf_lang.GetRaw(wep.item_name), "Unique", surface.GetTextureID(wep.image_inventory), {}}
				elseif wep.id == tonumber(loadout[2]) then
					Items[1] = {tf_lang.GetRaw(wep.item_name), "Unique", surface.GetTextureID(wep.image_inventory), {}}
				elseif wep.id == tonumber(loadout[3]) then
					Items[3] = {wep.name, "Unique", surface.GetTextureID(wep.image_inventory), {}}
				elseif wep.id == tonumber(loadout[4]) then
					Items[4] = {wep.name, "Unique", surface.GetTextureID(wep.image_inventory), {}}
				elseif wep.id == tonumber(loadout[5]) then
					Items[5] = {wep.name, "Unique", surface.GetTextureID(wep.image_inventory), {}}
				elseif wep.id == tonumber(loadout[6]) then
					Items[6] = {wep.name, "Unique", surface.GetTextureID(wep.image_inventory), {}}
				end
			end
		end
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
			
			if GetConVar("tf_hud_loadout_class"):GetInt() != 4 && GetConVar("tf_hud_loadout_class"):GetInt() != 9 then
				if (k == 1) then
					t.DoClick = function() itemSelector(1, weapons[1], self:GetParent(), GetConVar("tf_hud_loadout_class"):GetInt(), oldclass) end
				elseif (k == 2) then
					t.DoClick = function() itemSelector(2, weapons[2], self:GetParent(), GetConVar("tf_hud_loadout_class"):GetInt(), oldclass) end
				elseif (k == 3) then
					t.DoClick = function() itemSelector(3, weapons[3], self:GetParent(), GetConVar("tf_hud_loadout_class"):GetInt(), oldclass) end
				elseif (k == 4) then
					t.DoClick = function() hatSelector("hat",4,oldclass,weapons[4]) end
				elseif (k == 5) then
					t.DoClick = function() hatSelector("hat",5,oldclass,weapons[4]) end
				elseif (k == 6) then
					t.DoClick = function() hatSelector("hat",6,oldclass,weapons[4]) end
				end
			else
				if (k == 2) then 
					t.DoClick = function() itemSelector(1, weapons[2], self:GetParent(), GetConVar("tf_hud_loadout_class"):GetInt(), oldclass) end
				elseif (k == 1) then
					t.DoClick = function() itemSelector(2, weapons[1], self:GetParent(), GetConVar("tf_hud_loadout_class"):GetInt(), oldclass) end
				elseif (k == 3) then
					t.DoClick = function() itemSelector(3, weapons[3], self:GetParent(), GetConVar("tf_hud_loadout_class"):GetInt(), oldclass) end
				elseif (k == 4) then
					t.DoClick = function() hatSelector("hat",4,oldclass,weapons[4]) end
				elseif (k == 5) then
					t.DoClick = function() hatSelector("hat",5,oldclass,weapons[4]) end
				elseif (k == 6) then
					t.DoClick = function() hatSelector("hat",6,oldclass,weapons[4]) end
				end
			end
			
			--t:SetAttributePanel(self.AttributePanel, xoffset, yoffset)
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
	
	
	-- Move the attribute panel in front of everything
	self.AttributePanel:MoveToFront()
	
	-- And finally, the button to go back to the main loadout menu
	if not self.BackButton then
		self.BackButton = vgui.Create("TFButton")
		self.BackButton:SetParent(self)
		self.BackButton:SetPos(W/2 - 310*Scale,437*Scale)
		self.BackButton:SetSize(100*Scale,25*Scale)
		self.BackButton.labelText = "<< BACK"
		self.BackButton.font = "HudFontSmallBold"
		function self.BackButton:DoClick()
			CharInfoLoadoutSubPanel:SelectClassLoadout(0)
		end
	end
	local t
	-- The class panel, shows the current class selected holding the last weapon equipped
	if not self.ClassPanel then
		t = vgui.Create("ClassModelPanel")
		t:SetParent(self)
		t:SetPos(W/2-100*Scale, 20*Scale)
		t:SetSize(200*Scale, 340*Scale)
		t.FOV = 50
		t.spotlight = true
		self.ClassPanel = t
		
			
		-- oh no
		print(":O")
		if ply:GetPlayerClass() != "demoman" then

			--[[
			for name, wep in pairs(tf_items.Items) do
				if istable(wep) then
					if wep.id == tonumber(loadout[1]) then
						weapon1.text = name
						if wep.image_inventory then
							weapon1.icon = surface.GetTextureID(wep.image_inventory)
						end
					elseif wep.id == tonumber(loadout[2]) then
						weapon2.text = name
						if wep.image_inventory then
							weapon2.icon = surface.GetTextureID(wep.image_inventory)
						end
					elseif wep.id == tonumber(loadout[3]) then
						weapon3.text = name
						if wep.image_inventory then
							weapon3.icon = surface.GetTextureID(wep.image_inventory)
						end
					end
				end
			end]]
		else
			--[[
			for name, wep in pairs(tf_items.Items) do
				if istable(wep) then
					if wep.id == tonumber(loadout[2]) then
						weapon1.text = name
						if wep.image_inventory then
							weapon1.icon = surface.GetTextureID(wep.image_inventory)
						end
					elseif wep.id == tonumber(loadout[1]) then
						weapon2.text = name
						if wep.image_inventory then
							weapon2.icon = surface.GetTextureID(wep.image_inventory)
						end
					elseif wep.id == tonumber(loadout[3]) then
						weapon3.text = name
						if wep.image_inventory then
							weapon3.icon = surface.GetTextureID(wep.image_inventory)
						end
					end
				end
			end
			]]
		end

		t:AddModel(1,"models/player/scout.mdl",{
			Pos = Vector(190, 0, -36),
			Ang = Angle(0, 200, 0),
		})
		
		if (GetConVar("tf_hud_loadout_class"):GetInt() == 1) then
			t:AddModel(1,"models/player/scout.mdl",{
				Pos = Vector(190, 0, -36),
				Ang = Angle(0, 200, 0),
			})
		elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 2) then
			t:AddModel(1,"models/player/soldier.mdl",{
				Pos = Vector(190, 0, -36),
				Ang = Angle(0, 200, 0),
			})
		elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 3) then
			t:AddModel(1,"models/player/pyro.mdl",{
				Pos = Vector(190, 0, -36),
				Ang = Angle(0, 200, 0),
			})
		elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 4) then
			t:AddModel(1,"models/player/demo.mdl",{
				Pos = Vector(190, 0, -36),
				Ang = Angle(0, 200, 0),
			})
		elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 5) then
			t:AddModel(1,"models/player/heavy.mdl",{
				Pos = Vector(190, 0, -36),
				Ang = Angle(0, 200, 0),
			})
		elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 6) then
			t:AddModel(1,"models/player/engineer.mdl",{
				Pos = Vector(190, 0, -36),
				Ang = Angle(0, 200, 0),
			})
		elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 7) then
			t:AddModel(1,"models/player/medic.mdl",{
				Pos = Vector(190, 0, -36),
				Ang = Angle(0, 200, 0),
			})
		elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 8) then
			t:AddModel(1,"models/player/sniper.mdl",{
				Pos = Vector(190, 0, -36),
				Ang = Angle(0, 200, 0),
			})
		elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 9) then
			t:AddModel(1,"models/player/spy.mdl",{
				Pos = Vector(190, 0, -36),
				Ang = Angle(0, 200, 0),
			})
		end

		for name, wep in pairs(tf_items.Items) do
			if istable(wep) then
				if wep.id == tonumber(loadout[4]) and isstring(wep.model_player_per_class) then

					t:AddModel(3,string.Replace(wep.model_player_per_class,"%s",oldclass),{
						Parent = 1,
					})

				elseif wep.id == tonumber(loadout[5]) and isstring(wep.model_player_per_class) then

					t:AddModel(4,string.Replace(wep.model_player_per_class,"%s",oldclass),{
						Parent = 1,
					})

				elseif wep.id == tonumber(loadout[6]) and isstring(wep.model_player_per_class) then

					t:AddModel(5,string.Replace(wep.model_player_per_class,"%s",oldclass),{
						Parent = 1,
					})

				end
				local oldclass2 = oldclass
				if (oldclass == "spy" or oldclass == "demoman") then
					if wep.id == tonumber(loadout[2]) then

						t:AddModel(2,wep.model_world or wep.model_player,{
							Parent = 1,
						})
						t:StartAnimation(1,ACT_MP_STAND_SECONDARY)
					end
				else
					if wep.id == tonumber(loadout[1]) then

						t:AddModel(2,wep.model_world or wep.model_player,{
							Parent = 1,
						})
						if (oldclass == "spy") then
							t:StartAnimation(1,ACT_MP_STAND_BUILDING)
						else
							t:StartAnimation(1,ACT_MP_STAND_PRIMARY)
						end
					end
				end
			end
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
	if (GetConVar("tf_hud_loadout_class"):GetInt() == 1) then
		tf_draw.LabelText(
			W/2-280*Scale,
			15*Scale,
			240*Scale,
			25*Scale,
			"SCOUT",
			"TanLight",
			"HudFontMediumBold",
			"west"
		)
	elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 2) then
		tf_draw.LabelText(
			W/2-280*Scale,
			15*Scale,
			240*Scale,
			25*Scale,
			"SOLDIER",
			"TanLight",
			"HudFontMediumBold",
			"west"
		)
	elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 3) then
		tf_draw.LabelText(
			W/2-280*Scale,
			15*Scale,
			240*Scale,
			25*Scale,
			"PYRO",
			"TanLight",
			"HudFontMediumBold",
			"west"
		)
	elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 4) then
		tf_draw.LabelText(
			W/2-280*Scale,
			15*Scale,
			240*Scale,
			25*Scale,
			"DEMOMAN",
			"TanLight",
			"HudFontMediumBold",
			"west"
		)
	elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 5) then
		tf_draw.LabelText(
			W/2-280*Scale,
			15*Scale,
			240*Scale,
			25*Scale,
			"HEAVY",
			"TanLight",
			"HudFontMediumBold",
			"west"
		)
	elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 6) then
		tf_draw.LabelText(
			W/2-280*Scale,
			15*Scale,
			240*Scale,
			25*Scale,
			"ENGINEER",
			"TanLight",
			"HudFontMediumBold",
			"west"
		)
	elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 7) then
		tf_draw.LabelText(
			W/2-280*Scale,
			15*Scale,
			240*Scale,
			25*Scale,
			"MEDIC",
			"TanLight",
			"HudFontMediumBold",
			"west"
		)
	elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 8) then
		tf_draw.LabelText(
			W/2-280*Scale,
			15*Scale,
			240*Scale,
			25*Scale,
			"SNIPER",
			"TanLight",
			"HudFontMediumBold",
			"west"
		)
	elseif (GetConVar("tf_hud_loadout_class"):GetInt() == 9) then

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
	end
	
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
local OLDPANEL = PANEL
local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local class_sel_sm = {}
local classes = {"scout", "soldier", "pyro", "demo", "heavy", "engineer", "medic", "sniper", "spy"}
local classnames = {"SCOUT", "SOLDIER", "PYRO", "DEMOMAN", "HEAVY", "ENGINEER", "MEDIC", "SNIPER", "SPY"}

local class_ypos = 40
local class_xdelta = 5
local class_wide_min = 60
local class_wide_max = 100
local class_tall_min = 120
local class_tall_max = 200
local class_distance_min = 7
local class_distance_max = 100

local class_size_speed = 10

for k,v in ipairs(classes) do
	class_sel_sm[k] = {
		surface.GetTextureID("vgui/class_sel_sm_"..v.."_red"),
		surface.GetTextureID("vgui/class_sel_sm_"..v.."_inactive")
	}
end

local backpack_01 = surface.GetTextureID("hud/backpack_01")
local backpack_01_grey = surface.GetTextureID("hud/backpack_01_grey")

function PANEL:SelectClassLoadout(c)
	if c>=1 and c<=10 then
		FullLoadoutPanel:SetVisible(true)
		self:ResetButtons()
		self:SetVisible(false)
	else
		FullLoadoutPanel:SetVisible(false)
		self:SetVisible(true)
	end
end

function PANEL:SelectClassLoadout2(c) 
	if c>=1 and c<=10 then
		if FullLoadoutPanel then FullLoadoutPanel:Remove() end
		FullLoadoutPanel = vgui.CreateFromTable(vgui.RegisterTable(OLDPANEL, "DPanel"))
		FullLoadoutPanel:SetVisible(true)
		self:ResetButtons()
		self:SetVisible(false)
	else
		FullLoadoutPanel:SetVisible(false)
		self:SetVisible(true)
	end
end

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:SetVisible(true)
	self:SetParent(CharInfoPanel)
	
	-- Class loadout buttons
	self.ClassButtons = {}
	local x = (W/2)/Scale - (4.5 * class_wide_min + 4 * class_xdelta)
	for k,_ in ipairs(classes) do
		local t = vgui.Create("TFButton")
		t:SetParent(self)
		t:SetPos(x*Scale, (28+class_ypos)*Scale)
		t:SetSize(class_wide_min*Scale,class_tall_min*Scale)
		t.activeImage = class_sel_sm[k][1]
		t.inactiveImage = class_sel_sm[k][2]
		
		t.xcenter = Scale * (x+class_wide_min/2)
		t.ycenter = Scale * (28+class_ypos+class_tall_min/2)
		
		function t:DoClick()
			RunConsoleCommand("tf_hud_loadout_class",""..k)
			timer.Simple(0.1, function()
			
				if FullLoadoutPanel then FullLoadoutPanel:Remove() end
				FullLoadoutPanel = vgui.CreateFromTable(vgui.RegisterTable(OLDPANEL, "DPanel"))
				self:GetParent():SelectClassLoadout(k)
				self:GetParent().char_model = "models/player/medic.mdl"
				
			end)
		end
		
		self.ClassButtons[k] = t
		
		x = x + class_wide_min + class_xdelta
	end
	
	--[[-- Backpack
	local t = vgui.Create("TFButton")
	t:SetParent(self)
	t:SetPos(W/2-30*Scale, 254*Scale)
	t:SetSize(60*Scale,60*Scale)
	t.activeImage = backpack_01
	t.inactiveImage = backpack_01_grey]]
end

function PANEL:ResetButtons()
	local w, h = Scale*class_wide_min, Scale*class_tall_min
	for k,v in ipairs(self.ClassButtons) do
		v:SetPos(v.xcenter-w/2, v.ycenter-h/2)
		v:SetSize(w, h)
	end
end

function PANEL:PerformLayout()
	self:SetPos(0, 40*Scale)
	self:SetSize(W, H)
	
	if not self.ClassButtons then return end
	
	local active = false
	for _,v in ipairs(self.ClassButtons) do
		if v.Hover then
			active = true
			break
		end
	end
	
	if active then
		local x, y = self:CursorPos()
		for k,v in ipairs(self.ClassButtons) do
			local dist = math.Clamp(math.abs(v.xcenter - x) / Scale, class_distance_min, class_distance_max)
			local r = 1 - (dist - class_distance_min) / (class_distance_max - class_distance_min)
			
			local w, h = Scale*Lerp(r, class_wide_min, class_wide_max), Scale*Lerp(r, class_tall_min, class_tall_max)
			v.TargetSize = Vector(w, h, 0)
		end
	else
		for k,v in ipairs(self.ClassButtons) do
			local w, h = Scale*class_wide_min, Scale*class_tall_min
			v.TargetSize = Vector(w, h, 0)
		end
	end
	
	for k,v in ipairs(self.ClassButtons) do
		if v.TargetSize then
			local w0, h0 = v:GetSize()
			local dw, dh = (v.TargetSize.x - w0) * RealFrameTime() * class_size_speed, (v.TargetSize.y - h0) * RealFrameTime() * class_size_speed
			local w, h = w0 + dw, h0 + dh
			
			v:SetPos(v.xcenter-w/2, v.ycenter-h/2)
			v:SetSize(w, h)
		end
	end
end

function PANEL:Think()
	self:InvalidateLayout()
end

function PANEL:Paint()
	draw.Text{
		text="SELECT A CLASS TO MODIFY LOADOUT",
		font="HudFontSmallBold",
		pos={W/2, 330*Scale},
		color=Color(117, 107, 94, 255),
		xalign=TEXT_ALIGN_CENTER,
		yalign=TEXT_ALIGN_TOP,
	}
	
	for k,v in ipairs(self.ClassButtons) do
		if v.Hover then
			draw.Text{
				text=classnames[k],
				font="HudFontSmallBold",
				pos={v.xcenter, 226*Scale},
				color=Color(235, 226, 202, 255),
				xalign=TEXT_ALIGN_CENTER,
				yalign=TEXT_ALIGN_TOP,
			}
			
			draw.Text{
				text="(∞ ITEMS IN INVENTORY)",
				font="HudFontSmall",
				pos={v.xcenter, 242*Scale},
				color=Color(200, 80, 60, 255),
				xalign=TEXT_ALIGN_CENTER,
				yalign=TEXT_ALIGN_TOP,
			}
		end
	end
end

if CharInfoLoadoutSubPanel then CharInfoLoadoutSubPanel:Remove() end
CharInfoLoadoutSubPanel = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))


function itemSelector(type, weapons, parent, classid, oldclass)
    local Scale = ScrH() / 480
    local loadout_rect = surface.GetTextureID("vgui/loadout_rect")
    local loadout_rect_mouseover = surface.GetTextureID("vgui/loadout_rect_mouseover")

    local frame = vgui.Create("DFrame")
    frame:SetTitle("Item Picker")
    frame:SetSize(1300, 650)
    frame:Center()
    frame:SetDraggable(true)
    frame:SetMouseInputEnabled(true)
    frame:MakePopup() 

    local scroll = vgui.Create("DScrollPanel", frame)
    scroll:Dock(FILL)

    local itemicons = vgui.Create("DIconLayout", scroll)
    itemicons:Dock(FILL)

    local attr = vgui.Create("ItemAttributePanel")
    attr:SetSize(168 * Scale, 300 * Scale)
    attr:SetPos(0, 0)
    attr.text_ypos = 20
    attr:SetMouseInputEnabled(false)

    for k, v in pairs(weapons) do
        local model = vgui.Create("ItemModelPanel", frame)
        model:SetSize(140 * Scale, 75 * Scale)
        model:SetCursor("hand")
        model:SetQuality(v.item_quality and string.upper(string.sub(v.item_quality, 1, 1)) .. string.sub(v.item_quality, 2) or 0)
        model.activeImage = loadout_rect_mouseover
        model.inactiveImage = loadout_rect
        model.number = type
        model.model_xpos = 0
        model.model_ypos = 5
        model.model_tall = 55
        model.text_xpos = -5
        model.text_wide = 150
        model.text_ypos = 60
        model.itemImage_low = nil
        model.text = tf_lang.GetRaw(v.item_name) or v.name
        model.centerytext = true
        model.disabled = false
        if !isstring(v.image_inventory) or Material(v.image_inventory):IsError() then
            model.FallbackModel = v.model_player
            model.itemImage = surface.GetTextureID("backpack/weapons/c_models/c_bat")
        elseif isstring(v.image_inventory) then
            model.itemImage = surface.GetTextureID(v.image_inventory)
        end

        if v.attributes and v.attributes["material override"] and v.attributes["material override"].value then
            model.overridematerial = v.attributes["material override"].value
        end

        model.DoClick = function()
            updateLoadout(type, v.id, true, oldclass)
			timer.Simple(0.1, function()
			
				CharInfoLoadoutSubPanel:SelectClassLoadout2(classid)	

			end)
            surface.PlaySound(v.mouse_pressed_sound or "ui/item_hat_pickup.wav")
            frame:Close()
        end

        if istable(v.attributes) then
            model.attributes = v.attributes
        end

        itemicons:Add(model)
    end

    attr:MoveToFront()
end
function hatSelector(type, slot, oldclass, weapons)
	local Scale = ScrH()/480

	local loadout_rect = surface.GetTextureID("vgui/loadout_rect")
	local loadout_rect_mouseover = surface.GetTextureID("vgui/loadout_rect_mouseover")
	local color_panel = surface.GetTextureID("hud/color_panel_browner")
	local c_boxing_gloves = surface.GetTextureID("backpack/weapons/c_models/c_boxing_gloves/c_boxing_gloves")
	local Frame = vgui.Create("DFrame")
	Frame:SetTitle("Item Picker")
	Frame:SetSize(1300, 650)
	Frame:Center()
	Frame:SetDraggable(true)
	Frame:SetMouseInputEnabled(true)
	Frame:MakePopup()
	--gui.EnableScreenClicker(true)

	local scroll = vgui.Create("DScrollPanel", Frame)
	scroll:Dock(FILL)

	local itemicons = vgui.Create("DIconLayout", scroll)
	itemicons:Dock(FILL)

	local att = vgui.Create("ItemAttributePanel")
	att:SetSize(168*Scale,300*Scale)
	att:SetPos(0, 0)
	att.text_ypos = 20
	att:SetMouseInputEnabled(false)

	local attributes_xoffset1 = 30
	local attributes_xoffset2 = -168
	local attributes_yoffset = 120
	local xoffset, yoffset = attributes_xoffset1 * Scale, attributes_yoffset * Scale

	--Frame.OnClose = function() gui.EnableScreenClicker(false) att:Remove() end

	-- ugly code ahead
	for k, v in pairs(weapons) do
		if v and istable(v) and (v["item_class"] == "tf_wearable_item") and v["equip_region"] != "medal" then
			local t = vgui.Create("ItemModelPanel", Frame)
			t:SetSize(140 * Scale, 75 * Scale)
			itemicons:Add(t)
			t.activeImage = loadout_rect_mouseover
			t.inactiveImage = loadout_rect

			t.RealName = v["item_name"]
			t.centerytext = true
			t.disabled = false
			if !isstring(v["image_inventory"]) or Material(v["image_inventory"]):IsError() then
				t.FallbackModel = v["model_player"]
				t.itemImage = surface.GetTextureID("backpack/weapons/c_models/c_bat")
			elseif isstring(v["image_inventory"]) then
				-- t.FallbackModel = v["model_player"]
				t.itemImage = surface.GetTextureID(v["image_inventory"])
			end

			--[[if v["item_class"] ~= "tf_wearable_item" and tonumber(v["id"]) > 6000 then
				t.FallbackModel = v["model_player"]
			end]]

			if v["attributes"] and v["attributes"]["material override"] and v["attributes"]["material override"]["value"] then
				t.overridematerial = v["attributes"]["material override"]["value"]
			end

			t.itemImage_low = nil

			t.text = tf_lang.GetRaw(v["item_name"]) or v["name"]
			--t.text = tf_lang.GetRaw(v["item_name"]) or v["name"]
			local quality = 0
			if v["item_quality"] then
				quality = string.upper(string.sub(v["item_quality"], 1, 1)) .. string.sub(v["item_quality"], 2)
			end
			t:SetQuality(quality)

			t.model_xpos = 0
			t.model_ypos = 5
			t.model_tall = 55
			t.text_xpos = -5
			t.text_wide = 150
			t.text_ypos = 60
			t.DoClick = function() 
				updateLoadout(slot, v.id, true, oldclass)
				timer.Simple(0.1, function()
				
					CharInfoLoadoutSubPanel:SelectClassLoadout2(GetConVar("tf_hud_loadout_class"):GetInt())	
	
				end)
				surface.PlaySound(v["mouse_pressed_sound"] or "ui/item_hat_pickup.wav") 
				Frame:Close() 
			end
			t:SetCursor("hand")

			if istable(v["attributes"]) then
				t.attributes = v["attributes"]
			end

			if v["item_slot"] == "primary" then
				t.number = 1
			elseif v["item_slot"] == "secondary" then
				t.number = 2
			elseif v["item_slot"] == "melee" then
				t.number = 3
			end
		end
	end

	att:MoveToFront()
end