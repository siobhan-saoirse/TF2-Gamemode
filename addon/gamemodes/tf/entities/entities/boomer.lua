if (!IsMounted("left4dead2")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "base_nextbot"
ENT.Type = "nextbot"
ENT.PZClass = "boomer"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.PrintName		= "Boomer"
ENT.Category		= "Left 4 Dead 2 Bots"

list.Set( "NPC", "tf_boomer", {
	Name = ENT.PrintName,
	Class = "boomer",
	Category = ENT.Category,
	AdminOnly = true
} )

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

local function LeadBot_S_Add_Zombie(team,class,pos,ent)
	if !navmesh.IsLoaded() then
		ErrorNoHalt("There is no navmesh! Generate one using \"nav_generate\"!\n")
		return
	end

	local bot = player.CreateNextBot(ent.PrintName)
	local teamv = TEAM_RED
	if team == 1 then
		teamv = TEAM_GREEN
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
            bot:SetNoCollideWithTeammates(true)
			bot:SetPlayerClass(class)
			timer.Simple(0.1, function()
			
				bot:SetModel(bot:GetNWString("L4DModel"))
				
				tf_util.ReadActivitiesFromModel(bot) 
			end)
			bot.TFBot = true
		end
	end)

	MsgN("[LeadBot] Bot " .. ent.PrintName .. " with strategy " .. bot.BotStrategy .. " added!")
	return bot
end

function ENT:Initialize()
	if CLIENT then return end	
	self:SetModel("models/infected/boomer.mdl")
	self:ResetSequence(self:SelectWeightedSequence(ACT_IDLE))
	self:SetSolid(SOLID_NONE)
	self:SetModelScale(1)
	self:SetFOV(90)
	self.bots = {}
	self.infected = {}
    local npc = LeadBot_S_Add_Zombie(1,self.PZClass,self:GetPos(),self)
    if (!IsValid(npc)) then 
        ErrorNoHalt("The bot could not spawn because you are in singleplayer!") 
        return 
    end
	self.Bot = npc
	self:SetNoDraw(true)
    self:SetModel(npc:GetModel())
	self:ResetSequence(self:SelectWeightedSequence(ACT_IDLE))
end

function ENT:OnRemove()
	if SERVER then
		self.Bot:Kick()
	end
end

function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 16

	local ent = ents.Create( ClassName )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()

	return ent

end

function ENT:RunBehaviour()
	while ( true ) do
		coroutine.yield()
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
	return false
end

function ENT:Health()
	return nil
end