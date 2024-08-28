
function MsgF(msg, ...)
	local ok, res = pcall(Format, msg, ...)
	
	if ok then
		Msg(res)
	else
		local info = debug.getinfo(2)
		Error(Format("%s:%d: Error in MsgF '%s'", info.short_src, info.currentline, res))
	end
end

function MsgFN(msg, ...)
	local ok, res = pcall(Format, msg, ...)
	
	if ok then
		MsgN(res)
	else
		local info = debug.getinfo(2)
		Error(Format("%s:%d: Error in MsgFN '%s'", info.short_src, info.currentline, res))
	end
end
--[[
if CLIENT then

datastream.Hook("StreamDebugMessage", function(handler, id, enc, dec)
	print(dec[1])
end)

end
--]]
if SERVER then

function StreamDebugMessage(msg, rf)
	datastream.StreamToClients(rf or player.GetAll(), "StreamDebugMessage", {msg})
end

function CopyDamageInfo(dmg)
	local dmg2 = DamageInfo()
	dmg2:SetAttacker(dmg:GetAttacker())
	dmg2:SetInflictor(dmg:GetInflictor())
	dmg2:SetDamage(dmg:GetDamage())
	dmg2:SetDamageForce(dmg:GetDamageForce())
	dmg2:SetDamagePosition(dmg:GetDamagePosition())
	dmg2:SetDamageType(dmg:GetDamageType())
	dmg2:SetMaxDamage(dmg:GetMaxDamage())
	return dmg2
end

local DAMAGETYPES = {
"GENERIC",
"CRUSH",
"BULLET",
"SLASH",
"BURN",
"VEHICLE",
"FALL",
"BLAST",
"CLUB",
"SHOCK",
"SONIC",
"ENERGYBEAM",
"PREVENT_PHYSICS_FORCE",
"NEVERGIB",
"ALWAYSGIB",
"DROWN",
"PARALYZE",
"NERVEGAS",
"POISON",
"RADIATION",
"DROWNRECOVER",
"ACID",
"SLOWBURN",
"REMOVENORAGDOLL",
"PHYSGUN",
"PLASMA",
"AIRBOAT",
"DISSOLVE",
"BLAST_SURFACE",
"DIRECT",
"BUCKSHOT",
}

local function ctakedamageinfo_tostring(self)
	local damagetype, pos, force, adr
	
	_R.CTakeDamageInfo.__tostring = nil
	adr = string.match(tostring(self), "CTakeDamageInfo: (%x+)")
	_R.CTakeDamageInfo.__tostring = ctakedamageinfo_tostring
	
	pos = self:GetDamagePosition()
	force = self:GetDamageForce()
	damagetype = ""
	
	for _,v in ipairs(DAMAGETYPES) do
		if self:IsDamageType(_E["DMG_"..v]) then
			damagetype = damagetype.."|"..v
		end
	end
	
	if #damagetype>0 then
		damagetype = string.sub(damagetype, 2)
	end
	
	return Format("[%s -> %f damage done (max. %f) by %s using %s, type <%s>, pos(%f,%f,%f), force(%f,%f,%f)]",
		adr,
		self:GetDamage(),
		self:GetMaxDamage(),
		tostring(self:GetAttacker()),
		tostring(self:GetInflictor()),
		damagetype,
		pos.x,pos.y,pos.z,
		force.x,force.y,force.z)
end

local META = FindMetaTable("CTakeDamageInfo")

META.__tostring = ctakedamageinfo_tostring

function META:Duplicate()
	local dmg2 = DamageInfo()
	dmg2:SetAttacker(self:GetAttacker())
	dmg2:SetInflictor(self:GetInflictor())
	dmg2:SetDamage(self:GetDamage())
	dmg2:SetDamageForce(self:GetDamageForce())
	dmg2:SetDamagePosition(self:GetDamagePosition())
	dmg2:SetDamageType(self:GetDamageType())
	dmg2:SetMaxDamage(self:GetMaxDamage())
	return dmg2
end

end

local EntitySet_All = {}
local EntitySet_Players = {}
local EntitySet_NPCs = {}
local EntitySet_TFPlayers = {}
local EntitySet_Teams = {}

local function UpdateEntityTeam(ent, t)
	if ent.__EntityTeam and EntitySet_Teams[ent.__EntityTeam] then
		EntitySet_Teams[ent.__EntityTeam][ent] = nil
	end
	
	t = t or GAMEMODE:EntityTeam(ent)
	
	if t == TEAM_NEUTRAL then
		ent.__EntityTeam = nil
		return
	end
	
	ent.__EntityTeam = t
	
	if not EntitySet_Teams[t] then
		EntitySet_Teams[t] = {}
	end
	EntitySet_Teams[t][ent] = true
end

hook.Add("OnEntityCreated", "TrackEntityTypesCreated", function(ent)
	if not IsValid(ent) then return end
	
	EntitySet_All[ent] = true
	if ent:IsPlayer() then
		EntitySet_TFPlayers[ent] = true
		EntitySet_Players[ent] = true
	elseif ent:IsNPC() then
		EntitySet_TFPlayers[ent] = true
		EntitySet_NPCs[ent] = true
	end
	
	--UpdateEntityTeam(ent)
end)

hook.Add("EntityRemoved", "TrackEntityTypesRemoved", function(ent)
	EntitySet_All[ent] = nil
	EntitySet_Players[ent] = nil
	EntitySet_NPCs[ent] = nil
	EntitySet_TFPlayers[ent] = nil
	
	--[[if ent.__EntityTeam and EntitySet_Teams[ent.__EntityTeam] then
		EntitySet_Teams[ent.__EntityTeam][ent] = nil
	end]]
end)

entset = {}

function entset.GetAll()
	return EntitySet_All
end

function entset.GetPlayers()
	return EntitySet_Players
end

function entset.GetNPCs()
	return EntitySet_NPCs
end

function entset.GetTFPlayers()
	return EntitySet_TFPlayers
end

function entset.GetTeam(t)
	return EntitySet_Teams[t] or {}
end
