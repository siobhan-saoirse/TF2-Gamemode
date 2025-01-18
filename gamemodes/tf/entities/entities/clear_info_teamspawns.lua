AddCSLuaFile()
ENT.Type = "anim"
ENT.Team = TEAM_RED
ENT.Spawnable = true
ENT.PrintName = "Clear Team Spawnpoints"
ENT.Category = "Team Fortress 2" 
ENT.AdminOnly = true


function ENT:SpawnFunction(pl, tr)
	if not tr.Hit then return end
	
	local pos = tr.HitPos
	
	local ent = ents.Create(self.ClassName)
	ent:SetPos(pos)
	ent:Spawn()
	ent:Activate()
	
	ent:SetPos(pos - Vector(0,0,ent:OBBMins().z))

	for k,v in ipairs(ents.FindByClass("info_player_teamspawn")) do

		local ent = ents.Create("info_player_start")
		ent:SetPos(v:GetPos())
		ent:Spawn()
		ent:Activate()
		v:Remove()

	end
	
	return ent
end

function ENT:Initialize()
    
	self:Remove()

end