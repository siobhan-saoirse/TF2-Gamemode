
local GenericGibs = {Gibs={
	[GIB_LEFTLEG]		= GIBS_SILLY_START,
	[GIB_RIGHTLEG]		= GIBS_SILLY_START+1,
	[GIB_LEFTARM]		= GIBS_SILLY_START+2,
	[GIB_RIGHTARM]		= GIBS_SILLY_START+3,
	[GIB_TORSO]			= GIBS_SILLY_START+4,
	[GIB_TORSO2]		= GIBS_SILLY_START+5,
	[GIB_HEAD]			= GIBS_SILLY_START+6,
	[GIB_HEADGEAR1]		= GIBS_SILLY_START+7,
	[GIB_HEADGEAR2]		= GIBS_SILLY_START+8,
	[GIB_ORGAN]			= GIBS_SILLY_START+9,
}}

function EFFECT:Init(data)
	local pl = data:GetEntity()
	
	local c
	
	for k,_ in pairs(pl.StuckArrows or {}) do
		k.Parent = nil
	end
	
	if pl:IsPlayer() then
		c = pl:GetPlayerClassTable()
	else
		c = GenericGibs
	end
	
	if not c or not c.Gibs then return end
	
	local exclude = {}
	
	for _,v in pairs(pl:GetTFItems()) do
		if IsValid(v) then
		if v.GetVisuals and v:GetVisuals() ~= nil then
		local bodygroups = v:GetVisuals().hide_player_bodygroup_names
		for _,b in ipairs(bodygroups or {}) do
			if b == "hat" then
				exclude[GIB_HEADGEAR1] = true
			elseif b == "headphones" then
				exclude[GIB_HEADGEAR2] = true
			end
		end
		
		if v.SetupPlayerRagdoll then
			v:SetupPlayerRagdoll(NULL)
		end
		end
		end
	end
	
	for k,v in pairs(c.Gibs) do
		if not exclude[k] then
			local effectdata = EffectData()
				effectdata:SetEntity(pl)
				effectdata:SetMagnitude(v)
				effectdata:SetOrigin(pl:GetPos())
				effectdata:SetAngles(pl:GetAngles())
				effectdata:SetNormal(Vector(0,0,1))
				effectdata:SetRadius(8)
			util.Effect("tf_gib", effectdata)
		end
	end
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end