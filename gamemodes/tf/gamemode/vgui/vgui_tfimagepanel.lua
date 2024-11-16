local PANEL = {}

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:SetVisible(true)
end

function PANEL:Paint()
	if self.image then
		local w, h = self:GetSize()
		
		surface.SetDrawColor(255, 255, 255, 255)
		if self.scaleImage then
			surface.SetTexture(self.image)
			surface.DrawTexturedRect(0, 0, w, h)
		elseif self.tileImage then
			tf_draw.TexturedQuadTiled(self.image, 0, 0, w, h, {x=self.tileHorizontally,y=self.tileVertically})
		else
			local w2, h2 = surface.GetTextureSize(self.image)
			surface.SetTexture(self.image)
			surface.DrawTexturedRect(0, 0, w2, h2)
		end
	end
end

vgui.Register("TFImagePanel", PANEL)