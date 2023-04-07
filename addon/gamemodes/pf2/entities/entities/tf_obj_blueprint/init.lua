
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

function ENT:Initialize()
	local owner = self:GetOwner()
	if not IsValid(owner) then
		self:Remove() return
	end
	
	self.Player = self:GetOwner().Owner
	if not IsValid(self.Player) then
		self:Remove() return
	end
	
	local obj = owner:GetBuilding() 
	if not obj then
		self:Remove() return
	end
	
	--[[
	local entdata = scripted_ents.Get(obj.class_name)
	if not entdata then
		self:Remove() return
	end]]
	
	local model = obj.blueprint_model
	if not model then
		self:Remove() return
	end
	
	self:SetModel(model)
	if owner:EntityTeam()==TEAM_BLU then
		self:SetSkin(1)
	else
		self:SetSkin(0)
	end
	if obj.class_name == "obj_dispenser" and self.Player.TempAttributes.BuildsMiniSentries then
		self:SetModel("models/buildables/mdispenser_blueprint.mdl")
	end
	if obj.class_name == "obj_dispenser" and self.Player:GetWeapons()[3]:GetClass() == "tf_weapon_engi_fist" then 
		self:SetModel("models/buildables/repair_level1.mdl")
	elseif obj.class_name == "obj_sentrygun" and self.Player:GetWeapons()[3]:GetClass() == "tf_weapon_engi_fist" then
		self:SetModel("models/combine_turrets/floor_turret.mdl")
	end
	self.CurrentYaw = 0
	self.TargetYaw = 0
	self.Rotation = 0
	
	self:Think()
	--self:SetParent(owner)
	owner:DeleteOnRemove(self)
	self:SetNotSolid(true)
	self:DrawShadow(false)
end

function ENT:Build()
	local pos, ang, valid = self:CalcPos(self.Player)
	ang.y = math.NormalizeAngle(ang.y + self.CurrentYaw)
	
	self:SetPos(pos)
	self:SetAngles(ang)
	
	if not valid then return end
	
	local obj = self:GetOwner():GetBuilding()
	if not obj then return end
	
	local ent = ents.Create(obj.class_name)   
	if not IsValid(ent) then return end
	
	ent.Player = self.Player
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent:SetTeam(self.Player:EntityTeam())
	ent:SetBuilder(self.Player)
	ent:Spawn()
	ent:SetAngles(ang)
	if self.Player:GetWeapon("tf_weapon_builder").MovedBuildingLevel == 2 and obj.class_name == "obj_sentrygun" and self.Player:GetWeapon("tf_weapon_builder").Moving != false then 

		timer.Create("SEtModel", 0.1, 15, function()
			if ent:GetLevel() <= 2 then
				ent:AddMetal2(ent, 200)
			end
		end)
	elseif self.Player:GetWeapon("tf_weapon_builder").MovedBuildingLevel == 2 and obj.class_name == "obj_sentrygun" and self.Player:GetWeapon("tf_weapon_builder").Moving != false then 

		timer.Create("SEtModel", 0.1, 15, function()
			if ent:GetLevel() <= 2 then
				ent:AddMetal2(ent, 200)
			end
		end)
	elseif self.Player:GetWeapon("tf_weapon_builder").MovedBuildingLevel == 2 and obj.class_name == "obj_dispenser" and self.Player:GetWeapon("tf_weapon_builder").Moving != false then 

		timer.Create("SEtModel", 0.1, 20, function()
			if ent:GetLevel() <= 2 then
				ent:AddMetal2(ent, 200)
			end
		end)
	elseif self.Player:GetWeapon("tf_weapon_builder").MovedBuildingLevel == 3 and obj.class_name == "obj_dispenser" and self.Player:GetWeapon("tf_weapon_builder").Moving != false then 

		timer.Create("SEtModel", 0.1, 20, function()
			if ent:GetLevel() <= 3 then
				ent:AddMetal2(ent, 200)
			end
		end)
	elseif self.Player:GetWeapon("tf_weapon_builder").MovedBuildingLevel == 3 and obj.class_name == "obj_sentrygun" and self.Player:GetWeapon("tf_weapon_builder").Moving != false then 

		timer.Create("SEtModel", 0.1, 20, function()
			if ent:GetLevel() <= 3 then
				ent:AddMetal2(ent, 200)
			end
		end)
	elseif obj.class_name == "obj_sentrygun" and self.Player:GetWeapons()[3]:GetClass() == "tf_weapon_engi_fist" then 

		timer.Create("SEtModel", 0.1, 80, function()
		ent:SetModel("models/combine_turrets/floor_turret.mdl")
		ent.Model:SetModel("models/combine_turrets/floor_turret.mdl")
		ent.FireRate = 0.08
		ent.Shoot_Sound = "NPC_CeilingTurret.Shoot"
		ent.Idle_Sound = CreateSound(ent, "NPC_Turret.Ping")
		ent.Sound_Alert = Sound("NPC_CeilingTurret.Active")
		ent.NameOverride = "npc_turret_floor"
		ent.AimSpeedMultiplier = 0.7
		
		local health_frac = ent:Health() / ent:GetMaxHealth()
		ent:SetMaxHealth(ent:GetObjectHealth())
		ent:SetHealth(ent:GetObjectHealth() * health_frac)
		
		ent.MaxAmmo1 = 144
		ent.MaxAmmo2 = 20
		ent:SetAmmo1(ent.MaxAmmo1)
		ent:SetAmmo2(ent.MaxAmmo2)
		ent:SetLevel(1)
		end)
	end
	if obj.class_name == "obj_sentrygun" and self.Player.TempAttributes.BuildsMiniSentries then
		ent:SetBuildingType(1)
	elseif obj.class_name == "obj_dispenser" and self.Player.TempAttributes.BuildsMiniSentries then
		ent:SetBuildingType(1)
	elseif obj.class_name == "obj_dispenser" and self.Player:GetWeapons()[3]:GetClass() == "tf_weapon_engi_fist" then
		ent:SetBuildingType(2)
	elseif obj.class_name == "obj_sentrygun" and self.Player:GetWeapons()[3]:GetClass() == "tf_weapon_engi_fist" then
		ent:SetBuildingType(3) 
	elseif obj.class_name == "obj_sentrygun" and self.Player.TempAttributes.BuildsMegaSentries then
		ent:SetBuildingType(2)
	elseif obj.class_name == "obj_teleporter" and self.Player:GetInfoNum("tf_robot", 0) == 1 and self.Player:Team() == TEAM_BLU then
		ent.Spawnpoint = true
	end
	ent:SetBuildGroup(self:GetOwner():GetBuildGroup())
	ent:SetBuildMode(self:GetOwner():GetBuildMode())
	
	ent.objtype = obj.objtype
	
	return true
end

function ENT:Think()
	-- Updating target angle
	if self.Rotation ~= self.dt.Rotation then
		self.Rotation = self.dt.Rotation
		self.TargetYaw = math.NormalizeAngle(90 * self.Rotation)
	end
	
	-- Rotating the blueprint
	if self.LastThink then
		local dt = CurTime() - self.LastThink
		
		if self.CurrentYaw ~= self.TargetYaw then
			local old = self.CurrentYaw
			self.CurrentYaw = self.CurrentYaw + self.RotationSpeed * dt
			if old < self.TargetYaw and self.CurrentYaw >= self.TargetYaw then
				self.CurrentYaw = self.TargetYaw
			end
			self.CurrentYaw = math.NormalizeAngle(self.CurrentYaw)
		end
	end
	self.LastThink = CurTime()
	
	-- Calculating the position
	local pos, ang, valid = self:CalcPos(self.Player)
	self:SetPos(pos)
	
	ang.y = math.NormalizeAngle(ang.y + self.CurrentYaw)
	self:SetAngles(ang)
	
	if valid ~= self.dt.Allowed then
		self.dt.Allowed = valid
	end
	
	self:NextThink(CurTime())
	return true
end
