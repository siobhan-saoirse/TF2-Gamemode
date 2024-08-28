CLASS.Name = "Mercenary"
CLASS.Speed = 300
CLASS.Health = 150

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("hud/class_mercenaryred"),
		surface.GetTextureID("hud/class_mercenaryblue")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("hud/leaderboard_class_spy"),
		surface.GetTextureID("hud/leaderboard_class_spy")
	}
end 

CLASS.Loadout = {"tf_weapon_fists"}
CLASS.DefaultLoadout = {"Frying Pan","Pistol","Original"}
CLASS.ModelName = "soldier"

CLASS.Gibs = { 
	[GIB_LEFTLEG]		= GIBS_SOLDIER_START,
	[GIB_RIGHTLEG]		= GIBS_SOLDIER_START+1,
	[GIB_RIGHTARM]		= GIBS_SOLDIER_START+2,
	[GIB_TORSO]			= GIBS_SOLDIER_START+5,
	[GIB_EQUIPMENT1]	= GIBS_SOLDIER_START+3,
	[GIB_EQUIPMENT2]	= GIBS_SOLDIER_START+4,
	[GIB_HEAD]			= GIBS_SOLDIER_START+6,
	[GIB_HEADGEAR1]		= GIBS_SOLDIER_START+7,
	[GIB_ORGAN]			= GIBS_ORGANS_START,
}

CLASS.Sounds = {
	paincrticialdeath = {
		Sound("vo/soldier_paincrticialdeath01.wav"),
		Sound("vo/soldier_paincrticialdeath02.wav"),
		Sound("vo/soldier_paincrticialdeath03.wav"),
		Sound("vo/soldier_paincrticialdeath04.wav"),
	},
	painsevere = {
		Sound("vo/soldier_painsevere01.wav"),
		Sound("vo/soldier_painsevere02.wav"),
		Sound("vo/soldier_painsevere03.wav"),
		Sound("vo/soldier_painsevere04.wav"),
		Sound("vo/soldier_painsevere05.wav"),
		Sound("vo/soldier_painsevere06.wav"),
	},
	painsharp = {
		Sound("vo/soldier_painsharp01.wav"),
		Sound("vo/soldier_painsharp02.wav"),
		Sound("vo/soldier_painsharp03.wav"),
		Sound("vo/soldier_painsharp04.wav"),
		Sound("vo/soldier_painsharp05.wav"),
		Sound("vo/soldier_painsharp06.wav"),
		Sound("vo/soldier_painsharp07.wav"),
		Sound("vo/soldier_painsharp08.wav"),
	},
}

CLASS.AmmoMax = {
	[TF_PRIMARY]	= 20,		-- primary
	[TF_SECONDARY]	= 200,		-- secondary
	[TF_METAL]		= 220,		-- metal
	[TF_GRENADES1]	= 0,		-- grenades1
	[TF_GRENADES2]	= 0,		-- grenades2
}

if SERVER then

function CLASS:Initialize()
	self:SetModel("models/player/mercenary.mdl")
end

end
