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
			fc = Color(235,226,202,255) -- Colors.TanLight
			bc = Color(145,73,59,255) -- Colors.TFOrange
		else
			fc = Color(235,226,202,255) -- Colors.TanLight
			bc = Color(117,107,94,255) -- Colors.TanDark
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
	if (!self.Hover) then
		--surface.PlaySound("ui/buttonrollover.wav")
	end
	self.Hover = true
end

function PANEL:OnCursorExited()
	if self.invisible or self.disabled then return end
	self.Hover = false
end

function PANEL:OnMousePressed(b)
	if self.disabled then return end
	if b==MOUSE_LEFT then
		surface.PlaySound("ui/buttonclick.wav")
		timer.Simple(0.1, function()
			surface.PlaySound("ui/buttonclickrelease.wav")
		end)
		self:DoClick()
	end
end

function PANEL:DoClick()
end

vgui.Register("TFButton", PANEL)
