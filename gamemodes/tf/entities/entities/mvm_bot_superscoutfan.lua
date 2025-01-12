if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "scout"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Force-A-Nature Super Scout"
ENT.Category		= "TFBots - MVM"
ENT.PreferredIcon = "hud/leaderboard_class_scout_fan"
ENT.Items = {"Force-A-Nature","Bolt Boy","Fed-Fightin' Fedora"}

function ENT:CustomOnInitialize(bot)
	timer.Create("SetModel"..bot:EntIndex(),0.1,10,function() 
		bot:SetModel("models/bots/scout_boss/bot_scout_boss.mdl")
		bot:SetNWBool("IsBoss",true)
		bot:SetClassSpeed(400 * 1.2)
		bot:SetModelScale(1.75)
		bot:SetHealth(1200)
		bot:SetMaxHealth(1200)
	end)
end

list.Set( "NPC", "mvm_bot_superscoutfan", {
	Name = ENT.PrintName,
	Class = "mvm_bot_superscoutfan",
	Category = ENT.Category,
	AdminOnly = true,
	--AdminOnly = true
	AdminOnly = false
} )