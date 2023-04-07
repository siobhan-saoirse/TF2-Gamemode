if (!IsMounted("left4dead2")) then return end
if SERVER then AddCSLuaFile() end
ENT.Base = "base_nextbot"
ENT.Type = "nextbot"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.PrintName		= "Raid"
ENT.Category		= "TF2: MVM Bots"

list.Set( "NPC", "mvm_mob_director", {
	Name = ENT.PrintName,
	Class = "mvm_mob_director",
	Category = ENT.Category,
	AdminOnly = true
} )
function ENT:Initialize()
	if CLIENT then return end	
	self:SetModel("models/bots/scout/bot_scout.mdl")
	self:ResetSequence(self:SelectWeightedSequence(ACT_IDLE))
	self:SetMaterial("debug/debugmrmwireframe")
	self:SetSolid(SOLID_NONE)
	self:SetModelScale(1)
	self:SetFOV(90)
	self.bots = {}
	self.bot = {}
end
function ENT:Think()
	self:SetNoDraw(!GetConVar("developer"):GetBool())
	if (self:GetCycle() == 1) then
		self:ResetSequence(self:SelectWeightedSequence(ACT_IDLE))
		self:SetCycle(0)
	end
	return true
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

local function LeadBot_S_Add_Zombie(team,class,pos)
	if !navmesh.IsLoaded() then
		ErrorNoHalt("There is no navmesh! Generate one using \"nav_generate\"!\n")
		return
	end

	local name = string.upper(string.sub(class,1,1))..string.sub(class,2)
	local bot = player.CreateNextBot(name)
	local teamv = TEAM_RED
	if team == 1 then
		teamv = TEAM_bot
	end

	if !IsValid(bot) then ErrorNoHalt("[LeadBot] Player limit reached!\n") return end
	bot.LastSegmented = CurTime() + 1

	bot.ControllerBot = ents.Create("ctf_bot_navigator")
	bot.ControllerBot:Spawn()
	bot.ControllerBot:SetOwner(bot)

	bot.LastPath = nil
	bot.CurSegment = 2
	bot.TFBot = true
	bot.IsL4DZombie = true
	bot.BotStrategy = math.random(0, 1)

    --timer.Simple(1, function()
        ----TalkToMe(bot, "join")
    --end)
	bot:SetTeam(teamv)
	bot:SetPlayerClass(class)
	bot:SetPos(pos)
	timer.Simple(0.1, function()
		if IsValid(bot) then
			bot:SetPlayerClass(class)
			bot.TFBot = true
		end
	end)

	MsgN("[LeadBot] Bot " .. name .. " with strategy " .. bot.BotStrategy .. " added!")
	return bot
end
local zombies = {
	"mvm_bot_melee_scout",
	"mvm_bot_melee_scout",
	"mvm_bot_melee_scout",
	"mvm_bot_melee_scout",
	"mvm_bot_melee_scout_sandman",
	"mvm_bot_bonk_scout",
	"mvm_bot_bowman",
	"mvm_bot_demoknight",
	"mvm_bot_scout_minor_league",
	"mvm_bot_heavyshotgun",
	"mvm_bot_scoutfan",
	"mvm_bot_scoutfan",
	"mvm_bot_steelgauntlet",
	"mvm_bot_steelgauntlet",
	"mvm_bot_steelgauntlet",
	"mvm_bot_steelgauntletpusher",
	"mvm_bot_steelgauntlet",
	"mvm_bot",
	"mvm_bot_soldier",
	"mvm_bot_pyro",
	"mvm_bot_demoman",
	"mvm_bot_heavy",
	"mvm_bot_engineer",
	"mvm_bot_medic",
	"mvm_bot_sniper",
	"mvm_bot_spy",
	"mvm_bot_scout_gatebot",
	"mvm_bot_soldier_gatebot",
	"mvm_bot_pyro_gatebot",
	"mvm_bot_demo_gatebot",
	"mvm_bot_heavy_gatebot",
	"mvm_bot_engineer_gatebot",
	"mvm_bot_medic_gatebot",
	"mvm_bot_sniper_gatebot",
	"mvm_bot_spy_gatebot",
	-- duplicate
	"mvm_bot_melee_scout",
	"mvm_bot_melee_scout",
	"mvm_bot_melee_scout",
	"mvm_bot_melee_scout",
	"mvm_bot_melee_scout_sandman",
	"mvm_bot_bonk_scout",
	"mvm_bot_bowman",
	"mvm_bot_demoknight",
	"mvm_bot_scout_minor_league",
	"mvm_bot_heavyshotgun",
	"mvm_bot_scoutfan",
	"mvm_bot_scoutfan",
	"mvm_bot_steelgauntlet",
	"mvm_bot_steelgauntlet",
	"mvm_bot_steelgauntlet",
	"mvm_bot_steelgauntletpusher",
	"mvm_bot_steelgauntlet",
	"mvm_bot",
	"mvm_bot_soldier",
	"mvm_bot_pyro",
	"mvm_bot_demoman",
	"mvm_bot_heavy",
	"mvm_bot_engineer",
	"mvm_bot_medic",
	"mvm_bot_sniper",
	"mvm_bot_spy",
	"mvm_bot_scout_gatebot",
	"mvm_bot_soldier_gatebot",
	"mvm_bot_pyro_gatebot",
	"mvm_bot_demo_gatebot",
	"mvm_bot_heavy_gatebot",
	"mvm_bot_engineer_gatebot",
	"mvm_bot_medic_gatebot",
	"mvm_bot_sniper_gatebot",
	"mvm_bot_spy_gatebot",
	"mvm_bot_giantscout",
	"mvm_bot_giantsoldier",
	"mvm_bot_giantpyro",
	"mvm_bot_giantheavy",
	"mvm_bot_giantdemoman",
	"mvm_bot_giantdemoknight",
	"mvm_bot_giantshotgunheavy",
	"mvm_bot_giantheavyheater",
	"mvm_bot_giantheavyheater_gatebot",
	"mvm_bot_giantheavy_brassbeast",
	"mvm_bot_giantheavy_natascha",
	"mvm_bot_giantheavy_deflector",
	"mvm_bot_deflectorheavy",
	"mvm_bot_bowman_rapid_fire",
	"mvm_bot_superscout",
	"mvm_bot_superscoutfan",
}

local combine = {
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_metropolice",
	"npc_hunter",
	"npc_hunter",
	"npc_manhack",
	"npc_manhack",
	"npc_manhack",
	"npc_manhack",
	"npc_manhack",
	"npc_manhack",
	"npc_manhack",
	"npc_manhack",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_combine_s",
	"npc_cscanner",
	"npc_clawscanner",
	"npc_stalker"
}
function ENT:OnRemove()
	for k,v in ipairs(self.bots) do
		v:Remove()
		print("Removed special bot #"..v:EntIndex())
	end
	for k,v in ipairs(self.bot) do
		if (IsValid(v)) then
			v:Remove()
			print("Removed bot #"..v:EntIndex())
		end
	end
end

function ENT:ChasePos()
end
function ENT:RunBehaviour()
	while (true) do 
		for k,v in ipairs(self.bots) do
			if (!IsValid(v)) then
				table.remove(self.bots,k)
			end
		end
		for k,v in ipairs(self.bot) do
			if (!IsValid(v)) then
				table.remove(self.bot,k)
			end
		end
		self.loco:SetAcceleration( 1400 )
		self.loco:SetDesiredSpeed( 1400 )		-- Walk speed
		local pos = self:FindSpot("random", {radius = 4000})
		if (pos) then
			self:SetPos(pos)	
		end
			if (math.random(1,120) == 1) then 
				if (table.Count(self.bots) < 2) then 
					local bot = ents.Create(table.Random(zombies))
					if (!IsValid(bot)) then 
						coroutine.wait(0.1)
						return
					end
					bot:SetPos(self:GetPos())
					table.insert(self.bots,bot)
					bot:SetOwner(self)
					bot:Spawn()
					if (bot:GetModel()) then
						self:SetModel(bot:GetModel())
						timer.Simple(0.1, function()
							self:SetModelScale(bot:GetModelScale())
						end)
					end
					bot.TargetEnt = table.Random(player.GetHumans())
					print("Creating special bot #"..bot:EntIndex())
					timer.Create("CheckForNoEnemies"..bot:EntIndex(), 15, 0, function()
						if (!IsValid(bot)) then return end
						if (bot.TargetEnt == nil) then -- not doing anything, kick
							for k,v in ipairs(self.bots) do
								if (v:EntIndex() == bot:EntIndex()) then
									table.remove(self.bots,k)
								end
							end
							bot:Remove()
							print("Removed MVM bot #"..bot:EntIndex())
						end
					end)
					coroutine.wait(2)
				else
					print("We have reached the limits! Not spawning MVM bots...")
				end
			elseif (math.random(1,6) == 1) then 
					local cmb = table.Random(combine)
					if (cmb == "npc_manhack") then
						for i=1,math.random(1,5) do

							local bot = ents.Create(cmb)
							if (!IsValid(bot)) then 
								coroutine.wait(0.1)
								return
							end
							bot:SetAngles(self:GetAngles())
							bot:SetOwner(self)
							if (bot:GetClass() == "npc_combine_s") then
								bot:Fire("addoutput","numgrenades 6")
							end
							bot:Spawn()
							bot:SetSquad("overwatch")
							if (bot:GetClass() == "npc_helicopter" or bot:GetClass() == "npc_combinegunship" or bot:GetClass() == "npc_strider") then
								bot:SetPos(self:GetPos() + Vector(0,0,300))
							else
								bot:SetPos(self:GetPos() + Vector(0,0,20))
							end
							local plr = table.Random(player.GetAll())
							bot:SetTarget(plr)
							bot:SetEnemy(plr)
							bot:UpdateEnemyMemory( plr, plr:GetPos() )
							if (bot:GetClass() == "npc_combine_s") then
								bot:Give(table.Random({"weapon_ar2","weapon_smg1","weapon_shotgun"}))
								if (math.random(1,3) == 1) then
									bot:SetModel("models/combine_super_soldier.mdl")
								end
							elseif (bot:GetClass() == "npc_metropolice") then
								bot:Give(table.Random({"weapon_smg1","weapon_pistol","weapon_357","weapon_stunstick"}))
							end
							table.insert(self.bot,bot)
							print("Creating NPC #"..bot:EntIndex())
							timer.Create("CheckForNoEnemies"..bot:EntIndex(), 8, 0, function()
								if (!IsValid(bot)) then return end
								if (bot:GetEnemy() == nil) then -- not doing anything, kick
									for k,v in ipairs(self.bot) do
										if (v:EntIndex() == bot:EntIndex()) then
											table.remove(self.bot,k)
										end
									end
									bot:Remove()
									print("Removed NPC #"..bot:EntIndex())
								end
							end)
							if (bot:GetModel()) then
								self:SetModel(bot:GetModel())
							end
							coroutine.wait(1.5)

						end
					else
						local bot = ents.Create(cmb)
						if (!IsValid(bot)) then 
							coroutine.wait(0.1)
							return
						end
						bot:SetAngles(self:GetAngles())
						bot:SetOwner(self)
						if (bot:GetClass() == "npc_combine_s") then
							bot:Fire("addoutput","numgrenades 6")
						end
						bot:Spawn()
						bot:SetSquad("overwatch")
						if (bot:GetClass() == "npc_helicopter" or bot:GetClass() == "npc_combinegunship" or bot:GetClass() == "npc_strider") then
							bot:SetPos(self:GetPos() + Vector(0,0,300))
						else
							bot:SetPos(self:GetPos() + Vector(0,0,20))
						end
						local plr = table.Random(player.GetAll())
						bot:SetTarget(plr)
						bot:SetEnemy(plr)
						bot:UpdateEnemyMemory( plr, plr:GetPos() )
						if (bot:GetClass() == "npc_combine_s") then
							bot:Give(table.Random({"weapon_ar2","weapon_smg1","weapon_shotgun"}))
							if (math.random(1,3) == 1) then
								bot:SetModel("models/combine_super_soldier.mdl")
							end
						elseif (bot:GetClass() == "npc_metropolice") then
							bot:Give(table.Random({"weapon_smg1","weapon_pistol","weapon_357","weapon_stunstick"}))
						end
						table.insert(self.bot,bot)
						print("Creating NPC #"..bot:EntIndex())
						timer.Create("CheckForNoEnemies"..bot:EntIndex(), 8, 0, function()
							if (!IsValid(bot)) then return end
							if (bot:GetEnemy() == nil) then -- not doing anything, kick
								for k,v in ipairs(self.bot) do
									if (v:EntIndex() == bot:EntIndex()) then
										table.remove(self.bot,k)
									end
								end
								bot:Remove()
								print("Removed NPC #"..bot:EntIndex())
							end
						end)
						if (bot:GetModel()) then
							self:SetModel(bot:GetModel())
						end
						coroutine.wait(0.8)
					end
			else
				coroutine.yield()
			end
	end
end