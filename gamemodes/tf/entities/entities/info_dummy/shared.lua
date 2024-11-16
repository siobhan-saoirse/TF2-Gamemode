
ENT.Type = "anim"  
ENT.Base = "base_anim"    

function ENT:SetupDataTables()
	self:DTVar("Entity", 0, "AttachEntity")
end

if CLIENT then

local function GetAttachPosition(t)
	-- From TF2 bone
	local bone = t:LookupBone("bip_spine_2")
	if bone then return t:GetBonePosition(bone) end
	
	-- From HL2 bone
	local bone = t:LookupBone("ValveBiped.Bip01_Spine2")
	if bone then return t:GetBonePosition(bone) end
	
	if !_R then return t:GetPos() end

	-- From bounding box center
	local pos = _R.Vector.__add(t:WorldSpaceAABB())
	pos:Mul(0.5)
	return pos
end

function ENT:Think()
	if not IsValid(self.dt.AttachEntity) then return end
	self:SetPos(GetAttachPosition(self.dt.AttachEntity))
	self:NextThink(CurTime())
	return true
end

end

if SERVER then

AddCSLuaFile("shared.lua")

function ENT:Initialize()
	self:SetMoveType(MOVETYPE_NONE)
	self:SetNotSolid(true)
	self:SetNoDraw(true)
end

function ENT:AttachToEntity(ent)
	self.dt.AttachEntity = ent
end

end
