CLASS.Name = "Civilian_"
CLASS.Speed = 300
CLASS.Health = 50

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("hud/class_civred"),
		surface.GetTextureID("hud/class_civblue")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("hud/leaderboard_class_dead"),
		surface.GetTextureID("hud/leaderboard_class_dead")
	}
end

CLASS.Loadout = {}
CLASS.ModelName = "civilian"

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
		Sound("vo/heavy_paincrticialdeath01.wav"),
		Sound("vo/heavy_paincrticialdeath02.wav"),
		Sound("vo/heavy_paincrticialdeath03.wav"),
	},
	painsevere = {
		Sound("vo/heavy_painsevere01.wav"),
		Sound("vo/heavy_painsevere02.wav"),
		Sound("vo/heavy_painsevere03.wav"),
	},
	painsharp = {
		Sound("vo/heavy_painsharp01.wav"),
		Sound("vo/heavy_painsharp02.wav"),
		Sound("vo/heavy_painsharp03.wav"),
		Sound("vo/heavy_painsharp04.wav"),
		Sound("vo/heavy_painsharp05.wav"),
	},
}

CLASS.AmmoMax = {
	[TF_PRIMARY]	= 0,		-- primary
	[TF_SECONDARY]	= 0,		-- secondary
	[TF_METAL]		= 100,		-- metal
	[TF_GRENADES1]	= 0,		-- grenades1
	[TF_GRENADES2]	= 0,		-- grenades2
}

if SERVER then

	function CLASS:Initialize()
		self:StripWeapons()
		self:Give("tf_weapon_fireaxe")
	end
	
end