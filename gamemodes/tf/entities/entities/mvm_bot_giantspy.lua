if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "spy"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.PrintName		= "Giant Spy"
ENT.Category		= "TFBots - MVM"

function ENT:CustomOnInitialize(bot)
	timer.Create("SetModel"..bot:EntIndex(),0.1,10,function() 
		bot:SetModel("models/bots/spy/bot_spy.mdl")
		bot:SetNWBool("IsBoss",true)
		bot:SetClassSpeed(320 * 0.5)
		bot:SetModelScale(1.75)
		bot:SetHealth(1600)
		bot:SetMaxHealth(1600)
	end)
end

list.Set( "NPC", "mvm_bot_giantspy", {
	Name = ENT.PrintName, 
	Class = "mvm_bot_giantspy",
	Category = ENT.Category,
	AdminOnly = true
} )