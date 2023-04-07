CLASS.Name = "Zombie"
CLASS.Speed = 87
CLASS.Health = 100

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("effects/skull001_hud"),
		surface.GetTextureID("effects/skull001_hud")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("effects/skull001_hud"),
		surface.GetTextureID("effects/skull001_hud")
	}
end

CLASS.Loadout = {"tf_weapon_fists"}
CLASS.DefaultLoadout = {""}
CLASS.ModelName = "heavy"

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
	[TF_METAL]		= 100,		-- metal
	[TF_GRENADES1]	= 0,		-- grenades1
	[TF_GRENADES2]	= 0,		-- grenades2
}

if SERVER then

	function CLASS:Initialize()
		self:SetModel(table.Random({"models/cpthazama/l4d1/common/male_01.mdl","models/cpthazama/l4d1/common/common_female01.mdl","models/cpthazama/l4d1/common/common_female_nurse01.mdl","models/cpthazama/l4d1/common/common_male_baggagehandler_01.mdl","models/cpthazama/l4d1/common/common_male_pilot.mdl","models/cpthazama/l4d1/common/common_male_suit.mdl","models/cpthazama/l4d1/common/common_military_male01.mdl","models/cpthazama/l4d1/common/common_patient_male01.mdl","models/cpthazama/l4d1/common/common_police_male01.mdl","models/cpthazama/l4d1/common/common_surgeon_male01.mdl","models/cpthazama/l4d1/common/common_surgeon_male01.mdl","models/cpthazama/l4d1/common/common_worker_male01_test.mdl","models/cpthazama/l4d2/common/common_male_ceda.mdl","models/cpthazama/l4d2/common/common_male_clown.mdl","models/cpthazama/l4d2/common/common_male_fallen_survivor.mdl","models/cpthazama/l4d2/common/common_male_jimmy.mdl","models/cpthazama/l4d2/common/common_male_mud.mdl","models/cpthazama/l4d2/common/common_male_riot.mdl","models/cpthazama/l4d2/common/common_male_roadcrew.mdl","models/cpthazama/l4d2/common/common_male_roadcrew_rain.mdl"}))
		self:Give("tf_weapon_fists")
	end
	
end
