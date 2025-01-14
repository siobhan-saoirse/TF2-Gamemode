if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "melee_scout"
ENT.Spawnable = false
ENT.AdminOnly = true		
ENT.IsBoss = false
ENT.Difficulty = 2
ENT.PrintName		= "Hyper League Scout"
ENT.PreferredIcon = "hud/leaderboard_class_scout_stun"
ENT.Items = {"Batter's Helmet","Sandman"}
ENT.Category		= "TFBots - MVM"

function ENT:CustomOnInitialize(bot) 
	bot:GetActiveWeapon().Secondary.Delay = math.max(bot:GetActiveWeapon().Secondary.Delay * 0.25,0.25)
end
 
list.Set( "NPC", "mvm_bot_scout_hyper_league", {
	Name = ENT.PrintName,
	Class = "mvm_bot_scout_hyper_league",
	Category = ENT.Category,
	AdminOnly = true
} )