if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "sniper"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Giant Sniper"
ENT.Category		= "TFBots: MVM"

function ENT:CustomOnInitialize(bot)
	timer.Create("SetModel"..bot:EntIndex(),0.1,10,function() 
		bot:SetModel("models/bots/sniper/bot_sniper.mdl")
		bot:SetNWBool("IsBoss",true)
		bot:SetClassSpeed(300 * 0.5)
		bot:SetModelScale(1.75)
		bot:SetHealth(1600)
		bot:SetMaxHealth(1600)
	end)
end

list.Set( "NPC", "mvm_bot_giantsniper", {
	Name = ENT.PrintName, 
	Class = "mvm_bot_giantsniper",
	Category = ENT.Category,
	AdminOnly = true
} )