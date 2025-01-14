if SERVER then AddCSLuaFile() end
ENT.Base = "base_anim"
ENT.Type = "anim"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.AutomaticFrameAdvance = true
ENT.PrintName		= "BLU Spawner"
ENT.Category		= "TFBots"
ENT.Team = TEAM_BLU

list.Set( "NPC", "tf_blue_team_spawner", {
	Name = ENT.PrintName,
	Class = "tf_blue_team_spawner",
	Category = ENT.Category,
	AdminOnly = true,
	AdminOnly = true
} )
function ENT:Initialize()
	if CLIENT then return end	
	self:SetModel("models/editor/playerstart.mdl")
	self:SetMaterial("models/debug/debugwhite")
	self:SetColor(Color(team.GetColor(self.Team).r,team.GetColor(self.Team).g,team.GetColor(self.Team).b,100))
	self:SetRenderMode(RENDERMODE_TRANSCOLOR)
	self:SetRenderFX(kRenderFxHologram)
	self:SetSolid(SOLID_BBOX)
	self:SetModelScale(1.0)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self.bots = {}
	self.bot = {}
	self.spawnsblu = {}
	self.spawnsred = {}	
	self:SetSkin(self.Team - 1)
	self:SetUseType(SIMPLE_USE)
	if SERVER then
		self:EmitSound("MVM.Robot_Engineer_Spawn")
		for k, v in pairs(ents.FindByClass("info_player_teamspawn")) do
			if v:GetKeyValues()["StartDisabled"] == 0 then
				if v:GetKeyValues()["TeamNum"] == 3 then
					table.insert(self.spawnsblu, v)
				elseif v:GetKeyValues()["TeamNum"] == 2 then
					table.insert(self.spawnsred, v)
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
		end
	end
	timer.Stop("BotSpawner"..self:EntIndex())
end
  
function ENT:Think()
	
	if SERVER then
		for k,v in ipairs(self.bots) do
			if (!IsValid(v)) then
				table.remove(self.bots,k)
			end
		end
	end
	self:NextThink(CurTime())
	return true	
end


function ENT:Use( activator, caller )
	if (!self.WaveStarted) then
		activator:PrintMessage(HUD_PRINTTALK,"Bots will now spawn every 5 seconds")
		timer.Create("BotSpawner"..self:EntIndex(), 4, 0, function()
			if SERVER then 
				local slef = self
				local spawn = self
				if (table.Count(team.GetPlayers(self.Team)) < 8) then
					local bots = {
						"tf_red_bot",
						"tf_red_bot_soldier",
						"tf_red_bot_pyro",
						"tf_red_bot_demo",
						"tf_red_bot_heavyweapons",
						"tf_red_bot_engineer",
						"tf_red_bot_medic",
						"tf_red_bot_sniper",
						"tf_red_bot_spy"
					}
					if (self.Team == TEAM_BLU) then
						bots = {
							"tf_blue_bot",
							"tf_blue_bot_soldier",
							"tf_blue_bot_pyro",
							"tf_blue_bot_demo",
							"tf_blue_bot_heavyweapons",
							"tf_blue_bot_engineer",
							"tf_blue_bot_medic",
							"tf_blue_bot_sniper",
							"tf_blue_bot_spy"
						}
					end
						for i=1,1 do
							local bot = ents.Create(table.Random(bots))
								if (!IsValid(bot)) then
									return
								end
								if (table.Count(self.spawnsblu) > 0 and self.Team == TEAM_BLU) then
									local spawnpoint = table.Random(self.spawnsblu)
									bot:SetPos(spawnpoint:GetPos() + Vector(0,0,45))
								elseif (table.Count(self.spawnsred) > 0 and self.Team == TEAM_RED) then
									local spawnpoint = table.Random(self.spawnsred)
									bot:SetPos(spawnpoint:GetPos() + Vector(0,0,45))
								else
									bot:SetPos(spawn:GetPos() + Vector(0,0,45))
								end
								bot:SetOwner(self)
								bot:Spawn() 
								bot:EmitSound("Building_Teleporter.Receive",70,100)
								bot.Bot.Difficulty = math.random(0,2)
								bot.Bot:Speak("TLK_ROUND_START")
								if (self.Team == TEAM_BLU) then
									ParticleEffect("teleportedin_blue", bot:GetPos(), bot:GetAngles(), self)
								else
									ParticleEffect("teleportedin_red", bot:GetPos(), bot:GetAngles(), self)
								end
								table.insert(self.bots,bot) 
								--print("Creating robot #"..bot:EntIndex())
							end
				else
					--print("We have reached the limits! Not spawning MVM bots...")
				end
			end
		end) 
		self.WaveStarted = true
		self:EmitSound("buttons/lever8.wav")
	else
		activator:PrintMessage(HUD_PRINTTALK,"Bot spawning is now off")
		timer.Stop("BotSpawner"..self:EntIndex())
		self.WaveStarted = false
		self:EmitSound("buttons/lever8.wav")
	end
end