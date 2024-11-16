CLASS.Name = "Engineer"
CLASS.Speed = 300 * 0.6
CLASS.Health = 2500

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("hud/class_engired"),
		surface.GetTextureID("hud/class_engiblue")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("hud/leaderboard_class_engineer"),
		surface.GetTextureID("hud/leaderboard_class_engineer_d")
	}
end

CLASS.Loadout = {"tf_weapon_shotgun_primary", "tf_weapon_pistol", "tf_weapon_wrench",
	"tf_weapon_pda_engineer_build", "tf_weapon_pda_engineer_destroy"}
CLASS.DefaultLoadout = {"Shotgun","TF_WEAPON_PISTOL","TF_WEAPON_WRENCH",
	"TF_WEAPON_PDA_ENGINEER_BUILD","TF_WEAPON_PDA_ENGINEER_DESTROY"}
CLASS.ModelName = "engineer"

CLASS.Buildings = {"OBJ_SENTRYGUN", "OBJ_DISPENSER", "OBJ_TELEPORTER"}

CLASS.Gibs = {
	[GIB_LEFTLEG]		= GIBS_ENGINEER_START,
	[GIB_RIGHTARM]		= GIBS_ENGINEER_START+2,
	[GIB_TORSO]			= GIBS_ENGINEER_START+4,
	[GIB_TORSO2]		= GIBS_ENGINEER_START+1,
	[GIB_EQUIPMENT1]	= GIBS_ENGINEER_START+3,
	[GIB_HEAD]			= GIBS_ENGINEER_START+5,
	[GIB_HEADGEAR1]		= GIBS_ENGINEER_START+6,
	[GIB_ORGAN]			= GIBS_ORGANS_START,
}

CLASS.Sounds = {
	paincrticialdeath = {
		Sound("vo/engineer_paincrticialdeath01.wav"),
		Sound("vo/engineer_paincrticialdeath02.wav"),
		Sound("vo/engineer_paincrticialdeath03.wav"),
		Sound("vo/engineer_paincrticialdeath04.wav"),
		Sound("vo/engineer_paincrticialdeath05.wav"),
		Sound("vo/engineer_paincrticialdeath06.wav"),
	},
	painsevere = {
		Sound("vo/engineer_painsevere01.wav"),
		Sound("vo/engineer_painsevere02.wav"),
		Sound("vo/engineer_painsevere03.wav"),
		Sound("vo/engineer_painsevere04.wav"),
		Sound("vo/engineer_painsevere05.wav"),
		Sound("vo/engineer_painsevere06.wav"),
		Sound("vo/engineer_painsevere07.wav"),
	},
	painsharp = {
		Sound("vo/engineer_painsharp01.wav"),
		Sound("vo/engineer_painsharp02.wav"),
		Sound("vo/engineer_painsharp03.wav"),
		Sound("vo/engineer_painsharp04.wav"),
		Sound("vo/engineer_painsharp05.wav"),
		Sound("vo/engineer_painsharp06.wav"),
		Sound("vo/engineer_painsharp07.wav"),
		Sound("vo/engineer_painsharp08.wav"),
	},
}

CLASS.AmmoMax = {
	[TF_PRIMARY]	= 32,		-- primary
	[TF_SECONDARY]	= 200,		-- secondary
	[TF_METAL]		= 200,		-- metal
	[TF_GRENADES1]	= 0,		-- grenades1
	[TF_GRENADES2]	= 0,		-- grenades2
}
