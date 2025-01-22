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
	bot:GetActiveWeapon().Secondary.Delay = math.max(bot:GetActiveWeapon().Secondary.Delay * 0.1,0.25)
end
 
list.Set( "NPC", "mvm_bot_scout_major_league", {
	Name = ENT.PrintName,
	Class = "mvm_bot_scout_major_league",
	Category = ENT.Category,
	AdminOnly = true
} )