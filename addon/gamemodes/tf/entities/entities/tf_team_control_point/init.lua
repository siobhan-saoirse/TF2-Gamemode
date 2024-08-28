include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()
	self.ID = self.Properties.point_index
	self.OwnerTeam = self.Properties.point_default_owner
	self.Locked = false
	
	self:UpdateModel()
end

function ENT:UpdateModel()
	self:SetModel(self.Properties["team_model_"..self.OwnerTeam])
	self:SetBodygroup(0, self.OwnerTeam)
	self:ResetSequence(self:SelectWeightedSequence(ACT_IDLE))
	self:DrawShadow(false)
end

function ENT:InitPostEntity()
	if not IsValid(self.TriggerEntity) then
		return
	end
	
	print(self)
	
	self.Properties.team_previouspoint_2_0 = ents.FindByName(self.Properties.team_previouspoint_2_0 or "")[1] or NULL
	self.Properties.team_previouspoint_2_1 = ents.FindByName(self.Properties.team_previouspoint_2_1 or "")[1] or NULL
	self.Properties.team_previouspoint_2_2 = ents.FindByName(self.Properties.team_previouspoint_2_2 or "")[1] or NULL
	self.Properties.team_previouspoint_3_0 = ents.FindByName(self.Properties.team_previouspoint_3_0 or "")[1] or NULL
	self.Properties.team_previouspoint_3_1 = ents.FindByName(self.Properties.team_previouspoint_3_1 or "")[1] or NULL
	self.Properties.team_previouspoint_3_2 = ents.FindByName(self.Properties.team_previouspoint_3_2 or "")[1] or NULL
	
	PrintTable(self.Properties or {})
	
	self:SendData()
	self.Ready = true
end

function ENT:SendData(pl)
	umsg.Start("TF_AddControlPoint", pl)
		umsg.Char(self.Properties.point_index)
		umsg.String(self.Properties.point_printname)
		
		umsg.String(self.Properties.team_icon_0 or "")
		umsg.String(self.Properties.team_icon_2 or "")
		umsg.String(self.Properties.team_icon_3 or "")
		
		umsg.String(self.Properties.team_overlay_0 or "")
		umsg.String(self.Properties.team_overlay_2 or "")
		umsg.String(self.Properties.team_overlay_3 or "")
		
		umsg.Char(self.Properties.point_default_owner)
	umsg.End()
end

function ENT:SetOwnerTeam(o)
	self.OwnerTeam = o
	umsg.Start("TF_SetControlPointTeam")
		umsg.Char(self.ID)
		umsg.Char(self.OwnerTeam)
	umsg.End()
	self:UpdateModel()
end

function ENT:Open()
	self.Locked = false
	umsg.Start("TF_OpenControlPoint")
		umsg.Char(self.ID)
	umsg.End()
end

function ENT:Lock()
	self.Locked = true
	umsg.Start("TF_LockControlPoint")
		umsg.Char(self.ID)
	umsg.End()
end

function ENT:SetLocked(b)
	if b then
		self:Lock()
	else
		self:Open()
	end
end

-- Should this control point be locked or not?
function ENT:ComputeLockStatus()
	if self.TeamCanCap then
		-- If this point cannot be captured by any team other than its owner, it's definitely locked
		local lock = true
		for t=2,3 do
			if t~=self.OwnerTeam and self.TeamCanCap[t] then
				lock = false
				break
			end
		end
		if lock then
			return true
		end
	end
	
	local pt
	local lock = true
	for t=2,3 do
		if self.OwnerTeam ~= t then
			local cancap = true
			
			if self.TeamCanCap and not self.TeamCanCap[t] then
				cancap = false
			else
				for i=0,2 do
					pt = self.Properties["team_previouspoint_"..t.."_"..i]
					if not IsValid(pt) then
						if i==0 then
							local cannotcap = false
							for _,pt in pairs(ents.FindByClass("team_control_point")) do
								if ((t==2 and pt.ID>self.ID) or (t==3 and pt.ID<self.ID)) and pt~=self then
									if pt.OwnerTeam~=t then
										cannotcap = true
										break
									end
								end
							end
							if cannotcap then
								cancap = false
								break
							end
						end
					else
						if pt~=self then
							if pt.OwnerTeam~=t then
								cancap = false
								break
							end
						end
					end
				end
			end
			
			if cancap then
				lock = false
				break
			end
		end
	end
	return lock
end

function ENT:UpdateLockStatus()
	local l = self:ComputeLockStatus()
	print("Control point "..self.ID.." lock status : "..tostring(l))
	self:SetLocked(l)
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
	if GAMEMODE.PostEntityDone and not self.Ready then
		self:InitPostEntity()
		return
	end
	
	
end

function ENT:AcceptInput(name, activator, caller, data)
	
end
