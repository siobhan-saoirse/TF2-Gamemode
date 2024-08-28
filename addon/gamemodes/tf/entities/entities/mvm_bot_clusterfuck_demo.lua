if (!IsMounted("tf") and !IsMounted("cstrike")) then return end
if SERVER then AddCSLuaFile() end

ENT.Base = "mvm_bot"
ENT.PZClass = "wtfdemoman"
ENT.Spawnable = false
ENT.AdminOnly = true 
ENT.IsBoss = true
ENT.PrintName		= "WTF Demoman"
ENT.Category		= "TFBots - MVM"


list.Set( "NPC", "mvm_bot_clusterfuck_demo", {
	Name = ENT.PrintName,
	Class = "mvm_bot_clusterfuck_demo",
	Category = ENT.Category,
	AdminOnly = true
} )