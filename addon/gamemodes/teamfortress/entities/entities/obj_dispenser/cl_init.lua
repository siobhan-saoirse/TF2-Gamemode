
include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

local ScreenTexture = {
	[0]=surface.GetTextureID("vgui/dispenser_meter_bg_red"),
	[1]=surface.GetTextureID("vgui/dispenser_meter_bg_blue"),
}
local ArrowTexture = surface.GetTextureID("vgui/dispenser_meter_arrow")
local Offset = Vector(-1.1, -11, -0.6)
local Scale=0.0465
local DialSpeed = 1
local AngleStart = 85
local AngleEnd = -85

function ENT:CalcAngle(m)
	return Lerp(m, AngleStart, AngleEnd)
end



function ENT:Draw()
	if self:GetState()<2 then return end
	
	if not self.Model then
		for _,v in pairs(ents.FindByClass("obj_anim")) do
			if v:GetOwner() == self then
				self.Model = v
				break
			end
		end
	end
	
	if not IsValid(self.Model) then return end
	
	local metal = self:GetAmmoPercentage()
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
	
	local cp0_ll = self.Model:GetAttachment(self:LookupAttachment("controlpanel0_ll"))
	local cp1_ll = self.Model:GetAttachment(self:LookupAttachment("controlpanel1_ll"))
	
	if self:GetBuildingType() != 1 and self:GetBuildingType() != 2 then
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
end

function ENT:DrawScreen()
	surface.SetDrawColor(255,255,255,255)
	if self:Team() == TEAM_BLU then
		surface.SetTexture(ScreenTexture[1])
	else
		surface.SetTexture(ScreenTexture[0])
	end
	
	surface.DrawTexturedRect(0, 0, 480, 240)
	surface.SetTexture(ArrowTexture)
	
	local a = self.Ang
	local r = math.rad(a)
	local s, c = math.sin(r), math.cos(r)
	
	surface.DrawTexturedRectRotated(480*0.5 - math.floor(81*s), 240*0.90625 - math.floor(81*c), 50, 200, a)
end
