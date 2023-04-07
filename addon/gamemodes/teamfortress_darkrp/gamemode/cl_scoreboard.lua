
local Scoreboard

function GM:DestroyScoreboard()
	if Scoreboard then
		Scoreboard:Remove()
		Scoreboard = nil
	end
end

function GM:CreateScoreboard()
	if Scoreboard then
		self:DestroyScoreboard()
	end

	Scoreboard = vgui.Create("TFScoreboard")
end

function GM:ScoreboardShow()
	GAMEMODE.ShowScoreboard = true
	if not Scoreboard then
		self:CreateScoreboard()
	end
	
	Scoreboard:SetVisible(true)
	Scoreboard:UpdateScoreboard(true)
end

function GM:ScoreboardHide()
	GAMEMODE.ShowScoreboard = false
	if Scoreboard then
		Scoreboard:SetVisible(false)
	end
end

function GM:HUDDrawScoreBoard()
end
