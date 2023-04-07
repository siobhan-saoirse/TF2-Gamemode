// Entity information
ENT.Base = "base_anim"
ENT.Type = "anim"


// Called when the entity first spawns
function ENT:Initialize()
	self.ipsLocation = Vector(self.pos.x, self.pos.y, self.min.z + 8)
	
	local w = self.max.x - self.min.x
	local l = self.max.y - self.min.y
	local h = self.max.z - self.min.z
	
	local min = Vector(0 - (w / 2), 0 - (l / 2), 0 - (h / 2))
	local max = Vector(w / 2, l / 2, h / 2) 
	
	self:DrawShadow(false)
	self:SetCollisionBounds(min, max)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetMoveType(0)
	self:SetTrigger(true)
end


// Called when an entity touches it
function ENT:StartTouch(ent)
	if ent && ent:IsValid(self.WModel2) && ent:IsPlayer() && ent:Team() == TEAM_ALIVE && !self.triggered then
		self.triggered = true
		
		if self.OnTouchRun then
			self:OnTouchRun()
		end
		
		local ang = ent:GetAngles()
		
		if !self.skipSpawnpoint then
			GAMEMODE:CreateSpawnPoint(self.ipsLocation, ang.y)
		end
		
		for _, pl in pairs(player.GetAll()) do
			if pl && pl:IsValid(self.WModel2) && pl != ent && pl:Team() == TEAM_ALIVE then
				if pl:GetVehicle() && pl:GetVehicle():IsValid(self.WModel2) then
					// This just causes mayhem.
					-- pl:GetVehicle():SetPos(self.ipsLocation)
					-- pl:GetVehicle():SetAngles(ang)
					pl:ExitVehicle() -- Make the player exit the vehicle and then teleport.
					pl:SetPos(self.ipsLocation)
					pl:SetAngles(ang)
				else
					pl:SetPos(self.ipsLocation)
					pl:SetAngles(ang)
				end
			end
		end
		
		// We're going to allow checkpoint respawning now. It gets out of hand when players are dead forever.
		if GetConVarNumber("hl2c_classic") == 0 then
			GAMEMODE:HL2CForceRespawn()
		end
		
		table.remove(checkpointPositions, 1)
		if checkpointPositions[1] then
			if GetConVarNumber("hl2c_use_old_umsg") >= 1 then
				umsg.Start("SetCheckpointPosition", RecipientFilter():AddAllPlayers())
				umsg.Vector(checkpointPositions[1])
				umsg.End()
			elseif GetConVarNumber("hl2c_use_old_umsg") == 0 then
				for _, pl in pairs(player.GetAll()) do
				net.Start("SetCheckpointPosition")
					usermessage.WriteVector(checkpointPositions[1])
				net.Send(pl)
			end
		end
		end
		
		self:Remove()
	end
end