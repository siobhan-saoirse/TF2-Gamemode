
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

local ico_friend_indicator_scoreboard = surface.GetTextureID("vgui/ico_friend_indicator_scoreboard")

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
	
	self.PlayerTeam = TEAM_RED
end

function PANEL:SetTeam(t)
	self.PlayerTeam = t
end

function PANEL:PerformLayout()
	local ypos = math.floor(23*Scale)
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
		if d then
			col.a = 127
		else
			col.a = 255
		end
		PlayerName.text = pl:GetName()
		PlayerName.color = col
		PlayerName.pos[2] = ypos
		draw.Text(PlayerName)

		--surface.DrawTexturedRect(math.floor(14*Scale), ypos-math.floor(8*Scale), 15*Scale, 15*Scale)
		
		if c and c.ScoreboardImage then
			if (pl:GetNWString("PreferredIcon") != "") then

				local tex
				if d then
					tex = surface.GetTextureID(pl:GetNWString("PreferredIcon"),nil) or c.ScoreboardImage[2]
				else
					tex = surface.GetTextureID(pl:GetNWString("PreferredIcon"),nil)
				end
				if tex then
					if pl:IsMiniBoss() then
						surface.SetDrawColor( 255, 0, 0, 255 )
						surface.DrawRect(math.floor(14*Scale), ypos-math.floor(8*Scale), 15*Scale, 15*Scale)
					end
					surface.SetDrawColor(Colors.White)
					surface.SetTexture(tex)
					surface.DrawTexturedRect(math.floor(14*Scale), ypos-math.floor(8*Scale), 15*Scale, 15*Scale)
				end
			else
				local tex
				if d then
					tex = c.ScoreboardImage[2]
				else
					tex = c.ScoreboardImage[1]
				end
				if tex then
					if pl:IsMiniBoss() then
						surface.SetDrawColor( 255, 0, 0, 255 )
						surface.DrawRect(math.floor(14*Scale), ypos-math.floor(8*Scale), 15*Scale, 15*Scale)
					end
					surface.SetDrawColor(Colors.White)
					surface.SetTexture(tex)
					surface.DrawTexturedRect(math.floor(14*Scale), ypos-math.floor(8*Scale), 15*Scale, 15*Scale)
				end 
			end
		end
		if pl:GetPlayerClass() == "heavyweightchamp" or pl:GetPlayerClass() == "soldierbuffed" or pl:GetPlayerClass() == "melee_scout_expert" or pl:GetPlayerClass() == "giantsoldiercharged" then
			local crit = surface.GetTextureID("hud/leaderboard_class_critical")
			surface.SetTexture(crit)
			surface.DrawTexturedRect(math.floor(14*Scale), ypos-math.floor(8*Scale), 15*Scale, 15*Scale)
			
			surface.SetDrawColor( 255, 255, 255, 100 )
			if c and c.ScoreboardImage then
				if (pl:GetNWString("PreferredIcon") != "") then

					local tex
					if d then
						tex = surface.GetTextureID(pl:GetNWString("PreferredIcon"),nil) or c.ScoreboardImage[2]
					else
						tex = surface.GetTextureID(pl:GetNWString("PreferredIcon"),nil)
					end
					if tex then
						if pl:IsMiniBoss() then
							surface.SetDrawColor( 255, 0, 0, 255 )
							surface.DrawRect(math.floor(14*Scale), ypos-math.floor(8*Scale), 15*Scale, 15*Scale)
						end
						surface.SetDrawColor(Colors.White)
						surface.SetTexture(tex)
						surface.DrawTexturedRect(math.floor(14*Scale), ypos-math.floor(8*Scale), 15*Scale, 15*Scale)
					end
				else
					local tex
					if d then
						tex = c.ScoreboardImage[2]
					else
						tex = c.ScoreboardImage[1]
					end
					if tex then
						if pl:IsMiniBoss() then
							surface.SetDrawColor( 255, 0, 0, 255 )
							surface.DrawRect(math.floor(14*Scale), ypos-math.floor(8*Scale), 15*Scale, 15*Scale)
						end
						surface.SetDrawColor(Colors.White)
						surface.SetTexture(tex)
						surface.DrawTexturedRect(math.floor(14*Scale), ypos-math.floor(8*Scale), 15*Scale, 15*Scale)
					end 
				end
			end
		end
		
		ypos = ypos + math.floor(22*Scale) 
	end
	
end
 
vgui.Register("TFMVMScoreboardPlayerList", PANEL)
