if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "melee_scout"
ENT.Spawnable = false
ENT.AdminOnly = true		
ENT.IsBoss = false
ENT.Difficulty = 2
ENT.PrintName		= "Jumping Sandman"
ENT.PreferredName	= "Scout"
ENT.PreferredIcon = "hud/leaderboard_class_scout_stun"
ENT.Items = {"Hanger-On Hood","Flight of the Monarch","Sandman"}
ENT.Category		= "TFBots - MVM"

function ENT:CustomOnThink()
	local bot = self.Bot
	if bot.ControllerBot.nextStuckJump < CurTime() then
		if !bot:Crouching() then
			bot.ControllerBot.NextJump = 0 
		end
		bot.ControllerBot.nextStuckJump = CurTime() + 5
	end
	bot:SetJumpPower(220 * 2)
end
function ENT:CustomOnInitialize(bot)
	bot:GetActiveWeapon().Secondary.Delay = math.max(bot:GetActiveWeapon().Secondary.Delay * 0.5,0.25)
end
 
list.Set( "NPC", "mvm_bot_scout_long_jumping", {
	Name = ENT.PrintName,
	Class = "mvm_bot_scout_long_jumping",
	Category = ENT.Category,
	AdminOnly = true
} )