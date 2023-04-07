CLASS.Name = "Spitter"
CLASS.Speed = 3 * 87
CLASS.Health = 100

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("vgui/hud/pz_charge_spitter"),
		surface.GetTextureID("vgui/hud/pz_charge_spitter")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("vgui/hud/zombieteamimage_spitter"),
		surface.GetTextureID("vgui/hud/zombieteamimage_spitter")
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
		
		timer.Simple(0.1, function()
		
			self:SetModel("models/infected/spitter.mdl")
			self:SetNWString("L4DModel","models/infected/spitter.mdl")
			
		end)
		self:Give("tf_weapon_fists")
		ParticleEffectAttach("spitter_drool",PATTACH_POINT_FOLLOW,self,5)
		ParticleEffectAttach("spitter_drool_foam",PATTACH_POINT_FOLLOW,self,5)
		ParticleEffectAttach("spitter_drool_droplets",PATTACH_POINT_FOLLOW,self,5)
	end
	
end
