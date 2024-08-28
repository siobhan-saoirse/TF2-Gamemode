CLASS.Name = "Boomer"
CLASS.Speed = 170
CLASS.Health = 50

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("vgui/hud/pz_charge_boomer"),
		surface.GetTextureID("vgui/hud/pz_charge_boomer")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("vgui/hud/zombieteamimage_boomer"),
		surface.GetTextureID("vgui/hud/zombieteamimage_boomer")
	}
end

CLASS.Loadout = {"tf_weapon_fists"}
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
		local model = table.Random({"models/infected/boomer.mdl","models/infected/boomer.mdl","models/infected/boomer.mdl","models/infected/boomer.mdl","models/infected/boomer_l4d1.mdl","models/infected/boomette.mdl"})
		timer.Simple(0.1, function()
		
			self:SetModel(model)
			self:SetNWString("L4DModel",model)
			
		end)
		self:Give("tf_weapon_fists")
	end
	
end
