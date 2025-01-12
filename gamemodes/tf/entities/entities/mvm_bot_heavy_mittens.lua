if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "heavyweightchamp"
ENT.Spawnable = false 
ENT.AdminOnly = true
ENT.IsBoss = false
ENT.PrintName		= "Heavy Mittens"
ENT.Category		= "TFBots - MVM"
ENT.Items = {"Holiday Punch"}
ENT.OverrideModelScale = 0.65  
ENT.PreferredIcon = "hud/leaderboard_class_heavy_mittens"

function ENT:CustomOnInitialize(bot)
	bot:StripWeapons()
	bot:SetMaxHealth(60)
	bot:SetHealth(60)
	bot:SetModelScale(0.65)
end

list.Set( "NPC", "mvm_bot_heavy_mittens", {
	Name = ENT.PrintName,
	Class = "mvm_bot_heavy_mittens",
	Category = ENT.Category,
	AdminOnly = true
} )