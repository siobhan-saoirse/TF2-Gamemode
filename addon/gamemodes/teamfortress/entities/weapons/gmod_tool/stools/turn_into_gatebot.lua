 
TOOL.Category = "Civilian 2"
TOOL.Name = "#tool.turn_into_gatebot.name"

TOOL.LeftClickAutomatic = false
TOOL.RightClickAutomatic = false 
TOOL.RequiresTraceHit = true

TOOL.Information = {
	{ name = "left" }
}
--Scale UP
function TOOL:LeftClick( trace )

	if ( !IsValid( trace.Entity ) ) then return false end  
	if ( !trace.Entity:IsPlayer() and !trace.Entity:IsBot() and !trace.Entity.TFBot) then return false end
	if (!string.find(trace.Entity:GetModel(),"models/bots")) then return end
	if ( CLIENT ) then return true end
	
	local tr = trace
	local npc = trace.Entity
	timer.Simple(0.1, function()
	
		for k,v in ipairs(ents.FindByClass("tf_wearable_item")) do
			if (v:GetOwner():EntIndex() == npc:EntIndex() and !string.find(v:GetModel(),"gameplay_cosmetic")) then
				v:Remove()
			end
		end
	
	end)
	
	trace.Entity:EquipInLoadout("MvM GateBot Light "..string.upper(string.sub(tr.Entity.playerclass,1,1))..string.sub(tr.Entity.playerclass,2)) 

	return true

end

function TOOL.BuildCPanel( CPanel )

	CPanel:AddControl( "Header", { Description = "#tool.turn_into_gatebot.desc" } )

end
