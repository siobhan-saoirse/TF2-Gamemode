	
local ExtraAttributesPending = {}
local month_name = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}

module("tf_item", package.seeall)

-----------------------------------
-- BASE ITEM SHARED FUNCTIONS

local ITEM = {}

ITEM.IsTFItem = true

-- Should be called in ENT:Initialize on both client and server, should never be used on weapons, only on equippable SENTs
function ITEM:AddToPlayerItems()
	if not IsValid(self:GetOwner()) then return end
	
	if not self:GetOwner().PlayerItemList then
		self:GetOwner().PlayerItemList = {}
	end
	
	table.insert(self:GetOwner().PlayerItemList, self)
end

-- Should be called in ENT:OnRemove on both client and server, SENTs only
function ITEM:RemoveFromPlayerItems()
	if not IsValid(self:GetOwner()) then return end
	
	if not self:GetOwner().PlayerItemList then
		self:GetOwner().PlayerItemList = {}
	end
	
	for k,v in ipairs(self:GetOwner().PlayerItemList) do
		if self == v then
			table.remove(self:GetOwner().PlayerItemList, k)
			break
		end
	end
end

function ITEM:SetupDataTables()
	self:DTVar("Int", 0, "ItemID")
	if SERVER then self.dt.ItemID = -1 end
end

function ITEM:SetQuality(q)
	self:SetNWInt("Quality", q)
end

function ITEM:GetQuality()
	return self:GetNWInt("Quality")
end

function ITEM:SetLevel(l)
	self:SetNWInt("Level", l)
end

function ITEM:GetLevel()
	return self:GetNWInt("Level")
end

function ITEM:SetCustomName(n)
	self:SetNWString("CustomName", n)
end

function ITEM:GetCustomName()
	return self:GetNWString("CustomName")
end

function ITEM:SetCustomDescription(d)
	self:SetNWString("CustomDescription", d)
end

function ITEM:GetCustomDescription()
	return self:GetNWString("CustomDescription")
end

function ITEM:SetItemIndex(i)
	self.dt.ItemID = i
end

function ITEM:ItemIndex()
	return self.dt.ItemID or 0
end

function ITEM:GetItemData()
	local item = tf_items.ItemsByID[self:ItemIndex()]
	return item or {}
end

function ITEM:GetAttributes()
	return self.Attributes or self:GetItemData().attributes or {}
end

function ITEM:GetAttribute(class)
	for _,a in pairs(self.Attributes or self:GetItemData().attributes or {}) do
		if a.attribute_class == class then return a end
	end
end

function ITEM:IsAttributeEnabled(class)
	local att = self:GetAttribute(class)
	return att and att.value~=0
end

function ITEM:GetVisuals()
	return self:GetItemData().visuals or {}
end

function ITEM:GetKillIconName()
	local d = self:GetItemData()
	if d.item_iconname then
		return d.item_iconname
	else
		return self:GetClass()
	end
end

function ITEM:FindItemSet()
	local name = self:GetItemData().name
	if not name then return end
	
	for k,v in pairs(tf_items.ItemSets) do
		for _,n in ipairs(v.items or {}) do
			if n == name then
				return v
			end
		end
	end
end

function ITEM:CheckUpdateItem()
	local id = self:ItemIndex()
	if id>-1 and id~=self.CurrentItemID then
		local item = tf_items.ItemsByID[id]
		if item then
			--MsgN(Format("SetupItem [%d] %s", id, tostring(self)))
			self:SetupItem(tf_items.ItemsByID[id])
		else
			--MsgN(Format("WARNING: From '%s': Item #%d not found!", self:GetClass(), id))
		end
		self.CurrentItemID = id
	end
end

function ITEM:SendExtraAttributes(pl)
	if SERVER and self.ExtraAttributes then
		umsg.Start("TF_SetExtraAttributes", pl)
			--umsg.Entity(self)
			umsg.Long(self:EntIndex())
			umsg.Char(#self.ExtraAttributes)
			for _,v in ipairs(self.ExtraAttributes) do
				umsg.Short(v.id)
				umsg.Float(v.value)
			end
		umsg.End()
	end
end

function ITEM:SetExtraAttributes(att)
	self.ExtraAttributes = {}
	
	for _,v in ipairs(att) do
		local a = tf_items.AttributesByID[v[1]]
		
		if a then
			table.insert(self.ExtraAttributes, {
				id = v[1],
				name = a.name,
				attribute_class = a.attribute_class,
				value = v[2],
			})
		end
	end
	
	if #self.ExtraAttributes == 0 then return end
	
	self.ExtraAttributesTable = att
	
	self:SendExtraAttributes()
	
	if self.Attributes then
		table.Add(self.Attributes, self.ExtraAttributes)
		--self.ExtraAttributes = nil
		ApplyAttributes(self.ExtraAttributes, "equip", self, self.Owner)
	end
	
	if CLIENT then
		self.FormattedAttributes = nil
		if (IsValid(self.Owner:GetActiveWeapon())) then 
			if not self:IsWeapon() or self==self.Owner:GetActiveWeapon() then
				self:ResetParticles()
			end
		end
	end
end

function ITEM:OnEquipAttribute(att, owner)
	
end

function ITEM:InitAttributes(owner, attributes)
	--MsgFN("InitAttributes (%s) %s",tostring(self),tostring(owner))
	
	if not attributes then
		self.Attributes = {}
	else
		self.Attributes = table.Copy(attributes)
	end
	
	if self.ExtraAttributes then
		table.Add(self.Attributes, self.ExtraAttributes)
	end
	
	ApplyAttributes(self.Attributes, "equip", self, owner)
	
	if CLIENT then
		HudInspectPanel:Update()
		self.FormattedAttributes = nil
		if (IsValid(self.Owner:GetActiveWeapon())) then
			if not self:IsWeapon() or self==self.Owner:GetActiveWeapon() then
				self:ResetParticles()
			end
		end
	end
end

function ITEM:InitVisuals(owner, visuals)
	--MsgFN("InitVisuals (%s) %s",tostring(self),tostring(owner))
	visuals = visuals or {}
	
	if not IsValid(self) then return end
	if not isfunction(self.GetItemData) then return end
	if not self:GetItemData() then return end
	-- Skin and material
	self.WeaponSkin = visuals.skin
	if not self.WeaponSkin then
		if self.HasTeamColouredVModel or not self:IsWeapon() then
			self.WeaponSkin = (((owner:EntityTeam() == TEAM_BLU or owner:EntityTeam() == TF_TEAM_PVE_INVADERS) and 1) or 0)
		else
			self.WeaponSkin = 0
		end
	end
	
	if visuals.material_override then
		self.MaterialOverride = string.match(visuals.material_override, "(.-)%.vmt") or visuals.material_override
	end
	
	if self:IsWeapon() then
		self:SetSkin(self.WeaponSkin)
		if IsValid(owner) and IsValid(owner:GetViewModel()) then
			owner:GetViewModel():SetSkin(self.WeaponSkin)
		end
	end
	
	--self:SetMaterial(self.MaterialOverride)
	if self:IsWeapon() then
		if IsValid(owner) and IsValid(owner:GetViewModel()) then
			--owner:GetViewModel():SetMaterial(self.MaterialOvveride)
		end
	end
	
	-- Attached models
	if CLIENT then
		if visuals.attached_model_world and visuals.attached_model_world.model then
			self.AttachedWorldModel = visuals.attached_model_world.model
		elseif visuals.attached_model and visuals.attached_model.model then
			self.AttachedWorldModel = visuals.attached_model.model
		end
		
		if visuals.attached_model_view and visuals.attached_model_view.model then
			self.AttachedViewModel = visuals.attached_model_view.model
		elseif visuals.attached_model and visuals.attached_model.model then
			self.AttachedViewModel = visuals.attached_model.model
		end
	end
	
	-- Bodygroups
	--[[
	if not self:GetItemData().hide_bodygroups_deployed_only then
		if visuals.player_bodygroups then
			for _,group in ipairs(visuals.player_bodygroups) do
				--MsgFN("Setting bodygroup '%s' for player %s", group, tostring(owner))
				local b = PlayerNamedBodygroups[owner:GetPlayerClass()]
				if (visuals.player_bodygroups.hat) then
					owner:SetBodygroup(owner:FindBodygroupByName("hat"), 1)
				end
				if b and b[group] then
					owner:SetBodygroup(b[group], 1)
				end
				
				b = PlayerNamedViewmodelBodygroups[owner:GetPlayerClass()]
				if b and b[group] then
					if IsValid(owner:GetViewModel()) then
						owner:GetViewModel():SetBodygroup(b[group], 1)
					end
				end
			end
		end
	end]]
	
	
	-- Muzzles, tracers, sound effects
	for k,v in pairs(visuals) do
		if k=="muzzle_flash" then
			self.MuzzleEffect = v
			PrecacheParticleSystem(v)
		elseif k=="tracer_effect" then
			self.TracerEffect = v
			PrecacheParticleSystem(v)
			PrecacheParticleSystem(v.."_red")
			PrecacheParticleSystem(v.."_blue")
			PrecacheParticleSystem(v.."_red_crit")
			PrecacheParticleSystem(v.."_blue_crit")
		--elseif string.find(k, "sound") then
		--	self:ModifySound(k, v)
		end
	end
	
	if self.CreateSounds then
		self:CreateSounds(owner)
	end
	
	-- Thirdperson animations
	if visuals.animations then
		for act,rep in pairs(visuals.animations) do
			if debug.getregistry()[act] and self.ActivityTranslate[debug.getregistry()[act]] then
				self.ActivityTranslate[debug.getregistry()[act]] = debug.getregistry()[rep]
			end
		end
	end
end

function GlobalApplyBodygroups(ent, owner, itemdata)
	if not itemdata.hide_bodygroups_deployed_only then
		local visuals = itemdata.visuals or {}
		
		if visuals.player_bodygroups then
			for _,group in ipairs(visuals.player_bodygroups) do
				local b = PlayerNamedBodygroups[owner:GetPlayerClass()]
				if b and b[group] then
					ent:SetBodygroup(b[group], 1)
				end
				
				if ent:IsPlayer() then
					b = PlayerNamedViewmodelBodygroups[owner:GetPlayerClass()]
					if b and b[group] then
						if IsValid(ent:GetViewModel()) then
							ent:GetViewModel():SetBodygroup(b[group], 1)
						end
					end
				end
			end
		end
	end
end

function ITEM:ApplyPlayerBodygroups(ent)
	GlobalApplyBodygroups(ent or self.Owner, self.Owner, self:GetItemData())
end

function ITEM:InitProjectileAttributes(proj)
	proj.Attributes = self:GetAttributes()
	ApplyAttributesFromEntity(self, "projectile_fired", proj, self, self.Owner)
end

function ITEM:SetupItem(item)

	if SERVER then
		if self:IsWeapon() and self.SetupCModelActivities then
			if item.attach_to_hands==1 then
				local t = self.Owner:GetPlayerClassTable()
				if t and t.ModelName then
					self.ViewModelOverride = Format("models/weapons/c_models/c_%s_arms.mdl", t.ModelName)
					self.ViewModel = self.ViewModelOverride
					self:SetModel(self.ViewModelOverride)
					self.Owner:GetViewModel():SetModel(self.ViewModelOverride)
					self:SetupCModelActivities(item)
				end
			else
				self:SetupCModelActivities()
				self.ViewModelOverride = nil
			end
		end
	else
		if ExtraAttributesPending[self:EntIndex()] then
			--MsgFN("Processing extra attributes for pending item %s", tostring(self))
			self:SetExtraAttributes(ExtraAttributesPending[self:EntIndex()])
			ExtraAttributesPending[self:EntIndex()] = nil
			
			if self:IsWeapon() and self == self.Owner:GetActiveWeapon() then
				HudInspectPanel:Update()
			end
		end
		
		self:InitAttributes(self.Owner, item.attributes_by_id)
		
		if self.Owner:EntityTeam() == TEAM_BLU then
			self:InitVisuals(self.Owner, item.visuals_blu or item.visuals)
		else
			self:InitVisuals(self.Owner, item.visuals_red or item.visuals)
		end
		
		if self:IsWeapon() and self.SetupCModelActivities then
			if item.attach_to_hands==1 then
				local t = self.Owner:GetPlayerClassTable()
				if t and t.ModelName then
					self.ViewModelOverride = Format("models/weapons/c_models/c_%s_arms.mdl", t.ModelName)
					self:SetModel(self.ViewModelOverride)
					self:SetupCModelActivities(item)
				end
				
				if item.model_player then
					self.HasCModel = true
					self.WorldModelOverride = item.model_player
				end
			else
				self:SetupCModelActivities()
				self.HasCModel = false
				
				-- won't be using the original worldmodel anymore, since it tends to randomly disappear when the player is near NPCs
				if self.WorldModel ~= "" then
					self.WorldModelOverride = self.WorldModel
				end
			end
			
			self.WorldModelOverride2 = item.model_world
		
			-- todo: optimize clientside models, certainly don't need to create up to 4 clientside entities for each weapon
			--self:InitializeCModel()
			--self:InitializeWModel2()
			self:InitializeAttachedModels()
		end
	end
end

-----------------------------------
-- BASE ITEM CLIENTSIDE FUNCTIONS
 
if CLIENT then

function ITEM:ClearParticles()
	self:StopParticles()
	if IsValid(self.RootLocator) then self.RootLocator:StopParticles() end
	
	if self:IsWeapon() then
		if IsValid(self.Owner) and IsValid(self.Owner:GetViewModel()) then
			self.Owner:GetViewModel():StopParticles()
			if IsValid(self.Owner:GetViewModel().RootLocator) then self.Owner:GetViewModel().RootLocator:StopParticles() end
		end
		
		if IsValid(self.WModel2) then
			--self.WModel2:StopParticles()
			if IsValid(self.WModel2.RootLocator) then self.WModel2.RootLocator:StopParticles() end
		end
		
		if IsValid(self.CModel) then
			self.CModel:StopParticles()
			if IsValid(self.CModel.RootLocator) then self.CModel.RootLocator:StopParticles() end
		end
	end
end

local function UpdateRootLocator(self)
	if IsValid(self.RootLocator) then
		local mat = self:GetBoneMatrix(0)
		if mat then
			self.RootLocator:SetPos(mat:GetTranslation())
			self.RootLocator:SetAngles(mat:GetAngles())
		end
	end
end

local function ParticleEffectAttachToRoot(system, ent)
	if not IsValid(ent.RootLocator) then
		ent.RootLocator = ClientsideModel("models/props_junk/watermelon01.mdl")
		ent.RootLocator:SetPos(ent:GetPos())
		ent.RootLocator:SetNoDraw(true)
		ent.RootLocator:SetParent(ent)
		ent.RootLocator.Owner = ent
		ent.RootLocator.IsRootLocator = true
		--ent.BuildBonePositions = UpdateRootLocator
		ent:AddBuildBoneHook("UpdateRootLocator", UpdateRootLocator)
	end
	ParticleEffectAttach(system, PATTACH_ABSORIGIN_FOLLOW, ent.RootLocator, 0)
end

function ITEM:ResetParticles(state_override)
	--MsgFN("ResetParticles %s %s",tostring(self),state_override or -1)
	
	self:ClearParticles()
	
	if not self:IsWeapon() and (self.Owner == LocalPlayer() and not LocalPlayer():ShouldDrawLocalPlayer()) then
		return
	end
	
	local ent
	if not self:IsWeapon() then
		ent = self
	elseif self.Owner==LocalPlayer() and not LocalPlayer():ShouldDrawLocalPlayer() then
		ent = self:GetViewModelEntity()
	else
		ent = self:GetWorldModelEntity()
	end
	
	-- Attached particles
	for _,p in ipairs(self:GetVisuals().attached_particlesystems or {}) do
		local att
		if p.attachment then
			att = ent:LookupAttachment(p.attachment)
		end
		
		if att and att ~= 0 then
			ParticleEffectAttach(p.system, PATTACH_POINT_FOLLOW, ent, att)
		else
			ParticleEffectAttachToRoot(p.system, ent)
		end
	end
	
	-- Attribute-controlled attached particles
	if self.AttachedParticle then
		--MsgFN("Attaching particle effect '%s' to %s",self.AttachedParticle.system, tostring(ent))
		
		local att
		if self.AttachedParticle.attachment then
			att = ent:LookupAttachment(self.AttachedParticle.attachment)
		end
		
		if att and att ~= 0 then
			ParticleEffectAttach(self.AttachedParticle.system, PATTACH_POINT_FOLLOW, ent, att)
		else
			if self.AttachedParticle.attach_to_rootbone then
				ParticleEffectAttachToRoot(self.AttachedParticle.system, ent)
			else
				ParticleEffectAttach(self.AttachedParticle.system, PATTACH_ABSORIGIN_FOLLOW, ent, 0)
			end
		end
	end
	
	-- Critical boost effect
	if self:IsWeapon() and (self.Owner:HasPlayerState(PLAYERSTATE_CRITBOOST, state_override) || self.Owner:HasPlayerState(PLAYERSTATE_MINICRIT, state_override)) then
		local effect
		local effect2
		local t = self.Owner:EntityTeam()
		
		if t==2 then
			effect = "critgun_weaponmodel_blu"
		else
			effect = "critgun_weaponmodel_red"
		end
		
		if t==2 then
			effect2 = "critgun_weaponmodel_blu_glow"
		else
			effect2 = "critgun_weaponmodel_red_glow"
		end
		
		ParticleEffectAttach(effect, PATTACH_ABSORIGIN_FOLLOW, ent, 0)
		ParticleEffectAttach(effect2, PATTACH_ABSORIGIN_FOLLOW, ent, 0)
	end
end

local function AddFormattedAttribute(a, fa)
	local d = tf_items.Attributes[a.name]
	
	if d and d.hidden == 0 then
		local s
		local effect = d.effect_type
		
		if tf_lang.Exists(d.description_string) then
			if d.description_format == "value_is_percentage" then
				s = math.Round((a.value - 1) * 100)
			elseif d.description_format == "value_is_inverted_percentage" then
				--s = math.Round(((1/a.value) - 1) * 100)
				s = math.Round((1 - a.value) * 100)
				if effect=="negative" then s = -s end
			elseif d.description_format == "value_is_additive" then
				s = math.Round(a.value * 1000) * 0.001
			elseif d.description_format == "value_is_or" then
				s = ""
			elseif d.description_format == "value_is_additive_percentage" then
				s = math.Round(a.value * 100)
			elseif d.description_format == "value_is_date" then
				local dt = os.date("!*t", a.value)
				s = Format("%s %d, %d (%02d:%02d:%02d GMT)", month_name[dt.month], dt.day, dt.year, dt.hour, dt.min, dt.sec)
			elseif d.description_format == "value_is_particle_index" then
				s = tf_lang.GetRaw(Format("#Attrib_Particle%d", a.value))
			end
			
			s = tf_lang.GetFormatted(d.description_string, s)
		else
			s = a.name
		end
		
		if d.attribute_class and IsAttributeUnimplemented(d.attribute_class) then
			if effect == "positive" then
				table.insert(fa, {-3, s})
			elseif effect == "negative" then
				table.insert(fa, {-4, s})
			else
				table.insert(fa, {-2, s})
			end
		else
			if effect == "positive" then
				table.insert(fa, {3, s})
			elseif effect == "negative" then
				table.insert(fa, {4, s})
			else
				table.insert(fa, {2, s})
			end
		end
	end
end

function ITEM:GetFormattedAttributes()
	if self.FormattedAttributes then
		return self.FormattedAttributes
	end
	
	local fa = {raw = ""}
	
	local item = self:GetItemData()
	if item.item_type_name and tf_lang.Exists(item.item_type_name) then
		table.insert(fa, {1, tf_lang.GetFormatted("ItemTypeDesc", self:GetLevel(), tf_lang.GetRaw(item.item_type_name))})
	end
	
	local desc = self:GetCustomDescription()
	
	if desc and desc ~= "" then
		table.insert(fa, {2, Format("\"%s\"", desc)})
	elseif item.item_description and tf_lang.Exists(item.item_description) then
		table.insert(fa, {2, tf_lang.GetRaw(item.item_description)})
	end
	
	if self.Attributes then
		for _,a in ipairs(self.Attributes) do
			AddFormattedAttribute(a, fa)
		end
	end
	
	local set = self:FindItemSet()
	if set then
		local complete_set = true
		for _,n in ipairs(set.items or {}) do
			if not self.Owner:HasTFItem(n) then
				complete_set = false
			end
		end
		
		if complete_set or tonumber(set.secret) ~= 1 then
			table.insert(fa, {1, ""})
			table.insert(fa, {5, tf_lang.GetRaw(set.name)})
			for _,n in ipairs(set.items or {}) do
				local item = tf_items.Items[n]
				if item then
					local name = tf_items.GetItemFullName(item)
					if self.Owner:HasTFItem(n) then
						table.insert(fa, {7, name})
					else
						table.insert(fa, {6, name})
					end
				end
			end
			
			if complete_set and set.attributes then
				table.insert(fa, {1, ""})
				table.insert(fa, {5, tf_lang.GetRaw("#TF_Set_Bonus")})
				for _,a in ipairs(set.attributes) do
					AddFormattedAttribute(a, fa)
				end
			end
		end
	end
	
	local raw = ""
	for i=1,#fa do
		if i>1 then
			raw = raw.."\n"
		end
		raw = raw..fa[i][2]
	end
	
	fa.raw = raw
	self.FormattedAttributes = fa
	return fa
end

usermessage.Hook("TF_SetExtraAttributes", function(msg)
	local entid, wep, num, att, id, value
	
	--wep = msg:ReadEntity()
	entid = msg:ReadLong()
	wep = Entity(entid)
	num = msg:ReadChar()
	
	--MsgFN("Received %d extra attribute(s) for %s (%d)", num, tostring(wep), entid)
	
	--MsgFN("%d attributes to read", num)
	if num <= 0 then return end
	
	att = {}
	for i=1,num do
		id = msg:ReadShort()
		value = msg:ReadFloat()
		--MsgFN("\"%d\" = %f", id, value)
		table.insert(att, {id,value})
	end
	
	if not IsValid(wep) or not wep.SetExtraAttributes then
		ExtraAttributesPending[entid] = att
		--MsgN("Weapon not initialized, adding to pending list")
		return
	end
	
	wep:SetExtraAttributes(att)
end)

hook.Add("Think", "TFCheckUpdateItems", function()
	
	if (math.random(1,3+(table.Count(player.GetAll())*0.4)) == 1) then 
		for _,v in pairs(ents.GetAll()) do
			if v.IsRootLocator and not IsValid(v:GetParent()) then
				v:Remove()
			elseif v.CheckUpdateItem then
				local ok, err = pcall(v.CheckUpdateItem, v)
				if not ok then
					ErrorNoHalt(Format("%s:CheckUpdateItem failed: %s", tostring(v), err))
				end
			end
		end
	end
end)

end

-----------------------------------
-- END OF BASE ITEM TABLE

function InitializeAsBaseItem(tbl)
	-- Add all base TF item functions to the entity's metatable
	table.Merge(tbl, ITEM)
end
