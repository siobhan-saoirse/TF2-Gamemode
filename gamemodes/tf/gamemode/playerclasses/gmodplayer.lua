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
local function GetSpawnmenuWeaponsBySlot()
    local slots = {
        [0] = {}, -- Primary
        [1] = {}, -- Secondary
        [2] = {}, -- Melee or Utility
    }

    for _, wep in ipairs(weapons.GetList()) do
        -- Must be spawnable and have a valid Slot
        if wep.Spawnable  then
            table.insert(slots[wep.Slot], wep.ClassName)
        end
    end

    return slots
end

local function GiveRandomSpawnmenuWeapons(ply)
    if not IsValid(ply) or not ply:IsPlayer() then return end

    local weaponsBySlot = GetSpawnmenuWeaponsBySlot()

    for slot, list in pairs(weaponsBySlot) do
        if #list > 0 then
            local class = list[math.random(#list)]
            ply:Give(class)
        end
    end
end
function CLASS:Initialize()
	self:Give("weapon_slam")
	if (ConVarExists("hl2_cl_bob")) then

		self:Give("weapon_hl2_crowbar")
		self:Give("weapon_hl2_pistol")
		self:Give("weapon_hl2_smg1")
		self:Give("weapon_hl2_frag")
		self:Give("weapon_hl2_physcannon")
		self:Give("weapon_hl2_crossbow")
		self:Give("weapon_hl2_shotgun")
		self:Give("weapon_hl2_357")
		self:Give("weapon_hl2_rpg")
		self:Give("weapon_hl2_ar2")

	else
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
	end
	self:Give("weapon_gmod_hands")
	self:Give("weapon_medkit")
	self:Give("weapon_fists")
	if (!GetConVar("tf_competitive"):GetBool()) then
		self:Give("gmod_tool")
		self:Give("gmod_camera")
		self:Give("weapon_physgun")
	end
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
		if (self:IsBot() and self.TFBot and self:GetPlayerClass() == "gmodplayer") then

			if (ConVarExists("hl2_cl_bob")) then
				self:SelectWeapon(table.Random({"weapon_hl2_shotgun","weapon_hl2_smg1","weapon_hl2_357","weapon_hl2_ar2"}))
			else
				self:SelectWeapon(table.Random({"weapon_shotgun","weapon_smg1","weapon_357","weapon_ar2"}))
			end
			local mdl = table.Random(player_manager.AllValidModels())
			self:SetModel(mdl)

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