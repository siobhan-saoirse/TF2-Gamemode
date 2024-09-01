
module("tf_util", package.seeall)

if CLIENT then

DebugInfoLines = {}

function AddDebugInfo(id, func)
	table.insert(DebugInfoLines, {id,func})
end

function RemoveDebugInfo(id)
	for i=#DebugInfoLines,1,-1 do
		if DebugInfoLines[i][1]==id then
			table.remove(DebugInfoLines, i)
		end
	end
end

hook.Add("HUDPaint", "DebugInfoHUDPaint", function()
	for k,v in ipairs(DebugInfoLines) do
		draw.Text{text=v[2](),pos={5, 10*k-5}}
	end
end)

end

--[[
Calculates damage based on distance and various factors

float BaseDamage : The base amount of damage dealt
float MaxDamageFalloff : The maximum damage falloff at long range (default=0)
float MaxDamageRampUp : The maximum damage buff at close range (default=0)
float DamageModifier : A multiplier that affects damage only when it's not critical (default=1)
float DamageRandomize

vector Src : Where the projectile came from
vector HitPos : Where the projectile hit

bool Critical : Is the projectile critical? (default=false)
float CritDamageMultiplier : Critical damage multiplier (default=3)


can be called either using tf_util.CalculateDamage(table) or tf_util.CalculateDamage(weapon, hitpos)
]]

local tf_damage_disablespread = CreateConVar("tf_damage_disablespread", 1, {FCVAR_NOTIFY,FL_REPLICATED})

function CalculateDamage(data, hitpos, srcpos)
	if tf_damage_disablespread:GetBool() then
		return data.BaseDamage
	end
	
	local dist, falloff, damage
	local src, hit, crit
	
	if (data.GetPos and data:GetPos()) or srcpos then
		src = srcpos or data:GetPos()
		hit = hitpos
		crit = (data.Critical and data:Critical())
	else
		src = data.Src
		hit = data.HitPos
		crit = data.Critical
	end
	
	damage = data.BaseDamage
	
	return damage
end

function IsHL1SwepsMounted()
	for k, v in pairs(engine.GetAddons()) do 
		----print("addon "..v.wsid.." aka "..v.title.." has been detected!")
		if v.wsid == "1360233031" and v.mounted == true then
			return true
		end
	end
	return false
end
function CalculateDamageRanged(data, hitpos, srcpos)
	return data.BaseDamage
end 

-- Performs a traceline first, and if the hit entity doesn't match the condition, perform a tracehull
-- Additional condition checking parameters can be given, such as the entity which fired the trace

local function default_trace_condition(tr)
	return tr.Hit and IsValid(tr.Entity)
end

function MixedTrace(tracedata, condition, ...)
	condition = condition or default_trace_condition
	local tr = util.TraceLine(tracedata);
	if not condition(tr, ...) then
		tr = util.TraceHull(tracedata);
	end
	return tr
end

-- Performs a traceline with a callback instead of a filter (return false or nil to stop tracing)
function TraceLineWithCallback(tracedata)
	if not tracedata.callback then
		-- hurr
		return util.TraceLine(tracedata)
	end
	
	local filter = {}
	if tracedata.filter then
		if type(tracedata.filter) == "table" then
			table.Merge(filter, tracedata.filter)
		else
			table.insert(filter, tracedata.filter)
		end
	end
	tracedata.filter = filter
	
	local length = (tracedata.endpos - tracedata.start):Length()
	local res
	repeat
		res = util.TraceLine(tracedata)
		if tracedata.callback(res) then
			break
		end
		
		local frac = res.Fraction
		if (res.HitWorld or res.HitSky) and length > 0 then
			frac = frac + 0.1 / length
		elseif IsValid(res.Entity) then
			table.insert(tracedata.filter, res.Entity)
		end
		tracedata.start = LerpVector(frac, tracedata.start, tracedata.endpos)
		length = length * (1-frac)
	until not res.Hit
	
	return res
end

RegisteredModels = {}

function ReadActivitiesFromModel(ent)
	if not util.IsValidModel(ent:GetModel() or "") then return end
	
	if not RegisteredModels[ent:GetModel()] then
		--MsgFN("Reading activities from '%s'", ent:GetModel())
		local i = 0
		while ent:GetSequenceName(i)~="Unknown" do
			local act = string.upper(ent:GetSequenceActivityName(i))
			if act~="" and not _G[act] then
				_G[act] = ent:GetSequenceActivity(i)
				
				--[[if act == "ACT_MELEE_VM_HITCENTER" then
					MsgFN("Setting %s to %d (model='%s' entity=%s owner=%s)", act, _G[act], ent:GetModel(), tostring(ent), tostring(ent:GetOwner()))
				end]]
			end
			i = i+1
		end
		RegisteredModels[ent:GetModel()] = true
	end
end

local LastDebugInfo = {__default={}}
function SaveFullDebugInfo(name)
	local t = {}
	local i = 0
	repeat
		local info = debug.getinfo(i)
		t[i] = info
		i = i+1
	until not info
	
	LastDebugInfo[name or "__default"] = t
end

function PrintLastDebugInfo(name)
	for lvl, inf in ipairs(LastDebugInfo[name or "__default"] or {}) do
		MsgFN("Level %d", lvl)
		for k,v in SortedPairs(inf) do
			MsgFN("\t%s\t= %s", tostring(k), tostring(v))
		end
	end
end