
function EFFECT:Init(data)
	if IsValid(data:GetEntity()) and data:GetEntity():GetClass()=="obj_dispenser" then
		self.Dispenser = data:GetEntity()
		self:SetPos(self.Dispenser:GetPos())
		self:SetRenderBounds(self.Dispenser:GetRenderBounds())
	end
end

function EFFECT:Think()
	if not IsValid(self.Dispenser) then
		return false
	end
	return true
end

local ScreenTexture = {
	[0]=surface.GetTextureID("vgui/dispenser_meter_bg_red"),
	[1]=surface.GetTextureID("vgui/dispenser_meter_bg_blue"),
}
local ArrowTexture = surface.GetTextureID("vgui/dispenser_meter_arrow")
local Offset = Vector(-0.4, 0, -0.7)
local Scale = 0.082
local DialSpeed = 1
local AngleStart = 86
local AngleEnd = -90
local MaxMetal = 400

local function RotatedRect(x, y, w, h, ox, oy, a)
	local dx, dy = 10*(w*ox-w/2), 10*(h*oy-h/2)
	local s, c = math.sin(math.rad(a)), math.cos(math.rad(a))
	local ex, ey = dx * c + dy * s, dy * c - dx * s
	
	dx, dy = dx-ex, dy-ey
	
	surface.DrawTexturedRectRotated(x+dx/10, y+dy/10, w, h, a)
end

function EFFECT:CalcAngle(m)
	return AngleStart + (AngleEnd - AngleStart) * m / MaxMetal
end

function EFFECT:Render()
	local _,_,_,a = self.Dispenser:GetColor()
	if a==0 then return end
	
	local state = self.Dispenser:GetNWInt("State") or 0
	if state<2 then return end
	
	local metal = self.Dispenser:GetNWInt("Metal") or 0
	if metal and metal~=self.LastMetalAmount then
		if not self.Ang then
			self.Ang = self:CalcAngle(metal)
		else
			if metal>self.LastMetalAmount then
				self.DAng = -DialSpeed
			else
				self.DAng = DialSpeed
			end
			self.TargetAngle = self:CalcAngle(metal)
		end
		self.LastMetalAmount = metal
	elseif self.TargetAngle then
		if self.Ang*self.DAng > self.TargetAngle*self.DAng then
			self.Ang = self.TargetAngle
			self.TargetAngle = nil
		else
			self.Ang = self.Ang + self.DAng
		end
	end
	
	local cp0_ll = self.Dispenser:GetAttachment(self.Dispenser:LookupAttachment("controlpanel0_ll"))
	local cp1_ll = self.Dispenser:GetAttachment(self.Dispenser:LookupAttachment("controlpanel1_ll"))
	
	cam.Start3D2D(cp0_ll.Pos
		+ Offset.x * cp0_ll.Ang:Forward()
		+ Offset.y * cp0_ll.Ang:Right()
		+ Offset.z * cp0_ll.Ang:Up(), cp0_ll.Ang, Scale)
		self:DrawScreen()
	cam.End3D2D()
	
	cam.Start3D2D(cp1_ll.Pos
		+ Offset.x * cp1_ll.Ang:Forward()
		+ Offset.y * cp1_ll.Ang:Right()
		+ Offset.z * cp1_ll.Ang:Up(), cp1_ll.Ang, Scale)
		self:DrawScreen()
	cam.End3D2D()
end

function EFFECT:DrawScreen()
	local r,g,b,a = self.Dispenser:GetColor()
	surface.SetDrawColor(r,g,b,a)
	surface.SetTexture(ScreenTexture[self.Dispenser:GetSkin()] or ScreenTexture[0])
	surface.DrawTexturedRect(0, -128, 256, 128)
	surface.SetTexture(ArrowTexture)
	RotatedRect(128,-64, 32, 128, 0.5, 0.90625, self.Ang)
end