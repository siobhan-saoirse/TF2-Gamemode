if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Bottle"
SWEP.Slot				= 2
end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/c_models/c_demo_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_caber/c_caber.mdl"
SWEP.ExplodedModel		= "models/weapons/c_models/c_caber/c_caber_exploded.mdl"

SWEP.Crosshair = "tf_crosshair3"

SWEP.Swing = Sound("Weapon_FireAxe.Miss")
SWEP.SwingCrit = Sound("Weapon_FireAxe.MissCrit")

SWEP.HitFlesh = Sound("Weapon_FireAxe.HitFlesh")
SWEP.HitWorld = Sound("Weapon_FireAxe.HitWorld")

SWEP.BaseDamage = 35
SWEP.DamageRandomize = 0.15
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.ExplosionBaseDamage = 150
SWEP.ExplosionDamageRandomize = 0
SWEP.ExplosionRadiusInit = 180
SWEP.ExplosionCritDamageMultiplier = 2

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8

SWEP.HoldType = "MELEE"

function SWEP:SetupDataTables()
	self:CallBaseFunction("SetupDataTables")
	self:DTVar("Bool", 0, "Broken")
end

function SWEP:ViewModelDrawn()
	if IsValid(self.CModel) then
		if self.dt.Broken ~= self.VBrokenState then
			if self.dt.Broken then
				self.CModel:SetModel(self.ExplodedModel)
			else
				self.CModel:SetModel(self.WorldModel)
			end
			
			self.VBrokenState = self.dt.Broken
		end
	end
	
	self:CallBaseFunction("ViewModelDrawn")
end

function SWEP:DrawWorldModel(from_postplayerdraw)
	if IsValid(self.WModel2) then
		if self.dt.Broken ~= self.BrokenState then
			if self.dt.Broken then
				--self.WModel2:SetModel(self.ExplodedModel)
			else
				--self.WModel2:SetModel(self.WorldModel)
			end
			
			self.BrokenState = self.dt.Broken
		end
	end
	
	self:CallBaseFunction("DrawWorldModel", from_postplayerdraw)
end

function SWEP:MeleeAttack(dummy)
	if SERVER then
		if self.dt.Broken then
			self.NameOverride = nil
		else
			self.NameOverride = "ullapool_caber_explosion"
		end
	end
	
	return self:CallBaseFunction("MeleeAttack", dummy)
end

function SWEP:OnMeleeHit(trace)
	if IsValid(trace.Entity) and self.Owner:IsFriendly(trace.Entity) then
		return
	end
	
	if not self.dt.Broken then
		if SERVER then
			self.dt.Broken = true
			self.WorldModelOverride2 = self.ExplodedModel
			self.Owner:GetViewModel():SetBodygroup(1,1)
			
			local pos = trace.HitPos
			
			-- KA BEWM
			
			--[[local flags = 0
			if self.Owner:WaterLevel()>0 then
				flags = flags | 1
			end
			
			local effectdata = EffectData()
				effectdata:SetOrigin(pos)
				effectdata:SetAngles(angle_zero)
				effectdata:SetAttachment(flags)
			util.Effect("tf_explosion", effectdata, true, true)
			
			local range = self.ExplosionRadiusInit
			if self.ExplosionRadiusMultiplier and self.ExplosionRadiusMultiplier>1 then
				range = range * self.ExplosionRadiusMultiplier
			end
			
			self.OwnerDamage = 0.85
			util.BlastDamage(self, self.Owner, pos, range, 200)
			
			sound.Play(self.ExplosionSound, pos)]]
			
			-- Use an invisible grenade instead
			local grenade = ents.Create("tf_projectile_pipe")
			grenade:SetPos(pos)
			
			if self:Critical() then
				grenade.critical = true
			end
			
			grenade:SetOwner(self.Owner)
			grenade.BaseDamage = self.ExplosionBaseDamage
			grenade.DamageRandomize = self.ExplosionDamageRandomize
			grenade.ExplosionRadiusInit = self.ExplosionRadiusInit
			grenade.CritDamageMultiplier = self.ExplosionCritDamageMultiplier
			
			self:InitProjectileAttributes(grenade)
			
			grenade.NameOverride = "ullapool_caber_explosion"
			grenade.GrenadeMode = -1 -- invisible, instantly explodes
			grenade:Spawn()
		end
		
		self.Broken = true
	end
end

function SWEP:Deploy()
	if SERVER and self.dt.Broken then
		self.Owner:GetViewModel():SetBodygroup(1,1)
	end
	
	return self:CallBaseFunction("Deploy")
end

function SWEP:Holster()
	self:OnRemove()
	
	return self:CallBaseFunction("Holster")
end

function SWEP:OnRemove()
	if SERVER and self.dt.Broken then
		if IsValid(self.Owner) and self.Owner:GetActiveWeapon()==self then
			self.Owner:GetViewModel():SetBodygroup(1,0)
		end
	end
end