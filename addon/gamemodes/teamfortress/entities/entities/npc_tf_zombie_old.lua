AddCSLuaFile()
PrecacheParticleSystem( "bomibomicon_ring" );
PrecacheParticleSystem( "spell_pumpkin_mirv_goop_red" );
PrecacheParticleSystem( "spell_pumpkin_mirv_goop_blue" );
PrecacheParticleSystem( "spell_skeleton_goop_green" );

ENT.Base 			= "npc_tf_zombie"
ENT.Spawnable		= false
ENT.AttackDelay = 50
ENT.AttackDamage = 30
ENT.AttackRange = 120

local zombie_classes = {
	"scout",
	"soldier",
	"pyro",
	"demo",
	"heavy",
	"engineer",
	"medic",
	"sniper",
	"spy",
}

function ENT:Initialize()

	if SERVER then
		self.playerclass = table.Random(zombie_classes)
		self:SetModel( "models/player/"..self.playerclass..".mdl" )
		if (self.playerclass == "spy") then
			self:SetSkin(math.random(22,23))
		else
			self:SetSkin(math.random(4,5))
		end
		local axe = ents.Create("gmod_button")
		axe:SetModel("models/player/items/"..self.playerclass.."/"..self.playerclass.."_zombie.mdl")
		axe:SetPos(self:GetPos())
		axe:SetAngles(self:GetAngles())
		axe:SetParent(self)
		if (self.playerclass == "spy") then
			axe:SetSkin(self:GetSkin() - 22)
		else
			axe:SetSkin(self:GetSkin() - 4)
		end
		axe:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
		self:SetNWEntity("Hat",axe)
	end
	self.Ready = true
	self.LoseTargetDist	= 4000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 3000	-- How far to search for enemies
	self:SetHealth(50)
	self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE_DEBRIS )
	if SERVER then
		self:SetBloodColor(BLOOD_COLOR_RED)
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
				self.loco:SetDesiredSpeed( 240 )		-- Set the speed that we will be moving at. Don't worry, the animation will speed up/slow down to match
				self.loco:SetAcceleration(300)			-- We are going to run at the enemy quickly, so we want to accelerate really fast
				self:ChaseEnemy( ) 						-- The new function like MoveToPos.
				self:StartActivity( ACT_MP_STAND_MELEE )
				-- Now once the above function is finished doing what it needs to do, the code will loop back to the start
				-- unless you put stuff after the if statement. Then that will be run before it loops
			end
			
			
		end
		-- At this point in the code the bot has stopped chasing the player or finished walking to a random spot
		-- Using this next function we are going to wait 2 seconds until we go ahead and repeat it 
		coroutine.wait(2)
		
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
	if (IsValid(self:GetEnemy()) and self:GetEnemy():Health() < 0) then
		self:SetEnemy(nil)
	end
	if (IsValid(self:GetEnemy()) and self:IsOnGround()) then
		if (self:GetEnemy():GetPos():Distance(self:GetPos()) < self.AttackRange and self:GetEnemy():Health() > 0) then
			if (IsValid(self:GetEnemy()) and (!self.MeleeAttackDelay or CurTime() > self.MeleeAttackDelay)) then
				self.MeleeAttackDelay = CurTime() + 0.8
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
	elseif (IsValid(self:GetEnemy()) and self:GetEnemy():Health() < 0) then
		self:SetEnemy(nil)
	end
	self:NextThink(CurTime())
	return true
end
function ENT:OnKilled( dmginfo )

	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )

	local pos = self:GetPos()
	self:PrecacheGibs()
	self:BecomeRagdoll(dmginfo)
	timer.Simple(0.02, function()
		self:Remove()
	end)
end
list.Set( "NPC", "npc_tf_zombie_old", {
	Name = "ZOMBIE",
	Class = "npc_tf_zombie_old",
	Category = "TF2: Halloween"
})