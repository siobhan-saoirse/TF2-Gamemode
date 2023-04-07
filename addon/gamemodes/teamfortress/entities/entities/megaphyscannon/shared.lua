ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Super Gravity Gun"
ENT.Category		= "Half-Life 2"

ENT.Spawnable		= true
ENT.AdminOnly = false
ENT.DoNotDuplicate = true

--[[
if SERVER then

AddCSLuaFile("shared.lua")
function ENT:SpawnFunction(ply, tr)

	if (!tr.Hit) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create("MegaPhyscannon")
	
	ent:SetPos(SpawnPos)
	ent:Spawn()
	ent:Activate()
	--ent.ClawOpenState = false
	ent.Planted = false
	
	return ent
end


/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()

	--local model = ("models/weapons/errolliamp/w_superphyscannon.mdl")
	local model = ("models/weapons/shadowysn/w_superphyscannon.mdl")
	
	self.Entity:SetModel(model)
	
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:DrawShadow(true)
	--self.Entity:SetNWBool("scgg_spawn_into_old", true)
	
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	local phys = self.Entity:GetPhysicsObject()
	
	if (phys:IsValid(self.WModel2)) then
		phys:Wake()
	end

	self.Entity:SetUseType(SIMPLE_USE)
	
	--[[if SERVER then
		util.AddNetworkString( "SCGG_Entity_InvalidateBone" )
	end
	if CLIENT then
		usermessage.Receive( "SCGG_Entity_InvalidateBone", function( entity ) 
			print("i has mesage")
			entity:InvalidateBoneCache()
		end )
	end
	self.Entity:Fire("AddOutput", "classname weapon_superphyscannon", 0)
end


function ENT:PhysicsCollide(data, physobj)
	
	// Play sound on bounce
	if ((data.Speed > 150 and data.Speed <= 180) and data.DeltaTime > 0.2) then
		self.Entity:EmitSound("weapon.ImpactSoft", 75, 100, vol)
	end
	if (data.Speed > 180 and data.DeltaTime > 0.2) then
		self.Entity:EmitSound("weapon.ImpactHard")
	end
end

/*---------------------------------------------------------
   Name: Use
---------------------------------------------------------*/
function ENT:Use(activator, caller)
	if self.Entity.Fading == true then return end
	
	if (activator:IsPlayer()) and not self.Planted then
		local gun = activator:GetWeapon( "weapon_superphyscannon" )
		if !IsValid(gun) then
		activator:Give("weapon_superphyscannon")
		local newgun = activator:GetWeapon( "weapon_superphyscannon" )
		newgun:SetMaterial(self.Entity:GetMaterial())
		newgun:SetColor(self.Entity:GetColor())
		end
		self.Entity:Remove()
	end
end

/*---------------------------------------------------------
   Name: Think
---------------------------------------------------------*/
function ENT:Think()
			if self.ClawOpenState == true then
			self:SetPoseParameter("super_active", 1)
			--net.Start("SCGG_Entity_InvalidateBone")
			--usermessage.WriteEntity( self )
			--net.Send( player.GetAll() )
			elseif self.ClawOpenState != true then
			self:SetPoseParameter("super_active", 0)
			--net.Start("SCGG_Entity_InvalidateBone")
			--usermessage.WriteEntity( self )
			--net.Send( player.GetAll() )
			end
		if game.GetGlobalState("super_phys_gun") == GLOBAL_OFF and GetConVar("scgg_enabled"):GetInt() <= 0 and self.Entity.Fading != true then
			self.Entity.Fading = true
			--self.Entity:SetNWBool("scgg_spawn_into_old", false)
			
			local coreattachmentID=self.Entity:LookupAttachment("core")
			local coreattachment = self.Entity:GetAttachment(coreattachmentID)
			local core = ents.Create("env_citadel_energy_core")
			core:SetPos( coreattachment.Pos )
			core:SetAngles( self.Entity:GetAngles() )
			core:SetParent( self.Entity )
			core:Spawn()
			core:Fire( "AddOutput","scale 1.5",0 )
			core:Fire( "StartCharge","0.1``",0.1 )
			
			self.Entity:EmitSound("Weapon_Physgun.Off", 75, 100, 1)
			
			timer.Simple( 0.70, function()
		if IsValid(self.Entity) then
				self.Entity:SetCollisionGroup(COLLISION_GROUP_WORLD)
				local normalgrav = ents.Create("weapon_physcannon")
				normalgrav:SetPos( self.Entity:GetPos() )
				normalgrav:SetAngles( self.Entity:GetPhysicsObject():GetAngles() )
				normalgrav:SetVelocity( self.Entity:GetVelocity() )
				normalgrav:Fire("Addoutput","spawnflags 2",0)
				normalgrav:Fire("Addoutput","spawnflags 0",1)
				normalgrav:Spawn()
				normalgrav:Activate()
				core:SetParent( normalgrav )
				core:Fire( "Stop","0",0 )
				core:Fire( "Kill","0",2 )
				
				cleanup.ReplaceEntity( self.Entity, normalgrav )
				undo.ReplaceEntity( self.Entity, normalgrav )
				undo.Finish();
				timer.Simple( 0.02, function()
					if IsValid(self.Entity) then
					self.Entity:Remove()
					end
				end )
		end
			end )
		end
	self.Entity:NextThink( 0.5 )
end

end

if CLIENT then

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
end

/*---------------------------------------------------------
   Name: DrawPre
---------------------------------------------------------*/
function ENT:Draw()
local Mat = Material( "sprites/blueflare1" )
Mat:SetInt("$spriterendermode",5)
local Zap = Material( "sprites/physcannon_bluelight1b" )
Zap:SetInt("$spriterendermode",5)
	self.Entity:DrawModel()
	
	local ledcolor = Color(230, 45, 45, 255)

  	local TargetPos = self.Entity:GetPos() + (self.Entity:GetUp() * 11.6) + (self.Entity:GetRight() * 2) + (self.Entity:GetForward() * 1.5)

	local FixAngles = self.Entity:GetAngles()
	local FixRotation = Vector(90, 90, 90)
	
	FixAngles:RotateAroundAxis(FixAngles:Right(), FixRotation.x)
	FixAngles:RotateAroundAxis(FixAngles:Up(), FixRotation.y)
	FixAngles:RotateAroundAxis(FixAngles:Forward(), FixRotation.z)

	local scale = math.Rand( 8, 10 )
	local scale2 = math.Rand( 25, 27 )
	local scale3 = math.Rand( 3, 4 )
	local scale7 = math.Rand( 12, 14 )
	
	local StartPos 		= self.Entity:GetPos()
	local ViewModel 	= Owner == LocalPlayer()
	
	render.SetMaterial( Mat )
		
		local vm = self.Entity
		if (!vm || vm == NULL) then return end
		
		local attachmentID=vm:LookupAttachment("core")
		local attachment = vm:GetAttachment(attachmentID)
		StartPos = attachment.Pos
		
		local attachmentID2=vm:LookupAttachment("fork1t")
		local attachment_O = vm:GetAttachment( attachmentID2 )
		StartPosO = attachment_O.Pos
		
		local attachmentID3=vm:LookupAttachment("fork2t")
		local attachment_L = vm:GetAttachment( attachmentID3 )
		StartPosL = attachment_L.Pos
		
		local attachmentID4=vm:LookupAttachment("fork3t")
		local attachment_R = vm:GetAttachment( attachmentID4 )
		StartPosR = attachment_R.Pos
		
		local attachmentID5=vm:LookupAttachment("fork1m")
		local attachment_OH = vm:GetAttachment( attachmentID5 )
		StartPosOH = attachment_OH.Pos
		
		local attachmentID6=vm:LookupAttachment("fork2m")
		local attachment_LH = vm:GetAttachment( attachmentID6 )
		StartPosLH = attachment_LH.Pos
		
		local attachmentID7=vm:LookupAttachment("fork3m")
		local attachment_RH = vm:GetAttachment( attachmentID7 )
		StartPosRH = attachment_RH.Pos
		
		render.DrawSprite( StartPos, scale7, scale7, Color(255,255,255,240))
		render.DrawSprite( StartPosO, scale3, scale3, Color(255,255,255,80))
		render.DrawSprite( StartPosL, scale3, scale3, Color(255,255,255,80))
		render.DrawSprite( StartPosR, scale3, scale3, Color(255,255,255,80))
		render.DrawSprite( StartPosOH, scale3, scale3, Color(255,255,255,80))
		render.DrawSprite( StartPosLH, scale3, scale3, Color(255,255,255,80))
		render.DrawSprite( StartPosRH, scale3, scale3, Color(255,255,255,80))
end

end]]