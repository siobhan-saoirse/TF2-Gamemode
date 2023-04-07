local meta = FindMetaTable("Player")

function meta:GiveLoadout()
end

concommand.Add("loadout_update", function(ply)
    ply:GiveLoadout()
end) 