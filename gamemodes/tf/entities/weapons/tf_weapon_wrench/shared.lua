if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Slot				= 2
if CLIENT then
	SWEP.GlobalCustomHUD = {HudAccountPanel = true}
end

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"
SWEP.PrintName			= "Wrench"
SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/c_models/c_engineer_arms.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_wrench.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Swing = Sound("Weapon_Wrench.Miss")
SWEP.SwingCrit = Sound("Weapon_Wrench.MissCrit")
SWEP.HitFlesh = Sound("Weapon_Wrench.HitFlesh")
SWEP.HitWorld = Sound("Weapon_Wrench.HitWorld")
SWEP.HitBuildingSuccess = Sound("Weapon_Wrench.HitBuilding_Success")
SWEP.HitBuildingFailure = Sound("Weapon_Wrench.HitBuilding_Failure")

SWEP.BaseDamage = 65
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Delay          = 0.8

SWEP.HoldType = "MELEE"
SWEP.HoldTypeHL2 = "melee"

SWEP.NoHitSound = true
SWEP.UpgradeSpeed = 25

function SWEP:OnMeleeHit(tr)
	if tr.Entity and tr.Entity:IsValid() then
		if tr.Entity:IsBuilding() then
			local ent = tr.Entity
			
			if ent.IsTFBuilding and ent:IsFriendly(self.Owner) then
				if ent.Sapped == true then
					self.Owner:EmitSoundEx("Weapon_Sapper.Removed")
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
				if SERVER then

					if ent.Sapped == true then return end
					local m = ent:AddMetal(self.Owner, self.Owner:GetAmmoCount(TF_METAL))
					if m > 0 then
						self.Owner:EmitSoundEx(self.HitBuildingSuccess)
						self.Owner:RemoveAmmo(m, TF_METAL)
						umsg.Start("PlayerMetalBonus", self.Owner)
							umsg.Short(-m)
						umsg.End()
					elseif ent:GetState() == 1 then
						self.Owner:EmitSoundEx(self.HitBuildingSuccess)
					else
						self.Owner:EmitSoundEx(self.HitBuildingFailure)
					end
				end
			elseif tr.Entity:IsTFPlayer() and !tr.Entity:IsBuilding() then

				if tr.Entity:IsBuilding() and (tr.Entity:IsFriendly(self.Owner) && self.Owner.playerclass == "Engineer") then return end
				self:EmitSound(self.HitFlesh)

			end
		end
	elseif tr.HitWorld then
		if tr.Entity:IsBuilding() and (tr.Entity:IsFriendly(self.Owner) && self.Owner.playerclass == "Engineer") then return end
		self:EmitSound(self.HitWorld)
	end
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 0.5)
	local v = self.Owner:GetEyeTrace().Entity
	
		if v:IsBuilding() and v:GetBuilder() == self.Owner then
			if v:GetClass() == "obj_sentrygun" then
				if SERVER then
					local builder = self.Owner:GetWeapon("tf_weapon_builder")
					--print(builder.MovedBuildingLevel)
					if v:GetLevel()==2 then
						builder.MovedBuildingLevel = 2
					elseif v:GetLevel()==1 then
						builder.MovedBuildingLevel = 1
					elseif v:GetLevel() == 3 then 
						builder.MovedBuildingLevel = 3
					end
					v:Fire("Kill")
					self.Owner:Move(2, 0)
					builder:SetWeaponHoldType("BUILDING_DEPLOYED")
				end
			elseif v:GetClass() == "obj_dispenser" then
				if SERVER then
					local builder = self.Owner:GetWeapon("tf_weapon_builder")
					if v:GetLevel()==2 then
						builder.MovedBuildingLevel = 2
					elseif v:GetLevel()==1 then
						builder.MovedBuildingLevel = 1
					elseif v:GetLevel() == 3 then 
						builder.MovedBuildingLevel = 3
					end
					v:Fire("Kill")
					self.Owner:Move(0, 0)
					builder:SetWeaponHoldType("BUILDING_DEPLOYED")
				end
			elseif v:GetClass() == "obj_teleporter" and v:IsExit() != true then
				if SERVER then
					local builder = self.Owner:GetWeapon("tf_weapon_builder")
					if v:GetLevel()==2 then
						builder.MovedBuildingLevel = 2
					elseif v:GetLevel()==1 then
						builder.MovedBuildingLevel = 1
					elseif v:GetLevel() == 3 then 
						builder.MovedBuildingLevel = 3
					end
					v:Fire("Kill")
					self.Owner:Move(1, 0)
					builder:SetWeaponHoldType("BUILDING_DEPLOYED")
				end
			elseif v:GetClass() == "obj_teleporter" and v:IsExit() != false then
				if SERVER then
					local builder = self.Owner:GetWeapon("tf_weapon_builder")
					if v:GetLevel()==2 then
						builder.MovedBuildingLevel = 2
					elseif v:GetLevel()==1 then
						builder.MovedBuildingLevel = 1
					elseif v:GetLevel() == 3 then 
						builder.MovedBuildingLevel = 3
					end
					v:Fire("Kill")
					self.Owner:Move(1, 1)
					builder:SetWeaponHoldType("BUILDING_DEPLOYED")
				end
			end
		end
end 	

