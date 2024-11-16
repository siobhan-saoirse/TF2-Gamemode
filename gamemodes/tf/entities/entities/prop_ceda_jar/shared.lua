
ENT.Type 			= "anim"
ENT.Base 			= "base_anim"

PrecacheParticleSystem("peejar_trail_red")
PrecacheParticleSystem("peejar_trail_blu")
PrecacheParticleSystem("critical_grenade_red")
PrecacheParticleSystem("critical_grenade_blue")
PrecacheParticleSystem("peejar_impact")
PrecacheParticleSystem("peejar_impact_milk")
PrecacheParticleSystem("peejar_impact_small")

if CLIENT then

ENT.RenderGroup 		= RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()
end

end

if SERVER then

AddCSLuaFile( "shared.lua" )

ENT.Model = "models/w_models/weapons/w_eq_bile_flask.mdl"
ENT.Model2 = "models/w_models/weapons/w_eq_bile_flask.mdl"

ENT.Explosive = true
ENT.NoSelfDamage = true
--ENT.NoMiniCrits = true
ENT.ZeroDamageCrits = true
ENT.ExplosionSound = Sound("CedaJar.Explode")
ENT.OwnerDamage = 0

ENT.Trail = {"peejar_trail_red", "peejar_trail_blu"}

ENT.Mass = 10

local bugbait_radius = GetConVar("bugbait_radius")
local bugbait_hear_radius = GetConVar("bugbait_hear_radius")
local bugbait_distract_time = GetConVar("bugbait_distract_time")
local bugbait_grenade_radius = GetConVar("bugbait_grenade_radius")

function ENT:DoSpecialDamage(ent, dmginfo)
	local att = dmginfo:GetAttacker()
	
	dmginfo:SetDamage(0)
	dmginfo:SetDamageType(DMG_GENERIC)
	
	if ent:IsTFPlayer() and ent~=att and ent:CanReceiveCrits() and att:IsValidEnemy(ent) then
		
		if (!ent:HasPlayerState(PLAYERSTATE_PUKEDON)) then
			if (ent:IsPlayer()) then
				if SERVER then
					ent:SendLua("LocalPlayer():EmitSound('Event.VomitInTheFace')")
				end
			end
			ent:AddPlayerState(PLAYERSTATE_PUKEDON, true)	
		end
		timer.Simple(15, function()
			if (ent:HasPlayerState(PLAYERSTATE_PUKEDON)) then
				ent:RemovePlayerState(PLAYERSTATE_PUKEDON, false)	
			end
		end)
		
		if ent:IsPlayer() then
			-- Jarate? NOOOOOOOOOOOOOOOOOOOOOO!!!!
			ent:Speak("TLK_JARATE_HIT")
		elseif ent:GetClass()=="npc_combine_s" then
			ent:Fire("HitByBugbait", "", math.Rand(0, 0.5))
		end
		
		-- Since this doesn't actually cause damage, we are adding a cooperation here
		-- TODO: code high priority cooperations that remain as long as the effect doesn't wear off
		GAMEMODE:AddDamageCooperation(ent, att, 1, ASSIST_JARATE, 10)
	end
end

function ENT:Critical(ent, dmginfo)
	return ent~=self:GetOwner() and self.critical
end

function ENT:Initialize()
	if self.JarType == 2 then
		self:SetModel(self.Model2)
		self:SetSkin(2)
	else
		self:SetModel(self.Model)
	end
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_CUSTOM)
	self:SetHealth(1)
	self:SetMoveCollide(MOVECOLLIDE_FLY_SLIDE)
	
	local phys = self:GetPhysicsObject()
	if phys:IsValid(self.WModel2) then
		phys:Wake()
		phys:SetMass(self.Mass)
		phys:EnableDrag(false)
	end
	
	self.ai_sound = ents.Create("ai_sound")
	self.ai_sound:SetPos(self:GetPos())
	self.ai_sound:SetKeyValue("volume", "80")
	self.ai_sound:SetKeyValue("duration", "8")
	self.ai_sound:SetKeyValue("soundtype", "8")
	self.ai_sound:SetParent(self)
	self.ai_sound:Spawn()
	self.ai_sound:Activate()
	self.ai_sound:Fire("EmitAISound", "", 0.3)
	
	local effect = ParticleSuffix(GAMEMODE:EntityTeam(self:GetOwner()))
	local trail = self.Trail[self:GetOwner():EntityTeam()] or self.Trail[1]
	
	self.particle_trail = ents.Create("info_particle_system")
	self.particle_trail:SetPos(self:GetPos())
	self.particle_trail:SetParent(self)
	self.particle_trail:SetKeyValue("effect_name",trail)
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
end

function ENT:OnRemove()
	self.ai_sound:Remove()
	if self.particle_trail and self.particle_trail:IsValid(self.WModel2) then self.particle_trail:Remove() end
	if self.particle_crit and self.particle_crit:IsValid(self.WModel2) then self.particle_crit:Remove() end
end

function ENT:BugbaitTouch(owner)
	self:ActivateBugbaitTargets(owner)
	-- Alert any antlions around
	local bugbait_sound = ents.Create("ai_sound")
	bugbait_sound:SetPos(self:GetPos())
	bugbait_sound:SetKeyValue("volume", bugbait_hear_radius:GetInt())
	bugbait_sound:SetKeyValue("duration", bugbait_distract_time:GetFloat())
	bugbait_sound:SetKeyValue("soundtype", "512")
	bugbait_sound:Spawn()
	bugbait_sound:Activate()
	bugbait_sound:Fire("EmitAISound", "", 0)
	bugbait_sound:Fire("Kill", "", 5)
	
	--[[ Tell all spawners to now fight to this position
	g_AntlionMakerManager.BroadcastFightGoal( GetAbsOrigin() );]]
end

-- Direct port from CGrenadeBugBait::ActivateBugbaitTargets
function ENT:ActivateBugbaitTargets(owner)
	--[[
	-- Iterate over all sensors to see if they detected this impact
	for _,v in pairs(ents.FindByClass("point_bugbait")) do
		-- Make sure we're within range of the sensor
		local r = v:GetKeyValues().radius
		if r and r > v:GetPos():Distance(self:GetPos()) then
			-- Tell the sensor it's been hit
		end
	end]]
	
	-- oh fuck this shit
end

function ENT:DoExplosion()
	self.PhysicsCollide = nil
	
	sound.Play(self.ExplosionSound, self:GetPos())
	
	--[[local effect = "peejar_impact"
	
	local explosion = ents.Create("info_particle_system")
	explosion:SetKeyValue("effect_name", effect)
	explosion:SetKeyValue("start_active", "1")
	explosion:SetPos(self:GetPos()) 
	explosion:SetAngles(self:GetAngles())
	explosion:Spawn()
	explosion:Activate() 
	explosion:Fire("Kill", "", 0.1)]]
	
	local flags
	if self.JarType == 2 then
		flags = 16
	else
		flags = 4
	end
	
	local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetAngles(self:GetAngles())
		effectdata:SetAttachment(flags)
	util.Effect("tf_explosion", effectdata, true, true)
	
	local owner = self:GetOwner()
	if not owner or not owner:IsValid(self.WModel2) then owner = self end
	
	local range, damage
	range = 180
	self.BaseDamage = 1
	self.OwnerDamage = 0
	self.ResultDamage = self.BaseDamage
	
	self.CalculatedDamage = 0
	-- Yes, I'm using blast damage because it has a complex algorithm that allows explosive damage to get around walls with a certain limit
	-- A simple FindInSphere wouldn't be enough since players would be able to get jarated through a wall
	util.BlastDamage(self, owner, self:GetPos(), range*1, self.BaseDamage)
	self:BugbaitTouch(owner)
	self:Fire("kill", "", 0.01)
end

function ENT:PhysicsCollide(data, physobj)
	self:DoExplosion()
end

end
