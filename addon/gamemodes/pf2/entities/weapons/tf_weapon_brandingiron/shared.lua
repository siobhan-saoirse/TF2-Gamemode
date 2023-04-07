if SERVER then
	AddCSLuaFile( "shared.lua" )
end

	SWEP.PrintName			= "Fire Axe"
sound.Add( {
	name = "Taunt.Pyro03RockStar",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 95,
	sound = { "player/taunt_rockstar.wav"	}
} )
sound.Add( {
	name = "Taunt.Pyro03RockStarEnd",
	channel = CHAN_WEAPON,
	volume = 1.0,
	level = 95,
	sound = { "player/taunt_rockstar_end.wav"	}
} )
SWEP.Base				= "tf_weapon_melee_base"

SWEP.Slot				= 2
SWEP.ViewModel			= "models/weapons/v_models/v_brandingiron_pyro.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_brandingiron.mdl"
SWEP.Crosshair = "tf_crosshair2"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.Swing = Sound("Weapon_FireAxe.Miss")
SWEP.SwingCrit = Sound("Weapon_FireAxe.MissCrit")
SWEP.HitFlesh = Sound("Weapon_FireAxe.HitFlesh")
SWEP.HitRobot = Sound("MVM_Weapon_Sword.HitFlesh")
SWEP.HitWorld = Sound("Weapon_FireAxe.HitWorld")

SWEP.BaseDamage = 65
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8

SWEP.HoldType = "MELEE"
SWEP.HoldTypeHL2 = "MELEE2"

SWEP.DamageType = DMG_BURN
--SWEP.CritDamageType = DMG_SLASH|DMG_CRUSH
SWEP.CritDamageType = DMG_SLASH, DMG_CRUSH

-- The following weapons should not cut zombies in half
local NoSlashDamage = {
	[153] = true,	-- Homewrecker
	[214] = true,	-- Powerjack
	[326] = true,	-- Back Scratcher
}

function SWEP:InitAttributes(owner, attributes)
	self:CallBaseFunction("InitAttributes", owner, attributes)
	
	if NoSlashDamage[self:ItemIndex()] then
		self.DamageType = DMG_CLUB
		self.CritDamageType = DMG_CLUB
	end
end
function SWEP:Deploy()
	if (self.Owner:GetPlayerClass() == "civilian_") then
		self.ViewModel			= "models/weapons/v_models/v_umbrella_civilian.mdl"
		self.WorldModel			= "models/weapons/w_models/w_umbrella.mdl"
		self.Owner:GetViewModel():SetModel("models/weapons/v_models/v_umbrella_civilian.mdl")
		self:SetModel("models/weapons/v_models/v_umbrella_civilian.mdl")
		self.PrintName			= "Umbrella"
	end
	return self:CallBaseFunction("Deploy")
end
function SWEP:Think()
	if (self.Owner:GetPlayerClass() == "civilian_") then
		self.PrintName			= "Umbrella"
		self.BounceWeaponIcon   = true
		self.Icon = "sprites/bucket_fireaxe"
	end
	return self:CallBaseFunction("Think")
end

function SWEP:OnMeleeHit(tr)
	if self:GetItemData().model_player == "models/workshop/weapons/c_models/c_sledgehammer/c_sledgehammer.mdl" then
		if tr.Entity and tr.Entity:IsValid() then
			if tr.Entity:IsBuilding() then
				local ent = tr.Entity
				
				if ent.IsTFBuilding and ent:IsFriendly(self.Owner) then
					if ent.Sapped == true then
						self.Owner:EmitSound("Weapon_Sapper.Removed")
						ent:StopSound("TappedRobot")
						timer.Stop("SapEnd"..ent:EntIndex())
						timer.Stop("SapSentry2"..ent:EntIndex())
						timer.Stop("SapSentry3"..ent:EntIndex())
						ent.Model:SetPlaybackRate(2)
						timer.Simple(2, function()
							ent.Model:ResetSequence("idle")
							ent:ResetSequence("idle")
						end)
						umsg.Start("Notice_EntityKilledEntity")
							umsg.String("Sapper ("..ent.SappedBy:Nick()..")")
							umsg.Short(GAMEMODE:EntityTeam(ent.SappedBy))
							umsg.Short(GAMEMODE:EntityID(ent.SappedBy))
							
							umsg.String(self:GetItemData().item_iconname)
							
							umsg.String(GAMEMODE:EntityDeathnoticeName(self.Owner))
							umsg.Short(GAMEMODE:EntityTeam(self.Owner))
							umsg.Short(GAMEMODE:EntityID(self.Owner))
							
							
							umsg.Bool(self.Owner.LastDamageWasCrit)
						umsg.End()
						 
						ent:StopSound("SappedRobot") 
						if SERVER then
							brokensapper = ents.Create("prop_physics")
							brokensapper:SetPos(ent:GetPos() + Vector(math.random(10,40), math.random(10,40), math.random(50,70)))
							brokensapper:SetModel("models/buildables/gibs/sapper_gib002.mdl")
							brokensapper:Spawn()
							brokensapper:Activate()
							
							brokensapper:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
							brokensapper2 = ents.Create("prop_physics")
							brokensapper2:SetPos(ent:GetPos() + Vector(math.random(10,40), math.random(10,40), math.random(50,70)))
							brokensapper2:SetModel("models/buildables/gibs/sapper_gib001.mdl")
							brokensapper2:Spawn()
							brokensapper2:Activate()
							
							brokensapper2:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
						end
						ent.Sapped = false
					end
				end
			end
		end
	end
end