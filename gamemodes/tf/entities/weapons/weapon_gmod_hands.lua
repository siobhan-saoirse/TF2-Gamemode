
--if (!IsMounted("cstrike")) then return end
AddCSLuaFile()
SWEP.Base = "weapon_csbase"
SWEP.Category = "Team Fortress 2 Gamemode"
SWEP.PrintName = "Hands"
SWEP.Author = "Daisreich"

SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.Spawnable = true
SWEP.ViewModelFOV = 90

--SWEP.ViewModel = Model( "models/v_models/v_huntingrifle.mdl" )
SWEP.ViewModel = Model( "models/weapons/c_arms.mdl" )
SWEP.WorldModel = "models/empty.mdl"
SWEP.UseHands = true
SWEP.HoldType = "normal"
SWEP.Primary.ClipSize      = -1
SWEP.Primary.DefaultClip   = -1
SWEP.Primary.Automatic     = false
SWEP.Primary.Ammo          = "none"

SWEP.Secondary.ClipSize    = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic   = false
SWEP.Secondary.Ammo        = "none"

local weaponSelectionColor = Color( 255, 220, 0, 255 )
function SWEP:DrawWeaponSelection( x, y, w, t, a )
    weaponSelectionColor.a = a
    draw.SimpleText( "C", "creditslogo", x + w / 2, y, weaponSelectionColor, TEXT_ALIGN_CENTER )

    --baseClass.PrintWeaponInfo( self, x + w + 20, y + t * 0.95, alpha )
end

function SWEP:Deploy()
	self:SetWeaponHoldType( self.HoldType ) 
		local vm = self:GetOwner():GetViewModel()
		if SERVER then
			vm:SendViewModelMatchingSequence(vm:LookupSequence("seq_admire"))
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
    self:DrawShadow( false )
end 

function SWEP:Holster()
	return true

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