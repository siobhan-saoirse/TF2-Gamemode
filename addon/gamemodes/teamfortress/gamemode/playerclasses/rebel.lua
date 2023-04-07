CLASS.Name = "Civilian"
CLASS.Speed = 3 * 96
CLASS.Health = 80

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("decals/lambdaspray_2a"),
		surface.GetTextureID("decals/lambdaspray_2a")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("hud/leaderboard_class_spy"),
		surface.GetTextureID("hud/leaderboard_class_spy")
	}
end

CLASS.Loadout = {"tf_weapon_capsulelauncher","tf_weapon_trenchknife"}
CLASS.ModelName = "scout"

CLASS.AmmoMax = {
	[TF_PRIMARY]	= 200,		-- primary
	[TF_SECONDARY]	= 110,		-- secondary
	[TF_METAL]		= 100,		-- metal
	[TF_GRENADES1]	= 2,		-- grenades1
	[TF_GRENADES2]	= 0,		-- grenades2
}

CLASS.Gibs = {
	[GIB_LEFTLEG]		= GIBS_PYRO_START,
	[GIB_RIGHTLEG]		= GIBS_PYRO_START+1,
	[GIB_LEFTARM]		= GIBS_PYRO_START+2,
	[GIB_RIGHTARM]		= GIBS_PYRO_START+3,
	[GIB_TORSO]			= GIBS_PYRO_START+5,
	[GIB_TORSO2]		= GIBS_PYRO_START+4,
	[GIB_EQUIPMENT1]	= GIBS_PYRO_START+6,
	[GIB_HEAD]			= GIBS_PYRO_START+7,
	[GIB_ORGAN]			= GIBS_ORGANS_START,
}

CLASS.Sounds = {
	paincrticialdeath = {
	},
	painsevere = {
	},
	painsharp = {
	},
}

if SERVER then
	function CLASS:Initialize()
		if (math.random(1,6) != 1) then
			self:SetModel("models/humans/group03/male_0"..math.random(1,9)..".mdl")
		else
			self:SetModel("models/humans/group03/female_0"..table.Random({"1","2","3","4","6"})..".mdl")
		end
	end
end
