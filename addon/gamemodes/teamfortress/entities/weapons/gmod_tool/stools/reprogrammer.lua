 
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
	if ( !trace.Entity:IsPlayer() ) then return false end
	if ( !trace.Entity:IsBot() ) then return false end
	if ( CLIENT ) then return true end
	
	local tr = trace 
	local npc = trace.Entity
	if (trace.Entity:Team() == TEAM_RED) then
		npc:SetTeam(TEAM_BLU)
		npc:SetSkin(1)
	elseif (trace.Entity:Team() == TEAM_BLU) then
		npc:SetTeam(TEAM_RED)
		npc:SetSkin(0)
	elseif (trace.Entity:Team() == TEAM_NEUTRAL) then
		npc:SetTeam(math.random(TEAM_RED,TEAM_BLU)) 
		npc:SetSkin(1)
	end
	npc:SetPlayerClass(npc:GetPlayerClass())
	return true

end
function TOOL:RightClick( trace )

	if ( !IsValid( trace.Entity ) ) then return false end  
	if ( !trace.Entity:IsPlayer() ) then return false end
	if ( !trace.Entity:IsBot() ) then return false end
	if ( CLIENT ) then return true end
	
	local tr = trace
	local npc = trace.Entity
	npc:SetTeam(self:GetOwner():Team())
	npc:SetPlayerClass(npc:GetPlayerClass())
	if (self:GetOwner():Team() == TEAM_RED || self:GetOwner():Team() == TEAM_BLU) then
		npc:SetSkin(self:GetOwner():Team() - 2)
	else
		npc:SetSkin(0)
	end
	return true

end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.reprogrammer.desc" } )

end
