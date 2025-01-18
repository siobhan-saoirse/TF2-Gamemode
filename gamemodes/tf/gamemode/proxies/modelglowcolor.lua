
local DefaultGlowColor = Vector(1.0, 1.0, 1.0)

--[[local ]]
GlowColorTable = {
	{	-- red
		Vector(14.0, 1.0, 1.0),	-- crit
		Vector(9.0, 4.0, 1.0),	-- minicrit
	},
	{	-- blue
		Vector(1.0, 4.0, 14.0),	-- crit
		Vector(2.0, 9.0, 9.0),	-- minicrit
	},
	{	-- red
		Vector(14.0, 1.0, 1.0),	-- crit
		Vector(9.0, 4.0, 1.0),	-- minicrit
	},
	{	-- blue
		Vector(1.0, 4.0, 14.0),	-- crit
		Vector(2.0, 9.0, 9.0),	-- minicrit
	},
} 

matproxy.Add({
	name = "ModelGlowColor",
	init = function(self, mat, values)
		self.ResultTo = values.resultvar 
	end,

	bind = function(self, mat, ent)
		if (IsValid(ent) and IsValid(ent.Owner)) then

			local t2 = ent.Owner:GetProxyVar("CritTeam") 
			local s2 = ent.Owner:GetProxyVar("CritStatus")
			if s2 and t2 then
				mat:SetVector(self.ResultTo,GlowColorTable[t2][s2])
			else
				mat:SetVector(self.ResultTo,DefaultGlowColor)
			end

		elseif (IsValid(ent)) then

			local t2 = ent:GetProxyVar("CritTeam") 
			local s2 = ent:GetProxyVar("CritStatus")
			if s2 and t2 then
				mat:SetVector(self.ResultTo,GlowColorTable[t2][s2])
			else
				mat:SetVector(self.ResultTo,DefaultGlowColor)
			end

		end
	end

})

--[[
function PROXY:GetMaterial()
	if not self.Result then return end
	
	return self.Result:GetOwningMaterial()
end]]
