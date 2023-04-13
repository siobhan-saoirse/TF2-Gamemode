if (!IsMounted("left4dead2")) then return end
if SERVER then AddCSLuaFile() end

local dinfected = CreateConVar( "director_no_mobs", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE} )
ENT.Base = "base_nextbot"
ENT.Type = "nextbot"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.HordeMode = false
ENT.PrintName		= "AI Director"
ENT.Category		= "Left 4 Dead 2 Bots"
ENT.MaxCommon = 30
ENT.Slayer = false
ENT.Music1 = nil
ENT.Music2 = nil
ENT.Music3 = nil
ENT.MusicID = 0
local function lookForNextPlayer(ply)
	local npcs = {}
	for k,v in ipairs(ents.FindInSphere( ply:GetPos(), 10000 )) do
		if (v:IsTFPlayer() and !v:IsNextBot() and v:EntIndex() != ply:EntIndex()) then
			if (v:Health() > 1) then
				table.insert(npcs, v)
			end
		end
	end
	return npcs
end

ENT.MusicTable = {
	"Event.Zombat_1",
	"Event.Zombat_2",
	"Event.Zombat_3",
	"Event.Zombat_4",
	"Event.Zombat_5",
	"Event.Zombat_6",
	"Event.Zombat_7",
	"Event.Zombat_8",
	"Event.Zombat_9",
	"Event.Zombat_10",
	"Event.Zombat_11",
	"Event.Zombat_A_1",
	"Event.Zombat_A_2",
	"Event.Zombat_A_3",
	"Event.Zombat_A_4",
	"Event.Zombat_A_5",
	"Event.Zombat_A_6",
	"Event.Zombat_A_7",
	"Event.Zombat_A_8",
	"Event.Zombat_A_9",
	"Event.Zombat_A_10",
	"Event.Zombat_A_11",
	"Event.Zombat_B_1",
	"Event.Zombat_B_2",
	"Event.Zombat_B_3",
	"Event.Zombat_B_4",
	"Event.Zombat_B_5",
	"Event.Zombat_B_6",
	"Event.Zombat_B_7",
	"Event.Zombat_B_8",
	"Event.Zombat_B_9",
	"Event.Zombat_B_10",
	"Event.Zombat_B_11",
}

ENT.MusicTable2 = {
	"Event.Zombat3_A_Mall",
	"Event.Zombat3_B_Mall"
}
list.Set( "NPC", "ai_director", {
	Name = ENT.PrintName,
	Class = "l4d2_ai_director",
	Category = ENT.Category,
	AdminOnly = true,
} )

function ENT:Initialize()
	if CLIENT then return end	
	self:ResetSequence(self:SelectWeightedSequence(ACT_IDLE))
	self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
	self:SetSolid(SOLID_NONE)
	self:SetModelScale(1)
	self:SetFOV(90)
	self:ResetSequence(self:SelectWeightedSequence(ACT_IDLE))
	self.bots = {}
	self.infected = {}
	self.horde = {}
	self.MusicID = self.MusicID + 1
	
	local sound
	local filter
	if SERVER then
		filter = RecipientFilter()
		filter:AddAllPlayers()
		-- The sound is always re-created serverside because of the RecipientFilter.
		self.Music1 = CreateSound( game.GetWorld(), self.MusicTable[self.MusicID], filter ) -- create the new sound, parented to the worldspawn (which always exists)
		self.Music1:Play()
		if self.Music1 then
			self.Music1:SetSoundLevel( 0 ) -- play everywhere
		end
		self.Music2 = CreateSound( game.GetWorld(), table.Random(self.MusicTable2), filter ) -- create the new sound, parented to the worldspawn (which always exists)
		self.Music2:Play()
		if self.Music2 then
			self.Music2:SetSoundLevel( 0 ) -- play everywhere
		end
		self.Music3 = CreateSound( game.GetWorld(), "Event.Zombat2_Intro_BigEasy", filter ) -- create the new sound, parented to the worldspawn (which always exists)
		self.Music3:Play()
		if self.Music3 then
			self.Music3:SetSoundLevel( 0 ) -- play everywhere
		end
	end
	self:EmitSound(table.Random(
		{
			"Event.DangerAtmosphere_Survival",
		}
	),0,100,0.1)
	timer.Create("TheZombieChoir",15,0,function()
		
		self:EmitSound("Event.ZombieChoir",0,100,0.1)

	end)
	timer.Create("TheGerms",80,0,function()
		
		self:EmitSound(table.Random(
			{
				"music/contagion/quarantine_01.wav",
				"music/contagion/quarantine_02.wav",
				"music/contagion/quarantine_03.wav",
				"Event.DangerAtmosphere_Survival",
			}
		),0,100,0.1)

	end)
	timer.Create("TheGlimpse",35,0,function()
		
		self:EmitSound(table.Random(
			{
				"Event.LargeAreaRevealed"
			}
		),0,100,0.1)

	end)
	timer.Create("Horde",120,0,function()
		if (self.HordeMode == false) then
			if (table.Count(self.infected) < self.MaxCommon) then
				for k,v in ipairs(player.GetAll()) do
					v:SendLua("LocalPlayer():EmitSound(\""..table.Random(
						{
							"Event.MobSignal1_Survival",
							"Event.MobSignal2_Survival",
						}
					).."\")")
				end
			end
			timer.Simple(5, function()
			
				self:EmitSound("music/zombat/gatesofhell.wav",0,100)
				if (table.Count(self.infected) < self.MaxCommon) then
					self.HordeMode = !self.HordeMode

					if (self.MusicID > table.Count(self.MusicTable) - 1) then
						self.MusicID = 0 + 1
					else
						self.MusicID = self.MusicID + 1
					end
					self.Music1:Stop()
					self.Music1 = CreateSound( game.GetWorld(), self.MusicTable[self.MusicID], filter ) -- create the new sound, parented to the worldspawn (which always exists)
					self.Music1:PlayEx(0.5,100)
					self.Music2:Stop()
					self.Music2 = CreateSound( game.GetWorld(), table.Random(self.MusicTable2), filter ) -- create the new sound, parented to the worldspawn (which always exists)
					self.Music2:PlayEx(0.3,100)
					timer.Create("HordeMusic2", 14, 0, function()
						if (self.HordeMode) then
							self.Slayer = !self.Slayer
							if (self.Slayer) then
								self.Music3:Stop()
								self.Music3:PlayEx(0.5,100)
							else
								self.Music3:Stop()
							end
						end
					end)
					timer.Create("HordeMusic", 5.5, 0, function()
						if (self.HordeMode) then
							if (self.MusicID > table.Count(self.MusicTable) - 1) then
								self.MusicID = 0 + 1
							else
								self.MusicID = self.MusicID + 1
							end
							self.Music1:Stop()
							self.Music1 = CreateSound( game.GetWorld(), self.MusicTable[self.MusicID], filter ) -- create the new sound, parented to the worldspawn (which always exists)
							self.Music1:PlayEx(0.5,100)
							self.Music2:Stop()
							self.Music2 = CreateSound( game.GetWorld(), table.Random(self.MusicTable2), filter ) -- create the new sound, parented to the worldspawn (which always exists)
							self.Music2:PlayEx(0.3,100)
						end
					end) 
				end 
			end)
			if (table.Count(self.infected) < self.MaxCommon) then
				local plr = table.Random(lookForNextPlayer(self))
				local thevictim = ents.Create("infected")
				thevictim:SetAngles(Angle(0,math.random(0,360),0))
				thevictim:SetOwner(self)
				thevictim:Spawn()
				thevictim:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				local pos = thevictim:FindSpot("random", {pos=plr:GetPos(),radius = math.random(200,8000),type="hiding",stepup=800,stepdown=800})
				if (pos != nil) then
					thevictim:SetPos(pos)
				end
				--bot:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				table.insert(self.infected,thevictim)
				table.insert(self.horde,thevictim)
				print("Creating horde infected #"..thevictim:EntIndex())
				timer.Simple(0.025, function()
					thevictim.SearchRadius = 10000
					thevictim.LoseTargetDist = 20000
				end)
				for i=1,24 do

					local bot = ents.Create("infected")
					bot:SetAngles(Angle(0,math.random(0,360),0))
					bot:SetPos(thevictim:GetPos())
					bot:SetOwner(self)
					bot:Spawn()
					bot:SetPos(thevictim:GetPos() + self:GetForward()*(math.random(150,300)) + self:GetRight()*(math.random(150,300)))
					bot:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
					--bot:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
					table.insert(self.infected,bot)
					table.insert(self.horde,bot)
					print("Creating horde infected #"..bot:EntIndex())
					timer.Simple(0.025, function()
						bot.SearchRadius = 10000
						bot.LoseTargetDist = 20000
					end)
				end
			end
		elseif (!self.Horde or table.Count(self.horde) == 0) then
			if (table.Count(self.horde) == 0) then
				self.HordeMode = false
			end
		end
	end)
end
function ENT:Think()
	self:SetNoDraw(!GetConVar("developer"):GetBool())
	if (self.MusicID > table.Count(self.MusicTable) - 1) then
		self.MusicID = 0 + 1
	end
	if SERVER then
		if (table.Count(self.infected) > 19) then
	
			if (!self.HordeMode) then
				for k,v in ipairs(self.infected) do
					if (v:GetEnemy() != nil) then
						for k,v in ipairs(player.GetAll()) do
							v:SendLua("LocalPlayer():StopSound(\"event.zombat_intro_"..math.random(1,11).."\")")
							v:SendLua("LocalPlayer():EmitSound(\"event.zombat_intro_"..math.random(1,11).."\")")
						end
					
						self.HordeMode = true
	
						if (self.MusicID > table.Count(self.MusicTable) - 1) then
							self.MusicID = 0 + 1
						else
							self.MusicID = self.MusicID + 1
						end
						if (!self.StopPlayingSounds) then
							self.Music1:Stop()
							self.Music1 = CreateSound( game.GetWorld(), self.MusicTable[self.MusicID], filter ) -- create the new sound, parented to the worldspawn (which always exists)
							self.Music1:PlayEx(0.5,100)
							self.Music2:Stop()
							self.Music2 = CreateSound( game.GetWorld(), table.Random(self.MusicTable2), filter ) -- create the new sound, parented to the worldspawn (which always exists)
							self.Music2:PlayEx(0.3,100)
						end
						timer.Create("HordeMusic2", 14, 0, function()
							if (self.HordeMode) then
								self.Slayer = !self.Slayer
								if (self.Slayer) then
									self.Music3:Stop()
									self.Music3:PlayEx(0.5,100)
								else
									self.Music3:Stop()
								end
							end
						end)
						timer.Create("HordeMusic", 5.5, 0, function()
							if (self.HordeMode) then
								if (self.MusicID > table.Count(self.MusicTable) - 1) then
									self.MusicID = 0 + 1
								else
									self.MusicID = self.MusicID + 1
								end
								self.Music1:Stop()
								self.Music1 = CreateSound( game.GetWorld(), self.MusicTable[self.MusicID], filter ) -- create the new sound, parented to the worldspawn (which always exists)
								self.Music1:PlayEx(0.5,100)
								self.Music2:Stop()
								self.Music2 = CreateSound( game.GetWorld(), table.Random(self.MusicTable2), filter ) -- create the new sound, parented to the worldspawn (which always exists)
								self.Music2:PlayEx(0.3,100)
							end
						end) 
					end
				end
			end
	
		else
	
			self.HordeMode = false
	
		end
		if (table.Count(self.infected) < 19) then 
			self.HordeMode = false
			self.StopPlayingSounds = true
			if (self.StopPlayingSounds) then
				self.Music1:FadeOut(0.5)
				self.Music2:FadeOut(0.5)
				self.Music3:FadeOut(0.5)
				self.StopPlayingSounds = false
			end
		end
		for k,v in ipairs(self.horde) do
			if (!IsValid(v) or v:Health() < 1) then
				table.remove(self.horde,k)
			end
		end
	end
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
		teamv = TEAM_BLU
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
	"boomer",
	"boomer",
	"boomer",
	"boomer",
	"boomer",
	"boomer",
	"hunter",
	"smoker",
	"smoker",
	"smoker",
	"charger",
	"charger",
	"jockey",
	"jockey",
	"jockey",
	"jockey",
	"spitter",
	"spitter",
	"spitter",
	"spitter",
	"boomer",
	"spitter",
	"hunter",
	"smoker",
	"boomer",
	"hunter",
	"hunter",
	"hunter",
	"tank"
}

local zombie2 = {
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected",
	"infected"
}
function ENT:OnRemove()
	for k,v in ipairs(self.bots) do
		if (v != nil) then
			v:Kick()
			print("Removed special infected #"..v:EntIndex())
		end
	end
	for k,v in ipairs(self.infected) do
		if (IsValid(v)) then
			v:Remove()
			print("Removed infected #"..v:EntIndex())
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
		for k,v in ipairs(self.infected) do
			if (!IsValid(v)) then
				table.remove(self.infected,k)
			end
		end
		self.loco:SetAcceleration( 1400 )
		self.loco:SetDesiredSpeed( 1400 )		-- Walk speed
		rnd = 80
		if (!dinfected:GetBool()) then
			rnd = 120
		end
			if (math.random(1,rnd) == 1) then 
				if (table.Count(self.bots) < 4) then 
					--[[
					local bot = LeadBot_S_Add_Zombie(1,table.Random(zombies),self:GetPos())
					table.insert(self.bots,bot)
					bot:SetOwner(self)
					bot.TargetEnt = table.Random(player.GetAll())
					print("Creating special infected #"..bot:EntIndex())
					timer.Create("CheckForNoEnemies"..bot:EntIndex(), 15, 0, function()
						if (!IsValid(bot)) then return end
						if (bot.TargetEnt == nil) then -- not doing anything, kick
							for k,v in ipairs(self.bots) do
								if (v:EntIndex() == bot:EntIndex()) then
									table.remove(self.bots,k)
								end
							end
							bot:Kick()
							print("Removed special infected #"..bot:EntIndex())
						end
					end)]]
					
					local bot = ents.Create(table.Random(zombies))
					bot:SetOwner(self)
					bot:SetPos(self:GetPos())
					bot:Spawn()
					bot:Activate()
					local ply = bot.Bot
					
					local plr = table.Random(lookForNextPlayer(self))

					ply.TargetEnt = plr
						if (IsValid(ply.ControllerBot)) then
							local pos
							if (plr != nil) then
								pos = ply.ControllerBot:FindSpot("random", {pos=plr:GetPos(),radius = math.random(200,8000),type="hiding",stepup=800,stepdown=800})
							else
								pos = ply.ControllerBot:FindSpot("random", {pos=self:GetPos(),radius = math.random(200,8000),type="hiding",stepup=800,stepdown=800})
							end
							if (pos != nil) then
								ply:SetPos(pos)
							else
								if (plr != nil) then
									pos = ply.ControllerBot:FindSpot("random", {pos=plr:GetPos(),radius = math.random(200,8000),type="hiding",stepup=800,stepdown=800})
								else
									pos = ply.ControllerBot:FindSpot("random", {pos=self:GetPos(),radius = math.random(200,8000),type="hiding",stepup=800,stepdown=800})
								end
								if (pos != nil) then
									ply:SetPos(pos)
								end
							end
						end

					table.insert(self.bots,bot)
					debugoverlay.Box( ply:GetPos(), ply:OBBMins(), ply:OBBMaxs(), 3, Color( 255, 0, 0 ) )
					debugoverlay.Text( ply:GetPos(), "Creating special infected #"..bot:EntIndex(), 3,false )
					timer.Create("CheckForNoEnemies"..bot:EntIndex(), 10, 0, function()
						if (!IsValid(ply)) then return end
						if (!IsValid(ply.TargetEnt)) then -- not doing anything, kick
							for k,v in ipairs(self.bots) do
								if (v:EntIndex() == bot.Bot:EntIndex()) then
									table.remove(self.bots,k)
								end
							end
							bot:Remove()
							debugoverlay.Text( bot:GetPos(), "Removing special infected #"..bot:EntIndex(), 3, false )
						end
					end)
					coroutine.wait(0.5)
				else
					print("We have reached the limits! Not spawning special infected.")
				end
			elseif (table.Count(self.infected) < self.MaxCommon and !dinfected:GetBool()) then 
				local rnd2 = 16
				if (math.random(1,rnd2) == 1) then
					for i=0,math.random(1,3) do
						local bot = ents.Create(table.Random(zombie2))
						bot:SetAngles(Angle(0,math.random(0,360),0))
						bot:SetPos(self:GetPos())
						bot:SetOwner(self)
						bot:Spawn()
						local plr = table.Random(lookForNextPlayer(self))
						local pos
						if (bot:GetClass() == "infected") then
							if (plr != nil) then
								pos = bot:FindSpot("random", {pos=plr:GetPos(),radius = math.random(200,8000),type="hiding",stepup=800,stepdown=800})
							else
								pos = bot:FindSpot("random", {pos=self:GetPos(),radius = math.random(200,8000),type="hiding",stepup=800,stepdown=800})
							end
							if (pos != nil) then
								bot:SetPos(pos)
							else
								if (plr != nil) then
									pos = bot:FindSpot("random", {pos=plr:GetPos(),radius = math.random(200,8000),type="hiding",stepup=800,stepdown=800})
								else
									pos = bot:FindSpot("random", {pos=self:GetPos(),radius = math.random(200,8000),type="hiding",stepup=800,stepdown=800})
								end
								if (pos != nil) then
									bot:SetPos(pos)
								end
							end
						else
							self:SetModel(bot:GetModel())
							if (plr != nil) then
								pos = self:FindSpot("random", {pos=plr:GetPos(),radius = math.random(200,8000),type="hiding",stepup=800,stepdown=800})
							else
								pos = self:FindSpot("random", {pos=self:GetPos(),radius = math.random(200,8000),type="hiding",stepup=800,stepdown=800})
							end
							if (pos != nil) then
								bot:SetPos(pos)
							else
								if (plr != nil) then
									pos = self:FindSpot("random", {pos=plr:GetPos(),radius = math.random(200,8000),type="hiding",stepup=800,stepdown=800})
								else
									pos = self:FindSpot("random", {pos=self:GetPos(),radius = math.random(200,8000),type="hiding",stepup=800,stepdown=800})
								end
								if (pos != nil) then
									bot:SetPos(pos)
								end
							end
						end
						--bot:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
						table.insert(self.infected,bot) 
						debugoverlay.Box( bot:GetPos(), bot:OBBMins(), bot:OBBMaxs(), 3, Color( 255, 0, 0 ) )
						debugoverlay.Text( bot:GetPos(), "Creating infected #"..bot:EntIndex(), 3,false )
						timer.Create("CheckForNoEnemies"..bot:EntIndex(), 10, 0, function()
							if (!IsValid(bot)) then return end
							if (bot:GetEnemy() == nil and bot:Health() > 0 and !IsValid(bot.Door)) then -- not doing anything, kick
								for k,v in ipairs(self.infected) do
									if (v:EntIndex() == bot:EntIndex()) then
										table.remove(self.infected,k)
									end
								end
								bot:Remove()
								debugoverlay.Text( bot:GetPos(), "Removing infected #"..bot:EntIndex(), 3, false )
							end
						end)
					end
					coroutine.wait(0.5)
				end
			end
			coroutine.yield()
	end
end