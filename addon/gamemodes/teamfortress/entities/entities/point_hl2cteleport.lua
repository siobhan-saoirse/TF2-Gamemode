AddCSLuaFile()

ENT.Type = "point"

function ENT:AcceptInput(name, activator, caller, data)
	if (name == "teleport" || name == "Teleport") then
		for _, pl in pairs(player.GetAll()) do
			pl:SetPos(self:GetPos())
		end
	end
end