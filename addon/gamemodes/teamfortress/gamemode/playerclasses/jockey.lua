CLASS.Name = "Hunter"
CLASS.Speed = 3 * 90
CLASS.Health = 350

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("vgui/hud/pz_charge_jockey"),
		surface.GetTextureID("vgui/hud/pz_charge_jockey")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("vgui/hud/zombieteamimage_jockey"),
		surface.GetTextureID("vgui/hud/zombieteamimage_jockey")
	}
end

CLASS.Loadout = {"tf_weapon_fists","tf_weapon_rocketpack_hunter"}
CLASS.DefaultLoadout = {""}
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
	[TF_METAL]		= 100,		-- metal
	[TF_GRENADES1]	= 0,		-- grenades1
	[TF_GRENADES2]	= 0,		-- grenades2
}

if SERVER then

	function CLASS:Initialize()
		timer.Simple(0.1, function()
		
			self:SetModel("models/infected/jockey.mdl")
			self:SetNWString("L4DModel","models/infected/jockey.mdl")
			
		end)
		self:Give("tf_weapon_fists")
	end
	
end
