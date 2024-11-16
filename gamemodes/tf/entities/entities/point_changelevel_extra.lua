AddCSLuaFile()

ENT.Type = "point"

function ENT:AcceptInput(name, activator, caller, data)
	if (name == "changelevel" || name == "Changelevel") then
		GAMEMODE:GrabAndSwitchExtra()
	end
end