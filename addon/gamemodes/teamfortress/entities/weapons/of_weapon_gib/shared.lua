-- Real class name: tf_weapon_bet_rocketlauncher (see shd_items.lua)

if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then

SWEP.PrintName			= "G.I.B."
SWEP.Slot				= 3
SWEP.HasCModel = true
SWEP.RenderGroup = RENDERGROUP_BOTH
end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/v_models/v_bfg.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_bfg.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.MuzzleEffect = "muzzle_pipelauncher"

SWEP.ShootSound = Sound("weapons/mlg_shoot.wav")
SWEP.ShootCritSound = Sound("weapons/mlg_shoot_crit.wav")
SWEP.CustomExplosionSound = Sound("Weapon_QuakeRPG.Reload")
SWEP.ReloadSound = Sound("Weapon_QuakeRPG.Reload")

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8

SWEP.IsRapidFire = false
SWEP.ReloadSingle = false	

SWEP.HoldType = "PRIMARY"

SWEP.ProjectileShootOffset = Vector(30, 0, -6)

SWEP.PunchView = Angle( 0, 0, 0 )

SWEP.Properties = {}


function SWEP:Deploy()
	self:CallBaseFunction("Deploy")
end

function SWEP:ShootProjectile()
	if self:CanPrimaryAttack() == true then
		timer.Simple(0.2, function() 
		
			self:EmitSound(")weapons/mlg_charge_up.wav")
			self:SendWeaponAnim(ACT_VM_CHARGEUP)
			timer.Simple(1, function()
				self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
				if SERVER then
					self.Owner:EmitSound(")weapons/mlg_shoot.wav")
					local rocket = ents.Create("tf_projectile_gibber")
					rocket:SetPos(self:ProjectileShootPos())
					local ang = self.Owner:EyeAngles()
					
					if self.WeaponMode == 1 then
						local charge = (CurTime() - self.ChargeStartTime) / self.ChargeTime
						rocket.Gravity = Lerp(1 - charge, self.MinGravity, self.MaxGravity)
						rocket.BaseSpeed = Lerp(charge, self.MinForce, self.MaxForce)
						ang.p = ang.p + Lerp(1 - charge, self.MinAddPitch, self.MaxAddPitch)
					end
					
					rocket:SetAngles(ang)
					
					if self:Critical() then
						rocket.critical = true
					end
					
					for k,v in pairs(self.Properties) do
						rocket[k] = v
					end
					
					rocket:SetOwner(self.Owner)
					self:InitProjectileAttributes(rocket)
					
					rocket:Spawn()
					rocket:Activate()
				end
				
				self:ShootEffects()
			end)
		end)
	end
end