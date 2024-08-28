
local hud_showitempanel = CreateConVar("hud_showitempanel", "0", {FCVAR_ARCHIVE})

cvars.AddChangeCallback("hud_showitempanel", function(cvar, old, new)
	if not HudInspectPanel then return end
	
	if tonumber(new)==0 then
		HudInspectPanel:Hide(true)
	else
		HudInspectPanel:Show(true)
	end
end)

local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local color_panel = surface.GetTextureID("hud/color_panel_browner")
local c_boxing_gloves = surface.GetTextureID("backpack/weapons/c_models/c_boxing_gloves/c_boxing_gloves")

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(hud_showitempanel:GetBool())
	--self:SetVisible(false)
	
	local t = vgui.Create("ItemModelPanel")
	t:SetParent(self)
	t.activeImage = color_panel
	t.inactiveImage = color_panel
	
	t.srcborder = 23
	t.drawborder = 4.5*Scale
	
	t.disabled = true
	t.itemImage = c_boxing_gloves
	t.itemImage_low = nil
	t.text = ""
	t:SetQuality("Unique")
	
	t.model_xpos = -80
	t.model_ypos = 20
	t.model_tall = 55
	t.text_xpos = 100
	t.text_wide = 150
	t.text_ypos = 20
	t.centertext = true
	
	self.Panel = t
end

function PANEL:SetActiveItem(w)
	self.CurrentActiveWeapon = w
	self.Panel.itemImage = w:GetIconTextureID()
	self.Panel.itemImage_low = nil
	self.Panel.text = w:GetFullName()
	self.Panel.attributes = w.GetFormattedAttributes and w:GetFormattedAttributes()
	self.Panel:SetTextColor(w:GetNameColor())
	self:InvalidateLayout()
end

function PANEL:Show(dbg)
	if dbg then
		self:SetVisible(true)
		self:InvalidateLayout()
		return
	end
	
	if IsValid(LocalPlayer().Killer) and LocalPlayer().Killer:IsPlayer() then
		local w = (LocalPlayer().Killer.GetActiveWeapon and LocalPlayer().Killer:GetActiveWeapon()) or NULL
		
		if not self.Panel then return end
		
		if IsValid(w) and not w:IsBaseTFWeapon() then
			-- Current weapon is not a base weapon
			self:SetActiveItem(w)
			
			self:SetVisible(true)
			self:InvalidateLayout()
		else
			-- Current weapon is a base weapon, look for noticeable wearable items
			local items = {}
			for _,v in ipairs(LocalPlayer().Killer:GetTFItems()) do
				if not v:IsWeapon() then
					table.insert(items, v)
				end
			end
			
			if #items == 0 then return end
			
			w = table.Random(items)
			self:SetActiveItem(w)
			
			self:SetVisible(true)
			self:InvalidateLayout()
		end
	end
end

function PANEL:Hide(dbg)
	if dbg then
		self:SetVisible(false)
		self:InvalidateLayout()
		return
	end
	
	if hud_showitempanel:GetBool() then
		self:InvalidateLayout()
		return
	end
	
	self:SetVisible(false)
	self:InvalidateLayout()
end

function PANEL:PerformLayout()
	self:SetSize(270*Scale,180*Scale)
	
	if not self.Panel then return end
	
	self.Panel:SetPos(0, 0)
	
	local height = 80
	if self.Panel.attributes then
		local tw = self.Panel.text_wide * Scale
		local attr_tab = {
			x=0,y=0,
			w=tw,h=100*Scale,
			font="ItemFontAttribSmall",
			text=self.Panel.attributes,
			yspace=0,
			col=color_white,
			align="north",
		}
		
		height = math.max(80, 40 + tf_draw.LabelTextWrap(attr_tab, true) / Scale)
	end
	
	self.Panel:SetSize(270*Scale, height*Scale)
	self.Panel.model_ypos = (height*0.5)-22
	
	if LocalPlayer().InScreenshot then
		self:SetPos(W-270*Scale,H-height*Scale)
	else
		self:SetPos(W/2-38*Scale,300*Scale)
	end
end

function PANEL:Paint()
end

function PANEL:Update()
	self.CurrentActiveWeapon = nil
	self.CurrentActiveWeaponLocal = nil
end

function PANEL:PaintOver()
	if hud_showitempanel:GetBool() and LocalPlayer():Alive() then
		local w = LocalPlayer():GetActiveWeapon()

		if IsValid(w) and w ~= self.CurrentActiveWeaponLocal then
			if self.Panel then
				self:SetActiveItem(w)
			end
			self.CurrentActiveWeaponLocal = w
		end
		
		tf_lang.SetGlobal("killername", LocalPlayer():GetName())
	else
		tf_lang.SetGlobal("killername", GAMEMODE:EntityName(LocalPlayer().Killer))
	end
	
	draw.Text{
		text=tf_lang.GetFormatted("FreezePanel_Item"),
		font="TFDefaultSmall",
		pos={10*Scale, 3*Scale},
		color=Color(255,255,255,255),
		x_align=TEXT_ALIGN_LEFT,
		y_align=TEXT_ALIGN_TOP,
	}
end

if HudInspectPanel then HudInspectPanel:Remove() end
HudInspectPanel = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))

concommand.Add("nextitem", function(pl)
	if hud_showitempanel:GetBool() and LocalPlayer():Alive() then
		local w = HudInspectPanel.CurrentActiveWeapon
		local items = LocalPlayer():GetTFItems()
		for k,v in ipairs(items) do
			if v == w then
				k = k + 1
				if k > #items then
					k = 1
				end
				HudInspectPanel:SetActiveItem(items[k])
				break
			end
		end
	end
end)
