if SERVER then AddCSLuaFile() end
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true
ENT.PrintName		= "Robot Spawner"
ENT.Category		= "TFBots"

local stock_bots = {
	"mvm_bot",
	"mvm_bot_melee_scout",
	"mvm_bot_soldier",
	"mvm_bot_demoman",
	"mvm_bot_heavy",
	"mvm_bot_medic",
}
local horde_bots = {
	"mvm_bot",	
	"mvm_bot_soldier",
	"mvm_bot_demoman",
	"mvm_bot_heavy",
	"mvm_bot_demoknight",
	"mvm_bot_melee_scout",
	"mvm_bot_melee_scout_sandman",
	"mvm_bot_scout_minor_league",
}
local unlock_bots = {
	"mvm_bot_scout_minor_league",
	"mvm_bot_melee_scout_sandman",
	"mvm_bot_melee_scout_expert",
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
	"mvm_bot_bowman",
	"mvm_bot_samurai_demo",
	"mvm_bot_scout_shortstop",
	"mvm_bot_engineer"
}

local giant_bots = {
	"mvm_bot_giantscout",
	"mvm_bot_giantsoldier",
	"mvm_bot_giantchargedsoldier",
	"mvm_bot_giantburstfiresoldier",
	"mvm_bot_giantblastsoldier",
	"mvm_bot_giantpyro",
	"mvm_bot_giantflarepyro",
	"mvm_bot_giantpyro_airblast",
	"mvm_bot_giantdemoman",
	"mvm_bot_giantdemoknight",
	"mvm_bot_giantheavy",
	"mvm_bot_giantheavydeflector",
	"mvm_bot_giantheavy_brassbeast",
	"mvm_bot_giantheavy_natascha",
	"mvm_bot_colonelbarrage",
	"mvm_bot_heavyweightchamp_giant",
	"mvm_bot_bowman_rapid_fire",
	"mvm_bot_superscout",
	"mvm_bot_superscoutfan",
	"mvm_bot_scout_major_league"
}

list.Set( "NPC", "mvm_robot_spawner", {
	Name = ENT.PrintName,
	Class = "mvm_robot_spawner",
	Category = ENT.Category,
	AdminOnly = true,
	AdminOnly = true
} )
function ENT:Initialize()
	if CLIENT then return end	
	self:SetModel("models/buildables/teleporter.mdl")
	self:ResetSequence(self:LookupSequence("running"))
	self:SetSolid(SOLID_BBOX)
	self:SetModelScale(1.0)
	self.bots = {}
	self.bot = {}
	self.spawnsblu = {}	
	self:SetSkin(1)
	if SERVER then
		self:EmitSound("MVM.Robot_Engineer_Spawn")
		if (string.find(game.GetMap(),"mvm_")) then
			for k, v in pairs(ents.FindByClass("team_round_timer")) do
				v.IsSetupPhase = true
				v:SetAndPauseTimer(v.SetupLength, true)
			end
		end
		for k, v in pairs(ents.FindByClass("info_player_teamspawn")) do
			if v:GetKeyValues()["StartDisabled"] == 0 then
				if v:GetKeyValues()["TeamNum"] == 3 and !string.find(v:GetClass(),"sniper") and !string.find(v:GetClass(),"spy") and v:GetClass() != "spawnbot_invasion" and v:GetClass() != "spawnbot_left" then
					table.insert(self.spawnsblu, v)
				end
			end
		end
	end
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
			for k,v in ipairs(self.bots) do
				v:Remove()
				--print("Removed robot #"..v:EntIndex())
			end
	end
end
  
function ENT:Think()
	if SERVER then
		for k,v in ipairs(self.bots) do
			table.remove(self.bots,k)
			--print("Removed robot #"..v:EntIndex())
		end
	end
	self:NextThink(CurTime())
	return true	
end


function ENT:Use( activator, caller )
	if (!self.WaveStarted) then
		umsg.Start("TF_PlayGlobalSound")
			umsg.String("music.mvm_start_wave")
		umsg.End()
		umsg.Start("TF_PlayGlobalSound")
			umsg.String("Announcer.MVM_Wave_Start")
		umsg.End()
		if SERVER then
			if (string.find(game.GetMap(),"mvm_")) then
				for k, v in pairs(ents.FindByClass("team_round_timer")) do
					v:SetAndResumeTimer2(9, true)
				end
			end
		end
		local count = math.random(15,32)
				timer.Create("WaveEnder", 10 * count, 1, function()
					timer.Create("WaitUntilAllBotsDead", 0.1, 0, function()
						if (table.Count(team.GetPlayers(TEAM_BLU)) == 0) then
							umsg.Start("TF_PlayGlobalSound")
								umsg.String("music.mvm_end_wave")
							umsg.End()
							umsg.Start("TF_PlayGlobalSound")
								umsg.String("Announcer.MVM_Wave_End")
							umsg.End()
							
							for k, v in pairs(ents.FindByClass("team_round_timer")) do
								v.IsSetupPhase = true
								v:SetAndPauseTimer(v.SetupLength, true)
							end
							for k,v in ipairs(ents.FindByClass("func_door")) do
								if (v:GetName() == "cave_door") then
									v:Fire("Close","",0)
								end
							end
							self.WaveStarted = false
							for k,v in ipairs(ents.FindByClass("item_teamflag_mvm")) do
								v:Return()
							end
							timer.Stop("SentryBusterSpawner")
							timer.Stop("WaitUntilAllBotsDead")
						end
					end)
				end)
		timer.Simple(10, function()
			self:EmitSound("MVM.Robot_Teleporter_Deliver")
			for k,v in ipairs(player.GetAll()) do
				if (v:Team() != TEAM_BLU) then
					v:Speak("TLK_ROUND_START")
				end
			end
		end)
		timer.Create("SentryBusterSpawner", 30, 0, function()
			if SERVER then
				local count = #ents.FindByClass("obj_sentrygun")
				for k,v in ipairs(ents.FindByClass("obj_sentrygun")) do
					if (IsValid(v) and k == 1) then
						local spawn = table.Random(self.spawnsblu) 
						if (table.Count(self.spawnsblu) == 0) then
							spawn = self
						end
						for k,v in ipairs(player.GetBots()) do
							if (v:Nick() == "Sentry Buster") then
								return
							end
						end
						local bot = ents.Create("mvm_bot_sentrybuster")
						if (!IsValid(bot)) then
							return
						end
						bot:SetPos(spawn:GetPos() + Vector(0,0,45))
						table.insert(self.bots,bot) 
						bot:SetOwner(self)
						bot:Spawn() 
						bot:EmitSound("weapons/rescue_ranger_teleport_send_0"..math.random(1,2)..".wav",70,100)
						bot.TargetEnt = v
						ParticleEffect("teleportedin_blue", bot:GetPos(), bot:GetAngles(), self)
						--print("Creating robot #"..bot:EntIndex())
					end
				end
						
			end
		end)
		timer.Create("BotSpawner", 9, count, function()
			if SERVER then 
				local slef = self
				local spawn = table.Random(self.spawnsblu) 
				if (table.Count(self.spawnsblu) == 0) then
					spawn = self
				end
				if (table.Count(team.GetPlayers(TEAM_BLU)) < 6) then
					if (math.random(1,8) == 1) then
						local bottable = table.Random(horde_bots)
						if (math.random(1,4) == 1) then -- unlocked bots
							bottable = table.Random(unlock_bots)
						end 
							for i=1,math.random(2,10) do
								local bot = ents.Create(bottable)
								if (!IsValid(bot)) then
									return
								end
								bot:SetPos(spawn:GetPos() + Vector(0,0,45))
								table.insert(self.bots,bot) 
								bot:SetOwner(self)
								bot:Spawn()
								bot.TargetEnt = table.Random(team.GetPlayers(TEAM_RED))
								bot:EmitSound("weapons/rescue_ranger_teleport_send_0"..math.random(1,2)..".wav",70,100)
								ParticleEffect("teleportedin_blue", bot:GetPos(), bot:GetAngles(), self)
								--print("Creating horde robot #"..bot:EntIndex())
							end
					else
						local bot = ents.Create(table.Random(stock_bots))
						if (math.random(1,6) == 1) then -- unlocked bots
							bot = ents.Create(table.Random(unlock_bots))
							for i=1,math.random(1,10) do
								if (!IsValid(bot)) then
									return
								end
								bot:SetPos(spawn:GetPos() + Vector(0,0,45))
								table.insert(self.bots,bot) 
								bot:SetOwner(self)
								bot:Spawn() 
								bot:EmitSound("weapons/rescue_ranger_teleport_send_0"..math.random(1,2)..".wav",70,100)
								ParticleEffect("teleportedin_blue", bot:GetPos(), bot:GetAngles(), self)
								bot.TargetEnt = table.Random(team.GetPlayers(TEAM_RED))
								--print("Creating robot #"..bot:EntIndex())
							end
							
						elseif (math.random(1,10) == 1) then
							bot = ents.Create(table.Random(giant_bots)) 
								if (!IsValid(bot)) then
									return
								end
								bot:SetPos(spawn:GetPos() + Vector(0,0,45))
								table.insert(self.bots,bot) 
								bot:SetOwner(self)
								bot:Spawn() 
								bot:EmitSound("weapons/rescue_ranger_teleport_send_0"..math.random(1,2)..".wav",70,100)
								ParticleEffect("teleportedin_blue", bot:GetPos(), bot:GetAngles(), self)
								bot.TargetEnt = table.Random(team.GetPlayers(TEAM_RED))
								--print("Creating robot #"..bot:EntIndex())
							
						else

							for i=1,math.random(1,10) do
								if (!IsValid(bot)) then
									return
								end
								bot:SetPos(spawn:GetPos() + Vector(0,0,45))
								table.insert(self.bots,bot) 
								bot:SetOwner(self)
								bot:Spawn() 
								bot:EmitSound("weapons/rescue_ranger_teleport_send_0"..math.random(1,2)..".wav",70,100)
								ParticleEffect("teleportedin_blue", bot:GetPos(), bot:GetAngles(), self)
								bot.TargetEnt = table.Random(team.GetPlayers(TEAM_RED))
								--print("Creating robot #"..bot:EntIndex())
							end

						end
					end
				else
					--print("We have reached the limits! Not spawning MVM bots...")
				end
			end
		end)
		self.WaveStarted = true
	end
end