
include("shared.lua")

ENT.RenderGroup = RENDERGROUP_BOTH

function ENT:Initialize()
	self.Model = ClientsideModel("models/props_junk/watermelon01.mdl")
	self.Model:SetNoDraw(true)
	self.Model:DrawShadow(false)
	
	self.CurrentYaw = 0
	self.TargetYaw = 0
	self.Rotation = 0
end

function ENT:DrawTranslucent()
	if not IsValid(self.Player) then
		self.Player = self:GetOwner().Owner
	end
	
	if self.LastDrawn then
		local dt = CurTime() - self.LastDrawn
		self.Model:FrameAdvance(dt)
		
		if self.CurrentYaw ~= self.TargetYaw then
			local old = self.CurrentYaw
			self.CurrentYaw = self.CurrentYaw + self.RotationSpeed * dt
			if old < self.TargetYaw and self.CurrentYaw >= self.TargetYaw then
				self.CurrentYaw = self.TargetYaw
			end
			self.CurrentYaw = math.NormalizeAngle(self.CurrentYaw)
		end
	end
	self.LastDrawn = CurTime()
	
	
	if IsValid(self.Player) then
		local pos, ang = self:CalcPos(self.Player)
		if ang then
			ang.y = math.NormalizeAngle(ang.y + self.CurrentYaw)
			self.Model:SetModel(self:GetModel())
			self.Model:SetSkin(self:GetSkin())
			self.Model:SetRenderOrigin(pos)
			self.Model:SetRenderAngles(ang)
			self.Model:DrawModel()
		end
	end
end

function ENT:Think()
	if not IsValid(self.Player) then
		self.Player = self:GetOwner().Owner
	end
	
	if self.LastScale ~= self.dt.Scale then
		local s = self.dt.Scale
		if s > 0 then
			self.Model:SetModelScale( 0.8, 0 )
		end
		self.LastScale = s
	end
	
	if self.AllowedState ~= self.dt.Allowed then
		self.Model:SetModel(self:GetModel())
		self.Model:SetSkin(self:GetSkin())
		self.AllowedState = self.dt.Allowed
		if self.AllowedState then
			self.Model:ResetSequence(self.Model:SelectWeightedSequence(ACT_OBJ_PLACING))
			if self.Player == LocalPlayer() then
				self.Model:SetBodygroup(1, 1)
			else
				self.Model:SetBodygroup(1, 0)
			end
		else
			self.Model:ResetSequence(self.Model:SelectWeightedSequence(ACT_OBJ_IDLE))
			self.Model:SetBodygroup(1, 0)
		end
	end
	
	if self.Rotation ~= self.dt.Rotation then
		self.Rotation = self.dt.Rotation
		self.TargetYaw = math.NormalizeAngle(90 * self.Rotation)
	end
end

function ENT:OnRemove()
	if IsValid(self.Model) then
		self.Model:Remove()
	end
end
