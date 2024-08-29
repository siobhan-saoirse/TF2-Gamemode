if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "heavy"
ENT.Spawnable = false
ENT.AdminOnly = false
ENT.IsBoss = false
ENT.Items = {"U-clank-a","Deflector"}	
ENT.PrintName		= "Deflector Heavy" 
ENT.Category		= "TFBots - MVM"
ENT.PreferredIcon = "hud/leaderboard_class_heavy_deflector"
list.Set( "NPC", "mvm_bot_deflectorheavy", {
	Name = ENT.PrintName,
	Class = "mvm_bot_deflectorheavy"	,
	Category = ENT.Category,
	AdminOnly = true
} )