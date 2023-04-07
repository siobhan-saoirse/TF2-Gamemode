local meta = FindMetaTable("Player")

function meta:GiveLoadout()
    local convar = "loadout_" .. self:GetPlayerClass()
    local split = string.Split(self:GetInfo(convar, "-1,-1,-1,-1,-1"), ",")
    if #split ~= 5 then
        split = {-1, -1, -1, -1, -1}
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
            timer.Simple(0 + type * 0.05, function()
                self:EquipInLoadout(itemname)
                --tf_items.CC_GiveItem(self, _, {itemname})
            end)
            --self:ConCommand("__svgiveitem", itemname) --id)
        end
    end
end

concommand.Add("loadout_update", function(ply)
    ply:GiveLoadout()
end) 