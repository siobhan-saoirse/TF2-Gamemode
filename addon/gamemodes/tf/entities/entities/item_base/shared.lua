
ENT.Type = "anim"  
ENT.Base = "base_anim"    

ENT.Model = ""

--ENT.AutomaticFrameAdvance = true

if SERVER then

AddCSLuaFile("shared.lua")

ENT.RespawnTime = 10

function ENT:SpawnFunction(pl, tr)
	if not tr.Hit then return end
	
	local pos = tr.HitPos
	
	local ent = ents.Create(self.ClassName)
	ent:SetPos(pos)
	ent:Spawn()
	ent:Activate()
	
	ent:SetPos(pos - Vector(0,0,ent:OBBMins().z))
	
	ent.RespawnTime = -1
	
	return ent
end

function ENT:Initialize()
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	--self:SetNoDraw(true)
	
	--self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetTrigger(true)
	self:SetNotSolid(true)
	
	--[[
	self.Prop = ents.Create("prop_dynamic")
	self.Prop:SetMoveType(MOVETYPE_NONE)
	self.Prop:SetSolid(SOLID_NONE)
	self.Prop:SetModel(self.Model)
	self.Prop:SetPos(self:GetPos())
	self.Prop:SetAngles(self:GetAngles())
	self.Prop:Spawn()
	
	self.Prop:SetParent(self)
	
	local sequence = self.Prop:LookupSequence("idle")
	self.Prop:ResetSequence(sequence)
	self.Prop:SetPlaybackRate(1)
	self.Prop:SetCycle(1)]]
	
	local sequence = self:SelectWeightedSequence(ACT_IDLE)
	self:ResetSequence(sequence)
	self:SetPlaybackRate(1)
	self:SetCycle(0)
	
	if self.ActivateDelay then
		self.NextActive = CurTime() + self.ActivateDelay
	end
end

function ENT:DropWithGravity(vel)
	self:SetMoveType(MOVETYPE_FLYGRAVITY)
	self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
	self:SetVelocity(vel)
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	
	if key=="model" then	
		self:SetModel(value)
	end
end

function ENT:SetRespawnTime(time)
	self.RespawnTime = time
end

function ENT:Show()
	self:SetTrigger(true)
	--self.Prop:SetColor(255,255,255,255)
	self:SetNoDraw(false)
	self:DrawShadow(true)
	self:EmitSound("items/spawn_item.wav", 100, 100)
end

function ENT:Hide()
	if self.RespawnTime<0 then 
		self:Remove()
		return
	end
	
	self:SetTrigger(false)
	--self.Prop:SetColor(0,0,0,0)
	self:SetNoDraw(true)
	self:DrawShadow(false)
	
	if self.RespawnTime then
		self.NextRespawn = CurTime() + self.RespawnTime
	end
end

function ENT:Think()
	if self.NextActive and CurTime()>=self.NextActive then
		self.NextActive = nil
	end
	
	if self.NextRespawn and CurTime()>=self.NextRespawn then
		self:Show()
		self.NextRespawn = nil
	end
end

function ENT:CanPickup(ply)
	return true
end

function ENT:PlayerTouched(pl)
	
end

function ENT:StartTouch(ent)
	if not self.NextActive and ent:IsTFPlayer() and self:CanPickup(ent) and ent != self:GetOwner() then
		self:PlayerTouched(ent)
	end
end

end

if CLIENT then

ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Draw()
	-- fuck AutomaticFrameAdvance, this is better
	if self.LastDrawn then
		self:FrameAdvance(CurTime() - self.LastDrawn)
	end
	self.LastDrawn = CurTime()
	
	self:DrawModel()
end

end
