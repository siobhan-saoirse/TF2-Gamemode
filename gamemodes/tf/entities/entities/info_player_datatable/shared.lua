
-- Extends the player with

ENT.Type = "anim"  
ENT.Base = "base_anim"    

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "DeathFlags")
end

if SERVER then

AddCSLuaFile("shared.lua")

function ENT:Initialize()
	self:SetMoveType(MOVETYPE_NONE)
	self:SetNotSolid(true)
	self:SetNoDraw(true)
end


hook.Add("PlayerInitialSpawn", "PlayerCreateDataTable", function(pl)
	local ent = ents.Create("info_player_datatable")
	ent:SetPos(pl:GetPos())
	ent:SetAngles(pl:GetAngles())
	ent:SetParent(pl)
	ent:SetOwner(pl)
	ent:Spawn()
end)


else

function ENT:Draw()
end

end


local META = debug.getregistry().Entity

function META:GetDataTableEntity()
	if self:IsPlayer() then
		if IsValid(self.DataTableEntity) then
			return self.DataTableEntity
		else
			for _,v in pairs(ents.FindByClass("info_player_datatable")) do
				if v:GetOwner() == self then
					self.DataTableEntity = v
					return v
				end
			end
			return NULL
		end
	else
		return NULL
	end
end
