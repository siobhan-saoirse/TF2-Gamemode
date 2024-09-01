AddCSLuaFile() 
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("shd_util.lua")
AddCSLuaFile("shd_anim.lua")
AddCSLuaFile("shd_sound.lua")
AddCSLuaFile("shd_crits.lua")

include("shared.lua")

SWEP.Weight				= 5
SWEP.AutoSwitchTo		= false 
SWEP.AutoSwitchFrom		= false
SWEP.HoldType = "IDLE"
  
--CreateConVar("tf_weapon_deploy_speed", "0.17", {FCVAR_NOTIFY, FCVAR_SERVER_CAN_EXECUTE}, "The deploy speed of everybody's weapons on the server.")

hook.Add("PlayerAuthed", "TF_SendAllWeaponData", function(pl, steamid, uniqueid) 
	for _,v in pairs(ents.GetAll()) do
		if v.SendExtraAttributes then
			v:SendExtraAttributes(pl)
		end
	end
end)

function SWEP:CallOnOwnerClient(func, param)
	if not self.Owner or not self.Owner:IsValid() then return end
	
	umsg.Start("CallTFWeaponFunction", self.Owner)
		umsg.Entity(self)
		umsg.String(func)
		umsg.String(param or "")
	umsg.End()
end

function SWEP:CallOnClients(func, param, rp)
	umsg.Start("CallTFWeaponFunction", rp)
		umsg.Entity(self)
		umsg.String(func)
		umsg.String(param or "")
	umsg.End()  
end

-- obsolete
function SWEP:GetTextureDecal(trace)
	local texture
	if trace.MatType == 77 then
		texture = "decals/metal/shot" .. math.random(1,5)
		sound.Play( "physics/metal/metal_solid_impact_bullet" .. math.random(1,4) .. ".wav", trace.HitPos )
	elseif trace.MatType == 89 then
		texture = "decals/glass/shot" .. math.random(1,5)
		sound.Play( "physics/glass/glass_impact_bullet" .. math.random(1,4) .. ".wav", trace.HitPos )
	elseif trace.MatType == 87 then
		texture = "decals/wood/shot" .. math.random(1,5)
		sound.Play( "physics/wood/wood_solid_impact_bullet" .. math.random(1,5) .. ".wav", trace.HitPos )
	elseif trace.MatType == 67 then
		texture = "decals/concrete/tf_shot" .. math.random(1,5)
	elseif trace.MatType == 68 then
		texture = "decals/dirtshot" .. math.random(1,4)
	else
		texture = "decals/concrete/shot" .. math.random(1,4)
	end
	local decal = ents.Create( "infodecal" )
	decal:SetPos(trace.HitPos)
	decal:SetKeyValue("texture", texture)
	decal:Spawn()
	decal:Activate()
end

function SWEP:CalculateAmmoGiven()
	if self.Owner.AmmoMax and self.Owner.AmmoMax[self.Primary.Ammo] then
		return self:Ammo1() / self.Owner.AmmoMax[self.Primary.Ammo]
	else
		return 0.5
	end
end

function SWEP:OnDrop()
	if (GetConVar("tf_allow_pickup_weapons"):GetBool()) then
		self.BaseClass.OnDrop(self)
	end
	local mdl
	if self.WorldModelOverride2 then
		mdl = self.WorldModelOverride2
	else
		mdl = (self:GetItemData().model_world or self:GetItemData().model_player) or self.WorldModel
	end
	
	timer.Remove("AutoReload")
	
	local drop = ents.Create("prop_physics")
	drop:SetSolid(SOLID_VPHYSICS)
	drop:SetModel(mdl)
	drop:PhysicsInit(SOLID_VPHYSICS)
	drop:Spawn()
	drop.AmmoPercent = self.AmmoGiven or 100
	drop:Activate()
	
	if mdl == "models/weapons/c_models/c_shotgun/c_shotgun.mdl" then
		drop:SetMaterial("models/weapons/w_shotgun_tf/w_shotgun_tf")
	end
	
	if self.CustomMaterialOverride then
		drop:SetMaterial(self.CustomMaterialOverride)
	end
	
	if self.CustomColorOverride then
		drop:SetColor(self.CustomColorOverride)
	end
	
	drop:SetSkin(self.WeaponSkin or 0)
	drop:SetMaterial(self.WeaponMaterial or 0)
	
	drop:SetPos(self:GetPos())
	drop:SetAngles(self:GetAngles())
	
	drop:SetMoveType(MOVETYPE_VPHYSICS)
	drop:SetCollisionGroup(COLLISION_GROUP_WORLD)
	
	local phys = drop:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(10)
		phys:Wake()
		if self.DropVelocity then
			phys:SetVelocity(self.DropVelocity)  
		end 
	end
	
	local ammo = ents.Create("item_droppedweapon")
	ammo:SetSolid(SOLID_VPHYSICS)
	ammo:SetModel("models/items/ammopack_medium.mdl")
	ammo:PhysicsInit(SOLID_VPHYSICS)
	ammo:Spawn()
	ammo.AmmoPercent = self.AmmoGiven or 100
	ammo:Activate()
	
	if mdl == "models/weapons/c_models/c_shotgun/c_shotgun.mdl" then
		ammo:SetMaterial("models/weapons/w_shotgun_tf/w_shotgun_tf")
	end
	
	if self.CustomMaterialOverride then
		ammo:SetMaterial(self.CustomMaterialOverride)
	end
	
	if self.CustomColorOverride then
		ammo:SetColor(self.CustomColorOverride)
	end
	
	ammo:SetSkin(self.WeaponSkin or 0)
	ammo:SetMaterial(self.WeaponMaterial or 0)
	
	ammo:SetPos(self:GetPos())
	ammo:SetAngles(self:GetAngles())
	
	ammo:SetMoveType(MOVETYPE_VPHYSICS)
	ammo:SetCollisionGroup(COLLISION_GROUP_WORLD)
	
	local phys = ammo:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(10)
		phys:Wake()
		if self.ammoVelocity then
			phys:SetVelocity(self.ammoVelocity)  
		end 
	end
	
	timer.Stop("AutoReload")
	
	self:Remove()
end

function SWEP:DropAsAmmo()
	self.AmmoGiven = self:CalculateAmmoGiven() * 100
	self.DropVelocity = self.Owner:GetVelocity()
	self.Owner:DropWeapon(self)
end
--[[
function SWEP:DropAsAmmo()
	local mdl
	if self.WorldModelOverride2 then
		mdl = self.WorldModelOverride2
	else
		mdl = (self:GetItemData().model_world or self:GetItemData().model_player) or self.WorldModel
	end
	
	local drop = ents.Create("item_droppedweapon")
	drop:SetSolid(SOLID_VPHYSICS)
	drop:SetModel(mdl)
	drop:PhysicsInit(SOLID_VPHYSICS)
	drop:Spawn()
	drop.AmmoGiven = self:CalculateAmmoGiven() * 100
	drop:Activate()
	
	if mdl == "models/weapons/c_models/c_shotgun/c_shotgun.mdl" then
		drop:SetMaterial("models/weapons/w_shotgun_tf/w_shotgun_tf")
	end
	drop:SetSkin((self.Owner:Team() == TEAM_BLU and 1) or 0)
	
	local mat = drop:GetBoneMatrix(0)
	local invrot
	
	if mat then
		invrot = mat:GetAngles():GetInverse()
	end
	
	local bonename = drop:GetBoneName(0)
	mat = self.Owner:GetBoneMatrix(self.Owner:LookupBone(bonename))
	if mat then
		local pos = mat:GetTranslation()
		mat:SetTranslation(vector_origin)
		
		mat:Rotate(invrot)
		
		local ang = mat:GetAngles()
		ang.y = ang.y + self.Owner:EyeAngles().y
		
		mat = Matrix()
		mat:Rotate(Angle(0, self.Owner:EyeAngles().y, 0))
		mat:Translate(pos-self.Owner:GetPos())
		
		drop:SetPos(self.Owner:GetPos() + mat:GetTranslation())
		drop:SetAngles(ang)
	else
		drop:SetPos(self:GetPos() + 40 * vector_up)
		drop:SetAngles(self:GetAngles())
	end
	
	drop:SetMoveType(MOVETYPE_VPHYSICS)
	drop:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	local phys = drop:GetPhysicsObject()
	if phys:IsValid() then
		phys:SetMass(10)
		phys:Wake()
		phys:SetVelocity(self.Owner:GetVelocity())
	end
end
]]

