if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "The Gunslinger"
	SWEP.Slot				= 2
	SWEP.GlobalCustomHUD = {HudAccountPanel = true}
end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/c_models/c_engineer_gunslinger.mdl"
SWEP.WorldModel			= "models/empty.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.DropPrimaryWeaponInstead = true

SWEP.Swing = Sound("Weapon_Gunslinger.Swing")
SWEP.SwingCrit = Sound("Weapon_Gunslinger.Swing")
SWEP.HitFlesh = Sound("Weapon_Wrench.HitFlesh")
SWEP.HitWorld = Sound("Weapon_Wrench.HitWorld")
SWEP.HitBuildingSuccess = Sound("Weapon_Wrench.HitBuilding_Success")
SWEP.HitBuildingFailure = Sound("Weapon_Wrench.HitBuilding_Failure")

SWEP.BaseDamage = 65
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0
SWEP.IsRoboArm = true

SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8

SWEP.HoldType = "ITEM2"

SWEP.NoHitSound = true
SWEP.UpgradeSpeed = 25

SWEP.AltIdleAnimationProbability = 0.1


function SWEP:SetupDataTables()
	self:CallBaseFunction("SetupDataTables")
	self:DTVar("Int", 1, "Combo")
end

function SWEP:Equip() -- weird workaround hack for viewmodel bug
	if IsValid(self) and IsValid(self.Owner) then
		local lastwep = self.Owner:GetActiveWeapon():GetClass()
		self.Owner:SelectWeapon(self:GetClass())
		timer.Simple(0.1, function() if IsValid(self) and IsValid(self.Owner) then self.Owner:SelectWeapon(lastwep) end end)
	end
end

function SWEP:OnMeleeAttack(tr)
	if SERVER then
		local hit = false
		
		if IsValid(tr.Entity) and tr.Entity:IsTFPlayer() and !tr.Entity:IsBuilding() then
			hit = true
		end
		if IsValid(tr.Entity) and tr.Entity:IsNPC() and !tr.Entity:IsBuilding() then
			hit = true
		end
		if self:CriticalEffect() then
			self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_HARD_ITEM2,true)
		end
		if hit then
			self.HasHit = true
		else
			self.dt.Combo = 0
		end
	end
end


function SWEP:OnMeleeHit(tr)
	if tr.Entity and tr.Entity:IsValid() then
		if tr.Entity:IsBuilding() then
			local ent = tr.Entity
			
			if ent.IsTFBuilding and ent:IsFriendly(self.Owner) then
				if ent.Sapped == true then
					self.Owner:EmitSoundEx("Weapon_Sapper.Removed")
					ent.Sapped = false
				end
				if SERVER then

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
			else
				self:EmitSound(self.HitWorld)
			end
		elseif tr.Entity:IsPlayer() or tr.Entity:IsNPC() then
			self:EmitSound(self.HitFlesh)
		else
			self:EmitSound(self.HitWorld)
		end 
	elseif tr.HitWorld then
		self:EmitSound(self.HitWorld)
	end
	
	if SERVER then
		if self.HasHit then
			self.dt.Combo = self.dt.Combo + 1
			self.HasHit = false
		end
		
		if self.dt.Combo > 2 then
			self.dt.Combo = 0
		end
	end
end

function SWEP:Critical(ent,dmginfo)
	if self.dt.Combo >= 2 then
		return true
	end
	return self:CallBaseFunction("Critical", ent, dmginfo)
end

function SWEP:PredictCriticalHit()
	if self.dt.Combo >= 2 then
		self.NameOverride = "robot_arm_combo_kill"
		return true
	else
		self.NameOverride = nil
	end
end

function SWEP:Think()
	self.Owner:SetBodygroup( 2, 1 )
	--self.Owner:GetViewModel():SetBodygroup(1, 0)
	
	if not game.SinglePlayer() or SERVER then
		if self.NextIdle and CurTime()>=self.NextIdle then
			if self.PlayingIdle2Animation then
				self.PlayingIdle2Animation = false
			elseif math.Rand(0,1) <= self.AltIdleAnimationProbability and not self.PlayingIdle2Animation then
				self:SendWeaponAnim(self.VM_IDLE_2)
				self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
				self.PlayingIdle2Animation = true
			end
		end
	end
	
	if SERVER and not self.Owner:KeyDown(IN_ATTACK) then
		self.dt.Combo = 0
	end
	
	self:CallBaseFunction("Think")
end


function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 0.5)
	for k,v in pairs(ents.FindInSphere(self.Owner:GetPos(), 75)) do
		if v:IsBuilding() and v:GetOwner() == self.Owner then
			if v:GetClass() == "obj_sentrygun" then
				if SERVER then
					if v:GetLevel() == 3 then
						self.DeployedBuildingLevel = 3
					elseif v:GetLevel() == 2 then
						self.DeployedBuildingLevel = 2
					end
					v:Fire("Kill")
					self.Owner:ConCommand("move 2 0")
				end
			elseif v:GetClass() == "obj_dispenser" then
				if SERVER then
					if v:GetLevel() == 3 then
						self.DeployedBuildingLevel = 3
					elseif v:GetLevel() == 2 then
						self.DeployedBuildingLevel = 2
					end
					v:Fire("Kill")
					self.Owner:ConCommand("move 0 0")
				end
			elseif v:GetClass() == "obj_teleporter" and self:IsExit() != true then
				if SERVER then
					if v:GetLevel() == 3 then
						self.DeployedBuildingLevel = 3
					elseif v:GetLevel() == 2 then
						self.DeployedBuildingLevel = 2
					end
					v:Fire("Kill")
					self.Owner:ConCommand("move 1 0")
				end
			elseif v:GetClass() == "obj_teleporter" and self:IsExit() != false then
				if SERVER then
					if v:GetLevel() == 3 then
						self.DeployedBuildingLevel = 3
					elseif v:GetLevel() == 2 then
						self.DeployedBuildingLevel = 2
					end
					v:Fire("Kill")
					self.Owner:ConCommand("move 1 1")
				end
			end
		end
	end
end 	
