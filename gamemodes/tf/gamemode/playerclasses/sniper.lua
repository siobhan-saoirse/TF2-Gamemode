CLASS.Name = "Sniper"
CLASS.Speed = 300
CLASS.Health = 125

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("hud/class_sniperred"),
		surface.GetTextureID("hud/class_sniperblue")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("hud/leaderboard_class_sniper"),
		surface.GetTextureID("hud/leaderboard_class_sniper_d")
	}
end

CLASS.Loadout = {"tf_weapon_sniperrifle", "tf_weapon_smg", "tf_weapon_club"}
CLASS.DefaultLoadout = {"TF_WEAPON_SNIPERRIFLE", "TF_WEAPON_SMG", "TF_WEAPON_CLUB"}
CLASS.ModelName = "sniper"

CLASS.Gibs = {
	[GIB_LEFTLEG]		= GIBS_SNIPER_START,
	[GIB_RIGHTLEG]		= GIBS_SNIPER_START+1,
	[GIB_RIGHTARM]		= GIBS_SNIPER_START+2,
	[GIB_TORSO]			= GIBS_SNIPER_START+3,
	[GIB_HEAD]			= GIBS_SNIPER_START+4,
	[GIB_HEADGEAR1]		= GIBS_SNIPER_START+5,
	[GIB_HEADGEAR2]		= GIBS_SNIPER_START+6,
	[GIB_ORGAN]			= GIBS_ORGANS_START,
}

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

CLASS.AmmoMax = {
	[TF_PRIMARY]	= 25,		-- primary
	[TF_SECONDARY]	= 75,		-- secondary
	[TF_METAL]		= 100,		-- metal
	[TF_GRENADES1]	= 1,		-- grenades1
	[TF_GRENADES2]	= 0,		-- grenades2
}
