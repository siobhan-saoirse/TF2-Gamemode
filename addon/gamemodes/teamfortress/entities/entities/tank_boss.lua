AddCSLuaFile()

sound.Add( {
	name = "BossCart.Drive",
	channel = CHAN_BODY,
	volume = 1.0,
	level = 95,
	pitch = {100},
	sound = {
		"ambience/tankdrivein1.wav", 
		"ambience/tankdrivein2.wav"
	}
} )

PrecacheParticleSystem( "halloween_boss_summon" );
PrecacheParticleSystem( "halloween_boss_axe_hit_world" );
PrecacheParticleSystem( "halloween_boss_injured" );
PrecacheParticleSystem( "halloween_boss_death" );
PrecacheParticleSystem( "halloween_boss_foot_impact" );
PrecacheParticleSystem( "halloween_boss_eye_glow" );
ENT.Type 			= "nextbot"
ENT.Base 			= "base_nextbot"
ENT.Spawnable		= false
ENT.Model = "models/bots/boss_bot/boss_tank.mdl"
ENT.AttackDelay = 50
ENT.AttackDamage = 30
ENT.AttackRange = 2500
ENT.item1AttackDelay2 = CurTime() + 1.1	
ENT.CrybabyMode = false
function ENT:Initialize()

	if CLIENT then

		killicon.Add( "headtaker", "backpack/weapons/c_models/c_headtaker/c_headtaker", Color( 255, 255, 255, 255 ) )
	
	end
	self:SetModel( self.Model )
	self:AddFlags(FL_OBJECT)
	if SERVER then
		local axe = ents.Create("gmod_button")
		axe:SetModel("models/bots/boss_bot/tank_track_l.mdl")
		axe:SetPos(self:GetPos())
		axe:SetAngles(self:GetAngles())
		axe:SetParent(self)
		axe:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
		axe:SetSequence("forward")
		axe:SetPlaybackRate(1)
		local axe2 = ents.Create("gmod_button")
		axe2:SetModel("models/bots/boss_bot/tank_track_r.mdl")
		axe2:SetPos(self:GetPos())
		axe2:SetAngles(self:GetAngles())
		axe2:SetParent(self)
		axe2:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
		axe2:SetSequence("forward")
		axe2:SetPlaybackRate(1)
		local axe3 = ents.Create("gmod_button")
		axe3:SetModel("models/bots/boss_bot/bomb_mechanism.mdl")
		axe3:SetPos(self:GetPos())
		axe3:SetAngles(self:GetAngles())
		axe3:SetParent(self)
		axe3:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
	end
	local seq = "spawn"
	timer.Simple(0.1, function()
		self.Ready = true
		self:EmitSound("Building_Sentrygun.Built")
		if SERVER then
			self:EmitSound("MVM.TankEngineLoop")
			self:EmitSound("MVM.TankStart")
			timer.Create("TankPing"..self:EntIndex(), 5, 0, function()
				self:EmitSound("MVM.TankPing")
			end)
		end
	end)
	self.Ready = false
	self.LoseTargetDist	= 5400	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 4000	-- How far to search for enemies
	self:SetHealth(30000)
	self:SetSolid(SOLID_BBOX) 
	self:SetCollisionBounds(Vector(-100,-100,0),Vector(100,100,140))
	self:SetCollisionGroup(COLLISION_GROUP_NPC)
	self:SetCustomCollisionCheck(true)
	self:ResetSequence("movement")
	
	umsg.Start("TF_PlayGlobalSound")
		umsg.String("Announcer.MVM_Tank_Alert_Spawn")
	umsg.End()
	timer.Simple(0.1, function()
	
		for _,track in ipairs(ents.FindByClass("path_track")) do 	
			if (track:GetName() == "boss_path_1")  then
				
				for _,track2 in ipairs(ents.FindByClass("path_track")) do 	
					if (track2:GetName() == track:GetKeyValues()["target"]) then
						for _,track3 in ipairs(ents.FindByClass("path_track")) do 	
							if (track3:GetName() == track2:GetKeyValues()["target"]) then
								self:SetPos(track3:GetPos())
							end
						end
					end
				end
			end
		end
	
	end)
	if SERVER then
		ParticleEffectAttach( "smoke_train", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("smoke_attachment") );
		self:SetBloodColor(DONT_BLEED)
	end
end
function ENT:GetAxe()
	return self:GetNWEntity("Axe")
end
function ENT:OnRemove()
	if (IsValid(self.bullseye)) then
		self.bullseye:Remove()
	end
	self:StopSound("MVM.TankEngineLoop")
	self:StopSound("MVM.TankPing")
	for k,v in ipairs(player.GetAll()) do
		if (v.IsITFromHHH) then
			v:RemovePlayerState(PLAYERSTATE_MARKED)
			v.IsITFromHHH = false
		end
	end
end

function ENT:FireAnimationEvent( pos, ang, event, name )
	if (event == 6004 or event == 7001) then
		timer.Simple(0.01, function()
			self:EmitSound("MVM.GiantScoutStep")
		end)
	end
end
----------------------------------------------------
-- ENT:Get/SetEnemy()
-- Simple functions used in keeping our enemy saved
----------------------------------------------------
function ENT:SetEnemy(ent)
	if (self.CrybabyMode) then
		self.CrybabyMode = false
	end
	self.Enemy = ent
end
function ENT:GetEnemy()
	return self.Enemy
end

hook.Add("PlayerDeath","RemoveITOnPlayerDeath",function(ply,inflictor,attacker)
	if (ply.IsITFromHHH) then
		ply.IsITFromHHH = false
	end
end)
hook.Add("EntityTakeDamage","RemoveITFromitem1Hit",function(target,dmginfo)
	local att = dmginfo:GetAttacker()
	if (target:IsTFPlayer() and !target:IsNextBot() and (dmginfo:IsDamageType(DMG_CLUB) or dmginfo:IsDamageType(DMG_SLASH)) and att.IsITFromHHH) then
		att:RemovePlayerState(PLAYERSTATE_MARKED)
		att.IsITFromHHH = false
		for k,v in ipairs(ents.FindByClass("boss_cart")) do
			if (IsValid(v)) then
				v:SetEnemy(target)
			end
		end
	end
end)

----------------------------------------------------
-- ENT:HaveEnemy()
-- Returns true if we have a enemy
----------------------------------------------------
function ENT:HaveEnemy()
	-- If our current enemy is valid
	if ( self:GetEnemy() and IsValid(self:GetEnemy()) ) then
		-- If the enemy is too far
		if ( self:GetRangeTo(self:GetEnemy():GetPos()) > self.LoseTargetDist ) then
			-- If the enemy is lost then call FindEnemy() to look for a new one
			-- FindEnemy() will return true if an enemy is found, making this function return true
			if (self:GetEnemy():IsPlayer()) then
				self:GetEnemy():RemovePlayerState(PLAYERSTATE_MARKED)
				self:GetEnemy().IsITFromHHH = false
			end
			return self:FindEnemy()
		-- If the enemy is dead( we have to check if its a player before we use Alive() )
		elseif ( self:GetEnemy():IsTFPlayer() and (GAMEMODE:EntityTeam(self:GetEnemy()) == TEAM_SPECTATOR or GAMEMODE:EntityTeam(self:GetEnemy()) == TEAM_FRIENDLY or self:GetEnemy():Health() < 1 or self:GetEnemy():IsFlagSet(FL_NOTARGET)) ) then
			return self:FindEnemy()		-- Return false if the search finds nothing
		end	
		-- The enemy is neither too far nor too dead so we can return true
		return true
	else
		-- The enemy isn't valid so lets look for a new one
		return self:FindEnemy()
	end
end

----------------------------------------------------
-- ENT:FindEnemy()
-- Returns true and sets our enemy if we find one
----------------------------------------------------
function ENT:FindEnemy()
	if not self.Ready then return false end
	-- Search around us for entities
	-- This can be done any way you want eg. ents.FindInCone() to replicate eyesight
	--[[
	local _ents = ents.FindInSphere( self:GetPos(), self.SearchRadius )
	-- Here we loop through every entity the above search finds and see if it's the one we want
	for k,v in ipairs( _ents ) do
		if ( ( v:IsTFPlayer() and !v:IsNextBot()) and GAMEMODE:EntityTeam(v) != TEAM_SPECTATOR and GAMEMODE:EntityTeam(v) != TEAM_FRIENDLY and v:Health() > 1 and !v:IsFlagSet(FL_NOTARGET) ) then
			if SERVER then
				for k,v in ipairs(ents.GetAll()) do
					if v:IsNPC() then
						v:AddEntityRelationship(self,D_HT,99)
					end
				end
			end
			-- We found one so lets set it as our enemy and return true
			self:SetEnemy(v)
			if (v:IsNPC()) then
				v:SetEnemy(self.bullseye)
			elseif (v:IsNextBot()) then
				v:SetEnemy(self)
			end
			//self:EmitSound("BossCart.Drive")
			if (v:IsPlayer() and !v.IsITFromHHH) then
				v.IsITFromHHH = true
			end
			//v:AddPlayerState(PLAYERSTATE_MARKED)
			return true
		end
	end]]
	-- We found nothing so we will set our enemy as nil (nothing) and return false
	if (self.CrybabyMode) then
		self.CrybabyMode = false
	end
	self:SetEnemy(nil)
	return false
end

----------------------------------------------------
-- ENT:RunBehaviour()
-- This is where the meat of our AI is
----------------------------------------------------
function ENT:RunBehaviour()
	while (true) do	
		for k,v in ipairs(ents.FindByClass("func_capturezone")) do
			if (v.TeamNum == TEAM_BLU) then
				if (self:GetPos():Distance(v.Pos) > 200) then
					self:ChaseEnemy({},v.Pos)
				end
			end
		end 
		coroutine.yield()
	end

end	

----------------------------------------------------
-- ENT:ChaseEnemy()
-- Works similarly to Garry's MoveToPos function
--  except it will constantly follow the
--  position of the enemy until there no longer
--  is one.
----------------------------------------------------
function ENT:Think()
	if (IsValid(self:GetEnemy()) and self.Ready) then
		if (math.random(1,1800) == 1) then
			self.CrybabyMode = true
		end
		local targetheadpos,targetheadang = self:GetEnemy():GetBonePosition(1) -- Get the position/angle of the head.
		self.EyeAngle = (targetheadpos - self:EyePos()):Angle() -- And finally, we snap our aim to the head of the target.
	end
	if (SERVER and !self:HaveEnemy()) then
		self.EyeAngle = self:EyeAngles()
	end
	if (IsValid(self:GetEnemy()) and self.Ready) then
		if (math.random(1,1800) == 1) then
			self.CrybabyMode = true
		end
	end
	if (IsValid(self.Path) and self:GetPos():Distance(self.Path:GetPos()) < 200) then
		if (!self.Path.Passed) then
			self.Path:Fire("inpass","",0)
			self.Path.Passed = true
		end
	end
	
	for k,v in ipairs(ents.FindByClass("func_capturezone")) do
		if (v.TeamNum == TEAM_BLU) then
			if (self:GetPos():Distance(v.Pos) < 200) then
				if (!self.IsDeployingBomb) then
					self:ResetSequence("deploy")
					self:StopSound("MVM.TankEngineLoop")
					self:EmitSound("MVM.TankDeploy")
					
					umsg.Start("TF_PlayGlobalSound")
						umsg.String("Announcer.MVM_Tank_Alert_Deploying")
					umsg.End()
				end
			end
		end
	end
	self:NextThink(CurTime())
	return true
end

function ENT:HandleStuck()
end

function ENT:ChaseEnemy( options, pos )

	local options = options or {}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, pos )		-- Compute the path towards the enemies position

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() ) do

		self.loco:SetDesiredSpeed(80)
			
		if ( path:GetAge() > 0.1 ) then					-- Since we are following the player we have to constantly remake the path
			path:Compute(self, pos)-- Compute the path towards the enemy's position again
		end
		path:Update( self )								-- This function moves the bot along the path
		
		if ( options.draw ) then path:Draw() end
		-- If we're stuck, then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()

	end

	return "ok"

end
function ENT:OnInjured( dmginfo )
	if (dmginfo:IsDamageType(DMG_BULLET)) then
		ParticleEffect( "bot_impact_light", dmginfo:GetDamagePosition(), self:GetAngles() )
		self:EmitSound("MVM_Tank.BulletImpact")
	end
end
function ENT:OnKilled( dmginfo )

	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	self.Ready = false
	self:EmitSound("MVM.TankExplodes")
	ParticleEffect("asplode_hoodoo_shockwave", self:GetPos() + Vector(0,0,35), self:GetAngles())
	ParticleEffect("asplode_hoodoo_shockwave", self:GetPos() + Vector(0,0,35), self:GetAngles())
	ParticleEffect("asplode_hoodoo_shockwave", self:GetPos() + Vector(0,0,35), self:GetAngles())
	ParticleEffect("asplode_hoodoo_shockwave", self:GetPos() + Vector(0,0,35), self:GetAngles())

	ParticleEffect("cinefx_goldrush_flash", self:GetPos(), self:GetAngles())
	ParticleEffect("fireSmoke_Collumn_mvmAcres", self:GetPos(), Angle())
	ParticleEffect("fluidSmokeExpl_ring_mvm", self:GetPos() + Vector(50,50,25), self:GetAngles())
	ParticleEffect("fluidSmokeExpl_ring_mvm", self:GetPos() + Vector(-50,-50,25), self:GetAngles())
	ParticleEffect("fluidSmokeExpl_ring_mvm", self:GetPos() + Vector(-50,50,25), self:GetAngles())
	ParticleEffect("fluidSmokeExpl_ring_mvm", self:GetPos() + Vector(50,-50,25), self:GetAngles())

	ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", self:GetPos() + Vector(50,50,25), self:GetAngles())
	ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", self:GetPos() + Vector(-50,-50,25), self:GetAngles())
	ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", self:GetPos() + Vector(-50,50,25), self:GetAngles())
	ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", self:GetPos() + Vector(50,-50,25), self:GetAngles())
	timer.Simple(0.1, function()
				
		if (!IsValid(self)) then return end

		local pos = self:GetPos()
		self:Remove()

	end)
end

list.Set( "NPC", "tank_boss", {
	Name = "Tank",
	Class = "tank_boss",
	Category = "TF2: MVM Bots"
})