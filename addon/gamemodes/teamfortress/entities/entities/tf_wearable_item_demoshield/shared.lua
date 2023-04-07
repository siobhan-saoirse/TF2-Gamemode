
local tf_targe_enhanced_charge = CreateConVar("tf_targe_enhanced_charge", 1, {FCVAR_CHEAT})

ENT.Type 			= "anim"
ENT.Base 			= "tf_wearable_item"

ENT.MeleeRange = 50

ENT.ForceMultiplier = 10000
ENT.CritForceMultiplier = 10000
ENT.ForceAddPitch = 0
ENT.CritForceAddPitch = 0

ENT.DefaultBaseDamage = 50
ENT.DamagePerHead = 10
--ENT.MaxHeads = 5

ENT.BaseDamage = 50
ENT.DamageRandomize = 0.1
ENT.MaxDamageRampUp = 0
ENT.MaxDamageFalloff = 0

ENT.HitPlayerSound = Sound("DemoCharge.HitFlesh")
ENT.HitPlayerRangeSound = Sound("DemoCharge.HitFleshRange")
ENT.HitWorldSound = Sound("DemoCharge.HitWorld")

ENT.CritStartSound = Sound("DemoCharge.ChargeCritOn")
ENT.CritStopSound = Sound("DemoCharge.ChargeCritOff")

ENT.DefaultChargeDuration = 1.5
ENT.ChargeCooldownDuration = 12

ENT.ChargeSteerConstraint = 0.7

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
		self.CModelself.WModel2:SetNoDraw(true)
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
		if string.find(cmd, "+duck") then
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
			
			ang.y = oldyaw + math.Clamp(math.AngleDifference(ang.y, oldyaw), -t.ChargeSteerConstraint, t.ChargeSteerConstraint)
			cmd:SetViewAngles(ang)
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
		
		if self:GetOwner():CanDamage(tr.Entity) then
			local pitch, mul, dmgtype
			
			dmgtype = DMG_SLASH
			pitch, mul = self.ForceAddPitch, self.ForceMultiplier
			
			ang.p = math.Clamp(math.NormalizeAngle(ang.p - pitch), -90, 90)
			local force_dir = ang:Forward()
			
			--self.BaseDamage = self.DefaultBaseDamage + self.DamagePerHead * math.min(self:GetOwner():GetNWInt("Heads"), self.MaxHeads)
			self.BaseDamage = self.DefaultBaseDamage + self.DamagePerHead * self:GetOwner():GetNWInt("Heads")
			
			local dmg = tf_util.CalculateDamage(self, hitpos)
			
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
		end
		
		if tr.Entity:IsTFPlayer() and not tr.Entity:IsBuilding() then
			if self.ChargeState == 2 and (not self.NextRangeSound or CurTime() > self.NextRangeSound) then
				sound.Play(self.HitPlayerRangeSound, self:GetOwner():GetPos())
				self.NextRangeSound = CurTime() + 1
			else
				sound.Play(self.HitPlayerSound, self:GetOwner():GetPos())
			end
		else
			sound.Play(self.HitWorldSound, self:GetOwner():GetPos())
		end
	elseif tr.HitWorld then
		sound.Play(self.HitWorldSound, self:GetOwner():GetPos())
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
				local p = ents.Create("prop_physics")
				p:SetModel(tr.Entity:GetModel())
				p:SetBodygroup(1, 1)
				p:SetSkin(tr.Entity:GetSkin())
				p:SetPos(tr.Entity:GetPos())
				p:SetAngles(tr.Entity:GetAngles())
				
				OpenLinkedAreaPortal(tr.Entity)
				tr.Entity:Remove()
				p:Spawn()
				
				p:DispatchTraceAttack(dmginfo, hitpos, hitpos + 5*dir)
				
				local phys = p:GetPhysicsObject()
				if phys and phys:IsValid(self.WModel2) then
					p:SetPhysicsAttacker(self:GetOwner())
				end
				
				return
			elseif tr.Entity:GetClass() == "prop_dynamic" and IsValid(tr.Entity:GetParent())
			and tr.Entity:GetParent():GetClass()=="func_door_rotating" then
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
	
	self:StopCharging()
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
	self.SpeedBonus = 2.69
	self:GetOwner():ResetClassSpeed()
	self:GetOwner():SetJumpPower(0)
	

	ParticleEffectAttach( 'warp_version', PATTACH_ABSORIGIN_FOLLOW, self:GetOwner(), 0)
	ParticleEffectAttach( 'scout_dodge_socks', PATTACH_POINT_FOLLOW, self:GetOwner(), 0 )
	ParticleEffectAttach( 'scout_dodge_pants', PATTACH_POINT_FOLLOW, self:GetOwner(), 0 )
	if self:GetOwner():Team() == TEAM_BLU then
		ParticleEffectAttach( 'scout_dodge_blue', PATTACH_POINT_FOLLOW, self:GetOwner(), 3 )
	elseif self:GetOwner():Team() == TF_TEAM_PVE_INVADERS then
		ParticleEffectAttach( 'scout_dodge_blue', PATTACH_POINT_FOLLOW, self:GetOwner(), 3 )
	else
		ParticleEffectAttach( 'scout_dodge_red', PATTACH_POINT_FOLLOW, self:GetOwner(), 3 )
	end
	if not self.ChargeSoundEnt then
		self.ChargeSoundEnt = CreateSound(self:GetOwner(), "DemoCharge.Charging")
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
	
	self:GetOwner():EmitSound(self.CritStopSound)
	self:GetOwner():StopParticles()
	
	if self.ChargeSoundEnt then
		self.ChargeSoundEnt = nil
	end
	
	if self.ChargeState then
		if self.ChargeState == 2 then
			if self.CritStartSoundEnt then
				self.CritStartSoundEnt:Stop()
				self.CritStartSoundEnt = nil
			end
		end
		
		self.NextEndCritBoost = CurTime() + 0.4
	end
end

function ENT:OnMeleeSwing()
	if self.dt.Charging then
		if (self:GetOwner():GetPlayerClass() != "samuraidemo") then
			self:StopCharging()
		end
	end
end

function ENT:Think()
	if not IsValid(self:GetOwner()) then return end
	
	if CLIENT then
		if (self:GetItemData().image_inventory and self:GetItemData().item_iconname) then
			killicon.Add( self:GetItemData().item_iconname, self:GetItemData().image_inventory, Color( 255, 255, 255, 255 ) )
		elseif (self:GetItemData().image_inventory) then
			killicon.Add( string.Replace(self:GetClass(),"tf_weapon_",""), self:GetItemData().image_inventory, Color( 255, 255, 255, 255 ) )
		end
	end
	self:GetOwner().IsCharging = self.dt.Charging
	if self.dt.Charging then
		local vel = self:GetOwner():GetVelocity():LengthSqr()
		
		if self:GetOwner():Crouching() then
			self:GetOwner():ConCommand("-duck")
		end
		if !self:GetOwner():OnGround() then
		self:GetOwner():SetVelocity(self:GetOwner():GetAimVector() * 50)
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
			self:StopCharging()
			return
		end
		
		local p = (self.dt.NextEndCharge - CurTime()) / self.ChargeDuration
		local p0 = p * (self.DefaultChargeDuration / self.ChargeDuration)
		
		if p0 < 0.33 and self.ChargeState == 1 then
			GAMEMODE:StartCritBoost(self:GetOwner(), "melee")
			self.ChargeState = 2
			
			if not self.CritStartSoundEnt then
				self.CritStartSoundEnt = CreateSound(self, self.CritStartSound)
			end
			if self.CritStartSoundEnt then
				self.CritStartSoundEnt:Play()
			end
		elseif p0 < 0.66 and not self.ChargeState then
			GAMEMODE:StartCritBoost(self:GetOwner(), "melee")
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
	
	if self:GetOwner():KeyDown(IN_ATTACK2) and self.dt.Ready then
			if self:GetOwner():Crouching() then
				self:GetOwner():ConCommand("-duck")
			end
			self:StartCharging()
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

hook.Add("SetupMove", "TargeChargeSetupMove", function(pl, move)
	local t = pl.TargeEntity
	if IsValid(t) and t.dt and t.dt.Charging then
		-- This is already done clientside by CreateMove
		if SERVER then
			local ang = pl:EyeAngles()
			if pl.SavedTargeAngle then
				local oldyaw = pl.SavedTargeAngle.y
				
				ang.y = oldyaw + math.Clamp(math.AngleDifference(ang.y, oldyaw), -t.ChargeSteerConstraint, t.ChargeSteerConstraint)
				pl:SetEyeAngles(ang)
			end
			pl.SavedTargeAngle = ang
		end
		
		move:SetSideSpeed(0)
	else
		pl.SavedTargeAngle = nil
	end
end)
