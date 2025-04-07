-- A timer that resets every time a player is damaged
-- Used for Medigun healing ramp
function GM:ResetLastDamaged(pl)
	pl.LastDamaged = CurTime()
end

-- Kills

function GM:ResetKills(pl)
	pl.AddedKills = nil
	pl.recentkills = 0
end

function GM:AddKill(pl)
	if not pl.AddedKills then pl.AddedKills = {} end
	
	table.insert(pl.AddedKills, 1, CurTime())
	pl.recentkills = pl.recentkills + 1
end

function GM:UpdateKills(pl)
	if not pl.AddedKills then pl.AddedKills = {} end
	
	for i=#pl.AddedKills,1,-1 do 
		if CurTime()-pl.AddedKills[i]>10 then
			table.remove(pl.AddedKills, i)
			pl.recentkills = pl.recentkills - 1
		end
	end
end

-- Cooperations

-- Assist filters
AS_EARLIEST	= 0
AS_LATEST	= 1
AS_LOWEST	= 2
AS_HIGHEST	= 3
AS_ALL		= 4

local AssistOp = {
	[AS_EARLIEST] = function(a, b)
		return a.time < b.time
	end,
	[AS_LATEST] = function(a, b)
		return a.time > b.time
	end,
	[AS_LOWEST] = function(a, b)
		return a.value < b.value
	end,
	[AS_HIGHEST] = function(a, b)
		return a.value > b.value
	end,
	[AS_ALL] = function(a, b)
		return true
	end,
}

-- Assist types

local ASSIST_START	= 0
ASSIST_FIRE		= 0
ASSIST_NORMAL	= 1
ASSIST_BUFF		= 2
ASSIST_HEAL		= 3
ASSIST_JARATE	= 4
local ASSIST_END	= 4

local AssistData = {}

-- Fire assists will be given to the Pyro who did the most afterburn damage to the victim.
AssistData[ASSIST_FIRE]		= {
	display_filter = AS_HIGHEST,
	score_filter = AS_HIGHEST,
}

-- Normal assists will be given to the player who did the most damage to the victim.
AssistData[ASSIST_NORMAL]	= {
	display_filter = AS_HIGHEST,
	score_filter = AS_HIGHEST,
	remove_on_death = true,
	expire_time = 10
}

-- Buff assists will be given to all Soldiers with the Buff Banner/Battalion's Backup deployed near the killer
AssistData[ASSIST_BUFF]		= {
	display_filter = AS_EARLIEST,
	score_filter = AS_ALL,
	remove_on_death = true
}

-- Heal assists will be given to all Medics who are currently healing the killer
AssistData[ASSIST_HEAL]		= {
	display_filter = AS_EARLIEST,
	score_filter = AS_ALL,
	remove_on_death = true
}

-- Jarate assists will be given to the first Sniper who coated the victim in Jarate
AssistData[ASSIST_JARATE]	= {
	display_filter = AS_EARLIEST,
	score_filter = AS_EARLIEST
}

function GM:ResetCooperations(pl)
	pl.DamageCooperations = nil
end

function GM:AddGlobalAssistant(attacker, assistant, value, assist_type, expire_time)
	if not attacker.GlobalAssistants then attacker.GlobalAssistants = {} end
	if not attacker.GlobalAssistants[assist_type] then attacker.GlobalAssistants[assist_type] = {} end
	
	local assist_table = attacker.GlobalAssistants[assist_type]
	if not assist_table[assistant] then assist_table[assistant] = {} end
	
	assist_table[assistant].time = CurTime()
	assist_table[assistant].value = (assist_table[assistant].value or 0) + value
	assist_table[assistant].expire_time = expire_time
end

function GM:RemoveGlobalAssistant(attacker, assistant, assist_type)
	if not attacker.GlobalAssistants then return end
	if not attacker.GlobalAssistants[assist_type] then return end
	
	attacker.GlobalAssistants[assist_type][assistant] = nil
end

function GM:AddDamageCooperation(pl, attacker, value, assist_type, expire_time, extra_info)
	if not pl.DamageCooperations then pl.DamageCooperations = {} end
	
	if not attacker:IsPlayer() and not attacker:IsNPC() then return end
	
	assist_type = assist_type or ASSIST_NORMAL
	local assist_data = AssistData[assist_type]
	if not assist_data then
		ErrorNoHalt(Format("Assist type %d not supported, using normal assist instead", assist_type))
		assist_type = ASSIST_NORMAL
		assist_data = AssistData[assist_type]
	end
	
	--[[
	if attacker==pl.DamageCooperations[1] then return end
	
	if pl.DamageCooperations[2] and pl.DamageCooperations[2][1]==attacker then
		-- If the attacker is already a cooperator, update the time
		pl.DamageCooperations[2][2] = CurTime()
	else
		-- Else, just push it into the table and pop the earliest cooperator
		table.insert(pl.DamageCooperations, {attacker, CurTime()})
		if #pl.DamageCooperations>2 then
			table.remove(pl.DamageCooperations, 1)
		end
	end]]
	
	-- Better assists
	local assist_table
	if not pl.DamageCooperations[assist_type] then
		pl.DamageCooperations[assist_type] = {}
	end
	
	assist_table = pl.DamageCooperations[assist_type]
	
	if not assist_table[attacker] then
		assist_table[attacker] = {}
	end
	
	if not value then
		ErrorNoHalt("WARNING: AddDamageCooperations: value is nil!")
		LAST_DEBUG_INFO = debug.getinfo(2)
	end
	
	assist_table[attacker].time = CurTime()
	assist_table[attacker].value = (assist_table[attacker].value or 0) + (value or 0)
	assist_table[attacker].expire_time = expire_time
	assist_table[attacker].extra_info = extra_info
end

function GM:RemoveDamageCooperation(pl, attacker, assist_type)
	if not pl.DamageCooperations then return end
	if not pl.DamageCooperations[assist_type] then return end
	
	pl.DamageCooperations[assist_type][attacker] = nil
end

function GM:RemoveDamageCooperationPlayer(pl, attacker)
	if not pl.DamageCooperations then return end
	
	for _,v in pairs(pl.DamageCooperations) do
		v[attacker] = nil
	end
end

function GM:RemoveDamageCooperationType(pl, assist_type)
	if not pl.DamageCooperations then return end
	pl.DamageCooperations[assist_type] = nil
end

local function ValidAssist(v, assist_data)
	return v.time < CurTime() and
	(not assist_data.expire_time or CurTime() - v.time < assist_data.expire_time) and
	(not v.expire_time or CurTime() - v.time < v.expire_time)
end

function GM:GetAllAssistants(pl, attacker)
	if not pl.DamageCooperations then
		return {}
	end
	
	local assists = {}
	local tmp = {}
	local assist_table
	local best, bestvalue
	for i=ASSIST_END,ASSIST_START,-1 do
		tmp[1] = (attacker and attacker.GlobalAssistants) and attacker.GlobalAssistants[i]
		tmp[2] = pl.DamageCooperations[i]
		
		for j=1,2 do
			assist_table = tmp[j]
			if assist_table then
				local assist_data = AssistData[i]
				local op = AssistOp[assist_data.score_filter]
				
				if assist_data.score_filter == AS_ALL then
					for k,v in pairs(assist_table) do
						if IsValid(k) and ValidAssist(v, assist_data) and k~=attacker then
							assists[k] = true
						end
					end
				else
					best = nil
					if assist_data.score_filter == AS_EARLIEST or assist_data.score_filter == AS_LOWEST then
						bestvalue = {time=math.huge, value=math.huge}
					elseif assist_data.score_filter == AS_LATEST or assist_data.score_filter == AS_HIGHEST then
						bestvalue = {time=-math.huge, value=-math.huge}
					end
					
					for k,v in pairs(assist_table) do
						if IsValid(k) and ValidAssist(v, assist_data) and k~=attacker and op(v, bestvalue) then
							best = k
							bestvalue = v
						end
					end
					
					if best then
						assists[best] = bestvalue.extra_info or {}
					end
				end
			end
		end
	end
	
	return assists
end

function GM:GetDisplayedAssistant(pl, attacker)
	if not pl.DamageCooperations then
		return
	end
	
	local best, bestvalue
	local tmp = {}
	
	for i=ASSIST_END,ASSIST_START,-1 do
		tmp[1] = (attacker and attacker.GlobalAssistants) and attacker.GlobalAssistants[i]
		tmp[2] = pl.DamageCooperations[i]
		
		for j=1,2 do
			assist_table = tmp[j]
			if assist_table then
				local assist_data = AssistData[i]
				local op = AssistOp[assist_data.display_filter]
				
				best = nil
				if assist_data.display_filter == AS_EARLIEST or assist_data.display_filter == AS_LOWEST then
					bestvalue = {time=math.huge, value=math.huge}
				elseif assist_data.display_filter == AS_LATEST or assist_data.display_filter == AS_HIGHEST then
					bestvalue = {time=-math.huge, value=-math.huge}
				end
				
				for k,v in pairs(assist_table) do
					if IsValid(k) and ValidAssist(v, assist_data) and k~=attacker and op(v, bestvalue) then
						best = k
						bestvalue = v
					end
				end
				
				if best then
					return best
				end
			end
		end
	end
end

function GM:RemoveDamageCooperationsOnDeath(attacker)
	for _,v in pairs(ents.GetAll()) do
		if v:IsTFPlayer() and v.DamageCooperations then
			for assist_type, data in pairs(v.DamageCooperations) do
				if AssistData[assist_type].remove_on_death then
					data[attacker] = nil
				end
			end
		end
	end
end

-- Dominations

function GM:TriggerDomination(pl, attacker)
	if not pl.Dominators then
		pl.Dominators = {}
	end
	
	if pl.Dominators[attacker] then
		return
	end
	
	pl.Dominators[attacker] = true
	attacker.domination = "dominated"
	
	gamemode.Call("OnTFPlayerDominated", pl, attacker)
end

function GM:TriggerRevenge(pl, attacker)
	if not attacker.Dominators then
		attacker.Dominators = {}
	end
	
	if not attacker.Dominators[pl] then
		return
	end
	
	attacker.Dominators[pl] = nil
	attacker.domination = "revenge"
	
	gamemode.Call("OnTFPlayerRevenge", pl, attacker)
end

function GM:PlayerIsNemesis(pl1, pl2)
	if pl2.Dominators and pl2.Dominators[pl1] then
		return true
	end
	
	return false
end

function GM:ClearDominations(pl)
	pl.Dominators = nil
	pl.KillComboCounter = nil
	
	umsg.Start("PlayerResetDominations")
		umsg.Entity(pl)
	umsg.End()
end

hook.Add("PlayerAuthed", "TFSendPlayerDominations", function(pl)
	for _,v in pairs(player.GetAll()) do
		if v.Dominators then
			local num = 0
			for d,_ in pairs(v.Dominators) do
				if IsValid(d) then
					num = num + 1
				else
					v.Dominators[d] = nil
				end
			end
			
			if num > 0 then
				umsg.Start("SendPlayerDominations", pl)
					umsg.Entity(pl)
					umsg.Char(num)
					for d,_ in pairs(v.Dominators) do
						umsg.Entity(d)
					end
				umsg.End()
			end
		end
	end
end)

-- Managing crits

local debug_crits = CreateConVar("debug_crits", "0", {FCVAR_NOTIFY,FCVAR_CHEAT})

function GM:AddCritBoostTime(pl, time)
	local w = pl:GetActiveWeapon()
	
	if not pl.NextCritBoostExpire or CurTime()>pl.NextCritBoostExpire then
		pl.NextCritBoostExpire = CurTime()
		self:StartCritBoost(pl)
		
		if IsValid(w) and w.OnCritBoostStarted then
			w:OnCritBoostStarted()
		end
	else
		if IsValid(w) and w.OnCritBoostAdded then
			w:OnCritBoostAdded()
		end
	end
	timer.Stop("CritEnd"..pl:EntIndex())
	timer.Create("CritEnd"..pl:EntIndex(),time,1,function()
		GAMEMODE:StopCritBoost(pl)
	end)
end

function GM:StartCritBoost(pl, slotconstraint)
	if pl.CritBoostType == 2 then
		pl:RemovePlayerState(PLAYERSTATE_MINICRIT)
	end
	pl:StopSound("Weapon_General.CritPower")
	pl:EmitSound("Weapon_General.CritPower")
	pl.CritBoostType = 1
	pl.CritBoostSlotConstraint = slotconstraint
	pl:AddPlayerState(PLAYERSTATE_CRITBOOST, true)
	
	if pl:GetActiveWeapon().RollCritical then
		pl:GetActiveWeapon():RollCritical()
	end
end

function GM:StopCritBoost(pl)
	pl.CritBoostType = nil
	pl.CritBoostSlotConstraint = nil
	if (pl:HasPlayerState(PLAYERSTATE_CRITBOOST)) then
		--pl:EmitSound("TFPlayer.CritBoostOff")
	end
	pl:StopSound("Weapon_General.CritPower")
	pl:RemovePlayerState(bit.bor(PLAYERSTATE_CRITBOOST,PLAYERSTATE_MINICRIT), true)
	
	pl.NextCritBoostExpire = nil

	if pl:GetActiveWeapon().RollCritical then
		-- we need to roll a critical again, else when the crit boost expires, the next shot will still be a guaranteed crit
		pl:GetActiveWeapon():RollCritical()
	end
end

function GM:StartMiniCritBoost(pl, slotconstraint)
	pl.CritBoostType = 2
	pl.CritBoostSlotConstraint = slotconstraint
	pl:StopSound("Weapon_General.CritPower")
	pl:EmitSound("Weapon_General.CritPower")
	pl:AddPlayerState(PLAYERSTATE_MINICRIT, true)
end

function GM:StopMiniCritBoost(pl)
	pl.CritBoostType = nil
	pl.CritBoostSlotConstraint = nil
	pl:StopSound("Weapon_General.CritPower")
	pl:RemovePlayerState(PLAYERSTATE_MINICRIT, true)
end

function GM:ResetDamageCounter(pl)
	pl.DamageSum = nil
	pl.DamageDealtThisSecond = nil
	pl.DamageTable = nil
	pl.NextCritBoostExpire = nil
end

function GM:AddTotalDamage(pl, dmg)
	if not pl.DamageDealtThisSecond then pl.DamageDealtThisSecond = 0 end
	if not pl.DamageSum then pl.DamageSum = 0 end
	
	pl.DamageDealtThisSecond = pl.DamageDealtThisSecond + dmg
	pl.DamageSum = pl.DamageSum + dmg
end

function GM:UpdateTotalDamage(pl)
	if not pl.DamageTable then
		pl.DamageTable = {}
	end
	if not pl.DamageSum then pl.DamageSum = 0 end
	if not pl.DamageDealtThisSecond then pl.DamageDealtThisSecond = 0 end
	
	table.insert(pl.DamageTable, pl.DamageDealtThisSecond)
	
	if #pl.DamageTable>20 then
		pl.DamageSum = pl.DamageSum - table.remove(pl.DamageTable, 1)
	end
	
	pl.DamageDealtThisSecond = 0
end

function GM:RollCritical(pl)
	if not IsValid(pl) then return end
	
	local crits = debug_crits:GetInt()
	if crits==1 then -- Always crit
		--pl.NextShotIsCritical = true
		pl:SetNWBool("NextShotIsCritical", true)
		return
	end
	
	local w = pl:GetActiveWeapon()
	if pl.CritBoostType == 1 then
		if not pl.CritBoostSlotConstraint or (w.GetItemData and w:GetItemData().item_slot == pl.CritBoostSlotConstraint) then
			--pl.NextShotIsCritical = true
			pl:SetNWBool("NextShotIsCritical", true)
			return
		end
	end
	
	--pl.NextShotIsCritical = false
	if crits==-1 then -- Never crit
		pl:SetNWBool("NextShotIsCritical", false)
		return
	end
	
	-- you're covered in piss mate, no crits for you, wanker
	if pl:HasPlayerState(PLAYERSTATE_JARATED) then
		pl:SetNWBool("NextShotIsCritical", false)
		return
	end
	-- THAT IS DISGUSTING, WHY WOULD YOU DO THAT
	if pl:HasPlayerState(PLAYERSTATE_PUKEDON) then
		pl:SetNWBool("NextShotIsCritical", false)
		return
	end
	
	if not pl.DamageSum or pl.CritsDisabled then
		pl:SetNWBool("NextShotIsCritical", false)
		return
	end
	
	local w = pl:GetActiveWeapon()
	
	if not w or not w:IsValid() or not w.CriticalChance or w.CriticalChance<=0 then
		pl:SetNWBool("NextShotIsCritical", false)
		return
	end
	
	local chance = w.CriticalChance
	
	
	if pl.CritsOnly then -- 100% crits buff, during humiliation on the winning team for example
		chance = 100
	else
		-- Crit chance bonus based on damage, can go up to 10%
		chance = chance + math.Clamp(pl.DamageSum / 80, 0, 10)
	end
	
	if math.random(1,76)<=chance then
		-- critz omgomgomgomgomgomg
		pl:SetNWBool("NextShotIsCritical", true)
		--pl.NextShotIsCritical = true
		--pl:ChatPrint(Format("Rolling crit (%d%%): Success!",chance))
	else
		pl:SetNWBool("NextShotIsCritical", false)
		--pl:ChatPrint(Format("Rolling crit (%d%%): Fail!",chance))
	end
end
function GM:Tick()
end
local function CopyPoseParams(pEntityFrom, pEntityTo)
	if (SERVER) then
		for i = 0, pEntityFrom:GetNumPoseParameters() - 1 do
			local sPose = pEntityFrom:GetPoseParameterName(i)
			pEntityTo:SetPoseParameter(sPose, pEntityFrom:GetPoseParameter(sPose))
		end
	else
		for i = 0, pEntityFrom:GetNumPoseParameters() - 1 do
			local flMin, flMax = pEntityFrom:GetPoseParameterRange(i)
			local sPose = pEntityFrom:GetPoseParameterName(i)
			pEntityTo:SetPoseParameter(sPose, math.Remap(pEntityFrom:GetPoseParameter(sPose), 0, 1, flMin, flMax))
		end
	end
end
function GM:Think()
	for _,v in pairs(player.GetAll()) do
		if (IsValid(v.PuppetAnim)) then
			CopyPoseParams(v,v.PuppetAnim:GetPuppeteer())
			v.PuppetAnim:GetPuppeteer():SetSequence(v:GetSequence())
			v.PuppetAnim:GetPuppeteer():SetPlaybackRate(1)
			v.PuppetAnim:GetPuppeteer():SetCycle(v:GetCycle())
			v.PuppetAnim:GetPuppeteer():SetEnableAnimEventEffects(false)
			v.PuppetAnim:GetPuppeteer():SetPuppeteerAlpha(false)
			v.PuppetAnim:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			v.PuppetAnim:GetPuppeteer():SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		end
		for _,child in ipairs(ents.GetAll()) do
			if (child:GetParent():EntIndex() == v:EntIndex()) then
				--child:SetMaterial(v:GetMaterial())
			end
		end
		if (v:Alive()) then
			if (v:IsHL2()) then		  
				v:SetViewOffset(Vector(0,0,64 * v:GetModelScale()))
				v:SetViewOffsetDucked(Vector(0, 0, 28 * v:GetModelScale()))
			else
				if (v.playerclass == "Scout" or v.playerclass == "Soldier"
					or v.playerclass == "Pyro" or v.playerclass == "Demoman" or v.playerclass == "Engineer") then
					v:SetViewOffset(Vector(0, 0, 65 * v:GetModelScale()))
					v:SetViewOffsetDucked(Vector(0, 0, 28 * v:GetModelScale()))
				else
					v:SetViewOffset(Vector(0, 0, 75 * v:GetModelScale()))
					v:SetViewOffsetDucked(Vector(0, 0, 28 * v:GetModelScale()))
				end
			end
		end
		
		if (v:GetNWBool("Taunting",false) == true) then
			if (v:IsOnGround()) then
				v:SetVelocity(Vector(0,0,0))
			end
		end
	end
	if (math.random(1,2+(table.Count(player.GetAll())*2))) then
		if not self.NextUpdateDamage or CurTime()>self.NextUpdateDamage then
			for _,v in pairs(player.GetAll()) do
				-- Update damage dealt in the last 20 seconds for every player
				self:UpdateTotalDamage(v)
				self:UpdateKills(v)
				
				-- Roll critical hits for rapidfire weapons
				local w = v:GetActiveWeapon()
				if w and w:IsValid() and w.CriticalChance and w.IsRapidFire then
					self:RollCritical(v)
				end
			end
			
			self.NextUpdateDamage = CurTime() + 1
		end
		for k, v in ipairs(ents.GetAll()) do
			if (v:GetClass() == "gmod_tool" && GetConVar("tf_competitive"):GetBool() && IsValid(v:GetOwner()) and !v:GetOwner():IsAdmin()) then
				v:Remove()
			end
		end
		for k, self in ipairs(player.GetAll()) do
			if (self:IsNextBot()) then
				for p, ply in ipairs(player.GetAll()) do
					if(ply:EyePos():Distance(self:EyePos()) <= 300) then
						self:SetEyeTarget(ply:EyePos())
					end
				end
			end
		end
		for _,pl in ipairs(player.GetAll()) do
			for p, ply in ipairs(player.GetAll()) do
				if(ply:EntIndex() != pl:EntIndex() and ply:EyePos():Distance(pl:EyePos()) <= 300) then
					pl:SetEyeTarget(ply:EyePos())
				end
			end
			if (IsValid(pl.ShovedAnimation)) then
				pl:SetAngles(pl.ShovedAnimation:GetAngles())
				pl.ShovedAnimation.IsVJBaseSNPC = false
			end
			if (pl:Health() > pl:GetMaxHealth()) then

				if not pl.NextHealthDecay then
					pl.NextHealthDecay = CurTime() + 0.2
				elseif CurTime() >= pl.NextHealthDecay then
					pl:SetHealth(pl:Health() - 1)
					pl.NextHealthDecay = CurTime() + 0.2
				end

			end
			for k,v in ipairs(ents.FindInSphere(pl:GetShootPos() * 1.05,80 * pl:GetModelScale() * 1.01)) do
			
				if (pl:IsPlayer() and !pl:IsHL2() and IsValid(pl:GetActiveWeapon()) and pl.IsTFWeapon) then
					
					if (pl:GetActiveWeapon():GetItemData().item_name and pl:GetActiveWeapon():GetItemData().item_name == "#TF_Minigun_Deflector" and (string.find(v:GetClass(), "tf_projectile_") or v:GetClass() == "prop_combine_ball" or v:GetClass() == "rpg_missile" or v:GetCollisionGroup() == COLLISION_GROUP_PROJECTILE) and pl:KeyDown(IN_ATTACK)) then
					
						v:EmitSound("Halloween.HeadlessBossAxeHitWorld")
						
						local effectdata = EffectData()
							effectdata:SetOrigin(v:GetPos())
							effectdata:SetNormal(Vector(0,0,1))
							effectdata:SetMagnitude(2)
							effectdata:SetScale(1)
							effectdata:SetRadius(5)
						util.Effect("Sparks", effectdata)
						
						v:Remove()

					end
					
				end
				
			end
		end
		for _,bot in pairs(player.GetBots()) do
			if (string.find(bot:GetModel(),"/bot_")) then
				GAMEMODE:GiveAmmoPercent(bot, 100)
			end
		end
	end
	--[[
	if not self.NextLoopExpression or CurTime()>self.NextLoopExpression then
		for _,v in pairs(player.GetAll()) do
			v:Speak("TLK_PLAYER_EXPRESSION", true)
		end
		
		self.NextLoopExpression = CurTime() + 5
	end]]
end
 
--[[
hook.Add("Move", "TFPlayerSlowdown", function(pl, move)
	-- Players run 10% slower when moving backwards
	local fw = move:GetForwardSpeed()
	local sd = move:GetSideSpeed()
	
	local sp = pl:GetRealClassSpeed() * pl:GetNWFloat()
	
	if fwd<0 then
		local sp = -pl:GetRealClassSpeed() * 0.9
		if fwd<sp then
			move:SetForwardSpeed(sp)
		end
	end
end)
]]
hook.Add("Think", "TFPlayerThink", function()
		for v,_ in pairs(entset.GetTFPlayers()) do
			--------------------------------------------------------
			-- Overheal
			if v:IsValid() then
			local health, maxhealth = v:Health(), v:GetMaxHealth()
			if maxhealth>0 then -- Some particuliar NPCs have a max health of 0, do not take overhealing into consideration
				if not v.OverhealDecreasePeriod or v.CurrentMaxHealth~=maxhealth then
					-- A full overheal  (+50% max health) takes exactly 20 seconds to fade out
					v.OverhealDecreasePeriod = 20/(maxhealth * 0.5)
					v.CurrentMaxHealth = maxhealth
				end
				
				if (not v.NextOverhealThink or CurTime()>v.NextOverhealThink) and health>maxhealth then
					health = health-1
					v:SetHealth(health)
					v.NextOverhealThink = CurTime() + v.OverhealDecreasePeriod
				end
				
				if health<=maxhealth then
					v:RemovePlayerState(PLAYERSTATE_OVERHEALED, true)
				else
					v:AddPlayerState(PLAYERSTATE_OVERHEALED, true)
				end
			end
			end
			
			-- Update the Networked health for all NPCs
			if IsValid(v) and v:IsNPC() then
				if (v:GetNPCData()) then
					if not v.LastHealth and v:GetNPCData().health then
						v:ResetMaxHealth()
						v:ResetHealth()
					end
					
					v.LastHealth = v:HealthOLD()
					v:SetNWInt("Health", v.LastHealth)
				end
			end
			
			--------------------------------------------------------
			-- Fire
			
			-- now handled by tf_entityflame
			
			--[[
			if v.NextExtinguish then
				if v:WaterLevel()>2 or CurTime()>v.NextExtinguish or (v:IsPlayer() and not v:Alive()) then
					GAMEMODE:ExtinguishEntity(v)
				elseif not v.NextBurn or CurTime()>v.NextBurn then
					local attacker = v.LastIgniter or v
					local dmginfo = DamageInfo()
						dmginfo:SetAttacker(attacker)
						dmginfo:SetInflictor(attacker)
						dmginfo:SetDamage(3)
						dmginfo:SetDamageType(DMG_BURN|DMG_DIRECT)
						dmginfo:SetDamagePosition(v:GetPos())
					v:TakeDamageInfo(dmginfo)
					v.NextBurn = CurTime() + 0.5
				end
			end]]
			
			--------------------------------------------------------
			-- Removing Jarate effects
			
			if v.NextEndJarate and (v:WaterLevel()>2 or CurTime()>v.NextEndJarate) then
				v.NextEndJarate = nil
				v:RemovePlayerState(PLAYERSTATE_JARATED, true)
			end
			
			--------------------------------------------------------
			-- Removing Mad Milk effects
			
			if v.NextEndMilk and CurTime()>v.NextEndMilk then
				v.NextEndMilk = nil
				v:RemovePlayerState(PLAYERSTATE_MILK, true)
			end
			
			--------------------------------------------------------
			-- Recharging weapons (Jarate, Sandman, etc...)
			
			if v:IsPlayer() and v.NextGiveAmmo and CurTime()>v.NextGiveAmmo then
				if v.NextGiveAmmoType then
					v:GiveAmmo(1, v.NextGiveAmmoType)
				end
				v.NextGiveAmmo = nil
			end
			
			--------------------------------------------------------
			-- Critical boost expired, remove the crit effect
			
			if v:IsPlayer() and v.NextCritBoostExpire and CurTime()>v.NextCritBoostExpire then
				--GAMEMODE:StopCritBoost(v)
			end
			
			--------------------------------------------------------
			-- Thrown by explosion
			
			if v:IsThrownByExplosion() and v:OnGround() then
				v:SetThrownByExplosion(false)
			end
			
			--------------------------------------------------------
			-- Updating stats
			
			if not v.NextUpdateHealStats or CurTime() > v.NextUpdateHealStats then
				if v.AddedHealing then
					if v.AddedHealing ~= 0 then
						v:AddHealing(v.AddedHealing)
					end
				end
				if v and v.AddedHealing and isnumber(v.AddedHealing) then
					v.AddedHealing = 0
				end
				if v and v.HealingScoreProgress and isnumber(v.HealingScoreProgress) then
					local score = 0
					while v.HealingScoreProgress > 600 do
						v.HealingScoreProgress = v.HealingScoreProgress - 600
						score = score + 1
					end
					if score > 0 then v:AddFrags(score) end
				end
				if v.NextUpdateHealStats then
					v.NextUpdateHealStats = CurTime() + 2
				end
			end
			
			--------------------------------------------------------
			-- Player-only attributes
			
			local TA
			if IsValid(v) and v:IsPlayer() and v:Alive() and v.TempAttributes and TA then
				TA = v.TempAttributes
			end
			if TA then
				--------------------------------------------------------
				-- Health regeneration/drain
				
				if not TA.NextHealthRegen then
					TA.NextHealthRegen = CurTime() + 1
				elseif CurTime() >= TA.NextHealthRegen then
					--local h = TA.HealthRegen or 0
					local data = {health = 0}
					
					if v:GetPlayerClassTable().HasMedicRegeneration then
						data.health = 2
					end
					
					if v:IsPlayer() and IsValid(v:GetActiveWeapon()) then
						ApplyAttributesFromEntity(v:GetActiveWeapon(), "health_regen", v, data)
					end
					ApplyGlobalAttributesFromPlayer(v, "health_regen", v, data)
					
					v:GiveHealth(math.floor(data.health))
					TA.NextHealthRegen = CurTime() + 1
				end
				
				
				--------------------------------------------------------
				-- Ammo regeneration/drain
				
				if not TA.NextAmmoRegen then
					TA.NextAmmoRegen = CurTime() + 5
				elseif CurTime() >= TA.NextAmmoRegen then
					local data = {}
					
					if v:IsPlayer() and IsValid(v:GetActiveWeapon()) then
						ApplyAttributesFromEntity(v:GetActiveWeapon(), "ammo_regen", v, data)
					end
					ApplyGlobalAttributesFromPlayer(v, "ammo_regen", v, data)
					
					for ammo,count in pairs(data) do
						v:GiveTFAmmo(count,ammo)
					end
					TA.NextAmmoRegen = CurTime() + 5
				end
			end
		end
end)