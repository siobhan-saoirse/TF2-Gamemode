
local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local default_avatar = surface.GetTextureID("vgui/av_default")
local bot_avatar = surface.GetTextureID("vgui/null")

local leaderboard_dom = {}
for i=1, 16 do
	leaderboard_dom[i] = surface.GetTextureID("hud/leaderboard_dom"..i)
end

local leaderboard_dead = surface.GetTextureID("hud/leaderboard_dead")
local leaderboard_dominated = surface.GetTextureID("hud/leaderboard_dominated")
local leaderboard_nemesis = surface.GetTextureID("hud/leaderboard_nemesis")

local ico_friend_indicator_scoreboard = surface.GetTextureID("vgui/ico_friend_indicator_scoreboard")

CreateClientConVar("tf_scoreboard_text_ping", "0", {FCVAR_ARCHIVE})

local NameLabel = {
	text="Name",
	font="ScoreboardSmallest",
	pos={44*Scale, 7*Scale},
	xalign=TEXT_ALIGN_LEFT,
	yalign=TEXT_ALIGN_CENTER,
}

local ScoreLabel = {
	text="Score",
	font="ScoreboardSmallest",
	pos={253*Scale, 7*Scale},
	xalign=TEXT_ALIGN_RIGHT,
	yalign=TEXT_ALIGN_CENTER,
}

local PingLabel = {
	text="Ping",
	font="ScoreboardSmallest",
	pos={276*Scale, 7*Scale},
	xalign=TEXT_ALIGN_RIGHT,
	yalign=TEXT_ALIGN_CENTER,
}

local PlayerName = {
	text="",
	font="TFDefault",
	pos={44*Scale, 7*Scale},
	xalign=TEXT_ALIGN_LEFT,
	yalign=TEXT_ALIGN_CENTER,
}
local PlayerScore = {
	text="",
	font="TFDefault",
	pos={253*Scale, 7*Scale},
	xalign=TEXT_ALIGN_RIGHT,
	yalign=TEXT_ALIGN_CENTER,
}
local PlayerPing = {
	text="",
	font="TFDefault",
	pos={276*Scale, 7*Scale},
	xalign=TEXT_ALIGN_RIGHT,
	yalign=TEXT_ALIGN_CENTER,
}

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:SetVisible(true)
	
	self.Avatars = {}
	for i=1, 12 do
		self.Avatars[i] = vgui.Create("AvatarImage", self)
	end
	self.PlayerTeam = TEAM_RED
end

function PANEL:SetTeam(t)
	self.PlayerTeam = t
end

function PANEL:PerformLayout()
	local ypos = math.floor(23*Scale)
	
	for i=1, 12 do
		self.Avatars[i]:SetVisible(true)
		self.Avatars[i]:SetPos(math.floor(14*Scale), ypos-math.floor(8*Scale))
		self.Avatars[i]:SetSize(15*Scale, 15*Scale)
		ypos = ypos + math.floor(22*Scale)
	end
end

function PANEL:Paint()
	local w, h = self:GetSize()
	surface.SetDrawColor(255, 255, 255, 255)
	
	surface.DrawLine(3*Scale, 11.25*Scale, w-3.5*Scale, 11.25*Scale)
	draw.Text(NameLabel)
	draw.Text(ScoreLabel)
	draw.Text(PingLabel)
	
	local ypos = math.floor(23*Scale)
	
	local col = team.GetColor(self.PlayerTeam)
	local players = team.GetPlayers(self.PlayerTeam)
	
	table.sort(players, function(a, b) return a:Frags() > b:Frags() end)
	
	for i,pl in ipairs(players) do
		local c = pl:GetPlayerClassTable()
		local d = not pl:Alive()
		
		if pl == LocalPlayer() then
			surface.SetDrawColor(Colors.HudPanelBorder)
			surface.DrawRect(3*Scale, ypos-math.floor(11*Scale), w-math.floor(6*Scale), math.floor(21*Scale))
			surface.SetDrawColor(255, 255, 255, 255)
		end
		if self then
			if self.Avatars then
				self.Avatars[i]:SetPlayer(pl)
				self.Avatars[i]:SetVisible(true)
			end
		end
		if d then
			col.a = 127
		else
			col.a = 255
		end
		
		PlayerName.text = pl:GetName()
		PlayerName.color = col
		PlayerName.pos[2] = ypos
		draw.Text(PlayerName)
		
		PlayerScore.text = pl:Frags()
		PlayerScore.color = col
		PlayerScore.pos[2] = ypos
		draw.Text(PlayerScore)
		
		PlayerPing.color = col
		PlayerPing.pos[2] = ypos
		if GetConVar("tf_scoreboard_text_ping"):GetBool() then
		if pl:IsBot() then
			PlayerPing.text = "BOT"
		else
			PlayerPing.text = pl:Ping()
		end
		draw.Text(PlayerPing)
		else
		local ping = pl:Ping()
		surface.SetTexture(surface.GetTextureID("hud/scoreboard_ping_low"))
		if ping >= 60 and ping < 90 then
			surface.SetTexture(surface.GetTextureID("hud/scoreboard_ping_med"))
		elseif ping >= 90 and ping < 115 then
			surface.SetTexture(surface.GetTextureID("hud/scoreboard_ping_high"))
		elseif ping >= 115 then
			surface.SetTexture(surface.GetTextureID("hud/scoreboard_ping_very_high"))
		end

		if pl:IsBot() then
			if pl:Team() == TEAM_RED then
				surface.SetTexture(surface.GetTextureID("hud/scoreboard_ping_bot_red"))
			else
				surface.SetTexture(surface.GetTextureID("hud/scoreboard_ping_bot_blue"))
			end
		end

		if d then
			
		end

		surface.DrawTexturedRect(PlayerPing.pos[1] - 25, PlayerPing.pos[2] - 10, 25, 20)
		end
		
		if pl:GetFriendStatus() == "friend" then
			surface.SetTexture(ico_friend_indicator_scoreboard)
			surface.DrawTexturedRect(math.floor(3*Scale), ypos-math.floor(8.5*Scale), 30*Scale, 30*Scale)
		end

		if pl:IsBot() then
			surface.SetTexture(bot_avatar)
		else
			surface.SetTexture(default_avatar)
		end

		surface.DrawTexturedRect(math.floor(14*Scale), ypos-math.floor(8*Scale), 15*Scale, 15*Scale)
		
		local num_dominations = 0
		if pl.DominationsList then
			for k,_ in pairs(pl.DominationsList) do
				if IsValid(k) then
					num_dominations = num_dominations + 1
				else
					pl.DominationsList[k] = nil
				end
			end
		end
		
		if num_dominations > 0 then
			surface.SetTexture(leaderboard_dom[1])
			surface.DrawTexturedRect(184*Scale, ypos-7*Scale, 13*Scale, 13*Scale)
		end
		
		if LocalPlayer().DominationsList and LocalPlayer().DominationsList[pl] then
			surface.SetTexture(leaderboard_dominated)
			surface.DrawTexturedRect(214*Scale, ypos-7*Scale, 13*Scale, 13*Scale)
		end
		
		if LocalPlayer().NemesisesList and LocalPlayer().NemesisesList[pl] then
			surface.SetTexture(leaderboard_nemesis)
			surface.DrawTexturedRect(214*Scale, ypos-7*Scale, 13*Scale, 13*Scale)
		end
		
		if c and c.ScoreboardImage then
			if (pl:GetNWString("PreferredIcon")) then

				local tex
				if d then
					tex = surface.GetTextureID(pl:GetNWString("PreferredIcon"),nil) or c.ScoreboardImage[2]
				else
					tex = surface.GetTextureID(pl:GetNWString("PreferredIcon"),nil)
				end
				if tex then
					surface.SetTexture(tex)
					surface.DrawTexturedRect(199*Scale, ypos-7*Scale, 13*Scale, 13*Scale)
				end
			else
				local tex
				if d then
					tex = c.ScoreboardImage[2]
				else
					tex = c.ScoreboardImage[1]
				end
				if tex then
					surface.SetTexture(tex)
					surface.DrawTexturedRect(199*Scale, ypos-7*Scale, 13*Scale, 13*Scale)
				end
			end
		end
		
		if d then
			surface.SetTexture(leaderboard_dead)
			surface.DrawTexturedRect(30*Scale, ypos-6*Scale, 12*Scale, 12*Scale)
		end
		
		ypos = ypos + math.floor(22*Scale)
	end
	
	for i=#players+1, 12 do
		self.Avatars[i]:SetPlayer(NULL)
		self.Avatars[i]:SetVisible(false)
	end
end

vgui.Register("TFScoreboardPlayerList", PANEL)
