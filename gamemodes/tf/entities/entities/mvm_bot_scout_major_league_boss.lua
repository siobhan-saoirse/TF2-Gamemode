if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantscoutmelee"
ENT.Spawnable = false
ENT.AdminOnly = true		
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Major League"
ENT.PreferredIcon = "hud/leaderboard_class_scout_stun"
ENT.Items = {"Boston Boom-Bringer","Summer Shades","Genuine Cockfighter","Sandman"}
ENT.Category		= "TFBots - MVM"

function ENT:CustomOnInitialize(bot)
	timer.Create("SetModel"..bot:EntIndex(),0.1,10,function() 
		bot:SetModel("models/bots/scout_boss/bot_scout_boss.mdl")
		bot:SetNWBool("IsBoss",true)
		bot:SetModelScale(1.9)
		bot:SetClassSpeed(400 * 1.4)
		bot:SetHealth(10000)
		bot:SetMaxHealth(10000)
	end)
	bot:GetActiveWeapon().Secondary.Delay = math.max(bot:GetActiveWeapon().Secondary.Delay * 0.001,0.25)
end
 

list.Set( "NPC", "mvm_bot_scout_major_league_boss", {
	Name = ENT.PrintName,
	Class = "mvm_bot_scout_major_league_boss",
	Category = ENT.Category,
	AdminOnly = true
} )