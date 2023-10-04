AddCSLuaFile()
PrecacheParticleSystem( "bomibomicon_ring" );
PrecacheParticleSystem( "spell_pumpkin_mirv_goop_red" );
PrecacheParticleSystem( "spell_pumpkin_mirv_goop_blue" );
PrecacheParticleSystem( "spell_skeleton_goop_green" );

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= false
ENT.Model = "models/bots/skeleton_sniper/skeleton_sniper.mdl"
ENT.AttackDelay = 50
ENT.AttackDamage = 30
ENT.AttackRange = 120
local s_skeletonHatModels =
{
	"models/player/items/all_class/skull_scout.mdl",
	"models/workshop/player/items/scout/hw2013_boston_bandy_mask/hw2013_boston_bandy_mask.mdl",
	"models/workshop/player/items/demo/hw2013_blackguards_bicorn/hw2013_blackguards_bicorn.mdl",
	"models/player/items/heavy/heavy_big_chief.mdl",
}
function ENT:Initialize()

	self:SetModel( self.Model )
	local rand = math.random(1,7)
	local seq = "spawn0"..rand
	timer.Simple(0.2, function()
		if SERVER then
			self:ResetSequence(seq)
			if (self:GetModelScale() == 1) then
			
				timer.Create("Laugh"..self:EntIndex(), math.random(4,5), 0, function()
					self:EmitSound("Halloween.skeleton_laugh_medium")
				end)
			elseif (self:GetModel() == "models/bots/skeleton_sniper_boss/skeleton_sniper_boss.mdl") then
				timer.Create("Laugh"..self:EntIndex(), math.random(6,7), 0, function()
					self:EmitSound("Halloween.skeleton_laugh_giant")
				end)
			elseif (self:GetModelScale() == 0.5) then
				timer.Create("Laugh"..self:EntIndex(), math.random(2,3), 0, function()
					self:EmitSound("Halloween.skeleton_laugh_small")
				end)
			end

		end
		timer.Simple(0.1, function()
		
			if SERVER and math.random(1,50) == 1 then
				local axe = ents.Create("gmod_button")
				axe:SetModel(table.Random(s_skeletonHatModels))
				axe:SetModelScale(self:GetModelScale())
				axe:SetPos(self:GetBonePosition(self:LookupBone("bip_pelvis")))
				axe:SetAngles(self:GetAngles())
				axe:SetParent(self)
				axe:AddEffects(EF_BONEMERGE)
				self:SetNWEntity("Hat",axe)
			end
			
		end)
		if (self:GetModel() == "models/bots/skeleton_sniper/skeleton_sniper.mdl") then
			self:SetSkin(2)
			timer.Simple(self:SequenceDuration(self:LookupSequence(seq)) - 0.2, function()
				self.Ready = true
			end)
		elseif (self:GetModel() == "models/bots/skeleton_sniper/skeleton_sniper_boss.mdl") then
			self:SetSkin(2)
			self:SetModelScale(1.75)
			timer.Simple(self:SequenceDuration(self:LookupSequence(seq)) - 0.2, function()
				self.Ready = true
			end)
		end
	end)
	
	self:SetSkin(2)
	self.Ready = false
	self.LoseTargetDist	= 4000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 3000	-- How far to search for enemies
	self:SetHealth(30)
	self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE_DEBRIS )
	if SERVER then
		
		self:SetBloodColor(DONT_BLEED)
		self:AddFlags(FL_OBJECT)
		if SERVER then
			for k,v in ipairs(ents.GetAll()) do
				if v:IsNPC() then
					v:AddEntityRelationship(self,D_HT,99)
				end
			end
		end
	end
end

function ENT:HandleStuck()

	--
	-- Clear the stuck status
	--
	self.loco:ClearStuck()
	if (self:HaveEnemy()) then
		--self:SetPos(self:GetEnemy():GetPos() + Vector(0,0,10))
	end
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
		elseif ( self:GetEnemy():IsTFPlayer() and (GAMEMODE:EntityTeam(v) == TEAM_SPECTATOR or GAMEMODE:EntityTeam(v) == TEAM_FRIENDLY or self:GetEnemy():Health() < 1 or self:GetEnemy():IsFlagSet(FL_NOTARGET)) ) then
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
		if ( ( v:IsTFPlayer() and !v:IsNextBot()) and GAMEMODE:EntityTeam(v) != TEAM_SPECTATOR and GAMEMODE:EntityTeam(v) != TEAM_FRIENDLY and v:Health() > 0 and !v:IsFlagSet(FL_NOTARGET) ) then
			-- We found one so lets set it as our enemy and return true
			if v:IsNPC() and (v:Classify() == CLASS_ZOMBIE || v:Classify() == CLASS_HEADCRAB) then return end
			if (v:IsPlayer()) then
				self:SetEnemy(table.Random(player.GetAll()))
			else
				self:SetEnemy(v)
			end
			if (v:IsNPC()) then
				v:SetEnemy(self)
			end
			if SERVER then
				for k,v in ipairs(ents.GetAll()) do
					if v:IsNPC() and v:Classify() != CLASS_ZOMBIE and v:Classify() != CLASS_HEADCRAB then
						v:AddEntityRelationship(self,D_HT,99)
					end
				end
			end
			return true
		end
	end	
	-- We found nothing so we will set our enemy as nil (nothing) and return false
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
				self:StartActivity( ACT_MP_RUN_MELEE )			-- Set the animation
				self.loco:SetDesiredSpeed( 300 )		-- Set the speed that we will be moving at. Don't worry, the animation will speed up/slow down to match
				self:ChaseEnemy( ) 						-- The new function like MoveToPos.
				self:StartActivity( ACT_MP_STAND_MELEE )			-- Set the animation
				-- Now once the above function is finished doing what it needs to do, the code will loop back to the start
				-- unless you put stuff after the if statement. Then that will be run before it loops
			else
				-- Since we can't find an enemy, lets wander
				-- Its the same code used in Garry's test bot
				self:StartActivity( ACT_MP_STAND_MELEE )			-- Walk anmimation
			end
			
		end
		-- At this point in the code the bot has stopped chasing the player or finished walking to a random spot
		-- Using this next function we are going to wait 2 seconds until we go ahead and repeat it 
		coroutine.wait(0.1)
		
	end

end	

hook.Add( "ShouldCollide", "SkeletonCollision", function( ent1, ent2 )

    -- If players are about to collide with each other, then they won't collide.
    if ( ent1:GetClass() == "npc_tf_zombie" and ent2:GetClass() == "npc_tf_zombie" ) then return false end

end )

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
	
	if (IsValid(self:GetEnemy()) and self:GetEnemy():Health() < 1) then
		self:SetEnemy(nil)
	end
	if CLIENT then 

		if (self:GetModelScale() == 0.5) then
			self:ManipulateBoneScale(self:LookupBone("bip_head"),Vector(3,3,3))
		else
			self:ManipulateBoneScale(self:LookupBone("bip_head"),Vector(1,1,1))
		end

	end
	
	if (IsValid(self:GetEnemy()) and self:IsOnGround()) then
		if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange and self:GetEnemy():Health() > 0) then
			if (IsValid(self:GetEnemy()) and (!self.MeleeAttackDelay or CurTime() > self.MeleeAttackDelay)) then
				self.MeleeAttackDelay = CurTime() + 1.5
				self:AddGesture(ACT_MP_ATTACK_STAND_MELEE,true)
				local dmginfo = DamageInfo()
				dmginfo:SetAttacker(self)
				dmginfo:SetInflictor(self)
				dmginfo:SetDamageType(bit.bor(DMG_CLUB,DMG_SLASH))
				dmginfo:SetDamage(self.AttackDamage)
				self:GetEnemy():TakeDamageInfo(dmginfo) 
			end
		end
		if (self:IsOnGround() and self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange and self:GetEnemy():Health() > 0) then
			if (self:GetSequence() != self:SelectWeightedSequence(ACT_MP_STAND_MELEE)) then
				self:StartActivity( ACT_MP_STAND_MELEE )	
			end
			self.loco:SetDesiredSpeed( 0 )
			self.loco:SetAcceleration(0)
		elseif (self:IsOnGround() and self:GetEnemy():GetPos():Distance(self:GetPos()) > self.AttackRange and self:GetEnemy():Health() > 0) then
			if (self:GetSequence() != self:SelectWeightedSequence(ACT_MP_RUN_MELEE)) then
				self:StartActivity( ACT_MP_RUN_MELEE )	
			end
			self.loco:SetDesiredSpeed( 300 )
			self.loco:SetAcceleration(300)
		end
	elseif (SERVER and !self:IsOnGround() and !self.AirwalkAnim) then
		if (self:GetSequence() != self:SelectWeightedSequence(ACT_MP_AIRWALK_MELEE)) then
			self:StartActivity( ACT_MP_AIRWALK_MELEE )	
		end
		self.AirwalkAnim = true
	elseif (self:IsOnGround() and self.AirwalkAnim) then
		if (self:GetSequence() != self:SelectWeightedSequence(ACT_MP_STAND_MELEE)) then
			self:StartActivity( ACT_MP_STAND_MELEE )	
		end
		self:AddGesture(ACT_MP_JUMP_LAND_MELEE,true)
		self.AirwalkAnim = false
	elseif (IsValid(self:GetEnemy()) and self:GetEnemy():Health() < 1) then
		self:SetEnemy(nil)
	end
	self:NextThink(CurTime())
	return true
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
	if (string.find(self:GetModel(),"skeleton")) then
		if (self:GetSkin() == 3) then
			ParticleEffect( "spell_skeleton_goop_green", dmginfo:GetDamagePosition(), self:GetAngles() )
		elseif (self:GetSkin() == 2) then
			ParticleEffect( "spell_skeleton_goop_green", dmginfo:GetDamagePosition(), self:GetAngles() )
		elseif (self:GetSkin() == 0) then
			ParticleEffect( "spell_pumpkin_mirv_goop_red", dmginfo:GetDamagePosition(), self:GetAngles() )
		elseif (self:GetSkin() == 1) then
			ParticleEffect( "spell_pumpkin_mirv_goop_blue", dmginfo:GetDamagePosition(), self:GetAngles() )
		end
	end
	if not self.NextFlinch or CurTime() > self.NextFlinch then
		self:AddGesture(ACT_MP_GESTURE_FLINCH_CHEST)
		self.NextFlinch = CurTime() + 0.5
	end
end
function ENT:OnKilled( dmginfo )

	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )

	local pos = self:GetPos()
	if (self:GetModel() == "models/bots/skeleton_sniper/skeleton_sniper_boss.mdl") then
		ParticleEffect( "halloween_boss_death", self:GetPos(), self:GetAngles() )
		self:EmitSound("misc/halloween/spell_meteor_impact.wav")
		self:EmitSound("misc/halloween/spell_spawn_boss.wav")
	end 
	if (self:GetModel() == "models/bots/skeleton_sniper/skeleton_sniper.mdl") then
		if (self:GetModelScale() == 1) then
			local theskin = self:GetSkin()
			for i=1,3 do 
				timer.Simple(math.Rand(2,2.5), function()
					local mini_skeleton = ents.Create("npc_tf_zombie")
					local pos2 = pos + Vector(math.random(-32,32),math.random(-32,32),0) * math.random(1,6)
					mini_skeleton:SetModelScale(0.5)
					mini_skeleton:SetPos(pos2)
					if (theskin == 3) then
						ParticleEffect( "spell_skeleton_goop_green", pos2, mini_skeleton:GetAngles() )
					elseif (theskin == 2) then
						ParticleEffect( "spell_skeleton_goop_green", pos2, mini_skeleton:GetAngles() )
					elseif (theskin == 0) then
						ParticleEffect( "spell_pumpkin_mirv_goop_red", pos2, mini_skeleton:GetAngles() )
					elseif (theskin == 1) then
						ParticleEffect( "spell_pumpkin_mirv_goop_blue", pos2, mini_skeleton:GetAngles() )
					end
					mini_skeleton:EmitSound("Cleaver.ImpactFlesh")
					mini_skeleton:Spawn()
					mini_skeleton:Activate()
					mini_skeleton.AttackDamage = 20
					mini_skeleton.AttackRange = 40
					timer.Simple(0.25, function()
						if (theskin != 2) then
							mini_skeleton:SetSkin(theskin)
						end
					end)
				end)
			end
		end
	end
	self:PrecacheGibs()
	self:GibBreakClient(dmginfo:GetDamageForce() * 0.05)
	self:EmitSound("Halloween.skeleton_break")
	self:Remove()
end
list.Set( "NPC", "npc_tf_zombie", {
	Name = "SKELETON",
	Class = "npc_tf_zombie",
	Category = "TF2: Halloween"
})