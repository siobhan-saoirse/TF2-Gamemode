if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantengineer"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Giant Engineer"
ENT.Category		= "TFBots - MVM"

function ENT:CustomOnInitialize(bot)
	timer.Create("SetModel"..bot:EntIndex(),0.1,10,function() 
		bot:SetModel("models/bots/engineer/bot_engineer.mdl")
		bot:SetNWBool("IsBoss",true)
		bot:SetModelScale(1.75)
	end)
end

list.Set( "NPC", "mvm_bot_giantengineer", {
	Name = ENT.PrintName, 
	Class = "mvm_bot_giantengineer",
	Category = ENT.Category,
	--AdminOnly = true
	AdminOnly = false
} )