-- Regular GMod player, as if you were playing sandbox

if CLIENT then
	CLASS.ScoreboardImage = {
		surface.GetTextureID("vgui/modicon.vmt"),
	}
end

CLASS.Name = "Gmodplayer"
CLASS.Speed = 105
CLASS.Health = 100

CLASS.AdditionalAmmo = {
	Pistol = 256,
	["9mmRound"] = 256,
	["MP5_Grenade"] = 6,
	SMG1 = 256,
	grenade = 5,
	snark = 5,
	GrenadeHL1 = 5,
	Buckshot = 64,
	BuckshotHL1 = 64,
	["357"] = 32,
	["357Round"] = 32,
	XBowBolt = 32,
	XBowBoltHL1 = 32,
	AR2AltFire = 6,
	AR2 = 100,
	Uranium = 100,
	SMG1_Grenade = 6,
	Satchel = 10,
	TripMine = 10,
	RPG_Rocket = 18,
	RPG = 18,
}

CLASS.DefaultLoadout = {}
CLASS.Loadout = {
	"weapon_crowbar",
	"weapon_pistol",
	"weapon_smg1",
	"weapon_frag",
	"weapon_physcannon",
	"weapon_crossbow",
	"weapon_shotgun",
	"weapon_357",
	"weapon_rpg",
	"weapon_ar2",
	
	"gmod_tool",
	"gmod_camera",
	"weapon_physgun",
	"weapon_medkit"
}

CLASS.ModelName = "sniper"

CLASS.IsHL2 = true


CLASS.Gibs = {
	[GIB_LEFTLEG]		= GIBS_LAST+1,
	[GIB_RIGHTLEG]		= GIBS_LAST+1, 
	[GIB_RIGHTARM]		= GIBS_LAST+1,
	[GIB_TORSO]			= GIBS_LAST+1,
	[GIB_TORSO2]		= GIBS_LAST+1,
	[GIB_EQUIPMENT1]	= GIBS_LAST+1,
	[GIB_EQUIPMENT2]	= GIBS_LAST+1,
	[GIB_HEAD]			= GIBS_LAST+1,
	[GIB_ORGAN]			= GIBS_ORGANS_START,
}
CLASS.IsHL1Mounted = IsMounted("hl1") || IsMounted("hl1mp")
CLASS.Sounds = {
	paincrticialdeath = {
		Sound("vo/sniper_paincrticialdeath01.wav"),
		Sound("vo/sniper_paincrticialdeath02.wav"),
		Sound("vo/sniper_paincrticialdeath03.wav"),
		Sound("vo/sniper_paincrticialdeath04.wav"),
	},
	painsevere = {
		Sound("vo/sniper_painsevere01.wav"),
		Sound("vo/sniper_painsevere02.wav"),
		Sound("vo/sniper_painsevere03.wav"),
		Sound("vo/sniper_painsevere04.wav"),
	},
	painsharp = {
		Sound("vo/sniper_painsharp01.wav"),
		Sound("vo/sniper_painsharp02.wav"),
		Sound("vo/sniper_painsharp03.wav"),
		Sound("vo/sniper_painsharp04.wav"),
	},
}

if SERVER then

function CLASS:Initialize()
	local cl_playermodel = self:GetInfo("cl_playermodel")
	local modelname = player_manager.TranslatePlayerModel(cl_playermodel)
	util.PrecacheModel(modelname)
	self:SetModel(modelname)
	self:Give("weapon_slam")
	self:Give("weapon_crowbar")
	self:Give("weapon_pistol")
	self:Give("weapon_smg1")
	self:Give("weapon_frag")
	self:Give("weapon_physcannon")
	self:Give("weapon_crossbow")
	self:Give("weapon_shotgun")
	self:Give("weapon_357")
	self:Give("weapon_rpg")
	self:Give("weapon_ar2")
	if (scripted_ents.GetList()["none"]) then
		self:Give("none")
	end
	self:Give("weapon_medkit")
	self:Give("weapon_fists")
	self:Give("gmod_tool")
	self:Give("gmod_camera")
	self:Give("weapon_physgun")
	--[[
	if (self:GetPlayerClassTable().IsHL1Mounted) then
		if (tf_util.IsHL1SwepsMounted()) then
			self:Give("weapon_hl1_snark")
			self:Give("weapon_hl1_satchel")
			self:Give("weapon_hl1_handgrenade")
			self:Give("weapon_hl1_glock")
			self:Give("weapon_hl1_crowbar")
			self:Give("weapon_hl1_357")
			self:Give("weapon_hl1_crossbow")
			self:Give("weapon_hl1_rpg")
			self:Give("weapon_hl1_gauss")
			self:Give("weapon_hl1_egon")
			self:Give("weapon_hl1_shotgun")
			self:Give("weapon_hl1_mp5")
			self:Give("weapon_hl1_tripmine")
			self:Give("weapon_hl1_hornetgun")
		else
			self:Give("weapon_snark")
			self:Give("weapon_satchel")
			self:Give("weapon_handgrenade")
			self:Give("weapon_glock_hl1")
			self:Give("weapon_crowbar_hl1")
			self:Give("weapon_glock_hl1")
			self:Give("weapon_357_hl1")
			self:Give("weapon_crossbow_hl1")
			self:Give("weapon_rpg_hl1")
			self:Give("weapon_gauss")
			self:Give("weapon_egon")
			self:Give("weapon_shotgun_hl1")
			self:Give("weapon_mp5_hl1")
			self:Give("weapon_tripmine")
			self:Give("weapon_hornetgun")
		end
	end]]
	local cl_defaultweapon = self:GetInfo("cl_defaultweapon")

	if self:HasWeapon(cl_defaultweapon) then
		self:SelectWeapon(cl_defaultweapon) 
	end
	timer.Simple(0.12,function() 
		self:SetNWString("PlayerClassModel",modelname)
		if (self:IsBot() and self.TFBot and self:GetPlayerClass() == "gmodplayer") then

			local primaryweps = { 
				"weapon_ak47_cstrike",
				"weapon_aug_cstrike",
				"weapon_famas_cstrike",
				"weapon_galil_cstrike",
				"weapon_m3_cstrike",
				"weapon_mp5_cstrike",
				"weapon_p90_cstrike",
				"weapon_m4a1_cstrike",
				"weapon_sg552_cstrike",
				"weapon_tmp_cstrike",
				"weapon_xm1014_cstrike",
				"weapon_ar2_scripted",
				"weapon_shotgun_scripted",
				"weapon_smg1_scripted",
				"",
				"",
				"",
			}
			local secondaryweps = {
				"weapon_deagle_cstrike",
				"weapon_elite_cstrike",
				"weapon_fiveseven_cstrike",
				"weapon_glock_cstrike",
				"weapon_p228_cstrike",
				"weapon_usp_cstrike",
				"weapon_pistol_scripted",
				"weapon_357_scripted"
			}
				timer.Simple(0.3, function()
				
					self:SetModel(table.Random(player_manager.AllValidModels()))
					
					self:StripWeapons()
					self:Give(table.Random(primaryweps))
					self:Give(table.Random(secondaryweps))
					self:Give("weapon_knife_cstrike")
					self:SetArmor(math.random(15,250))
				end)

		end
	end)
end

end


CLASS.AmmoMax = {
	[TF_PRIMARY]	= 1000000,		-- primary
	[TF_SECONDARY]	= 1000000,		-- secondary
	[TF_METAL]		= 1000000,		-- metal
	[TF_GRENADES1]	= 1000000,		-- grenades1
	[TF_GRENADES2]	= 1000000,		-- grenades2
}