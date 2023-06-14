if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantdemoman"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Giant Burst Fire Demo"
ENT.Category		= "TF2: MVM Bots"


function ENT:CustomOnInitialize(bot)
	bot:GetActiveWeapon().Primary.Delay = 0.6 * 0.1
	bot:GetActiveWeapon().ReloadTime = 0.6 * 0.65
	bot:GetActiveWeapon().Primary.ClipSize = 4 + 7
	bot:GetActiveWeapon().Force = 1100 * 1.1
end

list.Set( "NPC", "mvm_bot_giantburstfiredemoman", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantburstfiredemoman",
	Category = ENT.Category,
	--AdminOnly = true
	AdminOnly = false
} )