if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantheavy"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Chief Heal-on-Kill Heavy"
ENT.PreferredName		= "Giant Heal-on-Kill Heavy"
ENT.Items = {"Tungsten Toque","Deflector"}
ENT.Category		= "TFBots: MVM"
ENT.PreferredIcon = "hud/leaderboard_class_heavy_deflector_healonkill"
ENT.VisionLimits = 1600

function ENT:CustomOnInitialize(bot)
	timer.Create("SetModel"..bot:EntIndex(),0.1,10,function() 
		bot:SetModelScale(1.8)
		bot:SetHealth(60000)
		bot:SetMaxHealth(60000)
	end)
end
function ENT:CustomOnKillEnemy(bot)
	GAMEMODE:HealPlayer(bot,bot,8000,true,false)
end
list.Set( "NPC", "mvm_bot_giantheavydeflector_healonkill_boss", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantheavydeflector_healonkill_boss",
	Category = ENT.Category,
	AdminOnly = true
} )