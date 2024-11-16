function ENT:Initialize()
	self:SetModel( "models/props_gameplay/resupply_locker.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
 
    local phys = self:GetPhysicsObject()
	if (phys:IsValid(self.WModel2)) then
		phys:Wake()
	end

	self.Team = 0
	self.Players = {}
	self.Opened = false
end
 
function ENT:Use( activator, caller )
    return
end
 

function ENT:KeyValue(key,value)
	key = string.lower(key)
	
	if key=="teamnum" then
		self.Team = tonumber(value)
	elseif key=="associatedmodel" then
		selfName = value
	end
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() then
		self.Players[ent] = -1
	end
end

function ENT:EndTouch(ent)
	if ent:IsPlayer() then
		self.Players[ent] = nil
	end
end

function ENT:Think()
	local resupplied
	
	for pl,last in pairs(self.Players) do
		if last==-1 or CurTime()-last>1 then
			resupplied = true
			GAMEMODE:GiveHealthPercent(pl, 100)
			GAMEMODE:GiveAmmoPercent(pl, 100)
			if self.Opened then
				self:EmitSound("AmmoPack.Touch", 100, 100)
			end
			self.Players[pl] = CurTime()
		end
	end
	
	if resupplied and not self.Opened then
		self:EmitSound("Regenerate.Touch", 100, 100)
		
		if not self and selfName then
			self = ents.FindByName(selfName)[1]
			----print("associatedmodel : "..selfName.." : "..tostring(self))
		end
		
		if self and self:IsValid(self.WModel2) then
			--self:ResetSequence(self:LookupSequence("open"))
			self:Fire("SetAnimation", "open")
		end
		
		self.Opened = true
		self.NextClose = CurTime() + 1.5
	end
	
	if self.NextClose and CurTime()>=self.NextClose then
		if self and self:IsValid(self.WModel2) then
			--self:ResetSequence(self:LookupSequence("close"))
			--self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
			self:Fire("SetAnimation", "close")
			self.NextIdle = CurTime() + 1.5
		else
			self.NextIdle = CurTime() + 1.5
		end
		self.NextClose = nil
	end
	
	if self.NextIdle and CurTime()>=self.NextIdle then
		--[[if self and self:IsValid(self.WModel2) then
			self:ResetSequence(self:LookupSequence("idle"))
		end]]
		
		self.NextIdle = nil
		self.Opened = false
	end
end
