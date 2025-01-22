if SERVER then

AddCSLuaFile("shared.lua")

end

if CLIENT then

SWEP.PrintName			= "Knife"

function SWEP:ResetBackstabState()
	self.NextBackstabIdle = nil
	self.BackstabState = false
	self.NextAllowBackstabAnim = CurTime() + 0.8
end

end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/c_models/c_spy_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_knife/c_knife.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Slot				= 2
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.Swing = Sound("Weapon_Knife.Miss")
SWEP.SwingCrit = Sound("Weapon_Knife.MissCrit")
SWEP.HitFlesh = Sound("Weapon_Knife.HitFlesh")
SWEP.HitRobot = Sound("MVM_Weapon_Knife.HitFlesh")
SWEP.HitWorld = Sound("Weapon_Knife.HitWorld")

SWEP.BaseDamage = 40
SWEP.ResetBaseDamage = 40
SWEP.DamageRandomize = 0
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0
SWEP.DamageType = bit.bor(DMG_CLUB,DMG_BULLET)

SWEP.CriticalChance = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8
SWEP.HoldTypeHL2 = "knife"
SWEP.HasThirdpersonCritAnimation = true

SWEP.MeleeAttackDelay = -1
SWEP.MeleePredictTolerancy = 0.1
SWEP.BackstabAngle = 180
SWEP.ShouldOccurFists = true
-- ACT_MELEE_VM_STUN

function SWEP:Deploy()
	self:CallBaseFunction("Deploy")
end

function SWEP:ShouldBackstab(ent)
	if not ent then
		local tr = self:MeleeAttack(true)
		ent = tr.Entity
	end
	
	if not IsValid(ent) or not self.Owner:CanDamage(ent) or ent:Health()<=0 or not ent:CanReceiveCrits() or inspecting == true or inspecting_post == true then
		return false
	end
	
	if not self.BackstabCos then
		self.BackstabCos = math.cos(math.rad(self.BackstabAngle * 0.5))
	end
	
	local v1 = ent:GetPos() - self.Owner:GetPos()
	local v2 = ent:GetAngles():Forward()
	
	v1.z = 0
	v2.z = 0
	v1:Normalize()
	v2:Normalize()
	
	return v1:Dot(v2) > self.BackstabCos
end

function SWEP:Critical(ent,dmginfo)
	if self:ShouldBackstab(ent) then
		return true
	end
	
	return self:CallBaseFunction("Critical", ent, dmginfo)
end

function SWEP:OnMeleeHit(tr)
	if CLIENT then return end
	
	local ent = tr.Entity
	
	if self.ShouldBackstab and self:ShouldBackstab(ent) then
		if self:GetItemData().model_player == "models/weapons/c_models/c_eternal_reward/c_eternal_reward.mdl" then
			if ent:IsPlayer() and !ent:IsHL2() and not ent:IsFriendly(self.Owner) and not ent:HasGodMode() then
				ent:SetMaterial("models/shadertest/predator")
				ent:GetRagdollEntity():SetMaterial("models/shadertest/predator")
				ent:TakeDamage(ent:Health() * 2, self.Owner, self)
				timer.Simple(0.2, function()
					self.Owner:SetModel(ent:GetModel())
					self.Owner:SetSkin(ent:GetSkin())
				end)
			end
		end
	end
end

function SWEP:PredictCriticalHit()
	if self:ShouldBackstab() then
		return true
	end
end


function SWEP:Think()

	if self.IsDeployed and CurTime() > self:GetNextPrimaryFire() and self.Owner:GetEyeTrace().Entity:Health() > 0 then
		local shouldbackstab = self:ShouldBackstab()
			
		if shouldbackstab and not self.BackstabState then
			self:SendWeaponAnimEx(self.BACKSTAB_VM_UP)
			self.NextBackstabIdle = CurTime() + self:SequenceDuration()
			self.NextIdle = nil
		elseif not shouldbackstab and self.BackstabState then
			if self.Primary.Delay and CurTime() >= self.Primary.Delay then
				self:SendWeaponAnimEx(self.BACKSTAB_VM_DOWN)
				self.NextBackstabIdle = nil
				self.NextIdle =  CurTime() + self:SequenceDuration()
			end
		end
		self.BackstabState = shouldbackstab
			
		if self.NextBackstabIdle and CurTime()>=self.NextBackstabIdle then
			self:SendWeaponAnimEx(self.BACKSTAB_VM_IDLE)
			self.NextBackstabIdle = nil
			self.NextIdle = nil
		end
			
		self.NextAllowBackstabAnim = nil
	end
	self:CallBaseFunction("Think")
	if self.Owner:GetPlayerClass() == "spy" then
		if self.Owner:GetModel() == "models/player/scout.mdl" or  self.Owner:GetModel() == "models/player/soldier.mdl" or  self.Owner:GetModel() == "models/player/pyro.mdl" or  self.Owner:GetModel() == "models/player/demo.mdl" or  self.Owner:GetModel() == "models/player/heavy.mdl" or  self.Owner:GetModel() == "models/player/engineer.mdl" or  self.Owner:GetModel() == "models/player/medic.mdl" or  self.Owner:GetModel() == "models/player/sniper.mdl" or  self.Owner:GetModel() == "models/player/hwm/spy.mdl" then
			
			self.Owner:SetNWBool("NoWeapon", true)
		else
			if IsValid(animent2) then
				animent2:Fire("Kill", "", 0.1)
			end
			self.Owner:SetNWBool("NoWeapon", false)
		end
	end
end

function SWEP:Deploy()
	--MsgFN("Deploy %s", tostring(self))
	if self.Owner:GetPlayerClass() == "spy" then
		if self.Owner:GetModel() == "models/player/scout.mdl" or  self.Owner:GetModel() == "models/player/soldier.mdl" or  self.Owner:GetModel() == "models/player/pyro.mdl" or  self.Owner:GetModel() == "models/player/demo.mdl" or  self.Owner:GetModel() == "models/player/heavy.mdl" or  self.Owner:GetModel() == "models/player/engineer.mdl" or  self.Owner:GetModel() == "models/player/medic.mdl" or  self.Owner:GetModel() == "models/player/sniper.mdl" or  self.Owner:GetModel() == "models/player/hwm/spy.mdl" then
			
			if SERVER then
				animent2 = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
				if self.Owner:GetModel() == "models/player/engineer.mdl" then
					animent2:SetModel("models/weapons/c_models/c_wrench/c_wrench.mdl")
				elseif self.Owner:GetModel() == "models/player/scout.mdl" then
					animent2:SetModel("models/weapons/c_models/c_bat.mdl")
				elseif self.Owner:GetModel() == "models/player/soldier.mdl" then
					animent2:SetModel("models/weapons/c_models/c_shovel/c_shovel.mdl")
				elseif self.Owner:GetModel() == "models/player/pyro.mdl" then
					animent2:SetModel("models/weapons/w_models/w_fireaxe.mdl")
				elseif self.Owner:GetModel() == "models/player/hwm/spy.mdl" then
					animent2:SetModel("models/weapons/c_models/c_knife/c_knife.mdl")
				elseif self.Owner:GetModel() == "models/player/sniper.mdl" then
					animent2:SetModel("models/weapons/c_models/c_machete/c_machete.mdl")
				elseif self.Owner:GetModel() == "models/player/medic.mdl" then
					animent2:SetModel("models/weapons/c_models/c_bonesaw/c_bonesaw.mdl")
				elseif self.Owner:GetModel() == "models/player/demo.mdl" then
					animent2:SetModel("models/weapons/w_models/w_bottle.mdl")
				end
				animent2:SetAngles(self.Owner:GetAngles())
				animent2:SetPos(self.Owner:GetPos())
				animent2:Spawn() 
				animent2:Activate()
				animent2:SetParent(self.Owner)
				animent2:AddEffects(EF_BONEMERGE)
				animent2:SetName("SpyWeaponModel"..self.Owner:EntIndex())
				animent2:SetSkin(self.Owner:GetSkin())
				timer.Create("SpyCloakDetector"..self.Owner:EntIndex(), 0.01, 0, function()
					if self.Owner:GetPlayerClass() == "spy" then
						if self.Owner:GetNoDraw() == true then
							if IsValid(animent2) then
								animent2:SetNoDraw(true)
							end
						else
							if IsValid(animent2) then
								animent2:SetNoDraw(false)
							end
						end
					else
						timer.Stop("SpyCloakDetector"..self.Owner:EntIndex())
						return
					end
				end)
			end
		else
			if IsValid(animent2) then
				animent2:Remove()
			end
			self:SetHoldType("MELEE")
		end
	end
	return self:CallBaseFunction("Deploy")
end
function SWEP:Holster()
	self:StopTimers()
	if IsValid(self.Owner) then
		timer.Simple(0.1, function()
			if IsValid(self.CModel3) then
				self.CModel3:Remove()
			end
		end)
		if self:GetItemData().hide_bodygroups_deployed_only then
			local visuals = self:GetVisuals()
			local owner = self.Owner
			
			if visuals.hide_player_bodygroup_names then
				for _,group in ipairs(visuals.hide_player_bodygroup_names) do
					local b = PlayerNamedBodygroups[owner:GetPlayerClass()]
					if b and b[group] then
						owner:SetBodygroup(b[group], 0)
					end
					
					b = PlayerNamedViewmodelBodygroups[owner:GetPlayerClass()]
					if b and b[group] then
						if IsValid(owner:GetViewModel()) then
							owner:GetViewModel():SetBodygroup(b[group], 0)
						end
					end
				end
			end
		end
	
		for k,v in pairs(self:GetVisuals()) do
			if k=="hide_player_bodygroup" then
				self.Owner:SetBodygroup(v,0)
			end
		end
	end
	if IsValid(animent2) then
		animent2:Fire("Kill", "", 0.1)
	end
	self.NextIdle = nil
	self.NextReloadStart = nil
	self.NextReload = nil
	self.Reloading = nil
	self.RequestedReload = nil
	self.NextDeployed = nil
	self.IsDeployed = nil
	if SERVER then
		if IsValid(self.WModel2) then
			--self.WModel2:Remove()
		end
	end
	if IsValid(self.Owner) then
		self.Owner.LastWeapon = self:GetClass()
	end
	
	return true
end


function SWEP:PrimaryAttack()
	if not self:CallBaseFunction("PrimaryAttack") then return false end
	
	self.NameOverride = nil
	
	if game.SinglePlayer() then
		self:CallOnClient("ResetBackstabState", "")
	elseif CLIENT then
		self:ResetBackstabState()
	end
end

if SERVER then

hook.Add("PreScaleDamage", "BackstabSetDamage", function(ent, hitgroup, dmginfo)
	local inf = dmginfo:GetInflictor()
	if inf.ShouldBackstab and inf:ShouldBackstab(ent) and inf:GetClass() != "tf_weapon_knife_icicle" then
		inf.ResetBaseDamage = inf.BaseDamage
		if ent:IsPlayer() and ent:IsMiniBoss() then
			inf.BaseDamage = ent:GetMaxHealth() * 0.12
			inf.BaseDamage = 195
			inf.NextIdle = CurTime() + 5
			timer.Simple(0.04, function()
				inf:SendWeaponAnimEx(ACT_MELEE_VM_STUN)
				inf.Owner:GetViewModel():SetPlaybackRate(0.5)
				inf:SetNextPrimaryFire(CurTime() + 2)
			end)
		elseif ent:IsNPC() and ent:GetClass() == "npc_antlionguard" then
			inf.BaseDamage = ent:GetMaxHealth() * 0.15
			inf.Owner:EmitSound("physics/body/body_medium_break2.wav", 120, math.random(50,60))
			inf.NextIdle = CurTime() + 5
			ent:EmitSound("npc/antlion_guard/antlion_guard_pain"..math.random(1,2)..".wav", 100, math.random(93, 102))
			inf.Owner:GetViewModel():SetPlaybackRate(1)
			timer.Simple(0.04, function()
				inf:SendWeaponAnimEx(ACT_MELEE_VM_STUN)	 	 
				inf:SetNextPrimaryFire(CurTime() + 2)
			end)
		else
			inf.BaseDamage = ent:Health() * 2
			ent:AddDeathFlag(DF_BACKSTAB)
		end
		inf.NameOverride = "tf_weapon_knife_backstab"
		dmginfo:SetDamage(inf.BaseDamage)
	else
		if (string.find(inf:GetClass(),"tf_weapon_knife")) then
			inf.BaseDamage = 45
		end
	end
end)

hook.Add("PostScaleDamage", "BackstabResetDamage", function(ent, hitgroup, dmginfo)
	local inf = dmginfo:GetInflictor()
	if inf:GetClass() == "tf_weapon_shotgun_imalreadywidowmaker" then
		
		inf.Owner:GiveTFAmmo(25, TF_METAL) 
		umsg.Start("PlayerMetalBonus", inf.Owner)
			umsg.Short(25)
		umsg.End()
	
	end
	if inf.ResetBaseDamage then
		inf.BaseDamage = 45
	end
end)

end
