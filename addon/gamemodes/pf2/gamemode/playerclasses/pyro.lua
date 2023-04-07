CLASS.Name = "Pyro"
CLASS.Speed = 300
CLASS.Health = 100
CLASS.Armor = 150

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("hud/class_pyrored"),
		surface.GetTextureID("hud/class_pyroblue")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("hud/leaderboard_class_pyro"),
		surface.GetTextureID("hud/leaderboard_class_pyro_d")
	}
end

CLASS.Loadout = {"tf_weapon_flamethrower", "tf_weapon_shotgun_pyro", "tf_weapon_fireaxe"}
CLASS.DefaultLoadout = {"TF_WEAPON_FLAMETHROWER","TF_WEAPON_SHOTGUN_PYRO","TF_WEAPON_BRANDINGIRON"}
CLASS.ModelName = "pyro"
CLASS.Fireproof = true

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
		Sound("vo/pyro_paincrticialdeath01.wav"),
		Sound("vo/pyro_paincrticialdeath02.wav"),
		Sound("vo/pyro_paincrticialdeath03.wav"),
	},
	painsevere = {
		Sound("vo/pyro_painsevere01.wav"),
		Sound("vo/pyro_painsevere02.wav"),
		Sound("vo/pyro_painsevere03.wav"),
		Sound("vo/pyro_painsevere04.wav"),
		Sound("vo/pyro_painsevere05.wav"),
		Sound("vo/pyro_painsevere06.wav"),
	},
	painsharp = {
		Sound("vo/pyro_painsharp01.wav"),
		Sound("vo/pyro_painsharp02.wav"),
		Sound("vo/pyro_painsharp03.wav"),
		Sound("vo/pyro_painsharp04.wav"),
		Sound("vo/pyro_painsharp05.wav"),
		Sound("vo/pyro_painsharp06.wav"),
		Sound("vo/pyro_painsharp07.wav"),
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

function CLASS:PlayCustomGesture(anim, state)
	local actname
	if anim==PLAYER_PREFIRE then
		actname = "ACT_MP_ATTACK_"..(WeaponGestureTranslateTable[state] or "STAND").."_PREFIRE"
	elseif anim==PLAYER_POSTFIRE then
		actname = "ACT_MP_ATTACK_"..(WeaponGestureTranslateTable[state] or "STAND").."_POSTFIRE"
	end
	
	if actname then
		act2 = _E[actname]
		self:RestartGesture(act2)
		return true
	end
end

end