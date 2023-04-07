
if CLIENT then
	killicon.Add( "tf_projectile_pipe", "backpack/weapons/w_models/w_stickybomb_launcher_large", Color( 255, 255, 255, 255 ) )
end

-- Sticky bomb

ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

ENT.Explosive = true

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "DetonateMode")
end

if CLIENT then

local mat = Material("models/debug/debugwhite")

function ENT:Draw()
	local highlight = false
	
	if self.dt.DetonateMode == 1 and self:GetOwner() == LocalPlayer() then
		for _,v in pairs(LocalPlayer():GetWeapons()) do
			if v.IsBombInSensorCone then
				w = v
				break
			end
		end
		
		if IsValid(w) then
			if w:IsBombInSensorCone(self) then
				highlight = true
			end
		end
	end
	
	if highlight then
		render.MaterialOverride(matShiny)
		if LocalPlayer():EntityTeam()==TEAM_BLU then
			render.SetColorModulation(0,0,1)
		elseif LocalPlayer():EntityTeam()==TF_TEAM_PVE_INVADERS then
			render.SetColorModulation(0,0,1)
		else
			render.SetColorModulation(1,0,0)
		end
		render.SetBlend(1)
		render.SuppressEngineLighting(true)
	end
	
	self:DrawModel()
	
	if highlight then
		render.SuppressEngineLighting(false)
		render.SetColorModulation(1,1,1)
		render.MaterialOverride(matShiny)
	end
end

end

if SERVER then

AddCSLuaFile( "shared.lua" )

local GibModels = {
Model("models/weapons/w_models/w_stickybomb_gib1.mdl"),
Model("models/weapons/w_models/w_stickybomb_gib2.mdl"),
Model("models/weapons/w_models/w_stickybomb_gib3.mdl"),
Model("models/weapons/w_models/w_stickybomb_gib4.mdl"),
Model("models/weapons/w_models/w_stickybomb_gib5.mdl"),
Model("models/weapons/w_models/w_stickybomb_gib6.mdl"),
}

ENT.Model = "models/weapons/w_models/w_grenade_pipebomb.mdl"
ENT.Model2 = "models/weapons/w_models/w_stickybomb_d.mdl"
ENT.Model3 = "models/weapons/w_models/w_stickybomb2.mdl"
ENT.Model4 = "models/weapons/w_models/w_stickybomb3.mdl"


ENT.ExplosionSound = ""
ENT.BounceSound = Sound("Weapon_Grenade_Pipebomb.Bounce")

ENT.BaseDamage = 120
ENT.DamageRandomize = 0.1
ENT.MaxDamageRampUp = 0.15
ENT.MaxDamageFalloff = 0.5
ENT.DamageModifier = 1

ENT.CritDamageMultiplier = 3

ENT.StickyDamping=15
ENT.Mass=30

function ENT:Critical()
	return self.critical
end

function ENT:CalculateDamage(ownerpos)
	return tf_util.CalculateDamage(self, self:GetPos(), ownerpos)
end

function ENT:Initialize()
	if self.DetonateMode==1 then
		self:SetModel(self.Model2)
		self.NameOverride = "tf_projectile_pipe_defender"
	elseif self.DetonateMode==2 then
		self:SetModel(self.Model3)
		self.NameOverride = "tf_projectile_pipe_round"
	else
		self:SetModel(self.Model)
	end
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_CUSTOM)
	self:SetHealth(1)
	self:SetMoveCollide(MOVECOLLIDE_FLY_SLIDE)
	if GAMEMODE:EntityTeam(self:GetOwner()) == TEAM_BLU then
		self:SetSkin(1)
	elseif GAMEMODE:EntityTeam(self:GetOwner()) == TF_TEAM_PVE_INVADERS then
		self:SetSkin(1)
	end
	
	local phys = self.Entity:GetPhysicsObject()
	if phys:IsValid(self.WModel2) then
		phys:Wake()
		phys:SetMass(self.Mass)
	end
	
	self.ai_sound = ents.Create("ai_sound")
	self.ai_sound:SetPos(self:GetPos())
	self.ai_sound:SetKeyValue("volume", "80")
	self.ai_sound:SetKeyValue("duration", "8")
	self.ai_sound:SetKeyValue("soundtype", "8")
	self.ai_sound:SetParent(self)
	self.ai_sound:Spawn()
	self.ai_sound:Activate()
	self.ai_sound:Fire("EmitAISound", "", 0.5)
	
	self.NextReady = CurTime() + 0.92 + (self.AdditionalArmTime or 0)
	self.NextNoFalloff = CurTime() + 5
	
	local effect = ParticleSuffix(GAMEMODE:EntityTeam(self:GetOwner()))
	
	self.particle_trail = ents.Create("info_particle_system")
	self.particle_trail:SetPos(self:GetPos())
	self.particle_trail:SetParent(self)
	self.particle_trail:SetKeyValue("effect_name","stickybombtrail_" .. effect)
	self.particle_trail:SetKeyValue("start_active", "1")
	self.particle_trail:Spawn()
	self.particle_trail:Activate()
	
	if self.critical then
		self.particle_crit = ents.Create("info_particle_system")
		self.particle_crit:SetPos(self:GetPos())
		self.particle_crit:SetParent(self)
		self.particle_crit:SetKeyValue("effect_name","critical_grenade_" .. effect)
		self.particle_crit:SetKeyValue("start_active", "1")
		self.particle_crit:Spawn()
		self.particle_crit:Activate()
	end
	
	self.FirstLaunch = true
end

function ENT:OnRemove()
	self.ai_sound:Remove()
	if self.particle_timer and self.particle_timer:IsValid(self.WModel2) then self.particle_timer:Remove() end
	if self.particle_trail and self.particle_trail:IsValid(self.WModel2) then self.particle_trail:Remove() end
	if self.particle_crit and self.particle_crit:IsValid(self.WModel2) then self.particle_crit:Remove() end
end

function ENT:Think()
	if self:GetOwner():IsPlayer() and self:GetOwner():GetActiveWeapon():GetItemData().model_player == "models/weapons/c_models/c_scottish_resistance/c_scottish_resistance.mdl" then
		self:SetModel("models/weapons/w_models/w_stickybomb_d.mdl")	
	end
	if self.NextReady and CurTime()>=self.NextReady then
		local effect = ParticleSuffix(GAMEMODE:EntityTeam(self:GetOwner()))
		self.particle_timer = ents.Create("info_particle_system")
		self.particle_timer:SetPos(self:GetPos())
		self.particle_timer:SetParent(self)
		self.particle_timer:SetKeyValue("effect_name","stickybomb_pulse_" .. effect)
		self.particle_timer:SetKeyValue("start_active", "1")
		self.particle_timer:Spawn()
		self.particle_timer:Activate()
	
		self.Ready = true
		self.NextReady = nil
		
		self.dt.DetonateMode = self.DetonateMode or 0
	end
	
	if self.NextNoFalloff and CurTime()>=self.NextNoFalloff then
		self.MaxDamageRampUp = 0
		self.MaxDamageFalloff = 0
		self.NextNoFalloff = nil
	end
	
	if IsValid(self.AttachedEntity) then
		if self.AttachedPhysObj and self.AttachedPhysObj:IsValid(self.WModel2) then
			if self.AttachedPhysObj:IsMoveable() then
				self:Detach()
			end
		end
	end
end

function ENT:DoExplosion()
	if self.Dead then return end
	self:EmitSound(self.ExplosionSound, 100, 100)
	
	--local flags = 0
	local flags = 8
	
	if self:WaterLevel()>0 then
		flags = bit.bor(flags, 1) 
	end
	
	if (self:Critical()) then

		ParticleEffect("Explosion_ShockWave_01", self:GetPos(), self:GetAngles())

	
		if self:GetOwner():Team() == TEAM_BLU then
			ParticleEffect("drg_cow_explosioncore_charged_blue", self:GetPos(), self:GetAngles())	
		elseif self:GetOwner():Team() == TF_TEAM_PVE_INVADERS then
			ParticleEffect("drg_cow_explosioncore_charged_blue", self:GetPos(), self:GetAngles())			
		else
			ParticleEffect("drg_cow_explosioncore_charged", self:GetPos(), self:GetAngles())
		end
		
		self:EmitSound("explode_8")
	end
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetAngles(self:GetAngles())
		effectdata:SetAttachment(flags)
	util.Effect("tf_explosion", effectdata, true, true)
	
	local owner = self:GetOwner()
	if not owner or not owner:IsValid(self.WModel2) then owner = self end
	
	local range = 180
	--local damage = self:CalculateDamage(owner:GetPos()+Vector(0,0,1))
	
	self:GetOwner()Damage = 0.9
	--self.ResultDamage = damage
	
	--util.BlastDamage(self, owner, self:GetPos(), range, damage)		--util.BlastDamage(self, owner, self:GetPos(), range, damage)
		if owner:IsPlayer() and owner:GetActiveWeapon():GetItemData().model_player == "models/weapons/c_models/c_sticky_jumper/c_sticky_jumper.mdl" then
			if owner:GetActiveWeapon():GetItemData().model_player  == "models/weapons/c_models/c_sticky_jumper/c_sticky_jumper.mdl" then
				owner:GetActiveWeapon().ShootSound = "weapons/sticky_jumper_shoot.wav"
				owner:GetActiveWeapon().ShootCritSound = "weapons/sticky_jumper_shoot.wav"
			end	
			util.BlastDamage(self, owner, self:GetPos(), range*1, 0)
			for k,v in ipairs(ents.FindInSphere(self:GetPos(), range*1)) do
				if v == owner then
					v:SetLocalVelocity(v:GetVelocity() * 1.9 + Vector(0, 0, 250)) 
				end
			end
		else
			util.BlastDamage(self, owner, self:GetPos(), range, 100)
		end
	
	self.Dead = true
	self:SetNotSolid(true)
	self:SetNoDraw(true)
	self:Fire("kill", "", 0.01)
end

function ENT:Break()
	if self.Dead then return end
	
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
	util.Effect("tf_stickybomb_destroyed", effectdata)
	
	--[[
	for _,v in ipairs(GibModels) do
		local drop = ents.Create("item_droppedweapon")
		drop:SetSolid(SOLID_VPHYSICS)
		drop:SetModel(v)
		drop:PhysicsInit(SOLID_VPHYSICS)
		drop:SetPos(self:GetPos())
		drop:SetAngles(self:GetAngles())
		drop:Spawn()
		drop.AmmoPercent = 0.5
		drop:Activate()
		
		drop:SetMoveType(MOVETYPE_VPHYSICS)
		drop:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		
		local phys = drop:GetPhysicsObject()
		if phys:IsValid(self.WModel2) then
			phys:AddAngleVelocity(Vector(math.Rand(-200,200),math.Rand(-200,200),math.Rand(-200,200)))
			phys:AddVelocity(Vector(math.random(-100,100),math.random(-100,100),math.random(100,300)))
			phys:Wake()
		end
	end]]
	
	if IsValid(self:GetOwner()) and self:GetOwner().Bombs then
		for k,v in ipairs(self:GetOwner().Bombs) do
			if v==self then
				table.remove(self:GetOwner().Bombs, k)
				break
			end
		end
		self:GetOwner():SetNWInt("NumBombs", #(self:GetOwner().Bombs))
	end
	
	self.Dead = true
	self:SetNotSolid(true)
	self:SetNoDraw(true)
	self:Fire("kill", "", 0.01)
end

function ENT:Detach()
	self.Detached = true
	self.AttachedEntity = nil
	self:GetPhysicsObject():SetDamping(0,self.StickyDamping)
	self:GetPhysicsObject():EnableMotion(true)
end

function ENT:OnTakeDamage(dmginfo)
	if not self.FirstLaunch then
		if dmginfo:IsExplosionDamage() then
			self:Detach()
			self:TakePhysicsDamage(dmginfo)
		elseif dmginfo:IsDamageType(DMG_BULLET) or dmginfo:IsDamageType(DMG_CLUB) or dmginfo:IsDamageType(DMG_SLASH) then
			self:Break()
		end
	end
end

function ENT:CanAttach(ent)
	if not ent then return false end
	
	if ent:IsWorld() then return true end

	if string.find(ent:GetClass(),"^prop_dynamic") then return true end
	
	if ent:GetClass() == "prop_physics" then
		local phys = ent:GetPhysicsObject()
		if phys:IsValid(self.WModel2) and not phys:IsMoveable() then
			return true
		end
	end
end

function ENT:PhysicsCollide(data, physobj)
	self.FirstLaunch = false
	
	if self.Detached then
		if self:GetPhysicsObject():GetVelocity():Length()<5 then
			self.Detached = false
		end
	end
	
	if self:CanAttach(data.HitEntity) and not self.Detached then
		if self.DetonateMode == 2 then
			self:Break()
			return
		end
		
		self.AttachedEntity = data.HitEntity
		if data.HitEntity:GetClass() == "prop_physics" then
			self.AttachedPhysObj = data.HitEntity:GetPhysicsObject()
		else
			self.AttachedPhysObj = nil
		end
		
		self:GetPhysicsObject():EnableMotion(true)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetSolid(SOLID_VPHYSICS)
	end
end

hook.Add("EntityRemoved", "StickyBombDetach", function(ent)
	for _,v in pairs(ents.FindByClass("tf_projectile_pipe_remote")) do
		if v.AttachedEntity==ent then
			v:Detach()
		end
	end
end)

end
