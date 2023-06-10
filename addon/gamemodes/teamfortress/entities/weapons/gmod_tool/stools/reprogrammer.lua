 
TOOL.Category = "Civilian 2"
TOOL.Name = "#tool.reprogrammer.name"
 
TOOL.LeftClickAutomatic = false
TOOL.RightClickAutomatic = false 
TOOL.RequiresTraceHit = true

TOOL.Information = {
	{ name = "left" },
	{ name = "right" },
} 
--Scale UP
function TOOL:LeftClick( trace )

	if ( !IsValid( trace.Entity ) ) then return false end  
	if ( !trace.Entity:IsTFPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local tr = trace 
	local npc = trace.Entity
	if (npc:IsPlayer() and npc.TFBot) then
		GAMEMODE:StopCritBoost(npc)
		if (trace.Entity:Team() == TEAM_RED) then
			npc:SetTeam(TEAM_BLU)
			npc:SetSkin(1)
		elseif (trace.Entity:Team() == TEAM_BLU) then
			npc:SetTeam(TEAM_RED)
			npc:SetSkin(0)
		elseif (trace.Entity:Team() == TEAM_YELLOW) then
			npc:SetTeam(TEAM_GREEN)
			npc:SetSkin(0)
		elseif (trace.Entity:Team() == TEAM_GREEN) then
			npc:SetTeam(TEAM_RED)
			npc:SetSkin(0)
		elseif (trace.Entity:Team() == TEAM_NEUTRAL) then
			npc:SetTeam(math.random(TEAM_RED,TEAM_BLU)) 
			npc:SetSkin(1)
		end
		timer.Simple(0.1, function()
		
			npc:SetPlayerClass(npc:GetPlayerClass())

		end)
	elseif (npc:IsNPC()) then
		
		if (GAMEMODE:EntityTeam(trace.Entity) == TEAM_RED) then
			npc:SetEntityTeam(TEAM_BLU)
		elseif (GAMEMODE:EntityTeam(trace.Entity) == TEAM_BLU) then
			npc:SetEntityTeam(TEAM_RED)
		elseif (GAMEMODE:EntityTeam(trace.Entity) == TEAM_YELLOW) then
			npc:SetEntityTeam(TEAM_GREEN)
		elseif (GAMEMODE:EntityTeam(trace.Entity) == TEAM_GREEN) then
			npc:SetEntityTeam(TEAM_RED)
		elseif (GAMEMODE:EntityTeam(trace.Entity) == TEAM_NEUTRAL) then
			npc:SetEntityTeam(math.random(TEAM_RED,TEAM_BLU))
		end

	end
	return true

end
function TOOL:RightClick( trace )

	if ( !IsValid( trace.Entity ) ) then return false end  
	if ( !trace.Entity:IsTFPlayer() ) then return false end
	if ( CLIENT ) then return true end
	
	local tr = trace
	local npc = trace.Entity
	if (npc:IsPlayer() and npc.TFBot) then
		npc:SetTeam(self:GetOwner():Team())
		GAMEMODE:StopCritBoost(npc)
		if (self:GetOwner():Team() == TEAM_RED || self:GetOwner():Team() == TEAM_BLU) then
			npc:SetSkin(self:GetOwner():Team() - 2)
		elseif (self:GetOwner():Team() == TEAM_YELLOW || self:GetOwner():Team() == TEAM_GREEN) then
			npc:SetSkin(self:GetOwner():Team() - 4)
		else
			npc:SetSkin(0)
		end
		timer.Simple(0.1, function()
		
			npc:SetPlayerClass(npc:GetPlayerClass())

		end)
	elseif (npc:IsNPC()) then
		npc:SetEntityTeam(self:GetOwner():Team())
	end
	return true

end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.reprogrammer.desc" } )

end
