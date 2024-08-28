if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Frying Pan"
	SWEP.Slot				= 2
end

SWEP.Base				= "tf_weapon_melee_base"

SWEP.Swing = Sound("Weapon_Shovel.Miss")
SWEP.SwingCrit = Sound("Weapon_Shovel.MissCrit")
SWEP.HitFlesh = Sound("FryingPan.HitFlesh")
SWEP.HitWorld = Sound("FryingPan.HitWorld")

local SpeedTable = {
{40, 1.6},
{80, 1.4},
{120, 1.2},
{160, 1.1},
}

SWEP.HitBuildingSuccess = Sound("Weapon_Wrench.HitBuilding_Success")
SWEP.HitBuildingFailure = Sound("Weapon_Wrench.HitBuilding_Failure")

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

SWEP.NoCModelOnStockWeapon = false

SWEP.HoldType = "MELEE_ALLCLASS"

function SWEP:InspectAnimCheck()
self:CallBaseFunction("InspectAnimCheck")
self.VM_DRAW = ACT_MELEE_ALLCLASS_VM_DRAW
self.VM_IDLE = ACT_MELEE_ALLCLASS_VM_IDLE
self.VM_HITCENTER = ACT_MELEE_ALLCLASS_VM_HITCENTER
self.VM_SWINGHARD = ACT_MELEE_ALLCLASS_VM_HITCENTER
self.VM_INSPECT_START = ACT_MELEE_ALLCLASS_VM_INSPECT_START
self.VM_INSPECT_IDLE = ACT_MELEE_ALLCLASS_VM_INSPECT_IDLE
self.VM_INSPECT_END = ACT_MELEE_ALLCLASS_VM_INSPECT_END
end

function SWEP:Think()
	self:CallBaseFunction("Think")
	
	if self.Owner:GetPlayerClass() == "scout" then
		self.Primary.Delay = 0.5
	else
		self.Primary.Delay = 0.80
	end
		
	if self.Owner:GetPlayerClass() == "engineer" then
		self.NoHitSound = false
		self.UpgradeSpeed = 25
		self.GlobalCustomHUD = {HudAccountPanel = true}
	end
end

function SWEP:OnMeleeHit(tr)
	if self.Owner:GetPlayerClass() == "engineer" then
		if tr.Entity and tr.Entity:IsValid() then
			if tr.Entity:IsBuilding() then
				local ent = tr.Entity
				
				if ent.IsTFBuilding and ent:IsFriendly(self.Owner) then
					if SERVER then
						local m = ent:AddMetal(self.Owner, self.Owner:GetAmmoCount(TF_METAL))
						if m > 0 then
							self:EmitSound(self.HitBuildingSuccess)
							self.Owner:RemoveAmmo(m, TF_METAL)
							umsg.Start("PlayerMetalBonus", self.Owner)
								umsg.Short(-m)
							umsg.End()
						elseif ent:GetState() == 1 then
							self:EmitSound(self.HitBuildingSuccess)
						else
							self:EmitSound(self.HitBuildingFailure)
						end
					end
				else
					//self:EmitSound(self.HitWorld)
				end
			elseif tr.Entity:IsPlayer() or tr.Entity:IsNPC() then
				//self:EmitSound(self.HitFlesh)
			else
				//self:EmitSound(self.HitWorld)
			end
		elseif tr.HitWorld then
			//self:EmitSound(self.HitWorld)
		end
	end
end