if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantscoutmelee"
ENT.Spawnable = false
ENT.AdminOnly = true		
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Major League Scout"
ENT.PreferredIcon = "hud/leaderboard_class_scout_stun"
ENT.Items = {"Batter's Helmet","Essential Accessories","Sandman"}
ENT.Category		= "TFBots: MVM"

function ENT:CustomOnInitialize(bot)
	timer.Create("SetModel"..bot:EntIndex(),0.1,10,function() 
		bot:SetModel("models/bots/scout_boss/bot_scout_boss.mdl")
		bot:SetNWBool("IsBoss",true)
		bot:SetModelScale(1.75)
		bot:SetClassSpeed(400)
		bot:SetHealth(1600)
		bot:SetMaxHealth(1600)
	bot:GetActiveWeapon().Secondary.Delay = math.max(bot:GetActiveWeapon().Secondary.Delay * 0.1,0.25)
end
 
list.Set( "NPC", "mvm_bot_scout_major_league", {
	Name = ENT.PrintName,
	Class = "mvm_bot_scout_major_league",
	Category = ENT.Category,
	AdminOnly = true
} )
