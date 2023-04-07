if (!IsMounted("tf")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "giantheavyshotgun"
ENT.Spawnable = false
ENT.AdminOnly = true
ENT.IsBoss = true
ENT.PrintName		= "Giant Shotgun Heavy"
ENT.Category		= "TF2: MVM Bots"
ENT.PreferredIcon = "hud/leaderboard_class_heavy_shotgun_giant"

list.Set( "NPC", "mvm_bot_giantshotgunheavy", {
	Name = ENT.PrintName,
	Class = "mvm_bot_giantshotgunheavy",
	Category = ENT.Category,
	AdminOnly = true
} )