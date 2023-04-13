AddCSLuaFile()
PrecacheParticleSystem("eyeboss_death")


ENT.Base             = "base_gmodentity"
ENT.Spawnable        = false
ENT.AdminOnly   = true	


ENT.Speed = 180

ENT.health = 90
ENT.Damage = 10
ENT.AttackWaitTime = 0.5
ENT.AttackFinishTime = 0.3

ENT.FallDamage = 10

ENT.angry = false
ENT.stunned = false
ENT.canteleport = true
ENT.Model = "models/props_halloween/halloween_demoeye.mdl"


ENT.Attack1 = Sound("")
ENT.Attack2 = Sound("")
ENT.Attack3 = Sound("")
ENT.Attack4 = Sound("")



ENT.FlinchAnim = (none)
ENT.FallAnim = (none)


ENT.LastPos = Vector(0, 0, 0)


ENT.playerclass = "scout"
game.AddParticles("particles/halloween.pcf")
game.AddParticles("particles/eyeboss.pcf")
game.AddParticles("particles/scary_ghost.pcf")
game.AddParticles( "particles/burningplayer.pcf" )
game.AddParticles( "particles/burningplayer_dx80.pcf" )

function ENT:Precache()
	if SERVER then
util.PrecacheModel(self.Model)
	end
end



function ENT:Think()
	self:NextThink(CurTime())
end


if CLIENT then
	function ENT:FireAnimationEvent(_, _, event)
		local sequence = self:GetSequenceName(self:GetSequence())

		if (event == 7001 or event == 7002) then
			self:EmitSound("Halloween.HeadlessBossFootfalls", 120, 100)
		end
	end
end

function ENT:Draw()
	self.Entity:DrawModel()	
end

concommand.Add("spawn_eyeboss", function(ply)
	if ply:IsAdmin() then
		if SERVER then	
		local pos = tr.HitPos
	
		local ent = ents.Create("eyeball_boss")
		ent:SetPos(pos)
		ent:Spawn()
		ent:Activate()
		
		ent:SetTeam(ply:Team())
		end
	end
end)

function ENT:Initialize()
		self:IdleSounds()

if SERVER then
local button = ents.Create( "eyeball_boss" )
if (  !IsValid( button ) ) then return end -- Check whether we successfully made an entity, if ( not - bail
button:SetModel( "models/empty.mdl" )
button:SetSkin(4)
button:SetPos(self:GetPos())

self:SetBloodColor(BLOOD_COLOR_YELLOW)

		timer.Create( "laugh", 5, 0, function()
		if !IsValid(self) then return end
		self:IdleSounds() 
		end );

	

	
	self.Entity:SetCollisionBounds( Vector(-4,-4,0), Vector(4,4,64) )
    self:SetCollisionGroup(COLLISION_GROUP_PLAYER)
--ParticleEffectAttach("ghost_pumpkin_flyingbits",PATTACH_ABSORIGIN_FOLLOW,self,0)
	
	

		self:SetHealth(5000)
		self:SetMaxHealth(5000)
			self:SetTeam(TEAM_NEUTRAL)
	self:SetModel(self.Model)
	button:SetParent(self)
	button:SetSkin(self:GetSkin())
	button:AddEffects(EF_BONEMERGE)
	self.LoseTargetDist	= 2000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 1000	-- How far to search for enemies
	--Misc--
	self:Precache()
	self.LastPos = self:GetPos()
	self.loco:SetAcceleration(0)
	self.loco:SetDeceleration(0) 
	self.nextbot = true
	self:SetMoveType( MOVETYPE_FLYGRAVITY )
	local bullseye = ents.Create("npc_bullseye") -- the bullseye is to get default NPCs to shoot at us.
		bullseye:SetPos(self:GetPos() + (self:GetAngles():Forward() * 45) + Vector(0,0,60))
		bullseye:SetParent(self)
		bullseye:Spawn()
		bullseye:SetHealth(999999999)
		bullseye:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		self.bullseye = bullseye
	self:EmitSound("ui/halloween_boss_summoned_monoculus.wav", 0)
end
end

function ENT:BehaveAct()
end

function ENT:Think()  
	if  SERVER then
			self:SetPos(self.LastPos + Vector(0,0,400))			
			local targetheadpos,targetheadang = self:GetEnemy():GetBonePosition(1) -- Get the position/angle of the head.
			self:SetAngles((targetheadpos - self:EyePos()):Angle()) -- And finally, we snap our aim to the head of the target.
	end
	self:NextThink(CurTime())
	return true
end

function ENT:OnStuck()
end

function ENT:OnUnStuck()
end

function ENT:GetDoor(ent)

	local doors = {}
	doors[1] = "models/props_c17/door01_left.mdl"
	doors[2] = "models/props_c17/door02_double.mdl"
	doors[3] = "models/props_c17/door03_left.mdl"
	doors[4] = "models/props_doors/door01_dynamic.mdl"
	doors[5] = "models/props_doors/door03_slotted_left.mdl"
	doors[6] = "models/props_interiors/elevatorshaft_door01a.mdl"
	doors[7] = "models/props_interiors/elevatorshaft_door01b.mdl"
	doors[8] = "models/props_silo/silo_door01_static.mdl"
	doors[9] = "models/props_wasteland/prison_celldoor001b.mdl"
	doors[10] = "models/props_wasteland/prison_celldoor001a.mdl"
	
	doors[11] = "models/props_radiostation/radio_metaldoor01.mdl"
	doors[12] = "models/props_radiostation/radio_metaldoor01a.mdl"
	doors[13] = "models/props_radiostation/radio_metaldoor01b.mdl"
	doors[14] = "models/props_radiostation/radio_metaldoor01c.mdl"
	
	
	for k,v in pairs( doors ) do
		if ent:GetModel() == v and string.find(ent:GetClass(), "door") then
			return "door"
		end
	end
	
end

function ENT:IdleSounds()
if SERVER then
	if math.random( 1,3 ) == 1 then
	local sounds = {}
	sounds[1] = (self.Idle1)
	sounds[2] = (self.Idle2)
	sounds[3] = (self.Idle3)
	sounds[4] = (self.Idle4)
		self:EmitSound( "Halloween.EyeballBossIdle" )
		if self.angry != true then
			if self.stunned == true then return end
			self:ResetSequence("lookaround"..math.random(1,3))
		end
	end
		end		
end

function ENT:Teleported()
	
		self:EmitSound("vo/halloween_eyeball/eyeball_teleport01.wav", 0)
		self:EmitSound("misc/halloween_eyeball/vortex_eyeball_moved.wav", 0)										
		self.LastPos = self:GetPos() + Vector(math.random(500,100	), math.random(500,100), nil)
	
end
function ENT:BodyUpdate()
	local act = self:GetActivity()
	if ( act == ACT_MP_run_MELEE_allclass ) then
		self:BodyMoveXY()
	end
	self:FrameAdvance()
end

function ENT:SetEnemy(ent)
	self.Enemy = ent
	
	--self:EmitSound("Halloween.EyeballBossBecomeAlert")
end

function ENT:GetEnemy()
	return self.Enemy
end

function ENT:HaveEnemy()

--self.loco:SetDesiredSpeed(self.Speed)
--if (self:Health() < 1) then
--else
	if ( self:GetEnemy() and IsValid( self:GetEnemy() ) ) then
		if ( self:GetRangeTo( self:GetEnemy():GetPos() ) > self.LoseTargetDist ) then
			return self:FindEnemy() 
		elseif ( self:GetEnemy():Health() < 1 or !IsValid(self:GetEnemy()) ) then
			self:EmitSound("Halloween.EyeballBossLaugh")
			return false
		end	
		
		if ( self.stunned == true ) then
			return false
		end
		return true
	else
		self:ResetSequence("arrives") 
		coroutine.wait(7.5)	
		return self:FindEnemy()
	end
	
end

function ENT:FindEnemy()
	-- Search around us for entities
	-- This can be done any way you want eg. ents.FindInCone() to replicate eyesight
	local _ents = ents.FindInSphere( self:GetPos(), 4000  )
	-- Here we loop through every entity the above search finds and see if it's the one we want
	for k, v in pairs( _ents ) do
		if v:IsPlayer() or v:IsNPC() or v.Base == "npc_tf2base" or v.Base == "npc_tf2base_mvm" or v.Base == "npc_demo_red" or v.Base == "npc_demo_mvm" or v.Base == "npc_scout_mvm" or v.Base == "npc_hwg_red" or v.Base == "npc_heavy_mvm" or v.Base == "npc_heavy_mvm_shotgun" or v.Base == "npc_soldier_red" or v.Base == "npc_sniper_red" or v.Base == "npc_spy_red" or v.Base == "npc_scout_red" or v.Base == "npc_pyro_red" or v.Base == "npc_medic_red" or v.Base == "npc_engineer_red" and v:Health() >= 0 then
				
				self:SetEnemy(v)
				return true	
		end
	end
	
		if ( self.stunned == true ) then
			return false
		end
	-- We found nothing so we will set our enemy as nil ( nothing ) and return false
	self:SetEnemy( nil )
	return false
end

function ENT:KeyValue(key,value)
	key = string.lower(key)
	
	if key=="teamnum" then
		local t = tonumber(value)
		
		if t==2 then
			self:SetTeam(TEAM_RED)
			self:SetSkin(2)
			self.angry = true
		elseif t==3 then
			self:SetTeam(TEAM_BLU)
			self:SetSkin(3)
			self.angry = true
		else
			self:SetTeam(TEAM_NEUTRAL)
		end
	end
	print(key, value, tonumber(value), self.Team)
end

function ENT:Team()
	return self:GetNWInt("Team") or TEAM_NEUTRAL
end

function ENT:SetTeam(t)
	if CLIENT then return end
	
	local oldteam = self:GetNWInt("Team")
	self:SetNWInt("Team", t)
	
	if oldteam ~= t then
		GAMEMODE:UpdateEntityRelationship(self)
	end
end




function ENT:RunBehaviour()
	while ( true ) do
		if ( self.stunned == true ) then
			return
		end
		--[[if self.canteleport == true then
			timer.Simple(20, function()
				self:Teleported()
				self.canteleport = false
				timer.Simple(15, function()
					self.canteleport = true
				end)
			end)
		end]]
		if ( self:HaveEnemy() ) then
			for k,v in ipairs(ents.FindByClass("npc_*")) do
				if v:IsNPC() then
					v:AddEntityRelationship(self.bullseye, D_HT, 999999999)
				end
			end
				if ( self.stunned == true ) then
					return
				end
				
				if self.angry == true then
					self:EmitSound("Halloween.EyeballBossRage")
					coroutine.wait(1.2)
				else
					--self:EmitSound("Halloween.EyeballBossBecomeAlert")
				coroutine.wait(0.7)
				end
					self:EmitSound("Weapon_RPG.SingleCrit")
				if self.angry == true then
				if ( self.stunned == true ) then
					return
				end
				self:ResetSequence("firing"..math.random(2,3)) 
				
					local rocket = ents.Create("tf_projectile_rocket")
					if game.GetMap() == "ctf_2fort" then	 
						rocket:SetPos(self.LastPos + Vector(0,0,400))
					else	
						rocket:SetPos(self.LastPos + Vector(0,0,400))
					end
							rocket:SetAngles(self:GetAngles())

					local ang = self:GetAngles()
					rocket:SetOwner(self)
					
					rocket:Spawn()
					rocket.critical = true
					rocket:Activate()	
						rocket.NameOverride = "monoculus"
					rocket:SetModel("models/props_halloween/eyeball_projectile.mdl")
					--v:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
				timer.Simple(0.4, function()
					
					self:EmitSound("Weapon_RPG.SingleCrit")
						local rocket = ents.Create("tf_projectile_rocket")
					if game.GetMap() == "ctf_2fort" then	 
						rocket:SetPos(self.LastPos + Vector(0,0,400))
					else	
						rocket:SetPos(self.LastPos + Vector(0,0,400))
					end
							rocket:SetAngles(self:GetAngles())
						local ang = self:GetAngles()
						rocket:SetOwner(self)
						
						rocket:Spawn()
						rocket.critical = true
						rocket:Activate()	
						rocket.NameOverride = "monoculus"	
					rocket:SetModel("models/props_halloween/eyeball_projectile.mdl")		
						--v:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
				
				end)
				timer.Simple(0.8, function()
					
					self:EmitSound("Weapon_RPG.SingleCrit")
						local rocket = ents.Create("tf_projectile_rocket")
					if game.GetMap() == "ctf_2fort" then	 
						rocket:SetPos(self.LastPos + Vector(0,0,400))
					else	
						rocket:SetPos(self.LastPos + Vector(0,0,400))
					end
							rocket:SetAngles(self:GetAngles())
						local ang = self:GetAngles()
						rocket:SetOwner(self)
						
						rocket:Spawn()
						rocket.critical = true
						rocket:Activate()	
						rocket.NameOverride = "monoculus"
					rocket:SetModel("models/props_halloween/eyeball_projectile.mdl")		
						--v:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
				
				end)
				timer.Simple(1, function()
					
				self:SetPlaybackRate(1)
				end)
				else
				self:ResetSequence("firing1") 
				if ( self.stunned == true ) then
					return
				end
					local rocket = ents.Create("tf_projectile_rocket")
										if game.GetMap() == "ctf_2fort" then	 
						rocket:SetPos(self.LastPos + Vector(0,0,400))
					else	
						rocket:SetPos(self.LastPos + Vector(0,0,400))
					end 
							rocket:SetAngles(self:GetAngles())
					local ang = self:GetAngles()
					rocket:SetOwner(self) 
					
					rocket:Spawn()
					rocket.critical = true
					rocket:Activate()	
						rocket.NameOverride = "monoculus"
					rocket:SetModel("models/props_halloween/eyeball_projectile.mdl")		
					--v:ViewPunch(Angle(math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage, math.random(-1, 1)*self.Damage))
				end
				self:SetPlaybackRate(1)
				
				coroutine.wait( 0.3 )
			self.loco:SetDesiredSpeed(self.Speed)
			self:IdleSounds() 
			
			
				
				
		else
				if ( self.stunned == true ) then
					return
				end
			-- Wander around
		self:ResetSequence("general_noise")
		self:SetPlaybackRate(1)
			self:IdleSounds()
			self.loco:SetDesiredSpeed(self.Speed)
			self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 )
		end
	end
end	

function ENT:SetPlayerClass(args) -- wat
	self.playerclass = tostring(args)
end
function ENT:GetPlayerClass() 
	return self.playerclass
end

function ENT:OnOtherKilled()
end

function ENT:OnLeaveGround() 
	if SERVER then
if self:IsOnGround() then
self:TakeDamage(self.FallDamage, self)
end
end
end

function ENT:OnLandOnGround()
		self:ResetSequence("general_noise")
		self:SetPlaybackRate(1)
end

	if SERVER then
function ENT:OnKilled( dmginfo )
	
	--	timer.Simple( 2.8, function() self:StartActivity( ACT_MP_STAND_ITEM1 ,5 ) end )
	self.loco:SetDesiredSpeed(0)
		
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
		self.stunned = true
	
		if dmginfo:GetAttacker():IsPlayer() then
			PrintMessage(HUD_PRINTTALK, dmginfo:GetAttacker():Nick().." has defeated MONOCULUS!")
		elseif dmginfo:GetAttacker():IsNPC() then
			PrintMessage(HUD_PRINTTALK, dmginfo:GetAttacker():GetClass().." has defeated MONOCULUS!")
		end
	timer.Simple(2.3,function()
	    self:ResetSequence("death",false)
		timer.Simple(0.1,function()
			self:EmitSound("Halloween.EyeballBossStunned",95)
		end)
		self:SetPlaybackRate(1)
		self:SetCycle(0) 	
		timer.Destroy("laugh")
		self.SearchRadius = self.SearchRadius + 0
    	self:SetPlaybackRate(1)
	end)
	
	timer.Simple(19.8,function()
	
		ParticleEffect( "eyeboss_death", self:GetPos(), Angle( 0, 0, 0 ) )
		
	end)
	timer.Simple(20,function()

PrintMessage( HUD_PRINTTALK, "MONOCULUS! has been defeated!" )

		self.stunned = true
		self:EmitSound("vo/halloween_eyeball/eyeball10.mp3", 150)
		self:EmitSound("misc/halloween_eyeball/book_spawn.wav", 125)
		self:SetModel("models/props_halloween/bombonomicon.mdl")
		timer.Simple(5, function()
			self:EmitSound("misc/halloween_eyeball/book_exit.wav", 125)
			self:Remove()
		end)
		self:EmitSound("ui/halloween_boss_defeated_monoculus.wav", 0)
		self:EmitSound("misc/halloween_eyeball/vortex_eyeball_died.wav", 125)
	end)
end

function ENT:OnRemove()
timer.Destroy("laugh")
end

function ENT:OnInjured( dmginfo )
	if ( self:HaveEnemy() ) then
	else
	self.SearchRadius = self.SearchRadius + 200
	self.LoseTargetDist = self.LoseTargetDist + 400
	end
	if dmginfo:GetInflictor():GetClass() == "rpg_missile" then
		self:EmitSound("Halloween.EyeballBossBecomeEnraged")
		self:SetSkin(1) 
		self:ResetSequence("angry") 
		timer.Simple(1, function()
			self.angry = true
		end)
		timer.Create("CalmDown", 10, 1, function()
			self.angry = false
			self:SetSkin(0)
			self:EmitSound("Halloween.EyeballBossCalmDown")
			coroutine.wait(1)
		end)
	end
	if dmginfo:GetInflictor():GetClass() == "grenade_ar2" then
		self:EmitSound("Halloween.EyeballBossBecomeEnraged")
		self:SetSkin(1)
		timer.Simple(1, function()
			self.angry = true
		end)
		self:ResetSequence("angry")
		timer.Create("CalmDown", 10, 1, function()
			self.angry = false
			self:SetSkin(0)
			self:EmitSound("vo/halloween_eyeball/eyeball07.mp3", 150)
			coroutine.wait(1)
		end)
	end
	if dmginfo:GetInflictor():GetClass() == "crossbow_bolt" then
		self:EmitSound("Halloween.EyeballBossBecomeEnraged")
		self:SetSkin(1)
		timer.Simple(1, function()
			self.angry = true
		end)
		self:ResetSequence("angry")
		timer.Create("CalmDown", 10, 1, function()
			self.angry = false
			self:SetSkin(0)
			self:EmitSound("vo/halloween_eyeball/eyeball07.mp3", 150)
			coroutine.wait(1)
		end)
	end
	if dmginfo:GetInflictor().critical == true then
		self:EmitSound("Halloween.EyeballBossBecomeEnraged")
		self:SetSkin(1)
		timer.Simple(1, function()
			self.angry = true
		end)
		self:ResetSequence("angry")
		timer.Create("CalmDown", 10, 1, function()
			self.angry = false
			self:SetSkin(0)
			self:EmitSound("vo/halloween_eyeball/eyeball07.mp3", 150)
			coroutine.wait(1)
		end)
	end
	if dmginfo:GetAttacker():GetClass() == "npc_combinegunship" or dmginfo:GetAttacker():GetClass() == "npc_helicopter" or dmginfo:GetAttacker():GetClass() == "npc_turret_floor" then
		self:EmitSound("Halloween.EyeballBossBecomeEnraged")
		self:SetSkin(1)
		timer.Simple(1, function()
			self.angry = true
		end)
		self:ResetSequence("angry")
		timer.Create("CalmDown", 10, 1, function()
			self.angry = false
			self:SetSkin(0)
			self:EmitSound("vo/halloween_eyeball/eyeball07.mp3", 150)
			coroutine.wait(1)
		end)
	end
	self:SetEnemy(dmginfo:GetAttacker())
	local effectdata = EffectData()
	effectdata:SetOrigin( dmginfo:GetDamagePosition() )
	util.Effect( "BloodImpact", effectdata )
end
	end
	
	
--[[	list.Set( "NPC", "eyeball_boss", {
	Name = "MONOCULUS!",
	Class = "eyeball_boss",
	Category = "Team Fortress 2"
} )]]