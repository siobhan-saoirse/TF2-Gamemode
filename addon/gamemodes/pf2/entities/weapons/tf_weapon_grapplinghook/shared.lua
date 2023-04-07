-- credit to https://steamcommunity.com/sharedfiles/filedetails/?id=1696595790

if CLIENT then
	SWEP.PrintName			= "Grappling Hook"
SWEP.Slot				= 6
SWEP.RenderGroup		= RENDERGROUP_BOTH
end

SWEP.Base				= "tf_weapon_melee_base"
SWEP.Crosshair = "tf_crosshair3"
 
SWEP.Category			= "Team Fortress 2"
SWEP.PrintName			= "Grappling Hook"
SWEP.ViewModel = "models/weapons/c_models/c_scout_arms_empty.mdl"
SWEP.WorldModel = "models/weapons/c_models/c_grappling_hook/c_grappling_hook.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= false
SWEP.AdminOnly          = true
SWEP.jumped 			= false
local sndGrappleHitPlayer		= Sound("weapons/grappling_hook_impact_flesh.wav")
local sndGrappleHit		= Sound("weapons/grappling_hook_impact_default.wav")
local sndGrappleShoot	= Sound("weapons/grappling_hook_shoot.wav")
local sndGrappleReel	= Sound("weapons/grappling_hook_reel_start.wav")
local sndGrappleAbort	= Sound("weapons/grappling_hook_reel_stop.wav")


local VM_FIRESTART = ACT_GRAPPLE_FIRE_START
local VM_FIREIDLE = ACT_GRAPPLE_FIRE_IDLE
local VM_PULLSTART = ACT_GRAPPLE_PULL_START
local VM_PULLIDLE = ACT_GRAPPLE_PULL_IDLE
local VM_PULLEND = ACT_GRAPPLE_PULL_END 

function SWEP:Think()

	if (!self.Owner || self.Owner == NULL) then return end
	
	
	nextshottime = CurTime()
	self.zoomed = false
	
	if ( self.Owner:KeyPressed( IN_ATTACK )) then
		if (self.jumped) then return end
		self:StartAttack()
		
	elseif ( self.Owner:KeyDown( IN_ATTACK ) && inRange) then
		if (self.jumped) then return end
		self:UpdateAttack()
		
	elseif ( self.Owner:KeyReleased( IN_ATTACK ) && inRange ) then
	
		self:EndAttack( true )
	
	end
	
	self.VM_DRAW = ACT_GRAPPLE_DRAW

	self.VM_IDLE = ACT_GRAPPLE_IDLE
		if self.Owner:GetPlayerClass() == "engineer" then
			self:SetHoldType("SECONDARY") 
		elseif (!self.Owner:IsHL2()) then
			self:SetHoldType("MELEE_ALLCLASS")  
		else
			self:SetHoldType("melee")  
		end
	return self:CallBaseFunction("Think")

end

function SWEP:DoTrace( endpos )
	local trace = {}
		trace.start = self.Owner:GetShootPos()
		trace.endpos = trace.start + (self.Owner:GetAimVector() * 32768) --14096 is length modifier.
		if(endpos) then trace.endpos = (endpos - self.Tr.HitNormal * 7) end
		trace.filter = { self.Owner, self.Weapon }
		
	self.Tr = nil
	self.Tr = util.TraceLine( trace )
end
function SWEP:CalcViewModelView(vm, oldpos, oldang, newpos, newang)
	if not self.VMMinOffset and self:GetItemData() then
		local data = self:GetItemData()
		if data.static_attrs and data.static_attrs.min_viewmodel_offset then
			self.VMMinOffset = Vector(data.static_attrs.min_viewmodel_offset)
		end
	end

	if GetConVar("tf_use_min_viewmodels"):GetBool() then -- TODO: Check for inspecting
		newpos = newpos + (newang:Forward() * 10)
		newpos = newpos + (newang:Right() * 0)
		newpos = newpos + (newang:Up() * -6)
	end

	return newpos, newang
end
function SWEP:StartAttack()
	-- Get begining and end poins of trace.
	local gunPos = self.Owner:GetShootPos() -- Start of distance trace.
	local disTrace = self.Owner:GetEyeTrace() -- Store all results of a trace in disTrace.
	local hitPos = disTrace.HitPos -- Stores Hit Position of disTrace.
	
	-- Calculate Distance
	-- Thanks to rgovostes for this code.
	local x = (gunPos.x - hitPos.x)^2;
	local y = (gunPos.y - hitPos.y)^2;
	local z = (gunPos.z - hitPos.z)^2;
	local distance = math.sqrt(x + y + z);
	
	-- Only latches if distance is less than distance CVAR, or CVAR negative
	local distanceCvar = GetConVarNumber("grapple_distance")
	inRange = false
	if distanceCvar < 0 or distance <= distanceCvar then
		inRange = true
	end 
	
	
	if inRange then
		if (SERVER) then
			
			if (!self.Beam) then -- If the beam does not exist, draw the beam.
				-- grapple_beam
				self.Beam = ents.Create( "trace2" )
					self.Beam:SetPos( self.Owner:GetShootPos() )
				self.Beam:Spawn()
				if CLIENT then
					if self.Owner:Team() == TEAM_BLU then
						self.Beam.matBeam = Material( "cable/cable_blue" )
					else
						self.Beam.matBeam = Material( "cable/cable_red" )
					end
				end
			end
			
			self.Beam:SetParent( self.Owner )
			self.Beam:SetOwner( self.Owner )
		
		end
		
		self:DoTrace()
		self.speed = 3500 -- Rope latch speed. Was 3000.
		self.startTime = CurTime()
		self.endTime = CurTime() + self.speed
		self.dt = -1
		
		if (SERVER && self.Beam) then
			self.Beam:GetTable():SetEndPos( self.Tr.HitPos )
		end
		
		self:UpdateAttack()
		self:SendWeaponAnim(ACT_GRAPPLE_FIRE_START)
		timer.Simple(0.15, function()
			if (!self.Owner:KeyDown( IN_ATTACK ) || (self.jumped)) then return end
			self:SendWeaponAnim(ACT_GRAPPLE_FIRE_IDLE)
		end)
		self.Owner:EmitSound( sndGrappleShoot )
		if (self.Owner:IsHL2()) then
			self.Owner:SetAnimation(PLAYER_ATTACK1)
		else
			self.Owner:DoAnimationEvent(ACT_DOD_CROUCH_ZOOMED,true)
		end
	end
end

function SWEP:UpdateAttack()

	--self.Owner:LagCompensation( true )
	
	if (!endpos) then endpos = self.Tr.HitPos end
	
	if (SERVER && self.Beam) then
		self.Beam:GetTable():SetEndPos( endpos )
	end

	lastpos = endpos
	
	
	if (!self.Beam) then

	-- Get begining and end poins of trace.
	local gunPos = self.Owner:GetShootPos() -- Start of distance trace.
	local disTrace = self.Owner:GetEyeTrace() -- Store all results of a trace in disTrace.
	local hitPos = disTrace.HitPos -- Stores Hit Position of disTrace.
	
	-- Calculate Distance
	-- Thanks to rgovostes for this code.
	local x = (gunPos.x - hitPos.x)^2;
	local y = (gunPos.y - hitPos.y)^2;
	local z = (gunPos.z - hitPos.z)^2;
	local distance = math.sqrt(x + y + z);
	
	-- Only latches if distance is less than distance CVAR, or CVAR negative
	local distanceCvar = GetConVarNumber("grapple_distance")
	inRange = false
	if distanceCvar < 0 or distance <= distanceCvar then
		inRange = true
	end 
	
	
	if inRange then
		if (SERVER) then
				
				if (!self.Beam) then -- If the beam does not exist, draw the beam.
					-- grapple_beam
					self.Beam = ents.Create( "trace2" )
						self.Beam:SetPos( self.Owner:GetShootPos() )
					self.Beam:Spawn()
					if CLIENT then
						if self.Owner:Team() == TEAM_BLU then
							self.Beam.matBeam = Material( "cable/cable_blue" )
						else
							self.Beam.matBeam = Material( "cable/cable_red" )
						end
					end
				end
				
				self.Beam:SetParent( self.Owner )
				self.Beam:SetOwner( self.Owner )
			
			end
			
			self:DoTrace()
			self.speed = 3500 -- Rope latch speed. Was 3000.
			self.startTime = CurTime()
			self.endTime = CurTime() + self.speed
			self.dt = -1
			
			if (SERVER && self.Beam) then
				self.Beam:GetTable():SetEndPos( self.Tr.HitPos )
			end
			
			self:UpdateAttack()
			self:SendWeaponAnim(ACT_GRAPPLE_FIRE_START)
			timer.Simple(0.15, function()
				if (!self.Owner:KeyDown( IN_ATTACK ) || (self.jumped)) then return end
				self:SendWeaponAnim(ACT_GRAPPLE_FIRE_IDLE)
			end)
			self.Owner:EmitSound( sndGrappleShoot )
			if (self.Owner:IsHL2()) then
				self.Owner:SetAnimation(PLAYER_ATTACK1)
			else
				self.Owner:DoAnimationEvent(ACT_DOD_CROUCH_ZOOMED,true)
			end
		end
	end
				
			if ( self.Tr.Entity:IsValid() ) then
			
					endpos = self.Tr.Entity:GetPos()
					if ( SERVER ) then
					self.Beam:GetTable():SetEndPos( endpos )
					end
			
			end
			
			local vVel = (endpos - self.Owner:GetPos())
			local Distance = endpos:Distance(self.Owner:GetPos())
			
			local et = (self.startTime + (Distance/self.speed))
			if(self.dt != 0) then
				self.dt = (et - CurTime()) / (et - self.startTime)
			end
			if(self.dt < 0) then
				
				if !self.Owner:KeyDown( IN_JUMP ) then 
					self.Owner:EmitSound("Grappling")
				end
				if self.Tr.Entity:IsTFPlayer() then
					self.Tr.Entity:EmitSound( ")weapons/fx/rics/arrow_impact_flesh.wav", 95 )
					self.Tr.Entity:EmitSound( sndGrappleHitPlayer )
					self.Tr.Entity:EmitSound( "GrappledFlesh" )
					if !self.Tr.Entity:IsFriendly(self.Owner) then
						self.Tr.Entity:TakeDamage(5, self.Owner, self)
					end
					timer.Create("Bleed"..self.Owner:EntIndex(), 0.5, 0, function()
						if self.Tr.Entity:Health() <= 1 then self.Tr.Entity:StopSound("GrappledFlesh") timer.Stop("Bleed"..self.Owner:EntIndex()) return end
						if !self.Owner:Alive() then self.Tr.Entity:StopSound("GrappledFlesh") timer.Stop("Bleed"..self.Owner:EntIndex()) return end
						if !self.Owner:KeyDown( IN_ATTACK ) || (self.jumped) then self.Tr.Entity:StopSound("GrappledFlesh") timer.Stop("Bleed"..self.Owner:EntIndex()) return end
						if !IsValid(self) then self.Tr.Entity:StopSound("GrappledFlesh") timer.Stop("Bleed"..self.Owner:EntIndex()) return end
						if !self.Tr.Entity:IsFriendly(self.Owner) then
							self.Tr.Entity:TakeDamage(5, self.Owner, self)
						end
					end)
				else	
					timer.Simple(0.02, function()
						if self.Owner:KeyDown( IN_JUMP ) then 
							yVel = self.Owner:GetVelocity().y
							vVel = vVel:GetNormalized()*1000
								if( SERVER ) then
								local gravity = GetConVarNumber("sv_Gravity")
								vVel:Add(Vector(0,0,(50/20)*2.0)) -- Player speed. DO NOT MESS WITH THIS VALUE!
								if(yVel < 0) then
									vVel:Sub(Vector(0,0,yVel/10))
								end
					
								self.Owner:SetLocalVelocity(vVel)
								end
							
								zVel = self.Owner:GetVelocity().z
								vVel = vVel:GetNormalized()*1000
									if( SERVER ) then
									local gravity = GetConVarNumber("sv_Gravity")
									vVel:Add(Vector(0,0,(50/20)*1.5)) -- Player speed. DO NOT MESS WITH THIS VALUE!
									if(zVel < 0) then
										vVel:Sub(Vector(0,0,zVel/10))
									end
					
									self.Owner:SetLocalVelocity(vVel)
									end
							if ( CLIENT ) then return end
							if ( !self.Beam ) then return end
							self.Owner:StopSound("Grappling")
							self.jumped = true
							self.Beam:Remove()
							self.Beam = nil
							self:SendWeaponAnim(ACT_GRAPPLE_PULL_END)
							timer.Simple(0.5, function()
								if (self.jumped) then
									self.jumped = false
								end
							end)
							self.Owner:EmitSound( sndGrappleHit )
							self.dt = 1
						else
							if (self.Beam) then
								self.Beam:EmitSound( sndGrappleHit )
							end
						end
					end)
				end
				if (self.jumped) then return end
				self:SendWeaponAnim(ACT_GRAPPLE_PULL_START)
				self.Owner:DoAnimationEvent(ACT_DOD_CROUCHWALK_ZOOMED,true)
				timer.Simple(0.3, function()
					if !self.Owner:KeyDown( IN_ATTACK ) or (self.jumped) then return end
					self:SendWeaponAnim(ACT_GRAPPLE_PULL_IDLE)
				end)
				timer.Create("AirWalkAnim"..self.Owner:EntIndex(), self.Owner:SequenceDuration(self.Owner:LookupSequence("a_grapple_pull_idle")), 0, function()
					if !self.Owner:KeyDown( IN_ATTACK ) or (self.jumped) then self.Tr.Entity:StopSound("GrappledFlesh") timer.Stop("AirWalkAnim"..self.Owner:EntIndex()) return end
					if !IsValid(self) then self.Tr.Entity:StopSound("GrappledFlesh") timer.Stop("AirWalkAnim"..self.Owner:EntIndex()) return end
					self.Owner:DoAnimationEvent(ACT_DOD_WALK_ZOOMED,true)
				end)
				if (self.jumped) then
					return
				else
					self.dt = 0
					
				
				timer.Simple(0.02, function()
					if self.Owner:KeyDown( IN_JUMP ) then 
						self.Owner:SetPos(self.Owner:GetPos() + Vector(0,0,30))
						yVel = self.Owner:GetVelocity().y
						vVel = vVel:GetNormalized()*1000
							if( SERVER ) then
							local gravity = GetConVarNumber("sv_Gravity")
							vVel:Add(Vector(0,0,(50/20)*2.0)) -- Player speed. DO NOT MESS WITH THIS VALUE!
							if(yVel < 0) then
								vVel:Sub(Vector(0,0,yVel/10))
							end
				
							self.Owner:SetLocalVelocity(vVel)
							end
						
							zVel = self.Owner:GetVelocity().z
							vVel = vVel:GetNormalized()*1000
								if( SERVER ) then
								local gravity = GetConVarNumber("sv_Gravity")
								vVel:Add(Vector(0,0,(50/20)*1.5)) -- Player speed. DO NOT MESS WITH THIS VALUE!
								if(zVel < 0) then
									vVel:Sub(Vector(0,0,zVel/10))
								end
				
								self.Owner:SetLocalVelocity(vVel)
								end
						if ( CLIENT ) then return end
						if ( !self.Beam ) then return end
						self.Owner:EmitSound( sndGrappleAbort )
						self.Owner:StopSound("Grappling")
						self.jumped = true
						self.Beam:Remove()
						self.Beam = nil
						self:SendWeaponAnim(ACT_GRAPPLE_PULL_END)
						timer.Simple(0.4, function()
							if (self.jumped) then
								self.jumped = false
							end
						end)
						self.Owner:EmitSound( sndGrappleHit )
						self.dt = 1
					end
				end)
				end
			end
			
			if(self.dt == 0) then
			zVel = self.Owner:GetVelocity().z
			vVel = vVel:GetNormalized()*1000
				if( SERVER ) then
				local gravity = GetConVarNumber("sv_Gravity")
				vVel:Add(Vector(0,0,(50/20)*1.65)) -- Player speed. DO NOT MESS WITH THIS VALUE!
				if(zVel < 0) then
					vVel:Sub(Vector(0,0,zVel/10))
				end

				self.Owner:SetLocalVelocity(vVel)
				end
			end
	
	endpos = nil
	
	--self.Owner:LagCompensation( false )
	
end

function SWEP:EndAttack( shutdownsound )
	
	if ( shutdownsound ) then
		self.Owner:EmitSound( sndGrappleAbort )
		self.Owner:StopSound("Grappling")
	end
	
	if ( CLIENT ) then return end
	if ( !self.Beam ) then return end
	
	self.Beam:Remove()
	self.Beam = nil
	self:SendWeaponAnim(ACT_GRAPPLE_PULL_END)
end

function SWEP:Holster()
	self:EndAttack( false )
	if SERVER then
		--self.WModel2:Remove()
	end
	self.BaseClass.Holster(self)
	return true
end
function SWEP:Deploy()
	self:SendWeaponAnim(ACT_GRAPPLE_DRAW)
	self.BaseClass.Deploy(self)
	return true
end

function SWEP:OnRemove()
	self:EndAttack( false )
	self.BaseClass.OnRemove(self)
	return true
end


function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end