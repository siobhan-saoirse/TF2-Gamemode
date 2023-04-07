CLASS.Name = "Spy"
CLASS.Speed = 320
CLASS.Health = 90
CLASS.Armor = 50

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("hud/class_spyred"),
		surface.GetTextureID("hud/class_spyblue")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("hud/leaderboard_class_spy"),
		surface.GetTextureID("hud/leaderboard_class_spy_d")
	}
end

CLASS.Loadout = {"tf_weapon_tranq", "tf_weapon_revolver", "tf_weapon_sapper", "tf_weapon_knife", "tf_weapon_pda_spy"}
CLASS.DefaultLoadout = {"TF_WEAPON_TRANQ","TF_WEAPON_REVOLVER", "TF_WEAPON_KNIFE", "TF_WEAPON_PDA_SPY", "TF_WEAPON_INVIS"}
CLASS.ModelName = "spy"
CLASS.Gibs = {
	[GIB_LEFTLEG]		= GIBS_SPY_START,
	[GIB_RIGHTLEG]		= GIBS_SPY_START+1,
	[GIB_LEFTARM]		= GIBS_SPY_START+2,
	[GIB_RIGHTARM]		= GIBS_SPY_START+3,
	[GIB_TORSO]			= GIBS_SPY_START+5,
	[GIB_TORSO2]		= GIBS_SPY_START+4,
	[GIB_HEAD]			= GIBS_SPY_START+6,
	[GIB_ORGAN]			= GIBS_ORGANS_START,
}

CLASS.Sounds = {
	paincrticialdeath = {
		Sound("vo/spy_paincrticialdeath01.wav"),
		Sound("vo/spy_paincrticialdeath02.wav"),
		Sound("vo/spy_paincrticialdeath03.wav"),
	},
	painsevere = {
		Sound("vo/spy_painsevere01.wav"),
		Sound("vo/spy_painsevere02.wav"),
		Sound("vo/spy_painsevere03.wav"),
		Sound("vo/spy_painsevere04.wav"),
		Sound("vo/spy_painsevere05.wav"),
	},
	painsharp = {
		Sound("vo/spy_painsharp01.wav"),
		Sound("vo/spy_painsharp02.wav"),
		Sound("vo/spy_painsharp03.wav"),
		Sound("vo/spy_painsharp04.wav"),
	},
}

CLASS.AmmoMax = {
	[TF_PRIMARY]	= 24,		-- primary
	[TF_SECONDARY]	= 24,		-- secondary
	[TF_METAL]		= 100,		-- metal
	[TF_GRENADES1]	= 0,		-- grenades1
	[TF_GRENADES2]	= 1,		-- grenades2
}

if SERVER then

	function CLASS:Initialize()
		self:Give("tf_weapon_builder")
	end

end