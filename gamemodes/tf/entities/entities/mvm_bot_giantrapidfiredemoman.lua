if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantdemoman"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Giant Rapid Fire Demoman"
ENT.Category		= "TFBots - MVM"


function ENT:CustomOnInitialize(bot)
	bot:GetActiveWeapon().Primary.Delay = 0.6 * 0.75
	bot:GetActiveWeapon().ReloadTime = 0.6 * -0.4
end

list.Set( "NPC", "mvm_bot_giantrapidfiredemoman", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantrapidfiredemoman",
	Category = ENT.Category,
	AdminOnly = true
} )