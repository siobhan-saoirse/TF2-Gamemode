
ENT.Type = "anim"  
ENT.Base = "base_anim"    

if SERVER then

AddCSLuaFile("shared.lua")

ENT.AmmoPercent = 10
ENT.LifeTime = 30

function ENT:Initialize()
	if self.WeaponEntity then
		if not IsValid(self.WeaponEntity) then
			self:Remove()
			return
		end
		
		self:SetPos(self.WeaponEntity:GetPos())
		self:SetAngles(self.WeaponEntity:GetAngles())
		self:SetModel(self.WeaponEntity:GetModel())
		self:SetSolid(SOLID_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetNotSolid(true)
		self:SetOwner(self.WeaponEntity)
		self:SetParent(self.WeaponEntity)
		self:DeleteOnRemove(self.WeaponEntity)
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetTrigger(false)
		self:SetNoDraw(true)
		self.Active = false
	else
		self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
		self:SetTrigger(true)
		self.NextDie = CurTime() + self.LifeTime
	end
end

function ENT:Think()
	if IsValid(self.WeaponEntity) then
		if IsValid(self.WeaponEntity:GetOwner()) then
			if self.Active then
				self.Active = false
				self:SetTrigger(false)
				self.NextDie = nil
			end
		else
			if not self.Active then
				self.Active = true
				self:SetTrigger(true)
				self.NextDie = CurTime() + self.LifeTime
			end
		end
	end
	
	if self.NextDie and CurTime()>=self.NextDie then
		self:Remove()
		return false
	end
end

function ENT:CanPickup(ply)
	if ply:IsHL2() then return false end
	
	if IsValid(self.WeaponEntity) and IsValid(self.WeaponEntity:GetOwner()) then
		return false
	end
	
	return not ply:HasFullAmmo()
end

function ENT:PlayerTouched(pl)
	self:EmitSound("AmmoPack.Touch", 100, 100)
	self:Remove()
	GAMEMODE:GiveAmmoPercent(pl, self.AmmoPercent)
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() and self:CanPickup(ent) then
		self:PlayerTouched(ent)
	end
end

function ENT:OnTakeDamage(dmginfo)
	if not self.WeaponEntity then
		self:TakePhysicsDamage(dmginfo)
	end
end

end

if CLIENT then

ENT.RenderGroup 	= RENDERGROUP_BOTH

function ENT:Draw()
	self:DrawModel()
end

end