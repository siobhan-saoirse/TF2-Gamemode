CLASS.Name = "Witch"
CLASS.Speed = 3 * 105
CLASS.Health = 1000

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("vgui/logos/spray_stencil_witch_01"),
		surface.GetTextureID("vgui/logos/spray_stencil_witch_01")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("vgui/logos/spray_stencil_witch_01"),
		surface.GetTextureID("vgui/logos/spray_stencil_witch_01")
	}
end

CLASS.Loadout = {"tf_weapon_fists"}
CLASS.DefaultLoadout = {"TF_WEAPON_FISTS"}
CLASS.ModelName = "scout"
CLASS.IsL4D = true
----------------------------------------

/* Setting this function to "true" prevents T posing when being moved while crouching with the minigun winded up, however also breaks the crouch movement animations. Relates to an animation blending issue not defined here, so I will set the value to "false" for debugging reasons. */

CLASS.NoDeployedCrouchwalk = false

----------------------------------------

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
		self:SetModel("models/infected/witch.mdl")
	end
	
end
