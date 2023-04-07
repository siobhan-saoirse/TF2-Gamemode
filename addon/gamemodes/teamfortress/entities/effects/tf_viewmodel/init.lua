
concommand.Add("vm_test", function(pl)
	local effectdata = EffectData()
		--effectdata:SetEntity(pl)
	util.Effect("tf_viewmodel", effectdata)
end)

function EFFECT:Init(data)
	--self.Owner = data:GetEntity()
	self.Owner = LocalPlayer()
	
	self.Entity:SetModel("models/weapons/v_models/v_scattergun_scout.mdl")
	
	self.Entity:SetSequence(self:SelectWeightedSequence(ACT_VM_IDLE))
	self.Entity:SetCycle(999999)
	self.Entity:SetPlaybackRate(1)
end

function EFFECT:Think()
	return true
end

function EFFECT:Render()
	if not self.Owner then return end
	
	local vm = self.Owner:GetViewModel()
	self.Entity:SetPos(vm:GetPos())
	self.Entity:SetAngles(vm:GetAngles())
	
	cam.Start3D(EyePos(), EyeAngles(), 64)
		cam.IgnoreZ(true)
		self.Entity:SetModel("models/weapons/v_models/v_scattergun_scout.mdl")
		self.Entity:DrawModel()
		self.Entity:SetModel("models/weapons/v_models/v_pistol_scout.mdl")
		self.Entity:DrawModel()
		cam.IgnoreZ(false)
	cam.End3D()
end
