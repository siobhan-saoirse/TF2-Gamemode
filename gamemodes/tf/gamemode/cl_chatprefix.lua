--Chat Tags by Tyguy
CreateClientConVar("chat_color_r", 255, true, false)
CreateClientConVar("chat_color_g", 255, true, false)
CreateClientConVar("chat_color_b", 255, true, false)
CreateClientConVar("chat_color_a", 255, true, false)

local Tags = 
{
--Group    --Tag     --Color
{"admin", "[ADMIN] ", Color(0, 0, 255, 255) },
{"superadmin", "[SUPERADMIN] ", Color(255, 0, 0, 255) },
{"owner", "[OWNER] ", Color(0, 255, 0, 255) }
}

isDev = false

function DevDetector(ply)
	if ply:SteamID() == "STEAM_0:0:36452708" or ply:SteamID() == "STEAM_0:0:35652170" or ply:SteamID() == "STEAM_0:1:120914933" then
		isDev = true 
	else
		isDev = false
	end
end
concommand.Add("getweapon", DevDetector)
 
hook.Add("OnPlayerChat", "Tags", function(ply, strText, bTeamOnly)
	if IsValid(ply) and ply:SteamID() == "STEAM_0:0:36452708" or ply:SteamID() == "STEAM_0:0:35652170" or ply:SteamID() == "STEAM_0:1:120914933" then
		isDev = true
	else
		isDev = false
	end
		
	if IsValid(ply) and ply:IsPlayer() then
		for k,v in pairs(Tags) do
			if ply:IsUserGroup(v[1]) then
				local R = GetConVarNumber("chat_color_r")
				local G = GetConVarNumber("chat_color_g")
				local B = GetConVarNumber("chat_color_b")
				local A = GetConVarNumber("chat_color_a")
				local Colour = team.GetColor(ply:Team()) or Color(0,0,0)
				local nickteam = team.GetColor(ply:Team())
				if isDev == false then
					if !bTeamOnly then
						chat.AddText(v[3], nickteam, ply:Nick(), color_white, ": ", Color(R, G, B, A), strText)
						return true
					else
						chat.AddText(v[3], nickteam, color_white,"(TEAM) ", ply:Nick(), color_white, ": ", Color(R, G, B, A), strText)
						return true
					end
				else
					if !bTeamOnly then
						chat.AddText(v[3], color_white,"(DEV) ", Colour, ply:Nick(), color_white, ": ", Color(R, G, B, A), strText)
						return true
					else
						chat.AddText(v[3], color_white,"(DEV) ", "(TEAM) ", Colour, ply:Nick(), color_white, ": ", Color(R, G, B, A), strText)
						return true
					end
				end
			end
		end
	end
	if !IsValid(ply) and !ply:IsPlayer() then
		local ConsoleColor = Color(0, 255, 0) --Change this to change Console name color
		chat.AddText(ConsoleColor, "Console", color_white, ": ", strText)
		return true
	end
end )