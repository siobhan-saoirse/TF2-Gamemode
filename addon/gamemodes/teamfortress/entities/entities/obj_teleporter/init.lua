
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

ENT.NumLevels = 3
ENT.Levels = {
{Model("models/buildables/teleporter.mdl"), Model("models/buildables/teleporter_light.mdl")},
{Model("models/buildables/teleporter.mdl"), Model("models/buildables/teleporter_light.mdl")},
{Model("models/buildables/teleporter.mdl"), Model("models/buildables/teleporter_light.mdl")},
}
ENT.IdleSequence = "running"
ENT.DisableDuringUpgrade = false
ENT.NoUpgradedModel = false

ENT.Sound_Ready = Sound("Building_Teleporter.Ready")
ENT.Sound_Send = Sound("Building_Teleporter.Send")
ENT.Sound_Receive = Sound("Building_Teleporter.Receive")

ENT.Sound_Spin1 = Sound("Building_Teleporter.SpinLevel1")
ENT.Sound_Spin2 = Sound("Building_Teleporter.SpinLevel2")
ENT.Sound_Spin3 = Sound("Building_Teleporter.SpinLevel3")

ENT.Sound_Explode = Sound("Building_Teleporter.Explode")

--ENT.Sound_DoneBuilding = Sound("Building_Sentrygun.Built")

ENT.TeleportDelay = 1

ENT.RechargeTime = 10
ENT.RechargeTime2 = 7
ENT.RechargeTime3 = 5
ENT.MinRechargingSpinSpeed = 0.2
ENT.SpinSpeed = 0

ENT.Acceleration = 0

ENT.Spawnpoint = false
ENT.Entrance = false
ENT.Exit = false
ENT.Sapped = false

ENT.Gibs = {
Model("models/buildables/Gibs/teleporter_gib1.mdl"),
Model("models/buildables/Gibs/teleporter_gib2.mdl"),
Model("models/buildables/Gibs/teleporter_gib3.mdl"),
Model("models/buildables/Gibs/teleporter_gib4.mdl"),
}

ENT.Accelerations = {
	{acc=0.003, dec=0.002},
}

function ENT:SetAcceleration(a)
	self.Acceleration = a
end

function ENT:OnStartBuilding()
	if self.Entrance == true then
		self:SetBuildMode(0)
	elseif self.Exit == true then
		self:SetBuildMode(1)	
	end
end

function ENT:PostEnable(laststate)
	if laststate == 1 then
		for _,v in pairs(ents.FindByClass("obj_teleporter")) do
			if v ~= self and v:GetBuilder() == self:GetBuilder() and v:GetState() == 3 and not IsValid(v:GetLinkedTeleporter()) then
				if (self:IsEntrance() and v:IsExit()) or (self:IsExit() and v:IsEntrance()) then
					self:SetLinkedTeleporter(v)
					v:SetLinkedTeleporter(self)
					self:OnLink(v)
					v:OnLink(self)
				end
			end
		end
		
		self.SpinSpeed = 0
		self:SetPlaybackRate(0)
	end
end

function ENT:OnLink(ent)
	if self.Spin_Sound then
		self.Spin_Sound:Stop()
	end
	self.Spin_Sound = CreateSound(self, self.Sound_Spin1)
	self.Spin_Sound:Play()
	self:SetAcceleration(0.005)
	self:SetChargePercentage(1)

	self.Model:ResetSequence("running")	

end

function ENT:OnUnlink(ent)
	if (!self.Spawnpoint) then
		self:SetAcceleration(-0.003)
	end
end

function ENT:OnStartUpgrade()
	if IsValid(self:GetLinkedTeleporter()) then
		self:SetChargePercentage(1)
		
		if self.Spin_Sound then
			self.Spin_Sound:Stop()
		end
		
		self.NextRecharge = CurTime() + 2
		self.NextRestartMotor = CurTime() + 2
		self:SetAcceleration(-0.006)
		self:GetLinkedTeleporter():SetAcceleration(-0.006)	
		self:GetLinkedTeleporter().NextRecharge = CurTime() + 3.5
		self:GetLinkedTeleporter().NextRestartMotor = CurTime() + 2
		
		self.DoneInitialWarmup = true
		if self:GetLevel()==2 then
			self.Spin_Sound = CreateSound(self, self.Sound_Spin2)
			self.Spin_Sound:Play()
		elseif self:GetLevel()==3 then
			self.Spin_Sound = CreateSound(self, self.Sound_Spin3)
			self.Spin_Sound:Play()
		end
	end
end

function ENT:GetExitPosition()
	local att = self:GetAttachment(self:LookupAttachment("centre_attach"))
	return att.Pos + 2*vector_up
end

function ENT:AddMetal(owner, max)
	if not self.BuildBoost then
		self.BuildBoost = {}
	end
	
	local exit = self:GetLinkedTeleporter()
	local mult = 1
	local w = owner:GetActiveWeapon()
	if IsValid(w) and w.ConstructRateMultiplier then
		mult = w.ConstructRateMultiplier
	end
	
	self.BuildBoost[owner] = {val=mult, endtime=CurTime() + 0.8}
	
	-- Building or upgrading
	if self:GetState()~=3 then return 0 end
	
	local max0 = max
	local metal_spent
	
	local repaired, resupplied, upgraded
	
	-- Repair
	metal_spent = math.Clamp(math.ceil((self:GetMaxHealth() - self:Health()) * 0.2), 0, math.min(max, self.RepairRate))
	
	if metal_spent > 0 then
		GAMEMODE:HealPlayer(owner, self, 5 * metal_spent, true, false)
		
		max = max - metal_spent
		repaired = true
	end
	
	-- Upgrade
	if self:GetLevel()<self.NumLevels then
		local current = self:GetMetal()
		metal_spent = math.Clamp(self.UpgradeCost - current, 0, math.min(max, self.UpgradeRate))
		current = current + metal_spent
		
		if current>=self.UpgradeCost then
			self:SetMetal(0)
			self:Upgrade()
			-- Upgrading already resupplies ammo so we don't need to do anything else
			upgraded = true
		elseif not repaired or not self:NeedsResupply() then
			-- Add to the upgrade status only if no metal was spent repairing the building or if the building doesn't need to be resupplied first
			self:SetMetal(current)
		end
		
		max = max - metal_spent
	end
	
	-- Resupply (todo)
	if self:NeedsResupply() and not upgraded then
		metal_spent = self:Resupply(max)
		
		if metal_spent then
			max = max - metal_spent
			resupplied = true
		end
	end
	
	return max0 - max
end

function ENT:Teleport(pl)
	if not self:IsEntrance() then return end
	local exit = self:GetLinkedTeleporter()
	if not IsValid(exit) then return end
	
	self:EmitSound(self.Sound_Send)
	
	self:SetChargePercentage(0)
	if self:GetLevel() == 2 then
		self.SpinSpeed = 2
		self:SetAcceleration(-0.004)
		self.NextRecharge = CurTime() + self.RechargeTime2
		self.NextRestartMotor = CurTime() + 0.5 * self.RechargeTime2
	elseif self:GetLevel() == 3 then
		self.SpinSpeed = 3
		self:SetAcceleration(-0.005)
		self.NextRecharge = CurTime() + self.RechargeTime3
		self.NextRestartMotor = CurTime() + 0.5 * self.RechargeTime3
	else
		self.SpinSpeed = 1.0
		self:SetAcceleration(-0.0025)
		self.NextRecharge = CurTime() + self.RechargeTime
		self.NextRestartMotor = CurTime() + 0.5 * self.RechargeTime
	end
	if exit:GetLevel() == 2 then
		exit.SpinSpeed = 2
		exit:SetAcceleration(-0.004)
		exit.NextRecharge = CurTime() + exit.RechargeTime2
		exit.NextRestartMotor = CurTime() + 0.5 * exit.RechargeTime2
	elseif exit:GetLevel() == 3 then
		exit.SpinSpeed = 3
		exit:SetAcceleration(-0.005)
		exit.NextRecharge = CurTime() + exit.RechargeTime3
		exit.NextRestartMotor = CurTime() + 0.5 * exit.RechargeTime3
	else
		exit.SpinSpeed = 1.0
		exit:SetAcceleration(-0.0025)
		exit.NextRecharge = CurTime() + exit.RechargeTime
		exit.NextRestartMotor = CurTime() + 0.5 * exit.RechargeTime
	end
	if pl:IsTFPlayer() then
		if pl:IsPlayer() then
		pl:SetFOV(50, 0.5)
		umsg.Start("TFTeleportEffect", pl)
		umsg.End()
		pl:ScreenFade( SCREENFADE.OUT, Color( 255, 255, 255, 150 ), 0.5, 0.65 )
		end
		ParticleEffect("teleportedin_red", self:GetPos(), self:GetAngles(), pl)
		timer.Simple(0.3, function()	
			
			if pl:IsPlayer() then
			pl:SetFOV(0, 0.7)
			end
		end)
	end
	timer.Simple(0.4, function()
		pl:SetPos(exit:GetExitPosition())
		ParticleEffect("teleportedin_red", exit:GetPos(), exit:GetAngles(), pl)
		exit:EmitSound(self.Sound_Receive)
		
		local y = self:GetAngles().y
		if pl:IsTFPlayer() then
			if pl:IsPlayer() then
			local ang = pl:EyeAngles()
			ang.y = y
			pl:SetEyeAngles(ang)
			umsg.Start("TFTeleportEffect", pl)
			umsg.End()
			else
			local ang = pl:GetAngles()
			ang.y = y
			pl:SetAngles(ang)			
			end
		else 
			local ang = pl:GetAngles()
			ang.y = y
			pl:SetAngles(ang)
		end
	end)
	self.DoneInitialWarmup = true
end

function ENT:OnThinkActive()
	if self:IsEntrance() and IsValid(self:GetLinkedTeleporter()) then
		self:SetBodygroup(2, 1)
		self:SetPoseParameter("direction", self.Model:GetAngles().y-(self.Model:GetPos()-self:GetLinkedTeleporter():GetPos()):Angle().y)
		self.Model:SetBodygroup(2, 1)
		self.Model:SetPoseParameter("direction", self.Model:GetAngles().y-(self.Model:GetPos()-self:GetLinkedTeleporter():GetPos()):Angle().y)
	else
		self:SetBodygroup(2, 0)
		self.Model:SetBodygroup(2, 0)
	end
	if string.find(game.GetMap(),"mvm_") and self:GetBuilder():Team() == TEAM_BLU then
		self.Spawnpoint = true
	end
	if !IsValid(self:GetLinkedTeleporter()) then
		self:OnUnlink(self:GetLinkedTeleporter())
	end
	
	if (self.Spawnpoint) then
	 
		if (!IsValid(self:GetLinkedTeleporter())) then 
			self:SetLinkedTeleporter(self)
			self:OnLink(self)
			self:SetAcceleration(0.0025)
			for k,v in pairs(player.GetAll()) do
				if !v:IsFriendly(self) then
					v:SendLua([[surface.PlaySound("vo/announcer_mvm_eng_tele_activated0"..math.random(1,4)..".mp3")]])
				end
				v:SendLua([[surface.PlaySound("mvm/mvm_tele_activate.wav")]])
			end
		end
	end
	if self.NextRecharge then
		local r = math.Clamp(1 - (self.NextRecharge - CurTime()) / self.RechargeTime, 0, 1)
		self:SetChargePercentage(r)
		if r == 1 then
			self.NextRecharge = nil
			self.SpinSpeed = 1
		end
	end
	
	self.Model:ResetSequence("running")	
	if self.NextRestartMotor and CurTime() >= self.NextRestartMotor then
		if self:GetLevel() == 1 then
			self:SetAcceleration(0.0025)
		elseif self:GetLevel() == 2 then
			self:SetAcceleration(0.004)
		elseif self:GetLevel() == 3 then
			self:SetAcceleration(0.005)
		end
		self.NextRestartMotor = nil
	end
	
	local exit = self:GetLinkedTeleporter()
	self.SpinSpeed = math.Clamp(self.SpinSpeed + self.Acceleration, 0, 1)
	self:SetPlaybackRate(self.SpinSpeed)
	self.Model:SetPlaybackRate(self.SpinSpeed)
	if self.Spin_Sound then
		self.Spin_Sound:ChangePitch(math.Clamp(100*self.SpinSpeed, 1, 100), 0)
	end
	
	if self.SpinSpeed == 1 then
		self:SetBodygroup(1,1)
		self.DoneInitialWarmup = true
	else
		self:SetBodygroup(1,0)
	end
	self:SetCycle(self.Model:GetCycle())
	local ready = self:IsReady()
	if ready ~= self.LastReady then
		if ready then
			self:EmitSound(self.Sound_Ready)
			exit:EmitSound(self.Sound_Ready)
			self.Clients = {}
		end
		self.LastReady = ready
	end
	
	if ready and self:IsEntrance() then
		local pos = self:GetPos()
		local teleported = false
		
		for _,v in pairs(self.Clients) do
			v.removeme = true
		end
		
		for _,pl in pairs(ents.FindInBox(pos + Vector(-10, -10, 0), pos + Vector(10, 10, 30))) do
			if pl:IsTFPlayer() and self:IsFriendly(pl) and not pl:IsBuilding() then
				if not self.Clients[pl] then
					self.Clients[pl] = {starttime = CurTime()}
				else
					self.Clients[pl].removeme = nil
					if not teleported and CurTime() - self.Clients[pl].starttime > self.TeleportDelay then
						teleported = true
						self.Clients[pl] = nil
						self:Teleport(pl)
					end
				end
			elseif pl:IsPlayer() and pl:GetPlayerClass() == "spy" and not pl:IsBuilding() and (pl:GetMoveType()==MOVETYPE_WALK or pl:GetMoveType()==MOVETYPE_STEP) then
				if not self.Clients[pl] then
					self.Clients[pl] = {starttime = CurTime()}
				else
					self.Clients[pl].removeme = nil
					if not teleported and CurTime() - self.Clients[pl].starttime > self.TeleportDelay then
						teleported = true
						self.Clients[pl] = nil
						self:Teleport(pl)
					end
				end
			end
		end
		
		for k,v in pairs(self.Clients) do
			if v.removeme then
				self.Clients[k] = nil
			end
		end
	end
end

function ENT:OnRemove()
	if self.Spin_Sound then
		self.Spin_Sound:Stop()
	end
end