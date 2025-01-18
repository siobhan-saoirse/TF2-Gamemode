AddCSLuaFile()
ENT.Type = "anim"
ENT.Team = TEAM_RED
ENT.Spawnable = true
ENT.PrintName = "RED Spawnpoint"
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
    ent:SetAngles((pl:GetPos() - ent:GetPos()):Angle())

	local point = ents.Create("info_player_teamspawn")
	point:SetPos(pos)
    point:SetKeyValue("TeamNum",self.Team)
	point:Spawn()
	point:Activate()
	point:SetPos(pos - Vector(0,0,ent:OBBMins().z))
    point:SetParent(ent)
	
	return ent
end

function ENT:Initialize()
    
	self:SetModel("models/editor/playerstart.mdl")
	self:SetMaterial("models/debug/debugwhite")
	self:SetColor(Color(team.GetColor(self.Team).r,team.GetColor(self.Team).g,team.GetColor(self.Team).b,100))
	self:SetRenderMode(RENDERMODE_TRANSCOLOR)
	self:SetRenderFX(kRenderFxHologram)
	self:SetSolid(SOLID_BBOX)
	self:SetModelScale(1.0)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)

end