CLASS.Name = "Giant Demoknight"
CLASS.Speed = 280 * 0.4
CLASS.Health = 55000

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("hud/class_demored"),
		surface.GetTextureID("hud/class_demoblue")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("hud/leaderboard_class_demoknight_giant"),
		surface.GetTextureID("hud/leaderboard_class_demoknight_giant")
	}
end

CLASS.Loadout = {"tf_weapon_grenadelauncher", "tf_weapon_pipebomblauncher", "tf_weapon_bottle"}
CLASS.DefaultLoadout = {"Chargin' Targe","Eyelander","Prince Tavish's Crown","Ali Baba's Wee Booties"}
CLASS.ModelName = "demo"

CLASS.Gibs = {
	[GIB_LEFTLEG]		= GIBS_DEMOMAN_START,
	[GIB_RIGHTLEG]		= GIBS_DEMOMAN_START+1,
	[GIB_LEFTARM]		= GIBS_DEMOMAN_START+2,
	[GIB_RIGHTARM]		= GIBS_DEMOMAN_START+3,
	[GIB_TORSO]			= GIBS_DEMOMAN_START+4,
	[GIB_HEAD]			= GIBS_DEMOMAN_START+5,
	[GIB_ORGAN]			= GIBS_ORGANS_START,
}

CLASS.Sounds = {
	paincrticialdeath = {
		Sound("vo/demoman_paincrticialdeath01.wav"),
		Sound("vo/demoman_paincrticialdeath02.wav"),
		Sound("vo/demoman_paincrticialdeath03.wav"),
		Sound("vo/demoman_paincrticialdeath04.wav"),
		Sound("vo/demoman_paincrticialdeath05.wav"),
	},
	painsevere = {
		Sound("vo/demoman_painsevere01.wav"),
		Sound("vo/demoman_painsevere02.wav"),
		Sound("vo/demoman_painsevere03.wav"),
		Sound("vo/demoman_painsevere04.wav"),
	},
	painsharp = {
		Sound("vo/demoman_painsharp01.wav"),
		Sound("vo/demoman_painsharp02.wav"),
		Sound("vo/demoman_painsharp03.wav"),
		Sound("vo/demoman_painsharp04.wav"),
		Sound("vo/demoman_painsharp05.wav"),
		Sound("vo/demoman_painsharp06.wav"),
		Sound("vo/demoman_painsharp07.wav"),
	},
}

CLASS.AmmoMax = {
	[TF_PRIMARY]	= 1000000,		-- primary
	[TF_SECONDARY]	= 24,		-- secondary
	[TF_METAL]		= 100,		-- metal
	[TF_GRENADES1]	= 0,		-- grenades1
	[TF_GRENADES2]	= 0,		-- grenades2
}

if SERVER then

function CLASS:Initialize()
	self:SetModel("models/bots/demo_boss/bot_demo_boss.mdl") 
	
	timer.Create("ColonelBarrage"..self:EntIndex(), 1, 0, function()
		if (self:GetPlayerClass() == "chieftavish") then
			GAMEMODE:HealPlayer(self, self, 500, true, false)
		end
	end)
end

end