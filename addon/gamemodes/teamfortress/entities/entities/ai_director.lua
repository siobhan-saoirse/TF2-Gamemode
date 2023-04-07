ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.Director = nil

function ENT:Initialize()
    self.Director = ents.Create("l4d2_ai_director")
    self.Director:SetPos(self:GetPos())
    self.Director:SetAngles(self:GetAngles())
    self.Director:Spawn()
    self.Director:Activate()
end

function ENT:OnRemove()
    if (IsValid(self.Director)) then

        self.Director:Remove()

    end
end