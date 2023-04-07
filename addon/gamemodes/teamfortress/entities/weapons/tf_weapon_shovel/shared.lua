if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Slot				= 2
if CLIENT then
	SWEP.PrintName			= "Shovel"
end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.ViewModel			= "models/weapons/c_models/c_soldier_arms_empty.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_shovel.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.Swing = Sound("Weapon_Shovel.Miss")
SWEP.SwingCrit = Sound("Weapon_Shovel.MissCrit")
SWEP.HitFlesh = Sound("Weapon_Shovel.HitFlesh")
SWEP.HitWorld = Sound("Weapon_Shovel.HitWorld")

local SpeedTable = {
{40, 1.6},
{80, 1.4},
{120, 1.2},
{160, 1.1},
}

SWEP.MinDamage = 0.5
SWEP.MaxDamage = 1.75

SWEP.BaseDamage = 65
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8

SWEP.NoCModelOnStockWeapon = true

SWEP.HoldType = "MELEE"
SWEP.HoldTypeHL2 = "MELEE"

function SWEP:Think()
	self:CallBaseFunction("Think")
	if self:GetItemData().model_player == "models/workshop/weapons/c_models/c_riding_crop/c_riding_crop.mdl" then
		self.Swing = Sound("DisciplineDevice.Swing")
		
		self.MeleeRange = 90
		self.MeleeAttackDelay = 0.2
		self.HitFlesh = Sound("DisciplineDevice.Impact")
		self.HitWorld = Sound("DisciplineDevice.HitWorld")
	end
	if SERVER and self.WeaponMode == 1 and (not self.NextHealthCheck or CurTime()>=self.NextHealthCheck) then
		if not self.InitialBaseDamage then
			self.InitialBaseDamage = self.BaseDamage
		end
		
		self.BaseDamage = self.InitialBaseDamage * Lerp((self.Owner:GetMaxHealth()-self.Owner:Health()) / self.Owner:GetMaxHealth(), self.MinDamage, self.MaxDamage)
		
		local sp
		for _,v in ipairs(SpeedTable) do
			if self.Owner:Health()<=v[1] then
				sp = v[2]
				break
			end
		end
		
		if sp~=self.LastSpeed then
			if sp then
				self.LocalSpeedBonus = sp
			else
				self.LocalSpeedBonus = nil
			end
			if self.Owner:GetInfoNum("tf_giant_robot",0) != 1 then
			self.Owner:ResetClassSpeed()
			end
			self.LastSpeed = sp
		end
		
		self.NextHealthCheck = CurTime() + 0.1
	end
end

function SWEP:Deploy()
	if SERVER and self.WeaponMode == 1 then
		self.NameOverride = "pickaxe"
	end
	
	return self:CallBaseFunction("Deploy")
end

function SWEP:Critical() 
	
	if self:GetItemData().model_player == "models/workshop/weapons/c_models/c_market_gardener/c_market_gardener.mdl" then
		if self.Owner:GetWeapons()[1].GetRocketJumpForce then
			return true
		else
			return false
		end
	end	
	if self:GetItemData().model_player == "models/weapons/c_models/c_market_gardener/c_market_gardener.mdl" then
		if self.Owner:GetWeapons()[1].GetRocketJumpForce then
			return true
		else
			return false
		end
	end
	return self:CallBaseFunction("Critical")
end

function SWEP:Holster()
	if SERVER and self.WeaponMode == 1 then
		self.LastSpeed = nil
	end
	
	return self:CallBaseFunction("Holster")
end
