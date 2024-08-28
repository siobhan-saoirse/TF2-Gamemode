CLASS.Name = "Hunter"
CLASS.Speed = 210
CLASS.Health = 200

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("hud/class_heavyred"),
		surface.GetTextureID("hud/class_heavyblue")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID(""),
		surface.GetTextureID("")
	}
end

CLASS.ModelName = "heavy"
CLASS.IsL4D = true
----------------------------------------

/* Setting this function to "true" prevents T posing when being moved while crouching with the minigun winded up, however also breaks the crouch movement animations. Relates to an animation blending issue not defined here, so I will set the value to "false" for debugging reasons. */

CLASS.NoDeployedCrouchwalk = false

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
	["Buckshot"]	= 32,		-- buckshot
	[TF_METAL]		= 100,		-- metal
	[TF_GRENADES1]	= 0,		-- grenades1
	[TF_GRENADES2]	= 0,		-- grenades2
}

CLASS.AdditionalAmmo = {
	Pistol = 256,
	SMG1 = 256,
	grenade = 5,
	Buckshot = 64,
	["357"] = 32,
	XBowBolt = 32,
	AR2AltFire = 6,
	AR2 = 100,
	SMG1_Grenade = 6,
}

if SERVER then

	function CLASS:Initialize()
		self:SetModel("models/l4d2/survivor_coach.mdl")
		self:Give("weapon_spas12_l4d")
		self:Give("weapon_l4d2_pistol")
		self:Give("weapon_l4d2_fireaxe")
		self:Give("weapon_l4d2_first_aid_kit")
		
	end
	
end
