
local tf_targe_enhanced_charge = CreateConVar("tf_targe_enhanced_charge", 1, {FCVAR_CHEAT})

ENT.Type 			= "anim"
ENT.Base 			= "tf_wearable_item"

ENT.MeleeRange = 50

ENT.ForceMultiplier = 10000
ENT.CritForceMultiplier = 10000
ENT.ForceAddPitch = 0
ENT.CritForceAddPitch = 0

ENT.DefaultBaseDamage = 15
ENT.DamagePerHead = 10
--ENT.MaxHeads = 5

ENT.BaseDamage = 15
ENT.DamageRandomize = 0.1
ENT.MaxDamageRampUp = 0
ENT.MaxDamageFalloff = 0

ENT.HitPlayerSound = Sound("DemoCharge.HitFlesh")
ENT.HitPlayerRangeSound = Sound("DemoCharge.HitFleshRange")
ENT.HitWorldSound = Sound("DemoCharge.HitWorld")

ENT.CritStartSound = ""
ENT.CritStopSound = ""

ENT.DefaultChargeDuration = 2.5
ENT.ChargeCooldownDuration = 20

ENT.ChargeSteerConstraint = GetConVar( "sensitivity" )

function ENT:SetupDataTables()
	self.BaseClass.SetupDataTables(self)
	self:DTVar("Bool", 0, "Charging")
	self:DTVar("Bool", 1, "Ready")
	self:DTVar("Float", 0, "NextEndCharge")
	self:DTVar("Float", 1, "AdditiveChargeDuration")
	self:DTVar("Float", 2, "ChargeCooldownMultiplier")
end

if CLIENT then

ENT.GlobalCustomHUD = {HudDemomanCharge = true}

function ENT:InitializeCModel(weapon)
	local vm = self:GetOwner():GetViewModel()
	
	if IsValid(vm) then
		self.CModel = ClientsideModel(self.Model)
		if not IsValid(self.CModel) then return end
		
		self.CModel:SetPos(vm:GetPos())
		self.CModel:SetAngles(vm:GetAngles())
		self.CModel:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL))
		self.CModel:SetParent(vm)
		self.CModel:SetNoDraw(true)
	end
end

function ENT:Think()
	self.BaseClass.Think(self)
	
	if not self.Initialized then
		self.Initialized = true
		if IsValid(self:GetOwner()) then
			self:GetOwner().TargeEntity = self
			if self:GetOwner() == LocalPlayer() then
				HudDemomanPipes:SetProgress(1)
				HudDemomanPipes:SetChargeStatus(0)
			end
		end
	end
	
	if self:GetOwner() == LocalPlayer() then
		if self.dt.Charging then
			if not self.ChargeDuration then
				self.ChargeDuration = self.DefaultChargeDuration + self.dt.AdditiveChargeDuration
			end
			
			local p = (self.dt.NextEndCharge - CurTime()) / self.ChargeDuration
			local p0 = p * (self.DefaultChargeDuration / self.ChargeDuration)
			
			if p0 < 0.33 then
				HudDemomanPipes:SetChargeStatus(3)
			elseif p0 < 0.66 then
				HudDemomanPipes:SetChargeStatus(2)
			else
				HudDemomanPipes:SetChargeStatus(1)
			end
			
			HudDemomanPipes:SetProgress(p)
		else
			HudDemomanPipes:SetChargeStatus(0)
			if self.dt.Ready then
				HudDemomanPipes:SetProgress(1)
			else
				self.ChargeDuration = nil
				
				local cooldown = self.ChargeCooldownDuration * self.dt.ChargeCooldownMultiplier
				local p = 1 - (self.dt.NextEndCharge - CurTime()) / cooldown
				HudDemomanPipes:SetProgress(p)
			end
		end
	end
end

hook.Add("PlayerBindPress", "TargeChargeBindPress", function(pl, cmd, down)
	local t = LocalPlayer().TargeEntity
	if IsValid(t) and t.dt and t.dt.Charging then
		if string.find(cmd, "+jump") then
			return true
		elseif string.find(cmd, "+duck") then
			return true
		end
	end
end)

hook.Add("CreateMove", "TargeChargeCreateMove", function(cmd)
	local t = LocalPlayer().TargeEntity
	if IsValid(t) and t.dt and t.dt.Charging then
		local ang = cmd:GetViewAngles()
		if LocalPlayer().SavedTargeAngle then
			local oldyaw = LocalPlayer().SavedTargeAngle.y
		end
		LocalPlayer().SavedTargeAngle = ang
	else
		LocalPlayer().SavedTargeAngle = nil
	end
end)

end

if SERVER then

AddCSLuaFile("shared.lua")

function ENT:CanChargeThrough(ent)
	if ent:GetClass() == "prop_physics" or ent:GetClass() == "prop_physics_multiplayer" then
		return (ent:GetPhysicsObject():IsValid(self.WModel2) and ent:GetPhysicsObject():IsMoveable() and ent:GetPhysicsObject():GetMass() < 200) or
				(ent:GetMaxHealth() > 1)
	elseif ent:GetClass() == "prop_dynamic" or ent:GetClass() == "prop_dynamic_override" then
		return ent:GetMaxHealth() > 1
	elseif ent:GetClass() == "func_breakable" then
		return true
	end
	
	return false
end

-- Open the area portal linked to this door entity
local function OpenLinkedAreaPortal(ent)
	local name = ent:GetName()
	if not name or name == "" then return end
	
	for _,v in pairs(ents.FindByClass("func_areaportal")) do
		if v.TargetDoorName == name then
			v:Fire("Open")
		end
	end
end

function ENT:MeleeAttack()
	if not IsValid(self:GetOwner()) then return end
	if self.ChargeState == 3 then return end
	
	local pos = self:GetOwner():GetShootPos()
	local ang = self:GetOwner():EyeAngles()
	ang.p = 0
	local endpos = pos + ang:Forward() * self.MeleeRange
	
	local hitent, hitpos, dmginfo, dir
	
	--self:GetOwner():LagCompensation(true)
	
	local tr = util.TraceLine {
		start = pos,
		endpos = endpos,
		filter = self:GetOwner()
	}
	
	if not tr.Hit then
		local mins, maxs = Vector(-20, -20, -40), Vector(20, 20, 20)
		
		tr = util.TraceHull {
			start = pos,
			endpos = endpos,
			filter = self:GetOwner(),
		
			mins = mins,
			maxs = maxs,
		}
	end
	
	--self:GetOwner():LagCompensation(false)
	
	if tr.Entity and tr.Entity:IsValid(self.WModel2) then
		if self:GetOwner():IsFriendly(tr.Entity) or self:GetOwner():GetSolid() == SOLID_NONE then
			return
		end
		
		local ang = self:GetOwner():EyeAngles()
		dir = ang:Forward()
		hitpos = tr.Entity:NearestPoint(self:GetOwner():GetShootPos()) - 2 * dir
		tr.HitPos = hitpos
		
		if self:GetOwner():CanDamage(tr.Entity) && !tr.Entity.HitByCharger then
			local pitch, mul, dmgtype
			
			dmgtype = DMG_SLASH
			pitch, mul = self.ForceAddPitch, self.ForceMultiplier
			
			ang.p = math.Clamp(math.NormalizeAngle(ang.p - pitch), -90, 90)
			local force_dir = ang:Forward()
			
			--self.BaseDamage = self.DefaultBaseDamage + self.DamagePerHead * math.min(self:GetOwner():GetNWInt("Heads"), self.MaxHeads)
			self.BaseDamage = self.DefaultBaseDamage + self.DamagePerHead * self:GetOwner():GetNWInt("Heads")
			
			local dmg = 20
			
			dmginfo = DamageInfo()
				dmginfo:SetAttacker(self:GetOwner())
				dmginfo:SetInflictor(self)
				dmginfo:SetDamage(dmg)
				dmginfo:SetDamageType(dmgtype)
				dmginfo:SetDamagePosition(hitpos)
				dmginfo:SetDamageForce(dmg * force_dir * mul)
			tr.Entity:DispatchTraceAttack(dmginfo, hitpos, hitpos + 5*dir)
			
			local phys = tr.Entity:GetPhysicsObject()
			if phys and phys:IsValid(self.WModel2) then
				tr.Entity:SetPhysicsAttacker(self:GetOwner())
			end
			if (tr.Entity:Health() < 1) then
				self:GetOwner():SetNWBool("Taunting", false)
				net.Start("DeActivateTauntCam")
				net.Send(self:GetOwner())
			end
		end
		
		if tr.Entity:IsTFPlayer() and not tr.Entity:IsBuilding() then
			if self.ChargeState == 2 and (not self.NextRangeSound or CurTime() > self.NextRangeSound) then
				sound.Play("player/charger/hit/charger_smash_0"..math.random(1,3)..".wav", self:GetOwner():GetPos())
				self.NextRangeSound = CurTime() + 1
			else
				self.ChargeState = 3
				if (tr.Entity:Health() < 20) then return end
					tr.Entity:EmitSound("Event.ChargerHit")
					if (tr.Entity:IsPlayer()) then
						net.Start("ActivateTauntCam")
						net.Send(tr.Entity)
						tr.Entity:SendLua('LocalPlayer():EmitSound("Event.ChargerSmash")')
					end
					sound.Play("player/charger/hit/charger_smash_0"..math.random(1,3)..".wav", self:GetOwner():GetPos())
					tr.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
					local ply = tr.Entity
					local ent = tr.Entity
					local animent = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
					animent:SetModel("models/cpthazama/l4d2/shared/anim_survivor.mdl")
					animent:SetSkin(self:GetOwner():GetSkin())
					animent:SetPos(self:GetOwner():GetPos())
					animent:SetAngles(self:GetOwner():GetAngles() + Angle(0,180,0))
					animent:Spawn()
					animent:Activate()
					ply.RagdollEntity = animent
					animent:SetSolid( SOLID_OBB ) -- This stuff isn't really needed, but just for physics
					animent:PhysicsInit( SOLID_OBB )
					animent:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
					animent:SetSequence( "Charger_carried" )
					animent:SetPlaybackRate( 1 )
					local animent2 = ents.Create( 'prop_dynamic_override' ) -- The entity used for the death animation	
					animent2:SetModel(ply:GetModel())
					animent2:SetSkin(ply:GetSkin())
					animent2:SetPos(ply:GetPos())
					animent2:SetAngles(ply:GetAngles())
					animent2:SetParent(animent)
					animent2:AddEffects(EF_BONEMERGE)
					timer.Create("CheckIfChargerOrVictimDead"..self:GetOwner():EntIndex(), 0, 0, function()
						local v = tr.Entity
						if v:Health() <= 1 then 
							timer.Stop("CheckIfChargerOrVictimDead"..self:GetOwner():EntIndex()) 
							timer.Stop("RIPTHATASSHOLEAPART"..self:GetOwner():EntIndex()) 
							timer.Stop("ChargerAnimLoop"..self:GetOwner():EntIndex()) 
							v:StopSound("Event.ChargerSlam")
							self:GetOwner():SetNWBool("Taunting", false)
							self:GetOwner():SetNWBool("NoWeapon", false)
							v:SetNWBool("Taunting", false)
							v:SetNoDraw(false)
							--v:SetParent()
							v:SetCollisionGroup(COLLISION_GROUP_PLAYER)
							net.Start("DeActivateTauntCam")
							net.Send(self:GetOwner())
							net.Start("DeActivateTauntCam")
							net.Send(v)
							if (IsValid(animent)) then
								animent:Remove()
							end
							if (IsValid(animent2)) then
								animent2:Remove()
							end
							return 
						end
						if self:GetOwner():Health() <= 1 then 
							timer.Stop("CheckIfChargerOrVictimDead"..self:GetOwner():EntIndex()) 
							timer.Stop("RIPTHATASSHOLEAPART"..self:GetOwner():EntIndex()) 
							timer.Stop("ChargerAnimLoop"..self:GetOwner():EntIndex()) 
							v:StopSound("Event.ChargerSlam")
							
							animent.IsBeingPounded = false
							animent:SetParent()
							animent:SetCycle( 0 )
							animent:SetSequence( "GetUpFrom_Charger" )
							timer.Simple(2.5, function()
									
								v:SetNWBool("Taunting", false)
								v:SetNoDraw(false)
								v:SetCollisionGroup(COLLISION_GROUP_PLAYER)
								--v:SetParent()
								net.Start("DeActivateTauntCam")
								net.Send(v)
								if (IsValid(animent)) then
									animent:Remove()
								end
								if (IsValid(animent2)) then
									animent2:Remove()
								end
								
							end) 
							return 
						end
					end)
					local wep = self
					function animent:Think() -- This makes the animation work
						if (self:GetCycle() == 1) then
							if (self.IsBeingPounded) then
								wep.Owner:DoAnimationEvent("Charger_pound")
							end
							self:SetCycle(0)
						end
						if (IsValid(wep) and IsValid(wep.Owner)) then
							self:SetAngles(wep.Owner:GetAngles() + Angle(0,180,0))
							self:SetPos(wep.Owner:GetPos())
							tr.Entity:SetPos(wep.Owner:GetPos())
							tr.Entity:SetAngles(wep.Owner:GetAngles())
							tr.Entity:SetNoDraw(true)
						end
						self:NextThink( CurTime() )
						return true
					end
					ply.RagdollEntity2 = animent2
					animent.AutomaticFrameAdvance = true
				timer.Simple((self.dt.NextEndCharge - CurTime()) / self.ChargeDuration, function()
					timer.Stop("ChargingChargerAnimLoop"..self:GetOwner():EntIndex())
					if (tr.Entity:Health() < 20) then return end
					self:StopCharging()
					self:GetOwner():DoAnimationEvent("Charger_slam_ground")					
					sound.Play("physics/concrete/boulder_impact_hard"..math.random(1,3)..".wav", self:GetOwner():GetPos())
					animent:SetSequence( "Charger_slammed_ground" )
					animent:SetCycle(0)
					timer.Simple(0.8,function()

						for k,v in pairs(ents.FindInSphere(tr.Entity:GetPos(), 110)) do
							if v:Health() >= 0 then
								if v:IsTFPlayer() and v:EntIndex() != self:GetOwner():EntIndex() and v:EntIndex() == tr.Entity:EntIndex() and not v:IsFriendly(self:GetOwner()) then
									
									self:GetOwner():DoAnimationEvent(ACT_DOD_RELOAD_DEPLOYED)
									if self:GetOwner():WaterLevel() ~= 0 then return end
									self:GetOwner():SetNWBool("Taunting", true)
									self:GetOwner():SetNWBool("NoWeapon", true)
									net.Start("ActivateTauntCam")
									net.Send(self:GetOwner())
									v:SetPos(self:GetOwner():GetPos())
									v:SetAngles(self:GetOwner():GetAngles())
									--v:SetParent(self:GetOwner(), self:GetOwner():LookupAttachment("rhand"))
									v:SetNWBool("Taunting", true)
									animent:SetCycle(0)
									animent:SetSequence( "Charger_pounded" )
									animent.IsBeingPounded = true
									v.RagdollEntity = animent
									v.IsBeingPoundedByCharger = true
									if (v:IsPlayer()) then
										v:SendLua('LocalPlayer():EmitSound("Event.ChargerSlam")')
									end
									v:EmitSound("Event.ChargerSlamHit", 85)
									self:GetOwner():EmitSound("player/charger/voice/attack/charger_pummel0"..math.random(1,4)..".wav",85)
									self:GetOwner():DoAnimationEvent("Charger_pound")
									
									ent:SetPos(ent:GetPos() + Vector(0,0,30))
									--ent:DoAnimationEvent(ACT_MP_SWIM_IDLE)
									ent:SetMoveType(MOVETYPE_FLYGRAVITY)
									ent:SetNoDraw(true)
									timer.Create("ChargerAnimLoop"..self:GetOwner():EntIndex(), 1.7, 0, function()
									end)
									timer.Create("RIPTHATASSHOLEAPART"..self:GetOwner():EntIndex(), 0.7, 0, function()
										self:GetOwner():EmitSound("player/charger/voice/attack/charger_pummel0"..math.random(1,4)..".wav",85)
										timer.Adjust("RIPTHATASSHOLEAPART"..self:GetOwner():EntIndex(), 1.7)
										timer.Simple(0.25, function()
											v:TakeDamage(15, self:GetOwner(), self)
											v:EmitSound("player/charger/hit/charger_smash_0"..math.random(1,3)..".wav", 85, 100)
										end)
									end)
								end
							end
						end
					end)
				end)
			end
		else
			timer.Simple(0.8, function()
				self:GetOwner():SetNWBool("Taunting", false)
				net.Start("DeActivateTauntCam")
				net.Send(self:GetOwner())
			end)
			self:GetOwner():DoAnimationEvent("Shoved_Backward")
			self:GetOwner():EmitSound("ChargerZombie.Stagger")
			sound.Play("physics/concrete/boulder_impact_hard"..math.random(1,3)..".wav", self:GetOwner():GetPos())
			self:StopCharging()
			timer.Stop("ChargingChargerAnimLoop"..self:GetOwner():EntIndex())
		end
	elseif tr.HitWorld then
		timer.Simple(0.8, function()
			self:GetOwner():SetNWBool("Taunting", false)
			net.Start("DeActivateTauntCam")
			net.Send(self:GetOwner())
		end)
		self:GetOwner():DoAnimationEvent("Shoved_Backward")
		self:GetOwner():EmitSound("ChargerZombie.Stagger")
		sound.Play("physics/concrete/boulder_impact_hard"..math.random(1,3)..".wav", self:GetOwner():GetPos())
		self:StopCharging()
		timer.Stop("ChargingChargerAnimLoop"..self:GetOwner():EntIndex())
	else
		return
	end
	
	util.ScreenShake(self:GetPos(), 10, 5, 1, 512)
	
	if not tr.HitWorld then
		if self:GetOwner().TempAttributes.ChargeIsUnstoppable then
			return
		end
		
		if tf_targe_enhanced_charge:GetBool() and IsValid(tr.Entity) then
			if self:CanChargeThrough(tr.Entity) then
				return
			elseif tr.Entity:GetClass() == "prop_door_rotating" then
				timer.Simple(0.8, function()
					self:GetOwner():SetNWBool("Taunting", false)
					net.Start("DeActivateTauntCam")
					net.Send(self:GetOwner())
				end)
				self:GetOwner():DoAnimationEvent("Shoved_Backward")
				self:GetOwner():EmitSound("ChargerZombie.Stagger")
				sound.Play("physics/concrete/boulder_impact_hard"..math.random(1,3)..".wav", self:GetOwner():GetPos())
				self:StopCharging()
				timer.Stop("ChargingChargerAnimLoop"..self:GetOwner():EntIndex())
				local p = ents.Create("prop_physics")
				p:SetModel(tr.Entity:GetModel())
				p:SetBodygroup(1, 1)
				p:SetSkin(tr.Entity:GetSkin())
				p:SetPos(tr.Entity:GetPos())
				p:SetAngles(tr.Entity:GetAngles())
				
				OpenLinkedAreaPortal(tr.Entity)
				tr.Entity:Remove()
				timer.Simple(0.8, function()
					self:GetOwner():SetNWBool("Taunting", false)
					net.Start("DeActivateTauntCam")
					net.Send(self:GetOwner())
				end)
				p:Spawn()
				
					p:DispatchTraceAttack(dmginfo, hitpos, hitpos + 5*dir)
				
				local phys = p:GetPhysicsObject()
				if phys and phys:IsValid(self.WModel2) then
					p:SetPhysicsAttacker(self:GetOwner())
				end
				
				return
			elseif tr.Entity:GetClass() == "prop_dynamic" and IsValid(tr.Entity:GetParent())
			and tr.Entity:GetParent():GetClass()=="func_door_rotating" then
				timer.Simple(0.8, function()
					self:GetOwner():SetNWBool("Taunting", false)
					net.Start("DeActivateTauntCam")
					net.Send(self:GetOwner())
				end)
				self:GetOwner():DoAnimationEvent("Shoved_Backward")
				self:GetOwner():EmitSound("ChargerZombie.Stagger")
				sound.Play("physics/concrete/boulder_impact_hard"..math.random(1,3)..".wav", self:GetOwner():GetPos())
				self:StopCharging()
				timer.Stop("ChargingChargerAnimLoop"..self:GetOwner():EntIndex())
				local door = tr.Entity:GetParent()
				
				local p = ents.Create("prop_physics")
				p:SetModel(tr.Entity:GetModel())
				p:SetSkin(tr.Entity:GetSkin())
				p:SetPos(tr.Entity:GetPos())
				p:SetAngles(tr.Entity:GetAngles())
				
				OpenLinkedAreaPortal(door) 
				door:Remove()
				p:Spawn()
				
					p:DispatchTraceAttack(dmginfo, hitpos, hitpos + 5*dir)
				
				local phys = p:GetPhysicsObject()
				if phys and phys:IsValid(self.WModel2) then
					p:SetPhysicsAttacker(self:GetOwner())
				end
				
				return
			end
		end
	end
	
	local vel = self:GetOwner():GetVelocity()
	local right = self:GetOwner():EyeAngles():Right()
	local side = vel:DotProduct(right)
	
	self:GetOwner():SetVelocity(-side * right)
end

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	if IsValid(self:GetOwner()) then
		self:GetOwner().TargeEntity = self
	end
	self.dt.Charging = false
	self.dt.Ready = true
	self.dt.ChargeCooldownMultiplier = 1
end

function ENT:StartCharging()
	if not self.ChargeDuration then
		self.dt.AdditiveChargeDuration = self:GetOwner().TempAttributes.AdditiveChargeDuration or 0
		self.dt.ChargeCooldownMultiplier = self:GetOwner().TempAttributes.ChargeCooldownMultiplier or 1
		self.ChargeDuration = self.DefaultChargeDuration + self.dt.AdditiveChargeDuration
	end
	
	self.dt.Ready = false
	self.dt.Charging = true
	self.dt.NextEndCharge = CurTime() + self.ChargeDuration
	self.SpeedBonus = 1.89
	self:GetOwner():ResetClassSpeed()
	self:GetOwner():SetJumpPower(0)
	
	net.Start("ActivateTauntCam")
	net.Send(self:GetOwner())
	self:GetOwner():SetNWBool("Taunting", true)
	self:GetOwner():DoAnimationEvent("Charger_charge")
	timer.Create("ChargingChargerAnimLoop"..self:GetOwner():EntIndex(), self:GetOwner():SequenceDuration(self:GetOwner():LookupSequence("Charger_Charge") ), 0, function()
		self:GetOwner():DoAnimationEvent("Charger_charge")
	end)
	if not self.ChargeSoundEnt then
		self.ChargeSoundEnt = CreateSound(self:GetOwner(), "ChargerZombie.Charge")
	end
	
	if self.ChargeSoundEnt then
		self.ChargeSoundEnt:Play()
	end
end

function ENT:StopCharging()
	self.ChargeDuration = nil
	self.dt.Ready = false
	self.dt.Charging = false
	self.dt.NextEndCharge = CurTime() + self.ChargeCooldownDuration * self.dt.ChargeCooldownMultiplier
	self.SpeedBonus = nil
	self:GetOwner():ResetClassSpeed()
	self:GetOwner():SetJumpPower(250)
	timer.Stop("ChargingChargerAnimLoop"..self:GetOwner():EntIndex())
	if self.ChargeSoundEnt then
		self.ChargeSoundEnt:Stop()
		self.ChargeSoundEnt = nil
	end
	
	if self.ChargeState then
		if self.ChargeState == 2 then
			if self.CritStartSoundEnt then
				self.CritStartSoundEnt:Stop()
				self.CritStartSoundEnt = nil
				self:GetOwner():EmitSound(self.CritStopSound)
			end
		end
		
		self.NextEndCritBoost = CurTime() + 0.4
	end
end

function ENT:OnMeleeSwing()
	if self.dt.Charging then
	end
end

function ENT:Think()
	if not IsValid(self:GetOwner()) then return end
	
	if self.dt.Charging then
		local vel = self:GetOwner():GetVelocity():LengthSqr()
		
		if self:GetOwner():Crouching() then
			self:GetOwner():ConCommand("-duck")
		end
		
		if not self.MaxSpeed or vel > self.MaxSpeed then
			self.MaxSpeed = vel
		end
		
		local cap = self.MaxSpeed * 0.8 * 0.8
		
		if vel < cap then
			--print("below minimum speed, performing trace check")
			self:MeleeAttack()
			if not self.dt.Charging then
				return
			end
		end
		
		if CurTime() > self.dt.NextEndCharge then
			timer.Simple(0.8, function()
				self:GetOwner():SetNWBool("Taunting", false)
				net.Start("DeActivateTauntCam")
				net.Send(self:GetOwner())
			end)
			self:StopCharging()
			return
		end
		
		local p = (self.dt.NextEndCharge - CurTime()) / self.ChargeDuration
		local p0 = p * (self.DefaultChargeDuration / self.ChargeDuration)
		
		if p0 < 0.33 and self.ChargeState == 1 then
			GAMEMODE:StartCritBoost(self:GetOwner())
			self.ChargeState = 2
			
			if not self.CritStartSoundEnt then
				self.CritStartSoundEnt = CreateSound(self, self.CritStartSound)
			end
			if self.CritStartSoundEnt then
				self.CritStartSoundEnt:Play()
			end
		elseif p0 < 0.66 and not self.ChargeState then
			GAMEMODE:StartCritBoost(self:GetOwner())
			self.ChargeState = 1
		end
	elseif not self.dt.Ready then
		if CurTime() > self.dt.NextEndCharge then
			self.dt.Ready = true
			umsg.Start("PlayChargeReadySound", self:GetOwner())
			umsg.End()
		end
		
		self.MaxSpeed = nil
		self.ChargeState = nil
	end
	
	if self.NextEndCritBoost and CurTime() > self.NextEndCritBoost then
		GAMEMODE:StopCritBoost(self:GetOwner())
		self.NextEndCritBoost = nil
	end
	
	if (self:GetOwner():KeyDown(IN_ATTACK) and !self:GetOwner():IsBot()) or (self:GetOwner():KeyDown(IN_ATTACK2) and self:GetOwner():IsBot()) and self.dt.Ready then
		if self:GetOwner():OnGround() then
			if self:GetOwner():Crouching() then
				self:GetOwner():ConCommand("-duck")
			end
			self:StartCharging()
		end
	end
	
	self:NextThink(CurTime())
	return true
end

end

hook.Add("Move", "TargeChargeMove", function(pl, move)
	local t = pl.TargeEntity
	if IsValid(t) and t.dt and t.dt.Charging then
		move:SetForwardSpeed(pl:GetRealClassSpeed())
		move:SetSideSpeed(0)
	end
end)
