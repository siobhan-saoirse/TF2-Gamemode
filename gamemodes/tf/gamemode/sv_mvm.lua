local function Trim(s)
    -- Remove leading and trailing whitespace
    s = s:match("^%s*(.-)%s*$")
    -- Remove leading // and optional whitespace after it
    s = s:gsub("//.*$", "")
    return s
end
local function ReadLines(path)
    local content = file.Read(path, "GAME")
    if not content then
        print("[POP] Failed to read file: " .. path)
        return nil
    end

    local lines = {}
    for line in content:gmatch("[^\r\n]+") do
        line = Trim(line)
        if line ~= "" and not line:match("^//") then
            table.insert(lines, line)
        end
    end
    return lines
end

local function ParseBlock(lines, start)
    local tbl = {}
    local i = start or 1

    while i <= #lines do
        local line = Trim(lines[i])

        if line == "}" then
            return tbl, i
        end

        -- Key "Value"
        local key, val = line:match('^([^%s]+)%s+"(.-)"$')
        if key and val then
            tbl[key] = val
            i = i + 1

        -- Key {
        elseif i + 1 <= #lines and Trim(lines[i + 1]) == "{" then
            key = line
            local subTbl, newIndex = ParseBlock(lines, i + 2)

            if tbl[key] then
                if type(tbl[key]) ~= "table" or tbl[key][1] == nil then
                    tbl[key] = { tbl[key] }
                end
                table.insert(tbl[key], subTbl)
            else
                tbl[key] = subTbl
            end

            i = newIndex + 1

        -- Key Value
        else
            key, val = line:match('^([^%s]+)%s+(.+)$')
            if key and val then
                tbl[key] = val
            end
            i = i + 1
        end
    end

    return tbl, i
end

function ParsePOPFile(path)
    local lines = ReadLines(path)
    if not lines then return nil end

    local parsed, _ = ParseBlock(lines, 1)
    return parsed
end

WaveManager = {}
WaveManager.CurrentWave = 0
WaveManager.Waves = {}
WaveManager.ActiveSpawns = {}
WaveManager.IsRunning = false
WaveManager.PopFilePath = nil

function WaveManager:LoadPOP(path)
    local pop = ParsePOPFile(path)
    PrintTable(pop)
    if not pop then
        print("[MvM] Failed to load .pop file!")
        return
    end

    local waves = pop.WaveSchedule.Wave
    if type(waves) == "table" and waves[1] == nil then
        -- single wave
        waves = { waves }
    end

    self.Waves = waves or {}
    self.CurrentWave = 0
    self.PopFilePath = path

    print("[MvM] Loaded " .. #self.Waves .. " waves.")
end

function WaveManager:ActivateWaves()
    if #self.Waves == 0 then
        print("[MvM] No waves to activate.")
        return
    end

    self.IsRunning = true
    self.CurrentWave = 1
    self:StartWave(self.Waves[self.CurrentWave])
end

function WaveManager:StartWave(wave)
    print("[MvM] Starting Wave " .. self.CurrentWave)

    if wave.StartWaveOutput then
        self:FireOutput(wave.StartWaveOutput)
    end

    if wave.Checkpoint == "Yes" then
        self.LastCheckpoint = self.CurrentWave
    end

    local spawns = wave.WaveSpawn
    if type(spawns) == "table" and spawns[1] == nil then
        -- single wave
        spawns = { spawns }
    end

    for _, spawn in ipairs(spawns or {}) do    
        if spawn.Squad then
            -- Squad logic: spawn bots at once
            local members = spawn.Squad
            if type(members) == "table" and members[1] == nil then
                members = { members }
            end

            for _, botdef in ipairs(members) do
                self:SpawnSingleBot(botdef)
            end

        elseif spawn.RandomChoice then
            local choices = spawn.RandomChoice
            if type(choices) == "table" and choices[1] == nil then
                choices = { choices }
            end

            local choice = choices[math.random(#choices)]
            self:SpawnGroup(choice)

        else
            -- Standard wave spawn
            self:SpawnGroup(spawn)
        end
    end
end

function WaveManager:SpawnMission(mission)
    local class = string.lower(mission.Class or "")
    local count = tonumber(mission.Count or 1)
    local delay = tonumber(mission.InitialCooldown or 5)
    local interval = tonumber(mission.CooldownTime or 30)

    timer.Simple(delay, function()
        timer.Create("MvM_Mission_" .. class .. "_" .. CurTime(), interval, count, function()
            if class == "sniper" then
                self:SpawnSpecialBot({ Name = "Sniper", Class = "Sniper", Skill = "Expert", Attributes = {"Sniper"} })

            elseif class == "spy" then
                self:SpawnSpecialBot({ Name = "Spy", Class = "Spy", Skill = "Expert", Attributes = {"Spy"} })

            elseif class == "sentrybuster" then
                self:SpawnSpecialBot({ Name = "SentryBuster", Class = "Demoman", Attributes = {"ExplodeOnDeath", "Mini-Boss"} })
            end
        end)
    end)
end

hook.Add("PlayerDeath", "MvMBotAutoKick", function(victim, inflictor, attacker)
    if string.find(game.GetMap(),"mvm_") and victim.TFBot and victim:Team() == TEAM_BLU then
        timer.Simple(5, function()
            if IsValid(victim) then
                victim:Kick("Bot removed after death (MvM)")
            end
        end)
    end
end)

function WaveManager:SpawnSpecialBot(def)
    local bot = player.CreateNextBot(def.Name or "MissionBot")
    bot.TFBot = true
    bot:SetTeam(TEAM_BLU)
    bot:SetPos(GetSpawnForRole(def.Class or "bot")) -- function based on `Where`
    
    ApplyBotAttributes(bot, def.Attributes or {})
    bot:SetPlayerClass(def.Class)
end
function GetSpawnForRole(role)
    -- Fallback logic
    local name = "spawnbot"
    if role == "Sniper" then name = "spawnbot_mission_sniper" end
    if role == "Spy" then name = "spawnbot_mission_spy" end
    if role == "SentryBuster" then name = "spawnbot_mission_buster" end

    local spawns = ents.FindByName(name)
    if #spawns > 0 then return spawns[math.random(#spawns)]:GetPos() end

    return Vector(0,0,0)
end

function WaveManager:EndWave()
    local wave = self.Waves[self.CurrentWave]
    if wave and wave.DoneOutput then
        self:FireOutput(wave.DoneOutput)
    end

    self:NextWave()
end

function WaveManager:FireOutput(output)
    if type(output) == "table" and output[1] == nil then
        output = { output }
    end

    for _, out in ipairs(output) do
        -- Must match output format: { Target, Action, Delay }
        local target = ents.FindByName(out.Target or "")[1]
        if IsValid(target) then
            target:Input(out.Action or "Trigger", NULL, NULL, "", tonumber(out.Delay or 0))
        end
    end
end


function WaveManager:SpawnGroup(spawn)
    local count = tonumber(spawn.TotalCount) or 1
    local maxActive = tonumber(spawn.MaxActive) or count
    local wait = tonumber(spawn.WaitBetweenSpawns) or 0
    local botDef = spawn.TFBot

    if not botDef then return end

    if type(botDef) == "table" and botDef[1] == nil then
        botDef = { botDef }
    end

    local spawned = 0
    local active = 0

    local function spawnBot()
        if spawned >= count then return end
        if active >= maxActive then return end
        for i=1,count do
            local def = botDef[math.random(#botDef)]

            local bot = player.CreateNextBot(def.Name or def.Class or "MvMBot")
            bot.IsL4DZombie = true 
            bot.TFBot = true
            bot.LastPath = nil
            bot.CurSegment = 2
            local v = table.Random(ents.FindByName("spawnbot"))
            bot:SetPos(v:GetPos())
            bot:SetTeam(TEAM_BLU)
            bot:SetPlayerClass(def.Class)
            timer.Simple(0.5, function()
                bot:Spawn()
                bot:SetPlayerClass(def.Class)
            end)
            bot:SetSkin(bot:Team() == TEAM_BLU and 1 or 0)

            bot.ControllerBot = ents.Create("ctf_bot_navigator")
            bot.ControllerBot:Spawn()
            bot.ControllerBot:SetOwner(bot)
            -- Apply attributes
            if def.Attributes then
                ApplyBotAttributes(bot, def.Attributes)
            end

            if def.Item then
                GiveBotItems(bot, def.Item)
            end

            spawned = spawned + 1
            active = active + 1

            bot.OnKilled = function()
                active = active - 1
                self:CheckWaveFinished()
            end
        end
    end

    timer.Create("MvM_SpawnGroup_" .. CurTime(), wait, count, spawnBot)
end

function WaveManager:CheckWaveFinished()
    local botsAlive = 0

    for _, ply in ipairs(player.GetAll()) do
        if ply:IsBot() and ply:Team() == TEAM_BLU and ply:Alive() then
            botsAlive = botsAlive + 1
        end
    end

    if botsAlive == 0 then
        self:NextWave()
    end
end

function WaveManager:NextWave()
    if self.CurrentWave >= #self.Waves then
        print("[MvM] All waves complete!")
        self.IsRunning = false
        return
    end

    self.CurrentWave = self.CurrentWave + 1
    self:StartWave(self.Waves[self.CurrentWave])
end

concommand.Add("mvm_start", function(ply)
    if IsValid(ply) and not ply:IsAdmin() then return end
    WaveManager:LoadPOP("scripts/population/"..game.GetMap()..".pop")
    WaveManager:ActivateWaves()
end)

function ApplyBotAttributes(bot, attributes)
    for _, attr in ipairs(attributes) do
        attr = string.lower(attr)

        if attr == "alwayscrit" then
            bot.AlwaysCrit = true

        elseif attr == "disablejump" then
            bot:SetJumpPower(0)

        elseif attr == "holdfireuntilclose" then
            bot.HoldFireUntilClose = true

        elseif attr == "aggressive" then
            bot.Aggressive = true

        elseif attr == "noattack" then
            bot.NoAttack = true

        elseif attr == "spawnwithfullcharge" then
            bot.SpawnWithCharge = true

        elseif attr == "mini-boss" or attr == "miniboss" then
            bot:SetModelScale(1.75)
        end
    end
end

function GiveBotItems(bot, items)
    if type(items) == "string" then
        items = { items }
    end

    for _, item in ipairs(items) do
        -- You could map item names to actual weapons or models here
        local wep = ents.Create("tf_weapon_" .. string.lower(item))
        if IsValid(wep) then
            wep:SetOwner(bot)
            wep:Spawn()
            bot:Give(wep:GetClass())
        end
    end
end

