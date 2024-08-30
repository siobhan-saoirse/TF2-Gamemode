local meta = FindMetaTable("Player")

function meta:GiveLoadout()
    local convar = "loadout_" .. self:GetPlayerClass()
    local split = string.Split(self:GetInfo(convar, "-1,-1,-1,-1,-1"), ",")
    if #split ~= 6 then
        split = {-1, -1, -1, -1, -1, -1}
    end

    for type, id in pairs(split) do
        id = tonumber(id)
        local itemname = nil
        -- oh no
        for name, wep in pairs(tf_items.Items) do
            if istable(wep) and wep.id == id then
                itemname = name
            end
        end

        if itemname then
            self:EquipInLoadout(itemname)
            --tf_items.CC_GiveItem(self, _, {itemname})
            --self:ConCommand("__svgiveitem", itemname) --id)
        end
    end


    timer.Simple(0.3, function()
    
		if (!self:IsL4D()) then
		
			if (self:GetInfoNum("tf_give_hl2_weapons",0) == 1 && (!GetConVar("tf_competitive"):GetBool() || self:IsAdmin())) then
				self:Give("weapon_physgun")
				self:Give("weapon_physcannon")	
				self:Give("gmod_tool")
				self:Give("gmod_camera")
			end
				
		end
    end)
end

concommand.Add("loadout_update", function(ply)
    local resupply
	if GetConVar("tf_competitive"):GetBool() then
		for k, v in pairs(ents.FindByClass("prop_dynamic")) do
			if v:GetModel() == "models/props_gameplay/resupply_locker.mdl" and v:GetPos():Distance(ply:GetPos()) <= 100 then
				resupply = v
			end
		end
		
		if !IsValid(resupply) then 
            ply:PrintMessage(HUD_PRINTCENTER,"You need to be near a Resupply Locker!")
            ply:ChatPrint("You need to be near a Resupply Locker!") 
            return false 
        end
	end
    ply:GiveLoadout()
    return true

end) 