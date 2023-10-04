AddCSLuaFile()

PrecacheParticleSystem( "halloween_boss_summon" );
PrecacheParticleSystem( "halloween_boss_axe_hit_world" );
PrecacheParticleSystem( "halloween_boss_injured" );
PrecacheParticleSystem( "halloween_boss_death" );
PrecacheParticleSystem( "halloween_boss_foot_impact" );
PrecacheParticleSystem( "halloween_boss_eye_glow" );
ENT.Base 			= "base_nextbot"
ENT.Spawnable		= false
ENT.Model = "models/bots/merasmus/merasmus.mdl"
ENT.AttackDelay = 50
ENT.AttackDamage = 30
ENT.MeleeAttackRange = 300
ENT.RangedAttackRange = 800
ENT.MeleeAttackDelay2 = CurTime() + 1.1	
ENT.CrybabyMode = false
function ENT:Initialize()

	if CLIENT then

		killicon.Add( "headtaker", "backpack/weapons/c_models/c_headtaker/c_headtaker", Color( 255, 255, 255, 255 ) )
	
	end
	self:SetModel( self.Model )
	self:AddFlags(FL_OBJECT)
	local seq = "teleport_in"
	timer.Simple(0.25, function()
		if SERVER then
			for k,v in ipairs(ents.GetAll()) do
				if v:IsNPC() then
					v:AddEntityRelationship(self,D_HT,99)
				end
			end
		end
		self:ResetSequence(self:LookupSequence(seq))
		timer.Simple(self:SequenceDuration(self:LookupSequence("teleport_in")) - 0.1, function()
			self.Ready = true
			if SERVER then
				self:StartActivity(self:GetSequenceActivity(self:LookupSequence("stand_melee")))
			end
		end)
	end)
	self.Ready = false
	self.LoseTargetDist	= 9000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 6000	-- How far to search for enemies
	self:SetHealth(20000)
	self:EmitSound("Halloween.MerasmusAppears")
	self:EmitSound("Halloween.Merasmus_Float")
	self:SetModelScale(1)
	self:SetCollisionBounds(Vector(-24,-24,0),Vector(24,24,140))
	self:SetCollisionGroup(COLLISION_GROUP_NPC)
	self:SetSkin(1)
	for k,v in ipairs(player.GetAll()) do
		if SERVER then
			v:SendLua("LocalPlayer():EmitSound(\"ui/halloween_boss_summoned.wav\")")
		end
	end
	if SERVER then
		self:SetBloodColor(DONT_BLEED)
		PrintMessage(HUD_PRINTCENTER,"MERASMUS has appeared!\n")
		ParticleEffectAttach("merasmus_spawn", PATTACH_ABSORIGIN_FOLLOW, self, -1)
		ParticleEffectAttach("merasmus_ambient_body", PATTACH_ABSORIGIN_FOLLOW, self, -1)
	end
end
function ENT:GetAxe()
	return self:GetNWEntity("Axe")
end
function ENT:OnRemove()
	if (IsValid(self.bullseye)) then
		self.bullseye:Remove()
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
		if ( ( v:IsTFPlayer() and !v:IsNextBot() ) and GAMEMODE:EntityTeam(v) != TEAM_SPECTATOR and GAMEMODE:EntityTeam(v) != TEAM_FRIENDLY and v:Health() > 1 and !v:IsFlagSet(FL_NOTARGET) ) then
			if SERVER then
				for k,v in ipairs(ents.GetAll()) do
					if v:IsNPC() then
						v:AddEntityRelationship(self,D_HT,99)
					end
				end
			end
			-- We found one so lets set it as our enemy and return true
			local plrs = player.GetAll()
			if (v:IsPlayer()) then
				v = table.Random(plrs)
			end
			self:SetEnemy(v)
			if (v:IsNPC()) then
				v:SetEnemy(self.bullseye)
			elseif (v:IsNextBot()) then
				v:SetEnemy(self)
			end
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
				self:StartActivity( self:GetSequenceActivity(self:LookupSequence("run_melee")) )			-- Set the animation
				self.loco:SetDesiredSpeed( 500 )		-- Set the speed that we will be moving at. Don't worry, the animation will speed up/slow down to match
				self:ChaseEnemy( ) 						-- The new function like MoveToPos.
				self:StartActivity( self:GetSequenceActivity(self:LookupSequence("stand_melee")) )			-- Set the animation
				-- Now once the above function is finished doing what it needs to do, the code will loop back to the start
				-- unless you put stuff after the if statement. Then that will be run before it loops
			
			else


					-- Since we can't find an enemy, lets wander
					-- Its the same code used in Garry's test bot
					self:StartActivity( self:GetSequenceActivity(self:LookupSequence("run_melee")) )			-- Set the animation
					self.loco:SetDesiredSpeed( 230 )		-- Walk speed
					self.loco:SetAcceleration(450)
					self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 ) -- Walk to a random place within about 500 units (yielding)
					self:StartActivity( self:GetSequenceActivity(self:LookupSequence("stand_melee")) )			-- Set the animation
					if (math.random(1,8) == 1) then
						self:EmitSound("Halloween.MerasmusHidden")
					else
						self:SetHealth(
							self:Health() + 100
						)
					end

			end

			coroutine.wait(2)
		else
			-- At this point in the code the bot has stopped chasing the player or finished walking to a random spot
			-- Using this next function we are going to wait 2 seconds until we go ahead and repeat it 
			coroutine.wait(3)
		end
		
	end

end	

hook.Add( "ShouldCollide", "SkeletonCollision", function( ent1, ent2 )

    -- If players are about to collide with each other, then they won't collide.
    if ( ent1:GetClass() == "npc_tf_zombie" and ent2:GetClass() == "npc_tf_zombie" ) then return false end

end )
function ENT:EyeAngles()
	return self.EyeAngle
end


function ENT:BodyUpdate()

	local act = self:GetActivity()

	--
	-- This helper function does a lot of useful stuff for us.
	-- It sets the bot's move_x move_y pose parameters, sets their animation speed relative to the ground speed, and calls FrameAdvance.
	--
	if ( act == ACT_MP_RUN_MELEE || act == self:GetSequenceActivity(self:LookupSequence("run_item1")) ) then

		self:BodyMoveXY()

		-- BodyMoveXY() already calls FrameAdvance, calling it twice will affect animation playback, specifically on layers
		return

	end

	--
	-- If we're not walking or running we probably just want to update the anim system
	--
	self:FrameAdvance()

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
		self.EyeAngle = self:GetAngles()
	end
	if (IsValid(self:GetEnemy()) and self:GetEnemy():Health() < 0) then
		self:SetEnemy(nil)
	end
	if SERVER then
			
		for k,v in ipairs(ents.FindInSphere(self:GetPos(),self.MeleeAttackRange)) do

			if (IsValid(v) and (v:IsPlayer() or v:IsNextBot() or v:IsNPC()) and IsValid(self:GetEnemy()) and v:EntIndex() != self:GetEnemy():EntIndex() and v:EntIndex() != self:EntIndex() and self.Ready and SERVER) then
				self.loco:FaceTowards(v:GetPos())
				if (v:GetPos():Distance(self:GetPos()) < self.MeleeAttackRange and v:Health() > 0) then
					self.loco:FaceTowards(v:GetPos())
					if (IsValid(v) and (!self.MeleeAttackDelay or CurTime() > self.MeleeAttackDelay) and (!self.RangedAttackDelay2 or CurTime() > self.RangedAttackDelay2)) then
						if (math.random(1,3) == 1) then
							self:EmitSound(table.Random({"Halloween.MerasmusStaffAttack","Halloween.MerasmusStaffAttackRare"}))
						end
						self:AddGestureSequence(self:LookupSequence("melee_swing"),true)
						timer.Simple(0.19, function()
							if (!self.Ready) then return end
							if (!self:HaveEnemy()) then return end
							if (v:GetPos():Distance(self:GetPos()) < 200) then
								v:AddDeathFlag(DF_DECAP)
							end 
						end)
						timer.Simple(0.2, function()
							if (!self.Ready) then return end
							if (!self:HaveEnemy()) then return end
							if (v:GetPos():Distance(self:GetPos()) < 200) then
									local dmginfo = DamageInfo()
									dmginfo:SetAttacker(self)
									dmginfo:SetInflictor(self)
									dmginfo:SetDamageType(bit.bor(DMG_CLUB,DMG_SLASH))
									dmginfo:SetDamage(500)
									v:TakeDamageInfo(dmginfo) 
								if (v:IsBuilding()) then
									self:EmitSound("Halloween.HeadlessBossAxeHitWorld")
								else
									self:EmitSound("Halloween.HeadlessBossAxeHitFlesh")
								end
							end
		
						end)
						self.MeleeAttackDelay = CurTime() + 1.0
					end
				end
			elseif (!self.UsingBomb and v:GetPos():Distance(self:GetPos()) > self.MeleeAttackRange and v:GetPos():Distance(self:GetPos()) < self.RangedAttackRange and v:Health() > 0) then
						if (IsValid(v) and (!self.RangedAttackDelay or CurTime() > self.RangedAttackDelay)) then
							self.loco:FaceTowards(v:GetPos())
							self.UsingBomb = true
								self:EmitSound(table.Random({"Halloween.MerasmusGrenadeThrow","Halloween.MerasmusGrenadeThrowRare"}))
							ParticleEffectAttach( "merasmus_shoot", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("effect_hand_R") );
							self:AddGestureSequence(self:LookupSequence("item1_fire"),true)
							local staffBodyGroup = self:FindBodygroupByName("staff")
							self:SetBodygroup( staffBodyGroup, 2 );
							local bomb
							timer.Simple(0.3, function()
							
								bomb = ents.Create("prop_physics")
								local aimvec = self:EyePos() + Vector(0,0,120)
								local aimvec2 = self:GetAttachment( self:LookupAttachment("effect_hand_R") ).Ang:Forward()
								bomb:SetPos(aimvec + (self:GetAngles():Forward() * 32))
								bomb:SetModel("models/props_lakeside_event/bomb_temp.mdl")
								-- Set the angles to the player'e eye angles. Then spawn it.
								bomb:SetAngles( self:EyeAngles() )
								bomb:Spawn()
				
								-- Now get the physics object. Whenever we get a physics object
								-- we need to test to make sure its valid before using it.
								-- If it isn't then we'll remove the entity.
								local phys = bomb:GetPhysicsObject()
								if ( not phys:IsValid() ) then bomb:Remove() return end
							
								-- Now we apply the force - so the chair actually throws instead 
								-- of just falling to the ground. You can play with this value here
								-- to adjust how fast we throw it.
								-- Now that this is the last use of the aimvector vector we created,
								-- we can directly modify it instead of creating another copy
								aimvec2:Mul( math.random(1500,2000) )
								phys:ApplyForceCenter( aimvec2 )
			
							end)
							timer.Simple(0.8, function()
								if (!self:HaveEnemy()) then return end
								if (math.random(1,3) == 1) then
									self:EmitSound(table.Random({"Halloween.MerasmusCastFireSpell","Halloween.MerasmusCastFireSpell"}))
								end 
								self:SetBodygroup( staffBodyGroup, 0 );
								self:StartActivity(ACT_RANGE_ATTACK2)
								self.loco:SetDesiredSpeed( 0 )
								self.loco:SetAcceleration(0)
								self.Ready = false
								timer.Simple(self:SequenceDuration(self:SelectWeightedSequence(ACT_RANGE_ATTACK2)), function()
									if (self:Health() < 0) then return end
									self.Ready = true
									self.UsingBomb = false
								end)
								self.RangedAttackDelay2 = CurTime() + self:SequenceDuration(self:SelectWeightedSequence(ACT_RANGE_ATTACK2))
								timer.Simple(1.2, function()
									if (self:Health() < 0) then return end
									if (!self:HaveEnemy()) then bomb:Remove() return end
									self:EmitSound("Halloween.Merasmus_Spell")
									ParticleEffect( "merasmus_dazed_explosion", bomb:GetPos() + Vector(0,0,30), bomb:GetAngles() )
									bomb:EmitSound("TF_BaseExplosionEffect.Sound")
									for k,v in ipairs(ents.FindInSphere(bomb:GetPos(), 160)) do
										if (v:IsTFPlayer() and v:EntIndex() != self:EntIndex()) then
											local dmginfo = DamageInfo()
											dmginfo:SetAttacker(self)
											dmginfo:SetInflictor(self)
											dmginfo:SetDamageType(DMG_BLAST)
											dmginfo:SetDamage(95)
											v:TakeDamageInfo(dmginfo) 
											v:SetLocalVelocity(v:GetVelocity() + Vector(0,0,800))
											if (v:Health() > 0) then
												GAMEMODE:IgniteEntity(v, self, self, 8)
											end
										end
									end
									for k,v in ipairs(ents.FindInSphere(bomb:GetPos(), self.RangedAttackRange)) do
										if (v:IsTFPlayer() and v:EntIndex() != self:EntIndex()) then
											local dmginfo = DamageInfo()
											dmginfo:SetAttacker(self)
											dmginfo:SetInflictor(self)
											dmginfo:SetDamageType(bit.bor(DMG_GENERIC,DMG_BURN,DMG_DISSOLVE))
											dmginfo:SetDamage(35)
											v:TakeDamageInfo(dmginfo) 
											v:SetLocalVelocity(v:GetVelocity() + Vector(0,0,800))
											if (v:Health() > 0) then
												GAMEMODE:IgniteEntity(v, self, self, 8)
											end
										end
									end
									bomb:Remove()
								end)
			
							end)
							self.RangedAttackDelay = CurTime() + 6
						end
			end
			
		end 
	end
	if (IsValid(self:GetEnemy()) and self.Ready and SERVER) then
		if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.MeleeAttackRange and self:GetEnemy():Health() > 0) then
			self.loco:FaceTowards(self:GetEnemy():GetPos())
			if (IsValid(self:GetEnemy()) and (!self.MeleeAttackDelay or CurTime() > self.MeleeAttackDelay) and (!self.RangedAttackDelay2 or CurTime() > self.RangedAttackDelay2)) then
				if (math.random(1,3) == 1) then
					self:EmitSound(table.Random({"Halloween.MerasmusStaffAttack","Halloween.MerasmusStaffAttackRare"}))
				end
				self:AddGestureSequence(self:LookupSequence("melee_swing"),true)
				timer.Simple(0.19, function()
					if (!self.Ready) then return end
					if (!self:HaveEnemy()) then return end
					if (self:GetEnemy():GetPos():Distance(self:GetPos()) < 200) then
						self:GetEnemy():AddDeathFlag(DF_DECAP)
					end
				end)
				timer.Simple(0.2, function()
					if (!self.Ready) then return end
					if (!self:HaveEnemy()) then return end
					if (self:GetEnemy():GetPos():Distance(self:GetPos()) < 200) then
							local dmginfo = DamageInfo()
							dmginfo:SetAttacker(self)
							dmginfo:SetInflictor(self)
							dmginfo:SetDamageType(bit.bor(DMG_CLUB,DMG_SLASH))
							dmginfo:SetDamage(500)
							self:GetEnemy():TakeDamageInfo(dmginfo) 
						if (self:GetEnemy():IsBuilding()) then
							self:EmitSound("Halloween.HeadlessBossAxeHitWorld")
						else
							self:EmitSound("Halloween.HeadlessBossAxeHitFlesh")
						end
					end

				end)
				self.MeleeAttackDelay = CurTime() + 1.0
			end
		elseif (!self.UsingBomb and self:GetEnemy():GetPos():Distance(self:GetPos()) > self.MeleeAttackRange and self:GetEnemy():GetPos():Distance(self:GetPos()) < self.RangedAttackRange and self:GetEnemy():Health() > 0) then
			if (IsValid(self:GetEnemy()) and (!self.RangedAttackDelay or CurTime() > self.RangedAttackDelay)) then
				self.loco:FaceTowards(self:GetEnemy():GetPos())
				self.UsingBomb = true
					self:EmitSound(table.Random({"Halloween.MerasmusGrenadeThrow","Halloween.MerasmusGrenadeThrowRare"}))
				ParticleEffectAttach( "merasmus_shoot", PATTACH_POINT_FOLLOW, self, self:LookupAttachment("effect_hand_R") );
				self:AddGestureSequence(self:LookupSequence("item1_fire"),true)
				local staffBodyGroup = self:FindBodygroupByName("staff")
				self:SetBodygroup( staffBodyGroup, 2 );
				local bomb
				timer.Simple(0.3, function()
				
					bomb = ents.Create("prop_physics")
					local aimvec = self:EyePos() + Vector(0,0,120)
					local aimvec2 = self:GetAttachment( self:LookupAttachment("effect_hand_R") ).Ang:Forward()
					bomb:SetPos(aimvec + (self:GetAngles():Forward() * 32))
					bomb:SetModel("models/props_lakeside_event/bomb_temp.mdl")
					-- Set the angles to the player'e eye angles. Then spawn it.
					bomb:SetAngles( self:EyeAngles() )
					bomb:Spawn()
	
					-- Now get the physics object. Whenever we get a physics object
					-- we need to test to make sure its valid before using it.
					-- If it isn't then we'll remove the entity.
					local phys = bomb:GetPhysicsObject()
					if ( not phys:IsValid() ) then bomb:Remove() return end
				
					-- Now we apply the force - so the chair actually throws instead 
					-- of just falling to the ground. You can play with this value here
					-- to adjust how fast we throw it.
					-- Now that this is the last use of the aimvector vector we created,
					-- we can directly modify it instead of creating another copy
					aimvec2:Mul( math.random(1500,2000) )
					phys:ApplyForceCenter( aimvec2 )

				end)
				timer.Simple(0.8, function()
					if (!self:HaveEnemy()) then return end
					if (math.random(1,3) == 1) then
						self:EmitSound(table.Random({"Halloween.MerasmusCastFireSpell","Halloween.MerasmusCastFireSpell"}))
					end 
					self:SetBodygroup( staffBodyGroup, 0 );
					self:StartActivity(ACT_RANGE_ATTACK2)
					self.loco:SetDesiredSpeed( 0 )
					self.loco:SetAcceleration(0)
					self.Ready = false
					timer.Simple(self:SequenceDuration(self:SelectWeightedSequence(ACT_RANGE_ATTACK2)), function()
						if (self:Health() < 0) then return end
						self.Ready = true
						self.UsingBomb = false
					end)
					self.RangedAttackDelay2 = CurTime() + self:SequenceDuration(self:SelectWeightedSequence(ACT_RANGE_ATTACK2))
					timer.Simple(1.2, function()
						if (self:Health() < 0) then return end
						if (!self:HaveEnemy()) then bomb:Remove() return end
						self:EmitSound("Halloween.Merasmus_Spell")
						ParticleEffect( "merasmus_dazed_explosion", bomb:GetPos() + Vector(0,0,30), bomb:GetAngles() )
						bomb:EmitSound("TF_BaseExplosionEffect.Sound")
						for k,v in ipairs(ents.FindInSphere(bomb:GetPos(), 160)) do
							if (v:IsTFPlayer() and v:EntIndex() != self:EntIndex()) then
								local dmginfo = DamageInfo()
								dmginfo:SetAttacker(self)
								dmginfo:SetInflictor(self)
								dmginfo:SetDamageType(DMG_BLAST)
								dmginfo:SetDamage(95)
								v:TakeDamageInfo(dmginfo) 
								v:SetLocalVelocity(v:GetVelocity() + Vector(0,0,800))
								if (v:Health() > 0) then
									GAMEMODE:IgniteEntity(v, self, self, 8)
								end
							end
						end
						for k,v in ipairs(ents.FindInSphere(bomb:GetPos(), self.RangedAttackRange)) do
							if (v:IsTFPlayer() and v:EntIndex() != self:EntIndex()) then
								local dmginfo = DamageInfo()
								dmginfo:SetAttacker(self)
								dmginfo:SetInflictor(self)
								dmginfo:SetDamageType(bit.bor(DMG_GENERIC,DMG_BURN,DMG_DISSOLVE))
								dmginfo:SetDamage(35)
								v:TakeDamageInfo(dmginfo) 
								v:SetLocalVelocity(v:GetVelocity() + Vector(0,0,800))
								if (v:Health() > 0) then
									GAMEMODE:IgniteEntity(v, self, self, 8)
								end
							end
						end
						bomb:Remove()
					end)

				end)
				self.RangedAttackDelay = CurTime() + 6
			end
		end
		if (self:GetEnemy():GetPos():Distance(self:GetPos()) < 000 and self:GetEnemy():Health() > 0) then
			if (self:GetSequence() != self:LookupSequence("stand_melee")) then
				self:StartActivity( self:GetSequenceActivity(self:LookupSequence("stand_melee")) )
			end
			self.loco:SetDesiredSpeed( 0 )
			self.loco:SetAcceleration(0)
		elseif (self:GetEnemy():GetPos():Distance(self:GetPos()) > 100 and self:GetEnemy():Health() > 0) then
			if (self.CrybabyMode) then

				if (self:GetSequence() != self:LookupSequence("run_melee")) then
					self:StartActivity( self:GetSequenceActivity(self:LookupSequence("run_melee")) )	
				end

			else
				if (self:GetSequence() != self:LookupSequence("run_melee")) then
					self:StartActivity( self:GetSequenceActivity(self:LookupSequence("run_melee")) )	
				end
			end
			self.loco:SetDesiredSpeed( 500 )
			self.loco:SetAcceleration(300)
		end
	elseif (IsValid(self:GetEnemy()) and (self:GetEnemy():Health() < 0) and self.Ready) then
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
			self.Ready = false
			self.UsingBomb = false
			self:PlaySequenceAndWait("teleport_out")
			if (!IsValid(self:GetEnemy())) then return end
			ParticleEffect( "merasmus_tp", self:GetPos(), self:GetAngles() )
			self.MeleeAttackDelay = CurTime() + 2
			self.RangeAttackDelay = CurTime() + 2
			self:EmitSound("Halloween.Merasmus_TP_Out")
			self:SetPos(self:GetEnemy():GetPos() + Vector(0,0,90))
			ParticleEffect( "merasmus_tp", self:GetPos(), self:GetAngles() )
			if (!IsValid(self:GetEnemy())) then return end
			self:EmitSound("Halloween.Merasmus_TP_In")
			self:PlaySequenceAndWait("teleport_in")
			self.Ready = true
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
	ParticleEffect( "merasmus_blood", dmginfo:GetDamagePosition(), self:GetAngles() )
	
	if not self.NextFlinch or CurTime() > self.NextFlinch then
		self:AddGesture(ACT_MP_GESTURE_FLINCH_CHEST)
		self.NextFlinch = CurTime() + 0.5
	end
end
function ENT:OnKilled( dmginfo )

	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	self.Ready = false
	self.UsingBomb = true
	self:PrecacheGibs()
	timer.Simple(0.1, function()
		if SERVER then
			self:SetEnemy(nil)
			self.loco:SetDesiredSpeed( 0 )
			self.loco:SetAcceleration(0)
			self:EmitSound("Halloween.Merasmus_Death")
			self:EmitSound("Halloween.MerasmusBanish")
			timer.Simple(0.1, function()
			
				if (!IsValid(self)) then return end

				self:StartActivity( ACT_DIESIMPLE )
				timer.Simple(self:SequenceDuration(self:LookupSequence("death")) - 0.1,function()
			
					ParticleEffect( "merasmus_tp", self:GetPos(), self:GetAngles() )
					PrintMessage(HUD_PRINTCENTER,"MERASMUS has been defeated!\n")
					self:EmitSound("Halloween.Merasmus_TP_Out")
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
	end)
end

list.Set( "NPC", "npc_merasmus", {
	Name = "MERASMUS!",
	Class = "npc_merasmus",
	Category = "TF2: Halloween"
})