ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()
	self.Team = 0
	self.Players = {}
	self.Opened = false
	
	timer.Stop("Warning!")
end

function ENT:KeyValue(key,value)
	key = string.lower(key)
	
	if key=="teamnum" then
		self.Team = tonumber(value)
	elseif key=="associatedmodel" then
		self.ResupplyLockerName = value
	end
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() then
		self.Players[ent] = -1
		for k,v in pairs(ents.FindByClass("item_teamflag")) do
			if v.Carrier == ent then
				if game.GetMap() == "sd_doomsday" then
					for _,relay in pairs(ents.FindByName("touch_relay")) do
						relay:Fire( "Trigger" )
					end
				end
			end
		end
		for k,v in pairs(ents.FindByClass("item_teamflag_mvm")) do
			if v.Carrier == ent then
				if string.find(game.GetMap(), "mvm_") then
					for _,ply in ipairs(player.GetAll()) do
						ply:SendLua([[surface.PlaySound("vo/mvm_bomb_alerts0"..math.random(4,5)..".mp3")]])
						if (ply.TFBot and !ply:IsFriendly(ent)) then
							ply.TargetEnt = ent
						end
						timer.Create("Warning!", 3, 0, function()
							ply:SendLua([[surface.PlaySound("mvm/mvm_bomb_warning.wav")]]) 
						end)
					end
				end
			end
		end
	end
end 

function ENT:EndTouch(ent)
	if ent:IsPlayer() then
		self.Players[ent] = nil
		for k,v in pairs(ents.FindByClass("item_teamflag")) do
			if v.Carrier == ent then
				if game.GetMap() == "sd_doomsday" then
					for _,relay in pairs(ents.FindByName("drop_relay")) do
						relay:Fire( "Trigger" )
					end
				end
			end
		end
		for k,v in pairs(ents.FindByClass("item_teamflag_mvm")) do
			if string.find(game.GetMap(), "mvm_") then
				timer.Stop("Warning!")
			end
		end
	end
end