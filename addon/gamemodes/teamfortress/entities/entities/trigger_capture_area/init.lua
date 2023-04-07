ENT.Base = "base_brush"
ENT.Type = "brush"


function ENT:Initialize()
end

function ENT:InitPostEntity()
	print(self)
	self.CapturePoint = ents.FindByName(self.Properties.area_cap_point or "")[1] or NULL
	
	if IsValid(self.CapturePoint) then
		self.CapturePoint.TriggerEntity = self
		self.CapturePoint.TeamCanCap = {
			[2]=(self.Properties.team_cancap_2==1),
			[3]=(self.Properties.team_cancap_3==1),
		}
	end
	
	PrintTable(self.Properties or {})
end

function ENT:KeyValue(key,value)
	key = string.lower(key)
	
	if not self.Properties then
		self.Properties = {}
	end
	if tonumber(value) then value=tonumber(value) end
	self.Properties[key] = value
end

function ENT:Think()
	if not GAMEMODE.PostEntityDone then return end
	if GAMEMODE.PostEntityDone and not self.PostEntityDone then
		self:InitPostEntity()
		self.PostEntityDone = true
		return
	end
end

function ENT:AcceptInput(name, activator, caller, data)
	
end

function ENT:StartTouch(ent)
	if IsValid(self.CapturePoint) and ent:IsPlayer() then
		if ent.CurrentControlPoint ~= self.CapturePoint.ID then
			ent.CurrentControlPoint = self.CapturePoint.ID
			umsg.Start("TF_EnterControlPoint", ent)
				umsg.Char(ent.CurrentControlPoint)
			umsg.End()
			if GAMEMODE:EntityTeam(self.CapturePoint) != ent:Team() then
				umsg.Start("TF_PlayGlobalSound", ent)
					umsg.String("Announcer.ControlPointContested")
				umsg.End()
				self.CapturePoint:EmitSound("ControlPoint.Start", 80, 100)
				self.CapturePoint:EmitSound("ControlPoint.Move", 80, 100)
				timer.Create("CapPoint"..ent.CurrentControlPoint, 10, 1, function()
					umsg.Start("TF_SetControlPointTeam", ent)
						umsg.Char(ent.CurrentControlPoint) 
						umsg.Float(tonumber(ent:Team()) + 1) 
					umsg.End()
					umsg.Start("TF_UnLockControlPoint", ent)
							umsg.Char(ent.CurrentControlPoint) 
					umsg.End()
					for k,v in ipairs(ents.FindByClass("team_control_point")) do
						if GAMEMODE:EntityTeam(v) != GAMEMODE:EntityTeam(self.ControlPoint) then
							umsg.Start("TF_UnLockControlPoint", ent)
								umsg.Char(v.ID) 
							umsg.End() 
						end
					end
					if ent:Team() == TEAM_RED then
						self.CapturePoint:SetBodygroup(0, ent:Team() + 1)
					elseif ent:Team() == TEAM_BLU then	
						self.CapturePoint:SetBodygroup(0, ent:Team() + 1) 
					end
					self.CapturePoint:SetNWInt("Team", ent:Team())
					self.CapturePoint:ResetSequence(self.CapturePoint:SelectWeightedSequence(ACT_IDLE))
					self.CapturePoint:DrawShadow(false)
					self.CapturePoint:StopSound("ControlPoint.Move")
					self.CapturePoint:EmitSound("ControlPoint.Stop")
				end)
			end  
			if GAMEMODE:EntityTeam(self.CapturePoint) == ent:Team() then
				timer.Stop("CapPoint"..ent.CurrentControlPoint)
				self.CapturePoint:StopSound("ControlPoint.Move")
				self.CapturePoint:EmitSound("ControlPoint.Malfunction")
				timer.Create("CapPoint"..ent.CurrentControlPoint, 20, 1, function()
					self.CapturePoint:StopSound("ControlPoint.Malfunction")
					self.CapturePoint:EmitSound("ControlPoint.Stop")
				end)
				
			end
		end
	end
end

function ENT:EndTouch(ent)
	if IsValid(self.CapturePoint) and ent:IsPlayer() then
		if ent.CurrentControlPoint == self.CapturePoint.ID then
			timer.Stop("CapPoint"..ent.CurrentControlPoint)
			ent.CurrentControlPoint = -1
			umsg.Start("TF_ExitControlPoint", ent)
			umsg.End()
			
			if GAMEMODE:EntityTeam(self.CapturePoint) != ent:Team() then		
				
				timer.Create("CapPoint"..self.CapturePoint, 20, 1, function()
					self.CapturePoint:StopSound("ControlPoint.Move")
					self.CapturePoint:StopSound("ControlPoint.Malfunction")
					self.CapturePoint:EmitSound("ControlPoint.Stop")
				end)
				
			end
		end
	end
end
