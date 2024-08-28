
SWEP.ShootSound = Sound("Weapon_Scatter_Gun.Single")
SWEP.ShootCritSound = Sound("Weapon_Scatter_Gun.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_Scatter_Gun.WorldReload")

local SoundNameTranslate = {
	sound_deploy			= "DeploySound",
	sound_single_shot		= "ShootSound",
	sound_double_shot		= "ShootSound2",
	sound_burst				= "ShootCritSound,SwingCrit",
	sound_empty				= "EmptySound",
	sound_reload			= "ReloadSound",
	
	sound_special1			= "SpecialSound1",
	sound_special2			= "SpecialSound2",
	sound_special3			= "SpecialSound3",
	custom_sound1			= "CustomSound1",
	
	sound_melee_miss		= "Swing",
	sound_melee_hit			= "HitFlesh",
	sound_melee_hit_world	= "HitWorld"
}

function SWEP:ModifySound(name,sound)
	if not SoundNameTranslate[name] then return false end
	
	local snd = string.gsub(SoundNameTranslate[name], "%s", "")
	util.PrecacheSound(sound)
	if snd then
		for _,v in ipairs(string.Explode(",", snd)) do
			self[v] = sound
		end
	end
	
	return true
end
