AddCSLuaFile()

PrecacheParticleSystem( "halloween_boss_summon" );
PrecacheParticleSystem( "halloween_boss_axe_hit_world" );
PrecacheParticleSystem( "halloween_boss_injured" );
PrecacheParticleSystem( "halloween_boss_death" );
PrecacheParticleSystem( "halloween_boss_foot_impact" );
PrecacheParticleSystem( "halloween_boss_eye_glow" );
ENT.Base 			= "base_nextbot"
ENT.Spawnable		= false
ENT.Model = "models/bots/headless_hatman.mdl"
ENT.AttackDelay = 50
ENT.AttackDamage = 30
ENT.AttackRange = 200
ENT.MeleeAttackDelay2 = CurTime() + 1.1	
ENT.CrybabyMode = false
function ENT:Initialize()

	if CLIENT then

		killicon.Add( "headtaker", "backpack/weapons/c_models/c_headtaker/c_headtaker", Color( 255, 255, 255, 255 ) )
	
	end
	self:SetModel( self.Model )
	self:AddFlags(FL_OBJECT)
	ParticleEffectAttach("halloween_boss_eye_glow", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("lefteye"))
	ParticleEffectAttach("halloween_boss_eye_glow", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("righteye"))
	if SERVER then
		local axe = ents.Create("gmod_button")
		axe:SetModel("models/weapons/c_models/c_bigaxe/c_bigaxe.mdl")
		axe:SetPos(self:GetPos())
		axe:SetAngles(self:GetAngles())
		axe:SetParent(self)
		axe:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
		self:SetNWEntity("Axe",axe)
	end
	local seq = "spawn"
	timer.Simple(0.1, function()
		timer.Simple(self:SequenceDuration(self:SelectWeightedSequence(ACT_TRANSITION)) - 0.1, function()
			self.Ready = true
			if SERVER then
				self:StartActivity(self:GetSequenceActivity(self:LookupSequence("stand_item1")))
				timer.Create("Laugh"..self:EntIndex(), 3, 0, function()
					if (self.Ready) then
						self:EmitSound("Halloween.HeadlessBossLaugh")
						timer.Adjust("Laugh"..self:EntIndex(),math.random(3,5),nil,nil)
						if (math.random(0,100) < 25) then
							self:AddGesture(ACT_MP_GESTURE_VC_FISTPUMP_MELEE,true)
						elseif (math.random(0,100) < 50) then
							self:AddGesture(ACT_MP_GESTURE_VC_FINGERPOINT_MELEE,true)
						end
					end
				end)
			end
		end)
	end)
	self.Ready = false
	self.LoseTargetDist	= 3600	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 2500	-- How far to search for enemies
	self:SetHealth(5000)
	self:EmitSound("Halloween.HeadlessBossSpawnRumble")
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_NPC)
	for k,v in ipairs(player.GetAll()) do
		if SERVER then
			v:SendLua("LocalPlayer():EmitSound(\"ui/halloween_boss_summoned_fx.wav\")")
		end
	end
	if SERVER then
		self:SetBloodColor(DONT_BLEED)
		PrintMessage(HUD_PRINTCENTER,"The Horseless Headless Horsemann has appeared!\n")
		ParticleEffectAttach("halloween_boss_summon", PATTACH_ABSORIGIN_FOLLOW, self, -1)
		self:StartActivity(ACT_TRANSITION)
	end
end
function ENT:GetAxe()
	return self:GetNWEntity("Axe")
end
function ENT:OnRemove()
	if (IsValid(self.bullseye)) then
		self.bullseye:Remove()
	end
	for k,v in ipairs(player.GetAll()) do
		if (v.IsITFromHHH) then
			v:PrintMessage(HUD_PRINTCENTER,"You are no longer IT.")
			v:SendLua("LocalPlayer():EmitSound(\"Player.TaggedOtherIT\")")
			v:RemovePlayerState(PLAYERSTATE_MARKED)
			v.IsITFromHHH = false
		end
	end
end

function ENT:FireAnimationEvent( pos, ang, event, name )
	if (event == 6004 or event == 7001) then
		timer.Simple(0.01, function()
			self:EmitSound("Halloween.HeadlessBossFootfalls")
		end)
		ParticleEffectAttach("halloween_boss_foot_impact", PATTACH_ABSORIGIN,self,0)
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
hook.Add("EntityTakeDamage","RemoveITFromMeleeHit",function(target,dmginfo)
	local att = dmginfo:GetAttacker()
	if (target:IsTFPlayer() and !target:IsNextBot() and (dmginfo:IsDamageType(DMG_CLUB) or dmginfo:IsDamageType(DMG_SLASH)) and att.IsITFromHHH) then
		att:PrintMessage(HUD_PRINTCENTER,"You are no longer IT.")
		att:SendLua("LocalPlayer():EmitSound(\"Player.TaggedOtherIT\")")
		att:RemovePlayerState(PLAYERSTATE_MARKED)
		att.IsITFromHHH = false
		for k,v in ipairs(ents.FindByClass("npc_headless_hatman")) do
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
				self:GetEnemy():PrintMessage(HUD_PRINTCENTER,"You are no longer IT.")
				self:GetEnemy():SendLua("LocalPlayer():EmitSound(\"Player.TaggedOtherIT\")")
				self:GetEnemy():RemovePlayerState(PLAYERSTATE_MARKED)
				self:GetEnemy().IsITFromHHH = false
			end
			return self:FindEnemy()
		-- If the enemy is dead( we have to check if its a player before we use Alive() )
		elseif ( self:GetEnemy():IsTFPlayer() and (GAMEMODE:EntityTeam(self:GetEnemy()) == TEAM_SPECTATOR or GAMEMODE:EntityTeam(self:GetEnemy()) == TEAM_FRIENDLY or self:GetEnemy():Health() < 0 or self:GetEnemy():IsFlagSet(FL_NOTARGET)) ) then
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
			if (math.random(1,5) == 1) then
				self:EmitSound("Halloween.HeadlessBossAlert")
			end
			if (v:IsPlayer() and !v.IsITFromHHH) then
				v:PrintMessage(HUD_PRINTCENTER,"YOU ARE IT!  MELEE HIT AN ENEMY TO TAG THEM IT!")
				v:SendLua("LocalPlayer():EmitSound(\"Player.YouAreIt\")")
				v.IsITFromHHH = true
				v:EmitSound("Halloween.PlayerScream")
			end
			v:AddPlayerState(PLAYERSTATE_MARKED)
			return true
		end
	end	
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
	-- This function is called when the entity is first spawned. It acts as a giant loop that will run as long as the NPC exists
	while ( true ) do
		-- Lets use the above mentioned functions to see if we have/can find a enemy
		if self.Ready then 
		
			if ( self:HaveEnemy() ) then

				-- Now that we have an enemy, the code in this block will run
				self.loco:FaceTowards(self:GetEnemy():GetPos())	-- Face our enemy
				self:StartActivity( self:GetSequenceActivity(self:LookupSequence("run_item1")) )			-- Set the animation
				self.loco:SetDesiredSpeed( 400 )		-- Set the speed that we will be moving at. Don't worry, the animation will speed up/slow down to match
				self:ChaseEnemy( ) 						-- The new function like MoveToPos.
				self:StartActivity( self:GetSequenceActivity(self:LookupSequence("stand_item1")) )			-- Set the animation
				-- Now once the above function is finished doing what it needs to do, the code will loop back to the start
				-- unless you put stuff after the if statement. Then that will be run before it loops
			
			else

				if (math.random(1,800) == 1) then

					-- Since we can't find an enemy, lets wander
					-- Its the same code used in Garry's test bot
					self:StartActivity( self:GetSequenceActivity(self:LookupSequence("run_item1")) )			-- Set the animation
					self.loco:SetDesiredSpeed( 320 )		-- Walk speed
					self.loco:SetAcceleration(300)
					self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 800 ) -- Walk to a random place within about 400 units (yielding)
					self:StartActivity( self:GetSequenceActivity(self:LookupSequence("stand_item1")) )			-- Set the animation


					coroutine.wait(2)
				end

			end

			coroutine.wait(0.1)
		else
			-- At this point in the code the bot has stopped chasing the player or finished walking to a random spot
			-- Using this next function we are going to wait 2 seconds until we go ahead and repeat it 
			coroutine.wait(0.1)
		end
		
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
	if SERVER then

		self:BodyMoveXY()

	end
	if (IsValid(self:GetEnemy()) and self.Ready) then
		if (math.random(1,1800) == 1) then
			self.CrybabyMode = true
		end
	end
	if (IsValid(self:GetEnemy()) and self:GetEnemy():Health() < 1) then
		self:SetEnemy(nil)
	end
	if (IsValid(self:GetEnemy()) and self.Ready) then
		if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange and self:GetEnemy():Health() > 0) then
			
			if (IsValid(self:GetEnemy()) and (!self.TerrifyAttackDelay or CurTime() > self.TerrifyAttackDelay)) then
				if (!self.TerrifyAttackDelay) then
					self.TerrifyAttackDelay = CurTime() + 20
					return
				end
				if (self:HaveEnemy() and self:GetEnemy():GetPos():Distance(self:GetPos()) < 300) then
					self.Ready = false
					self:EmitSound("Halloween.HeadlessBossBoo")
					self:AddGestureSequence(self:LookupSequence("boo"))
					timer.Simple(1.25, function()
						self.Ready = true
					end)
					timer.Simple(0.25, function()
					
						for k,v in ipairs(ents.FindInSphere(self:GetPos(),300)) do
							if v:IsTFPlayer() then
								if (v:IsPlayer()) then
									v:StripWeapons()
									v:ConCommand("tf_tp_simulation_toggle")
									v:EmitSound("Halloween.PlayerScream")
									local attach = v:LookupAttachment("head") or 1
									ParticleEffectAttach("yikes_fx", PATTACH_POINT_FOLLOW, v, attach)
									timer.Simple(3,function()
										v:StopParticles()
										local health = v:Health()
										v:SetPlayerClass(v:GetPlayerClass())
										v:ConCommand("tf_tp_simulation_toggle")
										timer.Simple(0.1, function()
											v:SetHealth(health)
										end)
									end)
								elseif (v:IsNPC()) then
									if (IsValid(v:GetActiveWeapon())) then
										local weaponname = v:GetActiveWeapon():GetClass()
										timer.Simple(0.1, function()
										
											v:StripWeapons()
											
										end)
										v:EmitSound("Halloween.PlayerScream")
										
										for k,v in ipairs(ents.GetAll()) do
											if v:IsNPC() then
												v:AddEntityRelationship(self,D_FR,99) 
											end
										end
										v.ScaredOfHHH = true
										local attach = v:LookupAttachment("head") or 1
										ParticleEffectAttach("yikes_fx", PATTACH_POINT_FOLLOW, v, attach)
										
										timer.Simple(3,function()
	
											v:StopParticles()
											for k,v in ipairs(ents.GetAll()) do
												if v:IsNPC() then
													v:AddEntityRelationship(self,D_HT,99)
												end
											end
											v.ScaredOfHHH = false
	
										end)
									else

										v:EmitSound("Halloween.PlayerScream")
									
										for k,v in ipairs(ents.GetAll()) do
											if v:IsNPC() then
												v:AddEntityRelationship(self,D_FR,99) 
											end
										end
										v.ScaredOfHHH = true
										local attach = v:LookupAttachment("head") or 1
										ParticleEffectAttach("yikes_fx", PATTACH_POINT_FOLLOW, v, attach)
										
										timer.Simple(3,function()
	
											v:StopParticles()
											for k,v in ipairs(ents.GetAll()) do
												if v:IsNPC() then
													v:AddEntityRelationship(self,D_HT,99)
												end
											end
											v.ScaredOfHHH = false
	
										end)
									end
								end
							end
						end

					end)
				end
				self.MeleeAttackDelay = CurTime() + 1
				self.TerrifyAttackDelay = CurTime() + 20
			end
			if (IsValid(self:GetEnemy()) and (!self.MeleeAttackDelay or CurTime() > self.MeleeAttackDelay)) then
				self:EmitSound("Halloween.HeadlessBossAttack")
				self:AddGestureSequence(self:LookupSequence("attackstand_item1"),true)
				timer.Simple(0.57, function()
					if (!self.Ready) then return end
					if (self:GetEnemy():GetPos():Distance(self:GetPos()) < 200) then
						self:GetEnemy():AddDeathFlag(DF_DECAP)
					end
				end)
				timer.Simple(0.58, function()
					if (!self.Ready) then return end
					if (self:GetEnemy():GetPos():Distance(self:GetPos()) < 200) then
						if (self:GetEnemy():GetClass() != "npc_headless_hatman") then
							local dmginfo = DamageInfo()
							dmginfo:SetAttacker(self)
							dmginfo:SetInflictor(self)
							dmginfo:SetDamageType(bit.bor(DMG_CLUB,DMG_SLASH))
							dmginfo:SetDamage(500)
							self:GetEnemy():TakeDamageInfo(dmginfo) 
						end
						if (self:GetEnemy():IsBuilding()) then
							ParticleEffect( "halloween_boss_axe_hit_world", self:GetEnemy():GetPos(), self:GetEnemy():GetAngles() )
							util.ScreenShake( self:GetPos(), 15, 5, 1, 1000 )
							self:EmitSound("Halloween.HeadlessBossAxeHitWorld")
						else
							self:EmitSound("Halloween.HeadlessBossAxeHitFlesh")
						end
					else
						local blade = self:GetAxe():GetAttachment(self:GetAxe():LookupAttachment("axe_blade"))
						ParticleEffect( "halloween_boss_axe_hit_world", blade.Pos, blade.Ang )
					end
					util.ScreenShake( self:GetPos(), 15, 5, 1, 1000 )
					self:EmitSound("Halloween.HeadlessBossAxeHitWorld")

				end)
				self.MeleeAttackDelay = CurTime() + 1
			end
		end
		if (self:GetEnemy():GetPos():Distance(self:GetPos()) < 100 and self:GetEnemy():Health() > 0) then
			if (self:GetSequence() != self:LookupSequence("stand_item1")) then
				self:StartActivity( self:GetSequenceActivity(self:LookupSequence("stand_item1")) )
			end
			self.loco:SetDesiredSpeed( 0 )
			self.loco:SetAcceleration(0)
		elseif (self:GetEnemy():GetPos():Distance(self:GetPos()) > 100 and self:GetEnemy():Health() > 0) then
			if (self.CrybabyMode) then

				if (self:GetSequence() != self:LookupSequence("run_melee")) then
					self:StartActivity( self:GetSequenceActivity(self:LookupSequence("run_melee")) )	
				end

			else
				if (self:GetSequence() != self:LookupSequence("run_item1")) then
					self:StartActivity( self:GetSequenceActivity(self:LookupSequence("run_item1")) )	
				end
			end
			self.loco:SetDesiredSpeed( 400 )
			self.loco:SetAcceleration(300)
		end
	elseif (IsValid(self:GetEnemy()) and (self:GetEnemy():Health() < 1) and self.Ready) then
		self:SetEnemy(nil)
	end
	self:NextThink(CurTime())
	return true
end

function ENT:HandleStuck()

	--
	-- Clear the stuck status
	--
	self.loco:ClearStuck()
	if (math.random(1,4) == 1) then
		if (self:HaveEnemy()) then
			self:SetPos(self:GetEnemy():GetPos() + Vector(0,0,10))
		end	
	else
		self.Enemy = nil
		self:FindEnemy()
	end
end

function ENT:ChaseEnemy( options )

	local options = options or {}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, self:GetEnemy():GetPos() )		-- Compute the path towards the enemies position

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() and self:HaveEnemy() ) do

		if ( path:GetAge() > 0.1 ) then					-- Since we are following the player we have to constantly remake the path
			path:Compute(self, self:GetEnemy():GetPos())-- Compute the path towards the enemy's position again
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
	if (math.random(1,20) == 1) then
		self:EmitSound("Halloween.HeadlessBossPain")
	end
	ParticleEffect( "halloween_boss_injured", dmginfo:GetDamagePosition(), self:GetAngles() )
end
function ENT:OnKilled( dmginfo )

	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	self.Ready = false
	self:PrecacheGibs()
	if (dmginfo:IsDamageType(DMG_DISSOLVE)) then

		ParticleEffect( "halloween_boss_death", self:GetPos(), self:GetAngles() )
		self:EmitSound("vo/halloween_boss/knight_death0"..math.random(1,2)..".mp3",95,100,1,CHAN_VOICE)
		PrintMessage(HUD_PRINTCENTER,"The Horseless Headless Horsemann has been defeated!\n")
		self:BecomeRagdoll(dmginfo)
		timer.Simple(0.1, function()
			self:Remove()
		end)
	else
		self:EmitSound("Halloween.HeadlessBossDying")
		if SERVER then
			self.Ready = false
			self:SetEnemy(nil)
			self.loco:SetDesiredSpeed( 0 )
			self.loco:SetAcceleration(0)
			self:StartActivity( ACT_DIESIMPLE )
			timer.Simple(0.1, function()
						
				if (!IsValid(self)) then return end

				timer.Simple(2.5,function()
			
					PrintMessage(HUD_PRINTCENTER,"The Horseless Headless Horsemann has been defeated!\n")
					ParticleEffect( "halloween_boss_death", self:GetPos(), self:GetAngles() )
					self:EmitSound("misc/halloween/spell_meteor_impact.wav",95,100,1,CHAN_ITEM)
					self:EmitSound("vo/halloween_boss/knight_death0"..math.random(1,2)..".mp3",95,100,1,CHAN_VOICE)
					for k,v in ipairs(player.GetAll()) do
						if SERVER then
							v:SendLua("LocalPlayer():EmitSound(\"ui/halloween_boss_defeated_fx.wav\")")
						end
					end
					local pos = self:GetPos()
					self:GibBreakServer(dmginfo:GetDamageForce() * 2)
					self:Remove()
		
				end)
			end)
		end
	end
end

list.Set( "NPC", "npc_headless_hatman", {
	Name = "Horseless Headless Horsemann",
	Class = "npc_headless_hatman",
	Category = "TF2: Halloween"
})