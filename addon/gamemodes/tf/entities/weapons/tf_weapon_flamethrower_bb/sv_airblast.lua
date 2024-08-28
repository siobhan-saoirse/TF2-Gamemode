
local function minicrit_true() return true end

local AirblastFunc = {
	["grenade_spit"] = function(self, ent, dir)
		ent:SetLocalVelocity(dir * 2000)
		ent:SetOwner(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "grenade_spit_deflect"
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end,
	["grenade_ar2"] = function(self, ent, dir)
		ent:SetLocalVelocity(dir * 2000)
		ent:SetOwner(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "grenade_ar2_deflect"
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end,
	["crossbow_bolt"] = function(self, ent, dir)
		ent:SetLocalVelocity(dir * 2000)
		ent:SetOwner(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "crossbow_bolt_deflect"
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end, 
	["npc_grenade_frag"] = function(self, ent, dir)
		local phys = ent:GetPhysicsObject()
		if not phys:IsValid() then return false end
		
		local vel = phys:GetVelocity()
		phys:AddVelocity(dir * math.Clamp(vel:Length(),1000,100000) - vel)
		
		ent:SetOwner(self.Owner)
		ent:SetPhysicsAttacker(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "npc_grenade_frag_deflect"
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end,
	["prop_combine_ball"] = function(self, ent, dir)
		local phys = ent:GetPhysicsObject()
		if not phys:IsValid() then return false end
		
		local vel = phys:GetVelocity()
		phys:AddVelocity(dir * math.Clamp(vel:Length(),1000,100000) - vel)
		
		ent:SetOwner(self.Owner)
		ent:SetPhysicsAttacker(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.MiniCrit = minicrit_true
		ent.NameOverride = "prop_combine_ball_deflect"
		ent:EmitSound(self.AirblastDeflectSound)
		
		if phys:HasGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG) then
			-- The combine ball was fired by a NPC, and simply dissolves stuff without damaging them
			-- Convert it into a player combine ball when it is airblasted
			phys:ClearGameFlag(FVPHYSICS_NO_NPC_IMPACT_DMG)
			phys:AddGameFlag(FVPHYSICS_DMG_DISSOLVE)
			phys:AddGameFlag(FVPHYSICS_HEAVY_OBJECT)
		end
		return true
	end,
	["rpg_missile"] = function(self, ent, dir)
		ent:SetLocalVelocity(dir * 2000)
		local dmginfo = DamageInfo()
		ent:SetOwner(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "rpg_missile_deflect"
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end,
	["tf_projectile_rocket"] = function(self, ent, dir)
		ent:SetLocalVelocity(dir * 2000)
		ent:SetOwner(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "tf_projectile_rocket_deflect"
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end,
	["soldierbot_rocket_launched"] = function(self, ent, dir)
		ent:SetLocalVelocity(dir * 2000)
		ent:SetOwner(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "tf_projectile_rocket_deflect"
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end,	
	["tf_projectile_rocket_fireball"] = function(self, ent, dir)
		ent:SetLocalVelocity(dir * 2000)
		ent:SetOwner(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "tf_weapon_flamethrower"
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end,
	["soldier_rocket_launched"] = function(self, ent, dir)
		ent:SetLocalVelocity(dir * 2000)
		ent:SetOwner(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "tf_projectile_rocket_deflect"
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end,
	["tf_projectile_rocket_airstrike"] = function(self, ent, dir)
		ent:SetLocalVelocity(dir * 2000)
		ent:SetOwner(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "tf_projectile_rocket_deflect"
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end,
	
	["tf_projectile_sentryrocket"] = function(self, ent, dir)
		ent:SetLocalVelocity(dir * 2000)
		ent:SetOwner(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "tf_projectile_rocket_deflect"
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end,
	["tf_projectile_pipe"] = function(self, ent, dir)
		ent:SetLocalVelocity(dir * 2000)
		ent:SetOwner(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "tf_projectile_pipe_deflect"
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end,
	["tf_projectile_cleaver"] = function(self, ent, dir)
		ent:SetLocalVelocity(dir * 2000)
		ent:SetOwner(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "tf_projectile_pipe_deflect"
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end,
	["tf_projectile_flare"] = function(self, ent, dir)
		ent:SetLocalVelocity(dir * 2000)
		ent:SetOwner(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "tf_projectile_pipe_deflect"
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end,
	["tf_projectile_ball"] = function(self, ent, dir)
		ent:SetLocalVelocity(dir * 2000)
		ent:SetOwner(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "tf_projectile_pipe_deflect"
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end,
	["tf_projectile_pipe_remote"] = function(self, ent, dir)
		ent:SetLocalVelocity(dir * 2000)
		ent:Detach()
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "tf_projectile_pipe_remote_deflect"
		ent:SetOwner(self.Owner)
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end,
	["tf_projectile_arrow"] = function(self, ent, dir)
		ent:SetLocalVelocity(dir * 2000)
		ent:SetOwner(self.Owner)
		ent.AttackerOverride = self.Owner
		ent.NameOverride = "tf_projectile_arrow_deflect"
		ent.MiniCrit = minicrit_true
		ent:EmitSound(self.AirblastDeflectSound)
		return true
	end,
}

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
					v:SetLocalVelocity(dir2 * 400)
					v:SetThrownByExplosion(true)
					
					if v:IsPlayer() then
						umsg.Start("TFAirblastImpact", v)
						umsg.End()
					end
				end
			elseif v.Reflect then
				v:Reflect(self.Owner, self, dir)
				reflect = true
			elseif AirblastFunc[c] then
				if AirblastFunc[c](self, v, dir, dir2) then
					reflect = true
				end
			elseif v:GetMoveType()==MOVETYPE_VPHYSICS then
				for i=0,v:GetPhysicsObjectCount()-1 do
					v:GetPhysicsObjectNum(i):ApplyForceCenter(18000*dir)
				end
			elseif v:IsTFPlayer() and self.Owner:IsFriendly(v) then
				GAMEMODE:ExtinguishEntity(v)
				v:EmitSound("player/flame_out.wav", 90)
			end
		end
	end
	
	if reflect then
		self:EmitSound(self.AirblastDeflectSound)
	end
end
