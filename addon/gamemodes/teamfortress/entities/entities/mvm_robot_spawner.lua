if SERVER then AddCSLuaFile() end
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true
ENT.PrintName		= "Robot Spawner"
ENT.Category		= "TF2: MVM Bots"

local stock_bots = {
	"mvm_bot",
	"mvm_bot_soldier",
	"mvm_bot_pyro",
	"mvm_bot_demoman",
	"mvm_bot_heavy",
	"mvm_bot_medic",
	"mvm_bot_sniper",
}

list.Set( "NPC", "mvm_robot_spawner", {
	Name = ENT.PrintName,
	Class = "mvm_robot_spawner",
	Category = ENT.Category,
	AdminOnly = true
} )
function ENT:Initialize()
	if CLIENT then return end	
	self:SetModel("models/buildables/teleporter_light.mdl")
	self:ResetSequence(self:LookupSequence("running"))
	self:SetSolid(SOLID_BBOX)
	self:SetModelScale(1.0)
	self.bots = {}
	self.bot = {}
	self.spawnsblu = {}	
	self:SetSkin(1)
	if SERVER then
		for k, v in pairs(ents.FindByClass("info_player_teamspawn")) do
			if v:GetKeyValues()["StartDisabled"] == 0 then
				if v:GetKeyValues()["TeamNum"] == 3 then
					table.insert(self.spawnsblu, v)
				end
			end
		end
	end
	timer.Create("BotSpawner", 10, 0, function()
		if SERVER then
			if (table.Count(self.bots) < 5) then 
				local bot = ents.Create(table.Random(stock_bots))
				if (!IsValid(bot)) then 
					coroutine.wait(0.1)
					return
				end
				local spawn = table.Random(self.spawnsblu) 
				if (table.Count(self.spawnsblu) == 0) then
					spawn = self
				end
				bot:SetPos(spawn:GetPos())
				table.insert(self.bots,bot) 
				bot:SetOwner(self)
				bot:Spawn()
				ParticleEffect("teleportedout_blue", self:GetPos(), self:GetAngles(), bot)
				bot:EmitSound("weapons/rescue_ranger_teleport_send_0"..math.random(1,2)..".wav",85,100)
				ParticleEffect("teleportedin_blue", bot:GetPos(), bot:GetAngles(), bot)
				bot.TargetEnt = table.Random(team.GetPlayers(TEAM_RED))
				print("Creating robot #"..bot:EntIndex())
			else
				print("We have reached the limits! Not spawning MVM bots...")
			end
		end
	end)
end

function ENT:OnInjured()
	return false
end

function ENT:OnKilled()
	return false
end

function ENT:IsNPC()
	return false
end

function ENT:IsNextBot()
	return true
end

function ENT:Health()
	return nil
end

function ENT:OnRemove()
	if SERVER then
		if (self.bots and table.Count(self.bots) > 0) then
			for k,v in ipairs(self.bots) do
				v:Remove()
				print("Removed robot #"..v:EntIndex())
			end
		end
	end
end

function ENT:ChasePos()
end
function ENT:Think()
	if (self:GetCycle() == 1) then
		self:ResetSequence(self:SelectWeightedSequence(ACT_IDLE))
		self:SetCycle(0)
	end
	if SERVER then
		if (self.bots and table.Count(self.bots) > 0) then
			for k,v in ipairs(self.bots) do
				if (!IsValid(v)) then
					table.remove(self.bots,k)
				end
			end
		end
	end
	self:NextThink(CurTime())
	return true	
end