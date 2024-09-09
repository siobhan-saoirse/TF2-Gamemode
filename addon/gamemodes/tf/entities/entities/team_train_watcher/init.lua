ENT.Type = "point"

local team_control_point = "team_train_watcher"

function ENT:Initialize()
	self.Train = self.Train or ""
end

function ENT:KeyValue(key,value)
	key = string.lower(key)
	
	if key=="train" then
		for k,v in ipairs(ents.FindByName(value)) do
			self.Train = v
		end
	end
	print(key, value, tonumber(value)) 
end
   