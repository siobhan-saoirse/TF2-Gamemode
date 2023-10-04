ENT.Base = "base_brush"
ENT.Type = "brush"


function ENT:Initialize()
	local pos = self:GetPos()
	local mins, maxs = self:WorldSpaceAABB() -- https://forum.facepunch.com/gmoddev/lmcw/Brush-entitys-ent-GetPos/1/#postdwfmq
	pos = (mins + maxs) * 0.5

	self.Team = self.Team or 0		
	self.TeamNum = self.TeamNum or 0
	self.Pos = pos 
	self.Players = {}
	self:SetSolid(SOLID_BBOX)
	self:SetCustomCollisionCheck( true ) 
end 

function ENT:KeyValue(key,value)
	key = string.lower(key)
	if key =="respawnroomname" then
		for k,v in ipairs(ents.GetAll()) do
			local t = tostring(value)
			if (v:GetName() == t) then
				self.RespawnRoom = v
				self.TeamNum = v.TeamNum
				print(t)
			end
		end
	end
	print(key, value, tostring(value), self.RespawnRoom)
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() then
		if (!string.find(game.GetMap(), "mvm_")) then -- suck my dick
			if (ent:Team() != TEAM_YELLOW and ent:Team() != TEAM_GREEN and ent:Team() != TEAM_NEUTRAL and ent:Team() != TEAM_FRIENDLY) then
				--[[if ((self.TeamNum == ent:Team() or ent:Team() == self.TeamNum) and ent:Team() != TEAM_SPECTATOR and ent:Team() != 0) then
					ent:KillSilent()
					ent:Spawn()
					ent:PrintMessage(HUD_PRINTCENTER,"You are not allowed to enter enemy spawnrooms.")
				end]]
			end 
		end
	end
end
 
hook.Add( "ShouldCollide", "RespawnRoomVisualizerCollision", function( ent1, ent2 )

    -- If players are about to collide with each other, then they won't collide.
    if ( ent1:GetClass() == "func_respawnroomvisualizer" and ent2:IsPlayer() ) then 
		if (ent1.TeamNum == TEAM_RED) then
			if (ent2:Team() != TEAM_RED) then
				return true
			else
				return false
			end
		elseif (ent1.TeamNum == TEAM_BLU) then
			if (ent2:Team() != TEAM_BLU) then
				return true
			else
				return false
			end
		end
    elseif ( ent2:GetClass() == "func_respawnroomvisualizer" and ent1:IsPlayer() ) then 
		if (ent2.TeamNum == TEAM_RED) then
			if (ent1:Team() != TEAM_RED) then
				return true
			else
				return false
			end
		elseif (ent2.TeamNum == TEAM_BLU) then
			if (ent1:Team() != TEAM_BLU) then
				return true
			else
				return false
			end
		end
	end

end )