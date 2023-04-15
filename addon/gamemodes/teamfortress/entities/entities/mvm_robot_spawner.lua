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
}
local unlock_bots = {
	"mvm_bot_scout_minor_league",
	"mvm_bot_heavyweightchamp",
	"mvm_bot_heavyweightchampfast",
	"mvm_bot_melee_scout",
	"mvm_bot_scout_sun_stick",
	"mvm_bot_melee_scout_sandman",
	"mvm_bot_samurai_demo",
	"mvm_bot_steelgauntlet",
	"mvm_bot_melee_scout_fanwar",
	"mvm_bot_pyro_flare",
	"mvm_bot_scoutfan",
	"mvm_bot_demoknight"
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
			if (!self.bots or table.Count(self.bots) < 8) then 
				local bot = ents.Create(table.Random(stock_bots))
				if (math.random(1,10) == 1) then -- unlocked bots
					bot = ents.Create(table.Random(unlock_bots))
				end
				if (!IsValid(bot)) then
					return
				end
				local spawn = table.Random(self.spawnsblu) 
				if (table.Count(self.spawnsblu) == 0) then
					spawn = self
				end
				bot:SetPos(spawn:GetPos() + Vector(0,0,45))
				table.insert(self.bots,bot) 
				bot:SetOwner(self)
				bot:Spawn()
				bot:EmitSound("weapons/rescue_ranger_teleport_send_0"..math.random(1,2)..".wav",85,100)
				bot.TargetEnt = table.Random(team.GetPlayers(TEAM_RED))
				print("Creating robot #"..bot:EntIndex())
			else
				print("We have reached the limits! Not spawning MVM bots...")
			end
		end
		ParticleEffect("teleportedin_blue", self:GetPos(), self:GetAngles(), self)
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
  
function ENT:Think()
	if SERVER then
		if (self.bots and table.Count(self.bots) > 0) then
			for k,v in ipairs(self.bots) do
				table.remove(self.bots,k)
				print("Removed robot #"..v:EntIndex())
			end
		end
	end
	self:NextThink(CurTime())
	return true	
end