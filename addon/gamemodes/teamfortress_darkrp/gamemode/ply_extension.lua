
-- General player extensions

local meta = FindMetaTable( "Player" )
if (!meta) then return end 
local builds = {}
builds[2] = "obj_sentrygun"
builds[0] = "obj_dispenser"
builds[1] = "obj_teleporter"
local Player = FindMetaTable("Player")
local oNick = Player.Nick
local oPlayer = Player.IsPlayer
 
function Player:DoTauntEvent(data)	
	self:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, self:LookupSequence(data), 0, true)
end  
function Player:IsPlayer()
	return oPlayer(self)
end
function Player:Nick()
	return oNick(self)
end
Player.Name = Player.Nick
Player.GetName = Player.Nick

function RegisterStatType(obj, name)
	local name_get = name
	local name_set = "Set"..name
	local name_add = "Add"..name
	local name_umsg = "__playerSet"..name
	
	obj[name_get] = function(self)
		if not self.Stats then self.Stats = {} end
		return self.Stats[name] or 0
	end
	
	if SERVER then
		obj[name_set] = function(self, val)
			if not self.Stats then self.Stats = {} end
			self.Stats[name] = val
			umsg.Start(name_umsg)
				umsg.Entity(self)
				umsg.Long(val)
			umsg.End()
		end
		
		obj[name_add] = function(self, val)
			self[name_set](self, self[name_get](self) + val)
		end
	else
		usermessage.Hook(name_umsg, function(msg)
			local self = msg:ReadEntity()
			if not IsValid(self) or not self:IsPlayer() then return end
			if not self.Stats then self.Stats = {} end
			self.Stats[name] = msg:ReadLong()
		end)
	end
end

RegisterStatType(meta, "Kills")
RegisterStatType(meta, "Assists")
RegisterStatType(meta, "Destructions")

RegisterStatType(meta, "Captures")
RegisterStatType(meta, "Defenses")
RegisterStatType(meta, "Dominations")
RegisterStatType(meta, "Revenges")

RegisterStatType(meta, "Healing")
RegisterStatType(meta, "Invulns")
RegisterStatType(meta, "Teleports")
RegisterStatType(meta, "Headshots")

RegisterStatType(meta, "Backstabs")
RegisterStatType(meta, "Bonus")

-- Serverside

if SERVER then

if not meta.SetFrags0 then
	meta.SetFrags0 = meta.SetFrags
end
function meta:SetFrags(n)
	if not self.Stats then self.Stats = {} end
	self.Stats.Points = n
	self:SetFrags0(math.floor(self.Stats.Points))
end

function meta:AddFrags(n)
	if not self.Stats then self.Stats = {} end
	self.Stats.Points = (self.Stats.Points or self:Frags()) + n
	self:SetFrags0(math.floor(self.Stats.Points))
end

function meta:Explode(dmginfo)
	if (self:IsL4D()) then return end
		self.ShouldGib = true
		umsg.Start("GibPlayer")
			umsg.Long(self:UserID())
			umsg.Short(self.DeathFlags)	
		umsg.End()
	--self:EmitSound(")player/gib"..math.random(1,3)..".wav", 95)
	--self:EmitSound(")player/gibexplosion"..math.random(1,3)..".wav", 115) 
end

function meta:Decap()
	self.ShouldGib = true
	if self:IsHL2() then
		umsg.Start("GibNPCHead")
			umsg.Long(self:UserID())
			umsg.Short(self.DeathFlags)
		umsg.End()
	else
		umsg.Start("GibPlayerHead")
			umsg.Long(self:UserID())
			umsg.Short(self.DeathFlags)
		umsg.End()
	end
end


function meta:SetBuilding(group, mode)
	local builder = self:GetWeapon("tf_weapon_builder")
	if self.Buildings[group] and self.Buildings[group][mode] then
		local cost = self.Buildings[group][mode].cost
		if self:GetAmmoCount(TF_METAL) < cost then
			return false
		end
		
		builder.dt.BuildGroup = group
		builder.dt.BuildMode = mode
		return true
	end
end

function meta:SetBuilding2(group, mode)
	if self.Buildings[group] and self.Buildings[group][mode] then
		self.dt.BuildGroup = group
		self.dt.BuildMode = mode
		return true
	end
end

local old_group_translate = {
	[0] = {0,0},
	[1] = {1,0},
	[2] = {1,1},
	[3] = {2,0},
	[4] = {3,0},
}

function meta:Build(number1,number2)
	local args
	local group = tonumber(number1)
	local sub = tonumber(number2)
	
	local builder = self:GetWeapon("tf_weapon_builder")
	
	if builds[group] and (!GetConVar("tf_unlimited_buildings"):GetBool()) then
		local tab = ents.FindByClass(builds[group])
		for k, v in pairs(tab) do
			if v.Player == self and builds[group] ~= "obj_teleporter" then
				return
			elseif v.Player == self and builds[group] == "obj_teleporter" then
				for i, o in pairs(tab) do
					if (sub == 0 and v:IsEntrance() and o:IsEntrance()) or (sub == 1 and v:IsExit() and o:IsExit()) then
						return
					end
				end
			end
		end
	end
	builder:SetHoldType("BUILDING")
	
	builder.Moving = false
	
	timer.Simple(25, function()
		if ( builder:IsValid() and builder.Moving != false and self:KeyPressed( IN_FORWARD ) ) then 
			self:EmitSound("vo/engineer_sentrymoving0"..math.random(1,2)..".wav", 80, 100)
		else
			return
		end
	end)	
	
	if not IsValid(builder) then return end
	if not group then return end
	
	if not sub then
		if not old_group_translate[group] then return end
		
		group, sub = unpack(old_group_translate[group])
	end
	local Buildings = {}
	local Buildings2 = {}
	local Buildings3 = {}
	local Buildings4 = {}
	table.remove(Buildings, 1) 
	table.remove(Buildings2, 1) 
	local current = self:GetActiveWeapon()
	for k,v in ipairs(ents.FindByClass("obj_sentrygun")) do
		if IsValid(v) and v:GetOwner() == self then
			table.insert(Buildings, v:EntIndex()) 
			PrintTable(Buildings)
		elseif !IsValid(v) then
			table.remove(Buildings, 1) 
		end
	end
	for k,v in ipairs(ents.FindByClass("obj_dispenser")) do
		if IsValid(v) and v:GetOwner() == self then
			table.insert(Buildings2, v:EntIndex())
		elseif !IsValid(v) then
			table.remove(Buildings2, 1) 
		end
	end
	for k,v in ipairs(ents.FindByClass("obj_teleporter")) do 
		if IsValid(v) and v:GetOwner() == self then
			table.insert(Buildings3, v:EntIndex())
		elseif !IsValid(v) then
			table.remove(Buildings3, 1) 
			table.remove(Buildings3, 2)
		end
	end
	if self:SetBuilding(group, sub) and current ~= builder then
		if current.IsPDA then
			local last = self:GetWeapon(self.LastWeapon)
			if not IsValid(last) or last.IsPDA then
			last = self:GetWeapons()[1]
		end
		builder.LastWeapon = last:GetClass()
		self:SelectWeapon(last:GetClass())
	else
		builder.LastWeapon = current:GetClass()
	end
	self:SelectWeapon("tf_weapon_builder")
end
 
end
function meta:Move(number1,number2)
	local group = tonumber(number1)
	local sub = tonumber(number2) 
	if self:GetInfoNum("tf_robot", 0) == 1 then
		self:EmitSound("vo/mvm/norm/engineer_mvm_sentrypacking0"..math.random(1,3)..".wav", 80, 100)
	else
		self:EmitSound("vo/engineer_sentrypacking0"..math.random(1,3)..".wav", 80, 100)		
	end
	local builder = self:GetWeapon("tf_weapon_builder")
	
	if not IsValid(builder) then return end
	if not group then return end
	
	builder:SetHoldType("BUILDING_DEPLOYED")
	builder.HoldType = "BUILDING_DEPLOYED"
	
	if not sub then
		if not old_group_translate[group] then return end
		
		group, sub = unpack(old_group_translate[group])
	end
	
	local current = self:GetActiveWeapon()
	if builder:SetBuilding2(group, sub) and current ~= builder then
		if current.IsPDA then
			local last = self:GetWeapon(self.LastWeapon)
			if not IsValid(last) or last.IsPDA then
				last = self:GetWeapons()[1]
			end
			builder.LastWeapon = last:GetClass()
			self:SelectWeapon(last:GetClass())
		else
			builder.LastWeapon = current:GetClass()
		end
		self:SelectWeapon("tf_weapon_builder")
		builder.Moving = true
	end
end

function meta:RandomSentence(group)
	
	local class = self.playerclass
	if not class then return end
	
	--[[local tbl = class.Sounds[group]
	self:EmitSound(tbl[math.random(1,#tbl)])]]

	self:EmitSound(Format("%s.%s", class, group))
end

function meta:StripTFItems()
	self:StripWeapons()
	self:StripAmmo()
	
	if self.PlayerItemList then
		for _,v in ipairs(self.PlayerItemList) do
			v:Remove()
		end
	end
end

function meta:StripHats()
	for _,v in pairs(ents.FindByClass("tf_hat")) do
		if v:GetOwner() == self then
			v:Remove()
		end
	end
	
	for i=1,10 do
		self:SetBodygroup(i,0)
	end
end

function meta:GiveTFAmmo(c, am, is_fraction)
	if c==0 then return end
	
	if not self.AmmoMax then
		if c>0 then
			return self:GiveAmmo(c, am)
		else
			return self:RemoveAmmo(-c, am)
		end
	end
	
	local a = self:GetAmmoCount(am)
	
	if is_fraction then
		if c ~= nil and not self:IsHL2() then
			c = math.ceil(c * self.AmmoMax[am])
		else
			c = 0
		end
	end
	
	if c>0 then
		c = math.min(self.AmmoMax[am] - a, c)
		if c>0 then
			self:GiveAmmo(c, am)
			if am == TF_METAL then
				umsg.Start("PlayerMetalBonus", self)
					umsg.Short(c)
				umsg.End()
			end
			return true
		end
	else
		self:RemoveAmmo(-c, am)
		if am == TF_METAL then
			umsg.Start("PlayerMetalBonus", self)
				umsg.Short(-c)
			umsg.End()
		end
	end
	
	return false
end

function meta:SetAmmoCount(c, am)
	local a = self:GetAmmoCount(am)
	
	if c > a then
		self:GiveAmmo(c - a, am)
	elseif c < a then
		self:RemoveAmmo(a - c, am)
	end
end

function meta:HasFullAmmo()
	for k,v in pairs(self.AmmoMax or {}) do
		if self:GetAmmoCount(k) < v then
			return false
		end
	end
	return true
end

function meta:ResetAttributes()
	local c = self:GetPlayerClassTable()
	
	self.TempAttributes = {}
	self:ResetClassSpeed(c.Speed or 100)
	self:ResetMaxHealth()
	self.AmmoMax = table.Copy(c.AmmoMax or {})
end

end

-- Shared

--[[function meta:GetCrouchedWalkSpeed()
	return self:GetNWFloat("CrouchedWalkSpeed")
end

function meta:GetWalkSpeed()
	return 1
end

function meta:GetRunSpeed()
	return 1
end

function meta:GetDuckSpeed()
	return self:GetNWFloat("TimeToDuck")
end

function meta:GetUnDuckSpeed()
	return self:GetNWFloat("TimeToUnDuck")
end]]

function meta:IsHL2()
	return self:GetNWBool("IsHL2")
end
function meta:IsL4D()
	return self:GetNWBool("IsL4D")
end

function meta:ShouldUseDefaultHull()
	if self ~= nil then
		if GetConVar("tf_use_hl_hull_size") then
			return self:GetNWBool("IsHL2") or self:GetNWBool("IsL4D") or GetConVar("tf_use_hl_hull_size"):GetInt() == 1
		end
	end
end

function meta:GetTFItems()
	local t = self:GetWeapons()
	if self.PlayerItemList then
		table.Add(t, self.PlayerItemList)
	end
	return t
end

function meta:HasTFItem(name)
	if not name then return false end
	
	for _,v in ipairs(self:GetTFItems()) do
		if v.IsTFItem and v:GetItemData().name == name then
			return true
		end
	end
	
	return false
end

--[[
if CLIENT then

usermessage.Hook("SendWeaponAnim", function(msg)
	local act = msg:ReadShort()
	local seq = GAMEMODE.Viewmodels[1][2]:SelectWeightedSequence(act)
	if seq>=0 then
		GAMEMODE.Viewmodels[1][2]:ResetSequence(seq)
		GAMEMODE.Viewmodels[1][2]:SetCycle(0)
	end
end)

end

meta.SendWeaponAnim0 = meta.SendWeaponAnim

function meta:SendWeaponAnim(act)
	self:SendWeaponAnim0(act)
	
	if SERVER then
		umsg.Start("SendWeaponAnim", self)
			umsg.Short(act)
		umsg.End()
	else
		local seq = GAMEMODE.Viewmodels[1][2]:SelectWeightedSequence(act)
		if seq>=0 then
			GAMEMODE.Viewmodels[1][2]:ResetSequence(seq)
			GAMEMODE.Viewmodels[1][2]:ResetSequenceInfo()
		end
	end
end
]]
