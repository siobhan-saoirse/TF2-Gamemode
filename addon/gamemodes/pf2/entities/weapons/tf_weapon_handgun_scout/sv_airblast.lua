
local function minicrit_true() return true end

function SWEP:DoAirblast()
	local r = self.AirblastRadius
	local dir = self.Owner:GetAimVector()
	local dir2 = dir:Angle()
	dir2.p = math.Clamp(dir2.p - 45,-90,90)
	dir2 = dir2:Forward()
	
	local pos = self.Owner:GetShootPos() + r * 1.5 * dir
	local reflect
	
	for _,v in pairs(ents.FindInBox(pos-Vector(r,r,r),pos+Vector(r,r,r))) do
		c = v:GetClass()
		--print(v)
		if v:GetOwner()~=self.Owner then
			if v:IsTFPlayer() and self.Owner:IsValidEnemy(v) and v:ShouldReceiveDamageForce() then
				if v:GetMoveType()==MOVETYPE_VPHYSICS then
					for i=0,v:GetPhysicsObjectCount()-1 do
						v:GetPhysicsObjectNum(i):ApplyForceCenter(18000*dir)
					end
				else
					v:SetGroundEntity(NULL)
					v:SetLocalVelocity(dir2 * 350)
					v:SetThrownByExplosion(true)
					
					if v:IsPlayer() then
						v:EmitSound(self.AirblastDeflectSound, 100, 100)
						v:SetThrownByExplosion(true)
						v:TakeDamage(10, self.Owner)
						v:SetLocalVelocity(dir2 * 350) 
						v:EmitSound("weapons/push_impact.wav", 100, 100)
						umsg.Start("TFAirblastImpact", v)
						umsg.End()
					end
				end
			elseif v.Reflect then
				v:Reflect(self.Owner, self, dir)
				reflect = true
			elseif v:GetMoveType()==MOVETYPE_VPHYSICS then
				for i=0,v:GetPhysicsObjectCount()-1 do
					v:GetPhysicsObjectNum(i):ApplyForceCenter(18000*dir)
				end
			end
		end
	end
	
	if reflect then
		self:EmitSound(self.AirblastDeflectSound)
	end
end
