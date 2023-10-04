
local DefaultGlowColor = Vector(0.0, 0.0, 0.0)

--[[local ]]
GlowColorTable = {
	{	-- red
		Vector(14.0, 1.0, 1.0),	-- crit
		Vector(14.0, 1.0, 1.0),	-- crit
	},
	{	-- blue
		Vector(1.0, 4.0, 14.0),	-- crit
		Vector(1.0, 4.0, 14.0),	-- crit
	},
	{	-- red
		Vector(14.0, 1.0, 1.0),	-- crit
		Vector(14.0, 1.0, 1.0),	-- crit
	},
	{	-- blue
		Vector(1.0, 4.0, 14.0),	-- crit
		Vector(1.0, 4.0, 14.0),	-- crit
	},
} 

matproxy.Add({
	name = "spy_invis",
	init = function(self, mat, values)
		self.ResultTo = values.resultvar  
	end,

	bind = function(self, mat, ent)
		if (IsValid(ent) and IsValid(ent.Owner)) then

			local t2 = ent.Owner:GetProxyVar("CloakTint") 
			local s2 = ent.Owner:GetProxyVar("CloakLevel")
			if s2 and t2 then
				mat:SetVector(self.ResultTo,GlowColorTable[t2][s2])
			else
				mat:SetVector(self.ResultTo,DefaultGlowColor)
			end

		elseif (IsValid(ent)) then

			local t2 = ent.Owner:GetProxyVar("CloakTint") 
			local s2 = ent.Owner:GetProxyVar("CloakLevel")
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
