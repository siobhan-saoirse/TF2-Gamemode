CLASS.Name = "Scientist"
CLASS.Speed = 320
CLASS.Health = 80

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("console/characters/zombie_heavy"),
		surface.GetTextureID("console/characters/zombie_heavy")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("console/characters/zombie_heavy"),
		surface.GetTextureID("console/characters/zombie_heavy")
	}
end

CLASS.Loadout = {"tf_weapon_scientist_syringe"}
CLASS.ModelName = "heavy"



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
	self:SetModel("models/scientist.mdl")
	self:StripWeapons()
	self:Give("tf_weapon_scientist_syringe")
end

end

