if SERVER then AddCSLuaFile() end
ENT.Base = "base_nextbot"
ENT.Type = "nextbot"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.PrintName		= "Raid"
ENT.Category		= "Civillian 2 Misc"

list.Set( "NPC", "mvm_mob_director", {
	Name = ENT.PrintName,
	Class = "mvm_mob_director",
	Category = ENT.Category,
	AdminOnly = true,
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

	--MsgN("[LeadBot] Bot " .. name .. " with strategy " .. bot.BotStrategy .. " added!")
	return bot
end

local combine = {
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
	"npc_cscanner",
	"npc_cscanner",
	"npc_cscanner",
	"npc_cscanner",
	"npc_cscanner",
	"npc_cscanner",
	"npc_cscanner",
	"npc_cscanner",
	"npc_rollermine",
	"npc_rollermine",
	"npc_rollermine",
	"npc_rollermine",
	"npc_rollermine",
	"npc_rollermine",
	"env_headcrabcanister",
	"env_headcrabcanister",
	"env_headcrabcanister",
	"env_headcrabcanister",
	"env_headcrabcanister",
	"env_headcrabcanister",
	"env_headcrabcanister",
	"env_headcrabcanister"
}
function ENT:OnRemove()
	for k,v in ipairs(self.bots) do
		v:Remove()
		--print("Removed special bot #"..v:EntIndex())
	end
	for k,v in ipairs(self.bot) do
		if (IsValid(v)) then
			v:Remove()
			--print("Removed bot #"..v:EntIndex())
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
		local ply = table.Random(player.GetAll())
		local pos = self:FindSpot("random", {type = "hiding", radius = math.random(400,20000), pos = ply:GetPos()})
		if (pos) then
			self:SetPos(pos)	
		end
			if (math.random(1,20) == 1) then 
					local cmb = table.Random(combine)
					if (cmb == "npc_manhack") then
						for i=1,math.random(1,3) do

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
							headcrab = math.random(0,2)
							count = 6
							speed = 3000
							time = 5
							height = 0
							damage = 150
							radius = 300
							duration = 30
							spawnflags = 0
								local plr = table.Random(player.GetAll())
							if (bot:GetClass() == "env_headcrabcanister") then
								bot:SetKeyValue( "HeadcrabType", headcrab )
								bot:SetKeyValue( "HeadcrabCount", count )
								bot:SetKeyValue( "FlightSpeed", speed )
								bot:SetKeyValue( "FlightTime", time )
								bot:SetKeyValue( "StartingHeight", height )
								bot:SetKeyValue( "Damage", damage )
								bot:SetKeyValue( "DamageRadius", radius )
								bot:SetKeyValue( "SmokeLifetime", duration )
								bot:SetKeyValue( "spawnflags", spawnflags )
								bot:Fire( "FireCanister" )
								bot:SetAngles(Angle(math.sin( CurTime() ) * 16 - 55,plr:GetAngles().y,0))
								bot:SetPos(plr:GetPos() + Vector(math.random(-300,300),math.random(-300,300),0))
							end
							
							bot:Spawn()
							if (bot:IsNPC()) then
								bot:SetSquad("overwatch")
								if (bot:GetClass() == "npc_helicopter" or bot:GetClass() == "npc_combinegunship" or bot:GetClass() == "npc_strider") then
									bot:SetPos(self:GetPos() + Vector(0,0,300))
								else
									bot:SetPos(self:GetPos() + Vector(0,0,20))
								end
								bot:SetTarget(plr)
								bot:SetEnemy(plr)
								bot:UpdateEnemyMemory( plr, plr:GetPos() )
								if (bot:GetClass() == "npc_combine_s") then
									bot:Give(table.Random({"weapon_ar2","weapon_smg1","weapon_shotgun"}))
									if (math.random(1,3) == 1) then
										bot:SetModel("models/combine_super_soldier.mdl")
									end
								elseif (bot:GetClass() == "npc_metropolice") then
									bot:Give(table.Random({"weapon_smg1","weapon_pistol","weapon_shotgun","weapon_ar2","weapon_stunstick"}))
								end
								table.insert(self.bot,bot)
								--print("Creating NPC #"..bot:EntIndex())
								timer.Create("CheckForNoEnemies"..bot:EntIndex(), 8, 0, function()
									if (!IsValid(bot)) then return end
									if (bot:GetEnemy() == nil) then -- not doing anything, kick
										for k,v in ipairs(self.bot) do
											if (v:EntIndex() == bot:EntIndex()) then
												table.remove(self.bot,k)
											end
										end
										bot:Remove()
										--print("Removed NPC #"..bot:EntIndex())
									end
								end)
							end
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
								bot:Fire("addoutput","numgrenades "..math.random(0,6))
							elseif (bot:GetClass() == "npc_metropolice") then
								bot:Fire("addoutput","manhacks "..math.random(0,3))
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
								bot:Give(table.Random({"weapon_smg1","weapon_pistol","weapon_stunstick"}))
							end
							table.insert(self.bot,bot)
							--print("Creating NPC #"..bot:EntIndex())
							timer.Create("CheckForNoEnemies"..bot:EntIndex(), 8, 0, function()
								if (!IsValid(bot)) then return end
								if (bot:GetEnemy() == nil) then -- not doing anything, kick
									for k,v in ipairs(self.bot) do
										if (v:EntIndex() == bot:EntIndex()) then
											table.remove(self.bot,k)
										end
									end
									bot:Remove()
									--print("Removed NPC #"..bot:EntIndex())
								end
							end)
							if (bot:GetModel()) then
								self:SetModel(bot:GetModel())
							end
							coroutine.wait(1.5)
					end
			else
				coroutine.yield()
			end
	end
end