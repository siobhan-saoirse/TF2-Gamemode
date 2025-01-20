AddCSLuaFile()

game.AddParticles("particles/particles_vsh.pcf")
ENT.Base 			= "base_nextbot"
ENT.Spawnable		= false
ENT.Model = "models/player/saxton_hale.mdl"
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
	if SERVER then
		local axe = ents.Create("gmod_button")
		axe:SetModel("models/empty.mdl")
		axe:SetPos(self:GetPos())
		axe:SetAngles(self:GetAngles())
		axe:SetParent(self)
		axe:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
		self:SetNWEntity("Axe",axe)
	end
	local seq = "taunt01"
	timer.Simple(0.1, function()
		if SERVER then
			self:AddGestureSequence(self:LookupSequence(seq)) 
		end
		timer.Simple(self:SequenceDuration(self:LookupSequence(seq)) - 0.6, function()
			self.Ready = true
			if SERVER then
				self:StartActivity(self:GetSequenceActivity(self:LookupSequence("stand_melee")))
				timer.Create("Laugh"..self:EntIndex(), 3, 0, function()
					if (self.Ready) then
						timer.Adjust("Laugh"..self:EntIndex(),math.random(3,15),nil,nil)
							if (self:GetEnemy() != nil and !self:Visible(self:GetEnemy())) then
								self:EmitSound(table.Random({
									"mvm/saxton_hale_by_matthew_simmons/come_back_01.mp3",
									"mvm/saxton_hale_by_matthew_simmons/come_back_02.mp3",
									"mvm/saxton_hale_by_matthew_simmons/laugh_01.mp3",
									"mvm/saxton_hale_by_matthew_simmons/last_mann_hiding_01.mp3",
									"mvm/saxton_hale_by_matthew_simmons/last_mann_hiding_02.mp3",
									"mvm/saxton_hale_by_matthew_simmons/last_mann_hiding_03.mp3",
									"mvm/saxton_hale_by_matthew_simmons/last_mann_hiding_04.mp3",
									"mvm/saxton_hale_by_matthew_simmons/last_mann_hiding_05.mp3",
									"mvm/saxton_hale_by_matthew_simmons/last_mann_hiding_06.mp3",
									"mvm/saxton_hale_by_matthew_simmons/last_mann_hiding_07.mp3",
								}),95,100,CHAN_VOICE)
								if (math.random(0,100) < 25) then
									self:AddGesture(ACT_MP_GESTURE_VC_FISTPUMP_MELEE,true)
								elseif (math.random(0,100) < 50) then
									self:AddGesture(ACT_MP_GESTURE_VC_FINGERPOINT_MELEE,true)
								elseif (math.random(0,100) < 75) then 
									self:AddGestureSequence(self:LookupSequence("gesture_melee_help"))  
								end
							else
								if (math.random(0,100) < 25) then
									self:AddGesture(ACT_MP_GESTURE_VC_FISTPUMP_MELEE,true)
								elseif (math.random(0,100) < 50) then
									self:AddGesture(ACT_MP_GESTURE_VC_FINGERPOINT_MELEE,true)
								end
							end 
					end
				end)
			end
		end)
	end)
	self.Ready = false
	self.LoseTargetDist	= 3600	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 2500	-- How far to search for enemies
	self:SetHealth(30000)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_NPC)
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
			v:RemovePlayerState(PLAYERSTATE_MARKED)
			v.IsITFromHHH = false
		end
	end
end

function ENT:FireAnimationEvent( pos, ang, event, name )
	if (event == 6004 or event == 7001) then
		timer.Simple(0.02, function()
			self:EmitSound("Concrete.Step"..table.Random({"Left","Right"}))
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
hook.Add("EntityTakeDamage","RemoveITFromMeleeHit",function(target,dmginfo)
	local att = dmginfo:GetAttacker()
	if (target:IsTFPlayer() and !target:IsNextBot() and (dmginfo:IsDamageType(DMG_CLUB) or dmginfo:IsDamageType(DMG_SLASH)) and att.IsITFromHHH) then
		att:RemovePlayerState(PLAYERSTATE_MARKED)
		att.IsITFromHHH = false
		for k,v in ipairs(ents.FindByClass("npc_saxton")) do
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
			if (v:IsPlayer() and !v.IsITFromHHH) then
				v.IsITFromHHH = true
			end
			//v:AddPlayerState(PLAYERSTATE_MARKED)
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
				self.loco:SetDesiredSpeed( 400 )		-- Set the speed that we will be moving at. Don't worry, the animation will speed up/slow down to match
				self:ChaseEnemy( ) 						-- The new function like MoveToPos.
				self:StartActivity( self:GetSequenceActivity(self:LookupSequence("stand_melee")) )			-- Set the animation
				-- Now once the above function is finished doing what it needs to do, the code will loop back to the start
				-- unless you put stuff after the if statement. Then that will be run before it loops
			
			else

				if (math.random(1,800) == 1) then

					-- Since we can't find an enemy, lets wander
					-- Its the same code used in Garry's test bot
					self:StartActivity( self:GetSequenceActivity(self:LookupSequence("run_melee")) )			-- Set the animation
					self.loco:SetDesiredSpeed( 400 )		-- Walk speed
					self.loco:SetAcceleration(400)
					self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 800 ) -- Walk to a random place within about 400 units (yielding)
					self:StartActivity( self:GetSequenceActivity(self:LookupSequence("stand_melee")) )			-- Set the animation


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
			
			if (IsValid(self:GetEnemy()) and (!self.MeleeAttackDelay or CurTime() > self.MeleeAttackDelay)) then
				self:AddGestureSequence(self:SelectWeightedSequence(ACT_MP_ATTACK_STAND_MELEE),true)
				self:EmitSound("Weapon_Fist.Miss")
				timer.Simple(0.2, function()
					if (!self.Ready) then return end
					if (self:GetEnemy():GetPos():Distance(self:GetPos()) < 200) then
						if (self:GetEnemy():GetClass() != "npc_saxton") then
							local dmginfo = DamageInfo()
							dmginfo:SetAttacker(self)
							dmginfo:SetInflictor(self)
							dmginfo:SetDamageType(bit.bor(DMG_CLUB,DMG_SLASH,DMG_BLAST))
							dmginfo:SetDamage(40)
							self:GetEnemy():TakeDamageInfo(dmginfo) 
							self:EmitSound("Weapon_Fist.HitFlesh")
							if (self:GetEnemy():Health() < 0) then
								self:EmitSound("mvm/saxton_hale_by_matthew_simmons/kill_generic_"..table.Random({
									"01",
									"02",
									"03",
									"04",
									"05",
									"06",
									"07",
									"08",
									"09",
									"10",
									"11",
									"12",
									"13",
									"14",
									"15",
									"16",
									"17",
									"18",
									"19",
									"20",
									"21",
									"22",
									"23",
									"24",
									"25",
									"26",
								})..".mp3",95,100,CHAN_VOICE)
							end
						end
					end

				end)
				self.MeleeAttackDelay = CurTime() + 0.4
			end
		end
		if (self:GetEnemy():GetPos():Distance(self:GetPos()) < 100 and self:GetEnemy():Health() > 0) then
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
			self.loco:SetDesiredSpeed( 400 )
			self.loco:SetAcceleration(400)
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
	if not self.NextFlinch or CurTime() > self.NextFlinch then
		self:AddGesture(ACT_MP_GESTURE_FLINCH_CHEST)
		self.NextFlinch = CurTime() + 0.5
	end
end
function ENT:OnKilled( dmginfo )

	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	self.Ready = false
	self:BecomeRagdoll(dmginfo)
	self:Remove()
end

list.Set( "NPC", "npc_saxton", {
	Name = "Saxton Hale",
	Class = "npc_saxton",
	Category = "TFBots: Extras",
	AdminOnly = true
})