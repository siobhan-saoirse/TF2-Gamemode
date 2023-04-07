AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

include("shared.lua")

local tf_minisentry_allow_upgrade = CreateConVar("tf_minisentry_allow_upgrade", "0", {FCVAR_CHEAT})

ENT.NumLevels = 3
ENT.Levels = {
{Model("models/buildables/sentry1_heavy.mdl"), Model("models/buildables/sentry1.mdl")},
{Model("models/buildables/sentry2_heavy.mdl"), Model("models/buildables/sentry2.mdl")},
{Model("models/buildables/sentry3_heavy.mdl"), Model("models/buildables/sentry3.mdl")},
}
ENT.IdleSequence = "idle_off"
ENT.DisableDuringUpgrade = true
ENT.NoUpgradedModel = false

ENT.Sound_Idle = Sound("Building_Sentrygun.Idle")
ENT.Sound_Idle2 = Sound("Building_Sentrygun.Idle2")
ENT.Sound_Idle3 = Sound("Building_Sentrygun.Idle3")
ENT.Sound_Alert = Sound("Building_Sentrygun.Alert") 

ENT.Sound_Fire = Sound("Building_Sentrygun.Fire") 
ENT.Sound_Fire2 = Sound("Building_Sentrygun.Fire2") 
ENT.Sound_Fire3 = Sound("Building_Sentrygun.Fire3")
ENT.Sound_FireMini = Sound("Building_MiniSentrygun.Fire")

ENT.Sound_Empty = Sound("Building_Sentrygun.Empty")

ENT.RocketShoot_Sound = Sound("Building_Sentrygun.FireRocket")

ENT.Sound_DoneBuilding = Sound("Building_Sentrygun.Built")

ENT.MaxAmmo1 = 100
ENT.MaxAmmo2 = 0

ENT.Wrangled = false
ENT.Sapped = false
ENT.IsDoneBuilding = false

local SentryGibs1 = {
Model("models/buildables/Gibs/sentry1_Gib1.mdl"),
Model("models/buildables/Gibs/sentry1_Gib2.mdl"),
Model("models/buildables/Gibs/sentry1_Gib3.mdl"),
Model("models/buildables/Gibs/sentry1_Gib4.mdl"),
}

local SentryGibs2 = {
Model("models/buildables/Gibs/sentry2_Gib1.mdl"),
Model("models/buildables/Gibs/sentry2_Gib2.mdl"),
Model("models/buildables/Gibs/sentry2_Gib3.mdl"),
Model("models/buildables/Gibs/sentry2_Gib4.mdl"),
}

local SentryGibs3 = {
Model("models/buildables/Gibs/sentry3_Gib1.mdl"),
Model("models/buildables/Gibs/sentry2_Gib2.mdl"),
Model("models/buildables/Gibs/sentry2_Gib3.mdl"),
Model("models/buildables/Gibs/sentry2_Gib4.mdl"),
}

ENT.Gibs = SentryGibs1
ENT.Sound_Explode = Sound("Building_Sentry.Explode")

ENT.TracerEffect = "bullet_tracer01"

ENT.BaseDamage = 16
ENT.DamageRandomize = 0.125
ENT.MaxDamageRampUp = 0
ENT.MaxDamageFalloff = 0
ENT.CritDamageMultiplier = 3

ENT.OriginZOffset = 40

function ENT:SpawnFunction(pl, tr)
	if not tr.Hit then return end
	
	local pos = tr.HitPos
	
	local ent = ents.Create(self.ClassName)
	ent:SetPos(pos)
	ent:Spawn()
	ent:Activate()
	
	ent:SetPos(pos - Vector(0,0,ent:OBBMins().z))
	
	ent:SetTeam(pl:Team())
	ent:SetBuilder(pl)
	
	return ent
end


local function sign(n)
	if n<0 then return -1
	elseif n>0 then return 1
	end
	return 0
end

local function angnorm(n)
	while n<=-180 do n=n+360 end
	while n>180 do n=n-360 end
	return n
end

local function dangnorm(a,b)
	a,b=angnorm(a),angnorm(b)
	local r = a-b
	
	if r<0 then
		local d = r+360
		if d<-r then return d
		else return r end
	else
		local d = r-360
		if d>-r then return d
		else return r end
	end
end

-- Target position retrieving methods

-- default
local function targetpos_default(t)
	return t:BodyTarget(t:GetPos())
end

-- from TF2 bone
local function targetpos_tf2(t)
	local bone = t:LookupBone("bip_spine_2")
	if bone then return t:GetBonePosition(bone) end
end

-- from HL2 bone
local function targetpos_hl2(t)
	local bone = t:LookupBone("ValveBiped.Bip01_Spine2")
	if bone then return t:GetBonePosition(bone) end
end

-- from bounding box
local function targetpos_bb(t)
	return t:LocalToWorld(t:OBBCenter())
end

local targetmethods = {targetpos_default, targetpos_tf2, targetpos_hl2, targetpos_bb}
local targetmethodnames = {
	"bodytarget",
	"tf2 spine",
	"hl2 spine",
	"bounding box",
}
local CURRENT_SELF

local function targetTraceCallback(res)
	local e = res.Entity
	if IsValid(e) and CURRENT_SELF:IsFriendly(e) then
		-- trace through teammates
		--MsgFN("Ignored entity %s", tostring(e))
		return false
	end
	
	return true
end

function ENT:Initialize()
	self.BaseClass.Initialize(self)
	self.TurretPitch = 0
	self.VisualTurretPitch = 0
	self.TurretYaw = 0
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
end

-- Find the most suitable target position retrieving method for a given entity
-- (returns nil if the entity cannot be reached)
function ENT:GetTargetMethod(ent, strict, dbg)
	--local startpos = self:ShootPos()
	local startpos = self:TargetOrigin()
	
	if dbg then MsgN(tostring(ent)) end
	for i,method in ipairs(targetmethods) do
		if dbg then MsgF("  Trying %s method... ", targetmethodnames[i]) end
		local pos = method(ent)
		if pos then
			CURRENT_SELF = self
			--local tr = util.TraceLine({start=startpos, endpos=pos, filter=self})
			local tr = tf_util.TraceLineWithCallback({start=startpos, endpos=pos, filter=self, callback=targetTraceCallback, mask=MASK_SHOT})
			CURRENT_SELF = nil
			if tr.Entity == ent or (not strict and tr.StartSolid) then
				if dbg then Msg("OK!\n") end
				return method
			else
				if dbg then MsgF("Failure! (entity hit: %s)\n", tostring(tr.Entity)) end
			end
		else
			if dbg then Msg("Failure! (no position found)\n") end
		end
	end
end

function ENT:SetAmmo1(a)
	self.Ammo1 = a
	self:SetAmmo1Percentage(self.Ammo1 / self.MaxAmmo1)
end

function ENT:AddAmmo1(a)
	self.Ammo1 = self.Ammo1 + a
	self:SetAmmo1Percentage(self.Ammo1 / self.MaxAmmo1)
end

function ENT:TakeAmmo1(a)
	if self.Ammo1 >= a then
		self.Ammo1 = self.Ammo1 - a
		self:SetAmmo1Percentage(self.Ammo1 / self.MaxAmmo1)
		return true
	end
	return false
end

function ENT:SetAmmo2(a)
	self.Ammo2 = a
	self:SetAmmo2Percentage(self.Ammo2 / self.MaxAmmo2)
end

function ENT:AddAmmo2(a)
	self.Ammo2 = self.Ammo2 + a
	self:SetAmmo2Percentage(self.Ammo2 / self.MaxAmmo2)
end

function ENT:TakeAmmo2(a)
	if self.Ammo2 >= a then
		self.Ammo2 = self.Ammo2 - a
		self:SetAmmo2Percentage(self.Ammo2 / self.MaxAmmo2)
		return true
	end
	return false
end

function ENT:CalculateDamage(hitpos, ent)
	return tf_util.CalculateDamage(self, hitpos)
end

function ENT:OnTakeDamage(dmginfo)
	if dmginfo:GetInflictor():IsWorld() then return end
	if dmginfo:GetDamageType() == DMG_POISON then return end
	self:SetBloodColor(BLOOD_COLOR_MECH)
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	if not self.BuildSubstractHealth then
		self.BuildSubstractHealth = 0
	end
	self.BuildSubstractHealth = self.BuildSubstractHealth + dmginfo:GetDamage()
	if self:Health()<=0 then
		gamemode.Call("OnNPCKilled", self, dmginfo:GetAttacker(), dmginfo:GetInflictor())
		self.OnTakeDamage = nil
		local owner = self:GetBuilder()
		if IsValid(owner) and owner:IsPlayer() and self.objtype then
			owner.objtype = self.objtype
			owner:Speak("TLK_LOST_OBJECT")
		end
		
		self:Explode()
	end
	if (dmginfo:IsDamageType(DMG_BULLET) and self:Health()>=1 ) then
		self:EmitSound("Building_Sentry.Damaged")
	end
end

function ENT:OnStartBuilding()
	if self:GetBuildingType() == 1 then
		self:SetSkin(self:GetSkin()+2)
		self:SetBodygroup(2, 1)
		self.Model:SetBodygroup(2, 1)
		self.Model:SetSkin(self:GetSkin())
		self.AnimNeedsBodygroup = true
		self.Model:SetBuildingScale(0.75)
		
		self.BuildRate = 2
		self.InitialHealth = self:GetObjectHealth()
		self:SetMaxHealth(self:GetObjectHealth())
		
		self.BaseDamage = 10
		
		if not tf_minisentry_allow_upgrade:GetBool() then
			self.RepairRate = 0
			self.UpgradeRate = 0
		end
	elseif self:GetBuildingType() == 2 then
		self.BaseDamage = 20
		self.UpgradeRate = 15
		self:SetBodygroup(2, 0)
		self.Model:SetBuildingScale(1.2)
	elseif self:GetBuildingType() == 3 then
		self.BaseDamage = 6
		self.UpgradeRate = 0
		self:SetBodygroup(2, 0)
		self.Model:SetBuildingScale(1.0)
		self.Model:SetModel("models/combine_turrets/floor_turret.mdl")
		self:SetModel("models/combine_turrets/floor_turret.mdl")
	end
end

function ENT:OnDoneBuilding()
	self:EmitSound(self.Sound_DoneBuilding)
	
	self.Target = nil
	
	self.TurretPitch = 0
	self.TurretYaw = 0
	self.TargetPitch = 0
	self.TargetYaw = 0
	self.DPitch = 0
	self.DYaw = 0
	self.IdlePitchSpeed = 0.3
	self.IdleYawSpeed = 0.75
	
	if self:GetBuildingType() == 1 then
		self.AimSpeedMultiplier = 1.35
		self.FireRateMultiplier = 0.66
	elseif self:GetBuildingType() == 2 then
		self.AimSpeedMultiplier = 0.8
		self.FireRateMultiplier = 1.25
	else
		self.AimSpeedMultiplier = 1
		self.FireRateMultiplier = 1
	end
	
	self.ActiveSpeed = 4 * self.AimSpeedMultiplier
	self.FireRate = 0.25 * self.FireRateMultiplier
	
	self:SetAmmo1(self.MaxAmmo1)
	self:SetAmmo2(self.MaxAmmo2)
	
	self.BulletSpread = 0
	
	--[[
	0 : Undefined/Building/Upgrading
	1 : Scanning
	2 : Targeting
	]]
	self:SetSentryState(1)
	
	self.Idle_Sound = CreateSound(self, self.Sound_Idle)
	
	if self:GetBuildingType() == 1 then
		self.Shoot_Sound = self.Sound_FireMini
		self.SoundPitch = 120
	elseif self:GetBuildingType() == 2 then
		self.Shoot_Sound = self.Sound_Fire
		self.SoundPitch = 85
	else
		self.Shoot_Sound = self.Sound_Fire
		self.SoundPitch = 100
	end
	self.IsDoneBuilding = true
end

function ENT:SetSentryState(st)
	if st==1 then
		--MsgFN("Switching to IDLE state!")
		self.TargetPitch = 0
		self.TargetYaw = 50
		self.Target = nil
		self.NextSearch = CurTime()+0.5
	else
		--MsgFN("Switching to TARGET state! (target:%s)", tostring(self.Target))
		self.NextSearch = CurTime()+1
	end
	self.SentryState = st
end

function ENT:SetAimTarget(p, y)
	self.TargetPitch = p
	self.TargetYaw = y
end

function ENT:OnStartUpgrade()
	self:EmitSound(self.Sound_DoneBuilding, 100, 100)
	
	self.Idle_Sound:Stop()
	if self:GetLevel()==2 then
		self.Gibs = SentryGibs2
		self.FireRate = 0.125
		self.Shoot_Sound = self.Sound_Fire2
		self.Idle_Sound = CreateSound(self, self.Sound_Idle2)
		self.NameOverride = "obj_sentrygun2"
		
		local health_frac = self:Health() / self:GetMaxHealth()
		self:SetMaxHealth(self:GetObjectHealth())
		self:SetHealth(self:GetObjectHealth() * health_frac)
		
		self.MaxAmmo1 = 120
		self.MaxAmmo2 = 0
		self:SetAmmo1(self.MaxAmmo1)
		self:SetAmmo2(self.MaxAmmo2)
	elseif self:GetLevel()==3 then
		self.Gibs = SentryGibs3
		self.Shoot_Sound = self.Sound_Fire3
		self.Idle_Sound = CreateSound(self, self.Sound_Idle3)
		self.NameOverride = "obj_sentrygun3"
		
		local health_frac = self:Health() / self:GetMaxHealth()
		self:SetMaxHealth(self:GetObjectHealth())
		self:SetHealth(self:GetObjectHealth() * health_frac)
		
		self.MaxAmmo1 = 144
		self.MaxAmmo2 = 20
		self:SetAmmo1(self.MaxAmmo1)
		self:SetAmmo2(self.MaxAmmo2)
	end
end

function ENT:PreUpgradeAnim()
	self:OnThink()
end

function ENT:OnDoneUpgrade()
	self:OnThink()
end

function ENT:OnThink()
	if self.AnimNeedsBodygroup then
		if self.AnimNeedsBodygroup == true then
			self:SetBodygroup(2, 1)
			self.Model:SetBodygroup(2, 1)
		end
	end
	if self.Wrangled == false then
		if self:GetBuildingType() == 3 then
			self:SetPoseParameter("aim_pitch", -self.VisualTurretPitch)
			self:SetPoseParameter("aim_yaw", -self.TurretYaw)
			self.Model:SetPoseParameter("aim_pitch", -self.VisualTurretPitch)
			self.Model:SetPoseParameter("aim_yaw", -self.TurretYaw)
		else
			self:SetPoseParameter("aim_pitch", self.VisualTurretPitch)
			self:SetPoseParameter("aim_yaw", self.TurretYaw)
			self.Model:SetPoseParameter("aim_pitch", self.VisualTurretPitch)
			self.Model:SetPoseParameter("aim_yaw", self.TurretYaw)		
		end
	end
end

function ENT:StartFiring()
	self.Firing = true
	self.NextFire = nil
end

function ENT:StopFiring()
	self.Firing = false
end

function ENT:ShootPos(right)
	local p
	
	if self:GetLevel()==1 then
		if self:GetBuildingType() == 3 then
			p = self:GetBonePosition(self:LookupBone("Barrel"))
		else
			p = self:GetAttachment(self:LookupAttachment("muzzle"))
		end
	else
		if right then
			p = self:GetAttachment(self:LookupAttachment("muzzle_r"))
		else
			p = self:GetAttachment(self:LookupAttachment("muzzle_l"))
		end
	end
	if self:GetBuildingType() == 3 then
		return p
	else
		return p.Pos
	end
end

function ENT:TargetOrigin()
	return self:GetPos() + self.OriginZOffset * vector_up
end

function ENT:RocketShootPos()
	local p
	
	p = self:GetAttachment(self:LookupAttachment("rocket"))
	
	return p.Pos
end

function ENT:ShootBullets()
	local dir = (self:GetAngles() + Angle(self.TurretPitch, self.TurretYaw, 0)):Forward()
	
	if self.GunCounter then
		self.GunCounter = 1 - self.GunCounter
	else
		self.GunCounter = 0
	end
	local pos = self:ShootPos(self.GunCounter > 0)
	local tarpos = self.TargetPos
	
	if not self.SoundCounter or self.SoundCounter == 0 then
		--self:EmitSound(self.Shoot_Sound)
		
		if self.ShootSoundEnt then
			self.ShootSoundEnt:Stop()
		end
		self.ShootSoundEnt = CreateSound(self, self.Shoot_Sound)
		
		if self:GetLevel() == 1 then
			self.SoundCounter = 1
			self.ShootSoundEnt:Play()
		
			if self.Wrangled != false then
				self.ShootSoundEnt:ChangePitch(120)
			end
		else
			self.SoundCounter = 2
			self.ShootSoundEnt:PlayEx(1, self.SoundPitch)
			if self.Wrangled != false then
				self.ShootSoundEnt:ChangePitch(120)
			end
		end
	end
	
	umsg.Start("DoSentryMuzzleFlash")
		umsg.Entity(self)
		umsg.Char(self.GunCounter)
	umsg.End()
	
	self:FireTFBullets{
		Num = 1,
		Src = pos,
		Dir = (tarpos - pos):GetNormal(),
		Spread = Vector(0, 0, 0),
		--Attacker = self,
		Attacker = self:GetBuilder(),
		
		Team = GAMEMODE:EntityTeam(self),
		Damage = self.BaseDamage,
		RampUp = self.MaxDamageRampUp,
		Falloff = self.MaxDamageFalloff,
		Critical = false,
		CritMultiplier = 3,
		DamageModifier = 1,
		DamageRandomize = self.DamageRandomize,
		
		Tracer = 1,
		TracerName = "bullet_tracer01",
		Force = 1,
	}
	self.SoundCounter = self.SoundCounter - 1
	
	return true
end

function ENT:ShootRocket()
	local pos = self:RocketShootPos()
	local tarpos = self.TargetPos
	local dir = (tarpos - pos):GetNormal()
	
	--self:EmitSound(self.RocketShoot_Sound)
	if self.RocketShootSoundEnt then
		self.RocketShootSoundEnt:Stop()
	end
	self.RocketShootSoundEnt = CreateSound(self, self.RocketShoot_Sound)
	self.RocketShootSoundEnt:PlayEx(1, self.SoundPitch)
	if self.Wrangled != false then
		self.RocketShootSoundEnt:ChangePitch(120) 
	end
	
	local rocket = ents.Create("tf_projectile_sentryrocket")
	rocket:SetPos(pos)
	rocket:SetAngles(dir:Angle())
	--rocket:SetOwner(self)
	rocket:SetOwner(self:GetBuilder())
	rocket.Launcher = self
	rocket:Spawn()
	--rocket:Activate()
end

function ENT:FindTarget(dbg)
	local Target, MinDist, Method
	for _,v in pairs(ents.FindInSphere(self:GetPos(), self.Range)) do
		if (v:IsTFPlayer()) and ( v:Health() > 0 ) and (self:Team()==TEAM_NEUTRAL or GAMEMODE:EntityTeam(v)~=self:Team()) then
			local d = self:GetPos():Distance(v:GetPos())
			if not MinDist or d<MinDist then
				local method = self:GetTargetMethod(v, true, dbg)
				if method then				
					if ( v:IsPlayer() and not v:IsFriendly(self) and v:GetPlayerClass() == "spy" ) then
						if v:GetModel() == "models/player/scout.mdl" or  v:GetModel() == "models/player/soldier.mdl" or  v:GetModel() == "models/player/pyro.mdl" or  v:GetModel() == "models/player/demo.mdl" or  v:GetModel() == "models/player/heavy.mdl" or  v:GetModel() == "models/player/engineer.mdl" or  v:GetModel() == "models/player/medic.mdl" or  v:GetModel() == "models/player/sniper.mdl" or  v:GetModel() == "models/player/hwm/spy.mdl"  then return true end
					end
					if ( v:IsPlayer() and v:HasGodMode() != false ) then
						return
					end 
					Target = v
					MinDist = d
					Method = method
				end
			end
		end
	end
	for _,v in pairs(ents.FindByClass("npc_mvm_tank")) do
		if v.MvMBot == true and self:Team() == TEAM_RED or self:Team() == TEAM_BLU then
			local d = self:GetPos():Distance(v:GetPos())
			if not MinDist or d<MinDist then
				local method = self:GetTargetMethod(v, true, dbg)
				if method then
					Target = v
					MinDist = d
					Method = method
				end
			end
		end
	end
	
	return Target, Method
end

function ENT:ThinkIdle()
	local dp, dy = sign(self.TargetPitch-self.TurretPitch), sign(self.TargetYaw-self.TurretYaw)
		
	self.TurretPitch = angnorm(self.TurretPitch + dp*self.IdlePitchSpeed)
	if dp * self.TurretPitch >= dp * self.TargetPitch then
		self.TurretPitch = self.TargetPitch
	end
		
	self.TurretYaw = angnorm(self.TurretYaw + dy*self.IdleYawSpeed)
	if dy * self.TurretYaw >= dy * self.TargetYaw then
		self.TargetYaw = -self.TargetYaw
		self.Idle_Sound:Stop()
		
		self.Idle_Sound:PlayEx(1, self.SoundPitch)
		
		self.TargetPitch = 5*math.random(-2,2)
	end
	
	self.VisualTurretPitch = self.TurretPitch
	
	if not self.NextSearch or CurTime()>=self.NextSearch then
		self.Target, self.TargetMethod = self:FindTarget()
		if self.Target and self.TargetMethod and self.Target:IsValid() then
			--self:EmitSound(self.Sound_Alert)
			if self.AlertSoundEnt then
				self.AlertSoundEnt:Stop()
			end
			if self:GetBuildingType() == 3 then
				self:EmitSound("NPC_CeilingTurret.Active")
			else
				self.AlertSoundEnt = CreateSound(self, self.Sound_Alert)
				self.AlertSoundEnt:PlayEx(1, self.SoundPitch)
			end
			
			if self.Target:IsPlayer() then
				umsg.Start("NotifySentrySpotted", self.Target)
					umsg.Entity(self)
				umsg.End()
			end
			self:SetSentryState(2)
			return
		end
		self.NextSearch = CurTime() + 0.5
	end
end
if SERVER then
function ENT:Think()
	local state = self:GetState()
	local deltatime = 0
	
	if self.LastThink then
		deltatime = CurTime() - self.LastThink
	end
	self.LastThink = CurTime()
		if !IsValid(self:GetBuilder()) then
			if self:GetBuilder():IsPlayer() then
				self:Explode()
			end
		end
	if IsValid(self:GetBuilder()) then
		if self:GetBuilder():IsPlayer() and self:GetBuilder():GetPlayerClass() != "engineer" then
			self:Explode()
		end
	end
	self:OnThink()
	if state==0 then
		if CurTime()-self.StartTime>=self.TimeLeft then
			self:Build()
		end
	elseif state==1 then
		local time_added = deltatime
		
		if self.BuildBoost then
			local total = 1
			local mul = self.DefaultBuildRate / self.BuildRate
			
			for pl,data in pairs(self.BuildBoost) do
				if CurTime() > data.endtime then
					self.BuildBoost[pl] = nil
				else
					total = total + data.val * mul
				end
			end
			
			self.Model:SetPlaybackRate(self.BuildRate * total)
			time_added = time_added * total
		end
		
		self.BuildProgress = math.Clamp(self.BuildProgress + time_added, 0, self.BuildProgressMax)
		self:SetBuildProgress(self.BuildProgress / self.BuildProgressMax)
		
		local health = math.Clamp((self.BuildProgress / self.BuildProgressMax) * self:GetMaxHealth(), self.InitialHealth, self:GetMaxHealth())
		self:SetHealth(health - (self.BuildSubstractHealth or 0))
		
		if self.BuildProgress >= self.BuildProgressMax then
			self:OnDoneBuilding()
			self:SetHealth(self:GetMaxHealth() - (self.BuildSubstractHealth or 0))
			self:Enable()
		end
	elseif state==2 then
		if CurTime()-self.StartTime>=self.TimeLeft then
			self:OnDoneUpgrade()
			self:Enable()
		end
		
		if not self.DisableDuringUpgrade then
			self:OnThinkActive()
		end
	elseif state==3 then
		self:OnThinkActive()
	end
	
	self:NextThink(CurTime())
	return true
end
end
function ENT:ThinkTarget()
	-- If the target gets too far away, forget about it
	if IsValid(self.Target) and self.Target:Health()>0 and (not self.NextDistanceCheck or CurTime() > self.NextDistanceCheck) then
		local dist = self:GetPos():Distance(self.Target:GetPos())
		if dist > self.Range then
			self.Target = nil
		end
		self.NextDistanceCheck = CurTime() + 0.25
	end
	
	-- Lost target, find another one, or go back to idle
	if not self.Target or not self.Target:IsValid() or self.Target:Health()<=0 then
		self.Target, self.TargetMethod = self:FindTarget()
		if not self.Target or not self.TargetMethod then
			self:StopFiring()
			self:SetSentryState(1)
			return
		end
		--self:EmitSound(self.Sound_Alert)
		if self.AlertSoundEnt then
			self.AlertSoundEnt:Stop()
		end
		if self:GetBuildingType() == 3 then
			self:EmitSound("NPC_CeilingTurret.Alert")
			timer.Simple(2, function()
				self.AlertSoundEnt = CreateSound(self, self.Sound_Alert)
				self.AlertSoundEnt:PlayEx(1, self.SoundPitch)
				self:StopSound("NPC_CeilingTurret.Alert")
			end)
		else
			self.AlertSoundEnt = CreateSound(self, self.Sound_Alert)
			self.AlertSoundEnt:PlayEx(1, self.SoundPitch)
		end 
		if self.Target:IsPlayer() then
			umsg.Start("NotifySentrySpotted", self.Target)
			umsg.End()
		end
	end
	
	self.TargetPos = self.TargetMethod(self.Target)
	
	-- Tracking
	--local ang = self:GetAngles()-(self.TargetPos - self:ShootPos()):Angle()
	local ang = self:GetAngles()-(self.TargetPos - self:TargetOrigin()):Angle()
	self.TargetPitch = angnorm(ang.p)
	self.TargetYaw = angnorm(ang.y)
	
	local dp = math.Clamp(0.2*dangnorm(self.TargetPitch,self.TurretPitch), -self.ActiveSpeed, self.ActiveSpeed)
	local dy = math.Clamp(0.2*dangnorm(self.TargetYaw,self.TurretYaw), -self.ActiveSpeed, self.ActiveSpeed)

	--self.TurretPitch = math.Clamp(angnorm(self.TurretPitch + dp),-50, 50)
	self.TurretPitch = math.Clamp(angnorm(self.TurretPitch + dp),-89.9, 89.9)
	self.VisualTurretPitch = math.Clamp(self.TurretPitch, -50, 50)
	self.TurretYaw = angnorm(self.TurretYaw + dy)
	
	-- Firing
	if self.Firing then
		if not self.NextFire or CurTime()>=self.NextFire then
			local ok = self:TakeAmmo1(1)
			
			self.ShootAnimCounter = (self.ShootAnimCounter or 1) - 1
			if self.ShootAnimCounter == 0 then
				self.ShootAnimCounter = 4
				if ok then
					self.Model:RestartGesture(ACT_RANGE_ATTACK1, true)
				elseif self:GetLevel() > 1 then
					self.Model:RestartGesture(ACT_RANGE_ATTACK1_LOW, true)
				end
			end
			
			if ok then
				self:ShootBullets()
			else
				self:EmitSound(self.Sound_Empty)
			end
			
			self.NextFire = CurTime() + self.FireRate
		end
		
		if self:GetLevel() == 3 then
			if not self.NextFireRocket or CurTime()>=self.NextFireRocket then
				local ok = self:TakeAmmo2(1)
				
				if ok then
					self:ShootRocket()
					self:SetNoDraw(true)
					self.Model:SetNoDraw(false)
					self.Model:RestartGesture(ACT_RANGE_ATTACK2, true)
					self.NextFireRocket = CurTime() + 3
				end
			end
		end
	else
		self.ShootAnimCounter = nil
		--self:RestartGesture(ACT_INVALID)
	end
	
	-- Check visibility and decide whether to shoot or not
	if not self.NextCheckVis or CurTime()>=self.NextCheckVis then
		local firestate = self.Firing
		
		if math.abs(dangnorm(self.TurretPitch,self.TargetPitch))<5 and math.abs(dangnorm(self.TurretYaw,self.TargetYaw))<5 then
			firestate = true
		else
			firestate = false
		end
		
		if firestate then
			self.TargetMethod = self:GetTargetMethod(self.Target)
			
			if not self.TargetMethod then
				firestate = false
				self.Target = nil
			end
		end
		
		if firestate ~= self.Firing then
			if firestate then
				self:StartFiring()
			else
				self:StopFiring()
			end
		end
		
		self.NextCheckVis = CurTime() + 0.25
	end
	
	-- Update target, if someone gets closer than the current target, switch
	if not self.NextSearch or CurTime()>=self.NextSearch then
		self.Target, self.TargetMethod = self:FindTarget()
		self.NextSearch = CurTime() + 1
	end
end

function ENT:OnThinkActive()
	if self.SentryState == 1 then -- Idling
		self:ThinkIdle()
	elseif self.SentryState == 2 then -- Targeting
		self:ThinkTarget()
	end
end

function ENT:NeedsResupply()
	return self.Ammo1 < self.MaxAmmo1 or self.Ammo2 < self.MaxAmmo2
end

function ENT:Resupply(max)
	local max0 = max
	local metal_spent
	
	-- bullets
	local num_bullets = math.min(self.MaxAmmo1 - self.Ammo1, math.min(max, 40))	-- +40 bullets per wrench hit
	metal_spent = num_bullets
	if metal_spent > 0 then
		max = max - metal_spent
		self:AddAmmo1(num_bullets)
	end
	
	-- rockets
	local num_rockets = math.min(self.MaxAmmo2 - self.Ammo2, math.min(math.floor(max/2), 8)) -- +8 rockets per wrench hit
	metal_spent = 2 * num_rockets
	if metal_spent > 0 then
		max = max - metal_spent
		self:AddAmmo2(num_rockets)
	end
	
	return max0 - max
end

function ENT:OnRemove()
	if self.Idle_Sound then
		self.Idle_Sound:Stop()
	end
end