if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantheavy"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Giant Heal-on-Kill Heavy (Type 2)"
ENT.PreferredName	= "Giant Heavy"
ENT.Items = {"Deflector"}
ENT.Category		= "TFBots: MVM"
ENT.PreferredIcon = "hud/leaderboard_class_heavy_deflector_healonkill" 
ENT.VisionLimits = 1200

function ENT:CustomOnKillEnemy(bot)
	GAMEMODE:HealPlayer(bot,bot,5000,true,false)
end
list.Set( "NPC", "mvm_bot_giantheavydeflector_healonkill2", {
	Name = ENT.PrintName, 
	Class = "mvm_bot_giantheavydeflector_healonkill2",
	Category = ENT.Category,
	AdminOnly = true
} )