
if (!IsMounted("cstrike")) then return end
AddCSLuaFile()
SWEP.Base = "weapon_base"
SWEP.Category = "Civilian 2"
SWEP.PrintName = "Hands"
SWEP.Author = "Daisreich"

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.Spawnable = true

--SWEP.ViewModel = Model( "models/v_models/v_huntingrifle.mdl" )
SWEP.ViewModel = Model( "models/weapons/c_arms.mdl" )
SWEP.WorldModel = "models/empty.mdl"
SWEP.UseHands = true
SWEP.HoldType = "normal"
function SWEP:Deploy()
	self:SetWeaponHoldType( self.HoldType ) 
		local vm = self:GetOwner():GetViewModel()
		if SERVER then
			self:SendWeaponAnim(vm:GetSequenceActivity(vm:LookupSequence("seq_admire")))
		end
	return true
end 

local phys_pushscale = GetConVar( "phys_pushscale" )

function SWEP:DealDamage()
end

function SWEP:Think()
end


function SWEP:Holster()

	return true

end

function SWEP:SetupDataTables()
end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end 

function SWEP:Holster()
	return true

end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end 

function SWEP:PrimaryAttack()
end 
function SWEP:SecondaryAttack()
end 

function SWEP:Reload()
end

function SWEP:OnDrop()
    if SERVER then
        self:Remove()
    end
end