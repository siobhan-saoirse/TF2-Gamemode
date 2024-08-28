if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Melee"
end

SWEP.Base				= "tf_weapon_base"

SWEP.ViewModel			= "models/weapons/v_models/v_bat_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_bat.mdl"

SWEP.Primary.Ammo			= "none"

SWEP.HoldType = "MELEE"

SWEP.Swing = Sound("")
SWEP.SwingCrit = Sound("")
SWEP.HitFlesh = Sound("")
SWEP.HitWorld = Sound("")

SWEP.MeleeAttackDelay = 0.25
--SWEP.MeleeAttackDelayCritical = 0.25
SWEP.MeleeRange = 50

SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.CriticalChance = 15
SWEP.HasThirdpersonCritAnimation = false
SWEP.NoHitSound = false

SWEP.ForceMultiplier = 5000
SWEP.CritForceMultiplier = 10000
SWEP.ForceAddPitch = 0
SWEP.CritForceAddPitch = 0

SWEP.DamageType = DMG_CLUB
SWEP.CritDamageType = DMG_CLUB

SWEP.MeleePredictTolerancy = 0.5

SWEP.HasCustomMeleeBehaviour = false

SWEP.VM_HITCENTER = ACT_VM_HITCENTER
SWEP.VM_SWINGHARD = ACT_VM_SWINGHARD

SWEP.HullAttackVector = Vector(10, 10, 15)

function SWEP:InspectAnimCheck()

end

local FleshMaterials = {
	[MAT_ANTLION] = true,
	[MAT_BLOODYFLESH] = true,
	[MAT_FLESH] = true,
	[MAT_ALIENFLESH] = true,
}

function SWEP:GetPrimaryFireActivity()
	if self.UsesLeftRightAnim then
		return self.VM_HITLEFT
	else
		return self.VM_HITCENTER
	end
end

function SWEP:GetSecondaryFireActivity()
	if self.UsesLeftRightAnim then
		return self.VM_HITRIGHT
	else
		return ACT_INVALID
	end
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:OnMeleeAttack(tr)
	
end

function SWEP:OnMeleeHit(tr)
	
end

function SWEP:MeleeHitSound(tr)
	--MsgFN("MeleeHitSound %f", CurTime())
	if CLIENT then
		return
	end
	
	if tr.Entity and IsValid(tr.Entity) then
		if tr.Entity:IsTFPlayer() then
			if tr.Entity:IsBuilding() then
				--self:EmitSound(self.HitWorld)
				--sound.Play(self.HitWorld, tr.HitPos)
				sound.Play(self.HitWorld, self:GetPos())
			else
				--self:EmitSound(self.HitFlesh)
				--sound.Play(self.HitFlesh, tr.HitPos)
				sound.Play(self.HitFlesh, self:GetPos())
			end
		else
			if not self.NoHitSound then
				if FleshMaterials[tr.Entity:GetMaterialType()] then
					--self:EmitSound(self.HitFlesh)
					--sound.Play(self.HitFlesh, tr.HitPos)
					sound.Play(self.HitFlesh, self:GetPos())
				else
					--self:EmitSound(self.HitWorld)
					--sound.Play(self.HitWorld, tr.HitPos)
					sound.Play(self.HitWorld, self:GetPos())
				end
			end
		end
	else
		if not self.NoHitSound then
			--self:EmitSound(self.HitWorld)
			--sound.Play(self.HitWorld, tr.HitPos)
			sound.Play(self.HitWorld, self:GetPos())
		end
	end
end

function SWEP:MeleeCritical(tr)
	local b = gamemode.Call("ShouldCrit", tr.Entity, self, self.Owner)
	
	if b ~= nil and b ~= self.CurrentShotIsCrit then
		self.CurrentShotIsCrit = b
		self.CritTime = CurTime()
		return b
	end
end

function SWEP:MeleeAttack(dummy)
	local pos = self.Owner:GetShootPos()
	local ang = self.Owner:GetAimVector()
	local endpos
	
	if SERVER and not dummy and game.SinglePlayer() then
		self:CallOnClient("MeleeAttack","")
	end
	
	if CLIENT and dummy=="" then
		dummy = false
	end
	
	local scanmul = 1 + self.MeleePredictTolerancy
	
	if dummy then
		-- When doing a dummy melee attack, perform a wider scan for better prediction
		endpos = pos + self.Owner:GetAimVector() * self.MeleeRange * scanmul
	else
		endpos = pos + self.Owner:GetAimVector() * self.MeleeRange
	end
	
	local hitent, hitpos
	
	if not dummy then
		self.Owner:LagCompensation(true)
	end
	
	local tr = util.TraceLine {
		start = pos,
		endpos = endpos,
		filter = self.Owner
	}
	
	if not tr.Hit then
		local mins, maxs
		local v = self.HullAttackVector
		if dummy then
			mins, maxs = scanmul * Vector(-v.x, -v.y, -v.z), scanmul * Vector(v.x, v.y, v.z)
		else
			mins, maxs = Vector(-v.x, -v.y, -v.z), Vector(v.x, v.y, v.z)
		end
		
		tr = util.TraceHull {
			start = pos,
			endpos = endpos,
			filter = self.Owner,
		
			mins = mins,
			maxs = maxs,
		}
	end
	
	if not dummy then
		self.Owner:LagCompensation(false)
	end
	
	--MsgN(Format("HELLO %s",tostring(dummy)))
	if dummy then return tr end
	
	self:OnMeleeAttack(tr)
	
	local damagedself = false
	if self.MeleeHitSelfOnMiss and not tr.HitWorld and not IsValid(tr.Entity) then
		damagedself = true
		tr.Entity = self.Owner
	end
	
	if tr.Entity and tr.Entity:IsValid() then
		--local ang = (endpos - pos):GetNormal():Angle()
		local ang = self.Owner:EyeAngles()
		local dir = ang:Forward()
		hitpos = tr.Entity:NearestPoint(self.Owner:GetShootPos()) - 2 * dir
		tr.HitPos = hitpos
		
		if self.Owner:CanDamage(tr.Entity) then
			if SERVER then
				local mcrit = self:MeleeCritical(tr)
				
				local pitch, mul, dmgtype
				if self.CurrentShotIsCrit then
					dmgtype = self.CritDamageType
					pitch, mul = self.CritForceAddPitch, self.CritForceMultiplier
				else
					dmgtype = self.DamageType
					pitch, mul = self.ForceAddPitch, self.ForceMultiplier
				end
				
				if tr.Entity:ShouldReceiveDefaultMeleeType() then
					dmgtype = DMG_CLUB
				end
				
				ang.p = math.Clamp(math.NormalizeAngle(ang.p - pitch), -90, 90)
				local force_dir = ang:Forward()
				
				self:PreCalculateDamage(tr.Entity)
				local dmg = self:CalculateDamage(nil, tr.Entity)
				--dmg = self:PostCalculateDamage(dmg, tr.Entity)
				
				local dmginfo = DamageInfo()
					dmginfo:SetAttacker(self.Owner)
					dmginfo:SetInflictor(self)
					dmginfo:SetDamage(dmg)
					dmginfo:SetDamageType(dmgtype)
					dmginfo:SetDamagePosition(hitpos)
					dmginfo:SetDamageForce(dmg * force_dir * mul)
				if damagedself then
					force_dir.x = -force_dir.x
					force_dir.y = -force_dir.y
					dmginfo:SetDamageForce(dmg * force_dir * (mul * 0.5))
					tr.Entity:DispatchBloodEffect()
					tr.Entity:TakeDamageInfo(dmginfo)
				else
					tr.Entity:DispatchTraceAttack(dmginfo, hitpos, hitpos + 5*dir)
				end
				
				local phys = tr.Entity:GetPhysicsObject()
				if phys and phys:IsValid() then
					tr.Entity:SetPhysicsAttacker(self.Owner)
				end
			elseif CLIENT then
				-- Fire a bullet clientside, just for decals and blood effects
				if util.TraceLine({start=hitpos,endpos=hitpos+4*dir}).Entity == tr.Entity then
					self:FireBullets{
						Src=hitpos,
						Dir=dir,
						Spread=Vector(0,0,0),
						Num=1,
						Damage=1,
						Tracer=0,
					}
				end
			end
		end
		
		self:MeleeHitSound(tr)
		self:OnMeleeHit(tr)
	elseif tr.HitWorld then
		local range = self.MeleeRange + 18
		local dir = self.Owner:GetAimVector()
		
		if not util.TraceLine({start=pos,endpos=pos+range*dir}).Hit then
			local ang = self.Owner:EyeAngles()
			ang.y = ang.y + 25
			local dir1 = ang:Forward()
			ang.y = ang.y - 50
			local dir2 = ang:Forward()
			
			local tr1 = util.TraceLine({start=pos,endpos=pos+range*dir1})
			local tr2 = util.TraceLine({start=pos,endpos=pos+range*dir2})
			
			if not tr1.Hit and not tr2.Hit then
				dir = nil
			elseif tr1.Fraction > tr2.Fraction then
				dir = dir2
				tr.HitPos = tr2.HitPos
			else
				dir = dir1
				tr.HitPos = tr1.HitPos
			end
		end
		
		if CLIENT then
			if dir then
				self:FireBullets{
					Src=pos,
					Dir=dir,
					Spread=Vector(0,0,0),
					Num=1,
					Damage=1,
					Tracer=0,
				}
			end
		end
		
		self:MeleeHitSound(tr)
		self:OnMeleeHit(tr)
	end
end

--[[
usermessage.Hook("DoMeleeSwing", function(msg)
	local wp = msg:ReadEntity()
	local crit = msg:ReadBool()
	
	if crit then
		wp:EmitSound(wp.SwingCrit, 100, 100)
	else
		wp:EmitSound(wp.Swing, 100, 100)
	end
end)]]

function SWEP:PrimaryAttack()
	if not self:CallBaseFunction("PrimaryAttack") then return false end
	
	if self.HasCustomMeleeBehaviour then return true end
	
	if SERVER and IsValid(self.Owner.TargeEntity) then
		self.Owner.TargeEntity:OnMeleeSwing()
	end
	
	if self:CriticalEffect() then
		--MsgN(Format("[%f] From SWEP:PrimaryAttack (%s) : Critical hit!", CurTime(), tostring(self)))
		self:EmitSound(self.SwingCrit, 100, 100)
		--[[if SERVER then
			self:EmitSound(self.SwingCrit, 100, 100)
			umsg.Start("DoMeleeSwing",self.Owner)
				umsg.Entity(self)
				umsg.Bool(true)
			umsg.End()
		end]]
		self:SendWeaponAnimEx(self.VM_SWINGHARD)
		if self.HasThirdpersonCritAnimation then
			self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_SECONDARYFIRE, true)
		else
			self.Owner:SetAnimation(PLAYER_ATTACK1)
		end
	else
		self:EmitSound(self.Swing, 100, 100)
		--[[if SERVER then
			self:EmitSound(self.Swing, 100, 100)
			umsg.Start("DoMeleeSwing",self.Owner)
				umsg.Entity(self)
				umsg.Bool(false)
			umsg.End()
		end]]
		
		if self.UsesLeftRightAnim then
			self:SendWeaponAnim(self.VM_HITLEFT)
		else
			self:SendWeaponAnim(self.VM_HITCENTER)
		end
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
	
	self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
	
	--self.NextMeleeAttack = CurTime() + self.MeleeAttackDelay
	if not self.NextMeleeAttack then
		self.NextMeleeAttack = {}
	end
	
	self:StopTimers()
	
	table.insert(self.NextMeleeAttack, CurTime() + self.MeleeAttackDelay)
	return true
end

function SWEP:SecondaryAttack()
	if not self:CallBaseFunction("Attack") then return false end
	
	if self.HasCustomMeleeBehaviour then return true end
	
	if self:CriticalEffect() then
		self:EmitSound(self.SwingCrit, 100, 100)
		--[[if SERVER then
			self:EmitSound(self.SwingCrit, 100, 100)
			umsg.Start("DoMeleeSwing",self.Owner)
				umsg.Entity(self)
				umsg.Bool(true)
			umsg.End()
		end]]
		self:SendWeaponAnimEx(self.VM_SWINGHARD)
		if self.HasThirdpersonCritAnimation then
			self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_SECONDARYFIRE, true)
		else
			self.Owner:SetAnimation(PLAYER_ATTACK1)
		end
	else
		self:EmitSound(self.Swing, 100, 100)
		--[[if SERVER then
			self:EmitSound(self.Swing, 100, 100)
			umsg.Start("DoMeleeSwing",self.Owner)
				umsg.Entity(self)
				umsg.Bool(false)
			umsg.End()
		end]]
		
		self:SendWeaponAnim(self.VM_HITRIGHT)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
	
	--self.NextMeleeAttack = CurTime() + self.MeleeAttackDelay
	if not self.NextMeleeAttack then
		self.NextMeleeAttack = {}
	end
	
	table.insert(self.NextMeleeAttack, CurTime() + self.MeleeAttackDelay)
end

function SWEP:ShootProjectile(num_bullets, aimcone)
	self:StopTimers()
	--local b = force_bullets_lagcomp:GetBool()
	
	--if b then
		self.Owner:LagCompensation(true)
	--end
	
	self:FireTFBullets{
		Num = num_bullets,
		Src = self.Owner:GetShootPos(),
		--Src = self:ShootPos(),
		Dir = self.Owner:GetAimVector(),
		Spread = Vector(aimcone, aimcone, 0),
		Attacker = self.Owner,
		
		Team = GAMEMODE:EntityTeam(self.Owner),
		Damage = self.BaseDamage,
		RampUp = self.MaxDamageRampUp,
		Falloff = self.MaxDamageFalloff,
		Critical = self:Critical(),
		CritMultiplier = self.CritDamageMultiplier,
		DamageModifier = self.DamageModifier,
		DamageRandomize = self.DamageRandomize,
		
		Tracer = 1,
		TracerName = self.TracerEffect,
		Force = 1,
	}
	
	--if b then
		self.Owner:LagCompensation(false)
	--end
	
	self:ShootEffects()
end


function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:ShootEffects()
end

function SWEP:Deploy()
	self:StopTimers()
	
	return self:CallBaseFunction("Deploy")
end

function SWEP:OnRemove()
	self:StopTimers()
	
	return self:CallBaseFunction("OnRemove")
end

function SWEP:Think()
	self:CallBaseFunction("Think")
	
	--if self.NextMeleeAttack and CurTime()>=self.NextMeleeAttack then
	
	while self.NextMeleeAttack and self.NextMeleeAttack[1] and CurTime() > self.NextMeleeAttack[1] do
		self:MeleeAttack()
		table.remove(self.NextMeleeAttack, 1)
		
		self:RollCritical()
	end
end

function SWEP:Holster()
	self.NextMeleeAttack = nil
	
	self:StopTimers()
	
	return self:CallBaseFunction("Holster")
end