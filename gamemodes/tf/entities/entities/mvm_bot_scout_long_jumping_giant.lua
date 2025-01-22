if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "scout"
ENT.Spawnable = false
ENT.AdminOnly = true		
ENT.IsBoss = true
ENT.Difficulty = 2
ENT.PrintName		= "Giant Jumping Sandman"
ENT.PreferredIcon = "hud/leaderboard_class_scout_stun"
ENT.Items = {"Hanger-On Hood","Flight of the Monarch","Sandman"}
ENT.Category		= "TFBots: MVM"

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
	bot:SelectWeapon(bot:GetWeapons()[3]:GetClass())
	bot:GetActiveWeapon().Secondary.Delay = math.max(bot:GetActiveWeapon().Secondary.Delay * 0.1,0.25)
	bot:GetActiveWeapon().BaseDamage = 45 * 2
	timer.Create("SetModel"..bot:EntIndex(),0.1,10,function() 
		bot:SetModel("models/bots/scout_boss/bot_scout_boss.mdl")
		bot:SetNWBool("IsBoss",true)
		bot:SetModelScale(1.75)
		bot:SetHealth(1600)
		bot:SetMaxHealth(1600)
	end)
	bot:GetWeapons()[2]:Remove()
	bot:GetWeapons()[1]:Remove()
end
 
list.Set( "NPC", "mvm_bot_scout_long_jumping_giant", {
	Name = ENT.PrintName,
	Class = "mvm_bot_scout_long_jumping_giant",
	Category = ENT.Category,
	AdminOnly = true
} )