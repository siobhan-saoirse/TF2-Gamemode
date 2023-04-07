if !pac or !isfunction(pac.RegisterEvent) then return end

local plyMeta = FindMetaTable('Player')
local gamemode = engine.ActiveGamemode
local IsTF = function() return gamemode() == 'teamfortress' end
local function try_viewmodel(ent)
	return ent == pac.LocalPlayer:GetViewModel() and pac.LocalPlayer or ent
end

local events = {
	{
		name = 'is_hl2',
		args = {},
		avaliable = function() return plyMeta.IsHL2 ~= nil end,
		func = function(self, eventPart, ent)
			ent = try_viewmodel(ent)
			return ent.IsHL2 and ent:IsHL2() or false
		end
	},
}

for k, v in ipairs(events) do
	local avaliable = v.avaliable
	local eventObject = pac.CreateEvent(v.name, v.args)
	eventObject.Think = v.func

	function eventObject:IsAvaliable()
		return IsTF() and avaliable()
	end

	pac.RegisterEvent(eventObject)
end