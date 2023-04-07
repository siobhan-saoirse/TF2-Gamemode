ENT.Type = "point"

local TeamTranslateTable = {
[0] = TEAM_NEUTRAL,
[2] = TEAM_RED,
[3] = TEAM_BLU,
}

function ENT:Initialize()
	print(self)
	PrintTable(self.Properties or {})
	
	-- Bleh, can't create working filters using Lua, so we'll just spawn a similar existing filter and delete this one
	
	--local negated = self.Properties.negated
	local negated = 0
	local teamnum = TeamTranslateTable[self.Properties.teamnum] or TEAM_NEUTRAL
	
	local filter = ents.Create("filter_activator_team")
	filter:SetName(self:GetName().."_alt")
	filter:SetPos(self:GetPos())
	filter:SetKeyValue("filterteam", teamnum)
	filter:SetKeyValue("Negated", negated)
	filter:Spawn()
	
	self:Remove()
end

function ENT:KeyValue(key,value)
	key = string.lower(key)
	
	if not self.Properties then
		self.Properties = {}
	end
	if tonumber(value) then value=tonumber(value) end
	self.Properties[key] = value
end

hook.Add("EntityKeyValue", "TF_OverrideTriggerFilter", function(ent, key, value)
	if string.lower(key)=="filtername" then
		return value.."_alt"
	end
end)