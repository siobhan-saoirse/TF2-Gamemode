local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local attribcolors = {
	[-2] = "ItemAttribNeutralUnimplemented",
	[-3] = "ItemAttribPositiveUnimplemented",
	[-4] = "ItemAttribNegativeUnimplemented",
	
	"ItemAttribLevel",
	"ItemAttribNeutral",
	"ItemAttribPositive",
	"ItemAttribNegative",
	"ItemSetName",
	"ItemSetItemMissing",
	"ItemSetItemEquipped",
}

function PANEL:Init()
	self:SetVisible(true)
	self:SetPaintBackgroundEnabled(false)
end

function PANEL:UpdateAttributePanel()
	if not self.AttributePanel then
		return
	end
	
	local x, y = self:GetPos()
	if self.attributes then
		PrintTable(self.attributes)
	end
--	self.AttributePanel:SetPos(x+self.Offset.x, y+self.Offset.y)
	self.AttributePanel.text = self.text
	self.AttributePanel.attributes = self.attributes
	self.AttributePanel.qualitycolor = self.qualitycolor
end

function PANEL:SetAttributePanel(p, offsetx, offsety)
	self.AttributePanel = p
	self.Offset = {x=offsetx, y=offsety}
end

function PANEL:SetQuality(q)
	q = "QualityColor"..q
	if Colors[q] then
		self:SetTextColor(Colors[q])
	end
end

function PANEL:SetTextColor(c)
	self.textcolor = c
end

function PANEL:Paint(w, h)
	if self.invisible then return end
	if !isnumber(self.itemImage) then return end
	
	local w, h = self:GetSize()
	
	surface.SetDrawColor(255,255,255,255)
	
	if self.activeImage and self.inactiveImage then
		-- Image button
		if self.srcborder and self.drawborder then
			local mat
			if self.Hover then
				mat = self.activeImage
			else
				mat = self.inactiveImage
			end
			tf_draw.BorderPanel(mat,
				0,0,w,h,
				self.srcborder,self.srcborder,self.drawborder,self.drawborder
			)
		else
			if self.Hover then
				surface.SetTexture(self.activeImage)
			else
				surface.SetTexture(self.inactiveImage)
			end
			surface.DrawTexturedRect(0, 0, w, h)
		end
	end
	
	if self.itemImage and self.model_tall then
		local x = w/2 + (self.model_xpos or 0) * Scale
		local y = (self.model_ypos + self.model_tall/2)*Scale
		local sx = self.model_tall*Scale*0.8
		
		if IsEntity(self.itemImage) and self.itemImage.DrawWeaponSelection then
			self.itemImage:DrawWeaponSelection(x - sx*1.3, y - 0.9*sx, 2.6*sx, 2.6*sx, 255)
		else
			local tex
			
			if self.model_tall>50 and self.itemImage_hi then
				tex = self.itemImage_hi
			else
				tex = self.itemImage
			end

			if !isnumber(tex) then return end
			
			surface.SetTexture(tex)
			local rx, ry = surface.GetTextureSize(tex)
			local sy = sx * ry/rx

			if self.FallbackModel then
				if !ispanel(self.wep) then
					self.wep = vgui.Create( "DModelPanel", self )
					self.wep:SetModel(self.FallbackModel)
					if rx>ry then
						if self.model_tall<=50 then
							self.wep:SetPos(x - sx * 0.96, y - sy * 1.52)
							self.wep:SetSize(2.21*sx, 2.55*sy)
						else
							self.wep:SetPos(x - sx * 1.05, y - sy * 1.43)
							self.wep:SetSize(2.28*sx, 2.55*sy)
						end
					else
						self.wep:SetPos(x - sx * 0.95, y - sy * 0.95)
						self.wep:SetSize(1.85*sx, 1.85*sy)
					end
					local mn, mx = self.wep.Entity:GetRenderBounds()
					local size = 0
					size = math.max( size, math.abs( mn.x ) + math.abs( mx.x ) )
					size = math.max( size, math.abs( mn.y ) + math.abs( mx.y ) )
					size = math.max( size, math.abs( mn.z ) + math.abs( mx.z ) )

					self.wep:SetFOV( 45 )
					self.wep:SetCamPos( Vector( size, size, size ) )
					self.wep:SetLookAt( ( mn + mx ) * 0.5 )
					self.wep.LayoutEntity = function() end
					self.wep:SetMouseInputEnabled(false)

					if self.overridematerial then
						self.wep.Entity:SetMaterial(self.overridematerial)
					end
				end
			else
				if rx>ry then
					if self.model_tall<=50 then
						surface.DrawTexturedRect(x - sx * 0.96, y - sy * 1.52, 2.21*sx, 2.55*sy)
					else
						surface.DrawTexturedRect(x - sx * 1.05, y - sy * 1.43, 2.28*sx, 2.55*sy)
					end
				else
					surface.DrawTexturedRect(x - sx * 0.95, y - sy * 0.95, 1.85*sx, 1.85*sy)
				end
			end
		end
	end
	
	if self.text then
		local color = self.textcolor or Colors.QualityColorNormal
		--local font = (self.model_tall<=50 and "ItemFontNameSmall") or "ItemFontNameLarge"
		local font = "ItemFontNameSmall"
		
		if not self.itemImage then
			color = Color(117, 107, 94, 255)
		end
		
		surface.SetFont(font)
		local maxwidth = surface.GetTextSize(self.text)
		if maxwidth>w*0.9 then
			--font = (self.model_tall<=50 and "ItemFontNameSmallest") or "ItemFontNameSmall"
			font = "ItemFontNameSmallest"
		end
		
		local x = (self.text_xpos or 1) * Scale
		local tw = (self.text_wide and self.text_wide * Scale) or (w - 2*Scale)
		
		local name_tab = {
			x=x,y=(self.text_ypos-12)*Scale,
			w=tw,h=20*Scale,
			font=font,
			text=self.text,
			col=color,
			align="south",
		}
		local attr_tab
		
		local text_height = tf_draw.LabelTextWrap(name_tab, true)
		local att_height
		local total_height = text_height
		
		if self.attributes and #(self.attributes)>0 then
			attr_tab = {
				x=x,y=(self.text_ypos+9)*Scale,
				w=tw,h=100*Scale,
				font="ItemFontAttribSmall",
				text=self.attributes,
				yspace=0,
				col=attribcolors,
				align="north",
			}
			
			att_height = tf_draw.LabelTextWrap(attr_tab, true)
			total_height = text_height + att_height
		end
		
		if self.centertext then
			local ty = (h - total_height)/2
			name_tab.y = ty
			name_tab.h = text_height
			
			if attr_tab then
				attr_tab.y = ty+text_height
			end
		end
		
		tf_draw.LabelTextWrap(name_tab)
		if attr_tab then tf_draw.LabelTextWrap(attr_tab) end
	end
	
	if self.number then
		local color
		if self.Hover then
			color = Colors.TanLight
		else
			color = Colors.TanDark
		end
		
		draw.Text{
			text=self.number,
			font="TFHudSelectionText",
			pos={w-17*Scale, 9*Scale},
			color=color,
			x_align=TEXT_ALIGN_CENTER,
			y_align=TEXT_ALIGN_TOP,
		}
	end
end

function PANEL:OnCursorEntered()
	if self.invisible or self.disabled then return end
	self.Hover = true
	if self.AttributePanel then
		self:UpdateAttributePanel()
		self.AttributePanel:SetVisible(true)
	end
end

function PANEL:OnCursorExited()
	if self.invisible or self.disabled then return end
	self.Hover = false
	if self.AttributePanel then
		self.AttributePanel:SetVisible(false)
	end
end

function PANEL:OnMousePressed(b)
	if self.disabled then return end
	if b==MOUSE_LEFT then
		self:DoClick()
	end
end

function PANEL:DoClick()
end

vgui.Register("ItemModelPanel", PANEL)
