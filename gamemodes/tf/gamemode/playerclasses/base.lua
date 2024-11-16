CLASS.Name = "undefined"
CLASS.Speed = 300
CLASS.Health = 100

CLASS.ModelName = "scout"
CLASS.Loadout = {"Fists"}
CLASS.DefaultLoadout = {"weapon_fists"}
CLASS.Gibs = {
	[GIB_LEFTLEG]		= GIBS_HEAVY_START,
	[GIB_RIGHTLEG]		= GIBS_HEAVY_START+1,
	[GIB_RIGHTARM]		= GIBS_HEAVY_START+4,
	[GIB_TORSO]			= GIBS_HEAVY_START+5,
	[GIB_TORSO2]		= GIBS_HEAVY_START+3,
	[GIB_EQUIPMENT1]	= GIBS_HEAVY_START+2,
	[GIB_EQUIPMENT2]	= GIBS_HEAVY_START+2,
	[GIB_HEAD]			= GIBS_HEAVY_START+6,
	[GIB_ORGAN]			= GIBS_ORGANS_START,
}
----------------------------------------

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
	[TF_PRIMARY]	= 200,		-- primary
	[TF_SECONDARY]	= 32,		-- secondary
	[TF_METAL]		= 100,		-- metal
	[TF_GRENADES1]	= 0,		-- grenades1
	[TF_GRENADES2]	= 0,		-- grenades2
}

if SERVER then

	function CLASS:Initialize()
		util.PrecacheModel("models/player.mdl")
		self:SetModel("models/player.mdl")
		self:Give("weapon_fists")
	end
	
end