-- should be made into a tf2 styled panel and a vgui thing later
-- needs a class picker
-- loadout should be done through data rather than convars, some custom classes may not work with convars
-- should probably open a list of weapons like before but only for the selected thing

CreateClientConVar("loadout_scout", "", true, true)
CreateClientConVar("loadout_soldier", "", true, true)
CreateClientConVar("loadout_pyro", "", true, true)
CreateClientConVar("loadout_demoman", "", true, true)
CreateClientConVar("loadout_heavy", "15,11,5,-1,-1", true, true)
CreateClientConVar("loadout_engineer", "", true, true)
CreateClientConVar("loadout_sniper", "", true, true)
CreateClientConVar("loadout_medic", "", true, true)
CreateClientConVar("loadout_spy", "", true, true)
CreateClientConVar("loadout_gmodplayer", "", true, true)

local nextLoadoutUpdate = 0

local function updateLoadout(type, id, update)
    local convar = GetConVar("loadout_" .. LocalPlayer():GetPlayerClass())
    local split = string.Split(convar:GetString(), ",")

    if #split == 5 then
        split[type] = id
    else
        split = {-1, -1, -1, -1, -1}
        split[type] = id
    end

    convar:SetString(table.concat(split, ","))
    if update then
        timer.Simple(0.3, function()
            RunConsoleCommand("loadout_update")
        end)
    end
end

local function select(self, i, val, update)
    local type = self.type
    local id = self:GetOptionData(i)
    local convar = GetConVar("loadout_" .. LocalPlayer():GetPlayerClass())
    local split = string.Split(convar:GetString(), ",")

    if #split == 5 then
        split[type] = id
    else
        split = {-1, -1, -1, -1, -1}
        split[type] = id
    end

    convar:SetString(table.concat(split, ","))
    timer.Simple(0.3, function()
        RunConsoleCommand("loadout_update")
    end)
end

local itemSelector

concommand.Add("open_charinfo_direct", function(_, _, args)
    local ply = LocalPlayer()
    local oldclass = ply:GetPlayerClass()
    local convar = GetConVar("loadout_" .. oldclass)
    if !convar then print("You're a class without a loadout?!") return end
    local class = string.upper(string.sub(oldclass, 1, 1)) .. string.sub(oldclass, 2) -- where's the function for class names?
    local loadout = string.Split(convar:GetString(), ",")
    local loadout_rect = surface.GetTextureID("vgui/loadout_rect")
    local loadout_rect_mouseover = surface.GetTextureID("vgui/loadout_rect_mouseover")

    if loadout[1] == "" then
        convar:SetString("-1,-1,-1,-1,-1")
        loadout = {-1, -1, -1, -1, -1}
    end

    nextLoadoutUpdate = 0

    local frame = vgui.Create("DFrame")
    frame:SetSize(450, 300)
    frame:Center()
    frame:SetTitle("Loadout (" .. class .. ")")
    frame:MakePopup()
    frame.OnClose = function()
        RunConsoleCommand("loadout_update")
        
        if (GetConVar("tf_grapplinghook_enable"):GetBool()) then
            ply:ConCommand("giveitem Grappling Hook")
        end
    end

    local classmodel = vgui.Create("DAdjustableModelPanel", frame)
    classmodel:SetSize(225, 250)
    classmodel:Center()
    classmodel:SetFOV(120)
    classmodel.LayoutEntity = function(self, ent)
        self:RunAnimation()
	    ent:FrameAdvance()
        -- print(classmodel:GetCamPos(), classmodel:GetFOV(), classmodel:GetLookAt(), classmodel:GetLookAng())

        if !IsValid(ent.Weapon) and IsValid(ply:GetWeapons()[1]) then
            local wmodel = ply:GetWeapons()[1]:GetWorldModelEntity():GetModel()
            ent.Weapon = ClientsideModel(wmodel)
            ent.Weapon:SetParent(ent)
            ent.Weapon:AddEffects(EF_BONEMERGE)
            ent.Weapon:SetNoDraw(false)
        end
    end
    classmodel:SetCamPos(Vector(105, 0, 45))
    classmodel:SetFOV(50)
    classmodel:SetLookAt(Vector(0, 0, 40))
    classmodel:SetLookAng(Angle(0, 180, 0))
    classmodel:SetAnimated(true)
    local mdl = LocalPlayer():GetPlayerClassTable().Model or LocalPlayer():GetModel()
    classmodel:SetModel(mdl)
    classmodel.oldDrawModel = classmodel.DrawModel
    classmodel.DrawModel = function(self)
        self:oldDrawModel()
        local ent = self:GetEntity()
        if IsValid(ent.Weapon) then
            ent.Weapon:DrawModel()
        end

        if IsValid(ent.Hat1) then
            ent.Hat1:DrawModel()
        end

        if IsValid(ent.Hat2) then
            ent.Hat2:DrawModel()
        end
    end
    classmodel.OnClose = function(self)
        local ent = self:GetEntity()
        if IsValid(ent.Weapon) then
            ent.Weapon:Remove()
        end

        if IsValid(ent.Hat1) then
            ent.Hat1:Remove()
        end

        if IsValid(ent.Hat2) then
            ent.Hat2:Remove()
        end
    end
    classmodel.OnRemove = classmodel.OnClose

    --[[local weapon1 = vgui.Create("DComboBox", frame)
    weapon1.type = 1
    weapon1:SetSize(150, 40)
    weapon1:SetValue(loadout[1])
    weapon1:AddChoice("Stock", -1)
    weapon1:SetPos(15, 35)
    weapon1.OnSelect = select
    local weapon2 = vgui.Create("DComboBox", frame)
    weapon2.type = 2
    weapon2:SetSize(150, 40)
    weapon2:SetValue(loadout[2])
    weapon2:AddChoice("Stock", -1)
    weapon2:SetPos(15, 130)
    weapon2.OnSelect = select
    local weapon3 = vgui.Create("DComboBox", frame)
    weapon3.type = 3
    weapon3:SetSize(150, 40)
    weapon3:SetValue(loadout[3])
    weapon3:AddChoice("Stock", -1)
    weapon3:SetPos(15, 235)
    weapon3.OnSelect = select]]


    local weapons = {{}, {}, {}}

    for id, item in pairs(tf_items.Items) do
        if istable(item) and item.used_by_classes and item.used_by_classes[oldclass] == 1 then
            if ply:GetPlayerClass() != "demoman" then
                if item.item_slot == "primary" then
                    weapons[1][id] = item -- table.insert(weapons[1], ) --id) -- weapon1:AddChoice(item.name, item.id)
                elseif item.item_slot == "secondary" then
                    weapons[2][id] = item -- weapon2:AddChoice(item.name, item.id)
                elseif item.item_slot == "melee" then
                    weapons[3][id] = item -- weapon3:AddChoice(item.name, item.id)
                end
            else
                if item.item_slot == "primary" then
                    weapons[2][id] = item -- table.insert(weapons[1], ) --id) -- weapon1:AddChoice(item.name, item.id)
                elseif item.item_slot == "secondary" then
                    weapons[1][id] = item -- weapon2:AddChoice(item.name, item.id)
                elseif item.item_slot == "melee" then
                    weapons[3][id] = item -- weapon3:AddChoice(item.name, item.id)
                end
            end
        end
    end
    if (IsValid(ply:GetWeapons()[1])) then
		classmodel:GetEntity():SetSequence("stand_"..ply:GetWeapons()[1]:GetHoldType())
    else
		classmodel:GetEntity():SetSequence("competitive_loserstate_idle")
    end
    local weapon1 = vgui.Create("DButton", frame)
    weapon1:SetSize(150, 80)
    weapon1:SetText("")
    weapon1:SetTextColor(Color(255, 255, 0))
    weapon1:SetPos(15, 35)
    if ply:GetPlayerClass() != "demoman" then
        weapon1.DoClick = function(self) surface.PlaySound("ui/buttonclick.wav")  itemSelector(1, weapons[1]) end
    else
        weapon1.DoClick = function(self) surface.PlaySound("ui/buttonclick.wav")  itemSelector(2, weapons[1]) end
    end
	weapon1.OnCursorEntered = function()
            local standAnim
            if (IsValid(ply:GetWeapons()[1])) then
                standAnim = "stand_"..ply:GetWeapons()[1]:GetHoldType()
            else
                standAnim = "competitive_loserstate_idle"
            end
        classmodel:GetEntity():SetSequence(standAnim)                  
        local wmodel = ply:GetWeapons()[1]:GetWorldModelEntity():GetModel()
		classmodel:GetEntity().Weapon:SetModel(wmodel)
		classmodel:GetEntity().Weapon:SetParent(classmodel:GetEntity())
        classmodel:GetEntity().Weapon:AddEffects(EF_BONEMERGE)
	end

    local weapon2 = vgui.Create("DButton", frame)
    weapon2:SetSize(150, 80)
    weapon2:SetText("")
    weapon2:SetTextColor(Color(255, 255, 0))
    weapon2:SetPos(15, 120)
    if ply:GetPlayerClass() != "demoman" then
        weapon2.DoClick = function(self) surface.PlaySound("ui/buttonclick.wav")  itemSelector(2, weapons[2]) end
    else
        weapon2.DoClick = function(self) surface.PlaySound("ui/buttonclick.wav")  itemSelector(1, weapons[2]) end
    end
	-- Ensure font and text color changes are applied
	weapon2.OnCursorEntered = function()
            local standAnim
            if (IsValid(ply:GetWeapons()[2])) then
                standAnim = "stand_"..ply:GetWeapons()[2]:GetHoldType()
            else
                standAnim = "competitive_loserstate_idle"
            end
            classmodel:GetEntity():SetSequence(standAnim)                     
            local wmodel = ply:GetWeapons()[2]:GetWorldModelEntity():GetModel()
		classmodel:GetEntity().Weapon:SetModel(wmodel)
		classmodel:GetEntity().Weapon:SetParent(classmodel:GetEntity())
        classmodel:GetEntity().Weapon:AddEffects(EF_BONEMERGE)

	end
    local weapon3 = vgui.Create("DButton", frame)
    weapon3:SetSize(150, 80)
    weapon3:SetText("")
    weapon3:SetTextColor(Color(255, 255, 0))
    weapon3:SetPos(15, 205)
    weapon3.DoClick = function(self) surface.PlaySound("ui/buttonclick.wav") itemSelector(3, weapons[3]) end
	weapon3.OnCursorEntered = function()
        local standAnim
        if (IsValid(ply:GetWeapons()[3])) then
            standAnim = "stand_"..ply:GetWeapons()[3]:GetHoldType()
        else
            standAnim = "competitive_loserstate_idle"
        end
		classmodel:GetEntity():SetSequence(standAnim)          
        local wmodel = ply:GetWeapons()[3]:GetWorldModelEntity():GetModel()
		classmodel:GetEntity().Weapon:SetModel(wmodel)
		classmodel:GetEntity().Weapon:SetParent(classmodel:GetEntity())
        classmodel:GetEntity().Weapon:AddEffects(EF_BONEMERGE)
	end
    local hat1 = vgui.Create("DImageButton", frame)
    hat1:SetSize(128, 128)
    hat1:SetText("Open Hat Menu")
    hat1:SetTextColor(Color(255, 255, 0))
    hat1:SetPos(305, 35)
    hat1:SetImage( "backpack/player/items/spy/firesuit" )
    hat1.DoClick = function(self) surface.PlaySound("ui/buttonclick.wav") hatSelector("hat") end
	hat1.OnCursorEntered = function()
		classmodel:GetEntity():SetSequence("competitive_loserstate_idle")    
        classmodel:GetEntity().Weapon:SetNoDraw(true)        
	end
    weapon3.PaintOver = function()
        if nextLoadoutUpdate < CurTime() then
            nextLoadoutUpdate = CurTime() + 5
            loadout = string.Split(convar:GetString(), ",")
            -- oh no
            print(":O")
            if ply:GetPlayerClass() != "demoman" then

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
                end
            else

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
            end
        end

        local paintf = function(self, w, h)
            if self:IsHovered() then
                surface.SetTexture(loadout_rect_mouseover)
            else
                surface.SetTexture(loadout_rect)
            end

            surface.SetDrawColor(255, 255, 255)
            surface.DrawTexturedRect(0, 0, w, h)

            if self.icon then
                surface.SetTexture(self.icon)
                surface.SetDrawColor(255, 255, 255)
                surface.DrawTexturedRect(25, 0, 95, 80)
            end

            if self.text then
                --[[surface.SetFont("ItemFontNameSmall")
                surface.SetTextP]]
                draw.SimpleTextOutlined(self.text, "TFDefaultSmall", w / 2, h / 2, Colors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, Colors.TanDarker)
            end
        end

        weapon1.Paint = paintf
        weapon2.Paint = paintf
        weapon3.Paint = paintf
    end
end)

function itemSelector(type, weapons)
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
            nextLoadoutUpdate = 0
            updateLoadout(type, v.id)
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
function hatSelector(type)
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
	for k, v in pairs(tf_items.ReturnItems()) do
		if v and istable(v) and v["name"] and GetImprovedItemName(v["name"]) and string.sub(GetImprovedItemName(v["name"]), 1, 3) == type then
			local t = vgui.Create("ItemModelPanel", Frame)
			t:SetSize(140 * Scale, 75 * Scale)
			itemicons:Add(t)
			t.activeImage = loadout_rect_mouseover
			t.inactiveImage = loadout_rect

			t.RealName = v["name"]
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

			t.text = string.sub(GetImprovedItemName(v["name"]), 4)
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
			t.DoClick = function() LocalPlayer():ConCommand("giveitem " .. t.RealName) surface.PlaySound(v["mouse_pressed_sound"] or "ui/item_hat_pickup.wav") Frame:Close() end
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