
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

ENT.IsTFWeapon = true

local MaxAngCorrection = 45

function ENT:InitEffects()
	if SERVER then
		local mat
		if GAMEMODE:EntityTeam(self:GetOwner())==TEAM_BLU then
			mat = "Effects/arrowtrail_blu.vmt"
		else
			mat = "Effects/arrowtrail_red.vmt"
		end
		
		self.Trail = util.SpriteTrail(self, 0, Color(255,255,255,200), false,
			0.1, 5, 1, 1/(5+1)*0.5, mat)
	end
end

if CLIENT then

function ENT:Initialize()
	self:InitEffects()
end

function ENT:Draw()
	self:DrawModel()
end

usermessage.Hook("ArrowHit", function(um)
	LocalPlayer():EmitSound("Weapon_Arrow.ImpactFlesh")
end)

end

if SERVER then

AddCSLuaFile( "shared.lua" )

ENT.Model = "models/weapons/w_models/w_arrow.mdl"

ENT.MinDamage = 50
ENT.MaxDamage = 50
ENT.DamageRandomize = 0.125
ENT.MaxDamageRampUp = 0
ENT.MaxDamageFalloff = 0
ENT.DamageModifier = 1

ENT.RangedMinDamage = 37.5
ENT.RangedMaxDamage = 75
ENT.RangedMinHealing = 75
ENT.RangedMaxHealing = 150

ENT.HitboxSize = 0.5

ENT.CritDamageMultiplier = 3

function ENT:OnInitAttribute(att)
	if att.attribute_class == "set_weapon_mode" then
		self.NoHeadshots = true
	end
end

function ENT:Critical()
	return self.critical
end

function ENT:CalculateDamage(ownerpos)
	return tf_util.CalculateDamage(self, self:GetPos(), ownerpos)
end

function ENT:Initialize()
	self:DrawShadow(false)
	
	local min = Vector(-self.HitboxSize, -self.HitboxSize, -self.HitboxSize)
	local max = Vector( self.HitboxSize,  self.HitboxSize,  self.HitboxSize)
	
	self:SetModel(self.Model)
	
	self.Charge = self.Charge or 0
	self.BaseDamage = Lerp(self.Charge, self.MinDamage, self.MaxDamage)
	
	self:SetMoveType(MOVETYPE_FLYGRAVITY)
	self:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
	self:SetCollisionBounds(min, max)
	self:SetSolid(SOLID_BBOX)
	
	self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
	
	self:SetGravity(Lerp(self.Charge, self.MaxGravity or 1, self.MinGravity or 0.025))
	self:SetLocalVelocity(self:GetForward() * Lerp(self.Charge, self.MinForce or 2400, self.MaxForce or 3500))
	
	self.StartPos = self:GetPos()
	
	self:InitEffects()
end

function ENT:Think()
	self:SetAngles(self:GetVelocity():Angle())
end

util.PrecacheSound("Weapon_Arrow.ImpactFlesh")
util.PrecacheSound("Weapon_Arrow.ImpactMetal")
util.PrecacheSound("Weapon_Arrow.ImpactWood")
util.PrecacheSound("Weapon_Arrow.ImpactConcrete")

local ImpactSounds ={
	[MAT_ALIENFLESH] = "Weapon_Arrow.ImpactFlesh",
	[MAT_ANTLION] = "Weapon_Arrow.ImpactFlesh",
	[MAT_BLOODYFLESH] = "Weapon_Arrow.ImpactFlesh",
	[MAT_CLIP] = "Weapon_Arrow.ImpactMetal",
	[MAT_COMPUTER] = "Weapon_Arrow.ImpactMetal",
	[MAT_CONCRETE] = "Weapon_Arrow.ImpactConcrete",
	[MAT_DIRT] = "Weapon_Arrow.ImpactConcrete",
	[MAT_FLESH] = "Weapon_Arrow.ImpactFlesh",
	[MAT_FOLIAGE] = "Weapon_Arrow.ImpactWood",
	[MAT_GLASS] = "Weapon_Arrow.ImpactMetal",
	[MAT_GRATE] = "Weapon_Arrow.ImpactMetal",
	[MAT_METAL] = "Weapon_Arrow.ImpactMetal",
	[MAT_PLASTIC] = "Weapon_Arrow.ImpactConcrete",
	[MAT_SAND] = "Weapon_Arrow.ImpactConcrete",
	[MAT_SLOSH] = "Weapon_Arrow.ImpactConcrete",
	[MAT_TILE] = "Weapon_Arrow.ImpactConcrete",
	[MAT_VENT] = "Weapon_Arrow.ImpactMetal",
	[MAT_WOOD] = "Weapon_Arrow.ImpactWood",
}

local function ArrowBulletCallback(att, tr, dmginfo)
	local ent = tr.Entity
	local inf = dmginfo:GetInflictor()
	
	--print("ArrowBulletCallback", ent)
	if ent:IsWorld() then
		local effectdata = EffectData()
			effectdata:SetEntity(NULL)
			effectdata:SetOrigin(tr.HitPos)
			effectdata:SetAngles(dmginfo:GetInflictor():GetAngles())
		util.Effect("tf_arrow_stuck", effectdata)

		inf:EmitSound(ImpactSounds[tr.MatType] or "Weapon_Arrow.ImpactMetal")
	elseif ent:IsTFPlayer() then
		local bone, hitpos = ent:TranslatePhysBoneToBone(tr.PhysicsBone), tr.HitPos + inf:GetForward() * 5
		local pos = ent:GetBonePosition(bone)
		
		--inf:SetAngles((pos - hitpos):Angle())
		
		local effectdata = EffectData()
			effectdata:SetEntity(ent)
			effectdata:SetAttachment(tr.PhysicsBone)
			effectdata:SetOrigin(hitpos)
			effectdata:SetAngles(inf:GetAngles())
		util.Effect("tf_arrow_stuck", effectdata)
		
		inf.HitPos = hitpos
		inf.HitAng = inf:GetAngles()
		inf.HitBone = tr.PhysicsBone
		
		if not inf.NoHeadshots and tr.HitGroup == HITGROUP_HEAD then
			inf.critical = true
			inf.NameOverride = "tf_projectile_arrow_headshot"
		end
		inf:EmitSound("Weapon_Arrow.ImpactFlesh")
		if att:IsPlayer() then
			net.Start("ArrowHit")
			net.Send(att)
		end
	else
		inf:EmitSound(ImpactSounds[tr.MatType] or "Weapon_Arrow.ImpactMetal")
	end
end

function ENT:Hit(ent)
	self.Touch = nil
	
	local owner = self:GetOwner()
	if not owner or not owner:IsValid(self.WModel2) then owner = self end
	
	if self.IsHealingBolt then
		local fraction = math.Clamp(self:GetPos():Distance(self.StartPos) / 1024, 0, 1)
		if ent:IsTFPlayer() and ent:IsFriendly(owner) and not ent:IsBuilding() then
			GAMEMODE:HealPlayer(owner, ent, Lerp(fraction, self.RangedMinHealing, self.RangedMaxHealing), true, false)
			
			if IsValid(self.Trail) then
				self.Trail:SetParent()
				self.Trail:Fire("kill", "", 1)
			end
			
			self:SetLocalVelocity(Vector(0,0,0))
			self:SetMoveType(MOVETYPE_NONE)
			self:SetNotSolid(true)
			self:SetNoDraw(true)
			self:Fire("kill", "", 0.5)
			
			return
		else
			self.DamageRandomize = 0
			self.MaxDamageRampUp = 0
			self.MaxDamageFalloff = 0
			self.BaseDamage = Lerp(fraction, self.RangedMinDamage, self.RangedMaxDamage)
		end
	end
	
	local damage = self:CalculateDamage(owner:GetPos())
	local dir = self:GetForward()
	
	local tr = util.QuickTrace(self:GetPos(), 20*dir, self)
	
	local trtest = util.TraceHull{
		start = self:GetPos(),
		endpos = self:GetPos() + 20*dir,
		filter = self,
		mins = Vector(-self.HitboxSize, -self.HitboxSize, -self.HitboxSize),
		maxs = Vector(-self.HitboxSize, -self.HitboxSize, -self.HitboxSize),
	}
	
	--MsgN("Test trace ("..tostring(self)..") : physbone "..tr.PhysicsBone)
	
	if tr.HitEntity~=ent then
		-- Trace towards the nearest bone
		if ent:IsTFPlayer() then
			local bone, dist, bpos
			for i=1,100 do
				local b = ent:TranslatePhysBoneToBone(i)
				if b==0 then break end
				
				local pos = ent:GetBonePosition(b)
				local d = self:GetPos():Distance(pos)
				if not dist or d<dist then
					bone, dist, bpos = b, d, pos
				end
			end
			
			if bone then
				dir = (bpos - self:GetPos()):GetNormal()
			else
				-- Couldn't find a nearest bone, trace towards the center of the entity's bounding box
				local min, max = ent:WorldSpaceAABB()
				dir = ((min+max)/2 - self:GetPos()):GetNormal()
			end
			
			local old_ang = self:GetAngles()
			local new_ang = dir:Angle()
			local diff = Angle(
				math.AngleDifference(new_ang.p, old_ang.p),
				math.AngleDifference(new_ang.y, old_ang.y),
				math.AngleDifference(new_ang.r, old_ang.r))
			
			if diff.p > MaxAngCorrection then		new_ang.p = old_ang.p + MaxAngCorrection
			elseif diff.p < -MaxAngCorrection then	new_ang.p = old_ang.p - MaxAngCorrection
			end
			if diff.y > MaxAngCorrection then		new_ang.y = old_ang.y + MaxAngCorrection
			elseif diff.y < -MaxAngCorrection then	new_ang.y = old_ang.y - MaxAngCorrection
			end
			if diff.r > MaxAngCorrection then		new_ang.r = old_ang.r + MaxAngCorrection
			elseif diff.r < -MaxAngCorrection then	new_ang.r = old_ang.r - MaxAngCorrection
			end
			
			self:SetAngles(new_ang)
		end
	end
	
	self:FireBullets{
		Src=self:GetPos(),
		Attacker=owner,
		Dir=dir,
		Spread=Vector(0,0,0),
		Num=1,
		Damage=damage,
		Tracer=0,
		Force=Lerp(self.Charge, 1, 50),
		Callback=ArrowBulletCallback,
	}
	
	if IsValid(self.Trail) then
		self.Trail:SetParent()
		self.Trail:Fire("kill", "", 1)
	end
	
	self:SetLocalVelocity(Vector(0,0,0))
	self:SetMoveType(MOVETYPE_NONE)
	self:SetNotSolid(true)
	self:SetNoDraw(true)
	self:Fire("kill", "", 0.5)
end

function ENT:ShouldCollide(ent)
	if self.IsHealingBolt and IsValid(self:GetOwner()) and ent:IsTFPlayer() and ent:IsFriendly(self:GetOwner()) and not ent:IsBuilding() then
		return true
	end
end

function ENT:Touch(ent)
	if ent:IsSolid() then
		self:Hit(ent)
	end
end

-- Used for serverside ragdoll pinning (singleplayer only)
hook.Add("PostScaleDamage", "TFArrowPinRegister", function(ent, hitgroup, dmginfo)
	local inf = dmginfo:GetInflictor()
	
	if inf:GetClass()=="tf_projectile_arrow" and inf.HitPos then
		ent.LastArrowHitPos = inf.HitPos
		ent.LastArrowHitAng = inf.HitAng
		ent.LastArrowHitBone = inf.HitBone
	else
		ent.LastArrowHitPos = nil
		ent.LastArrowHitAng = nil
		ent.LastArrowHitBone = nil
	end
end)

end
