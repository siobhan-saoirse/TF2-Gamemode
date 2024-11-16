CLASS.Name = "Scout"
CLASS.Speed = 400
CLASS.Health = 125

PrecacheParticleSystem("doublejump_puff")

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("hud/class_scoutred"),
		surface.GetTextureID("hud/class_scoutblue")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("hud/leaderboard_class_scout"),
		surface.GetTextureID("hud/leaderboard_class_scout_d")
	}
end

CLASS.Loadout = {"tf_weapon_scattergun", "tf_weapon_pistol_scout", "tf_weapon_bat"}
CLASS.DefaultLoadout = {"TF_WEAPON_BAT"}
CLASS.ModelName = "scout"

CLASS.Gibs = {
	[GIB_LEFTLEG]		= GIBS_SCOUT_START,
	[GIB_RIGHTLEG]		= GIBS_SCOUT_START+1,
	[GIB_LEFTARM]		= GIBS_SCOUT_START+3,
	[GIB_RIGHTARM]		= GIBS_SCOUT_START+4,
	[GIB_TORSO]			= GIBS_SCOUT_START+5,
	[GIB_TORSO2]		= GIBS_SCOUT_START+2,
	[GIB_HEAD]			= GIBS_SCOUT_START+6,
	[GIB_HEADGEAR1]		= GIBS_SCOUT_START+7,
	[GIB_HEADGEAR2]		= GIBS_SCOUT_START+8,
	[GIB_ORGAN]			= GIBS_ORGANS_START,
}

CLASS.Sounds = {
	paincrticialdeath = {
		Sound("vo/scout_paincrticialdeath01.wav"),
		Sound("vo/scout_paincrticialdeath02.wav"),
		Sound("vo/scout_paincrticialdeath03.wav"),
	},
	painsevere = {
		Sound("vo/scout_painsevere01.wav"),
		Sound("vo/scout_painsevere02.wav"),
		Sound("vo/scout_painsevere03.wav"),
		Sound("vo/scout_painsevere04.wav"),
		Sound("vo/scout_painsevere05.wav"),
		Sound("vo/scout_painsevere06.wav"),
	},
	painsharp = {
		Sound("vo/scout_painsharp01.wav"),
		Sound("vo/scout_painsharp02.wav"),
		Sound("vo/scout_painsharp03.wav"),
		Sound("vo/scout_painsharp04.wav"),
		Sound("vo/scout_painsharp05.wav"),
		Sound("vo/scout_painsharp06.wav"),
		Sound("vo/scout_painsharp07.wav"),
		Sound("vo/scout_painsharp08.wav"),
	},
}

CLASS.AmmoMax = {
	[TF_PRIMARY]	= 32,		-- primary
	[TF_SECONDARY]	= 36,		-- secondary
	[TF_METAL]		= 100,		-- metal
	[TF_GRENADES1]	= 1,		-- grenades1
	[TF_GRENADES2]	= 1,		-- grenades2
}
