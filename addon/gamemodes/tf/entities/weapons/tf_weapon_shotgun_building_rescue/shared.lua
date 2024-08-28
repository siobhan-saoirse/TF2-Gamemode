if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.HeadshotScore = 1
end

PrecacheParticleSystem( "teleportedin_red" )
PrecacheParticleSystem( "teleported_red" )
PrecacheParticleSystem( "teleportedin_blue" )
PrecacheParticleSystem( "teleported_blue" )
PrecacheParticleSystem( "teleported_flash" )

if CLIENT then

SWEP.PrintName			= "Rescue Ranger"
SWEP.Slot				= 0

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= "models/weapons/c_models/c_engineer_arms.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_tele_shotgun/c_tele_shotgun.mdl"
SWEP.Crosshair = "tf_crosshair1"

SWEP.MuzzleEffect = ""

SWEP.ShootSound = Sound("Weapon_RescueRanger.Single")
SWEP.ShootCritSound = Sound("Weapon_RescueRanger.SingleCrit")
SWEP.ReloadSound = Sound("weapons/shotgun_reload.wav")

SWEP.Primary.ClipSize		= 4
SWEP.Primary.DefaultClip	= SWEP.Primary.ClipSize
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 0.6
SWEP.ReloadTime = 0.5

SWEP.IsRapidFire = false
SWEP.ReloadSingle = true

SWEP.HoldType = "PRIMARY"

SWEP.ProjectileShootOffset = Vector(0, 8, -5)

function SWEP:ShootProjectile()
	if SERVER then
		local syringe = ents.Create("tf_projectile_arrow_heal_building")
		local ang = self.Owner:EyeAngles()
		local vec = ang:Forward()
		
		--local vec = ang:Forward() + math.Rand(-self.BulletSpread,self.BulletSpread) * ang:Right() + math.Rand(-self.BulletSpread,self.BulletSpread) * ang:Up()
		
		syringe:SetPos(self:ProjectileShootPos())
		syringe:SetAngles(vec:Angle())
		if self:Critical() then
			syringe.critical = true
		end
		syringe:SetOwner(self.Owner)
		--syringe:SetProjectileType(1)
		
		self:InitProjectileAttributes(syringe)
		
		syringe.NameOverride = self:GetItemData().item_iconname
		syringe:Spawn()
	end
	
	self:ShootEffects()
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 0.5)
	local v = self.Owner:GetEyeTrace().Entity
	local pos = self.Owner:GetEyeTrace().HitPos
		if v:IsBuilding() and v:GetOwner() == self.Owner then
			if v:GetClass() == "obj_sentrygun" then
				v:EmitSound("weapons/rescue_ranger_teleport_receive_0"..math.random(1,2)..".wav")
				if self.Owner:Team() == TEAM_RED or self.Owner:Team() == TEAM_NEUTRAL then
					ParticleEffect("teleportedin_red", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ) )
					ParticleEffect("teleported_red", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ))
					ParticleEffect("teleported_flash", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ))
				else
					ParticleEffect("teleportedin_blue", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ) )
					ParticleEffect("teleported_blue", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ))
					ParticleEffect("teleported_flash", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ))
				end
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
					self.Owner:ConCommand("move 2 0")
					self.Owner:EmitSound("weapons/rescue_ranger_teleport_send_0"..math.random(1,2)..".wav")
				end
			elseif v:GetClass() == "obj_dispenser" then
				v:EmitSound("weapons/rescue_ranger_teleport_receive_0"..math.random(1,2)..".wav")
				if self.Owner:Team() == TEAM_RED or self.Owner:Team() == TEAM_NEUTRAL then
					ParticleEffect("teleportedin_red", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ) )
					ParticleEffect("teleported_red", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ))
					ParticleEffect("teleported_flash", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ))
				else
					ParticleEffect("teleportedin_blue", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ) )
					ParticleEffect("teleported_blue", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ))
					ParticleEffect("teleported_flash", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ))
				end
				if SERVER then
					local builder = self.Owner:GetWeapon("tf_weapon_builder")
					if v:GetLevel()==2 then
						builder.MovedBuildingLevel = 2
					elseif v:GetLevel()==1 then
						builder.MovedBuildingLevel = 1
					elseif v:GetLevel() == 3 then 
						builder.MovedBuildingLevel = 3
					end
					v:Fire("Kill", "", 0.)
					self.Owner:ConCommand("move 0 0")
					self.Owner:EmitSound("weapons/rescue_ranger_teleport_send_0"..math.random(1,2)..".wav")
				end
			elseif v:GetClass() == "obj_teleporter" and v:IsExit() != true then
				v:EmitSound("weapons/rescue_ranger_teleport_receive_0"..math.random(1,2)..".wav")
				if self.Owner:Team() == TEAM_RED or self.Owner:Team() == TEAM_NEUTRAL then
					ParticleEffect("teleportedin_red", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ) )
					ParticleEffect("teleported_red", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ))
					ParticleEffect("teleported_flash", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ))
				else
					ParticleEffect("teleportedin_blue", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ) )
					ParticleEffect("teleported_blue", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ))
					ParticleEffect("teleported_flash", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ))
				end
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
					self.Owner:ConCommand("move 1 0")
					self.Owner:EmitSound("weapons/rescue_ranger_teleport_send_0"..math.random(1,2)..".wav")
				end
			elseif v:GetClass() == "obj_teleporter" and v:IsExit() != false then
				v:EmitSound("weapons/rescue_ranger_teleport_receive_0"..math.random(1,2)..".wav")
				if self.Owner:Team() == TEAM_RED or self.Owner:Team() == TEAM_NEUTRAL then
					ParticleEffect("teleportedin_red", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ) )
					ParticleEffect("teleported_red", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ))
					ParticleEffect("teleported_flash", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ))
				else
					ParticleEffect("teleportedin_blue", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ) )
					ParticleEffect("teleported_blue", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ))
					ParticleEffect("teleported_flash", self.Owner:GetEyeTrace().HitPos, Angle( 0, 0, 0 ))
				end
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
					self.Owner:ConCommand("move 1 1")
					self.Owner:EmitSound("weapons/rescue_ranger_teleport_send_0"..math.random(1,2)..".wav")
				end
			end
		end
end 
