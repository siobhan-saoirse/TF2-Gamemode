if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Wrangler"
	SWEP.RenderGroup 		= RENDERGROUP_BOTH
end

heavysandvichtaunt = { "vo/heavy_sandwichtaunt01.wav", "vo/heavy_sandwichtaunt02.wav", "vo/heavy_sandwichtaunt03.wav", "vo/heavy_sandwichtaunt04.wav", "vo/heavy_sandwichtaunt05.wav", "vo/heavy_sandwichtaunt06.wav", "vo/heavy_sandwichtaunt07.wav", "vo/heavy_sandwichtaunt08.wav", "vo/heavy_sandwichtaunt09.wav", "vo/heavy_sandwichtaunt10.wav", "vo/heavy_sandwichtaunt11.wav", "vo/heavy_sandwichtaunt12.wav", "vo/heavy_sandwichtaunt13.wav", "vo/heavy_sandwichtaunt14.wav", "vo/heavy_sandwichtaunt15.wav", "vo/heavy_sandwichtaunt16.wav", "vo/heavy_sandwichtaunt17.wav" }	

SWEP.Base				= "tf_weapon_base"

SWEP.Slot				= 1
SWEP.ViewModel			= "models/weapons/c_models/c_engineer_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_wrangler.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Swing = Sound("")
SWEP.SwingCrit = Sound("")
SWEP.HitFlesh = Sound("")
SWEP.HitWorld = Sound("")

SWEP.BaseDamage = 45
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay          = 30
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay          = 30
SWEP.RangedMinHealing = 45
SWEP.RangedMaxHealing = 85

SWEP.HoldType = "ITEM1"
SWEP.HoldTypeHL2 = "pistol"
SWEP.NextFireRocket = 1
SWEP.NextFireBullets = 0
SWEP.NextOuch = 3

function SWEP:PrimaryAttack() 
	for k,v in pairs(ents.FindByClass("obj_sentrygun")) do
		if v:GetOwner() == self.Owner then
			if not self.NextFireBullets or CurTime()>=self.NextFireBullets then
				v.TargetPos = self.Owner:GetEyeTrace().HitPos	
				if SERVER then
					if v:GetLevel() == 1 then
						v:RestartGesture(ACT_RANGE_ATTACK1, true)
						--v.Model:RestartGesture(ACT_RANGE_ATTACK1, true)
					else
						v:RestartGesture(ACT_RANGE_ATTACK1_LOW, true)
						--v.Model:RestartGesture(ACT_RANGE_ATTACK1_LOW, true)
					end
					local ok = v:TakeAmmo1(1)
					if ok then
						v:ShootBullets()
					else
						v:EmitSound(v.Sound_Empty)
						if not self.NextOuch or CurTime()>=self.NextOuch then	
							self.Owner:EmitSoundEx("Weapon_Wrangler.Ouch")
							self.NextOuch = CurTime() + 3
						end	
					end
				end
				if v:GetLevel() >= 2 then
					
					--v.Model:RestartGesture(ACT_RANGE_ATTACK1, true)
					self.NextFireBullets = CurTime() + 0.1
				else
					
					--v.Model:RestartGesture(ACT_RANGE_ATTACK1_LOW, true)
					self.NextFireBullets = CurTime() + 0.13
				end
			end
		end
	end
end

function SWEP:Think()
	for k,v in pairs(ents.FindByClass("obj_sentrygun")) do
		if v:GetOwner() == self.Owner then
			v.Target = nil
			if SERVER then
				v:SetPoseParameter("aim_pitch", -self.Owner:GetPoseParameter("body_pitch"))
				v:SetPoseParameter("aim_yaw", self.Owner:GetPoseParameter("body_yaw"))
				v.Model:SetPoseParameter("aim_pitch", -self.Owner:GetPoseParameter("body_pitch"))
				v.Model:SetPoseParameter("aim_yaw", self.Owner:GetPoseParameter("body_yaw"))
			end
		end
	end
	return self.BaseClass.Think(self)
end
		
function SWEP:Holster()
	
	for k,v in pairs(ents.FindByClass("obj_sentrygun")) do
		if v:GetOwner() == self.Owner then
			if v:GetLevel() == 1 then
				v.Shoot_Sound = Sound("Building_Sentrygun.Fire")
			elseif v:GetLevel() == 2 then
				v.Shoot_Sound = Sound("Building_Sentrygun.Fire2")
			elseif v:GetLevel() == 3 then
				v.Shoot_Sound = Sound("Building_Sentrygun.Fire3")
			end
			if SERVER then
				v.Wrangled = false
			end
			if IsValid(animent3) then
			animent3:Fire("Kill", "", 0.01)
			end
		end
	end


	return self.BaseClass.Holster(self)

end

function SWEP:Deploy()
	for k,v in pairs(ents.FindByClass("obj_sentrygun")) do
		if v:GetOwner() == self.Owner then
			if v:GetLevel() == 1 then
				v.Shoot_Sound = Sound("Building_Sentrygun.ShaftFire")
			elseif v:GetLevel() == 2 then
				v.Shoot_Sound = Sound("Building_Sentrygun.ShaftFire2")
			elseif v:GetLevel() == 3 then
				v.Shoot_Sound = Sound("Building_Sentrygun.ShaftFire3")
			end
			v.Wrangled = true 
			if SERVER then
				animent3 = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
				animent3:SetAngles(v:GetAngles())
				animent3:SetPos(v:GetPos())
				animent3:SetModel("models/buildables/sentry_shield.mdl")
				animent3:Spawn()
				animent3:SetSkin(v:GetSkin())
				animent3:Activate()
				animent3:SetParent(v)
			end
		end
	end	
	return self.BaseClass.Deploy(self)
end 

function SWEP:SecondaryAttack()
	for k,v in pairs(ents.FindByClass("obj_sentrygun")) do
		if v:GetOwner() == self.Owner then
			if not self.NextFireRocket or CurTime()>=self.NextFireRocket then
				v.TargetPos = self.Owner:GetEyeTrace().HitPos	
				if SERVER then
					local ok = v:TakeAmmo2(1)
					if ok then
						v:ShootRocket()
						self.NextFireRocket = CurTime() + 3	
						v:RestartGesture(ACT_RANGE_ATTACK2, true)
						v.Model:RestartGesture(ACT_RANGE_ATTACK2, true)
					else
						v:EmitSound(v.Sound_Empty)
						self.NextFireRocket = CurTime() + 0.25
						self:SendWeaponAnim(ACT_ITEM1_VM_IDLE_2)
					end
				end
			end
		end
	end
end