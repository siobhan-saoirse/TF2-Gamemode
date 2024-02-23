AddCSLuaFile()
if (!IsMounted("left4dead2")) then return end

local function lookForNextPlayer(ply)
	local npcs = {}
	if (math.random(1,8) == 1) then
		for k,v in ipairs(ents.FindInSphere( ply:GetPos(), ply.SearchRadius )) do
			if (v:IsTFPlayer() and !v:IsNextBot() and v:EntIndex() != ply:EntIndex()) then
				if (v:Health() > 1) then
					table.insert(npcs, v)
				end
			end
		end
	end
	return npcs
end
local function nearestNPC(ply)
	local npcs = {}
	if (math.random(1,8) == 1) then
		for k,v in ipairs(ents.FindInSphere( ply:GetPos(), ply.SearchRadius )) do
			if (v:IsNPC() and !v:IsNextBot() and v:EntIndex() != ply:EntIndex()) then
				if (v:Health() > 1) then
					table.insert(npcs, v)
				end
			end
		end
	end
	return npcs
end
local function nearestDoor(ply)
	local npcs = {}
	if (math.random(1,8) == 1) then
		for k,v in ipairs(ents.FindInSphere(ply:GetPos(),120)) do
			if (v:GetClass() == "prop_door_rotating" and v:GetPos():Distance(ply:GetPos()) < 70) then
				table.insert(npcs, v)
			end
		end
	end
	return npcs
end

local function nearestPipebomb(ply)
	local npcs = {}
	if (math.random(1,8) == 1) then
		for k,v in ipairs(ents.FindInSphere(ply:GetPos(),2600)) do
			if ((!string.find(v:GetClass(),"weapon_") and (string.find(v:GetClass(),"grenade") or string.find(v:GetClass(),"pipe") or string.find(v:GetClass(),"bomb"))) or (v:IsTFPlayer() and v:EntIndex() != ply:EntIndex() and (v:HasPlayerState(PLAYERSTATE_JARATED) or v:HasPlayerState(PLAYERSTATE_PUKEDON)))) then
				table.insert(npcs, v)
			end
		end
	end
	return npcs
end


ENT.Base 			= "base_nextbot"
ENT.Spawnable		= false
ENT.AttackDelay = 50
ENT.AttackDamage = 8
ENT.AttackRange = 85
ENT.AutomaticFrameAdvance = true
ENT.HaventLandedYet = false
ENT.Walking = false
ENT.IsRightArmCutOff = false
ENT.IsLeftArmCutOff = false
local modeltbl = {
	"models/infected/witch.mdl"
}

hook.Add("EntityEmitSound","InfectedHearSound",function(snd)
	if (IsValid(snd.Entity)) then
		if (snd.Entity:IsTFPlayer() and GAMEMODE:EntityTeam(snd.Entity) != TEAM_GREEN) then

			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),1300)) do
				if (v:IsPlayer() and v:IsL4D() and !IsValid(v.TargetEnt) and v.TFBot) then
					v.TargetEnt = snd.Entity

					if SERVER then
						for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end
					end
				end
			end

		end
		if (snd.Entity:IsTFPlayer() and !snd.Entity:IsNextBot()) then
			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
				if (v:GetClass() == "witch" and !IsValid(v:GetEnemy()) and v.Ready) then
					v:SetEnemy(snd.Entity)
	
					if SERVER then
						local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
						v:AddGestureSequence(anim,true)
					end
	
					timer.Stop("IdleExpression"..v:EntIndex())
					timer.Stop("AngryExpression"..v:EntIndex())
					timer.Create("AngryExpression"..v:EntIndex(), 3, 0, function()
						
						if SERVER then
							local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
							v:AddGestureSequence(anim,true)
						end
	
						timer.Adjust("AngryExpression"..v:EntIndex(),v:SequenceDuration(anim))
					end)
					if SERVER then
						for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end
					end
				end
			end
		end
	end
end)
function ENT:IsNPC()
	return true
end
function ENT:Initialize()

	if SERVER then
		if (!self.DontReplaceModel) then
			self:SetModel( table.Random(modeltbl) )
		end
	end
	self.LoseTargetDist	= 600	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 2000	-- How far to search for enemies
	self:SetHealth(1000) 
	if SERVER then
		--[[
		if (math.random(1,4) == 1) then
			self:SetColor(Color(255,255,0))
			self:SetRenderMode( RENDERMODE_TRANSALPHADD )
		elseif (math.random(1,6) == 1) then
			self:SetColor(Color(128,128,0))
			self:SetRenderMode( RENDERMODE_TRANSALPHADD )
		end]]
		self:SetFOV(90)
		self:SetBloodColor(BLOOD_COLOR_RED)
		self:AddFlags(FL_OBJECT)
		self:AddFlags(FL_NPC)
		if SERVER then
			for k,v in ipairs(ents.GetAll()) do
				if v:IsNPC() then
					v:AddEntityRelationship(self,D_HT,99)
				end
			end
		end
		self:SetBodygroup(0,math.random(1,2))
		self:SetBodygroup(1,math.random(1,2))
		self:StartActivity( self:GetSequenceActivity(self:LookupSequence("idle_sitting")) )
		self.Ready = true
	end	
end

function ENT:HandleStuck()
	--
	-- Clear the stuck status
	--
	if (IsValid(self:GetEnemy())) then
		local pos = self:FindSpot("near", {pos=self:GetEnemy():GetPos(),radius = 12000,type="hiding",stepup=800,stepdown=800})
		self:SetPos(pos)
	else
		self:SetPos(self:GetPos() + self:GetForward()*(table.Random({50,100}) or 0) + self:GetRight()*(table.Random({50,100}) or 0))
	end
	self.loco:ClearStuck() 
end


function ENT:OnRemove()
	timer.Stop("IdleExpression"..self:EntIndex())
	timer.Stop("AngryExpression"..self:EntIndex())
	if (IsValid(self.bullseye)) then
		self.bullseye:Remove()
	end
end

----------------------------------------------------
-- ENT:Get/SetEnemy()
-- Simple functions used in keeping our enemy saved
----------------------------------------------------
function ENT:SetEnemy(ent)
	if (!self.SoonToBeRetreating && !self.Retreating and IsValid(ent)) then
		if ent:IsL4D() then return end
		if (self:Visible(ent)) then
			self.Enemy = ent
		end
		for k,v in ipairs(nearestNPC(self)) do
			if v:IsNPC() then
				v:AddEntityRelationship(self,D_HT,99)
			end
		end
	end
end
function ENT:GetEnemy()
	return self.Grenade or self.Enemy
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
		elseif ( self:GetEnemy():IsTFPlayer() and (GAMEMODE:EntityTeam(self:GetEnemy()) == TEAM_SPECTATOR or GAMEMODE:EntityTeam(self:GetEnemy()) == TEAM_FRIENDLY or self:GetEnemy():Health() < 1 or self:GetEnemy():IsFlagSet(FL_NOTARGET)) ) then
			return self:FindEnemy()
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
	local _ents = lookForNextPlayer(self)
	-- Here we loop through every entity the above search finds and see if it's the one we want
	if (self.Angry) then
		timer.Stop("ShredMyVictimToGibs"..self:EntIndex())
		if (!self.SoonToBeRetreating and !self.Retreating) then
			self:StartActivity( self:GetSequenceActivity(self:LookupSequence("Idle_Pre_Retreat"))  )
			self.WillIShredMyEnemyToGibs = false
			self.SoonToBeRetreating = true
			self.Angry = false
			self:EmitSound("WitchZombie.RetreatHorror")
			timer.Simple(2.5, function()
				self.SoonToBeRetreating = false
				self.Retreating = true
				self:StartActivity( self:GetSequenceActivity(self:LookupSequence("Run_Retreat"))  )			-- Set the animation
				self:EmitSound("WitchZombie.RetreatHorror")
			end)
		end
	end
		for k,v in ipairs( _ents ) do
			if ( ( v:IsPlayer() or v:IsNPC()) and !v:IsFriendly(self) and GAMEMODE:EntityTeam(v) != TEAM_SPECTATOR and GAMEMODE:EntityTeam(v) != TEAM_FRIENDLY and v:Health() > 0 and !v:IsFlagSet(FL_NOTARGET) ) then
				-- We found one so lets set it as our enemy and return true
				self:SetEnemy(v)
				if (v:IsNPC()) then
					if (!IsValid(v:GetEnemy())) then
						v:SetEnemy(self)
						v:AddEntityRelationship(self,D_HT,99)
					end
				end

				if SERVER then
					for _,npc in ipairs(ents.FindByClass("npc_*")) do

						npc:SetEnemy(self)

					end
					local anim = self:LookupSequence("exp_angry_0"..math.random(1,6))
					self:AddGestureSequence(anim,true)
				end

				timer.Stop("IdleExpression"..self:EntIndex())
				timer.Stop("AngryExpression"..self:EntIndex())
				timer.Create("AngryExpression"..self:EntIndex(), 3, 0, function()
					
					if SERVER then
						local anim = self:LookupSequence("exp_angry_0"..math.random(1,6))
						self:AddGestureSequence(anim,true)
					end

					timer.Adjust("AngryExpression"..self:EntIndex(),self:SequenceDuration(anim))
				end)
				return true
			end
		end	
	
	-- We found nothing so we will set our enemy as nil (nothing) and return false
	self:SetEnemy(nil)
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
function ENT:HandleAnimEvent( event, eventTime, cycle, type, options )
	if (event == 3001) then
		if (IsValid(self:GetEnemy())) then
			if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange and self:GetEnemy():Health() > 0) then
				if (self.Grenade != nil and !self.Grenade:IsTFPlayer() and self:GetEnemy():EntIndex() == self.Grenade:EntIndex()) then return end
				self.loco:ClearStuck() 
				self:EmitSound(
					table.Random(
						{
							"WitchZombie.ShredVictim",
						}
					),
					85, 100
				)
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker(self)
				dmginfo:SetInflictor(self)
				dmginfo:SetDamageType(bit.bor(DMG_SLASH,DMG_CLUB))
				dmginfo:SetDamage(self.AttackDamage)
				self:GetEnemy():TakeDamageInfo(dmginfo) 
				if (self:GetEnemy():IsPlayer()) then
					self:GetEnemy():SetClassSpeed(1)
					self:GetEnemy():SetViewOffset(Vector(0, 0, 28 * self:GetEnemy():GetModelScale()))
					self:GetEnemy():SetMoveType(MOVETYPE_NONE)
					if (!self.WillIShredMyEnemyToGibs) then
						self:StartActivity( self:GetSequenceActivity(self:LookupSequence("killing_blow_display"))  )
						self.WillIShredMyEnemyToGibs = true
						self:EmitSound("WitchZombie.RageBeforeKillingFrenzy")
						timer.Simple(3.5, function()
							self:StartActivity( self:GetSequenceActivity(self:LookupSequence("killing_blow_loop"))  )
							self:EmitSound("WitchZombie.KillingFrenzy")
							timer.Create("ShredMyVictimToGibs"..self:EntIndex(), 0.6, 0, function()
								self:StartActivity( self:GetSequenceActivity(self:LookupSequence("killing_blow_loop"))  )
								self:EmitSound("WitchZombie.KillingFrenzy")
								if (self:GetEnemy():Health() < 1) then
						
									self.WillIShredMyEnemyToGibs = false
									timer.Stop("ShredMyVictimToGibs"..self:EntIndex())
									self:FindEnemy() 
						
								end
							end)
						end)
					end
				end
			else 
				self:EmitSound("L4D_Zombie.AttackMiss")
			end
		else
			self:EmitSound("L4D_Zombie.AttackMiss")
		end
	end
end

function ENT:IsNPC() 
	return true
end
hook.Add("ScaleNPCDamage","InfectedDamage2",function(npc,hitgroup,dmginfo)
	
	if (npc:GetClass() == "witch") then	
		if (hitgroup == HITGROUP_HEAD) then
			npc.WasShotInTheHead = true
			dmginfo:ScaleDamage(2)
		end
	end
end)
----------------------------------------------------
-- ENT:RunBehaviour()
-- This is where the meat of our AI is
----------------------------------------------------
function ENT:RunBehaviour()
	-- This function is called when the entity is first spawned. It acts as a giant loop that will run as long as the NPC exists
	while ( true ) do
		-- Lets use the above mentioned functions to see if we have/can find a enemy
		if self.Ready then 
			
			if (self.Retreating) then

				
				self.loco:SetDesiredSpeed( 500 )		-- Set the speed that we will be moving at. Don't worry, the animation will speed up/slow down to match
				self.loco:SetAcceleration(500)
				self:MoveToPos(self:FindSpot("random", {pos=self:GetPos(),radius = 8000,type="hiding",stepup=800,stepdown=800}))
				self:StartActivity( self:GetSequenceActivity(self:LookupSequence("Run_Retreat"))  )			-- Set the animation
				if (self:IsOnGround() and self.Ready) then
					if (string.find(self:GetModel(),"female")) then
						self:StartActivity( self:GetSequenceActivity(self:LookupSequence("idle")) )			-- Set the animation
					else
						self:StartActivity( self:GetSequenceActivity(self:LookupSequence("idle")) )			-- Set the animation
					end
				end
			else
				if ( self:HaveEnemy() ) then
					-- Now that we have an enemy, the code in this block will run
					self.loco:FaceTowards(self:GetEnemy():GetPos())	-- Face our enemy
					if (!self.Angry) then

						if (!self.Alert) then
							self:EmitSound("WitchZombie.Surprised")
							self:StartActivity( self:GetSequenceActivity(self:LookupSequence("agitated"))  )			-- Set the animation
							self.Alert = true

							timer.Create("Growl"..self:EntIndex(), 1.2, 0, function()
								if (self:GetEnemy():GetPos():Distance(self:GetPos()) > 150 and self:GetEnemy():GetPos():Distance(self:GetPos()) < 230) then
									self:EmitSound("WitchZombie.GrowlMedium")
									self:StartActivity( self:GetSequenceActivity(self:LookupSequence("agitated"))  )			-- Set the animation
									timer.Adjust("Growl"..self:EntIndex(), 1)
									self.BecomingMad = false
								elseif (self:GetEnemy():GetPos():Distance(self:GetPos()) < 150) then
									self:EmitSound("WitchZombie.GrowlHigh")
									self:StartActivity( self:GetSequenceActivity(self:LookupSequence("agitated_02"))  )			-- Set the animation
									timer.Adjust("Growl"..self:EntIndex(), 1.8)
									if (math.random(1,10) == 1) then

										if (!self.Angry) then
											self:StartActivity( self:GetSequenceActivity(self:LookupSequence("Wander_acquire")) )
											self:EmitSound("WitchZombie.Scream")
											timer.Stop("Growl"..self:EntIndex())
											timer.Simple(1, function()
												self:EmitSound("WitchZombie.Rage")
												self.Angry = true
											end)
										end

									end
									self.BecomingMad = true
								else
									self:EmitSound("WitchZombie.GrowlLow")
									self:StartActivity( self:GetSequenceActivity(self:LookupSequence("agitated"))  )			-- Set the animation
									timer.Adjust("Growl"..self:EntIndex(), 1.2)
									self.BecomingMad = false
								end
							end)
						end
					else
						if (self:IsOnGround()) then
							if (string.find(self:GetModel(),"mud")) then

								self:StartActivity( self:GetSequenceActivity(self:LookupSequence("run"))  )			-- Set the animation

							else
								self:StartActivity( self:GetSequenceActivity(self:LookupSequence("run"))  )			-- Set the animation
							end
						end
						self.loco:SetDesiredSpeed( 500 )		-- Set the speed that we will be moving at. Don't worry, the animation will speed up/slow down to match
						self.loco:SetAcceleration(500)
						self:ChaseEnemy( ) 						-- The new function like MoveToPos.
						if (self:IsOnGround() and self.Ready) then
							if (string.find(self:GetModel(),"female")) then
								self:StartActivity( self:GetSequenceActivity(self:LookupSequence("idle")) )			-- Set the animation
							else
								self:StartActivity( self:GetSequenceActivity(self:LookupSequence("idle")) )			-- Set the animation
							end
						end
					end
					-- Now once the above function is finished doing what it needs to do, the code will loop back to the start
					-- unless you put stuff after the if statement. Then that will be run before it loops
					coroutine.wait(0.01)
				elseif (self.Retreating) then

					if (self:IsOnGround()) then
						if (string.find(self:GetModel(),"mud")) then
	
							self:StartActivity( self:GetSequenceActivity(self:LookupSequence("Run_Retreat"))  )			-- Set the animation
	
						else
							self:StartActivity( self:GetSequenceActivity(self:LookupSequence("Run_Retreat"))  )			-- Set the animation
						end
					end
					self.loco:SetDesiredSpeed( 350 )		-- Set the speed that we will be moving at. Don't worry, the animation will speed up/slow down to match
					self.loco:SetAcceleration(500)
					self:MoveToPos(self:FindSpot("random", {pos=self:GetPos(),radius = 8000,type="hiding",stepup=800,stepdown=800}))
					if (self:IsOnGround() and self.Ready) then
						if (string.find(self:GetModel(),"female")) then
							self:StartActivity( self:GetSequenceActivity(self:LookupSequence("idle")) )			-- Set the animation
						else
							self:StartActivity( self:GetSequenceActivity(self:LookupSequence("idle")) )			-- Set the animation
						end
					end

				else
					-- Since we can't find an enemy, lets wander
					-- Its the same code used in Garry's test bot
					if (math.random(1,80) == 1 and !self.Walking) then
						self:StartActivity( self:GetSequenceActivity(self:LookupSequence("walk_01")) )
						self.loco:SetDesiredSpeed( 20 )		-- Walk speed
						self.loco:SetAcceleration(150)
						self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 ) -- Walk to a random place within about 400 units (yielding)
						self.Walking = true
					else
						self.Walking = false
					end
					coroutine.wait(2)
				end

			end
		
		else

			if (self:IsOnFire() and !string.find(self:GetModel(),"ceda")) then

				-- Since we can't find an enemy, lets wander
				-- Its the same code used in Garry's test bot
				self:StartActivity( self:GetSequenceActivity(self:LookupSequence("run_onfire")) )
				self.loco:SetDesiredSpeed( 50 )		-- Walk speed
				self.loco:SetAcceleration(900)
				self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 ) -- Walk to a random place within about 400 units (yielding)
			elseif (self.ContinueRunning and !self:IsOnFire()) then
				-- Now that we have an enemy, the code in this block will run
				self.loco:FaceTowards(self:GetEnemy():GetPos())	-- Face our enemy
				self:ChaseEnemy( ) 						-- The new function like MoveToPos.
				-- Now once the above function is finished doing what it needs to do, the code will loop back to the start
				-- unless you put stuff after the if statement. Then that will be run before it loops
			end
			timer.Stop("AngryExpression"..self:EntIndex())
			coroutine.wait(0.01)
		end
		-- At this point in the code the bot has stopped chasing the player or finished walking to a random spot
		-- Using this next function we are going to wait 2 seconds until we go ahead and repeat it 
		
	end

end	

hook.Add( "ShouldCollide", "SkeletonCollision", function( ent1, ent2 )

    -- If players are about to collide with each other, then they won't collide.
    if ( ent1:GetClass() == "npc_tf_zombie" and ent2:GetClass() == "npc_tf_zombie" ) then return false end

end )

----------------------------------------------------
-- ENT:ChaseEnemy()
-- Works similarly to Garry's MoveToPos function
--  except it will constantly follow the
--  position of the enemy until there no longer
--  is one.
----------------------------------------------------
function ENT:Think()
	if SERVER then
		
		if (IsValid(self.Door2)) then

			self.loco:ClearStuck() 
			self:EmitSound(
				"Doors.Wood.Pound1",
				85, 100
			)
			debugoverlay.Text( self:GetPos(), "Breaking down door #"..self.Door2:EntIndex().."!", 1.5,false )
			debugoverlay.Box( self.Door2:GetPos(), self.Door2:OBBMins(), self.Door2:OBBMaxs(), 1.5, Color( 128, 0, 0, 128) )
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				debugoverlay.Text( self:GetPos(), "I broke it down! #"..self.Door2:EntIndex().."", 1.5,false )
				debugoverlay.Box( self.Door2:GetPos(), self.Door2:OBBMins(), self.Door2:OBBMaxs(), 1.5, Color( 0, 255, 0, 128) )
				self.Ready = true
				local p = ents.Create("prop_physics")
				p:SetModel(self.Door2:GetModel())
				p:SetBodygroup(1, 1)
				p:SetSkin(self.Door2:GetSkin())
				p:SetPos(self.Door2:GetPos())
				p:SetAngles(self.Door2:GetAngles())
				
				OpenLinkedAreaPortal(self.Door2)
				self.Door2:Remove()
				p:Spawn()
				
				local vel = self:EyePos():Angle()
				vel.p = vel.p
				vel = vel:Forward() * -1100 

				
				local phys = p:GetPhysicsObject()
				if phys then
					p:GetPhysicsObject():AddVelocity(vel)
					p:SetPhysicsAttacker(self)
				end
				self:SetCollisionGroup(COLLISION_GROUP_NPC)

		end
		if (self.SoonToBeRetreating || self.Retreating) then
			self:SetEnemy(nil)
			self.WillIShredMyEnemyToGibs = false
		end
		if (self.Angry) then
			if (!IsValid(self:GetEnemy()) or self:GetEnemy():Health() < 1) then

				self.WillIShredMyEnemyToGibs = false
				timer.Stop("ShredMyVictimToGibs"..self:EntIndex())
				self:FindEnemy() 

			end
		end
		if (GAMEMODE:EntityTeam(self.Enemy) == TEAM_GREEN and !(self.Enemy:HasPlayerState(PLAYERSTATE_JARATED) and self.Enemy:HasPlayerState(PLAYERSTATE_PUKEDON))) then 
			self.Enemy = nil
			self:FindEnemy() 
		end
		self:SetNWInt( 'NetworkedActivity', self:GetActivity() )
		self.loco:SetGravity( 700 )
		self.loco:SetJumpHeight( 200 )
		for k, v in pairs(nearestDoor(self)) do
			if (IsValid(v)) then
				-- open a door if we see one blocking our path
				local targetpos = v:GetPos() + Vector(0, 0, 45)
				if util.TraceLine({start = self:EyePos(), endpos = targetpos, filter = function( ent ) return ent == v end}).Entity == v then
					self.Door2 = v
				end
			end
		end
		if (!IsValid(self:GetEnemy()) and self:IsOnGround() and self.Ready and !self.WillIShredMyEnemyToGibs and !self.Retreating) then
			if (self:GetCycle() == 1 and !self.Walking) then
				self:StartActivity( self:GetSequenceActivity(self:LookupSequence("idle_sitting")) )
			elseif (self:GetCycle() == 1) then

				timer.Create("IdleExpression"..self:EntIndex(), 0, 0, function()
					
					local anim = self:LookupSequence("exp_idle_0"..math.random(1,6))
					if SERVER then
						self:AddGestureSequence(anim,true)
					end
			
					
					timer.Adjust("IdleExpression"..self:EntIndex(),self:SequenceDuration(anim))
				end)

			end
		end
		if (IsValid(self.AvoidingEntity) and self.AvoidingEntity:GetPos():Distance(self:GetPos()) > 120 ) then
			self.AvoidingEntity = nil
			self:SetCollisionGroup(COLLISION_GROUP_NPC)
		end
		if (!self:IsOnGround()) then
			if (!self.HaventLandedYet) then
				self:ResetSequence("fall_05")
				self.HaventLandedYet = true
			end
		else
			if (self.HaventLandedYet) then
				local anim = self:LookupSequence("landing01")
				if (IsValid(self:GetEnemy())) then
					anim = self:LookupSequence("landing0"..math.random(2,4))
				end
				self:ResetSequence(anim)
				timer.Simple(self:SequenceDuration(anim) - 0.2, function()
					if (IsValid(self:GetEnemy())) then
						if (self.loco:IsUsingLadder()) then
							self:StartActivity( self:GetSequenceActivity(self:LookupSequence("Ladder_Ascend"))  )			-- Set the animation
						else
							if (self:IsOnGround()) then
								if (string.find(self:GetModel(),"mud")) then
			
									self:StartActivity( self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  )			-- Set the animation
			
								else
									self:StartActivity( self:GetSequenceActivity(self:LookupSequence("run"))  )			-- Set the animation
								end
							end
						end
					else
						if (self:IsOnGround()) then
							self:StartActivity( self:GetSequenceActivity(self:LookupSequence("idle_sitting")) )
						end
					end
				end)
				self.HaventLandedYet = false
			end
		end
		if (self.Ready) then
			if (IsValid(self:GetEnemy()) and self.Angry) then
				timer.Stop("Growl"..self:EntIndex())
				if (math.random(1,80) == 1) then
					if (!self.PlayingSequence and !self.WillIShredMyEnemyToGibs) then
						self:EmitSound("WitchZombie.Rage")
					elseif (!self.PlayingSequence and self.Retreating) then
						self:EmitSound("WitchZombie.RetreatHorror")
					end
				end
			else
				if (self.Retreating and math.random(1,200) == 1) then
					self:EmitSound("WitchZombie.RetreatHorror")
				elseif (!self.Retreating and math.random(1,200) == 1) then
					self:EmitSound("WitchZombie.Despair")
				end
			end
		end
		if (self.Retreating) then
			for k,v in ipairs(ents.FindInSphere(self:GetPos(),4000)) do
				if (v:IsPlayer()) then
					if (!v:Visible(self)) then
						self:Remove()
					end
				end
			end
		end
	end
	if (self:IsOnFire() and !string.find(self:GetModel(),"ceda")) then
		self:SetSequence( self:LookupSequence("run_onfire") )
	end
	if (IsValid(self:GetEnemy()) and self:GetEnemy():Health() < 1) then
		self:SetEnemy(nil)
	end
	if (IsValid(self.Door) and self:IsOnGround() and self.Door:GetPos():Distance(self:GetPos()) < self.AttackRange) then
		self.loco:SetDesiredSpeed( 0 )
		self.loco:SetAcceleration(-270)
	end
	if (self.WillIShredMyEnemyToGibs) then
		self.loco:SetDesiredSpeed( 0 )
		self.loco:SetAcceleration(0)
	end
	if (!IsValid(self.Door) and self.WasAttackingDoor) then

		self.Ready = true
		self:SetCollisionGroup(COLLISION_GROUP_NPC)
		self.WasAttackingDoor = false

	end
	if (self.PlayingSequence) then
		self:SetPlaybackRate(1)
	end
	if (IsValid(self.Door) and !self.ContinueRunning and self.Door:GetPos():Distance(self:GetPos()) < self.AttackRange and !self.WillIShredMyEnemyToGibs) then
		local targetheadpos,targetheadang = self.Door:GetBonePosition(1) -- Get the position/angle of the head.
		if (!self.MeleeAttackDelay2 or CurTime() > self.MeleeAttackDelay2) then
			if (self.Door:GetPos():Distance(self:GetPos()) < self.AttackRange) then
				self.OldEnemy = self.Enemy
				self.Ready = false
				self.WasAttackingDoor = false
				self:SetEnemy(nil)
				local anim = self:LookupSequence("MovingMelee_01") 
				self.MeleeAttackDelay = CurTime() + 0.2
				self.MeleeAttackDelay2 = CurTime() + self:SequenceDuration(anim)
				self.loco:ClearStuck() 
				self:AddGesture(anim,true)
			end
		end
	end
	if (IsValid(self:GetEnemy()) and self:IsOnGround() and !self.WillIShredMyEnemyToGibs) then
		if (self.Angry and !self.ContinueRunning and self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange + 80 and self:GetEnemy():Health() > 0) then
			local targetheadpos,targetheadang = self:GetEnemy():GetBonePosition(1) -- Get the position/angle of the head.
			if (IsValid(self:GetEnemy()) and (!self.MeleeAttackDelay or CurTime() > self.MeleeAttackDelay)) then
				if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange) then
					self:SetCollisionGroup(COLLISION_GROUP_NPC)
				end
				if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange	) then
					local anim = self:GetSequenceActivity(self:LookupSequence("MovingMelee_01"))
					self.MeleeAttackDelay = CurTime() + 0.2
					self:AddGesture(anim,true)
					self.loco:ClearStuck() 
				end
			end
		end
		if (self.Retreating) then
			self:BodyMoveXY()
		end
		if (self:IsOnGround() and self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange and self:GetEnemy():Health() > 0 or self.PlayingSequence) and !self.WillIShredMyEnemyToGibs then
			self.loco:SetDesiredSpeed( 0 )
			self.loco:SetAcceleration(-270)
		elseif (!self.ContinueRunning and self:IsOnGround() and (self:GetEnemy():GetPos():Distance(self:GetPos()) > self.AttackRange) and self:GetEnemy():Health() > 0 and !self.WillIShredMyEnemyToGibs) then
			if (!self.PlayingSequence && !self.SoonToBeRetreating) then
				self:BodyMoveXY()
			end
			if (self.MeleeAttackDelay and CurTime() < self.MeleeAttackDelay) then
				if (CurTime() < self.MeleeAttackDelay) then
					self.MeleeAttackDelay = CurTime() + 0.01
				end
				if (IsValid(self:GetEnemy())) then
					if (self.loco:IsUsingLadder()) then
						self:StartActivity( self:GetSequenceActivity(self:LookupSequence("Ladder_Ascend"))  )			-- Set the animation
					else
						if (self:IsOnGround()) then
							if (string.find(self:GetModel(),"mud")) then
		
								self:StartActivity( self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  )			-- Set the animation
		
							else
								self:StartActivity( self:GetSequenceActivity(self:LookupSequence("run"))  )			-- Set the animation
							end
						end
					end
				else
					if (self:IsOnGround()) then
						self:StartActivity( self:GetSequenceActivity(self:LookupSequence("shamble_01")) )
					end
				end
				self.loco:SetDesiredSpeed( 500 )
				self.loco:SetAcceleration(500)
			else
				self.loco:SetDesiredSpeed( 500 )
				self.loco:SetAcceleration(500)
			end
		end 
	elseif (IsValid(self:GetEnemy()) and self:GetEnemy():Health() < 1) then
		self:SetEnemy(nil)
	elseif (self.ContinueRunning or self:IsOnFire()) then
		self:SetPlaybackRate(1)
	end
	if (self.Retreating) then
		self.loco:SetDesiredSpeed( 500 )
		self.loco:SetAcceleration(500)
	end
	self:NextThink(CurTime())
	return true
end

function ENT:ChaseEnemy( options )

	local options = options or {}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( 300 )
	path:SetGoalTolerance( 20 )
	path:Compute( self, self:GetEnemy():GetPos() + self:GetForward()*(math.random(50,100)) + self:GetRight()*(math.random(50,100)) )		-- Compute the path towards the enemies position

	if ( !path:IsValid() ) then return "failed" end

	if (!self.HaventLandedYet and !self.EncounteredEnemy) then 

		local mad = self:LookupSequence("violent_alert01_Common_"..table.Random({"a","b","c","d","e"}))
		self:ResetSequence( mad )
		self.PlayingSequence = true
		timer.Simple(self:SequenceDuration(mad), function()
			self.PlayingSequence = false
			if (string.find(self:GetModel(),"mud")) then

				self:StartActivity( self:GetSequenceActivity(self:LookupSequence("mudguy_run"))  )			-- Set the animation

			else
				self:StartActivity( self:GetSequenceActivity(self:LookupSequence("run"))  )			-- Set the animation
			end
		end)

		self.EncounteredEnemy = true
	end
	while ( path:IsValid() and IsValid(self:GetEnemy()) ) do

		local pos = self:GetEnemy():GetPos()
		if (self:GetEnemy():GetPos():Distance(self:GetPos()) > self.AttackRange) then
			for k,v in ipairs(ents.FindInSphere(self:GetPos(),180)) do -- avoid other infected
				if (v:GetClass() == "infected_this_is_not_needed_anymore_why" and v:EntIndex() != self:EntIndex()) then
					self.AvoidingEntity = v
					pos = self:GetEnemy():GetPos() + (self:GetForward() + v:GetForward()*(-100)) + (v:GetRight() * -100 - self:GetRight()*(100))
					self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
				end
			end
		end
		if ( path:GetAge() > 0.02 ) then					-- Since we are following the player we have to constantly remake the path
			path:Compute(self, pos)-- Compute the path towards the enemy's position again
		end
		path:Update( self )								-- This function moves the bot along the path
		if (self:GetEnemy():IsPlayer()) then
			if (math.random(1,80) == 1) then
				debugoverlay.Text( self:GetPos(), "I can see you, "..self:GetEnemy():GetName(), 3,false )
			end
		end
		debugoverlay.Line(path:GetStart(), path:GetEnd(), 0.2, Color(0,255,0), false)
		if ( options.draw ) then path:Draw() end
		-- If we're stuck, then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() and self:GetEnemy():GetPos():Distance(self:GetPos()) > self.AttackRange ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()

	end

	return "ok"

end
function ENT:OnInjured( dmginfo )
	if (dmginfo:GetAttacker():GetClass() == "entityflame" or dmginfo:GetAttacker():GetClass() == "tf_entityflame") then
		dmginfo:GetAttacker():StopSound("General.BurningObject")
	end
	if (dmginfo:IsDamageType(DMG_ACID)) then
		dmginfo:ScaleDamage(0)
		dmginfo:SetDamageType(DMG_GENERIC)
	end
	if (dmginfo:IsDamageType(DMG_BURN) and !string.find(self:GetModel(),"ceda")) then
		self.Ready = false
		self:SetEnemy(nil)
		self:Ignite(30,120)
		if (!self.Burning) then
			self:StopSound("General.BurningFlesh")
			self:EmitSound("General.BurningFlesh")
			self.Burning = true
		end
		if (math.random(1,40) == 1) then
			self:EmitSound("Zombie.IgniteScream")
		end
	end
	if SERVER then
		self:AddGestureSequence(self:LookupSequence("flinch_02"),true)
	end
	if (self.Retreating) then
		self:SetEnemy(nil)
	end
	if (IsValid(dmginfo:GetAttacker()) and !self.Angry and !self.Retreating and !dmginfo:GetAttacker():IsL4D()) then
		self:StartActivity( self:GetSequenceActivity(self:LookupSequence("Wander_acquire")) )
		self:EmitSound("WitchZombie.Scream")
		timer.Stop("Growl"..self:EntIndex())
		timer.Simple(1, function()
			self:EmitSound("WitchZombie.Rage")
			self.Angry = true
		end)
	elseif (IsValid(dmginfo:GetAttacker()) and self.Angry) then
		self:EmitSound("WitchZombie.Pain")
	end
end

local deathanimfemaletbl = 
{

	"death_01",
	"death_02a",
	"death_02c",
	"death_03",
	"death_05",
	"death_06",
	"Death_m02a",
	"Death_m05",
	"Death_m09",
	"Death_m11_01a",
	"Death_m11_01b",
	"Death_m11_02a",
	"Death_m11_02b",
	"Death_m11_02c",
	"Death_m11_02d",
	"Death_m11_03a",
	"Death_m11_03b",
	"Death_m11_03c",

}
local deathbyshotgunanimtbl = 
{

	"Death_shotgun_Forward",
	--"Death_Shotgun_Leftward",
	--"Death_Shotgun_Rightward",
	--"Death_Shotgun_Rightward01",
	--"Death_Shotgun_Rightward02",
	"Death_Shotgun_Backward_03",
	"Death_Shotgun_Backward_04",
	"Death_Shotgun_Backward_05",
	"Death_Shotgun_Backward_06",
	"Death_Shotgun_Backward_07",
	"Death_Shotgun_Backward_08",
	"Death_Shotgun_Backward_09",
	--"Death_Shotgun_Backward_collapse"

}
local deathanimtbl = 
{

	"death_01",
	"death_02a",
	"death_02c",
	"death_03",
	"death_05",
	"death_06", 
	"death_07",
	"death_08",
	"death_08b",
	"death_08",
	"death_10ab",
	"death_10b",
	"death_10c",
	"death_11_01a",
	"death_11_01b",
	"death_11_02a",
	"death_11_02b",
	"death_11_02c",
	"death_11_02d",
	"death_11_03a",
	"death_11_03b",
	"death_11_03c"

}

local deathanimfemaletblrun = 
{

	"DeathRunning_01",
	"DeathRunning_02",
	"DeathRunning_04",
	"DeathRunning_05",
	"DeathRunning_06",
	"DeathRunning_07",
	"DeathRunning_09",
	"DeathRunning_10",
	"DeathRunning_m04",
	"DeathRunning_m09",
	"DeathRunning_m10",
	"DeathRunning_m11a",
	"DeathRunning_m11b",
	"DeathRunning_m11c"
	
}
local deathanimtblrun = 
{

	"DeathRunning_01",
	"DeathRunning_03",
	"DeathRunning_04",
	"DeathRunning_05",
	"DeathRunning_06",
	"DeathRunning_07",
	"DeathRunning_08",
	"DeathRunning_09",
	"DeathRunning_10",
	"DeathRunning_11a",
	"DeathRunning_11b",
	"DeathRunning_11c",
	"DeathRunning_11d",
	"DeathRunning_11e",
	"DeathRunning_11f",
	"DeathRunning_11g"
	
}

function ENT:OnKilled( dmginfo )

	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )

	local pos = self:GetPos()
	self:PrecacheGibs()
	if (IsValid(self:GetEnemy()) and self:GetEnemy():IsPlayer()) then
		self:GetEnemy():ResetClassSpeed()
	end
	if (self.WasShotInTheHead) then
		self:EmitSound("WitchZombie.HeadShot")
	else
		self:EmitSound("WitchZombie.Die") 
	end
	if SERVER then

		self:BecomeRagdoll(dmginfo)

	end
end
list.Set( "NPC", "witch", {
	Name = "Witch",
	Class = "witch",
	Category = "Left 4 Dead 2"
})