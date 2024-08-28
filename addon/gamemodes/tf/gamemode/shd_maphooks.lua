
if CLIENT then
	return
end

if game.GetMap() == "d1_trainstation_05" then

hook.Add("InitPostEntity", "plug_fix", function()
	local plug = ents.FindByName("plug")[1]
	if IsValid(plug) then
		plug:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	end
end)

elseif game.GetMap() == "d2_prison_07" then

hook.Add("InitPostEntity", "turret_fix", function()
	for _,turret in pairs(ents.FindByName("turret_buddy")) do
		turret:SetNWInt("Team", TEAM_RED)
		gamemode.Call("UpdateEntityRelationship", turret)
	end
end)

end