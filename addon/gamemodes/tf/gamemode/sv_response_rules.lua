
local tf_voice_cooldown = CreateConVar("tf_voice_cooldown", "1", {FCVAR_NOTIFY})

local function PrecacheGameSounds(path)
	local data
	
	if SERVER and game.IsDedicated() then
		data = file.Read(GM.Folder.."/gamemode/contents/"..path, "GAME")
	else
		data = file.Read(GM.Folder.."/gamemode/contents/"..path, "GAME")
	end
	
	data = '"woot"\n{\n'..data..'\n}\n'
	
	for s,_ in pairs(util.KeyValuesToTable(data)) do
		util.PrecacheSound(s)
	end
end

sound.AddSoundOverrides( "gamemode/contents/game_sounds_vo.lua" )

module("response_rules", package.seeall)

Criteria = {}
Responses = {}
Rules = {}

local comparisons = {
	[">"]  = function(a,b) return a != nil && b != nil && a>b end,
	["<"]  = function(a,b) return a != nil && b != nil && a<b end,
	["<="] = function(a,b) return a != nil && b != nil && a<=b end,
	[">="] = function(a,b) return a != nil && b != nil && a>=b end,
	["!="] = function(a,b) return a != nil && b != nil && a~=b end,
	[""]   = function(a,b) return a != nil && b != nil && a==b end,
}

function AddCriterion(str) 
	--[[
	local name, matchkey, matchvalue, required, weight, w =
		string.match(str, '[cC]riterion%s*"(%S*)"%s*"(%S*)"%s*"(%S*)"%s*(%S*)%s*(%S*)%s*(%S*)')
	]]
	local name, matchkey, matchvalue, required, weight, w =
		string.match(str, '[cC]riterion%s*(%b"")%s*(%b"")%s*(%b"")%s*(%S*)%s*(%S*)%s*(%S*)')
	name = string.match(name, '^"(.*)"$')
	matchkey = string.match(matchkey, '^"(.*)"$')
	matchvalue = string.match(matchvalue, '^"(.*)"$')
	
	if not name then
		return
	end
	
	local tbl = {}
	tbl.key = matchkey
	
	if (required=='required' or required=='"required"') then
		tbl.required = true
	end
	
	if (weight=='weight' or weight=='"weight"') and tonumber(w) then
		tbl.weight = tonumber(w)
	else
		tbl.weight = 1
	end
	
	tbl.values = {}
	for operator,value in string.gmatch(matchvalue, "([<>=!]*)([^,]+)") do
		local t = {}
		t.o = comparisons[operator] or comparisons[""]
		
		if tonumber(value) then
			t.n = tonumber(value)
		else
			t.n = value
		end
		
		table.insert(tbl.values, t)
	end
	if not tbl.values[1] then
		tbl.values[1] = {o=comparisons[""], n=""}
	end
	
	--Msg("Registered criterion '"..name.."'\n")
	
	Criteria[name] = tbl
	return tbl
end

function AddResponse(str)
	local name
	name, str = string.match(str, '[rR]esponse%s*"*(%a+)"*%s*{(.-)}')
	if not name then
		return
	end
	
	local tbl = {}
	
	for line in string.gmatch(str, ".-\n") do
		local head,param,param2,param3 = string.match(line, "(%S+)%s*(%S*)%s*(%S*)%s*(%S*)")
		if head=="scene" then
			local sc = string.match(param, '([%a%d_/%.]+)')
			PrecacheScene(sc)  
			local t = {sc}
			if param2=="predelay" then
				t.predelay = {}
				for v in string.gmatch(param3, "[%d%.]+") do
					table.insert(t.predelay, tonumber(v) or 0)
				end
			end
			table.insert(tbl, t)
		elseif head=="speak" then
			local sc = string.match(param, '([%a%d_/%.]+)')
			util.PrecacheSound(sc)  
			table.insert(tbl, t)
		end
	end 
	 
	Responses[name] = tbl
	return tbl
end

function AddRule(str)
	local name
	name, str = string.match(str, "[rR]ule%s*(%a+)%s*{(.-)}")
	if not name then
		return
	end
	
	local tbl = {}
	local criteria = string.match(str, "[cC]riteria%s*(.-)\n")
	
	if not criteria then
		return
	end
	
	tbl.criteria = {}
	for criterion in string.gmatch(criteria, "(%S+)") do
		table.insert(tbl.criteria, criterion)
	end
	
	local response = string.match(str, "[rR]esponse%s*(.-)\n")
	if not response then
		return
	end
	
	tbl.response = response
	
	local worldcontext = string.find(str, "applycontexttoworld")
	
	local context, value, duration = string.match(str, "[aA]pplyContext%s*\"(.-):(%d-):(%d-)\"\n")
	if context and value and duration then
		tbl.context = {context, tonumber(value) or 0, tonumber(duration) or 0, worldcontext ~= nil}
	end
	 
	Rules[name] = tbl
	return tbl
end

function IsMatchingCriterion(ent,crit)
	local value = ent[crit.key]
	if not crit.values then return false end
	
	for _,v in ipairs(crit.values) do
		if not v.o(value, v.n) then
			return false
		end
	end
	
	return true
end

concommand.Add("match_criterion", function(pl,cmd,args)
	if not Criteria[args[1]] then return end
	pl:ChatPrint(tostring(IsMatchingCriterion(pl,Criteria[args[1]])))
end)

--------------------------------------------------------------------------------

function Load(path)
	Msg("Loading response/rules script '"..path.."' ... ")
	local nrule, nresp, ncrit = 0, 0, 0
	local data
	
	if SERVER and game.IsDedicated() then
		data = file.Read(GM.Folder.."/gamemode/contents/"..path, "GAME")
	else 
		data = file.Read(GM.Folder.."/gamemode/contents/"..path, "GAME")
	end
	
	if not data or data=="" then
		MsgFN("Error, file '%s' not found!", path)
		return  
	end
    
	data = string.gsub(data, "//.-\n", "")
	data = string.gsub(data, "\r", "") -- get rid of carriage returns
	
	-- Criteria  
	for str in string.gmatch(data, "([cC]riterion.-\n)") do
		--print(str)
		AddCriterion(str)
		ncrit = ncrit + 1
	end 
	 
	-- Rules
	for str in string.gmatch(data, "([rR]ule.-{.-})") do
		AddRule(str)
		nrule = nrule + 1
	end
	
	-- Responses
	for str in string.gmatch(data, "([rR]esponse.-{.-})") do
		AddResponse(str)
		nresp = nresp + 1
	end
	
	Msg(nrule.." rules, "..nresp.." responses, "..ncrit.." criteria\n")
	
	-- Includes
	for str in string.gmatch(data, "#include \"(.-)\"") do
		Load(str)
	end
end

local MissingCriterionErrorShown

function SelectResponse(ent, dbg)
	for k,v in pairs(ent.TemporaryContexts or {}) do
		if CurTime()>v then
			ent[k] = nil
		end
	end
	
	local bestrule, best, bestscore = nil, nil, 0
	for rname,rule in pairs(Rules) do
		local score = 0
		for rcrit,cname in ipairs(rule.criteria) do
			local criterion = Criteria[cname]
			
			if not criterion then
				if not MissingCriterionErrorShown then
					MissingCriterionErrorShown = true
					ErrorNoHalt("WARNING: Criterion '"..cname.."' is required for rule '"..rname.."' but was not found")
					ErrorNoHalt("WARNING: Outdated tf_response_rules.lua, some scenes might not function properly")
				end
			elseif IsMatchingCriterion(ent, criterion or {}) then
				score = score + criterion.weight
			elseif criterion.required then
				score = -1
				break
			end
		end
		
		if score>=bestscore and Responses[rule.response] then
			bestrule = rule
			best = Responses[rule.response]
			bestscore = score
		end
	end
	
	if bestrule and bestrule.context then
		if bestrule.context[4] then
			-- Apply the context to all players
			local n = "world"..bestrule.context[1]
			for _,v in pairs(player.GetAll()) do
				v[n] = bestrule.context[2]
				if not v.TemporaryContexts then v.TemporaryContexts = {} end
				v.TemporaryContexts[n] = CurTime() + bestrule.context[3]
			end
		else
			ent[bestrule.context[1]] = bestrule.context[2]
			if not ent.TemporaryContexts then ent.TemporaryContexts = {} end
			ent.TemporaryContexts[bestrule.context[1]] = CurTime() + bestrule.context[3]
		end
	end
	
	return best
end

local function playscene_delayed(ent, scene)
	if not IsValid(ent) then return end
	if (string.find(ent:GetModel(),"hwm")) then
		if (ent:GetInfoNum("tf_usehwmvcds ",0) == 1) then
			scene = string.Replace(scene,"low","high")
		end
	end
	ent:PlayScene(scene, 0)
end

function PlayResponse(ent, response, nospeech, concept)
	if ent.NextSpeak and CurTime()<ent.NextSpeak and concept != "TLK_PLAYER_TAUNT" then
		return false
	end

	--PrintTable(response) 
	
	local num = #response
	local i = math.random(1,num)
	local j = i
	
	while response[j][1]==ent.LastScene and not nospeech do
		j = j+1
		if j>num then j=1 end
		if j==i then break end
	end
	
	local r = response[j]
	
	local delay
	if r.predelay then
		if r.predelay[2] then
			delay = math.Rand(r.predelay[1], r.predelay[2])
		else
			delay = r.predelay[1]
		end
	end
	if not nospeech then
		if delay then
			timer.Simple(delay, function()
				time = playscene_delayed(ent, r[1])
				ent:SetNWBool("SpeechTime", time) 
			end)
		else
			if (string.find(ent:GetModel(),"hwm")) then
				if (ent:GetInfoNum("tf_usehwmvcds ",0) == 1) then
					r[1] = string.Replace(r[1],"low","high")
				end
			end
			time = ent:PlayScene(r[1], 0)
			ent:SetNWBool("SpeechTime", time)
		end
		
		ent.LastScene = r[1]
		if not nospeech then
			
			if tf_voice_cooldown:GetBool() then
				if (time) then
					print("vcd time: "..1.5)
					ent.NextSpeak = CurTime() + 1.5
				else
					print("vcd time: 1.5")
					ent.NextSpeak = CurTime() + 1.5
				end
				if delay then ent.NextSpeak = ent.NextSpeak + delay end
			end
		end
		return true
	end
	
	return false
end
function PainfulResponse(ent, response, nospeech, attacker)
	if ent.NextPainSound and CurTime()<ent.NextPainSound and not nospeech then
		return false
	end

	--PrintTable(response) 
	
	local num = #response
	local i = math.random(1,num)
	local j = i
	
	while response[j][1]==ent.LastScene and not nospeech do
		j = j+1
		if j>num then j=1 end
		if j==i then break end
	end
	
	local r = response[j]
	
	local delay
	if r.predelay then
		if r.predelay[2] then
			delay = math.Rand(r.predelay[1], r.predelay[2])
		else
			delay = r.predelay[1]
		end
	end
	if not nospeech then
		if delay then
			timer.Simple(delay, function()
				time = playscene_delayed(ent, r[1])
				ent:SetNWBool("SpeechTime", time) 
			end)
		else
			time = ent:PlayScene(r[1], 0)
		end
		
		ent.LastScene = r[1]
		if not nospeech then
			print("vcd time: "..time)
				if (ent:GetPlayerClass() == "scout" or ent:GetPlayerClass() == "soldier") then
					ent.NextPainSound = CurTime() + math.random(0.2,1.2)
				else
					ent.NextPainSound = CurTime() + 1.5
				end
		end
		return true
	end
	
	return false
end
function FlamingResponse(ent, response, nospeech)
	if ent.NextFireSound and CurTime()<ent.NextFireSound and not nospeech then
		return false
	end

	--PrintTable(response) 
	
	local num = #response
	local i = math.random(1,num)
	local j = i
	
	while response[j][1]==ent.LastScene and not nospeech do
		j = j+1
		if j>num then j=1 end
		if j==i then break end
	end
	
	local r = response[j]
	
	local delay
	if r.predelay then
		if r.predelay[2] then
			delay = math.Rand(r.predelay[1], r.predelay[2])
		else
			delay = r.predelay[1]
		end
	end
	if not nospeech then
		if delay then
			timer.Simple(delay, function()
				time = playscene_delayed(ent, r[1])
				ent:SetNWBool("SpeechTime", time) 
			end)
		else
			if (string.find(ent:GetModel(),"hwm")) then
				if (ent:GetInfoNum("tf_usehwmvcds ",0) == 1) then
					r[1] = string.Replace(r[1],"low","high")
				end
			end
			time = ent:PlayScene(r[1], 0)
			ent:SetNWBool("SpeechTime", time)
		end
		
		ent.LastScene = r[1]
		if not nospeech then
			print("vcd time: "..2.5)
			ent.NextFireSound = CurTime() + 2.5
			if delay then ent.NextFireSound = ent.NextFireSound + delay end
		end
		return true
	end
	
	return false
end
function PlayResponse2(ent, response, nospeech)
	if ent.NextSpeak and CurTime()<ent.NextSpeak and not nospeech then
		return false
	end

	--PrintTable(response)
	
	local num = #response
	local i = math.random(1,num)
	local j = i
	
	
	while response[j][1]==ent.LastScene and not nospeech do
		j = j+1
		if j>num then j=1 end
		if j==i then break end
	end
	
	local r = response[j]
	
	local delay
	local time
	if r.predelay then
		if r.predelay[2] then
			delay = math.Rand(r.predelay[1], r.predelay[2])
		else
			delay = r.predelay[1]
		end
	end
	if not ent.NextSpeak or CurTime()>ent.NextSpeak or nospeech then
		if delay then
			timer.Simple(delay, function()
				time = playscene_delayed(ent, r[1])
				ent:SetNWBool("SpeechTime", time) 
			end)
		else
			if (string.find(ent:GetModel(),"hwm")) then
				if (ent:GetInfoNum("tf_usehwmvcds ",0) == 1) then
					r[1] = string.Replace(r[1],"low","high")
				end
			end
			time = ent:PlayScene(r[1], 0)
			ent:SetNWBool("SpeechTime", time)
		end
		
		ent.LastScene = r[1]
		if not nospeech then
			
			if tf_voice_cooldown:GetBool() then
				if (time) then
					print("vcd time: "..time)
					ent.NextSpeak = CurTime() + time
				else
					print("vcd time: 1.5")
					ent.NextSpeak = CurTime() + 1.5
				end
				if delay then ent.NextSpeak = ent.NextSpeak + delay end
			end
		end
		return true
	end
	
	return false
end

function PlayResponse3(ent, response, nospeech)

	--PrintTable(response)
	
	local num = #response
	local i = math.random(1,num)
	local j = i
	
	
	while response[j][1]==ent.LastScene and not nospeech do
		j = j+1
		if j>num then j=1 end
		if j==i then break end
	end
	
	local r = response[j]
	
	local delay
	local time
	if r.predelay then
		if r.predelay[2] then
			delay = math.Rand(r.predelay[1], r.predelay[2])
		else
			delay = r.predelay[1]
		end
	end
	if not nospeech then
		if delay then
			timer.Simple(delay, function()
				time = playscene_delayed(ent, r[1])
				ent:SetNWBool("SpeechTime", time) 
			end)
		else
			if (string.find(ent:GetModel(),"hwm")) then
				if (ent:GetInfoNum("tf_usehwmvcds ",0) == 1) then
					r[1] = string.Replace(r[1],"low","high")
				end
			end
			time = ent:PlayScene(r[1], 0)
			ent:SetNWBool("SpeechTime", time)
		end
		
		ent.LastScene = r[1]
		if not nospeech then
			
			if tf_voice_cooldown:GetBool() then
				if (time) then
					print("vcd time: "..time)
					ent.NextSpeak = CurTime() + time
				else
					print("vcd time: 1.5")
					ent.NextSpeak = CurTime() + 1.5
				end
				if delay then ent.NextSpeak = ent.NextSpeak + delay end
			end
		end
		return true
	end
	
	return false
end

function PlayResponse4(ent, response, nospeech)

	--PrintTable(response)
	
	local num = #response
	local i = math.random(1,num)
	local j = i
	
	
	while response[j][1]==ent.LastScene and not nospeech do
		j = j+1
		if j>num then j=1 end
		if j==i then break end
	end
	
	local r = response[j]
	
	local delay
	local time
	if r.predelay then
		if r.predelay[2] then
			delay = math.Rand(r.predelay[1], r.predelay[2])
		else
			delay = r.predelay[1]
		end
	end
	if not nospeech then
		if delay then
			timer.Simple(delay, function()
				time = playscene_delayed(ent, r[1])
				ent:SetNWBool("SpeechTime", time) 
			end)
		else
			if (string.find(ent:GetModel(),"hwm")) then
				if (ent:GetInfoNum("tf_usehwmvcds ",0) == 1) then
					r[1] = string.Replace(r[1],"low","high")
				end
			end
			time = ent:PlayScene(r[1], 0)
			ent:SetNWBool("SpeechTime", time)
		end
		
		ent.LastScene = r[1]
		if not nospeech then
			
			if tf_voice_cooldown:GetBool() then
				if (time) then
					print("vcd time: "..1.5)
					ent.NextSpeak = CurTime() + 1.5
				else
					print("vcd time: 1.5")
					ent.NextSpeak = CurTime() + 1.5
				end
				if delay then ent.NextSpeak = ent.NextSpeak + delay end
			end
		end
		return true
	end
	
	return false
end

local META = FindMetaTable("Player")

function META:Speak(concept, nospeech, dbg)
	if not self:Alive() then
		return false
	end
	--[[
	if not nospeech then
		Msg("Concept : "..concept.."\n")
	end]]
	
	----------------------------------------------------------------
	
	-- Which concept we want to play
	self.Concept = tostring(concept)
	
	-- Random number
	self.randomnum = math.random(0,100)
	
	-- Current weapon
	if IsValid(self:GetActiveWeapon()) then
		if (self:GetActiveWeapon():GetClass() == "tf_weapon_allclass") then
			if (self:GetPlayerClass() == "engineer") then
				self.playerweapon = "tf_weapon_wrench"
			elseif (self:GetPlayerClass() == "heavy") then
				self.playerweapon = "tf_weapon_fists"
			elseif (self:GetPlayerClass() == "pyro") then
				self.playerweapon = "tf_weapon_fireaxe"
			elseif (self:GetPlayerClass() == "demoman") then
				self.playerweapon = "tf_weapon_bottle"
			elseif (self:GetPlayerClass() == "scout") then
				self.playerweapon = "tf_weapon_bat"
			elseif (self:GetPlayerClass() == "soldier") then
				self.playerweapon = "tf_weapon_shovel"
			elseif (self:GetPlayerClass() == "medic") then
				self.playerweapon = "tf_weapon_bonesaw"
			elseif (self:GetPlayerClass() == "sniper") then
				self.playerweapon = "tf_weapon_club"
			elseif (self:GetPlayerClass() == "spy") then
				self.playerweapon = "tf_weapon_knife"
			end
		elseif (self:GetActiveWeapon():GetClass() == "tf_weapon_katana") then
			if (self:GetPlayerClass() == "engineer") then
				self.playerweapon = "tf_weapon_wrench"
			elseif (self:GetPlayerClass() == "heavy") then
				self.playerweapon = "tf_weapon_fists"
			elseif (self:GetPlayerClass() == "pyro") then
				self.playerweapon = "tf_weapon_fireaxe"
			elseif (self:GetPlayerClass() == "demoman") then
				self.playerweapon = "tf_weapon_sword"
			elseif (self:GetPlayerClass() == "scout") then
				self.playerweapon = "tf_weapon_bat" 
			elseif (self:GetPlayerClass() == "soldier") then
				self.playerweapon = "tf_weapon_rocketlauncher_dh"
			elseif (self:GetPlayerClass() == "medic") then
				self.playerweapon = "tf_weapon_bonesaw"
			elseif (self:GetPlayerClass() == "sniper") then
				self.playerweapon = "tf_weapon_club"
			elseif (self:GetPlayerClass() == "spy") then
				self.playerweapon = "tf_weapon_knife"
			end
		elseif (self:GetActiveWeapon():GetClass() == "tf_weapon_bat_giftwrap") then
			if (self:GetPlayerClass() == "scout") then
				self.playerweapon = "tf_weapon_bat"
			end
		elseif (string.find(self:GetActiveWeapon():GetClass(),"minigun") || string.find(self:GetActiveWeapon():GetClass(),"minifun") || string.find(self:GetActiveWeapon():GetClass(),"gatling")) then
			self.playerweapon = "tf_weapon_minigun"
		else
			self.playerweapon = self:GetActiveWeapon():GetClass() 
		end
		if self:GetActiveWeapon().GetItemData then
			self.item_name = self:GetActiveWeapon():GetItemData().name or ""
			self.item_type_name = self:GetActiveWeapon():GetItemData().item_type_name or ""
		else
			self.item_name = ""
			self.item_type_name = ""
		end
	else
		self.playeranim = ""
	end
	
	-- Health fraction
	self.playerhealthfrac = self:Health()/self:GetMaxHealth()
	
	-- What class the player is looking at
	self.crosshair_on = ""
	self.crosshair_enemy = "No"
	
	local start = self:GetShootPos()
	local endpos = start + self:GetAimVector() * 10000
	local tr = util.TraceHull{
		start = start,
		endpos = endpos,
		filter = self,
		mins = Vector(-10, -10, -10),
		maxs = Vector(10, 10, 10),
	}
	
	local class = ""
	if tr.Entity and tr.Entity:IsPlayer() then
		if tr.Entity:GetPlayerClass() == "gmodplayer" then
			class = string.lower(tr.Entity.playerclass) or "sniper"
		elseif tr.Entity:GetPlayerClass() == "medicshotgun" then
			class = "medic"
		else
			class = tr.Entity:GetPlayerClass()
		end
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_combine_s" then
		class = "soldier"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_metropolice" then
		class = "metrocop"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_kleiner" then
		class = "medic"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_eli" then
		class = "medic"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_barney" then
		class = "medic"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_citizen" then
		class = "engineer"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_breen" then
		class = "scout"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_vortigaunt" then
		class = "heavy"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() then
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	end
	self.crosshair_on = class
	 
	-- Temporary
	self.GameRound = 5
	if self:IsLoser() then
		self.OnWinningTeam = 0
	else
		self.OnWinningTeam = 1
	end
	---------------------------------------------------------------- 
	
	local response = SelectResponse(self, dbg)
	
	if response then
		return PlayResponse(self, response, nospeech, concept)
	end
	
	return false
end

function META:PainSound(concept, nospeech, dbg, attacker)
	if not self:Alive() then
		return false
	end
	--[[
	if not nospeech then
		Msg("Concept : "..concept.."\n")
	end]]
	
	----------------------------------------------------------------
	
	-- Which concept we want to play
	self.Concept = tostring(concept)
	
	-- Random number
	self.randomnum = math.random(0,100)
	
	-- Current weapon
	if IsValid(self:GetActiveWeapon()) then
		if (self:GetActiveWeapon():GetClass() == "tf_weapon_allclass") then
			if (self:GetPlayerClass() == "engineer") then
				self.playerweapon = "tf_weapon_wrench"
			elseif (self:GetPlayerClass() == "heavy") then
				self.playerweapon = "tf_weapon_fists"
			elseif (self:GetPlayerClass() == "pyro") then
				self.playerweapon = "tf_weapon_fireaxe"
			elseif (self:GetPlayerClass() == "demoman") then
				self.playerweapon = "tf_weapon_bottle"
			elseif (self:GetPlayerClass() == "scout") then
				self.playerweapon = "tf_weapon_bat"
			elseif (self:GetPlayerClass() == "soldier") then
				self.playerweapon = "tf_weapon_shovel"
			elseif (self:GetPlayerClass() == "medic") then
				self.playerweapon = "tf_weapon_bonesaw"
			elseif (self:GetPlayerClass() == "sniper") then
				self.playerweapon = "tf_weapon_club"
			elseif (self:GetPlayerClass() == "spy") then
				self.playerweapon = "tf_weapon_knife"
			end
		elseif (self:GetActiveWeapon():GetClass() == "tf_weapon_katana") then
			if (self:GetPlayerClass() == "engineer") then
				self.playerweapon = "tf_weapon_wrench"
			elseif (self:GetPlayerClass() == "heavy") then
				self.playerweapon = "tf_weapon_fists"
			elseif (self:GetPlayerClass() == "pyro") then
				self.playerweapon = "tf_weapon_fireaxe"
			elseif (self:GetPlayerClass() == "demoman") then
				self.playerweapon = "tf_weapon_sword"
			elseif (self:GetPlayerClass() == "scout") then
				self.playerweapon = "tf_weapon_bat" 
			elseif (self:GetPlayerClass() == "soldier") then
				self.playerweapon = "tf_weapon_rocketlauncher_dh"
			elseif (self:GetPlayerClass() == "medic") then
				self.playerweapon = "tf_weapon_bonesaw"
			elseif (self:GetPlayerClass() == "sniper") then
				self.playerweapon = "tf_weapon_club"
			elseif (self:GetPlayerClass() == "spy") then
				self.playerweapon = "tf_weapon_knife"
			end
		elseif (self:GetActiveWeapon():GetClass() == "tf_weapon_bat_giftwrap") then
			if (self:GetPlayerClass() == "scout") then
				self.playerweapon = "tf_weapon_bat"
			end
		elseif (string.find(self:GetActiveWeapon():GetClass(),"minigun") || string.find(self:GetActiveWeapon():GetClass(),"minifun") || string.find(self:GetActiveWeapon():GetClass(),"gatling")) then
			self.playerweapon = "tf_weapon_minigun"
		else
			self.playerweapon = self:GetActiveWeapon():GetClass() 
		end
		if self:GetActiveWeapon().GetItemData then
			self.item_name = self:GetActiveWeapon():GetItemData().name or ""
			self.item_type_name = self:GetActiveWeapon():GetItemData().item_type_name or ""
		else
			self.item_name = ""
			self.item_type_name = ""
		end
	else
		self.playeranim = ""
	end
	
	-- Health fraction
	self.playerhealthfrac = self:Health()/self:GetMaxHealth()
	
	-- What class the player is looking at
	self.crosshair_on = ""
	self.crosshair_enemy = "No"
	
	local start = self:GetShootPos()
	local endpos = start + self:GetAimVector() * 10000
	local tr = util.TraceHull{
		start = start,
		endpos = endpos,
		filter = self,
		mins = Vector(-10, -10, -10),
		maxs = Vector(10, 10, 10),
	}
	
	local class = ""
	if tr.Entity and tr.Entity:IsPlayer() then
		if tr.Entity:GetPlayerClass() == "gmodplayer" then
			class = string.lower(tr.Entity.playerclass) or "sniper"
		elseif tr.Entity:GetPlayerClass() == "medicshotgun" then
			class = "medic"
		else
			class = tr.Entity:GetPlayerClass()
		end
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_combine_s" then
		class = "soldier"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_metropolice" then
		class = "metrocop"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_kleiner" then
		class = "medic"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_eli" then
		class = "medic"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_barney" then
		class = "medic"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_citizen" then
		class = "engineer"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_breen" then
		class = "scout"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_vortigaunt" then
		class = "heavy"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() then
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	end
	self.crosshair_on = class
	
	-- Temporary
	self.GameRound = 5
	if self:IsLoser() then
		self.OnWinningTeam = 0
	else
		self.OnWinningTeam = 1
	end
	----------------------------------------------------------------
	
	local response = SelectResponse(self, dbg)
	
	if response then
		return PainfulResponse(self, response, nospeech, dbg, attacker)
	end
	
	return false
end
function META:FireSound(concept, nospeech, dbg)
	if not self:Alive() then
		return false
	end
	--[[
	if not nospeech then
		Msg("Concept : "..concept.."\n")
	end]]
	
	----------------------------------------------------------------
	
	-- Which concept we want to play
	self.Concept = tostring(concept)
	
	-- Random number
	self.randomnum = math.random(0,100)
	
	-- Current weapon
	if IsValid(self:GetActiveWeapon()) then
		if (self:GetActiveWeapon():GetClass() == "tf_weapon_allclass") then
			if (self:GetPlayerClass() == "engineer") then
				self.playerweapon = "tf_weapon_wrench"
			elseif (self:GetPlayerClass() == "heavy") then
				self.playerweapon = "tf_weapon_fists"
			elseif (self:GetPlayerClass() == "pyro") then
				self.playerweapon = "tf_weapon_fireaxe"
			elseif (self:GetPlayerClass() == "demoman") then
				self.playerweapon = "tf_weapon_bottle"
			elseif (self:GetPlayerClass() == "scout") then
				self.playerweapon = "tf_weapon_bat"
			elseif (self:GetPlayerClass() == "soldier") then
				self.playerweapon = "tf_weapon_shovel"
			elseif (self:GetPlayerClass() == "medic") then
				self.playerweapon = "tf_weapon_bonesaw"
			elseif (self:GetPlayerClass() == "sniper") then
				self.playerweapon = "tf_weapon_club"
			elseif (self:GetPlayerClass() == "spy") then
				self.playerweapon = "tf_weapon_knife"
			end
		elseif (self:GetActiveWeapon():GetClass() == "tf_weapon_katana") then
			if (self:GetPlayerClass() == "engineer") then
				self.playerweapon = "tf_weapon_wrench"
			elseif (self:GetPlayerClass() == "heavy") then
				self.playerweapon = "tf_weapon_fists"
			elseif (self:GetPlayerClass() == "pyro") then
				self.playerweapon = "tf_weapon_fireaxe"
			elseif (self:GetPlayerClass() == "demoman") then
				self.playerweapon = "tf_weapon_sword"
			elseif (self:GetPlayerClass() == "scout") then
				self.playerweapon = "tf_weapon_bat" 
			elseif (self:GetPlayerClass() == "soldier") then
				self.playerweapon = "tf_weapon_rocketlauncher_dh"
			elseif (self:GetPlayerClass() == "medic") then
				self.playerweapon = "tf_weapon_bonesaw"
			elseif (self:GetPlayerClass() == "sniper") then
				self.playerweapon = "tf_weapon_club"
			elseif (self:GetPlayerClass() == "spy") then
				self.playerweapon = "tf_weapon_knife"
			end
		elseif (self:GetActiveWeapon():GetClass() == "tf_weapon_bat_giftwrap") then
			if (self:GetPlayerClass() == "scout") then
				self.playerweapon = "tf_weapon_bat"
			end
		elseif (string.find(self:GetActiveWeapon():GetClass(),"minigun") || string.find(self:GetActiveWeapon():GetClass(),"minifun") || string.find(self:GetActiveWeapon():GetClass(),"gatling")) then
			self.playerweapon = "tf_weapon_minigun"
		else
			self.playerweapon = self:GetActiveWeapon():GetClass() 
		end
		if self:GetActiveWeapon().GetItemData then
			self.item_name = self:GetActiveWeapon():GetItemData().name or ""
			self.item_type_name = self:GetActiveWeapon():GetItemData().item_type_name or ""
		else
			self.item_name = ""
			self.item_type_name = ""
		end
	else
		self.playeranim = ""
	end
	
	-- Health fraction
	self.playerhealthfrac = self:Health()/self:GetMaxHealth()
	
	-- What class the player is looking at
	self.crosshair_on = ""
	self.crosshair_enemy = "No"
	
	local start = self:GetShootPos()
	local endpos = start + self:GetAimVector() * 10000
	local tr = util.TraceHull{
		start = start,
		endpos = endpos,
		filter = self,
		mins = Vector(-10, -10, -10),
		maxs = Vector(10, 10, 10),
	}
	
	local class = ""
	if tr.Entity and tr.Entity:IsPlayer() then
		if tr.Entity:GetPlayerClass() == "gmodplayer" then
			class = "sniper"
		elseif tr.Entity:GetPlayerClass() == "medicshotgun" then
			class = "medic"
		else
			class = tr.Entity:GetPlayerClass()
		end
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_combine_s" then
		class = "soldier"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_metropolice" then
		class = "metrocop"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_kleiner" then
		class = "medic"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_eli" then
		class = "medic"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_barney" then
		class = "medic"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_citizen" then
		class = "engineer"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_breen" then
		class = "scout"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_vortigaunt" then
		class = "heavy"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() then
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	end
	self.crosshair_on = class
	
	-- Temporary
	self.GameRound = 5
	if self:IsLoser() then
		self.OnWinningTeam = 0
	else
		self.OnWinningTeam = 1
	end
	----------------------------------------------------------------
	
	local response = SelectResponse(self, dbg)
	
	if response then
		return FlamingResponse(self, response, nospeech, dbg)
	end
	
	return false
end

function META:SpeakWithEnemyCrosshair(concept, nospeech, dbg)
	if not self:Alive() then
		return false
	end
	--[[
	if not nospeech then
		Msg("Concept : "..concept.."\n")
	end]]
	
	----------------------------------------------------------------
	
	-- Which concept we want to play
	self.Concept = tostring(concept)
	
	-- Random number
	self.randomnum = math.random(0,100)
	
	-- Current weapon
	if IsValid(self:GetActiveWeapon()) then
		if (self:GetActiveWeapon():GetClass() == "tf_weapon_allclass") then
			if (self:GetPlayerClass() == "engineer") then
				self.playerweapon = "tf_weapon_wrench"
			elseif (self:GetPlayerClass() == "heavy") then
				self.playerweapon = "tf_weapon_fists"
			elseif (self:GetPlayerClass() == "pyro") then
				self.playerweapon = "tf_weapon_fireaxe"
			elseif (self:GetPlayerClass() == "demoman") then
				self.playerweapon = "tf_weapon_bottle"
			elseif (self:GetPlayerClass() == "scout") then
				self.playerweapon = "tf_weapon_bat"
			elseif (self:GetPlayerClass() == "soldier") then
				self.playerweapon = "tf_weapon_shovel"
			elseif (self:GetPlayerClass() == "medic") then
				self.playerweapon = "tf_weapon_bonesaw"
			elseif (self:GetPlayerClass() == "sniper") then
				self.playerweapon = "tf_weapon_club"
			elseif (self:GetPlayerClass() == "spy") then
				self.playerweapon = "tf_weapon_knife"
			end
		elseif (self:GetActiveWeapon():GetClass() == "tf_weapon_bat_giftwrap") then
			if (self:GetPlayerClass() == "scout") then
				self.playerweapon = "tf_weapon_bat"
			end
		elseif (string.find(self:GetActiveWeapon():GetClass(),"minigun") || string.find(self:GetActiveWeapon():GetClass(),"minifun") || string.find(self:GetActiveWeapon():GetClass(),"gatling")) then
			self.playerweapon = "tf_weapon_minigun"
		else
			self.playerweapon = self:GetActiveWeapon():GetClass() 
		end
		if self:GetActiveWeapon().GetItemData then
			self.item_name = self:GetActiveWeapon():GetItemData().name or ""
			self.item_type_name = self:GetActiveWeapon():GetItemData().item_type_name or ""
		else
			self.item_name = ""
			self.item_type_name = ""
		end
	else
		self.playeranim = ""
	end
	
	-- Health fraction
	self.playerhealthfrac = self:Health()/self:GetMaxHealth()
	
	-- What class the player is looking at
	self.crosshair_on = ""
	self.crosshair_enemy = "Yes"
	
	local start = self:GetShootPos()
	local endpos = start + self:GetAimVector() * 10000
	local tr = util.TraceHull{
		start = start,
		endpos = endpos,
		filter = self,
		mins = Vector(-10, -10, -10),
		maxs = Vector(10, 10, 10),
	}
	
	local class = ""
	if tr.Entity and tr.Entity:IsPlayer() then
		if tr.Entity:GetPlayerClass() == "gmodplayer" then
			class = "sniper"
		elseif tr.Entity:GetPlayerClass() == "medicshotgun" then
			class = "medic"
		else
			class = tr.Entity:GetPlayerClass()
		end
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_combine_s" then
		class = "soldier"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_metropolice" then
		class = "metrocop"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_kleiner" then
		class = "medic"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_eli" then
		class = "medic"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_barney" then
		class = "medic"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_citizen" then
		class = "engineer"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_breen" then
		class = "scout"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_vortigaunt" then
		class = "heavy"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() then
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	end
	self.crosshair_on = class
	
	-- Temporary
	self.GameRound = 5
	if self:IsLoser() then
		self.OnWinningTeam = 0
	else
		self.OnWinningTeam = 1
	end
	----------------------------------------------------------------
	
	local response = SelectResponse(self, dbg)
	
	if response then
		return PlayResponse(self, response, nospeech, dbg)
	end
	
	return false
end

function META:Taunt(concept, nospeech, dbg)
	if not self:Alive() then
		return false
	end
	--[[
	if not nospeech then
		Msg("Concept : "..concept.."\n")
	end]]
	
	----------------------------------------------------------------
	
	-- Which concept we want to play
	self.Concept = tostring(concept)
	
	-- Random number
	self.randomnum = math.random(0,100)
	
	-- Current weapon
	if IsValid(self:GetActiveWeapon()) then
		if (self:GetActiveWeapon():GetClass() == "tf_weapon_allclass") then
			if (self:GetPlayerClass() == "engineer") then
				self.playerweapon = "tf_weapon_wrench"
			elseif (self:GetPlayerClass() == "heavy") then
				self.playerweapon = "tf_weapon_fists"
			elseif (self:GetPlayerClass() == "pyro") then
				self.playerweapon = "tf_weapon_fireaxe"
			elseif (self:GetPlayerClass() == "demoman") then
				self.playerweapon = "tf_weapon_grenadelauncher"
			elseif (self:GetPlayerClass() == "scout") then
				self.playerweapon = "tf_weapon_bat"
			elseif (self:GetPlayerClass() == "soldier") then
				self.playerweapon = "tf_weapon_shovel"
			elseif (self:GetPlayerClass() == "medic") then
				self.playerweapon = "tf_weapon_bonesaw"
			elseif (self:GetPlayerClass() == "sniper") then
				self.playerweapon = "tf_weapon_club"
			elseif (self:GetPlayerClass() == "spy") then
				self.playerweapon = "tf_weapon_knife"
			end
		elseif (self:GetActiveWeapon():GetClass() == "tf_weapon_bat_giftwrap") then
			if (self:GetPlayerClass() == "scout") then
				self.playerweapon = "tf_weapon_bat"
			end
		elseif (string.find(self:GetActiveWeapon():GetClass(),"minigun") || string.find(self:GetActiveWeapon():GetClass(),"minifun") || string.find(self:GetActiveWeapon():GetClass(),"gatling")) then
			self.playerweapon = "tf_weapon_minigun"
		else
			self.playerweapon = self:GetActiveWeapon():GetClass()
		end
		if self:GetActiveWeapon().GetItemData then
			self.item_name = self:GetActiveWeapon():GetItemData().name or ""
			self.item_type_name = self:GetActiveWeapon():GetItemData().item_type_name or ""
		else
			self.item_name = ""
			self.item_type_name = ""
		end
	else
		self.playeranim = ""
	end
	
	-- Health fraction
	self.playerhealthfrac = self:Health()/self:GetMaxHealth()
	
	-- What class the player is looking at
	self.crosshair_on = ""
	self.crosshair_enemy = "No"
	
	local start = self:GetShootPos()
	local endpos = start + self:GetAimVector() * 10000
	local tr = util.TraceHull{
		start = start,
		endpos = endpos,
		filter = self,
		mins = Vector(-10, -10, -10),
		maxs = Vector(10, 10, 10),
	}
	
	local class = ""
	if tr.Entity and tr.Entity:IsPlayer() then
		if tr.Entity:GetPlayerClass() == "gmodplayer" then
			class = "sniper"
		elseif tr.Entity:GetPlayerClass() == "medicshotgun" then
			class = "medic"
		else
			class = tr.Entity:GetPlayerClass()
		end
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_combine_s" then
		class = "soldier"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_metropolice" then
		class = "metrocop"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_kleiner" then
		class = "medic"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_eli" then
		class = "medic"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_barney" then
		class = "medic"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_citizen" then
		class = "engineer"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_breen" then
		class = "scout"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	elseif tr.Entity and tr.Entity:IsNPC() and tr.Entity:GetClass() == "npc_vortigaunt" then
		class = "heavy"
		-- Capitalize player class because the talker system wants to :/
		class = string.upper(string.sub(class,1,1))..string.sub(class,2)
		
		if self:IsValidEnemy(tr.Entity) then
			self.crosshair_enemy = "Yes"
		end
	end
	self.crosshair_on = class
	
	-- Temporary
	self.GameRound = 5
	if self:IsLoser() then
		self.OnWinningTeam = 0
	else
		self.OnWinningTeam = 1
	end
	----------------------------------------------------------------
	
	local response = SelectResponse(self, dbg)
	
	if response then
		if (concept == "TLK_FIREWEAPON" or concept == "TLK_MINIGUN_FIREWEAPON" or concept == "TLK_PLAYER_TAUNT") then
			return PlayResponse3(self, response, nospeech, dbg)
		else
			return PlayResponse4(self, response, nospeech, dbg)
		end
	end
	
	return false
end
