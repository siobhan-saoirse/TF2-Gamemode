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
	"mvm_bot_demoman",
	"mvm_bot_heavy",
}
local horde_bots = {
	"mvm_bot",	
	"mvm_bot_soldier",
	"mvm_bot_melee_scout",
	"mvm_bot_demoman",
	"mvm_bot_heavy",
	"mvm_bot_demoknight",
	"mvm_bot_melee_scout_sandman",
	"mvm_bot_scout_minor_league",
}
local unlock_bots = {
	"mvm_bot_scout_minor_league",
	"mvm_bot_melee_scout_sandman",
	"mvm_bot_bonk_scout",
	"mvm_bot_heavyweightchamp",
	"mvm_bot_heavyweightchampfast",
	"mvm_bot_melee_scout",
	"mvm_bot_scout_sun_stick",
	"mvm_bot_melee_scout_sandman",
	"mvm_bot_steelgauntlet",
	"mvm_bot_melee_scout_fanwar",
	"mvm_bot_pyro_flare",
	"mvm_bot_scout_wrap_assassin",
	"mvm_bot_pyro_pusher",
	"mvm_bot_heavyshotgun",
	"mvm_bot_scout_shortstop",
	"mvm_bot_deflectorheavy",
	"mvm_bot_medic",
	"mvm_bot_scoutfan",
	"mvm_bot_demoknight",
	"mvm_bot_bowman"
}

local giant_bots = {
	"mvm_bot_giantscout",
	"mvm_bot_giantsoldier",
	"mvm_bot_giantchargedsoldier",
	"mvm_bot_giantburstfiresoldier",
	"mvm_bot_giantblastsoldier",
	"mvm_bot_giantpyro",
	"mvm_bot_giantdemoman",
	"mvm_bot_giantdemoknight",
	"mvm_bot_giantheavy",
	"mvm_bot_giantheavydeflector",
	"mvm_bot_giantheavy_brassbeast",
	"mvm_bot_giantheavy_natascha",
	"mvm_bot_colonelbarrage",
	"mvm_bot_samurai_demo",
	"mvm_bot_steelgauntlet",
	"mvm_bot_steelgauntletpusher",
	"mvm_bot_heavyweightchamp_giant",
	"mvm_bot_bowman_rapid_fire",
	"mvm_bot_superscout",
	"mvm_bot_superscoutfan",
	"mvm_bot_scout_major_league",
	"mvm_bot_scout_shortstop",
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
	timer.Create("BotSpawner", 5, 0, function()
		if SERVER then 
				if (math.random(1,8) == 1) then
					local bottable = table.Random(horde_bots)
					if (math.random(1,4) == 1) then -- unlocked bots
						bottable = table.Random(unlock_bots)
					end
					local spawn = table.Random(self.spawnsblu) 
					if (table.Count(self.spawnsblu) == 0) then
						spawn = self
					end
					for i=1,math.random(4,8) do
						local bot = ents.Create(bottable)
						if (!IsValid(bot)) then
							return
						end
						bot:SetPos(spawn:GetPos() + Vector(0,0,45))
						table.insert(self.bots,bot) 
						bot:SetOwner(self)
						bot:Spawn()
						bot.TargetEnt = table.Random(team.GetPlayers(TEAM_RED))
						print("Creating horde robot #"..bot:EntIndex())
					end
				else
					local spawn = table.Random(self.spawnsblu) 
					if (table.Count(self.spawnsblu) == 0) then
						spawn = self
					end
						local bot = ents.Create(table.Random(stock_bots))
						if (math.random(1,6) == 1) then -- unlocked bots
							bot = ents.Create(table.Random(unlock_bots))
						elseif (math.random(1,10) == 1) then
							bot = ents.Create(table.Random(giant_bots)) 
						end
						if (!IsValid(bot)) then
							return
						end
						bot:SetPos(spawn:GetPos() + Vector(0,0,45))
						table.insert(self.bots,bot) 
						bot:SetOwner(self)
						bot:Spawn()
						bot:EmitSound("weapons/rescue_ranger_teleport_send_0"..math.random(1,2)..".wav",85,100)
						bot.TargetEnt = table.Random(team.GetPlayers(TEAM_RED))
						print("Creating robot #"..bot:EntIndex())
				end
			else
				print("We have reached the limits! Not spawning MVM bots...")
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