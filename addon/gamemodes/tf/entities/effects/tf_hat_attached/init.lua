
function EFFECT:Init(data)
	local hat = data:GetEntity()
	local pl = hat:GetOwner()
	self.Parent = pl:GetRagdollEntity()
	
	if not IsValid(self.Parent) then
		return
	end
	
	local mdl = hat.Model
	if not mdl then
		self.Parent = nil
		return
	end
	
	if hat.GetItemTint then
		self.ItemTint = hat:GetItemTint()
	else
		self.ItemTint = 0
	end
	
	self:SetModel(mdl)
	self:AddEffects(EF_BONEMERGE)
	self:SetParent(self.Parent)
	
	self:CopyVisualOverrides(hat)
	hat.InitVisuals(self, pl, hat:GetVisuals())
end

function EFFECT:Think()
	return IsValid(self.Parent)
end

function EFFECT:Render()
	self:StartVisualOverrides()
	self:StartItemTint(self.ItemTint)
	self:DrawModel()
	self:EndItemTint()
	self:EndVisualOverrides()
end
