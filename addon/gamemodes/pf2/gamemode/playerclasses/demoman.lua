CLASS.Name = "Demoman"
CLASS.Speed = 280
CLASS.Health = 90
CLASS.Armor = 100

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("hud/class_demored"),
		surface.GetTextureID("hud/class_demoblue")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("hud/leaderboard_class_demo"),
		surface.GetTextureID("hud/leaderboard_class_demo_d")
	}
end

CLASS.Loadout = {"tf_weapon_grenadelauncher", "tf_weapon_pipebomblauncher", "tf_weapon_bottle"}
CLASS.DefaultLoadout = {"TF_WEAPON_GRENADELAUNCHER", "TF_WEAPON_PIPEBOMBLAUNCHER", "TF_WEAPON_BOTTLE"}
CLASS.ModelName = "demo"

CLASS.Gibs = {
	[GIB_LEFTLEG]		= GIBS_DEMOMAN_START,
	[GIB_RIGHTLEG]		= GIBS_DEMOMAN_START+1,
	[GIB_LEFTARM]		= GIBS_DEMOMAN_START+2,
	[GIB_RIGHTARM]		= GIBS_DEMOMAN_START+3,
	[GIB_TORSO]			= GIBS_DEMOMAN_START+4,
	[GIB_HEAD]			= GIBS_DEMOMAN_START+5,
	[GIB_ORGAN]			= GIBS_ORGANS_START,
}

CLASS.Sounds = {
	paincrticialdeath = {
		Sound("vo/demoman_paincrticialdeath01.wav"),
		Sound("vo/demoman_paincrticialdeath02.wav"),
		Sound("vo/demoman_paincrticialdeath03.wav"),
		Sound("vo/demoman_paincrticialdeath04.wav"),
		Sound("vo/demoman_paincrticialdeath05.wav"),
	},
	painsevere = {
		Sound("vo/demoman_painsevere01.wav"),
		Sound("vo/demoman_painsevere02.wav"),
		Sound("vo/demoman_painsevere03.wav"),
		Sound("vo/demoman_painsevere04.wav"),
	},
	painsharp = {
		Sound("vo/demoman_painsharp01.wav"),
		Sound("vo/demoman_painsharp02.wav"),
		Sound("vo/demoman_painsharp03.wav"),
		Sound("vo/demoman_painsharp04.wav"),
		Sound("vo/demoman_painsharp05.wav"),
		Sound("vo/demoman_painsharp06.wav"),
		Sound("vo/demoman_painsharp07.wav"),
	},
}

CLASS.AmmoMax = {
	[TF_PRIMARY]	= 30,		-- primary
	[TF_SECONDARY]	= 32,		-- secondary
	[TF_METAL]		= 100,		-- metal
	[TF_GRENADES1]	= 2,		-- grenades1
	[TF_GRENADES2]	= 2,		-- grenades2
}
