local PANEL = {}

function PANEL:Init()
	self:SetVisible(true)
	self:SetPaintBackgroundEnabled(false)
end

function PANEL:Paint()
	if self.invisible then return end
	
	local w, h = self:GetSize()
	
	if self.activeImage and self.inactiveImage then
		-- Image button
		surface.SetDrawColor(255,255,255,255)
	
		if self.Hover then
			surface.SetTexture(self.activeImage)
		else
			surface.SetTexture(self.inactiveImage)
		end
		surface.DrawTexturedRect(0, 0, w, h)
	else
		-- Text button
		local fc, bc
		if self.Hover then
			fc = Colors.TanDarker
			bc = Colors.Orange
		else
			fc = Colors.TanDark
			bc = Colors.TanLight
		end
		
		draw.RoundedBox(6, 0, 0, w, h, bc)
	
		if self.labelText then
			draw.Text{
				text=self.labelText,
				font=self.font,
				pos={w/2,h/2},
				color=fc,
				xalign=TEXT_ALIGN_CENTER,
				yalign=TEXT_ALIGN_CENTER,
			}
		end
	end
end

function PANEL:OnCursorEntered()
	if self.invisible or self.disabled then return end
	self.Hover = true
end

function PANEL:OnCursorExited()
	if self.invisible or self.disabled then return end
	self.Hover = false
end

function PANEL:OnMousePressed(b)
	if self.disabled then return end
	if b==MOUSE_LEFT then
		self:DoClick()
	end
end

function PANEL:DoClick()
end

vgui.Register("TFButton", PANEL)
