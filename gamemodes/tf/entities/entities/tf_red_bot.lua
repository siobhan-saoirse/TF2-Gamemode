if SERVER then AddCSLuaFile() end

ENT.Base = "base_nextbot"
ENT.Type = "nextbot"
ENT.PZClass = "scout" 
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = false
ENT.Team = "RED"
ENT.PrintName		= "Red Scout"
ENT.Category		= "TFBots"

local function LeadBot_S_Add_Zombie(team,class,pos,ent)
	if !navmesh.IsLoaded() then
		ErrorNoHalt("There is no navmesh! Generate one using \"nav_generate\"!\n")
		return
	end

	local name = string.upper(string.sub(class,1,1))..string.sub(class,2)
	local bot = player.CreateNextBot(ent.PrintName)
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
			
			if (bot:GetPlayerClass() == "gmodplayer") then
					local primaryweps = { 
						"weapon_ak47_cstrike",
						"weapon_aug_cstrike",
						"weapon_famas_cstrike",
						"weapon_galil_cstrike",
						"weapon_m3_cstrike",
						"weapon_mp5_cstrike",
						"weapon_p90_cstrike",
						"weapon_m4a1_cstrike",
						"weapon_sg552_cstrike",
						"weapon_tmp_cstrike",
						"weapon_xm1014_cstrike",
						"weapon_ar2_scripted",
						"weapon_shotgun_scripted",
						"weapon_smg1_scripted",
						"",
						"",
						"",
					}
					local secondaryweps = {
						"weapon_deagle_cstrike",
						"weapon_elite_cstrike",
						"weapon_fiveseven_cstrike",
						"weapon_glock_cstrike",
						"weapon_p228_cstrike",
						"weapon_usp_cstrike",
						"weapon_pistol_scripted",
						"weapon_357_scripted"
					}
					timer.Simple(0.3, function()
					
						bot:SetModel(table.Random(player_manager.AllValidModels()))
						
						bot:StripWeapons()
						bot:Give(table.Random(primaryweps))
						bot:Give(table.Random(secondaryweps))
						bot:Give("weapon_knife_cstrike")
						bot:SetArmor(math.random(15,250))
					end)
			end
		end
	end)
	--MsgN("[LeadBot] Bot " .. name .. " with strategy " .. bot.BotStrategy .. " added!")
	return bot
end

list.Set( "NPC", "tf_red_bot", {
	Name = ENT.PrintName,
	Class = "tf_red_bot",
	Category = ENT.Category,
	AdminOnly = true
} )


function ENT:Initialize()
	if CLIENT then return end	
	self:SetModel("models/player/scout.mdl")
	self:ResetSequence(self:SelectWeightedSequence(ACT_MP_STAND_MELEE))
	self:SetSolid(SOLID_NONE)
	self:SetModelScale(1) 
	self:SetFOV(90)
	self.bots = {}
	self.infected = {}
	local team = 0
	if (self.Team == "BLU") then
		team = 1
	end
	
	if (self.PZClass == "civilian_" && !file.Exists("models/player/civilian.mdl","WORKSHOP")) then 
		self:Remove()
	end
    local npc = LeadBot_S_Add_Zombie(team,self.PZClass,self:GetPos(),self)
    if (!IsValid(npc)) then 
        ErrorNoHalt("The bot could not spawn because you are in singleplayer!") 
        return 
    end
	self:SetNoDraw(true)
    self:SetModel(npc:GetModel())
	self:ResetSequence(self:SelectWeightedSequence(ACT_MP_STAND_MELEE))
	timer.Simple(0.3, function()
		
		if (self.Team == "BLU") then
	
			npc:SetSkin(1)
				
		end
		--RandomWeapon2(npc, "primary")
		--RandomWeapon2(npc, "secondary")
		--RandomWeapon2(npc, "melee")
		--RandomCosmetic(npc, "head")
		--RandomCosmetic(npc, "misc")
		--RandomCosmetic(npc, "hat")			
		local class = npc:GetPlayerClass()
		if (class != "scout" and 
			class != "soldier" and 
			class != "pyro" and 
			class != "demoman" and 
			class != "heavy" and 
			class != "engineer" and 
			class != "medic" and 
			class != "sniper" and 
			class != "spy" and 
			class != "gmodplayer") 
		then
			
			local class = npc.playerclass
			if (string.find(class,"demoman")) then
				class = "demo"
			elseif (string.find(class,"Demoman")) then
				class = "demo"
			elseif (string.find(class,"demoknight")) then
				class = "demo"
			end
		else
			
			local class = npc:GetPlayerClass()
			if (string.find(class,"demoman")) then
				class = "demo"
			elseif (string.find(class,"Demoman")) then
				class = "demo"
			elseif (string.find(class,"demoknight")) then
				class = "demo"
			end
			
		end

	end)
	self.Bot = npc
end

function ENT:Think()
	if (!IsValid(self.Bot) and SERVER) then
		self:Remove() 
	end
	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	if SERVER then
		self.Bot:Kick()
	end
end


function RandomWeapon2(ply, wepslot)
	local weps = tf_items.ItemsByID
	local class = ply:GetPlayerClass()
	local validweapons = {}
	for k, v in pairs(weps) do
		if v and istable(v) and isstring(wepslot) and v["name"] and v["item_slot"] == wepslot and !string.find(v["name"], "Jumper") and v["prefab"] and v["prefab"] != "weapon_melee_allclass" and v["used_by_classes"] and v["used_by_classes"][class] and v["craft_class"] == "weapon" then
			table.insert(validweapons, v["name"])
		end
	end

	local wep = table.Random(validweapons)
	ply:EquipInLoadout(wep)
end

function RandomCosmetic(ply, wepslot)
	local weps = tf_items.ReturnItems()
	local class = ply:GetPlayerClass()
	local validweapons = {}
	for k, v in pairs(weps) do
		if v and istable(v) and isstring(wepslot) and v["name"] and v["item_slot"] == wepslot and v["used_by_classes"] and v["used_by_classes"][class] and v["prefab"] != "tournament_medal" and !string.find(v["item_name"], "Taunt") and v["equip_region"] != "medal" and (v["item_class"] == "tf_wearable" || !IsValid(v["item_class"]) ) then
			table.insert(validweapons, v["name"])
		end
	end

	local wep = table.Random(validweapons)
	ply:EquipInLoadout(wep)
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