
EFFECT.LifeTime = 10
EFFECT.FadeTime = 2

EFFECT.Model = "models/weapons/w_models/w_arrow.mdl"

function EFFECT:Init(data)
	local ent, pos, ang, physbone = data:GetEntity(), data:GetOrigin(), data:GetAngles(), data:GetAttachment()
	
	self:SetModel(self.Model)
	self:SetPos(pos)
	self:SetAngles(ang)
	
	if IsValid(ent) then
		local bone = ent:TranslatePhysBoneToBone(physbone)
		local bonepos, boneang = ent:GetBonePosition(bone)
		if bonepos and boneang then
			self.Parent = ent
			if IsValid(ent.DeathRagdoll) then self.Parent = ent.DeathRagdoll end
			self.Bone = bone
			
			local dir, normal = ang:Forward(), ang:Up()
			local X, Y, Z = boneang:Forward(), boneang:Right(), boneang:Up()
			
			if self.Parent:GetClass()=="class C_HL2MPRagdoll" or self.Parent:GetClass()=="class C_ClientRagdoll" or self.Parent:GetClass()=="prop_ragdoll" then
				local phys = self.Parent:GetPhysicsObjectNum(physbone)
				if IsValid(phys) then
					local tr = util.TraceLine{
						start = pos,
						endpos = pos + dir * 80,
						mask = MASK_SOLID_BRUSHONLY,
					}
					if tr.Hit and not tr.HitSky then
						-- Pin the ragdoll
						
						pos = tr.HitPos - dir * 5
						
						if self.Parent:GetClass() ~= "prop_ragdoll" then
							self.PhysObj = phys
							self.NextPhysFreeze = CurTime() + 0.05
							EndDeathPose(self.Parent)
							phys:SetPos(pos)
						end
						
						pos = pos + dir * 8
						self:SetPos(pos)
						
						self.NoAttach = true
						return
					end
				end
			end
			
			local diff = pos - bonepos
			
			self.RelativePosition = Vector(diff:Dot(X),diff:Dot(Y),diff:Dot(Z))*0.5
			self.RelativeDirection = Vector(dir:Dot(X),dir:Dot(Y),dir:Dot(Z))
			self.RelativeNormal = Vector(normal:Dot(X),normal:Dot(Y),normal:Dot(Z))
			
			if not self.Parent.StuckArrows then self.Parent.StuckArrows = {} end
			self.Parent.StuckArrows[self] = true
		end
		
		self:SetParent(ent)
	else
		self.NextDeath = CurTime() + self.LifeTime
	end
end

function EFFECT:Think()
	if self.NextPhysFreeze and CurTime() > self.NextPhysFreeze then
		if self.PhysObj and self.PhysObj:IsValid(self.WModel2) then
			self.PhysObj:EnableMotion(false)
		end
		self.NextPhysFreeze = nil
	end
	
	if self.NextDeath then
		local diff = self.NextDeath - CurTime()
		
		if diff<self.FadeTime then
			local a = math.Clamp(255*diff/self.FadeTime, 0, 255)
			self:SetColor(Color(255,255,255,a))
		end
		
		return diff>0
	elseif IsValid(self.Parent) then
		local _,_,_,a = self.Parent:GetColor()
		self:SetColor(Color(255,255,255,a))
		
		return true
	else
		return false
	end
end

function EFFECT:Render()
	if self.Parent==LocalPlayer() then
		if not LocalPlayer():ShouldDrawLocalPlayer() then
			return
		end
	end
	
	if not self.NoAttach and IsValid(self.Parent) then
		local pos, ang = self.Parent:GetBonePosition(self.Bone)
		pos = pos +
			self.RelativePosition.x * ang:Forward() +
			self.RelativePosition.y * ang:Right() +
			self.RelativePosition.z * ang:Up()
		local dir = 
			self.RelativeDirection.x * ang:Forward() +
			self.RelativeDirection.y * ang:Right() +
			self.RelativeDirection.z * ang:Up()
		ang = dir:Angle()
		
		self:SetPos(pos)
		self:SetAngles(ang)
	end
	
	self:DrawModel()
end
