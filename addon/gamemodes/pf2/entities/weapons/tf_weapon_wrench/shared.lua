if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Slot				= 2
if CLIENT then
	SWEP.PrintName			= "Wrench"
SWEP.GlobalCustomHUD = {HudAccountPanel = true}
end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/v_models/v_wrench_engineer.mdl"
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

SWEP.NoHitSound = true
SWEP.UpgradeSpeed = 25

function SWEP:OnMeleeHit(tr)
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
				if SERVER then

					if ent.Sapped == true then return end
					local m = ent:AddMetal(self.Owner, self.Owner:GetAmmoCount(TF_METAL))
					if m > 0 then
						self.Owner:EmitSound(self.HitBuildingSuccess)
						self.Owner:RemoveAmmo(m, TF_METAL)
						umsg.Start("PlayerMetalBonus", self.Owner)
							umsg.Short(-m)
						umsg.End()
					elseif ent:GetState() == 1 then
						self.Owner:EmitSound(self.HitBuildingSuccess)
					else
						self.Owner:EmitSound(self.HitBuildingFailure)
					end
				end
			end
		end
	end
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 0.5)
	for k,v in pairs(ents.FindInSphere(self.Owner:GetPos(), 75)) do
		if v:IsBuilding() and v:GetBuilder() == self.Owner then
			if v:GetClass() == "obj_sentrygun" then
				if SERVER then
					local builder = self.Owner:GetWeapon("tf_weapon_builder")
					print(builder.MovedBuildingLevel)
					if v:GetLevel()==2 then
						builder.MovedBuildingLevel = 2
					elseif v:GetLevel()==1 then
						builder.MovedBuildingLevel = 1
					elseif v:GetLevel() == 3 then 
						builder.MovedBuildingLevel = 3
					end
					v:Fire("Kill", "", 0.1)
					self.Owner:Move(2, 0)
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
					v:Fire("Kill", "", 0.1)
					self.Owner:Move(0, 0)
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
					v:Fire("Kill", "", 0.1)
					self.Owner:Move(1, 0)
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
					v:Fire("Kill", "", 0.1)
					self.Owner:Move(1, 1)
				end
			end
		end
	end
end 	


function SWEP:MeleeHitSound(tr)
	if (tr.Entity:IsPlayer()) then
		if (tr.Entity:IsFriendly(self.Owner)) then
			local armor = tr.Entity:Armor() + tr.Entity:GetMaxArmor() * 0.5
			if SERVER then
				if (tr.Entity:Armor() < tr.Entity:GetMaxArmor()) then
					if (armor > tr.Entity:GetMaxArmor()) then
						tr.Entity:SetArmor(tr.Entity:GetMaxArmor())
					else
						tr.Entity:SetArmor(armor)
					end
				end
			end
			if (tr.Entity:Armor() < tr.Entity:GetMaxArmor()) then
				self:EmitSound("items/armor_repaired.wav",75)
			end
		end
	end
	self:BaseCall(tr)
end