if CLIENT then
	CLASS.ScoreboardImage = {
		surface.GetTextureID("vgui/modicon.vmt"),
	}
end

CLASS.Name = "Bonzi"
CLASS.Speed = 105
CLASS.Health = 69

CLASS.DefaultLoadout = {}
CLASS.Loadout = {
	"weapon_crowbar",
	"weapon_pistol",
	"weapon_smg1",
	"weapon_frag",
	"weapon_physcannon",
	"weapon_crossbow",
	"weapon_shotgun",
	"weapon_357",
	"weapon_rpg",
	"weapon_ar2",
	
	"gmod_tool",
	"gmod_camera",
	"weapon_physgun",
}

CLASS.ModelName = "sniper"

CLASS.IsHL2 = true


CLASS.Gibs = {
	[GIB_LEFTLEG]		= GIBS_LAST+1,
	[GIB_RIGHTLEG]		= GIBS_LAST+1, 
	[GIB_RIGHTARM]		= GIBS_LAST+1,
	[GIB_TORSO]			= GIBS_LAST+1,
	[GIB_TORSO2]		= GIBS_LAST+1,
	[GIB_EQUIPMENT1]	= GIBS_LAST+1,
	[GIB_EQUIPMENT2]	= GIBS_LAST+1,
	[GIB_HEAD]			= GIBS_LAST+1,
	[GIB_ORGAN]			= GIBS_ORGANS_START,
}
CLASS.IsHL1Mounted = IsMounted("hl1") || IsMounted("hl1mp")
CLASS.Sounds = {
	paincrticialdeath = {
		Sound("vo/sniper_paincrticialdeath01.wav"),
		Sound("vo/sniper_paincrticialdeath02.wav"),
		Sound("vo/sniper_paincrticialdeath03.wav"),
		Sound("vo/sniper_paincrticialdeath04.wav"),
	},
	painsevere = {
		Sound("vo/sniper_painsevere01.wav"),
		Sound("vo/sniper_painsevere02.wav"),
		Sound("vo/sniper_painsevere03.wav"),
		Sound("vo/sniper_painsevere04.wav"),
	},
	painsharp = {
		Sound("vo/sniper_painsharp01.wav"),
		Sound("vo/sniper_painsharp02.wav"),
		Sound("vo/sniper_painsharp03.wav"),
		Sound("vo/sniper_painsharp04.wav"),
	},
}

if SERVER then

function CLASS:Initialize()
	local cl_playermodel = self:GetInfo("cl_playermodel")
	self:SetModel("models/bonzi/bonzibuddy.mdl")
	self:RemoveSuit()
	self:Give("weapon_fists")
	self:Give("none")
	local cl_defaultweapon = self:GetInfo("cl_defaultweapon")

	self:SelectWeapon("none") 
end

end