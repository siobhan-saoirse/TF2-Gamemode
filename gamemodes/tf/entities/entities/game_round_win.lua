-- Define the entity
DEFINE_BASECLASS("base_entity")

ENT.Type = "point"
ENT.Base = "base_entity"
ENT.PrintName = "Game Round Win"
ENT.Category = "TF2"
ENT.Spawnable = false

-- Setup data tables for keyvalues
function ENT:KeyValue(key, value)
	key = string.lower(key)

	if key == "teamnum" then
		self.WinningTeam = tonumber(value)
	elseif key == "force_map_reset" then
		self.ForceMapReset = tobool(tonumber(value))
	elseif key == "round_restart" then
		self.RoundRestart = tobool(tonumber(value))
	elseif key == "show_on_scoreboard" then
		self.ShowOnScoreboard = tobool(tonumber(value))
	end
end

-- Trigger win
function ENT:AcceptInput(name, activator, caller)
	name = string.lower(name)
	if name == "roundwin" then 
		self:TriggerRoundWin()
	end
end

-- Simulated round win
function ENT:TriggerRoundWin()
	local teamID = self.WinningTeam or TEAM_UNASSIGNED

	print("[game_round_win] Triggering round win for team:", teamID)

	-- Show scoreboard message
	GM:RoundWin(self.WinningTeam)

	-- Trigger game logic for team win (you can expand this)
	hook.Run("TF2_RoundWin", teamID)
end
