ENT.Type = "point"

local team_control_point = "team_control_point"

function ENT:Initialize()
end

function ENT:InitPostEntity()
	print(self)
	PrintTable(self.Properties or {})
	
	self:SendData()
end

function ENT:SendData(pl)
	local layout = self.Properties.caplayout
	
	if not layout then
		layout = ""
		local tab = ents.FindByClass(team_control_point)
		table.sort(tab, function(a,b) if not a then return end if not b then return end if not a.ID then return end if not b.ID then return end return a.ID<b.ID end)
		for _,v in ipairs(tab) do
			layout = layout..(v.ID-1).." "
		end
		print("Generating layout string : "..layout)
	end
	
	umsg.Start("TF_SetControlPointLayout", pl)
		umsg.String(layout)
	umsg.End()
end

function ENT:UpdateControlPoints()
	local pts = ents.FindByClass(team_control_point)
	for _,v in pairs(pts) do
		if not v.Ready then return end
	end
	
	for _,v in pairs(pts) do
		v:UpdateLockStatus()
	end
	
	self.ControlPointsReady = true
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
	
	if not self.ControlPointsReady then
		self:UpdateControlPoints()
	end
end

function ENT:AcceptInput(name, activator, caller, data)
	
end
