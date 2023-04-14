if SERVER then

AddCSLuaFile("shared.lua")

end

if CLIENT then

SWEP.PrintName			= "Icicle"
SWEP.Slot				= 2

function SWEP:ResetBackstabState()
	self.NextBackstabIdle = nil
	self.BackstabState = false
	self.NextAllowBackstabAnim = CurTime() + 0.8
end

end

SWEP.Base				= "tf_weapon_knife"

SWEP.ViewModel			= "models/weapons/c_models/c_spy_arms_empty.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_xms_cold_shoulder/c_xms_cold_shoulder.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.Swing = Sound("")
SWEP.SwingCrit = Sound("")
SWEP.HitFlesh = Sound("")
SWEP.HitRobot = Sound("MVM_Weapon_Knife.HitFlesh")
SWEP.HitWorld = Sound("Icicle.HitWorld")

SWEP.HoldType = "MELEE"


if SERVER then

hook.Add("PreScaleDamage", "BackstabSetDamageIcicle", function(ent, hitgroup, dmginfo)
	local inf = dmginfo:GetInflictor()
	if inf.ShouldBackstab and inf:ShouldBackstab(ent) and inf:GetClass() == "tf_weapon_knife_icicle" then
		inf.ResetBaseDamage = inf.BaseDamage
		if ent:IsNPC() then
			ent:EmitSound("weapons/icicle_freeze_victim_01.wav", 95, 100)
			if SERVER then
				local animent = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
				animent:SetModel(ent:GetModel())
				animent:SetSkin(ent:GetSkin())
				animent:SetPos(ent:GetPos())
				animent:SetAngles(ent:GetAngles())
				animent:SetBodyGroups(ent:GetBodyGroups())
				animent:Spawn()
				animent:Activate()
	
				animent:SetSolid( SOLID_OBB ) -- This stuff isn't really needed, but just for physics
				animent:PhysicsInit( SOLID_OBB )
				animent:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
				ent:EmitSound("weapons/icicle_freeze_victim_01.wav", 95, 100)
				animent:SetSequence(ent:GetSequence())
				animent:SetPlaybackRate( 1 )
				animent:SetMaterial("models/player/shared/ice_player")
				timer.Simple(0.2, function()
					animent:SetPlaybackRate( 0 )
				end)
				animent.AutomaticFrameAdvance = true
				function animent:Think() -- This makes the animation work
					self:NextThink( CurTime() )
					return true
				end
	
				timer.Simple( 20, function() -- After the sequence is done, spawn the ragdoll
					animent:Remove()
				end )
				ent:Remove()
			end
			
		end
		if ent:IsPlayer() and ent:GetInfoNum("tf_hhh", 0) == 1 then
			inf.BaseDamage = 20
			inf.Owner:EmitSound("player/spy_shield_break.wav", 80, 100)
			timer.Simple(0.04, function()
				inf:SendWeaponAnimEx(ACT_MELEE_VM_STUN) 
				inf.Owner:GetViewModel():SetPlaybackRate(0.5)
				inf:SetNextPrimaryFire(CurTime() + 2)
			end)
		elseif ent:IsPlayer() and ent:GetInfoNum("tf_vagineer", 0) == 1 then
			inf.BaseDamage = 20
			inf.Owner:EmitSound("player/spy_shield_break.wav", 80, 100)
			timer.Simple(0.04, function()
				inf:SendWeaponAnimEx(ACT_MELEE_VM_STUN)
				inf.Owner:GetViewModel():SetPlaybackRate(0.5)
				inf:SetNextPrimaryFire(CurTime() + 2)
			end)
		elseif ent:IsPlayer() and ent:GetInfoNum("tf_giant_robot", 0) == 1 then
			inf.BaseDamage = 20
			inf.Owner:EmitSound("player/spy_shield_break.wav", 80, 100)
			timer.Simple(0.04, function()
				inf:SendWeaponAnimEx(ACT_MELEE_VM_STUN)
				inf.Owner:GetViewModel():SetPlaybackRate(0.5)
				inf:SetNextPrimaryFire(CurTime() + 2)
			end)
		elseif ent:IsPlayer() and ent:GetPlayerClass() == "giantpyro" then
			inf.BaseDamage = 20
			inf.Owner:EmitSound("player/spy_shield_break.wav", 80, 100)
			timer.Simple(0.04, function()
				inf:SendWeaponAnimEx(ACT_MELEE_VM_STUN)
				inf.Owner:GetViewModel():SetPlaybackRate(0.5)
				inf:SetNextPrimaryFire(CurTime() + 2)
			end)
		elseif ent:IsPlayer() and ent:GetPlayerClass() == "giantheavy" then
			inf.BaseDamage = 20
			inf.Owner:EmitSound("player/spy_shield_break.wav", 80, 100)
			timer.Simple(0.04, function()
				inf:SendWeaponAnimEx(ACT_MELEE_VM_STUN)
				inf.Owner:GetViewModel():SetPlaybackRate(0.5)
				inf:SetNextPrimaryFire(CurTime() + 2)
			end)
		elseif ent:IsPlayer() and ent:GetPlayerClass() == "giantdemoman" then
			inf.BaseDamage = 20
			inf.Owner:EmitSound("player/spy_shield_break.wav", 80, 100)
			timer.Simple(0.04, function()
				inf:SendWeaponAnimEx(ACT_MELEE_VM_STUN)
				inf.Owner:GetViewModel():SetPlaybackRate(0.5)
				inf:SetNextPrimaryFire(CurTime() + 2)
			end)
		elseif ent:IsPlayer() and ent:GetPlayerClass() == "giantsoldier" then
			inf.BaseDamage = 20
			inf.Owner:EmitSound("player/spy_shield_break.wav", 80, 100)
			timer.Simple(0.04, function()
				inf:SendWeaponAnimEx(ACT_MELEE_VM_STUN)
				inf.Owner:GetViewModel():SetPlaybackRate(0.5)
				inf:SetNextPrimaryFire(CurTime() + 2)
			end)
		elseif ent:IsPlayer() and ent:GetPlayerClass() == "colonelbarrage" then
			inf.BaseDamage = 20
			inf.Owner:EmitSound("player/spy_shield_break.wav", 80, 100)
			timer.Simple(0.04, function()
				inf:SendWeaponAnimEx(ACT_MELEE_VM_STUN)
				inf.Owner:GetViewModel():SetPlaybackRate(0.5)
				inf:SetNextPrimaryFire(CurTime() + 2)
			end)
		elseif ent:IsPlayer() and ent:GetInfoNum("tf_sentrybuster", 0) == 1 then
			inf.BaseDamage = 20
			inf.Owner:EmitSound("player/spy_shield_break.wav", 80, 100)
			timer.Simple(0.04, function()
				inf:SendWeaponAnimEx(ACT_MELEE_VM_STUN)
				inf.Owner:GetViewModel():SetPlaybackRate(0.5)
				inf:SetNextPrimaryFire(CurTime() + 2)
			end)
		elseif ent:IsPlayer() and ent:GetInfoNum("tf_merasmus", 0) == 1 then
			inf.BaseDamage = 20
			inf.Owner:EmitSound("player/spy_shield_break.wav", 80, 100)
			timer.Simple(0.04, function()
				inf:SendWeaponAnimEx(ACT_MELEE_VM_STUN)
				inf.Owner:GetViewModel():SetPlaybackRate(0.5)
				inf:SetNextPrimaryFire(CurTime() + 2)
			end)
		elseif ent:IsPlayer() and ent:GetInfoNum("tf_giant_robot", 0) == 1 then
			inf.BaseDamage = 65
			timer.Simple(0.04, function()
				inf:SendWeaponAnimEx(ACT_MELEE_VM_STUN)
				inf.Owner:GetViewModel():SetPlaybackRate(0.5)
				inf:SetNextPrimaryFire(CurTime() + 2)
			end)
		elseif ent:IsNPC() and ent:GetClass() == "npc_antlionguard" then
			inf.BaseDamage = 25 * 1
			inf.Owner:EmitSound("physics/body/body_medium_break2.wav", 120, math.random(50,60))
			ent:EmitSound("npc/antlion_guard/antlion_guard_pain"..math.random(1,2)..".wav", 100, math.random(93, 102))
			inf.Owner:GetViewModel():SetPlaybackRate(1)
			timer.Simple(0.04, function()
				inf:SendWeaponAnimEx(ACT_MELEE_VM_STUN)	 	 
				inf:SetNextPrimaryFire(CurTime() + 2)
			end)
		else
			inf.BaseDamage = 500
			ent:AddDeathFlag(DF_FROZEN)
		end
		dmginfo:SetDamage(inf.BaseDamage)
	else 
		if (string.find(inf:GetClass(),"tf_weapon_knife")) then
			inf.BaseDamage = 45
		end
	end
end)

hook.Add("PostScaleDamage", "BackstabResetDamageIcicle", function(ent, hitgroup, dmginfo)
	local inf = dmginfo:GetInflictor()
	if inf.ResetBaseDamage then
		inf.BaseDamage = inf.ResetBaseDamage
	end
end)

end
