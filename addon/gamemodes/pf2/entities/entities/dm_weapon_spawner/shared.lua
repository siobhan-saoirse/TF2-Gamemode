AddCSLuaFile()

ENT.Type = "anim"  
ENT.Base = "item_base"    

ENT.Model = "models/props_junk/PopCan01a.mdl"
ENT.Weapon = "weapon_smg1"
ENT.Prop = nil



function ENT:Initialize()
	self:SetModel(self.Model)
	self:SetSolid(SOLID_VPHYSICS)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:DrawShadow(false)
	--self:SetNoDraw(true)
	
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:EmitSound("items/spawn_item.wav")
	self:SetTrigger(true)
end

function ENT:Think()
	if self.NextActive and CurTime()>=self.NextActive then
		self.NextActive = nil
	end
	
	if self.NextRespawn and CurTime()>=self.NextRespawn then
		self:Show()
		self.NextRespawn = nil
	end
	self:SetAngles(self:GetAngles() + Angle(0, 10, 0))
	if self:GetModel() == "models/weapons/w_models/w_rocketlauncher.mdl" then
		self:SetModel("models/weapons/c_models/c_bet_rocketlauncher/c_bet_rocketlauncher.mdl")
	end
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() then
		self:PlayerTouched(ent)
		self:Hide()
	end
end
function ENT:PlayerTouched(pl)
	pl:Give(self.Weapon)
	pl:SelectWeapon(self.Weapon)
	pl:EmitSound("items/gunpickup2.wav")
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	
	if key=="weaponname" then
		local wep = tostring(value)
		self.Weapon = tostring(value) 
		timer.Create("SetWeapon", 0.5, 0, function()
			self.Weapon = tostring(value) 
		end)	
	elseif key=="spawnpropname" then
		self.Prop = tostring(value) 
		timer.Create("SetProp", 0.5, 0, function()
			self.Prop = tostring(value) 
		end)
		timer.Create("SpawnProp", 40, 0, function()
			local button = ents.Create( "prop_physics" )
			if ( !IsValid( button ) ) then return end -- Check whether we successfully made an entity, if not - bail
			button:SetModel( self.Prop )
			button:SetPos( self:GetPos() )
			button:Spawn()
			self:EmitSound("items/spawn_item.wav", 80, 100)
		end)
	elseif key=="model" then
		local model = tostring(value) 
		self.Model = model
		self:SetModel(model)
		timer.Create("SetModel", 0.5, 0, function()
			if model == "models/weapons/w_models/w_rocketlauncher.mdl" then
				self:SetModel("models/weapons/c_models/c_bet_rocketlauncher/c_bet_rocketlauncher.mdl")
			else
				self:SetModel(model)
			end
		end)
		print(model)
	end
end
