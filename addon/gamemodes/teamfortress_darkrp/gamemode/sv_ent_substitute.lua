--[[
local substable = {}
local nametable = {}
local ents_table = {}

function AddSubstituteClass(src, dst)
	substable[src] = dst
end

hook.Add("InitPostEntity", "EntitySubstiteSpawnAll", function()
	for src,dst in pairs(ents_table) do
		if IsValid(dst) then
			dst:Spawn()
		end
		if IsValid(src) then
			src:Remove()
		end
		ents_table[src] = nil
	end
end)

hook.Add("OnEntityCreated", "EntitySubstituteCreate", function(ent)
	if IsValid(ent) and substable[ent:GetClass()] then
		local subs = ents.Create(substable[ent:GetClass()])
		ents_table[ent] = subs
	end
end)

hook.Add("EntityKeyValue", "EntitySubstituteKeyvalue", function(ent, key, value)
	if IsValid(ent) then
		if nametable[value] and not(substable[ent:GetClass()] and key == "targetname") then
			value = nametable[value]
		end
		
		if IsValid(ents_table[ent]) then
			if key == "targetname" then
				nametable[value] = "__subs_"..value
				value = nametable[value]
			end
			
			ents_table[ent]:SetKeyValue(key, value)
		end
		
		return value
	end
end)

AddSubstituteClass("team_control_point", "tf_team_control_point")]]