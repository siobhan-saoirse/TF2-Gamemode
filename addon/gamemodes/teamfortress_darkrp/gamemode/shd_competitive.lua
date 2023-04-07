CreateConVar( "tf_competitive", "0", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "Disables sandbox features, recommended for serious coop!" )

hook.Add("SpawnMenuOpen", "TF2Competitive", function()
	if GetConVar("tf_competitive"):GetBool() then
		return false
	end
end)

hook.Add("PlayerNoClip", "TF2Competitive", function()
	if GetConVar("tf_competitive"):GetBool() then
		return false
	end
end)