
DEFINE_BASECLASS( "base_gmodentity" )

local TranslateCModelToVModel = {
	["models/weapons/c_models/c_targe/c_targe.mdl"] = "models/weapons/c_models/c_v_targe/c_v_targe.mdl",
}

function ENT:GetHatData()
	return PlayerHats[self:GetNWString("HatName")]
end

function ENT:GetHatModel()
	local name = self:GetNWString("HatName")
	local data = PlayerHats[name]
	if data and not data.nomodel then
		return "models/player/items/"..(data.model or name)..".mdl"
	end
end

function ENT:SetupSkinAndBodygroups(ent)
	local hatdata = self:GetHatData()
	
	if hatdata then
		if hatdata.skin then
			ent:SetSkin(hatdata.skin)
		else
			if self:GetOwner():Team()==TEAM_BLU then
				ent:SetSkin(1)
			else
				ent:SetSkin(0)
			end
		end
		
		if hatdata.perclassbodygroup then
			local mdlname = self:GetOwner():GetPlayerClassTable().ModelName
			if mdlname and ClassToMedalBodygroup[mdlname] then
				ent:SetBodygroup(1, ClassToMedalBodygroup[mdlname])
			end
		end
		
		ent:StopParticles()
		if hatdata.particles then
			for a,p in pairs(hatdata.particles) do
				local att = ent:LookupAttachment(a)
				if att and att > 0 then
					ParticleEffectAttach(p, PATTACH_POINT_FOLLOW, ent, att)
				else
					ParticleEffectAttach(p, PATTACH_ABSORIGIN_FOLLOW, ent, 0)
				end
			end
		end
	end
end

function ENT:SetupPlayerBodygroups(pl)
	local hatdata = self:GetHatData()
	
	pl = pl or self:GetOwner()
	
	if hatdata and hatdata.hide then
		local mdlname = self:GetOwner():GetPlayerClassTable().ModelName
		if PlayerNamedBodygroups[mdlname] then
			for _,v in ipairs(hatdata.hide) do
				local d = PlayerNamedBodygroups[mdlname][v]
				if d then
					pl:SetBodygroup(d,1)
				end
			end
		end
	end
end

function ENT:SetupDataTables()
	self:DTVar("Bool", 0, "ShowInViewModel")
end

function ENT:ShowsInViewModel()
	return self.dt.ShowInViewModel
end

if CLIENT then

function ENT:DrawInViewModel(vm, wep)
	print(self:GetOwner())
	if not wep.AddedCModels then
		wep.AddedCModels = {}
	end
	
	if not IsValid(wep.AddedCModels[self]) then
		local mdlname = TranslateCModelToVModel[self:GetModel()] or self:GetModel()
		
		cm = ClientsideModel(mdlname)
		cm:SetPos(vm:GetPos())
		cm:SetAngles(vm:GetAngles())
		cm:AddEffects(EF_BONEMERGE)
		cm:SetParent(vm)
		cmself.WModel2:SetNoDraw(true)
		
		wep.AddedCModels[self] = cm
	end
	
	wep.AddedCModels[self]:DrawModel()
end

end

if SERVER then

AddCSLuaFile( "shared.lua" )

function ENT:Initialize()
	local hatdata
	
	if self.HatName then
		hatdata = PlayerHats[self.HatName]
	end
	
	if hatdata then
		self:SetNWString("HatName", self.HatName)
		self.Model = self:GetHatModel()
	else
		self:SetNWString("HatName", "")
	end
	
	if self.Model then
		self:SetModel(self.Model)
		self:SetKeyValue("effects", "1")
	else
		self:SetNoDraw(true)
		self:DrawShadow(false)
	end
	
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	
	local pl = self.Player or player.GetAll()[1]
	self:SetPos(pl:GetPos())
	self:SetAngles(pl:GetAngles())
	self:SetParent(pl)
	self:SetOwner(pl)
	
	self:SetupSkinAndBodygroups(self)
	self:SetupPlayerBodygroups()
	
	local att = self.Attributes or {}
	if att.show_in_vmodel then
		self.dt.ShowInViewModel = true
	else
		self.dt.ShowInViewModel = false
	end
end

hook.Add("DoPlayerDeath", "TFHatDisable", function(pl)
	for _,v in pairs(ents.FindByClass("tf_hat")) do
		if v:GetOwner()==pl then
			v:SetKeyValue("effects", "0")
			v:SetParent()
			vself.WModel2:SetNoDraw(true)
			v:DrawShadow(false)
			v.Dead = true
		end
	end
end)

hook.Add("PlayerHurt", "TFHatDisable2", function(pl)
	for k,v in pairs(ents.FindByClass("tf_weapon_invis_dringer")) do
		if v.Owner == pl then
			for _,v in pairs(ents.FindByClass("tf_hat")) do
				if v:GetOwner()==pl then
					v:SetKeyValue("effects", "0")
					v:SetParent()
					vself.WModel2:SetNoDraw(true)
					v:DrawShadow(false)
					v.Dead = true
				end
			end
		end
	end
end)

hook.Add("PlayerSpawn", "TFHatCleanup", function(pl)
	for _,v in pairs(ents.FindByClass("tf_hat")) do
		if v:GetOwner()==pl and v.Dead then
			v:Remove()
		end
	end
end)

end
