if SERVER then

AddCSLuaFile("shared.lua")

end

if CLIENT then

SWEP.GlobalCustomHUD = {HudBuildingStatus = true}
	SWEP.PrintName			= "Red-Tape Recorder"
SWEP.Slot				= 1
SWEP.RenderGroup		= RENDERGROUP_BOTH

end
 
SWEP.Base				= "tf_weapon_base"

SWEP.ViewModel			= "models/weapons/c_models/c_spy_arms.mdl"
SWEP.WorldModel			= "models/workshop_partner/weapons/c_models/c_sd_sapper/c_sd_sapper.mdl"

SWEP.HoldType = "BUILDING"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.HoldTypeHL2 = "rpg"

SWEP.Primary.Delay		= 0.1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.DeploySound		= Sound("weapons/draw_Secondary.wav")

SWEP.Secondary.Delay		= 0.1
SWEP.Secondary.Automatic	= false
SWEP.HasSecondaryFire = true

SWEP.DeployDuration = 0.1

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:InspectAnimCheck()
	self:CallBaseFunction("InspectAnimCheck")
	self.VM_DRAW = ACT_ITEM3_VM_DRAW
	self.VM_IDLE = ACT_ITEM3_VM_IDLE
end

function SWEP:PrimaryAttack()
	
	if self.Owner:GetPlayerClass() == "spy" or self.Owner:GetPlayerClass() == "gmodplayer"  then
		for k,v in pairs(ents.FindInSphere(self.Owner:GetPos(), 120)) do
			if v:IsPlayer() and v:GetInfoNum("tf_robot", 0) == 1 and not v:IsFriendly(self.Owner) and v:GetInfoNum("tf_giant_robot",0) != 1 then
				self:SetNextPrimaryFire(CurTime() + 10)
				self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_GRENADE)
				if SERVER then
				if v:GetNWBool("Taunting") == true then return end
				if not v:IsOnGround() then return end
				if v:WaterLevel() ~= 0 then return end
				self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_GRENADE)
				v:EmitSound("Weapon_Sapper.Plant") 
				timer.Create("StunRobot25"..v:EntIndex(), 0.001, 1, function()
					v:DoAnimationEvent(ACT_MP_STUN_BEGIN,2)
					timer.Create("StunRobotloop3"..v:EntIndex(), 0.6, 0, function()
						if not v:Alive() then timer.Stop("StunRobotloop") v:Freeze(false) return end
						timer.Create("StunRobotloop4"..v:EntIndex(), 0.2,  0, function()
							if not v:Alive() then timer.Stop("StunRobotloop4") v:Freeze(false) return end
							v:DoAnimationEvent(ACT_MP_STUN_MIDDLE,2)
						end) 
					end)
				end)
				v:Freeze(true)
				v:EmitSound("TappedRobot")
				v:SetNWBool("Taunting", true)
				v:SetNWBool("NoWeapon", true)
				net.Start("ActivateTauntCam")
				net.Send(v)
				local animent = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
				animent:SetModel("models/buildables/sd_sapper_placed.mdl")
				animent:SetSkin(v:GetSkin())
				animent:SetPos(v:GetBonePosition(v:LookupBone("bip_head")))
				animent:SetAngles(v:GetAngles())
				animent:Spawn()
				animent:Activate()
	
				animent:SetSolid( SOLID_OBB ) -- This stuff isn't really needed, but just for physics
				animent:PhysicsInit( SOLID_OBB )
				animent:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
				animent:SetParent(v, v:LookupAttachment("head"))
				timer.Create("EndStunRobot"..v:EntIndex(), 7, 1, function()
					if not IsValid(v) or (v:Health() < 1 and v:GetNWBool("Taunting") != true) then v:Freeze(false) v:StopSound("TappedRobot") timer.Stop("EndStunRobot"..v:EntIndex()) timer.Stop("StunRobotloop3"..v:EntIndex()) timer.Stop("StunRobotloop4"..v:EntIndex()) return end
					timer.Stop("StunRobotloop3"..v:EntIndex())
					timer.Stop("StunRobotloop4"..v:EntIndex())
					v:StopSound("TappedRobot")
					v:EmitSound("Weapon_Sapper.Removed")
					net.Start("DeActivateTauntCam")
					net.Send(v)
					v:Freeze(false)
					v:SetNWBool("NoWeapon", false)
					v:SetNWBool("Taunting", false)
					animent:Remove() 
				end)
				end
			end
			if v:IsPlayer() and not v:IsFriendly(self.Owner) and v:GetInfoNum("tf_giant_robot",0) == 1 then
				self:SetNextPrimaryFire(CurTime() + 10)
				self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_GRENADE)
				if SERVER then
				if v:GetNWBool("Taunting") == true then return end
				if not v:IsOnGround() then return end
				if v:WaterLevel() ~= 0 then return end
				v:EmitSound("Weapon_Sapper.Plant")
				timer.Create("StunRobot25"..v:EntIndex(), 0.001, 1, function()
					timer.Create("StunRobotloop3"..v:EntIndex(), 0.6, 0, function()
						if not v:Alive() then timer.Stop("StunRobotloop") v:Freeze(false) return end
						timer.Create("StunRobotloop4"..v:EntIndex(), 0.000000001,  0, function()
							if not v:Alive() then timer.Stop("StunRobotloop4") v:Freeze(false) return end
							v:SetClassSpeed(27)
						end) 
					end)
				end)
				v:DoAnimationEvent(ACT_DOD_SECONDARYATTACK_BOLT, true)
				v:EmitSound("TappedRobot")
				net.Send(v)
				local animent = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
				animent:SetModel("models/buildables/sd_sapper_placed.mdl")
				animent:SetSkin(v:GetSkin())
				animent:SetPos(v:GetBonePosition(v:LookupBone("bip_head")))
				animent:SetAngles(v:GetAngles())
				animent:Spawn()
				animent:Activate()
	
				animent:SetSolid( SOLID_OBB ) -- This stuff isn't really needed, but just for physics
				animent:PhysicsInit( SOLID_OBB )
				animent:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
				animent:SetParent(v, v:LookupAttachment("head"))
				timer.Create("EndStunRobot"..v:EntIndex(), 7, 1, function()
					if not IsValid(v) or (v:Health() < 1 and v:GetNWBool("Taunting") != true) then v:Freeze(false) v:StopSound("TappedRobot") timer.Stop("EndStunRobot"..v:EntIndex()) timer.Stop("StunRobotloop3"..v:EntIndex()) timer.Stop("StunRobotloop4"..v:EntIndex()) return end
					timer.Stop("StunRobotloop3"..v:EntIndex())
					timer.Stop("StunRobotloop4"..v:EntIndex())
					v:DoAnimationEvent(ACT_MP_STUN_END,2)
					v:StopSound("TappedRobot")
					v:EmitSound("Weapon_Sapper.Removed")
					net.Send(v)
					v:SetClassSpeed(57)
					animent:Remove()
				end)
				end
			end
			if v:IsPlayer() and string.find(game.GetMap(), "mvm_") and v:Team() == TEAM_BLU and self.Owner:Team() != TEAM_BLU and v:GetInfoNum("tf_giant_robot",0) != 1 then
				self:SetNextPrimaryFire(CurTime() + 10)
				self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_GRENADE)
				if SERVER then
				if v:GetNWBool("Taunting") == true then return end
				if not v:IsOnGround() then return end
				if v:WaterLevel() ~= 0 then return end
				v:EmitSound("Weapon_Sapper.Plant")
				timer.Create("StunRobot25"..v:EntIndex(), 0.001, 1, function()
					v:DoAnimationEvent(ACT_MP_STUN_BEGIN,2)
					timer.Create("StunRobotloop3"..v:EntIndex(), 0.6, 0, function()
						if not v:Alive() then timer.Stop("StunRobotloop") v:Freeze(false) return end
						timer.Create("StunRobotloop4"..v:EntIndex(), 0.2,  0, function()
							if not v:Alive() then timer.Stop("StunRobotloop4") v:Freeze(false) return end
							v:DoAnimationEvent(ACT_MP_STUN_MIDDLE,2)
						end) 
					end)
				end)
				v:DoAnimationEvent(ACT_DOD_SECONDARYATTACK_BOLT, true)
				v:Freeze(true)
				v:EmitSound("TappedRobot")
				v:SetNWBool("Taunting", true)
				v:SetNWBool("NoWeapon", true)
				net.Start("ActivateTauntCam")
				net.Send(v)
				local animent = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
				animent:SetModel("models/buildables/sd_sapper_placed.mdl")
				animent:SetSkin(v:GetSkin())
				animent:SetPos(v:GetBonePosition(v:LookupBone("bip_head")))
				animent:SetAngles(v:GetAngles())
				animent:Spawn()
				animent:Activate()
	
				animent:SetSolid( SOLID_OBB ) -- This stuff isn't really needed, but just for physics
				animent:PhysicsInit( SOLID_OBB )
				animent:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
				animent:SetParent(v, v:LookupAttachment("head"))
				timer.Create("EndStunRobot"..v:EntIndex(), 7, 1, function()
					if not IsValid(v) or (v:Health() < 1 and v:GetNWBool("Taunting") != true) then v:Freeze(false) v:StopSound("TappedRobot") timer.Stop("EndStunRobot"..v:EntIndex()) timer.Stop("StunRobotloop3"..v:EntIndex()) timer.Stop("StunRobotloop4"..v:EntIndex()) return end
					timer.Stop("StunRobotloop3"..v:EntIndex())
					timer.Stop("StunRobotloop4"..v:EntIndex())
					v:DoAnimationEvent(ACT_MP_STUN_END,2)
					v:StopSound("TappedRobot")
					v:EmitSound("Weapon_Sapper.Removed")
					net.Start("DeActivateTauntCam")
					net.Send(v)
					v:Freeze(false)
					v:SetNWBool("NoWeapon", false)
					v:SetNWBool("Taunting", false)
					animent:Remove()
				end)
				end
			end 
			if v:IsBuilding() and not v:IsFriendly(self.Owner) then
				self:SetNextPrimaryFire(CurTime() + 2)
				self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_GRENADE)
				v:EmitSound("weapons/sapper_plant.wav") 
				v.Sapped = true
				v.SappedBy = self.Owner
				if SERVER then
				if v:GetClass() == "obj_sentrygun" then
					v:GetOwner():EmitSound("vo/engineer_autoattackedbyspy03.wav", 80, 100)
					if v.Model:GetModel() == "models/buildables/sentry1.mdl" then
						v:SetModel("models/buildables/sentry1_heavy.mdl")
						v:ResetSequence("build")
						v:SetCycle(1)
						v:SetPlaybackRate(-0.5)
						v.Model:SetModel("models/buildables/sentry1_heavy.mdl")
						v.Model:ResetSequence("build")
						v.Model:SetCycle(1)
						v.Model:SetPlaybackRate(-0.5)
						timer.Create("SapEnd"..v:EntIndex(), 11, 1, function()
							v:StopSound("TappedRobot")
							v:Explode()
						end)
					end 
					if v.Model:GetModel() == "models/buildables/sentry2.mdl" then
						v:SetModel("models/buildables/sentry2_heavy.mdl")
						v:ResetSequence("upgrade")
						v:SetCycle(0)
						v:SetPlaybackRate(-0.4)
						v.Model:SetModel("models/buildables/sentry2_heavy.mdl")
						v.Model:ResetSequence("upgrade")
						v.Model:SetCycle(1)
						v.Model:SetPlaybackRate(-0.4)
						timer.Create("SapSentry3"..v:EntIndex(), 4, 1, function()
								if v:GetClass() == "obj_sentrygun" then
									v:SetLevel(1)
									v:SetModel("models/buildables/sentry1_heavy.mdl")
									v:ResetSequence("build")
									v:SetCycle(0)
									v:SetPlaybackRate(-0.4)
									v.Model:SetModel("models/buildables/sentry1_heavy.mdl")
									v.Model:ResetSequence("build")
									v.Model:SetCycle(1)
									v.Model:SetPlaybackRate(-0.4)
									timer.Create("SapEnd"..v:EntIndex(), 11, 1, function()
										v:StopSound("TappedRobot")
										v:Explode()
									end)
								end
						end)
					end
					if v.Model:GetModel() == "models/buildables/sentry3.mdl" then
						v:SetModel("models/buildables/sentry3_heavy.mdl")
						v:ResetSequence("upgrade")
						v:SetCycle(0)
						v:SetPlaybackRate(-0.4) 
						v.Model:SetModel("models/buildables/sentry3_heavy.mdl")
						v.Model:ResetSequence("upgrade")
						v.Model:SetCycle(1)
						v.Model:SetPlaybackRate(-0.4) 
						timer.Create("SapSentry2", 4, 1, function()
								if v:GetClass() == "obj_sentrygun" then
									v:SetLevel(2)
									v:SetModel("models/buildables/sentry2.mdl")
									v.Model:SetModel("models/buildables/sentry2.mdl")
									if v:GetModel() == "models/buildables/sentry2.mdl" then
										v:SetModel("models/buildables/sentry2_heavy.mdl")
										v:ResetSequence("upgrade")
										v:SetCycle(0)
										v:SetPlaybackRate(-0.4)
										v.Model:SetModel("models/buildables/sentry2_heavy.mdl")
										v.Model:ResetSequence("upgrade")
										v.Model:SetCycle(1)
										v.Model:SetPlaybackRate(-0.4)
										timer.Create("SapSentry3"..v:EntIndex(), 4, 1, function()
												if v:GetClass() == "obj_sentrygun" then
													v:SetLevel(1)
													v:SetModel("models/buildables/sentry1_heavy.mdl")
													v:ResetSequence("build")
													v:SetCycle(0)
													v:SetPlaybackRate(-0.5)
													v.Model:SetModel("models/buildables/sentry1_heavy.mdl")
													v.Model:ResetSequence("build")
													v.Model:SetCycle(1)
													v.Model:SetPlaybackRate(-0.5)
													timer.Create("SapEnd"..v:EntIndex(), 11, 1, function()
														v:StopSound("TappedRobot")
														v:Explode()
													end)
												end
										end)
									end
								end
						end)
					end
				elseif v:GetClass() == "obj_dispenser" then
					v:GetOwner():EmitSound("vo/engineer_autoattackedbyspy02.wav", 80, 100)
					if v.Model:GetModel() == "models/buildables/dispenser_light.mdl" then
						v:SetModel("models/buildables/dispenser.mdl")
						v:ResetSequence("build")
						v:SetCycle(0)
						v:SetPlaybackRate(-0.5)
						v.Model:SetModel("models/buildables/dispenser.mdl")
						v.Model:ResetSequence("build")
						v.Model:SetCycle(1)
						v.Model:SetPlaybackRate(-0.5)
						timer.Simple(22, function()
							v:StopSound("TappedRobot")
							v:Explode()
						end)
					end 
					if v.Model:GetModel() == "models/buildables/dispenser_lvl2_light.mdl" then
						v:SetModel("models/buildables/dispenser_lvl2.mdl")
						v:ResetSequence("upgrade")
						v:SetCycle(0)
						v:SetPlaybackRate(-0.4)
						v.Model:SetModel("models/buildables/dispenser_lvl2.mdl")
						v.Model:ResetSequence("upgrade")
						v.Model:SetCycle(1)
						v.Model:SetPlaybackRate(-0.4)
						timer.Create("SapDispenser3", 4, 1, function()
								if v:GetClass() == "obj_dispenser" then
									v:SetLevel(1)
									v:SetModel("models/buildables/dispenser.mdl")
									v:ResetSequence("build")
									v:SetCycle(0)
									v:SetPlaybackRate(-0.5)
									v.Model:SetModel("models/buildables/dispenser.mdl")
									v.Model:ResetSequence("build")
									v.Model:SetCycle(1)
									v.Model:SetPlaybackRate(-0.5)
									timer.Simple(22, function()
										v:StopSound("TappedRobot")
										v:Explode()
									end)
								end
						end)
					end
					if v.Model:GetModel() == "models/buildables/dispenser_lvl3_light.mdl" then
						v:SetModel("models/buildables/dispenser_lvl3.mdl")
						v:ResetSequence("upgrade")
						v:SetCycle(0)
						v:SetPlaybackRate(-0.4) 
						v.Model:SetModel("models/buildables/dispenser_lvl3.mdl")
						v.Model:ResetSequence("upgrade")
						v.Model:SetCycle(1)
						v.Model:SetPlaybackRate(-0.4) 
						timer.Create("SapDispenser2", 4, 1, function()
								if v:GetClass() == "obj_dispenser" then
									v:SetLevel(2)
									v:SetModel("models/buildables/dispenser_lvl2.mdl")
									v.Model:SetModel("models/buildables/dispenser_lvl2.mdl")
									if v:GetModel() == "models/buildables/dispenser_lvl2.mdl" then
										v:SetModel("models/buildables/dispenser_lvl2.mdl")
										v:ResetSequence("upgrade")
										v:SetCycle(0)
										v:SetPlaybackRate(-0.4)
										v.Model:SetModel("models/buildables/dispenser_lvl2.mdl")
										v.Model:ResetSequence("upgrade")
										v.Model:SetCycle(1)
										v.Model:SetPlaybackRate(-0.4)
										timer.Create("SapDispenser3", 4, 1, function()
											if v:IsBuilding() and not v:IsFriendly(self.Owner) then
												if v:GetClass() == "obj_dispenser" then
													v:SetLevel(1)
													v:SetModel("models/buildables/dispenser.mdl")
													v:ResetSequence("build")
													v:SetCycle(0)
													v:SetPlaybackRate(-0.5)
													v.Model:SetModel("models/buildables/dispenser.mdl")
													v.Model:ResetSequence("build")
													v.Model:SetCycle(1)
													v.Model:SetPlaybackRate(-0.5)
													timer.Simple(22, function()
														v:StopSound("TappedRobot")
														v:Explode()
													end)
												end
											end
										end)
									end
								end
						end)
					end
				elseif v:GetClass() == "obj_teleporter" then
					v:GetOwner():EmitSound("vo/engineer_autoattackedbyspy01.wav", 80, 100)   
				end
			end
				
				v:EmitSound("TappedRobot")
				timer.Create("SapSentry"..v:EntIndex(), 0.001, 0, function()
					v.Target = nil
			
					v.TurretPitch = 0
					v.TurretYaw = 0
					v.TargetPitch = 0
					v.TargetYaw = 0
					v.DPitch = 0
					v.DYaw = 0
	
					v.IdlePitchSpeed = 0.3
					v.IdleYawSpeed = 0.75
					if not v:IsValid() then
						v:StopSound("TappedRobot")
						timer.Stop("SapSentry")
					end
					if v.Sapped == false then
						timer.Stop("SapSentry"..v:EntIndex())
					end
				end)
			end
		end
	end
end