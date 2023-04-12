local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

-- maximum number of slots to be displayed
local MAXSLOTS = 8

local color_panel = {
	[0]=surface.GetTextureID("hud/color_panel_brown"),
	surface.GetTextureID("hud/color_panel_red"),
	surface.GetTextureID("hud/color_panel_blu"),
}
local w_machete_large = surface.GetTextureID("backpack/weapons/c_models/c_sandwich/c_sandwich_large")
local teamnames = {"red","blue"}
--local w_machete_large = surface.GetTextureID("sprites/bucket_fists_blue")

local ACTIVE_WIDTH = 110
local ACTIVE_HEIGHT = 77
local INACTIVE_WIDTH = 71.5
local INACTIVE_HEIGHT = 54
local GAP_HEIGHT = 3.75

local DEFAULT_ICONS = {
weapon_physgun					= "entities/weapon_physgun.png",
}

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(false)
	
	self.Panels = {}
	for i=1,MAXSLOTS do
		local t = vgui.Create("ItemModelPanel")
		t:SetParent(self)
		t.activeImage = color_panel[1]
		t.inactiveImage = color_panel[0]
		t.srcborder = 23
		t.drawborder = 4.5*Scale
		t.disabled = true
		t.itemImage = w_machete_large
		t.itemImage_low = nil
		t.text = "THE SANDVICH"
		t.number = i
		t:SetQuality("Unique")
		
		self.Panels[i] = t
	end
	
	self.Loadout = {}
	self.Current = 1
	
	--[[self:SetLoadout({1,2,3})
	self:Select(1)]]
end

function PANEL:PerformLayout()
	self:SetPos(0,0)
	self:SetSize(W,H)
	
	if not self.Panels then return end
	
	local y = (H - (self.TotalHeight)*Scale) / 2
	for k=1,self.NumSlots do
		local t = self.Panels[k]
		if k == self.Current then
			t:SetPos(W-(ACTIVE_WIDTH+3)*Scale, y)
			t:SetSize(ACTIVE_WIDTH*Scale, ACTIVE_HEIGHT*Scale)
			t.model_ypos = 5
			t.model_tall = 62
			t.text_ypos = 57.5 +5
			t.inactiveImage = color_panel[1]
			y = y + (ACTIVE_HEIGHT+GAP_HEIGHT)*Scale
		else
			t:SetPos(W-(INACTIVE_WIDTH+3)*Scale, y)
			t:SetSize(INACTIVE_WIDTH*Scale, INACTIVE_HEIGHT*Scale)
			t.model_ypos = 5
			t.model_tall = 42
			t.text_ypos = 38.5
			t.inactiveImage = color_panel[0]
			y = y + (INACTIVE_HEIGHT+GAP_HEIGHT)*Scale
		end
	end
end

function PANEL:CanSelectSlot(n)
	for i,l in ipairs(self.Loadout) do
		if l.slot == n then
			return true
		end
	end
	return false
end

function PANEL:Select(n)
	for i=1,MAXSLOTS do
		self.Panels[i].Hover = false
	end
	
	for i,l in ipairs(self.Loadout) do
		if l.slot == n then
			self.Current = i
			self.CurrentSlot = l.slot
			self.Panels[self.Current].Hover = true
			self:InvalidateLayout()
			return
		end
	end
end

function PANEL:GetNextSlot(n)
	for i,l in ipairs(self.Loadout) do
		if l.slot == n then
			if self.Loadout[i+1] then
				return self.Loadout[i+1].slot
			else
				return self.Loadout[1].slot
			end
		end
	end
	return 1
end

function PANEL:GetPreviousSlot(n)
	for i,l in ipairs(self.Loadout) do
		if l.slot == n then
			if self.Loadout[i-1] then
				return self.Loadout[i-1].slot
			else
				return self.Loadout[#self.Loadout].slot
			end
		end
	end
	return 1
end

function PANEL:CalcCurrentWeaponSlot()
	for i=1,self.NumSlots do
		local l = self.Loadout[i]
		
		if l and l.ent == LocalPlayer():GetActiveWeapon() then
			return i
		end
	end
	
	return 1
end

local specialslots = {}
specialslots["weapon_physgun"] = 7
specialslots["gmod_tool"] = 6

local physgunIcon = Material("entities/weapon_physgun.png")
DEFAULT_ICONS["weapon_physgun"] = physgunIcon

function PANEL:UpdateLoadout()
	self.Loadout = {}
	
	local maxslot = 0
	local loadout = {}
	
	for _,v in pairs(LocalPlayer():GetWeapons()) do
		local slot = (specialslots[v:GetClass()] and specialslots[v:GetClass()]) or v.Slot or v:GetSlot()

		if slot and not v.Hidden then
			if (!string.find(v:GetClass(),"tf_weapon")) then
				if (LocalPlayer():GetPlayerClass() == "spy") then
					slot = 4 + slot
				elseif (LocalPlayer():GetPlayerClass() == "engineer") then
					slot = 5 + slot
				else
					slot = 3 + slot
				end
			end
			loadout[slot+1] = {
				class=v:GetClass(),
				ent=v,
				slot=slot+1,
				id=(v.ItemIndex and v:ItemIndex()) or -1
			}
			
			if slot>maxslot then maxslot = slot end
		end
	end
	
	for i=1,maxslot+1 do
		if loadout[i] then
			table.insert(self.Loadout, loadout[i])
		end
	end
	
	self.NumSlots = math.Clamp(#self.Loadout, 0, MAXSLOTS)
	self.TotalHeight = (INACTIVE_HEIGHT + 4) * (self.NumSlots-1) + ACTIVE_HEIGHT
	self:InvalidateLayout()
	
	for i=1,MAXSLOTS do
		local t = self.Panels[i]
		local l = self.Loadout[i]

		if i<=self.NumSlots then
			t:SetVisible(true)
			local w = tf_items.ItemsByID[l.id]
			if w then
				if w.image_inventory then
					t.itemImage = surface.GetTextureID(w.image_inventory)
				else
					t.itemImage = nil
				end
				
				
				t:SetTextColor(l.ent:GetNameColor())
				local q = (l.ent.GetQuality and l.ent:GetQuality()) or 0
				
				t.text = l.ent:GetFullName()
			else
				t.itemImage = l.ent.WepSelectIcon or surface.GetTextureID("weapons/swep")
				if l.ent.GetFullName then
					t:SetTextColor(l.ent:GetNameColor())
					t.text = l.ent:GetFullName()
				else
					t:SetTextColor(Color(255, 255, 255))
					t.text = l.ent.PrintName or l.class
				end
			end
			
			if LocalPlayer():EntityTeam() == TEAM_BLU then
				t.activeImage = color_panel[2]
			elseif LocalPlayer():EntityTeam() == TF_TEAM_PVE_INVADERS then
				t.activeImage = color_panel[2]
			else
				t.activeImage = color_panel[1]
			end
			
			t.number = l.slot
			t.itemImage_hi = nil
			if l.ent == LocalPlayer():GetActiveWeapon() then
				self.Current = i
				self.CurrentSlot = l.slot
			end
		else
			t:SetVisible(false)
		end
	end
end

function PANEL:SetLoadout(tbl)
	self.Loadout = table.Copy(tbl)
	self.NumSlots = math.Clamp(#self.Loadout, 1, MAXSLOTS)
	self.TotalHeight = (INACTIVE_HEIGHT + 4) * (self.NumSlots-1) + ACTIVE_HEIGHT
	self:InvalidateLayout()
	
	for k=1,MAXSLOTS do
		local t = self.Panels[k]
		
		if k<=self.NumSlots then
			t:SetVisible(true)
			local w = TF_WEAPONS[self.Loadout[k]]
			if w then
				local tex = Format(w.icon, teamnames[LocalPlayer():EntityTeam()] or teamnames[1])
				t.itemImage = surface.GetTextureID(tex)
				t.itemImage_hi = nil
				t.text = w.name
			else
				t.itemImage = nil
				t.itemImage_hi = nil
				t.text = w.name
			end
		else
			t:SetVisible(false)
		end
	end
end

function PANEL:CanSelectWeapon(n)
	--[[n = self.Loadout[n or self.Current]
	for _,v in pairs(LocalPlayer():GetWeapons()) do
		if v:GetClass()==n then return true end
	end
	return false]]
	
	return true
end

function PANEL:CurrentWeapon()
	--return self.Loadout[self.Current]
	if self.Loadout[self.Current] then
	return self.Loadout[self.Current].class
	end
end

function PANEL:Paint()
	if not LocalPlayer():Alive() or LocalPlayer():Team() == TEAM_SPECTATOR or LocalPlayer():HasWeapon("nil") then
		self:SetVisible(false)
	end
end

if HudWeaponSelection then HudWeaponSelection:Remove() end
HudWeaponSelection = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))