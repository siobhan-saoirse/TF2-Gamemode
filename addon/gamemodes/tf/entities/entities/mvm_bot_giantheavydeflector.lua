if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantheavy"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.Difficulty = 3
ENT.PrintName		= "Giant Deflector Heavy"
ENT.Items = {"U-clank-a","Deflector"}
ENT.Category		= "TFBots - MVM"
ENT.PreferredIcon = "hud/leaderboard_class_heavy_deflector" 
list.Set( "NPC", "mvm_bot_giantheavydeflector", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantheavydeflector",
	Category = ENT.Category,
	--AdminOnly = true
	AdminOnly = false
} )