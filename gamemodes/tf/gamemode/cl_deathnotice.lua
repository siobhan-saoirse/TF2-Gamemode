include("cl_killicons.lua")

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

surface.CreateFont("TF_Deathnotice", {font = "Verdana", size = 16, weight = 900})

Neutral_Color = Color(128, 128, 128, 255)
Red_Color = Color(163, 87, 74)
Blu_Color = Color(85, 124, 131)
--Spectator_Color = Color(128, 128, 128, 255)

DefaultMessage_Color = Color(251, 235, 202, 255)
DefaultMessageNeg_Color = Color(0, 0, 0, 196)

local hud_deathnotice_time = GetConVar("hud_deathnotice_time")
local hud_deathnotice_time_local = CreateClientConVar("hud_deathnotice_time_local", 12)

local Deaths = {}

local NOTICE_NORMAL = 1  
local NOTICE_HUMILIATION = 2
local NOTICE_DOMINATION = 3 
local NOTICE_HUMILIATION2 = 4

function TranslateKilliconName(name)
	if (LocalPlayer():GetPlayerClass() == "gmodplayer") then 
		if (!string.find(name,"weapon_") && !string.find(name,"grenade_") && !string.find(name,"npc_") && !string.find(name,"monster_") && !string.find(name,"prop_") && !string.find(name,"combine_mine")) then
			return KilliconTranslate[name] or "d_"..name
		else
			return name
		end
	else
		return KilliconTranslate[name] or "d_"..name
	end
end

local function IsHidden(name)
	-- Name doesn't start with #
	if string.byte(name, 1)~=35 then return false end
	
	name = string.sub(name, 2)
	if NPCData[name] and NPCData[name].team==TEAM_HIDDEN then
		return true
	else
		return false
	end
end

local function GetDeathNoticeID(victim_id, attacker_id, cooperator_id, inflictor)
	return util.CRC(Format("%d_%d_%d_%s", victim_id or 0, attacker_id or 0, --[[cooperator_id or 0]] 0, inflictor or ""))
end

usermessage.Hook("Notice_EntityKilledEntity", function(msg)
	if (LocalPlayer() and LocalPlayer():GetPlayerClass() == "gmodplayer") then
		local victim_name = msg:ReadString()
		local victim_team = msg:ReadShort()
		local victim_id = msg:ReadShort()
		
		local inflictor   = msg:ReadString()
		
		local attacker_name = msg:ReadString() 
		local attacker_team = msg:ReadShort()
		local attacker_id = msg:ReadShort()
		
		local cooperator_name = msg:ReadString()
		local cooperator_team = msg:ReadShort()
		local cooperator_id = msg:ReadShort()

		if (LocalPlayer():GetPlayerClass() == "gmodplayer" and !string.StartWith(inflictor,"weapon_") && !string.find(inflictor,"grenade_") && !string.find(inflictor,"npc_") && !string.find(inflictor,"monster_") && !string.find(inflictor,"prop_") && !string.find(inflictor,"combine_mine")) then
			GAMEMODE:AddDeathNotice( attacker_name, attacker_team, inflictor, victim_name, victim_team )
		else
			GAMEMODE:AddDeathNotice( attacker_name, attacker_team, string.Replace(string.Replace(TranslateKilliconName(inflictor),"d_",""),"hl_","weapon_"), victim_name, victim_team )
		end
	else
		local pid = LocalPlayer():UserID()
		
		local victim_name = msg:ReadString()
		local victim_team = msg:ReadShort()
		local victim_id = msg:ReadShort()
		
		local inflictor   = msg:ReadString()
		
		local attacker_name = msg:ReadString()
		local attacker_team = msg:ReadShort()
		local attacker_id = msg:ReadShort()
		
		local cooperator_name = msg:ReadString()
		local cooperator_team = msg:ReadShort()
		local cooperator_id = msg:ReadShort()
		
		if cooperator_name=="" then cooperator_name = nil end
		
		local critical = msg:ReadBool()
		
		if victim_team ~= TEAM_HIDDEN then
			GAMEMODE:TFAddDeathNotice(
				attacker_name,
				attacker_team,
				inflictor,
				victim_name,
				victim_team,
				cooperator_name,
				cooperator_team,
				nil,
				critical,
				pid==attacker_id or pid==victim_id or pid==cooperator_id,
				GetDeathNoticeID(victim_id, attacker_id, cooperator_id, inflictor)
			)
		end
	end
end)

usermessage.Hook("Notice_EntityHumiliationCounter", function(msg)
	local pid = LocalPlayer():UserID()
	
	local victim_name = msg:ReadString()
	local victim_team = msg:ReadShort()
	local victim_id = msg:ReadShort()
	
	local inflictor   = msg:ReadString()
	
	local attacker_name = msg:ReadString()
	local attacker_team = msg:ReadShort()
	local attacker_id = msg:ReadShort()
	
	--[[
	local cooperator_name = msg:ReadString()
	local cooperator_team = msg:ReadShort()
	local cooperator_id = msg:ReadShort()
	
	if cooperator_name=="" then cooperator_name = nil end]]
	
	local critical = msg:ReadBool()
	
	if victim_team ~= TEAM_HIDDEN then
		GAMEMODE:TFAddDeathNotice(
			attacker_name,
			attacker_team,
			inflictor,
			victim_name,
			victim_team,
			nil,
			0,
			nil,
			critical,
			pid==attacker_id or pid==victim_id,
			GetDeathNoticeID(victim_id, attacker_id, 0, inflictor),
			NOTICE_HUMILIATION
		)
	end
end)

usermessage.Hook("Notice_EntityHumiliationLaughCounter", function(msg)
	local pid = LocalPlayer():UserID()
	
	local victim_name = msg:ReadString()
	local victim_team = msg:ReadShort()
	local victim_id = msg:ReadShort()
	
	local inflictor   = msg:ReadString()
	
	local attacker_name = msg:ReadString()
	local attacker_team = msg:ReadShort()
	local attacker_id = msg:ReadShort()
	
	--[[
	local cooperator_name = msg:ReadString()
	local cooperator_team = msg:ReadShort()
	local cooperator_id = msg:ReadShort()
	
	if cooperator_name=="" then cooperator_name = nil end]]
	
	local critical = msg:ReadBool()
	
	if victim_team ~= TEAM_HIDDEN then
		GAMEMODE:TFAddDeathNotice(
			attacker_name,
			attacker_team,
			inflictor,
			victim_name,
			victim_team,
			nil,
			0,
			nil,
			critical,
			pid==attacker_id or pid==victim_id,
			GetDeathNoticeID(victim_id, attacker_id, 0, inflictor),
			NOTICE_HUMILIATION2
		)
	end
end)

usermessage.Hook("Notice_EntityFinishedOffEntity", function(msg)
	if (LocalPlayer() and LocalPlayer():GetPlayerClass() == "gmodplayer") then
		local victim_name = msg:ReadString()
		local victim_team = msg:ReadShort()
		local victim_id = msg:ReadShort()
		
		local attacker_name = msg:ReadString()
		local attacker_team = msg:ReadShort()
		local attacker_id = msg:ReadShort()

		GAMEMODE:AddDeathNotice( attacker_name, attacker_team, "skull", victim_name, victim_team )
	else
		local pid = LocalPlayer():UserID()
		
		local victim_name = msg:ReadString()
		local victim_team = msg:ReadShort()
		local victim_id = msg:ReadShort()
		
		local attacker_name = msg:ReadString()
		local attacker_team = msg:ReadShort()
		local attacker_id = msg:ReadShort()
		
		GAMEMODE:TFAddDeathNotice(
			attacker_name,
			attacker_team,
			"skull",
			victim_name,
			victim_team,
			nil,
			0,
			"finished off ",
			false,
			pid==attacker_id or pid==victim_id,
			GetDeathNoticeID(victim_id, attacker_id, 0, "__finish")
		)
	end
end)

usermessage.Hook("Notice_EntityFell", function(msg)
	
	if (LocalPlayer() and LocalPlayer():GetPlayerClass() == "gmodplayer") then
		local victim_name = msg:ReadString()
		local victim_team = msg:ReadShort()
		local victim_id = msg:ReadShort()

		GAMEMODE:AddDeathNotice( victim_name, victim_team, "skull", victim_name, victim_team )
	else
		local pid = LocalPlayer():UserID()
		
		local victim_name = msg:ReadString()
		local victim_team = msg:ReadShort()
		local victim_id = msg:ReadShort()
		
		GAMEMODE:TFAddDeathNotice(
			victim_name,
			victim_team,
			"skull",
			"",
			0,
			nil,
			0,
			"fell to a clumsy, painful death",
			false,
			pid==attacker_id or pid==victim_id,
			GetDeathNoticeID(victim_id, 0, 0, "__falldamage")
		)
	end
end)

usermessage.Hook("Notice_EntitySuicided", function(msg)
	
	if (LocalPlayer() and LocalPlayer():GetPlayerClass() == "gmodplayer") then
		local victim_name = msg:ReadString()
		local victim_team = msg:ReadShort()
		local victim_id = msg:ReadShort()

		GAMEMODE:AddDeathNotice( victim_name, victim_team, "skull", victim_name, victim_team )
	else
		local pid = LocalPlayer():UserID()
		
		local victim_name = msg:ReadString()
		local victim_team = msg:ReadShort()
		local victim_id = msg:ReadShort()
		
		GAMEMODE:TFAddDeathNotice(
			victim_name,
			victim_team,
			"skull",
			"",
			0,
			nil,
			0,
			"bid farewell, cruel world!",
			false,
			pid==attacker_id or pid==victim_id,
			GetDeathNoticeID(victim_id, 0, 0, "__suicide")
		)
	end
end)

usermessage.Hook("Notice_EntityDominatedEntity", function(msg)
	local pid = LocalPlayer():UserID()
	
	local victim_name = msg:ReadString()
	local victim_team = msg:ReadShort()
	local victim_id = msg:ReadShort()
	
	local attacker_name = msg:ReadString()
	local attacker_team = msg:ReadShort()
	local attacker_id = msg:ReadShort()
	
	GAMEMODE:TFAddDeathNotice(
		attacker_name,
		attacker_team,
		"domination",
		victim_name,
		victim_team,
		nil,
		0,
		tf_lang.GetRaw("#Msg_Dominating").." ",
		false,
		pid==attacker_id or pid==victim_id,
		GetDeathNoticeID(victim_id, attacker_id, 0, "__domination"),
		NOTICE_DOMINATION
	)
end)

usermessage.Hook("Notice_EntityRevengeEntity", function(msg)
	local pid = LocalPlayer():UserID()
	
	local victim_name = msg:ReadString()
	local victim_team = msg:ReadShort()
	local victim_id = msg:ReadShort()
	
	local attacker_name = msg:ReadString()
	local attacker_team = msg:ReadShort()
	local attacker_id = msg:ReadShort()
	
	GAMEMODE:TFAddDeathNotice(
		attacker_name,
		attacker_team,
		"domination",
		victim_name,
		victim_team,
		nil,
		0,
		tf_lang.GetRaw("#Msg_Revenge").." ",
		false,
		pid==attacker_id or pid==victim_id,
		GetDeathNoticeID(victim_id, attacker_id, 0, "__revenge"),
		NOTICE_DOMINATION
	)
end)

function GM:TFAddDeathNotice(Attacker, team1, Inflictor, Victim, team2, Cooperator, team3, Message, Critical, Highlight, UniqueId, NoticeType)
--print(Attacker, Attacker, Attacker, team1)
	if string.find(Attacker, "\1") then
		local obj, owner = unpack(string.Explode("\1", Attacker))
		if obj and owner then
			Attacker = Format("%s (%s)", tf_lang.GetRaw(obj), tf_lang.GetRaw(owner))
		end
	end
	
	if string.find(Victim, "\1") then
		local obj, owner = unpack(string.Explode("\1", Victim))
		if obj and owner then
			Victim = Format("%s (%s)", tf_lang.GetRaw(obj), tf_lang.GetRaw(owner))
		end
	end
	
	NoticeType = NoticeType or NOTICE_NORMAL
	
	if Inflictor then
		Inflictor = TranslateKilliconName(Inflictor)
	end
	
	for _,v in ipairs(Deaths) do
		if v.id == UniqueId then
			local quit = false
			
			if NoticeType == NOTICE_HUMILIATION then
				if v.hitcount and v.hitcount > 0 then
					-- Hit counter message received after a hit counter message on the same entity, increase the hit counter
					v.hitcount = v.hitcount + 1
					v.right2 = tf_lang.GetFormatted("#Humiliation_Count", v.hitcount).." "
					v.time		=	CurTime()
				else
					-- Hit counter message received after kill message, update the kill message with a funny comment
					v.hitcount = -1
					v.right2 = tf_lang.GetFormatted("#Humiliation_Kill").." "
					v.time		=	CurTime()
				end
				
				quit = true
			elseif NoticeType == NOTICE_HUMILIATION2 then
				if v.hitcount and v.hitcount > 0 then
						-- Hit counter message received after a hit counter message on the same entity, increase the hit counter
					v.hitcount = v.hitcount + 1
					v.right2 = tf_lang.GetFormatted("#Humiliation_Count", v.hitcount).." "
					v.time		=	CurTime()
				else
						-- Hit counter message received after kill message, update the kill message with a funny comment
						v.hitcount = -1
					v.right2 = "LAUGH KILL!".." "
					v.time		=	CurTime()
				end
					
				quit = true
			elseif v.hitcount then
				-- Kill message received after hit counter message, turn the hit counter into a kill message
				v.hitcount = -1
				v.right2 = tf_lang.GetFormatted("#Humiliation_Kill").." "
				v.time		=	CurTime()
				
				quit = true
			end
			
			if quit then
				if Critical and not v.critical then
					v.critical = true
				end
				
				return
			end
		end
	end
	
	if NoticeType == NOTICE_HUMILIATION then
		Message = tf_lang.GetFormatted("#Humiliation_Count", 1).." "
	end
	
	if Message then
		--print(Attacker.." "..Message..Victim)
	else
		local InflictorName = string.gsub(Inflictor, "^tf_weapon_", "")
		if Critical then
			--print(Attacker.." killed "..Victim.." using "..InflictorName.." (crit)")
		else
			--print(Attacker.." killed "..Victim.." using "..InflictorName)
		end
	end
	
	local Death = {}
	Death.time		=	CurTime()
	Death.id		=	UniqueId
	
	if team1 ~= TEAM_HIDDEN then
		Death.left		= 	Attacker
	end
	
	if team3 ~= TEAM_HIDDEN then
		Death.left2		= 	Cooperator
	end
	
	if Death.left2 and not Death.left then
		Death.left = Death.left2
		Death.left2 = nil
	end
	
	Death.right		= 	Victim
	Death.right2	=   Message
	
	Death.icon		=	Inflictor
	
	Death.critical  =   Critical
	Death.highlight =   Highlight
	
	if NoticeType == NOTICE_DOMINATION then
		if Highlight then
			Death.color1 = table.Copy(DefaultMessageNeg_Color)
			Death.color2 = table.Copy(DefaultMessageNeg_Color)
			Death.color3 = table.Copy(DefaultMessageNeg_Color)
		else
			Death.color1 = table.Copy(DefaultMessage_Color)
			Death.color2 = table.Copy(DefaultMessage_Color)
			Death.color3 = table.Copy(DefaultMessage_Color)
		end
	else
		if team1 == -1 or team1 == 1002 then Death.color1 = table.Copy(Neutral_Color) 
		elseif team1 == 2 then Death.color1 = table.Copy(Red_Color) 
		elseif team1 == 3 then Death.color1 = table.Copy(Blu_Color) 
		else Death.color1 = table.Copy(GetTeamSecondaryColor(team1)) end
			
		if team2 == -1 or team2 == 1002 then Death.color2 = table.Copy(Neutral_Color) 
		elseif team2 == 2 then Death.color2 = table.Copy(Red_Color) 
		elseif team2 == 3 then Death.color2 = table.Copy(Blu_Color) 
		else Death.color2 = table.Copy(GetTeamSecondaryColor(team2)) end
		
		if team3 == -1 or team3 == 1002 then Death.color3 = table.Copy(Neutral_Color) 
		elseif team3 == 2 then Death.color3 = table.Copy(Red_Color) 
		elseif team3 == 3 then Death.color3 = table.Copy(Blu_Color) 
		else Death.color3 = table.Copy(GetTeamSecondaryColor(team3)) end
	end
	
	if Highlight then Death.color4 = table.Copy(DefaultMessageNeg_Color)
	else Death.Color4 = table.Copy(DefaultMessage_Color) end
	
	if Death.left == Death.right then
		Death.left = nil
	end
	
	if NoticeType == NOTICE_HUMILIATION then
		Death.hitcount = 1
	end
	
	table.insert(Deaths, Death)
end

local function DrawDeath(x, y, death)
	local _, _, d_texture_tf = GetKilliconData("d_skull", death.highlight)
	local K, color, d_texture = GetKilliconData(death.icon, death.highlight)
	local w, h = K.w, K.h
	local box_x, box_width, box_height
	local x_attacker, x_coop, x_plus
	
	
	box_height = 15 * Scale
	local ks = box_height / h
	w,h = w*ks, h*ks
	
	surface.SetFont("TFDefault")
	local l_victim, h_text = surface.GetTextSize(death.right)
	
	local x_victim = x - l_victim - 4
	local x_icon, x_message
	
	if death.right2 then
		local l_message = surface.GetTextSize(death.right2)
		x_message = x_victim - l_message
		x_icon = x_message - w - 4
	else
		x_icon = x_victim - w - 4
	end
	
	if death.left then
		if death.left2 then
			local l_coop = surface.GetTextSize(death.left2)
			local l_plus = surface.GetTextSize("+")
			local l_attacker = surface.GetTextSize(death.left)
		
			x_coop = x_icon - l_coop - 4
			x_plus = x_coop - l_plus - 4
			x_attacker = x_plus - l_attacker - 4
		else
			local l_attacker = surface.GetTextSize(death.left)
			x_attacker = x_icon - l_attacker - 4
		end
		
		box_x = x_attacker-20
		box_width = x-x_attacker+30
	else
		box_x = x_icon-20
		box_width = x-x_icon+30
	end
	
	local y_text = y + math.ceil((box_height-h_text)/2) + 1
	
	draw.RoundedBox(4, box_x, y, box_width, box_height, color)
	
	surface.SetDrawColor(255,255,255,255)
	local tex
	if death.critical then
		tex = surface.GetTextureID(d_texture_tf)
		tf_draw.ModTexture(tex, x_icon, y, w, h, Killicons["_images"].d_crit)
	end
	tex = surface.GetTextureID(d_texture)
	tf_draw.ModTexture(tex, x_icon, y, w, h, K)
	
	// Draw KILLER
	if death.left then
		draw.SimpleText(death.left, "TFDefault", x_attacker, y_text, death.color1, TEXT_ALIGN_LEFT)
		if death.left2 then
			draw.SimpleText("+", "TFDefault", x_plus, y_text, death.color3, TEXT_ALIGN_LEFT)
			draw.SimpleText(death.left2, "TFDefault", x_coop, y_text, death.color3, TEXT_ALIGN_LEFT)
		end
	end
	
	// Draw VICTIM
	draw.SimpleText(death.right, "TFDefault", x_victim, y_text, death.color2, TEXT_ALIGN_LEFT)
	if death.right2 then
		draw.SimpleText(death.right2, "TFDefault", x_message, y_text, death.color4, TEXT_ALIGN_LEFT)
	end
	
	return y + box_height + 5*Scale
end


function GM:DrawDeathNotice(x, y)
	if (LocalPlayer():GetPlayerClass() == "gmodplayer") then
		return self.BaseClass.DrawDeathNotice(self,x,y)
	end
	if LocalPlayer().InScreenshot then return end
	
	local hud_deathnotice_time = hud_deathnotice_time:GetFloat()
	local hud_deathnotice_time_local = hud_deathnotice_time_local:GetFloat()
	--local cleared = true
	
	x = ScrW() - 25
	y = y * ScrH() + 60
	
	-- Draw
	local size = #Deaths
	local i = 1
	local Death
	
	while i <= size do
		Death = Deaths[i]
		
		local maxtime = (Death.highlight and hud_deathnotice_time_local) or hud_deathnotice_time
		
		if Death.time + maxtime > CurTime() then
			if (i <= 3) then
				y = DrawDeath(x, y, Death)
			end
			--cleared = false
			i = i + 1
		else
			table.remove(Deaths, i)
			size = size - 1
		end
	end
	
	--[[
	// We want to maintain the order of the table so instead of removing
	// expired entries one by one we will just clear the entire table
	// once everything is expired.
	
	-- fucking bullshit garry go suk dik ok
	
	if cleared then
		Deaths = {}
	end]]
end