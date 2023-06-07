if CLIENT then return end

--[[LEADBOT STANDALONE V1.0_DEV by Lead]]--
--[["For epic developers who don't have friends to play with. 😎"]]--
--[[ONLY MEAN TO BE USED WITHIN Team Fortress 2 Gamemode Dev!!!]]--

local profiles = {}
local bots = {}

--local names = {"LeadKiller", "A Random Person", "Foxie117", "G.A.M.E.R v24", "Agent Agrimar"}
local names = {"A Professional With Standards", "AimBot", "AmNot", "Aperture Science Prototype XR7", "Archimedes!", "BeepBeepBoop", "Big Mean Muther Hubbard", "Black Mesa", "BoomerBile", "Cannon Fodder", "CEDA", "Chell", "Chucklenuts", "Companion Cube", "Crazed Gunman", "CreditToTeam", "CRITRAWKETS", "Crowbar", "CryBaby", "CrySomeMore", "C++", "DeadHead", "Delicious Cake", "Divide by Zero", "Dog", "Force of Nature", "Freakin' Unbelievable", "Gentlemanne of Leisure", "GENTLE MANNE of LEISURE ", "GLaDOS", "Glorified Toaster with Legs", "Grim Bloody Fable", "GutsAndGlory!", "Hat-Wearing MAN", "Headful of Eyeballs", "Herr Doktor", "HI THERE", "Hostage", "Humans Are Weak", "H@XX0RZ", "I LIVE!", "It's Filthy in There!", "IvanTheSpaceBiker", "Kaboom!", "Kill Me", "LOS LOS LOS", "Maggot", "Mann Co.", "Me", "Mega Baboon", "Mentlegen", "Mindless Electrons", "MoreGun", "Nobody", "Nom Nom Nom", "NotMe", "Numnutz", "One-Man Cheeseburger Apocalypse", "Poopy Joe", "Pow!", "RageQuit", "Ribs Grow Back", "Saxton Hale", "Screamin' Eagles", "SMELLY UNFORTUNATE", "SomeDude", "Someone Else", "Soulless", "Still Alive", "TAAAAANK!", "Target Practice", "ThatGuy", "The Administrator", "The Combine", "The Freeman", "The G-Man", "THEM", "Tiny Baby Man", "Totally Not A Bot", "trigger_hurt", "WITCH", "ZAWMBEEZ", "Ze Ubermensch", "Zepheniah Mann", "0xDEADBEEF", "10001011101"}
local classtbl4d = {"tank_l4d","boomer","boomer","boomer","jockey","charger","charger","spitter","spitter","smoker","hunter"}
local classtb = {/*"scout", */"soldier", "pyro", "heavy", "demoman", "sniper", "engineer", "medic", "spy"} -- "scout", "soldier", "pyro", "engineer", "heavy", "demoman", "sniper", "medic", "spy"
local classtbmvm = {"scout","scout","scout","scout","scout","scout","scout","scout","scout","scout","scout","scout","scout","scout","scout","scout","scout","scout","scout","scout","scout","scout","scout","scout","scoutfan","scoutfan","scoutfan","scoutfan","soldier","soldier","soldier","soldier","pyro","pyro","pyro","pyro","pyro","pyro","demoman","demoman","demoman","demoman","demoman","heavy","heavy","heavy","heavy","heavy","spy","spy","spy","sniper","sniper","engineer","engineer","engineer","engineer","engineer","engineer","medic","medic","medic","medic","sentrybuster","sentrybuster","sentrybuster","giantscout","giantpyro","giantheavy","giantsoldier","giantmedic","superscout","superscout","superscoutfan","giantheavyshotgun","giantheavyheater","giantsoldierrapidfire","giantsoldiercharged","soldierbuffed","soldierblackbox","soldierblackbox","soldierblackbox","soldierblackbox","soldierblackbox","soldierblackbox","soldierblackbox","soldierblackbox","soldierblackbox","soldierbuffed","soldierbuffed","demoknight","demoknight","demoknight","demoknight","demoknight","demoknight","demoknight","soldierbuffed","soldierbuffed","soldierbuffed","heavyshotgun","heavyshotgun","heavyshotgun","heavyshotgun","heavyweightchamp","heavyweightchamp","heavyweightchamp","heavyweightchamp","melee_scout","melee_scout_sandman","melee_scout_sandman","melee_scout_sandman","melee_scout_sandman","melee_scout","melee_scout","melee_scout","melee_scout","melee_scout","melee_scout","melee_scout","melee_scout","ubermedic","ubermedic","ubermedic","ubermedic","ubermedic","ubermedic"}
local bot_class = CreateConVar("tf_bot_keep_class_after_death", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})
local bot_diff = CreateConVar("tf_bot_difficulty", "1", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "Sets the difficulty level for the bots. Values are: 0=easy, 1=normal, 2=hard, 3=expert. Default is \"Normal\" (1).")
local bot_respawn = CreateConVar("tf_bot_npc_respawn", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, "Should the NPC bots respawn?")
local tf_bot_notarget = CreateConVar("tf_bot_notarget", "0", {FCVAR_ARCHIVE, FCVAR_NOTIFY})
local tf_bot_melee_only = CreateConVar("tf_bot_melee_only", "0", {FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY})

function lookForNearestPlayer(bot)
	local npcs = {}
	for k,v in ipairs(player.GetBots()) do
		if (v:Alive() and !v:IsFriendly(bot) and v:EntIndex() != bot:EntIndex() and !v:IsFlagSet(FL_NOTARGET)) then
			table.insert(npcs, v)
		end
	end
	return npcs
end

function lookForClosestHumanPlayer(bot)
	local npcs = {} 
	for k,v in ipairs(ents.FindInSphere(bot:GetPos(), 500)) do
		if (v:IsPlayer() and v:Alive() and !v:IsBot() and v:EntIndex() != bot:EntIndex() and !IsValid(bot.TargetEnt)) then
			table.insert(npcs, v)
		end
	end
	return npcs
end

function getNPCsAndPlayers()
	local npcs = {}
	if (math.random(1,8) == 1) then
		for k,v in ipairs(ents.GetAll()) do
			if (v:IsNPC() or v:IsNextBot()) then
				if (v:Health() > 0) then
					table.insert(npcs, v)
				end
			end
		end
	end
	return npcs, player.GetAll()
end

function LBAddProfile(tab) 
	if profiles[tab["name"]] then return end
	table.insert(profiles, tab) 
end
 
function LBAddBot(team)
	--if !profiles[name] then MsgN("That is not a valid bot!") return end
	if !navmesh.IsLoaded() then
		navmesh.BeginGeneration()
		for k, v in pairs(player.GetAll()) do
			v:ChatPrint("GENERATING NAV")
		end
	end
	local diff = GetConVar("tf_bot_difficulty"):GetFloat() -- math.random(3)
--[[local diffn = "Normal"
	if diff == 0 then
		diffn = "Easy"
	if diff == 1 then 
		diffn = "Normal"
	elseif diff == 2 then
		diffn = "Hard"
	elseif diff == 3 then
		diffn = "Expert"
	end]]
	local name = table.Random(names) -- .." (bot) "..diffn --"Bot"..math.random(0, 99)
	local bot = player.CreateNextBot(name)
	local teamd = TEAM_RED
	if team == 1 then
		teamd = TEAM_BLU
	end
	
	bot.ControllerBot = ents.Create("ctf_bot_navigator")
	bot.ControllerBot:Spawn()
	bot.LastPath = nil
	bot.CurSegment = 2
	if (!bot.IsL4DZombie) then
		if string.find(game.GetMap(), "mvm_") then
			bot:SetPlayerClass(table.Random(classtbmvm))
		else
			bot:SetPlayerClass(table.Random(classtb))
		end
	end
	for k, v in pairs(player.GetAll()) do
		v:ChatPrint(tostring(team))
	end
	timer.Simple(3, function()
		if IsValid(bot) then
			bot.TFBot = true
			if string.find(game.GetMap(), "mvm_") then
				
				ply:SetTeam(TF_TEAM_PVE_INVADERS)
				ply:SetSkin(1)
					
			else		
			
				bot:SetTeam(TEAM_BLU)
			end
			bot:Kill()
			bot.Difficulty = diff
			table.insert(bots, bot)
		end
	end)
end

function LBFindClosest(bot)
	local players = player.GetHumans()
	local distance = 9999
	local player = player.GetHumans()[1]
	local distanceplayer = 9999
	for k, v in pairs(players) do
		distanceplayer = v:GetPos():Distance(bot:GetPos())
		if distance > distanceplayer and v ~= bot then
			distance = distanceplayer
			player = v
		end
	end

	--print(player:Nick().." is the closest!")
	bot.FollowPly = player
end

hook.Add("PlayerHurt", "LeadBot_Death", function(ply, bot, hp, dmg)
    if bot.TFBot then
        local controller = bot.ControllerBot
    end
end)

local function LeadBot_S_Add(team)
	if !navmesh.IsLoaded() then
		ErrorNoHalt("There is no navmesh! Generate one using \"nav_generate\"!\n")
		return
	end

	local name = table.Random(names) or "Bot"
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
	bot.BotStrategy = math.random(0, 1)

    --timer.Simple(1, function()
        ----TalkToMe(bot, "join")
    --end)
	bot:SetTeam(teamv)
	if string.find(game.GetMap(), "mvm_") then
		bot:SetPlayerClass(table.Random(classtbmvm))
	else
		bot:SetPlayerClass(table.Random(classtb))
	end

	timer.Simple(1, function()
		if IsValid(bot) then
			bot.TFBot = true
			if string.find(game.GetMap(), "mvm_") then
				
				bot:SetTeam(TF_TEAM_PVE_INVADERS)
				bot:SetSkin(1)
			else
				bot:SetTeam(math.random(TEAM_RED,TEAM_BLU))
				bot:SetSkin(bot:Team()-1)
			end
			bot:Spawn()
		end
	end)

	MsgN("[LeadBot] Bot " .. name .. " with strategy " .. bot.BotStrategy .. " added!")
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
		teamv = TEAM_INFECTED
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
end

local function LeadBot_S_Add_Survivor(team,class,pos)
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
end
local function LeadBot_S_Add_BlueSurvivor(team,class,pos)
	if !navmesh.IsLoaded() then
		ErrorNoHalt("There is no navmesh! Generate one using \"nav_generate\"!\n")
		return
	end

	local name = string.upper(string.sub(class,1,1))..string.sub(class,2)
	local bot = player.CreateNextBot(name)
	local teamv = TEAM_BLU
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
end

hook.Add("PostCleanupMap", "LeadBot_S_PostCleanup", function()
	for k, v in pairs(player.GetBots()) do
		if v.TFBot then
			v.ControllerBot = ents.Create("ctf_bot_navigator")
			v.ControllerBot:Spawn()
			v.ControllerBot:SetOwner(v)
		end
	end
end)

hook.Add("PostPlayerDeath", "LeadBot_S_Death", function(bot)
	if bot.TFBot then
		local time = 6 
		if (GetConVar("civ2_allow_respawn_with_key_press"):GetBool() and !string.find(bot:GetModel(),"/bot_")) then
			time = 2
		end
		timer.Simple(time, function()
			if IsValid(bot) and !bot:Alive() then
				if (bot_respawn:GetBool() and !bot:IsL4D()) then

					if (!string.find(bot:GetModel(),"/bot_")) then
						bot:Spawn()
					else
						bot:Kick("No longer needed")
					end
					 
				else
					if (!string.find(bot:GetModel(),"/bot_")) then
						if (!bot.IsL4DZombie) then
							bot:Spawn()
						else
							bot:Kick("No longer needed")
						end
					else
						if (!bot.IsL4DZombie) then
							bot:Spawn()
						else
							bot:Kick("No longer needed")
						end
					end
				end
			end
		end)
	end
end)

hook.Add("StartCommand", "LeadBot_S_Command", function(bot, cmd)
	if bot.TFBot then
		local botWeapon = bot:GetActiveWeapon()

		--[[if IsValid(botWeapon) and (botWeapon:Clip1() == 0 or !IsValid(bot.TargetEnt) and botWeapon:Clip1() <= botWeapon:GetMaxClip1() / 2) then
			buttons = buttons + IN_RELOAD
		end]]

		--cmd:ClearButtons()
		--cmd:ClearMovement()
	end
end)

function RandomWeapon2(ply, wepslot)
	local weps = tf_items.ReturnItems()
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

hook.Add("PlayerSpawn", "LeadBot_S_PlayerSpawn", function(bot)
	if (IsValid(bot)) then
		if bot.TFBot and bot:GetPlayerClass() == "gmodplayer" then
			local randWeapon = table.Random(bot:GetWeapons())
			if (randWeapon:GetClass() != "weapon_knife_cstrike") then
				bot:SelectWeapon(tostring(randWeapon:GetClass()))
			end
		elseif bot.TFBot then
				local class = table.Random(classtb)
				timer.Simple(1, function()
					--TalkToMe(bot, "join")
				end)
				if !bot_class:GetBool() then
					if (!bot.IsL4DZombie) then
						if string.find(game.GetMap(), "mvm_") then
							bot:SetPlayerClass(table.Random(classtbmvm))
						else
							bot:SetPlayerClass(table.Random(classtb))
						end
					end
				end
				timer.Simple(0.1, function()
					local oldclass = bot:GetPlayerClass()
					
					if (!bot.IsL4DZombie) then
						bot:SetPlayerClass(table.Random(classtb)) -- change to different class unrelated to the regular classes
					end
					timer.Simple(0.2, function()
					
						bot:SetPlayerClass(oldclass)
						if (bot.IsL4DZombie and !string.find(bot:GetModel(),"/bot_")) then
							--RandomWeapon2(bot, "primary")
							--RandomWeapon2(bot, "secondary")
							--RandomWeapon2(bot, "melee")
							--RandomCosmetic(bot, "hat")
							--RandomCosmetic(bot, "misc")
							--RandomCosmetic(bot, "head")
						end

					end)
				end)
				timer.Simple(1, function()
					bot:SetFOV(100, 0) 
				end)
		end
	end
end)

hook.Add("SetupMove", "LeadBot_Control2", function(bot, mv, cmd)

	local buttons = 0
	if bot.TFBot then
	
		cmd:ClearMovement()
		cmd:ClearButtons()

		bot.movingAway = false
	
		local controller = bot.ControllerBot
		
		if (bot.OverrideModelScale) then
			bot:SetModelScale(bot.OverrideModelScale)
		end
		if (!bot:IsOnGround()) then
			buttons = buttons + IN_DUCK
		end
		if !IsValid(controller) then
			bot.ControllerBot = ents.Create("leadbot_navigator")
			bot.ControllerBot:Spawn()
			bot.ControllerBot:SetOwner(bot)
			controller = bot.ControllerBot
		else
			controller:SetPos(bot:GetPos())
			controller:SetAngles(bot:GetAngles())
		end
	
		local moveawayrange = 80
		if (string.find(bot:GetModel(),"/bot_")) then
			moveawayrange = 150
		end
		
		if controller.NextCenter > CurTime() and bot:GetNWBool("Taunting",false) != true and bot.botPos then
			if controller.strafeAngle == 1 then
				mv:SetSideSpeed(1500)
			elseif controller.strafeAngle == 2 then
				mv:SetSideSpeed(-1500)
			else
				mv:SetForwardSpeed(-1500)
			end
		end
			for k,v in ipairs(ents.FindInSphere(bot:GetPos(),moveawayrange)) do
				if (IsValid(v) and GAMEMODE:EntityTeam(v) == bot:Team() and v:IsTFPlayer() and v:EntIndex() != bot:EntIndex() and bot:GetNWBool("Taunting",false) != true) then
					local forward = bot:EyeAngles():Forward()
					local right = bot:EyeAngles():Right()
					local avoidVector = bot:GetPos()
					local between = bot:GetPos() - v:GetPos()
					local between2 = between:GetNormalized()
					avoidVector = avoidVector + ( Vector(1,1,1) - ( between2 / moveawayrange ) ) * between
					local vecDelta = v:WorldSpaceCenter() - bot:GetPos() + Vector(0.5,0.5,0.5) + Vector(0,0,72)
					local vRad = v:WorldSpaceAABB()
					vRad.z = 0
					local flAvoidRadius = vRad:Length()
					local flPushStrength = math.Remap(vecDelta:Length(), flAvoidRadius, 0, 0, 256)
					
					local vecPush
					if (bot:GetVelocity():Length2DSqr() > 0.1) then
						local vecVelocity = bot:GetVelocity()
						vecVelocity.z = 0.0
						local vecUp = Vector( 0, 0, 1 )
						vecPush = vecUp:Cross(vecVelocity)
					else
						local angView = bot:EyeAngles()
						angView.x = 0.0
						vecPush = angView:Right()
					end
					local vecSeparationVelocity = avoidVector * 50
					if (vecDelta:Dot(vecPush) < 0) then
						local vel = vecPush * flPushStrength
						vecSeparationVelocity = vel
					else
						local vel = vecPush * -flPushStrength
						vecSeparationVelocity = vel
					end
					local flMaxPlayerSpeed = bot:GetMaxSpeed()
					local flCropFraction = 1.33333333
					if (bot:Crouching() and bot:IsOnGround()) then
						flMaxPlayerSpeed = flMaxPlayerSpeed * flCropFraction
					end
					local flMaxPlayerSpeedSqr = flMaxPlayerSpeed * flMaxPlayerSpeed

					if ( vecSeparationVelocity:LengthSqr() > flMaxPlayerSpeedSqr ) then
						vecSeparationVelocity:Normalize()
						vecSeparationVelocity = vecSeparationVelocity * flMaxPlayerSpeed
					end
					local vAngles = bot:EyeAngles()
					vAngles.x = 0 
					local currentdir = vAngles:Forward()
					local rightdir = vAngles:Right()
					local vDirection = vecSeparationVelocity:GetNormalized()
					
					local fwd = vDirection:Dot( currentdir )
					local rt = vDirection:Dot( rightdir )

					local forward2 = fwd * flPushStrength
					local side = rt * flPushStrength
					
					avoidVector:Normalize()
					bot.movingAway = true
					bot.pushAwayMove = mv:GetForwardSpeed() + (forward2 * 0.5)
					mv:SetForwardSpeed(mv:GetForwardSpeed() + (forward2 * 0.5))
					mv:SetSideSpeed(mv:GetSideSpeed() + (side * 0.5))
				end
			end
			 --[[
		local BotCanTarget = tf_bot_notarget:GetBool()
 
		if ( bot:IsBot() and !BotCanTarget and !IsValid(bot.TargetEnt) ) then 
			
			if (math.random(1,4) == 1) then
				for k, v in pairs(player.GetBots()) do
					if v:IsPlayer() and v:EntIndex() != bot:EntIndex() and v:GetPos():Distance(bot:GetPos()) < 1200 and !IsValid(bot.TargetEnt) then
						if (!v:IsFriendly(bot)) then -- TODO: find a better way to do this
							local targetpos = v:EyePos() - Vector(0, 0, 10) -- bot eye check, don't start shooting targets just because we barely see their head
							local trace = util.TraceLine({start = bot:GetShootPos(), endpos = targetpos, filter = function( ent ) return ent == v end})

							if (math.random(1,4) == 1) then

								for _,trgt in ipairs(ents.FindInSphere(trace.HitPos, 230)) do
									if (trgt == bot.TargetEnt and !trgt:IsFlagSet(FL_NOTARGET) and !bot:IsL4D()) then
										bot.TargetEnt = trgt
									end
								end

							end
							if (!IsValid(bot.TargetEnt) && bot:IsL4D() and !v:IsFlagSet(FL_NOTARGET) ) then

								if (v:EntIndex() == bot:EntIndex()) then return end
								if (v:EntIndex() == bot.ControllerBot:EntIndex()) then return end
								bot.TargetEnt = v

							end
						end
					end
				end
			end
		end]]
		

		if (math.random(1,4) == 1) then
			for k,v in ipairs(ents.FindInSphere(bot:GetPos(), 1200)) do
				if (v:IsPlayer() and v:IsBot() and v:EntIndex() != bot:EntIndex()) then
					if (v.TFBot and (v:GetPlayerClass() == "medic") and v:IsFriendly(bot)) then
						if (IsValid(v.TargetEnt) and v.TargetEnt:EntIndex() == bot:EntIndex() and bot:IsFriendly(v) and bot:Health() > bot:GetMaxHealth()) then
							if (v.TargetEnt and v.TargetEnt:IsFriendly(bot)) then
								v.TargetEnt = nil
							end
						end
					end
				end
			end
		end

		if bot:Health() < bot:GetMaxHealth() / 3 then
			for k,v in ipairs(ents.FindInSphere(bot:GetPos(), 1200)) do
				if (v:IsPlayer() and v:IsBot() and v:EntIndex() != bot:EntIndex()) then
					if (v.TFBot and (v.playerclass == "Medic") and v:IsFriendly(bot)) then
						if (!IsValid(v.TargetEnt)) then
							if (bot:Health() < bot:GetMaxHealth()) then
								v.TargetEnt = bot
								v:SelectWeapon(v:GetWeapons()[2]:GetClass())
							end
						end
					end
				end
			end
			if math.random(1,500) == 1  and !string.find(bot:GetModel(),"/bot_") then
				local args = {"TLK_PLAYER_MEDIC"}
				if bot:Speak(args[1]) then
					bot:DoAnimationEvent(ACT_MP_GESTURE_VC_HANDMOUTH, true)
			
					umsg.Start("TFPlayerVoice")
						umsg.Entity(bot)
						umsg.String(args[1])
					umsg.End()
				end
			end
		end 


		
		if bot:GetVelocity():Length2DSqr() <= 225 then
			if controller.NextCenter < CurTime() then
				controller.strafeAngle = ((controller.strafeAngle == 1 and 2) or 1)
				controller.NextCenter = CurTime() + math.Rand(0.3, 0.65)
				--[[
			elseif controller.nextStuckJump < CurTime() then
				if !bot:Crouching() then
					controller.NextJump = 0
				end
				controller.nextStuckJump = CurTime() + math.Rand(1, 2)]]
			end
		end
	
		if (IsValid(bot.TargetEnt) and bot.TargetEnt:Health() < 1) then
			bot.TargetEnt = nil
			bot.LastPath = nil
		end
		
	
		-- force a recompute
		if controller.PosGen and controller.P then
			if (IsValid(bot.TargetEnt) and bot:GetPos():Distance(bot.TargetEnt:GetPos()) < 80) then
			
			else
				controller.P:Compute(controller, controller.PosGen)
			end
		end	
			
		if (bot.botPos) then
			bot.ControllerBot.PosGen = bot.botPos
		end

			if IsValid(bot.TargetEnt) and bot:GetPos():Distance(bot.TargetEnt:GetPos()) < 6000 and bot.TargetEnt:Health() > 0 then
				if (bot:GetPlayerClass() != "tank_l4d") then
					if (bot:GetNWBool("Taunting",false) == true) then 
						return 
					end 
				end	
			
				local shouldvegoneforthehead = bot.TargetEnt:EyePos()
				local bone = 1
				shouldvegoneforthehead = bot.TargetEnt:GetBonePosition(bone)
				if (!bot.isCarryingIntel) then
					if (math.random(1,10) == 1) then
						bot.botPos = bot.ControllerBot:FindSpot("near", {pos=bot.TargetEnt:GetPos(),radius = 12000,type="hiding",stepup=800,stepdown=800})
					end
				end

				local lerp = 1.2
				if bot.Difficulty == 0 then
					lerp = 0.9
				elseif bot.Difficulty == 2 then
					lerp = 2
				elseif bot.Difficulty == 3 then
					lerp = 4
				end
				if (bot:IsL4D()) then
					bot:SetEyeAngles(LerpAngle(FrameTime() * 5 * lerp, bot:EyeAngles(), (shouldvegoneforthehead - bot:GetShootPos()):Angle()))
				else
					if (bot:GetPlayerClass() == "soldier" and (bot:GetActiveWeapon().HoldType == "PRIMARY" or bot:GetActiveWeapon().HoldType == "PRIMARY2")) then
						bot:SetEyeAngles(LerpAngle(FrameTime() * math.random(8, 10) * lerp, bot:EyeAngles(), (shouldvegoneforthehead - bot:GetShootPos() - Vector(0,0,25)):Angle()))
					else
						bot:SetEyeAngles(LerpAngle(FrameTime() * math.random(8, 10) * lerp, bot:EyeAngles(), (shouldvegoneforthehead - bot:GetShootPos()):Angle()))
					end
				end
			end
			if IsValid(bot.intelcarrier) and !IsValid(bot.TargetEnt) and bot:GetPos():Distance(bot.intelcarrier:GetPos()) < 6000 and bot.intelcarrier:Health() > 0 then
				if (bot:GetPlayerClass() != "tank_l4d") then
					if (bot:GetNWBool("Taunting",false) == true) then 
						return 
					end 
				end	
			
				local shouldvegoneforthehead = bot.intelcarrier:EyePos()
				local bone = 1
				shouldvegoneforthehead = bot.intelcarrier:GetBonePosition(bone)
				if (!bot.isCarryingIntel) then
					bot.botPos = bot.intelcarrier:GetPos()
				end

				local lerp = 1.2
				if bot.Difficulty == 0 then
					lerp = 0.9
				elseif bot.Difficulty == 2 then
					lerp = 2
				elseif bot.Difficulty == 3 then
					lerp = 4
				end
				if (bot:IsL4D()) then
					bot:SetEyeAngles(LerpAngle(FrameTime() * 5 * lerp, bot:EyeAngles(), (shouldvegoneforthehead - bot:GetShootPos()):Angle()))
				else
					if (bot:GetPlayerClass() == "soldier" and (bot:GetActiveWeapon().HoldType == "PRIMARY" or bot:GetActiveWeapon().HoldType == "PRIMARY2")) then
						bot:SetEyeAngles(LerpAngle(FrameTime() * math.random(8, 10) * lerp, bot:EyeAngles(), (shouldvegoneforthehead - bot:GetShootPos() - Vector(0,0,25)):Angle()))
					else
						bot:SetEyeAngles(LerpAngle(FrameTime() * math.random(8, 10) * lerp, bot:EyeAngles(), (shouldvegoneforthehead - bot:GetShootPos()):Angle()))
					end
				end
			end
		if bot.ControllerBot.P then
			bot.LastPath = bot.ControllerBot.P:GetAllSegments()
		end
	
		if !bot.ControllerBot.P then
			return
		end
		if bot.CurSegment ~= 2 and !table.EqualValues( bot.LastPath, bot.ControllerBot.P:GetAllSegments() ) then
			bot.CurSegment = 2
		end
	
		------------------------------
		--------[[BOT EYES]]---------
		------------------------------

		if !bot.LastPath then return end
		local curgoal = bot.LastPath[bot.CurSegment]
		
		-- got nowhere to go, why keep moving?
		if !curgoal then
			mv:SetForwardSpeed(0)
			return
		end
		
		-- think one step ahead!
		if bot:GetPos():Distance(curgoal.pos) < 50 * bot:GetModelScale() and bot.LastPath[bot.CurSegment + 1] then
			curgoal = bot.LastPath[bot.CurSegment + 1]
		end
		
		local goalpos = curgoal.pos
		local controller = bot.ControllerBot
		local lerpc = FrameTime() * 8
		
		if bot:GetPos():Distance(curgoal.pos) < 50 * bot:GetModelScale() then
			bot.LastSegmented = CurTime()
			if bot.LastPath[bot.CurSegment + 1] then
				curgoal = bot.LastPath[bot.CurSegment + 1] 
			end
		end
		
		if (!bot:GetNWBool("Taunting",false) and bot.botPos) then
			if ((bot.intelcarrier and bot.intelcarrier.movingAway)) then
				mv:SetForwardSpeed(0)
				return
			else
				mv:SetForwardSpeed(1200)
			end
		end
		local mva = ((goalpos + bot:GetCurrentViewOffset()) - bot:GetShootPos()):Angle()
		
		if bot.botPos and curgoal.area:GetAttributes() != NAV_MESH_CLIFF and bot:GetPos():Distance(curgoal.pos) > 50 * bot:GetModelScale() then
			if (IsValid(bot.TargeEntity) and bot.TargeEntity.dt.Charging) then

			else
				mv:SetMoveAngles(mva)
			end
		end
		

	
			if ((!IsValid(bot.TargetEnt) or bot.isCarryingIntel) and curgoal and bot:GetPos():Distance(curgoal.pos) > 50 * bot:GetModelScale()) then
				if (bot:GetPlayerClass() != "tank_l4d") then
					if (bot:GetNWBool("Taunting",false) == true) then
						return
					end
				end	
				local lerp = 1.2
				if bot.Difficulty == 0 then
					lerp = 0.9
				elseif bot.Difficulty == 2 then
					lerp = 2
				elseif bot.Difficulty == 3 then
					lerp = 4
				end
				if (!IsValid(bot.TargetEnt)) then
					if (bot:IsL4D()) then
						bot:SetEyeAngles(LerpAngle(FrameTime() * 8, bot:EyeAngles(), ((curgoal.pos + Vector(0, 0, 65)) - bot:GetShootPos()):Angle()))
					else
						if controller.LookAtTime > CurTime() then
							local ang = LerpAngle(lerpc, bot:EyeAngles(), controller.LookAt)
							bot:SetEyeAngles(Angle(ang.p, ang.y, 0))
						else
							local ang = LerpAngle(lerpc, bot:EyeAngles(), mva)
							bot:SetEyeAngles(Angle(ang.p, ang.y, 0))
						end
					end
				end
			end
	end
end)
hook.Add("SetupMove", "LeadBot_Control", function(bot, mv, cmd)
	local buttons = 0
	if bot.TFBot then
		local controller = bot.ControllerBot
		bot.movement = mv
		if bot:IsPlayer() and !bot:IsBot() then
			bot:PrintMessage(HUD_PRINTCENTER, "You're being controlled by a bot, ask an admin to stop being controlled.")
		end
		if bot.ControllerBot:GetPos() ~= bot:GetPos() then
			bot.ControllerBot:SetPos(bot:GetPos())
		end

		if (IsValid(bot.TargeEntity) and bot.TargeEntity:GetClass() == "tf_wearable_item_demoshield" and bot.TargeEntity.dt.Ready and bot.botPos) then
			bot.TargeEntity:StartCharging()
		end
		
		local intel
		local fintel
		local intelcap
		local fintelcap
		local targetpos2 = Vector(0, 0, 0)

		if string.find(game.GetMap(), "ctf_") then -- CTF AI
			for k, v in pairs(ents.FindByClass("item_teamflag")) do
				if v.TeamNum ~= bot:Team() then
					intel = v
				else
					fintel = v
				end
			end

			for k, v in pairs(ents.FindByClass("func_capturezone")) do
				if v.TeamNum ~= bot:Team() then
					intelcap = v
				else
					fintelcap = v
				end
			end

			if !intel.Carrier then -- neither intel has a capture
				targetpos2 = intel:GetPos() -- goto enemy intel
				ignoreback = true
			elseif intel.Carrier == bot then -- or if friendly intelligence has capture
				targetpos2 = fintelcap.Pos -- goto friendly cap spot
				ignoreback = true
			elseif intel.Carrier and bot:EntIndex() != intel.Carrier:EntIndex() then -- or else if we have it already carried
				
				targetpos2 = intel.Carrier:GetPos() -- follow that man
			elseif fintel.Carrier and bot:EntIndex() != fintel.Carrier:EntIndex() then -- if our intel is being stolen...
				targetpos2 = fintel.Carrier:GetPos() -- defend our intel
			end

			bot.botPos = targetpos2
			
			bot.LastSegmented = CurTime() + math.Rand(0.5, 1)
		--[[
		elseif string.find(game.GetMap(), "cp_") then -- CP AI


			for k, v in pairs(ents.FindByClass("trigger_capture_area")) do
				if GAMEMODE:EntityTeam(v.CapturePoint) ~= bot:Team() then
					intelcap = v.CapturePoint
				else
					fintelcap = v.CapturePoint
				end
			end

			if GAMEMODE:EntityTeam(intelcap) != ent:Team() then -- or if friendly intelligence has capture
				targetpos2 = intelcap.Pos -- goto friendly cap spot
				ignoreback = true
			end

			bot.botPos = targetpos2
		]]
		elseif string.find(game.GetMap(), "mvm_") and (bot:Team() == TEAM_BLU or bot:Team() == TF_TEAM_PVE_INVADERS) and bot:GetPlayerClass() != "engineer" and bot.playerclass != "medic" and bot:GetPlayerClass() != "sentrybuster" then -- CTF AI in MVM Maps
			for k, v in pairs(ents.FindByClass("item_teamflag_mvm")) do
				if v.TeamNum ~= bot:Team() and k == 1 then 
					intel = v
				end
			end

			for k, v in pairs(ents.FindByClass("func_capturezone")) do
				fintelcap = v
			end
			if (IsValid(intel)) then
				bot.isCarryingIntel = true
				if !intel.Carrier then -- neither intel has a capture
					targetpos2 = intel:GetPos() -- goto enemy intel
					bot.intelcarrier = nil
				elseif intel.Carrier and intel.Carrier:EntIndex() == bot:EntIndex() then -- or if friendly intelligence has capture
					targetpos2 = fintelcap.Pos -- goto friendly cap spot
					bot.intelcarrier = nil
				elseif IsValid(intel.Carrier) and bot:EntIndex() != intel.Carrier:EntIndex() then -- or else if we have it already carried

					targetpos2 = intel.Carrier:GetPos() -- follow that man
					bot.intelcarrier = intel.carrier
				else
					targetpos2 = fintelcap.Pos -- move to the bomb, the flag is currently invalid until a bot gets it
					bot.intelcarrier = nil
				end	
			else
				targetpos2 = fintelcap.Pos -- goto friendly cap spot
			end

			bot.botPos = targetpos2
			bot.LastSegmented = CurTime() + math.Rand(0.5, 1)
		else
			-- find a random spot on the map, and in 10 seconds do it again!
			if (!IsValid(bot.TargetEnt) and !bot:IsL4D()) then 
				if (!bot.IsL4DZombie) then
					bot.botPos = bot.ControllerBot:FindSpot("random", {radius = 12500})
				else
					bot.botPos = nil
					if (bot.movingAway) then
						mv:SetForwardSpeed(bot.pushAwayMove * 0.5)
					else
						mv:SetForwardSpeed(0)
					end
				end
			elseif (bot:IsL4D()) then
				local trgt = table.Random(lookForNearestPlayer(bot))
				if (IsValid(trgt) and trgt:Alive() and trgt:EntIndex() != bot:EntIndex()) then
					bot.botPos = trgt:GetPos()
				else
					bot.botPos = nil
					mv:SetForwardSpeed(0)
				end
			end
		end
			
		for _, intel in pairs(ents.FindByClass("item_teamflag_mvm")) do
						
			if IsValid(intel.Carrier) and bot:GetPos():Distance(intel.Carrier:GetPos()) < 180 and bot:EntIndex() != intel.Carrier:EntIndex() then -- dont move if too close!
				bot.tooclose = true
			else
				bot.tooclose = false
			end

		end
		if bot.playerclass == "Medic" or bot:GetPlayerClass() == "giantmedic" then
				--print(intel)
			local targetply = player.GetAll()[1]
			local fintel
			for k, v in pairs(player.GetBots()) do
				
				for _, intel in pairs(ents.FindByClass("item_teamflag_mvm")) do
					fintel = intel
					if (IsValid(intel.Carrier)) then
						if intel.Carrier ~= bot and bot:IsFriendly(intel.Carrier) then
							targetply = v
						end
					end
				end
				if v ~= bot and bot:IsFriendly(v) and v:Health() < v:GetMaxHealth() / 2 then
					targetply = v
				end
			end
	
			if IsValid(fintel) and targetply ~= fintel.Carrier and targetply:Health() > targetply:GetMaxHealth() / 2 then
				targetply = nil
			end
	
			if IsValid(targetply) then
				targetpos2 = targetply:GetPos()
				local trace = util.QuickTrace(bot:EyePos(), targetply:EyePos() - bot:EyePos(), bot)
				debugoverlay.Line(trace.StartPos, trace.HitPos, 1, Color( 255, 255, 0 ))
	
				if trace.Entity == targetply and targetply:IsFriendly(bot) then
					bot.TargetEnt = targetply
				else 
					if (IsValid(fintel) and targetply ~= fintel.Carrier) then
						bot.TargetEnt = nil
					end
				end
			end
		end
		------------------------------
		 -----[[ENTITY DETECTION]]-----
		------------------------------
		if (bot:Team() == TEAM_BLU and bot:GetPlayerClass() == "sentrybuster") then
		
				for k, v in pairs(ents.FindByClass("obj_*")) do
					if (!IsValid(bot.TargetEnt)) then
						if v:EntIndex() != bot:EntIndex() then
							if (!v:IsFriendly(bot)) then -- TODO: find a better way to do this
								local targetpos = v:EyePos() - Vector(0, 0, 10) -- bot eye check, don't start shooting targets just because we barely see their head
								local trace = util.TraceLine({start = bot:GetShootPos(), endpos = targetpos, filter = function( ent ) return ent == v end})
			
								if (v:EntIndex() == bot:EntIndex()) then return end
								if (v:EntIndex() == bot.ControllerBot:EntIndex()) then return end
								bot.TargetEnt = v
							end
						end
					end
				end
		end
		if (math.random(1,10) == 1) then 
			for k, v in pairs(ents.FindInSphere(bot:GetPos(),6000)) do
				if (!IsValid(bot.TargetEnt)) then
					if v:IsNPC() and v:GetPos():Distance(bot:GetPos()) < 2500 and !IsValid(bot.TargetEnt) then
						if (!v:IsFriendly(bot)) then -- TODO: find a better way to do this
							local targetpos = v:EyePos() - Vector(0, 0, 10) -- bot eye check, don't start shooting targets just because we barely see their head
							local trace = util.TraceLine({start = bot:GetShootPos(), endpos = targetpos, filter = function( ent ) return ent == v end})
	
							if trace.Entity == v then -- TODO: FOV Check
								if (!IsValid(bot.TargetEnt)) then
									if (v:EntIndex() == bot.ControllerBot:EntIndex()) then return end
									bot.TargetEnt = v
								end
							end
						end
					elseif v:IsNextBot() and !v:IsPlayer() and v:GetPos():Distance(bot:GetPos()) < 2500 and !IsValid(bot.TargetEnt) then
						if (!v:IsFriendly(bot)) then -- TODO: find a better way to do this
							local targetpos = v:EyePos() - Vector(0, 0, 10) -- bot eye check, don't start shooting targets just because we barely see their head
							local trace = util.TraceLine({start = bot:GetShootPos(), endpos = targetpos, filter = function( ent ) return ent == v end})
	
							if trace.Entity == v then -- TODO: FOV Check
								if (!IsValid(bot.TargetEnt)) then
									if (v:EntIndex() == bot:EntIndex()) then return end
									if (v:EntIndex() == bot.ControllerBot:EntIndex()) then return end
									bot.TargetEnt = v
								end
							end
						end
					end
				end
			end
				for k, v in pairs(player.GetAll()) do
					if (!IsValid(bot.TargetEnt)) then
						if v:IsPlayer() and v:EntIndex() != bot:EntIndex() and v:GetPos():Distance(bot:GetPos()) < 6000 and !IsValid(bot.TargetEnt) then
							if (!v:IsFriendly(bot)) then -- TODO: find a better way to do this
								local targetpos = v:EyePos() - Vector(0, 0, 10) -- bot eye check, don't start shooting targets just because we barely see their head
								local trace = util.TraceLine({start = bot:GetShootPos(), endpos = targetpos, filter = function( ent ) return ent == v end})
			
								if trace.Entity == v and !trace.Entity:IsFlagSet(FL_NOTARGET) then -- TODO: FOV Check
									if (!IsValid(bot.TargetEnt) and v:Team() != TEAM_NEUTRAL) then
										if (v:EntIndex() == bot:EntIndex()) then return end
										if (v:EntIndex() == bot.ControllerBot:EntIndex()) then return end
										bot.TargetEnt = v
									end
								end
							end
						end
					end
				end
			if (string.find(bot:GetModel(),"/bot_") and bot:Team() == TEAM_BLU and bot:GetPlayerClass() != "sentrybuster") then
		
				for k, v in pairs(team.GetPlayers(TEAM_RED)) do
					if (!IsValid(bot.TargetEnt)) then
						if v:IsPlayer() and v:EntIndex() != bot:EntIndex() and v:GetPos():Distance(bot:GetPos()) < 6000 and v:Visible(bot) and !IsValid(bot.TargetEnt) then
							if (!v:IsFriendly(bot)) then -- TODO: find a better way to do this
								local targetpos = v:EyePos() - Vector(0, 0, 10) -- bot eye check, don't start shooting targets just because we barely see their head
								local trace = util.TraceLine({start = bot:GetShootPos(), endpos = targetpos, filter = function( ent ) return ent == v end})
			
								if (!IsValid(bot.TargetEnt)) then
									if (v:EntIndex() == bot:EntIndex()) then return end
									if (v:EntIndex() == bot.ControllerBot:EntIndex()) then return end
									bot.TargetEnt = v
								end
							end
						end
					end
				end
			elseif (string.find(game.GetMap(),"mvm_") and bot:Team() == TEAM_RED) then
		
				for k, v in pairs(team.GetPlayers(TEAM_BLU)) do
					if (!IsValid(bot.TargetEnt)) then
						if v:IsPlayer() and v:EntIndex() != bot:EntIndex() and v:GetPos():Distance(bot:GetPos()) < 6000 and !IsValid(bot.TargetEnt) and !v:HasGodMode() then
							if (!v:IsFriendly(bot)) then -- TODO: find a better way to do this
								local targetpos = v:EyePos() - Vector(0, 0, 10) -- bot eye check, don't start shooting targets just because we barely see their head
								local trace = util.TraceLine({start = bot:GetShootPos(), endpos = targetpos, filter = function( ent ) return ent == v end})
			
								if (!IsValid(bot.TargetEnt)) then
									if (v:EntIndex() == bot:EntIndex()) then return end
									if (v:EntIndex() == bot.ControllerBot:EntIndex()) then return end
									bot.TargetEnt = v
								end
							end 
						end
					end
				end
		
			end
		end
		------------------------------
		--------[[BOT LOGIC]]---------
		------------------------------
	
		if IsValid(bot.TargetEnt) then
			
			-- move to our target
			local distance = bot.TargetEnt:GetPos():DistToSqr(bot:GetPos())

			-- back up if the target is really close
			-- TODO: find a random spot rather than trying to back up into what could just be a wall
			-- something like controller.PosGen = controller:FindSpot("random", {pos = bot:GetPos() - bot:GetForward() * 350, radius = 1000})?
			if distance <= 90000 * bot:GetModelScale() and bot:Visible(bot.TargetEnt) then
				if (((IsValid(bot:GetActiveWeapon()) and bot:GetActiveWeapon().IsMeleeWeapon) or !bot.TargetEnt:IsFriendly(bot)) and !bot:GetNWBool("Taunting",false)) then   
					if (IsValid(bot:GetActiveWeapon()) and bot:GetActiveWeapon().IsMeleeWeapon) then
						mv:SetForwardSpeed(bot:GetRunSpeed())
						if (math.random(1,10) == 1) then
							bot.ControllerBot.PosGen = controller:FindSpot("random", {pos = bot:GetPos() - bot:GetForward() * (110 * bot:GetModelScale()), radius = 120 * bot:GetModelScale()})
						end
					else
						mv:SetForwardSpeed(bot:GetRunSpeed())
						if (math.random(1,10) == 1) then
							bot.ControllerBot.PosGen = controller:FindSpot("random", {pos = bot:GetPos() - bot:GetForward() * 350 * bot:GetModelScale(), radius = 3000 * bot:GetModelScale()})
						end
					end
				else
					mv:SetForwardSpeed(bot:GetRunSpeed())
					if (math.random(1,10) == 1) then
						bot.ControllerBot.PosGen = controller:FindSpot("random", {pos = bot:GetPos() - bot:GetForward() * 350 * bot:GetModelScale(), radius = 3000 * bot:GetModelScale()})
					end
				end
			else

				if (!bot.isCarryingIntel) then
					bot.botPos = bot.TargetEnt:GetPos()
				end

			end
	
			-- back up if the target is really close
			-- TODO: find a random spot rather than trying to back up into what could just be a wall
			
			if (tf_bot_melee_only:GetBool()) then
				if (IsValid(bot:GetWeapons()[3])) then
					bot:SelectWeapon(bot:GetWeapons()[3])
				elseif (IsValid(bot:GetWeapons()[2])) then
					bot:SelectWeapon(bot:GetWeapons()[2])
				else
					bot:SelectWeapon(bot:GetWeapons()[1])
				end
			end
			if (!tf_bot_melee_only:GetBool()) then
				if (bot:IsL4D()) then
					if IsValid(bot:GetActiveWeapon()) and bot:GetPos():Distance(bot.TargetEnt:GetPos()) < 70 and bot.playerclass != "medic" then 
						if (!bot:GetActiveWeapon().IsMeleeWeapon) then
							mv:SetForwardSpeed(-100)
						else
							mv:SetForwardSpeed(0)
						end
					elseif IsValid(bot:GetActiveWeapon()) and bot:GetPos():Distance(bot.TargetEnt:GetPos()) < 80 and bot.playerclass == "Medic" and bot.TargetEnt:IsFriendly(bot) then 
						mv:SetForwardSpeed(0) 
					elseif IsValid(bot:GetActiveWeapon()) and bot:GetPos():Distance(bot.TargetEnt:GetPos()) < 50 and bot.playerclass == "Medic" and !bot.TargetEnt:IsFriendly(bot) then 
						if (!bot:GetActiveWeapon().IsMeleeWeapon) then
							mv:SetForwardSpeed(-100)
						else
							mv:SetForwardSpeed(0)
						end
					end
				else
					if IsValid(bot:GetActiveWeapon()) and bot:GetPos():Distance(bot.TargetEnt:GetPos()) < 50 and bot.playerclass != "medic" then 
						if (!bot:GetActiveWeapon().IsMeleeWeapon) then
							mv:SetForwardSpeed(-100)
						else
							mv:SetForwardSpeed(0)
						end
					elseif IsValid(bot:GetActiveWeapon()) and bot:GetPos():Distance(bot.TargetEnt:GetPos()) < 80 and bot.playerclass == "Medic" and bot.TargetEnt:IsFriendly(bot) then 
						mv:SetForwardSpeed(0)
					elseif IsValid(bot:GetActiveWeapon()) and bot:GetPos():Distance(bot.TargetEnt:GetPos()) < 50 and bot.playerclass == "Medic" and !bot.TargetEnt:IsFriendly(bot) then 
						if (!bot:GetActiveWeapon().IsMeleeWeapon) then
							mv:SetForwardSpeed(-100)
						else
							mv:SetForwardSpeed(0)
						end
					end
				end
			end
			if bot:GetPlayerClass() == "sniper" then
				if bot:GetActiveWeapon().Slot == 0 then
					buttons = buttons + IN_ATTACK2
					mv:SetForwardSpeed(0)
				else
					mv:SetForwardSpeed(1200)
				end
			end
			bot.LastSegmented = CurTime()
		end

			if (bot:GetPlayerClass() == "engineer") then
				for k, v in pairs(ents.FindByClass("obj_*")) do
						
					if IsValid(v) and bot:GetPos():Distance(v:GetPos()) < 120 and bot:EntIndex() == v:GetBuilder():EntIndex() then -- dont move if too close!
						bot.tooclose = true
						bot.isCarryingIntel = true
						if (bot:GetActiveWeapon():GetClass() != bot:GetWeapons()[3]:GetClass()) then
							bot:SelectWeapon(bot:GetWeapons()[3]:GetClass())
						end
						if (CurTime() > bot:GetActiveWeapon():GetNextPrimaryFire()) then
							bot:GetActiveWeapon():PrimaryAttack()
						end
						bot:AddFlags(FL_DUCKING)
						
						local shouldvegoneforthehead = v:EyePos()
						local bone = 1
						shouldvegoneforthehead = v:GetBonePosition(bone)
						local lerp = 1.2
						bot:SetEyeAngles(LerpAngle(FrameTime() * math.random(8, 10) * lerp, bot:EyeAngles(), (shouldvegoneforthehead - bot:GetShootPos()):Angle()))
						
					else
						bot.tooclose = false
						bot.isCarryingIntel = false
						bot:RemoveFlags(FL_DUCKING)
					end

					if IsValid(v) and bot:EntIndex() == v:GetBuilder():EntIndex() and v:GetClass() == "obj_sentrygun" then -- dont move if too close!
						bot.botPos = v:GetPos()
					elseif (!IsValid(v)) then
						bot.BuiltSentry = false
					end
				end
			end
			
			
		cmd:SetButtons(buttons)
	end
end)

hook.Remove("PlayerSpawn", "leadbot_spawn")

hook.Add("PlayerDisconnected", "leadbot_removed", function(ply)
	for k,v in ipairs(player.GetAll()) do
		if (k < 0) then
			GAMEMODE.round_active = false
		end
	end
	if IsValid(ply) and IsValid(ply.ControllerBot) then
		ply.ControllerBot:Remove()
	end
	
	ply:StopSound("MVM.GiantScoutLoop")
	ply:StopSound("MVM.GiantSoldierLoop")
	ply:StopSound("MVM.GiantPyroLoop")
	ply:StopSound("MVM.GiantDemomanLoop")
	ply:StopSound("MVM.GiantHeavyLoop")
end)

hook.Add("Think", "leadbot_think", function()
	--for _, bot in pairs(player.GetBots()) do
		--print(bot)
		--[[for m, n in pairs(ents.FindByClass("prop_buys")) do
			if n:GetPos():Distance(bot:GetPos()) < 120 then
				print(n)
			end
		end]]
		--[[if bot:Team() == TEAM_SPECTATOR then
			bot:SetTeam(TEAM_PLAYERS)
		end]]
		--[[if bot.TFBot then
			if IsValid(bot:GetActiveWeapon()) then
				local wep = bot:GetActiveWeapon()
				local ammoty = wep:GetPrimaryAmmoType() or wep.Primary.Ammo
				--bot:SetAmmo(32, ammoty)
			end]]

			--[[if nzRound:InState(ROUND_WAITING) and !IsValid(bot:GetActiveWeapon()) then
				bot:KillSilent()
			end]]	

			--if bot:GetActiveWeapon() == NULL or (IsValid(bot:GetActiveWeapon()) and bot:GetActiveWeapon():GetClass() ~= Entity(1):GetActiveWeapon():GetClass()) or !IsValid(bot:GetActiveWeapon()) then
				--if Entity(1):GetActiveWeapon():GetClass() ~= "nz_quickknife_crowbar" and Entity(1):GetActiveWeapon():GetClass() ~= "nz_grenade" and !IsValid(bot.UseTarget) then
					--bot:StripWeapons()
					--bot:Give(Entity(1):GetActiveWeapon():GetClass())
				--end
			--end
		--end
	--end
end)

hook.Add("OnPlayerReady", "leadbot_ready", function()
	RunConsoleCommand("lk.ready_bots")
end)
hook.Add("StartCommand", "leadbot_control", function(bot, cmd)
	if (bot.ControllingPlayer) then
		bot.ControlledButtons = cmd:GetButtons()
		bot.ControlledImpulse = cmd:GetImpulse()
		bot.ControlledMouseWheel = cmd:GetMouseWheel()
		bot.ControlledMoveForward = cmd:GetForwardMove()
		bot.ControlledMouseX = cmd:GetMouseX()
		bot.ControlledMouseY = cmd:GetMouseY()
		bot.ControlledUpMove = cmd:GetUpMove()
		bot.ControlledSideMove = cmd:GetSideMove()
		if (bot.ControllingPlayer:IsNPC()) then
			if (bot:KeyDown(IN_ATTACK)) then
				if (!bot.ControllingPlayer:IsCurrentSchedule(SCHED_MELEE_ATTACK1)) then
					bot.ControllingPlayer:SetSchedule(SCHED_MELEE_ATTACK1)
				end
			elseif (bot:KeyDown(IN_ATTACK2)) then
				if (!bot.ControllingPlayer:IsCurrentSchedule(SCHED_RANGE_ATTACK1)) then
					bot.ControllingPlayer:SetSchedule(SCHED_RANGE_ATTACK1)
				end
			end
			if (bot.ControlledMoveForward > 0 && !bot:KeyDown(IN_ATTACK)) then
				bot.ControllingPlayer:SetSaveValue( "m_vecLastPosition", bot:GetAimVector() * 500 )
				if (bot:KeyDown(IN_SPEED)) then
					bot.ControllingPlayer:SetSchedule( SCHED_FORCED_GO_RUN )
				else
					bot.ControllingPlayer:SetSchedule( SCHED_FORCED_GO )
				end
				bot.ControllingPlayer:SetMoveVelocity(bot:GetAimVector() * 1100)
			end
		end
	end
	if (bot.BeingControlled && IsValid(bot.BeingControlledBy)) then
		cmd:ClearMovement()
		cmd:ClearButtons()
		cmd:SetButtons(bot.BeingControlledBy.ControlledButtons)
		cmd:SetForwardMove(bot.BeingControlledBy.ControlledMoveForward)
		cmd:SetSideMove(bot.BeingControlledBy.ControlledSideMove)
		cmd:SetMouseX(bot.BeingControlledBy.ControlledMouseX)
		cmd:SetMouseY(bot.BeingControlledBy.ControlledMouseY)
		cmd:SetMouseWheel(bot.BeingControlledBy.ControlledMouseWheel)
		cmd:SetImpulse(bot.BeingControlledBy.ControlledImpulse)
		cmd:SetUpMove(bot.BeingControlledBy.ControlledUpMove)
		cmd:SetViewAngles(bot.BeingControlledBy:EyeAngles())
		bot:SetEyeAngles(bot.BeingControlledBy:EyeAngles())
		if (bot.TFBot) then
			bot.WasTFBot = bot.TFBot
			bot.TFBot = false
		end
	end
		if bot.TFBot  then 
			local buttons = 0
			local controller = bot.ControllerBot
			cmd:ClearMovement()
			cmd:ClearButtons()
				
			if (IsValid(bot.TargetEnt)) then
				if (bot.TargetEnt:EntIndex() == bot:EntIndex()) then
					bot.LastPath = nil
					bot.TargetEnt = nil
				elseif (bot.TargetEnt:IsFriendly(bot) and bot.playerclass != "medic") then
					bot.LastPath = nil
					bot.TargetEnt = nil
				elseif (bot.TargetEnt:EntIndex() == bot.ControllerBot:EntIndex()) then
					bot.LastPath = nil  
					bot.TargetEnt = nil
				end
			end
			
			if (bot:GetPlayerClass() == "samuraidemo") then
				bot:SetJumpPower(240 * 2.3)
			end
		
		if (string.find(game.GetMap(),"mvm_")) then
			if (bot:GetPlayerClass() == "engineer" and !IsValid(bot.SentryGunHint) and !bot.BuiltSentry and bot:Team() != TEAM_BLU) then
				bot.SentryGunHint = table.Random(ents.FindByClass("bot_hint_sentrygun"))
			elseif (IsValid(bot.SentryGunHint) and !bot.BuiltSentry and bot:Team() != TEAM_BLU) then
				bot.ControllerBot.PosGen = bot.SentryGunHint:GetPos()
				bot:Build(2,0)
				if (bot:GetPos():Distance(bot.SentryGunHint:GetPos()) < 150) then
					buttons = buttons + IN_ATTACK
					bot.BuiltSentry = true
					timer.Simple(0.2, function()
						bot:SelectWeapon(bot:GetWeapons()[3]:GetClass())
					end)
				end
			elseif (bot:GetPlayerClass() == "engineer" and !IsValid(bot.SentryGunHint) and !bot.BuiltSentry and bot:Team() == TEAM_BLU) then
				bot.SentryGunHint = table.Random(ents.FindByClass("bot_hint_sentrygun"))
			elseif (IsValid(bot.SentryGunHint) and !bot.BuiltSentry and bot:Team() == TEAM_BLU) then
				bot.ControllerBot.PosGen = bot.SentryGunHint:GetPos()
				bot:Build(1,1)
				if (bot:GetPos():Distance(bot.SentryGunHint:GetPos()) < 150) then
					buttons = buttons + IN_ATTACK
					bot.BuiltSentry = true
					timer.Simple(0.2, function()
						bot:SelectWeapon(bot:GetWeapons()[3]:GetClass())
					end)
				end
			end
		else
		
			if (bot:GetPlayerClass() == "engineer" and !IsValid(bot.SentryGunHint) and !bot.BuiltSentry) then
				bot.SentryGunHint = table.Random(ents.FindByClass("bot_hint_sentrygun"))
			elseif (IsValid(bot.SentryGunHint) and !bot.BuiltSentry) then
				bot.ControllerBot.PosGen = bot.SentryGunHint:GetPos()
				bot:Build(2,0)
				if (bot:GetPos():Distance(bot.SentryGunHint:GetPos()) < 150) then
					buttons = buttons + IN_ATTACK
					bot.BuiltSentry = true
					timer.Simple(0.2, function()
						bot:SelectWeapon(bot:GetWeapons()[3]:GetClass())
					end)
				end
			end
		end
		if IsValid(bot.TargetEnt) then
			if (bot.TargetEnt:Health() > 0) then 

					if (!IsValid(bot:GetActiveWeapon())) then return end
					if bot:GetPlayerClass() == "melee_scout_sandman" or bot:GetPlayerClass() == "melee_scout" then 
						for k,v in ipairs(ents.FindInSphere(bot:GetPos(), 240)) do
							if v == bot.TargetEnt then
								buttons = buttons + IN_ATTACK2
							end
						end
					end
					if bot:GetActiveWeapon():GetClass() == "tf_weapon_bat_wood" then 
						if (bot.TargetEnt:GetPos():Distance(bot:GetPos()) < 540) then
							buttons = buttons + IN_ATTACK2 
						end
					end
					if bot:GetPlayerClass() == "demoknight" or bot:GetPlayerClass() == "samuraidemo" or bot:GetPlayerClass() == "giantdemoknight" or bot:GetPlayerClass() == "chieftavish" then
						if (bot.TargetEnt:GetPos():Distance(bot:GetPos()) < 500) then
							buttons = buttons + IN_ATTACK2
						end
					end
					if bot:GetPlayerClass() == "charger" then
						if (bot.TargetEnt:GetPos():Distance(bot:GetPos()) < 240) then
							buttons = buttons + IN_ATTACK2
						end
					elseif bot:GetPlayerClass() == "smoker" then
						if (bot.TargetEnt:GetPos():Distance(bot:GetPos()) < 1000) then
							buttons = buttons + IN_ATTACK2
						end
					elseif bot:GetPlayerClass() == "hunter" then
						if (bot:GetActiveWeapon().ReadyToPounce) then
							if (bot.TargetEnt:GetPos():Distance(bot:GetPos()) < 800) then
									if (!bot:IsFlagSet(FL_DUCKING)) then
										bot:AddFlags(FL_DUCKING)
									end
							end
							if (bot.TargetEnt:GetPos():Distance(bot:GetPos()) < 240) then
								if (bot:Visible(bot.TargetEnt)) then
									buttons = buttons + IN_ATTACK2
								end
							end
						else
							if (bot:IsFlagSet(FL_DUCKING)) then
								bot:RemoveFlags(FL_DUCKING)
							end
						end
						
					elseif bot:IsL4D() then

						if (bot.TargetEnt:GetPos():Distance(bot:GetPos()) < 240) then
							if (bot:Visible(bot.TargetEnt)) then
								if (bot:GetNWBool("Taunting",false) != true) then
									if (bot:Visible(bot.TargetEnt)) then
										buttons = buttons + IN_ATTACK
									end
								end
							end
						end

					else

						if (bot:GetNWBool("Taunting",false) != true) then
							if (bot:Visible(bot.TargetEnt)) then
								if (bot:GetPlayerClass() == "gmodplayer" or bot.playerclass == "Sniper") then
									if (IsValid(bot:GetActiveWeapon())) then
										if (math.random(1,3) == 1) then
											buttons = buttons + IN_ATTACK
										end
									end
								else 
									if (IsValid(bot:GetActiveWeapon()) and bot:Visible(bot.TargetEnt) and bot.TargetEnt:Health() > 0 and bot:GetPos():Distance(bot.TargetEnt:GetPos()) < 2600 * bot:GetModelScale()) then
										if (bot:GetPlayerClass() != "samuraidemo" and IsValid(bot.TargeEntity) and bot.TargeEntity.dt.Charging) then
										
										else
											if (bot:GetActiveWeapon().IsMeleeWeapon and bot.TargetEnt:GetPos():Distance(bot:GetPos()) > 400 * bot:GetModelScale()) then return end
											if (bot:Team() == TEAM_BLU and string.find(bot:GetModel(),"/bot_") and bot:HasGodMode()) then return end
											if (IsValid(bot.TargeEntity) and bot.TargeEntity.dt.Charging and ply:GetPlayerClass() != "samuraidemo") then return end
											if (bot:GetActiveWeapon().ReloadSingle and !bot:GetActiveWeapon().Reloading) then
												buttons = buttons + IN_ATTACK
											elseif (!bot:GetActiveWeapon().ReloadSingle) then
												buttons = buttons + IN_ATTACK
											end
										end
									end
								end
							end
						end

					end

			end
		end
		if IsValid(bot:GetActiveWeapon()) and bot:GetActiveWeapon():Clip1() == 0 then
			--print(bot:GetActiveWeapon():Clip1())
			--print("RELOAD")
			--bot:GetActiveWeapon():SetClip1(1)
			if math.random(2) == 1 then
				buttons = buttons + IN_RELOAD
			end
		end

		cmd:SetButtons(buttons)
		end
end)

hook.Add("PostPlayerDeath", "leadbot_respawn", function(bot)
	if (IsValid(bot)) then
		timer.Simple(6.8, function()
			if IsValid(bot) and bot:Deaths() >= 1 and bot.IsL4DZombie and bot:IsBot() then
				if (!string.find(bot:GetModel(),"/bot_")) then
					
					if (!bot_respawn:GetBool() or bot:IsL4D()) then
						bot:Kick("")
					end

				else

					bot:Kick("")

				end
			end

		end)
		timer.Simple(6.5, function() if IsValid(bot) and bot.TFBot and !bot:Alive() then bot:Spawn() end end)
	end
end)

function table.EqualValues(t1,t2,ignore_mt)
	ignore_mt = ignore_mt or true
	local ty1 = type(t1)
	local ty2 = type(t2)
	if ty1 ~= ty2 then return false end
	-- non-table types can be directly compared
	if ty1 ~= 'table' and ty2 ~= 'table' then return t1 == t2 end
	-- as well as tables which have the metamethod __eq
	local mt = getmetatable(t1)
	if not ignore_mt and mt and mt.__eq then return t1 == t2 end
	for k1,v1 in pairs(t1) do
		local v2 = t2[k1]
		if v2 == nil or not table.EqualValues(v1,v2) then return false end
	end
	for k2,v2 in pairs(t2) do
		local v1 = t1[k2]
		if v1 == nil or not table.EqualValues(v1,v2) then return false end
	end
	return true
end

concommand.Add("print_save_data", function(ply)
	PrintTable(ply:GetSaveTable())
end)
concommand.Add("tf_bot_kick_all", function() for k, v in pairs(player.GetBots()) do v:Kick("Kicked from server") end end)
concommand.Add("tf_bot_bring_all", function(ply) for k, v in pairs(player.GetBots()) do v:SetPos(ply:GetPos()) end end)
concommand.Add("tf_bot_goto", function(ply) local bots = {} for k, v in pairs(player.GetBots()) do table.insert(bots, v) end ply:SetPos(table.Random(bots):GetPos()) end)
concommand.Add("tf_bot_bring", function(ply) local bots = {} for k, v in pairs(player.GetBots()) do table.insert(bots, v) end local pos = navmesh.GetNavArea(Entity(1):GetPos(), 5):GetRandomPoint() table.Random(bots):SetPos(pos) end)
concommand.Add("tf_bot_kill_all", function() for k, v in pairs(player.GetBots()) do v:Kill() end end)
concommand.Add("tf_bot_kill_bots", function() for k, v in pairs(player.GetBots()) do v:Kill() end end)
concommand.Add("tf_bot_say", function(ply, _, args) for k, v in pairs(player.GetBots()) do v:Say(args[1]) end end)

--concommand.Add("lk.noclip", function(ply) if ply:GetMoveType() == MOVETYPE_NOCLIP then ply:SetMoveType(MOVETYPE_WALK) else ply:SetMoveType(MOVETYPE_NOCLIP) end end)
--concommand.Add("lk.downme", function(ply) ply:DownPlayer() end)
concommand.Add("tf_bot_add", function(ply, _, _, args) 
	if (game.SinglePlayer()) then 
		print("Doesn't work in Singleplayer!") 
	end 
	if ply:IsAdmin() or ply:IsSuperAdmin() then 
		for i=0, args[1]-1 do
			LeadBot_S_Add(args[2]) 
		end
	end 
end)
concommand.Add("z_spawn", function(ply, _, _, args) 
	if ply:IsAdmin() or ply:IsSuperAdmin() then 
		
		if (game.SinglePlayer()) then 
			if (args == "witch") then
				local bot = ents.Create("npc_vj_l4d2_witch")
				local pos = ply:GetEyeTrace().HitPos
				bot:SetPos(pos)
				bot:Spawn()
				bot:Activate()
			elseif (args == "boomer") then
				local bot = ents.Create(table.Random({"npc_vj_l4d2_boomer","npc_vj_l4d2_boomer","npc_vj_l4d2_boomer","npc_vj_l4d2_boomer","npc_vj_l4d2_boomette","npc_vj_l4d_boomer"}))
				local pos = ply:GetEyeTrace().HitPos
				bot:SetPos(pos)
				bot:Spawn()
				bot:Activate()
			elseif (args == "smoker") then
				local bot = ents.Create(table.Random({"npc_vj_l4d2_smoker","npc_vj_l4d_smoker"}))
				local pos = ply:GetEyeTrace().HitPos
				bot:SetPos(pos)
				bot:Spawn()
				bot:Activate()
			elseif (args == "hunter") then
				local bot = ents.Create(table.Random({"npc_vj_l4d2_hunter","npc_vj_l4d_hunter"}))
				local pos = ply:GetEyeTrace().HitPos
				bot:SetPos(pos)
				bot:Spawn()
				bot:Activate()
			elseif (args == "tank_l4d") then
				local bot = ents.Create(table.Random({"npc_vj_l4d2_tank","npc_vj_l4d_tank"}))
				local pos = ply:GetEyeTrace().HitPos
				if (math.random(1,8) == 1) then
					bot:SetMaterial("color")
					local animent2 = ents.Create( 'prop_dynamic_override' ) -- The entity used for the death animation	
					animent2:SetModel("models/infected/hulk_dlc3.mdl")
					animent2:SetSkin(bot:GetSkin())
					animent2:SetPos(bot:GetPos())
					animent2:SetAngles(bot:GetAngles())
					animent2:SetParent(bot)
					animent2:AddEffects(EF_BONEMERGE)
				end
				bot:SetPos(pos)
				bot:Spawn()
				bot:Activate()
			elseif (args == "charger") then
				local bot = ents.Create("npc_vj_l4d2_charger")
				local pos = ply:GetEyeTrace().HitPos
				bot:SetPos(pos)
				bot:Spawn()
				bot:Activate()
			elseif (args == "spitter") then
				local bot = ents.Create("npc_vj_l4d2_spitter")
				local pos = ply:GetEyeTrace().HitPos
				bot:SetPos(pos)
				bot:Spawn()
				bot:Activate()
			elseif (args == "jockey") then
				local bot = ents.Create("npc_vj_l4d2_jockey")
				local pos = ply:GetEyeTrace().HitPos
				bot:SetPos(pos)
				bot:Spawn()
				bot:Activate()
			else
				local bot = ents.Create("sent_vj_l4d_cominf")
				local pos = ply:GetEyeTrace().HitPos
				bot:SetPos(pos)
				bot:Spawn()
				bot:Activate()
			end
		else
			if (args == "smoker" || args == "boomer" || args == "hunter" || args == "tank_l4d" || args == "charger" || args == "jockey" || args == "spitter") then
				LeadBot_S_Add_Zombie(1,args,ply:GetEyeTrace().HitPos) 
			else
				if (args == "witch") then
					local bot = ents.Create("npc_vj_l4d2_witch")
					local pos = ply:GetEyeTrace().HitPos
					bot:SetPos(pos)
					bot:Spawn()
					bot:Activate()
				else
					local bot = ents.Create("sent_vj_l4d_cominf")
					local pos = ply:GetEyeTrace().HitPos
					bot:SetPos(pos)
					bot:Spawn()
					bot:Activate()
				end
			end
		end
	end 
end)
concommand.Add("sb_add", function(ply, _, _, args) 
	if ply:IsAdmin() or ply:IsSuperAdmin() then 
		LeadBot_S_Add_Survivor(0,args,ply:GetEyeTrace().HitPos) 
	end 
end)
concommand.Add("sb_add_blue", function(ply, _, _, args) 
	if ply:IsAdmin() or ply:IsSuperAdmin() then 
		LeadBot_S_Add_BlueSurvivor(0,args,ply:GetEyeTrace().HitPos) 
	end 
end)
concommand.Add("tf_bot_name_add", function(_, _, args) table.insert(names, args[1]) MsgN(args[1].." added to names list!") end)
concommand.Add("tf_bot_quota", function(_, _, args) for i=0, args[1]-1 do LeadBot_S_Add() end end)

--concommand.Add("lk.playerclass", function(_, _, args) for k, v in pairs(player.GetBots()) do v:SetPlayerClass(args[1]) end end)

concommand.Add("tf_bot_scramble", function(_, _, args) for k, v in pairs(player.GetBots()) do local teamd = TEAM_RED if math.random(2) == 1 then teamd = TEAM_BLU end v:SetTeam(teamd) end end)

--concommand.Add("lk.neutral", function(_, _, args) for k, v in pairs(player.GetBots()) do v:SetTeam(TEAM_NEUTRAL) end end)
--:SpectateEntity(table.Random(player.GetBots()))
concommand.Add("tf_spectate_bot", function(ply, _, args) if args[1] == "2" then ply:Spectate(OBS_MODE_CHASE) return elseif args[1] == "1" then ply:Spectate(OBS_MODE_IN_EYE) return elseif args[1] == "3" then ply:Spectate(OBS_MODE_ROAMING) return end ply:StripWeapons() local bot = table.Random(player.GetBots()) ply:SpectateEntity(bot) ply:Spectate(OBS_MODE_IN_EYE) end)
concommand.Add("tf_unspectate_bot", function(ply) ply:UnSpectate() ply:KillSilent() ply:Spawn() end)

concommand.Add("tf_bot_takecontrol", function(ply) local bot = ply:GetObserverTarget() ply:UnSpectate() ply:SetMoveType(MOVETYPE_WALK) ply:KillSilent() ply:Spawn() ply:SetTeam(bot:Team()) ply:SetPlayerClass(bot:GetPlayerClass()) timer.Simple(0.1, function() ply:UnSpectate() ply:SetPlayerClass(bot:GetPlayerClass()) timer.Simple(0.1, function() ply:SetHealth(bot:Health()) ply:SetPos(bot:GetPos()) ply:SetEyeAngles(bot:EyeAngles()) ply:SendLua([[surface.PlaySound("misc/freeze_cam.wav")]]) bot:Kill() end) end) end)

--[[concommand.Add("tf_bot_difficulty", function(_, _, args)
	if !args[1] then MsgN("Defines the skill of bots joining the game.") return
	local diffn = "easy"
	if args[1] == "2" then
		diffn = "medium"
	elseif args[1] == "3" then
		diffn = "hard" 
	end

	for k, v in pairs(player.GetBots()) do
		v.Difficulty = args[1]
	end 

	for k, v in pairs(player.GetAll()) do 
		v:ChatPrint("Difficulty has been set to "..args[1].." ("..diffn..")") 
	end 
end)]]