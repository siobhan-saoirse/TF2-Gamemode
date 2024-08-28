local PANEL = {}
	
function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:SetVisible(true)
end

function PANEL:Paint()
	if self.labelText then
		local w, h = self:GetSize()
		local text = self.labelText
		local color = self.fgcolor
		
		if type(text)=="function" then text = text() end
		if type(color)=="function" then color = color() end
		
		tf_draw.LabelText(
			0,
			0,
			w,
			h,
			text,
			color or "TanLight",
			self.font or "Default",
			self.textAlignment or "north-west"
		)
	end
end

vgui.Register("TFLabel", PANEL)