
local tf_targe_enhanced_charge = CreateConVar("tf_targe_enhanced_charge", 1, {FCVAR_CHEAT})

ENT.Type 			= "anim"
ENT.Base 			= "tf_wearable_item"

ENT.MeleeRange = 0

ENT.ForceMultiplier = 10000
ENT.CritForceMultiplier = 10000
ENT.ForceAddPitch = 20
ENT.CritForceAddPitch = 0

ENT.DefaultBaseDamage = 50
ENT.DamagePerHead = 10
--ENT.MaxHeads = 5

ENT.BaseDamage = 0
ENT.DamageRandomize = 0.1
ENT.MaxDamageRampUp = 0
ENT.MaxDamageFalloff = 0

ENT.HitPlayerSound = Sound("")
ENT.HitPlayerRangeSound = Sound("")
ENT.HitWorldSound = Sound("")

ENT.CritStartSound = Sound("")
ENT.CritStopSound = Sound("")

ENT.DefaultChargeDuration = 0
ENT.ChargeCooldownDuration = 0

ENT.ChargeSteerConstraint = 9999

function ENT:SetupDataTables()
	self.BaseClass.SetupDataTables(self)
	self:DTVar("Bool", 0, "Charging")
	self:DTVar("Bool", 1, "Ready")
	self:DTVar("Float", 0, "NextEndCharge")
	self:DTVar("Float", 1, "AdditiveChargeDuration")
	self:DTVar("Float", 2, "ChargeCooldownMultiplier")
end

if CLIENT then

function ENT:InitializeCModel(weapon)
	local vm = self:GetOwner():GetViewModel()
	
	if IsValid(vm) then
		self.CModel = ClientsideModel(self.Model)
		if not IsValid(self.CModel) then return end
		
		self.CModel:SetPos(vm:GetPos())
		self.CModel:SetAngles(vm:GetAngles())
		self.CModel:AddEffects(EF_BONEMERGE)
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
			return nil
		end
	end
end

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

function ENT:MeleeAttack()
	if not IsValid(self:GetOwner()) then return end
	
	local pos = self:GetOwner():GetShootPos()
	local ang = self:GetOwner():EyeAngles()
	ang.p = 0
	local endpos = pos + ang:Forward() * self.MeleeRange
	
	local hitent, hitpos, dmginfo
	
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
		local dir = ang:Forward()
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
			--print("charge hit", tr.Entity, tr.Entity:Health(), tr.Entity:GetMaxHealth(), self:CanChargeThrough(tr.Entity))
			if self:CanChargeThrough(tr.Entity) then
				return
			--[[elseif tr.Entity:GetClass() == "prop_door_rotating" then
				local p = ents.Create("prop_physics")
				p:SetModel(tr.Entity:GetModel())
				p:SetBodygroup(1, 1)
				p:SetSkin(tr.Entity:GetSkin())
				p:SetPos(tr.Entity:GetPos())
				p:SetAngles(tr.Entity:GetAngles())
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
				p:SetModel(door:GetModel())
				p:SetSkin(door:GetSkin())
				p:SetPos(door:GetPos())
				p:SetAngles(door:GetAngles())
				door:Remove()
				p:Spawn()
				
				p:DispatchTraceAttack(dmginfo, hitpos, hitpos + 5*dir)
				
				local phys = p:GetPhysicsObject()
				if phys and phys:IsValid(self.WModel2) then
					p:SetPhysicsAttacker(self:GetOwner())
				end
				
				return]]
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
		return nil
	end
	
	if not self.ChargeSoundEnt then
		return nil
	end
	
	if self.ChargeSoundEnt then
		return nil
	end
end

function ENT:StopCharging()
	
	if self.ChargeSoundEnt then
		return nil
	end
	
	if self.ChargeState then
		return nil
	end
end

function ENT:OnMeleeSwing()
	if self.dt.Charging then
		self:StopCharging()
	end
end

function ENT:Think()
	if not IsValid(self:GetOwner()) then return end
	
	if self.dt.Charging then
		return nil
	end
	
	if self.NextEndCritBoost and CurTime() > self.NextEndCritBoost then
		return nil
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
