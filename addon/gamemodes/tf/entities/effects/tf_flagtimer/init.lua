
function EFFECT:Init(data)
	self.Target = data:GetEntity()
	self:SetPos(self.Target:GetPos()+Vector(0,0,50))
	self:SetParent(self.Target)
	
	self.Progress = vgui.Create("CircularProgressBar")
	self.Progress:SetPos(0, 0)
	self.Progress:SetSize(128, 128)
	self.Progress:SetBackgroundTexture("vgui/flagtime_empty")
	self.Progress:SetForegroundTexture("vgui/flagtime_full")
	self.Progress:SetProgress(0)
	self.Progress:SetVisible(false)
end

function EFFECT:Think()
	return IsValid(self.Target)
end

function EFFECT:Render()
	cam.Start3D(self:GetPos(), EyeAngles())
		draw.RoundedBox(8, 50, 50, 100, 100, Color( 255, 255, 255 ))
		self.Progress:Paint()
	cam.End3D()
end
