local W = ScrW()
local H = ScrH()
local Scale = H/480

local health_bg = surface.GetTextureID("hud/health_bg")
local health_color = surface.GetTextureID("hud/health_color")
local health_equip_bg = surface.GetTextureID("hud/health_equip_bg")
local health_over_bg = surface.GetTextureID("hud/health_over_bg")
local health_dead = surface.GetTextureID("hud/health_dead")

local PANEL = {}

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	--self:ParentToHUD()
	self:SetVisible(true)
end

function PANEL:PerformLayout()
	if !IsValid(LocalPlayer()) then return end
	
	self:SetSize(32*Scale,32*Scale)
end

function PANEL:SetTargetEntity(e, freeze)
	self.Target = e
	
	if freeze and IsValid(self.Target) then
		local health
		local maxhealth = 100
		
		health, maxhealth = self.Target:Health(), self.Target:GetMaxHealth()
		--[[
		if self.Target:IsPlayer() then
			health = self.Target:Health()
			
			local tbl = self.Target:GetPlayerClassTable()
		
			if tbl and tbl.Health then
				maxhealth = tbl.Health
			end
		else
			health = self.Target:GetNWFloat("Health") or 0
			maxhealth = self.Target:GetNWFloat("MaxHealth") or 1
		end
		
		if maxhealth==0 then
			health, maxhealth = 1,1
		end]]
		
		self.FixedHealth = health
		self.FixedMaxHealth = maxhealth
		self.FixedTargetIsBuilding = self.Target:IsBuilding()
	else
		self.FixedHealth = nil
		self.FixedMaxHealth = nil
		self.FixedTargetIsBuilding = nil
	end
end

function PANEL:Paint()
	--if GetConVarNumber("cl_drawhud")==0 then return end
	
	local size, amplitude, frequency
	local health
	local maxhealth = 100
	local isbuilding
	
	if self.FixedHealth and self.FixedMaxHealth then
		health = self.FixedHealth
		maxhealth = self.FixedMaxHealth
		isbuilding = self.FixedTargetIsBuilding
	elseif not IsValid(self.Target) then
		surface.SetTexture(health_dead)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect(5*Scale, 5*Scale, 22*Scale, 22*Scale)
		return
	else
		--[[if self.Target:IsPlayer() then
			health = self.Target:Health()
			
			local tbl = self.Target:GetPlayerClassTable()
		
			if tbl and tbl.Health then
				maxhealth = tbl.Health
			end
		else
			health = self.Target:GetNWFloat("Health") or 0
			maxhealth = self.Target:GetNWFloat("MaxHealth") or 1
		end
		
		if maxhealth==0 then
			health, maxhealth = 1,1
		end]]
		health, maxhealth = self.Target:Health(), self.Target:GetMaxHealth()
		
		isbuilding = self.Target:IsBuilding()
	end
	
	if health<=0 then
		surface.SetTexture(health_dead)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect(5*Scale, 5*Scale, 22*Scale, 22*Scale)
		return
	end
	
	if isbuilding then
		surface.SetTexture(health_equip_bg)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect(0*Scale, 2*Scale, 28*Scale, 28*Scale)
	end
	
	local ratio = math.Clamp(health/maxhealth,0,1)
	
	--local tbl = LocalPlayer():GetPlayerClassTable()
	
	--[[if 2*health<maxhealth then -- Low health warning
		size = (maxhealth - 2*health)/maxhealth
		frequency = 20
		amplitude = math.Clamp(size*127, 0, 127)
		
		surface.SetTexture(health_over_bg)
		surface.SetDrawColor(255,0,0,128+amplitude*math.sin(frequency*CurTime()))
		surface.DrawTexturedRect((5-size*11)*Scale, (5-size*11)*Scale, (1+size)*22*Scale, (1+size)*22*Scale)
	else]]
	if health>maxhealth then -- Overheal
		size = (health-maxhealth)/maxhealth
		frequency = 20
		amplitude = math.Clamp(size*127, 0, 127)
		
		if self.Static then amplitude = 0 end
		
		surface.SetTexture(health_over_bg)
		surface.SetDrawColor(255,255,255,128+amplitude*math.sin(frequency*CurTime()))
		surface.DrawTexturedRect((5-size*11)*Scale, (5-size*11)*Scale, (1+size)*22*Scale, (1+size)*22*Scale)
	end
	
	surface.SetTexture(health_bg)
	surface.SetDrawColor(255,255,255,255)
	surface.DrawTexturedRect(5*Scale, 5*Scale, 22*Scale, 22*Scale)
	
	local x,y,w,h = math.ceil(7*Scale), math.ceil(7*Scale), math.ceil(18*Scale), math.ceil(18*Scale)
	surface.SetTexture(health_color)
	
	if 2*health<maxhealth then
		surface.SetDrawColor(255,0,0,255)
	else
		surface.SetDrawColor(255,255,255,255)
	end
	
	local y2 = y+h*(1-ratio)
	tf_draw.TexturedQuadPart(health_color, x, y2, w, (y+h)-y2, 0, 128*(1-ratio), 128, 128*ratio)
end

vgui.Register("SpectatorGUIHealth", PANEL, "DPanel")
