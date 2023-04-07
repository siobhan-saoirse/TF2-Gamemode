
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

local tf_minidispenser_allow_upgrade = CreateConVar("tf_minidispenser_allow_upgrade", "0", {FCVAR_CHEAT})

ENT.NPCCallRange = 512
ENT.NPCCallHealthFraction = 0.75
ENT.NPCCallProbability = 0.5

ENT.NumLevels = 3
ENT.Levels = {
{Model("models/buildables/dispenser.mdl"), Model("models/buildables/dispenser_light.mdl")},
{Model("models/buildables/dispenser_lvl2.mdl"), Model("models/buildables/dispenser_lvl2_light.mdl")},
{Model("models/buildables/dispenser_lvl3.mdl"), Model("models/buildables/dispenser_lvl3_light.mdl")},
}
ENT.IdleSequence = "ref"
ENT.DisableDuringUpgrade = false
ENT.NoUpgradedModel = false

ENT.Sound_Idle = Sound("Building_Dispenser.Idle")
ENT.Sound_Explode = Sound("Building_Dispenser.Explode")
ENT.Sound_Generate = Sound("Building_Dispenser.GenerateMetal")
ENT.Sound_Heal = Sound("Building_Dispenser.Heal")

ENT.Sound_DoneBuilding = Sound("Building_Sentrygun.Built")

ENT.Gibs = {
Model("models/buildables/Gibs/dispenser_gib1.mdl"),
Model("models/buildables/Gibs/dispenser_gib2.mdl"),
Model("models/buildables/Gibs/dispenser_gib3.mdl"),
Model("models/buildables/Gibs/dispenser_gib4.mdl"),
Model("models/buildables/Gibs/dispenser_gib5.mdl"),
}
ENT.Sound_Explode = Sound("Building_Dispenser.Explode")

ENT.Sapped = false

ENT.Range = 100

function ENT:StartSupply(pl)
	self.NumClients = self.NumClients + 1
	if not self.NextHealSound or CurTime()>self.NextHealSound then
		self.Heal_Sound:Stop()
		self.Heal_Sound:Play()
		self.NextHealSound = CurTime() + 0.4
	end
	
	local target = ents.Create("info_dummy")
	target:SetPos(pl:GetPos() + Vector(0,0,45))
	target:Spawn()
	target:SetParent(pl)
	target:AttachToEntity(pl)
	target:SetName(tostring(target))
	local e = ParticleSuffix(self:EntityTeam())
	local effect = ents.Create("info_particle_system")
	if self:GetBuildingType() == 2 then
		self:SetModel("models/buildables/dispenser_light.mdl")
		effect:SetKeyValue("effect_name", "medicgun_beam_"..e)
	else
		effect:SetKeyValue("effect_name", "dispenser_heal_"..e)
	end
	effect:SetKeyValue("cpoint1", target:GetName())
	effect:SetKeyValue("start_active", "1" )
	
	effect:SetParent(self)
	effect:Spawn()
	effect:Activate()
	
	effect:Fire("SetParentAttachment", "heal_origin")
	
	self.Clients[pl] = {effect, target}
	pl.BeingHealedByDispenser = true
end

function ENT:StopSupply(pl)
	self.NumClients = self.NumClients - 1
	if self.NumClients==0 then
		self.Heal_Sound:Stop()
	end
	
	local t = self.Clients[pl]
	if not t then return end
	
	if IsValid(t[1]) then t[1]:Remove() end
	if IsValid(t[2]) then t[2]:Remove() end
	
	self.Clients[pl] = nil
	pl.BeingHealedByDispenser = false
	pl.DoneWaitForHealingSchedule = false
end

function ENT:OnStartBuilding()
	self.Idle_Sound = CreateSound(self, self.Sound_Idle)
	self.Heal_Sound = CreateSound(self, self.Sound_Heal)
	if self:GetBuildingType() == 1 then
		self.BuildRate = 1.5
		self.NextAmmoSupply = CurTime() + 0.5
		self:SetModel("models/buildables/mdispenser.mdl")
		self.Model:SetModel("models/buildables/mdispenser.mdl")
		self.Levels = {
			{Model("models/buildables/mdispenser.mdl"), Model("models/buildables/mdispenser_light.mdl")},
			{Model("models/buildables/mdispenser.mdl"), Model("models/buildables/mdispenser_light.mdl")},
			{Model("models/buildables/mdispenser.mdl"), Model("models/buildables/mdispenser_light.mdl")}
		}
		self.Gibs = {
			Model("models/buildables/gibs/mdispenser_gib1.mdl"),
			Model("models/buildables/gibs/mdispenser_gib2.mdl"),
			Model("models/buildables/Gibs/mdispenser_gib3.mdl"),
			Model("models/buildables/Gibs/mdispenser_gib4.mdl"),
			Model("models/buildables/Gibs/mdispenser_gib5.mdl"),
		}
	end
	if self:GetBuildingType() == 2 then
		self.Model:SetModel("models/buildables/repair_level1.mdl")	
		self:SetModel("models/buildables/dispenser_light.mdl")
		self.Levels = {
			{Model("models/buildables/dispenser_light.mdl"), Model("models/buildables/repair_level1.mdl")},
			{Model("models/buildables/dispenser_light.mdl"), Model("models/buildables/repair_level2.mdl")},
			{Model("models/buildables/dispenser_light.mdl"), Model("models/buildables/repair_level3.mdl")}
		}
	end
end

function ENT:OnDoneBuilding()
	self:EmitSound(self.Sound_DoneBuilding, 100, 100)
	self.Idle_Sound:Play()
	
	self.MetalPerGeneration = 40
	self.HealRate = 0.1
	self.AmmoPerSupply = 40

	self.Clients = {}
	self.NumClients = 0
	
	self:SetNoDraw(false)
	
	self:SetMetalAmount(25)
	self.NextGenerate = CurTime() + 5
	if self:GetBuildingType() == 1 then
		self.NextAmmoSupply = CurTime() + 0.5
		
		self.BuildRate = 2
		self.InitialHealth = self:GetObjectHealth()
		self:SetMaxHealth(self:GetObjectHealth())
		
		if not tf_minidispenser_allow_upgrade:GetBool() then
			self.RepairRate = 0
			self.UpgradeRate = 0
		end
		timer.Simple(0.05, function()
			self:SetModel("models/buildables/mdispenser_light.mdl")
			self.Model:SetModel("models/buildables/mdispenser_light.mdl")
		end)
	elseif self:GetBuildingType() == 2 then 
		
		self.BuildRate = 2
		self.InitialHealth = self:GetObjectHealth()
		self:SetMaxHealth(self:GetObjectHealth())
		
		if not tf_minidispenser_allow_upgrade:GetBool() then
			self.RepairRate = 15
			self.UpgradeRate = 15
		end
		timer.Simple(0.05, function()
			self:SetModel("models/buildables/dispenser_light.mdl")
			self.Model:SetModel("models/buildables/repair_level1.mdl")
		end)
	end
end

function ENT:OnStartUpgrade()
	self:EmitSound(self.Sound_DoneBuilding, 100, 100)
	
	if self.level==2 then
		self.MetalPerGeneration = 50
		self.HealRate = 0.066
		self.AmmoPerSupply = 50
		timer.Simple(0.2, function()
			self:SetModel("models/buildables/dispenser_light.mdl")
		end)
		timer.Simple(0.05, function()
			if self:GetBuildingType() == 2 then
			self.Model:SetModel("models/buildables/repair_level2.mdl")
			end
		end)
	else if self.level==3 then
		self.MetalPerGeneration = 60
		self.HealRate = 0.05
		self.AmmoPerSupply = 60
		timer.Simple(0.2, function()
			self:SetModel("models/buildables/dispenser_light.mdl")
		end)
		timer.Simple(0.05, function()
			if self:GetBuildingType() == 2 then
			self.Model:SetModel("models/buildables/repair_level3.mdl")
			end
		end)
		end
	end
end

function ENT:OnThinkActive()
	if self.NextGenerate and CurTime()>=self.NextGenerate then
		local color = self:GetColor()
		if self:AddMetalAmount(self.MetalPerGeneration)>0 and color.a>0 then
			self:EmitSound(self.Sound_Generate, 100, 100)
		end
		if self:GetBuildingType() == 1 then
			self.NextGenerate = CurTime() + 2.5
		else
			self.NextGenerate = CurTime() + 5
		end
	end
	
	if not self.NextSearch or CurTime()>=self.NextSearch then
		local removedclients = table.Copy(self.Clients)
		for _,v in pairs(ents.FindInSphere(self:GetPos(), self.Range)) do
			if (v:IsPlayer() or v:IsNPC() or v.Base == "npc_tf2base") and not v:IsBuilding() and (self:Team()==TEAM_NEUTRAL or GAMEMODE:EntityTeam(v)==self:Team()) then
				if self.Clients[v] then
					-- Don't remove that client
					removedclients[v] = nil
				else
					self:StartSupply(v)
				end 
			end
			if (self:GetBuildingType() == 2) and v:IsBuilding() and (self:Team()==TEAM_NEUTRAL or GAMEMODE:EntityTeam(v)==self:Team()) then
				if self.Clients[v] then 
					-- Don't remove that client
					removedclients[v] = nil
				else
					self:StartSupply(v)
				end
			end
		end
		
		for k,_ in pairs(removedclients) do
			self:StopSupply(k)
		end
		
		self.NextSearch = CurTime() + 0.2
	end
	
	if not self.NextAmmoSupply or CurTime()>=self.NextAmmoSupply then
		local metal_before = self:GetMetalAmount()
		local metal_after = metal_before
		
		for k,_ in pairs(self.Clients) do
			if k:IsPlayer() then
				GAMEMODE:GiveAmmoPercentNoMetal(k, self.AmmoPerSupply)
				
				if metal_after > 0 then
					local ammo_before = k:GetAmmoCount(TF_METAL)
					k:GiveTFAmmo(math.min(self.MetalPerGeneration, metal_after), TF_METAL)
					local ammo_after = k:GetAmmoCount(TF_METAL)
					metal_after = metal_after - (ammo_after - ammo_before)
				end
			end
		end
		self:AddMetalAmount(metal_after - metal_before)
		if self:GetBuildingType() == 1 then
			self.NextAmmoSupply = CurTime() + 0.7
		else
			self.NextAmmoSupply = CurTime() + 1
		end
	end
	
	if not self.NextHeal or CurTime()>=self.NextHeal then
		for k,_ in pairs(self.Clients) do
			if self:GetBuildingType() == 2 then
				k:SetHealth(math.Clamp(k:Health() + 1.5, 0, k:GetMaxHealth() + 140))
			else
				k:SetHealth(math.Clamp(k:Health() + 1, 0, k:GetMaxHealth()))
			end
			
			if k:IsNPC() and not k:IsCurrentSchedule(SCHED_FORCED_GO_RUN) and not k.DoneWaitForHealingSchedule then
				if IsValid(k:GetEnemy()) then
					k:SetSchedule(SCHED_SHOOT_ENEMY_COVER)
				else
					k:SetSchedule(SCHED_COWER)
				end
				k.DoneWaitForHealingSchedule = true
			end
		end
		self.NextHeal = CurTime() + self.HealRate
	end
	
	if not self.NextCallNPCs or CurTime()>=self.NextCallNPCs then
		for _,v in pairs(ents.FindInSphere(self:GetPos(), self.NPCCallRange)) do
			if not v.BeingHealedByDispenser and v:IsNPC() and v:IsFriendly(self) and not v:IsBuilding() and v:GetMoveType()==MOVETYPE_STEP then
				if v:GetMaxHealth() > 0 and v:Health() / v:GetMaxHealth() <= self.NPCCallHealthFraction then
					if math.random() < self.NPCCallProbability then
						v:SetLastPosition(self:NearestPoint(v:GetPos()))
						v:SetSchedule(SCHED_FORCED_GO_RUN)
					end
				end
			end
		end
		self.NextCallNPCs = CurTime() + 2
	end
end

function ENT:OnRemove()
	for _,v in pairs(self.Clients or {}) do
		self:StopSupply()
	end
	
	if self.Idle_Sound then
		self.Idle_Sound:Stop()
	end
	
	if self.Heal_Sound then
		self.Heal_Sound:Stop()
	end
end