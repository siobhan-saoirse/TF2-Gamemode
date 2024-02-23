-- observer point for spectating
AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:Initialize()
	self:SetModel("models/editor/camera.mdl")
    self:SetNoDraw(true)
end
