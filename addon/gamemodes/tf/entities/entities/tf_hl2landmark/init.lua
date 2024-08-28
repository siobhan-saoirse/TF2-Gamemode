ENT.Type = "point"

local AmmoTypes = {
TF_PRIMARY,
TF_SECONDARY,
TF_METAL,
TF_GRENADES1,
TF_GRENADES2
}

function ENT:Initialize()
	self:Clear()
end

function ENT:IsValidMap()
	return self.Map==game.GetMap() and IsValid(self.LandmarkEntity)
end

function ENT:GetLandmarkEntity()
	if not self.Landmark then return end
	
	for _,v in pairs(ents.FindByName(self.Landmark)) do
		if v:GetClass()=="info_landmark" then
			self.LandmarkEntity = v
		end
	end
end

function ENT:Clear()
	self.Data = {}
	self.Map = nil
	self.Landmark = nil
	self.LandmarkEntity = nil
end

function ENT:Load()
	self:Clear()
	if not file.Exists("teamfortress/landmark.txt", "DATA") then return 1 end
	local ok, t = pcall(util.JSONToTable, file.Read("teamfortress/landmark.txt", "DATA"))
	
	if not ok then
		ErrorNoHalt(t)
		file.Delete("teamfortress/landmark.txt")
		return 2
	end
	
	self.Map = t.map
	self.Landmark = t.landmark
	self.Data = t.data
	
	self:GetLandmarkEntity()
	file.Delete("teamfortress/landmark.txt")
end

function ENT:Save()
	local t = {map=self.Map, landmark=self.Landmark, data=self.Data}
	file.Write("teamfortress/landmark.txt", util.TableToJSON(t))
	file.Write("teamfortress/landmark2.txt", util.TableToJSON(t))
	
	file.Append("teamfortress/log.txt", Format("Saving landmark data, map: %s\n", self.Map))
end

function ENT:LoadPlayerData(pl)
	local data = self.Data[pl:UniqueID()]
	if not data then
		Msg("Could not find data from player \""..pl:GetName().."\"\n")
		return
	end
	
	Msg("Loading data from player \""..pl:GetName().."\"\n")
	PrintTable(data)
	
	pl.CPPos = self.LandmarkEntity:GetPos() + data.pos
	pl.CPAng = data.ang
	
	pl:SetPos(pl.CPPos)
	pl:SetEyeAngles(pl.CPAng)
	
	pl:SetPlayerClass(data.class)
	pl:SetHealth(data.health)
	
	local activeweapon
	
	pl.ItemLoadout = {}
	pl.ItemProperties = {}
	
	for k,wdata in pairs(data.loadout) do
		pl.ItemLoadout[k] = tf_items.ItemsByID[wdata.id].name
		pl.ItemProperties[k] = wdata.properties
	end
	
	pl:SetPlayerClass(data.class)
	
	--pl.TempAttributes = data.tmpattrib
	
	pl:StripAmmo()
	for _,ammotype in ipairs(AmmoTypes) do
		pl:GiveAmmo(data.ammo[ammotype], ammotype)
	end
	
	for k,wdata in pairs(data.loadout) do
		local weap = pl:GetWeapon(tf_items.ItemsByID[wdata.id].item_class)
		if IsValid(weap) then
			if wdata.active then
				activeweapon = weap:GetClass()
			end
			
			weap:SetClip1(wdata.c1)
			weap:SetClip2(wdata.c2)
			
			if weap.LoadData and wdata.custom then
				weap:LoadData(wdata.custom)
			end
		end
	end
	
	if activeweapon then
		pl:SelectWeapon(activeweapon)
	end
end

function ENT:SavePlayerData(pl)
	local data = {}
	Msg("Saving data from player \""..pl:GetName().."\"\n")
	
	local id = pl:UniqueID()
	
	data.class = pl:GetPlayerClass()
	data.health = pl:Health()
	data.ammo = {}
	for _,ammotype in ipairs(AmmoTypes) do
		data.ammo[ammotype] = pl:GetAmmoCount(ammotype)
	end
	
	data.loadout = {}
	for k,item in pairs(pl.ItemLoadout) do
		item = tf_items.Items[item]
		
		if item then
			local wdata = {}
			wdata.id = item.id
			wdata.properties = pl.ItemProperties[k]
			
			local weap = pl:GetWeapon(item.item_class)
			if IsValid(weap) then
				if weap == pl:GetActiveWeapon() then
					wdata.active = true
				end
				
				wdata.c1 = weap:Clip1()
				wdata.c2 = weap:Clip2()
				if weap.SaveData then
					wdata.custom = {}
					weap:SaveData(wdata.custom)
				end
			end
			
			data.loadout[k] = wdata
		end
	end
	
	--data.tmpattrib = pl.TempAttributes
	
	data.pos = pl:GetPos() - self.LandmarkEntity:GetPos()
	data.ang = pl:EyeAngles()
	
	self.Data[id] = data
	PrintTable(data)
end

function ENT:SaveLevelData(caller)
	Msg("Changelevel triggered!\n")
	
	self:Clear()
	
	self.Map = caller.map
	self.Landmark = caller.landmark
	
	self:GetLandmarkEntity()
	
	if not self.LandmarkEntity then
		Msg("Error, no info_landmark found!\n")
		return
	end
	
	Msg("Changing level to "..self.Map.."\n")
	for _,v in pairs(player.GetAll()) do
		self:SavePlayerData(v)
	end
	
	self:Save()
end

function ENT:SetCheckpoint(pl)
	Msg("Checkpoint reached by player : "..pl:GetName().."\n")
	pl.CPPos = pl:GetPos()
	pl.CPAng = pl:EyeAngles()
end

function ENT:AcceptInput(name, activator, caller)
	if name=="Trigger" and caller:GetClass()=="trigger_changelevel" then
		self:SaveLevelData(caller)
	elseif name=="Checkpoint" and caller:GetClass()=="trigger_autosave" then
		self:SetCheckpoint(activator)
	end
end
