local neutralinstalled = false
for k, v in pairs(engine.GetAddons()) do
	if v.wsid == "501783258" and v.mounted == true then
		neutralinstalled = true
	end
end

if not neutralinstalled then return end
CreateClientConVar("tf_neutralmodel", 1, true, true)
CreateClientConVar("tf_neutralmodel_skin", 1, true, true, "The skin for the model, 0 for red 1 for blu")
CreateClientConVar("tf_neutralmodels_all", 1) 
 
hook.Add("PostPlayerDraw", "NeutralModels", function(ply) -- Experimental and WIP, Sorry for the strange and messy code!
	if ((ply:Team() == TEAM_YELLOW or ply:Team() == TEAM_GREEN) and not ply:IsHL2() and !ply:IsL4D() and ply:Alive() and ply:GetInfoNum("tf_robot", 0) == 0 and neutralinstalled and ply:GetInfoNum("tf_neutralmodel", 1) == 1 and LocalPlayer():GetInfoNum("tf_neutralmodels_all", 1) == 1) then
		local model = "models/lkskin/hwm/"..(string.sub(string.gsub(ply:GetPlayerClass(), "man", ""), 1) or "scout")..".mdl"

		if ply:GetPlayerClass() == "civilian" then
			model = "models/lkskin/hwm/scout.mdl" 
		end

		if not IsValid(ply.NeutralModel) then
			ply.NeutralModel = ClientsideModel(model)
		end

		ply.NeutralModel:SetModel(model)
		ply.NeutralModel:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL))
		ply.NeutralModel:SetParent(ply)
		ply.NeutralModel:SetSkin(ply:GetSkin())
		ply:SetMaterial("color")

		for k, v in pairs(ply.NeutralModel:GetBodyGroups()) do
			ply.NeutralModel:SetBodygroup(k, ply:GetBodygroup(k))
		end
	else
		ply:SetMaterial("")

		if IsValid(ply.NeutralModel) then
			ply.NeutralModel:Remove()
		end
	end
end)