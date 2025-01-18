-- observer point for spectating
AddCSLuaFile()
ENT.Type = "anim"

function ENT:Initialize()
	self:SetModel("models/editor/camera.mdl")
    self:SetNoDraw(true)
end
