CLASS.Name = "Medic"
CLASS.Speed = 320
CLASS.Health = 150

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("hud/class_medicred"),
		surface.GetTextureID("hud/class_medicblue")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("hud/leaderboard_class_medic"),
		surface.GetTextureID("hud/leaderboard_class_medic_d")
	}
end

CLASS.Loadout = {"tf_weapon_medigun", "tf_weapon_bonesaw"}
CLASS.DefaultLoadout = {"TF_WEAPON_MEDIGUN","TF_WEAPON_BONESAW"}
CLASS.ModelName = "medic"

CLASS.Gibs = {
	[GIB_LEFTLEG]		= GIBS_MEDIC_START,
	[GIB_RIGHTLEG]		= GIBS_MEDIC_START+1,
	[GIB_LEFTARM]		= GIBS_MEDIC_START+3,
	[GIB_RIGHTARM]		= GIBS_MEDIC_START+4,
	[GIB_TORSO]			= GIBS_MEDIC_START+5,
	[GIB_TORSO2]		= GIBS_MEDIC_START+2,
	[GIB_HEAD]			= GIBS_MEDIC_START+6,
	[GIB_HEADGEAR1]		= GIBS_MEDIC_START+7,
	[GIB_ORGAN]			= GIBS_ORGANS_START,
}

CLASS.Sounds = {
	paincrticialdeath = {
		Sound("vo/medic_paincrticialdeath01.wav"),
		Sound("vo/medic_paincrticialdeath02.wav"),
		Sound("vo/medic_paincrticialdeath03.wav"),
		Sound("vo/medic_paincrticialdeath04.wav"),
	},
	painsevere = {
		Sound("vo/medic_painsevere01.wav"),
		Sound("vo/medic_painsevere02.wav"),
		Sound("vo/medic_painsevere03.wav"),
		Sound("vo/medic_painsevere04.wav"),
	},
	painsharp = {
		Sound("vo/medic_painsharp01.wav"),
		Sound("vo/medic_painsharp02.wav"),
		Sound("vo/medic_painsharp03.wav"),
		Sound("vo/medic_painsharp04.wav"),
		Sound("vo/medic_painsharp05.wav"),
		Sound("vo/medic_painsharp06.wav"),
		Sound("vo/medic_painsharp07.wav"),
		Sound("vo/medic_painsharp08.wav"),
	},
}

CLASS.AmmoMax = {
	[TF_PRIMARY]	= 150,		-- primary
	[TF_SECONDARY]	= 150,		-- secondary
	[TF_METAL]		= 100,		-- metal
	[TF_GRENADES1]	= 0,		-- grenades1
	[TF_GRENADES2]	= 0,		-- grenades2
}

if SERVER then

CLASS.HasMedicRegeneration = true

function CLASS:Initialize()
	self:SetNWInt("Ubercharge", 0)
	self:Give("tf_weapon_shotgun")
	self:SelectWeapon("tf_weapon_shotgun")
end

end
