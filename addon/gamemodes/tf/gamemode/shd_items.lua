
module("tf_items", package.seeall)

Attributes = {n=0}
Items = {n=0}
Qualities = {n=0}
Particles = {n=0}
ItemSets = {}

AttributesByID = {}
ItemsByID = {}
PrefabsByName = {}

COUNTER = 0

-- because fuck classname length limitations
-- keeps weapons more or less uniformed
local classtranslate = {
	["tf_weapon_rocketlauncher_directhit"] = "tf_weapon_rocketlauncher_dh",
	["tf_weapon_handgun_scout_primary"] = "tf_weapon_handgun_scout",
	["tf_weapon_bet_rocketlauncher"] = "tf_weapon_rocketlauncher_qrl",
} 

-- Adds an unique number before each attribute name so we can enumerate attributes in the right order
local function FormatAttributesBlock(a, str)
	local counter = 0
	return a..string.gsub(str, '"([^"]-)"(%s*{)', function(s,t)
		counter = counter + 1
		--return string.format('"%d-%s"%s', counter, s, t)
		return string.format('"%s-%d"%s', s, counter, t) -- util.KeyValuesToTable is bugged, work around
	end)
end

-- Store the item set items by numerical index rather than by name, so we can enumrate them in the right order
local function FormatItemSetBlock(a, str)
	local counter = 0
	return a..string.gsub(str, '"([^"]-)"(%s*".-")', function(s,t)
		counter = counter + 1
		return string.format('"%d" "%s"', counter, s, t)
	end)
end

-- Adds an unique number before each key which has the given name
local function FormatNamedBlocks(str, name)
	local counter = 0
	return string.gsub(str, '(%s*)"'..name..'"', function(s)
		counter = counter + 1
		return string.format('%s"%d-'..name..'"', s, counter)
	end)
end

-- Convert every numeric strings from a table into a number
local function ConvertStringsToNumbers(tbl)
	for k,v in pairs(tbl) do
		if type(v)=="table" then
			ConvertStringsToNumbers(v)
		elseif type(v)=="string" then
			local n = tonumber(v)
			if n then
				tbl[k] = n
			end
		end
	end
end

local visuals_names = {"visuals", "visuals_red", "visuals_blu"}

function ParseGameItems(data, silent)
	local smin, smax, smax1
	
	-- Loading qualities
	smin, smax = string.find(data, '"qualities"%s*%b{}')
	if not smin then
		if not silent then ErrorNoHalt("ITEM SCRIPT ERROR: Could not load qualities!\n") end
		return false
	end
	
	local data_qualities = string.sub(data, smin, smax)
	local numreg = 0
	local numign = 0
	
	for k,v in pairs(util.KeyValuesToTable(data_qualities)) do
		Qualities.n = Qualities.n + 1
		Qualities[k] = tonumber(v.value)
		numreg = numreg + 1
	end
	if not silent then Msg(numreg.." qualities registered.\n") end
	
	-- Loading items
	smin, smax = string.find(data, '"items"%s*%b{}', smax+1)
	if not smin then
		if not silent then ErrorNoHalt("ITEM SCRIPT ERROR: Could not load items!\n") end
		return false
	end
	
	local data_items = string.sub(data, smin, smax)
	numreg = 0
	
	data_items = string.gsub(data_items, '("attributes"%s*)(%b{})', FormatAttributesBlock)
	data_items = string.gsub(data_items, '("bundle"%s*)(%b{})', FormatItemSetBlock)
	for _,v in ipairs(visuals_names) do
		data_items = string.gsub(data_items, '("'..v..'"%s*%b{})', function(s) return FormatNamedBlocks(s,"attached_model") end)
		data_items = string.gsub(data_items, '("'..v..'"%s*%b{})', function(s) return FormatNamedBlocks(s,"hide_player_bodygroup_name") end)
		data_items = string.gsub(data_items, '("'..v..'"%s*%b{})', function(s) return FormatNamedBlocks(s,"show_player_bodygroup_name") end)
		data_items = string.gsub(data_items, '("'..v..'"%s*%b{})', function(s) return FormatNamedBlocks(s,"animation") end)
		data_items = string.gsub(data_items, '("'..v..'"%s*%b{})', function(s) return FormatNamedBlocks(s,"attached_particlesystem") end)
		data_items = string.gsub(data_items, '("'..v..'"%s*%b{})', function(s) return FormatNamedBlocks(s,"overide_material") end)
	end
	
	local hatlog = ""
	file.Write("test"..tostring(smax)..".txt", data_items)
	for k,v in pairs(util.KeyValuesToTable(data_items)) do
		if v.item_class and classtranslate[v.item_class] then
			v.item_class = classtranslate[v.item_class]
		end
		if (!v.item_slot) then
			v.item_slot = "misc"
		end
		if v.model_player then
			util.PrecacheModel(v.model_player)
			
			if v.item_slot == "head" or v.item_slot == "misc" then
				hatlog = hatlog..Format('["%s"] = {\n},\n', v.model_player)
			end
		end
		
		if v.attributes then
			v.attributes_by_id = {}
			v.attributes0 = {}
			for a,w in pairs(v.attributes) do
				--local num,name = string.match(a, "(%d)%-([%w%-%s]+)")
				local name,num = string.match(a, "([%w%-%s]+)%-(%d+)") -- util.KeyValuesToTable is bugged, work around
				name = string.lower(name)
				w.name = name
				v.attributes0[name] = w
				v.attributes[a] = nil
				v.attributes_by_id[tonumber(num)] = w
			end
			
			v.attributes = v.attributes0
			v.attributes0 = nil
		end
		
		if v.bundle then
			v.bundle0 = {}
			for k,i in pairs(v.bundle) do
				v.bundle0[tonumber(k)] = i
				v.bundle[k] = nil
			end
			
			v.bundle = v.bundle0
			v.bundle0 = nil
		end
		
		for _,name in ipairs(visuals_names) do
			local vis = v[name]
			
			if vis then
				--vis.attached_models = {}
				--vis.hide_player_bodygroup_names = {}
				--vis.show_player_bodygroup_names = {}
				--vis.animations = {}
				--vis.hide_player_bodygroup_names = {}
				--vis.player_bodygroups = {}
				--vis.attached_particlesystems = {}
				
				for a,w in pairs(vis) do
					if string.find(a, "sound") and type(w)=="string" then
						util.PrecacheSound(w)
					elseif a=="muzzle_flash" then
						PrecacheParticleSystem(w)
					elseif a=="tracer_effect" then
						PrecacheParticleSystem(w.."_red")
						PrecacheParticleSystem(w.."_blue")
						PrecacheParticleSystem(w.."_red_crit")
						PrecacheParticleSystem(w.."_blue_crit")
					elseif a=="custom_particlesystem" and type(w)=="table" and w.system then
						PrecacheParticleSystem(w.system)
					end
					
					local num = string.match(a, "(%d)%-attached_model")
					if num then
						if w.world_model then
							vis.attached_model_world = w
						elseif w.view_model then
							vis.attached_model_view = w
						else
							vis.attached_model = w
						end
						
						util.PrecacheModel(w.model)
						--vis.attached_models[tonumber(num)] = w
					end
					
					num = string.match(a, "(%d)%-player_bodygroups")
					if num then
						vis[a] = nil
						table.insert(vis.player_bodygroups, w)
					end

					num = string.match(a, "(%d)%-hide_player_bodygroup_name")
					if num then
						vis[a] = nil
						table.insert(vis.hide_player_bodygroup_names, w)
					end
					
					num = string.match(a, "(%d)%-show_player_bodygroup_name")
					if num then
						vis[a] = nil
						table.insert(vis.hide_player_bodygroup_names, w)
					end
					
					num = string.match(a, "(%d)%-animation")
					if num then
						vis[a] = nil
						vis.animations[w.activity] = w.replacement
					end
					
					num = string.match(a, "(%d)%-attached_particlesystem")
					if num then
						vis[a] = nil
						table.insert(vis.attached_particlesystems, w)
						PrecacheParticleSystem(w.system)
					end
					
					num = string.match(a, "(%d)%-material_override")
					if num then
						vis[a] = nil
						table.insert(vis.materials_overidded, w)
						PrecacheParticleSystem(w.system)
					end
				end
				if (name == "visuals_red") then
					v.visuals_red = vis
				elseif (name == "visuals_blu") then
					v.visuals_blu = vis
				elseif (name == "visuals") then
					v.visuals = vis
				end
			end
		end
		
		Items.n = Items.n + 1
		v.id = tonumber(k)
		
		Items[v.name] = v
		ItemsByID[v.id] = v
		numreg = numreg + 1
	end
	ConvertStringsToNumbers(Items)
	if not silent then MsgN(numreg.." items registered.") end
	
	file.Append("hatlog.txt", hatlog)
	--MsgN(numign.." items ignored.")
	
	-- Loading attributes
	smin, smax = string.find(data, '"attributes"%s*%b{}', smax+1)
	if not smin then
		if not silent then ErrorNoHalt("ITEM SCRIPT ERROR: Could not load attributes!\n") end
		return false
	end
	
	local data_attribs = string.sub(data, smin, smax)
	numreg = 0
	
	for k,v in pairs(util.KeyValuesToTable(data_attribs)) do
		Attributes.n = Attributes.n + 1
		v.id = tonumber(k)
		v.name = string.lower(v.name)
		Attributes[v.name] = v
		AttributesByID[v.id] = v
		numreg = numreg + 1
	end
	ConvertStringsToNumbers(Attributes)
	if not silent then Msg(numreg.." attributes registered.\n") end
	
	-- Loading items sets
	smin, smax1 = string.find(data, '"item_sets"%s*%b{}', smax+1)
	if smin then
		smax = smax1
		
		local data_item_sets = string.sub(data, smin, smax)
		numreg = 0
		
		data_item_sets = string.gsub(data_item_sets, '("attributes"%s*)(%b{})', FormatAttributesBlock)
		data_item_sets = string.gsub(data_item_sets, '("items"%s*)(%b{})', FormatItemSetBlock)
		
		for k,v in pairs(util.KeyValuesToTable(data_item_sets)) do
			v.id = k
			
			if v.attributes then
				v.attributes_by_id = {}
				v.attributes0 = {}
				for a,w in pairs(v.attributes) do
					--local num,name = string.match(a, "(%d)%-([%w%-%s]+)")
					local name,num = string.match(a, "([%w%-%s]+)%-(%d+)") -- util.KeyValuesToTable is bugged, work around
					name = string.lower(name)
					w.name = name
					v.attributes0[name] = w
					v.attributes[a] = nil
					v.attributes_by_id[tonumber(num)] = w
				end
				
				v.attributes = v.attributes0
				v.attributes0 = nil
			end
			
			if v.items then
				v.items0 = {}
				for k,i in pairs(v.items) do
					v.items0[tonumber(k)] = i
					v.items[k] = nil
				end
				
				v.items = v.items0
				v.items0 = nil
			end
			
			ItemSets[k] = v
			numreg = numreg + 1
		end
		
		if not silent then Msg(numreg.." item sets registered.\n") end
	end
	
	-- Loading particles
	smin, smax = string.find(data, '"attribute_controlled_attached_particles"%s*%b{}', smax+1)
	if not smin then
		ErrorNoHalt("ITEM SCRIPT ERROR: Could not load particles!\n")
		return false
	end
	
	local data_particles = string.sub(data, smin, smax)
	numreg = 0
	
	for k,v in pairs(util.KeyValuesToTable(data_particles)) do
		Particles.n = Particles.n + 1
		Particles[tonumber(k)] = v
		PrecacheParticleSystem(v.system)
		numreg = numreg + 1
	end
	if not silent then Msg(numreg.." particles registered.\n") end
	
	return true
end

--[[function file.Read( filename, path )
	if ( path == true ) then path = "GAME" end
	if ( path == nil or path == false ) then path = "DATA" end
 
	local f = file.Open( filename, "r", path )
	if ( !f ) then return end
	local str = f:Read( f:Size() )
	f:Close()
	return str or ""
end]]

function LoadGameItems(path)
	MsgN("Loading items script '%s' ...", path)
	
	local data
	
	if SERVER and game.IsDedicated() then
		data = file.Read("gamemodes/tf/gamemode/items/"..path, "GAME")
	else
		data = file.Read("gamemodes/tf/gamemode/items/"..path, "GAME")
	end
	
	if not data or data=="" then
		ErrorNoHalt("ITEM SCRIPT ERROR: File is empty or does not exist!\n")
		return
	end
	
	ParseGameItems(data, true) -- leaving this on silent for now, results in no script errors
end

local files, dirs = file.Find("gamemodes/tf/gamemode/items/workshop/*", "GAME")
for k,v in pairs(files) do
    if string.StartWith(v, "items_") then
        tf_items.LoadGameItems("workshop/"..v)
    end
end

function ReturnItems()
	return Items
end

function AddAttribute(data)
	AttributesByID[data.id] = data
	Attributes[data.name] = data
end

local META

if CLIENT then

META = FindMetaTable("Entity")

local QUALITY_COLORS = {
	[0] = "Normal",
	[3] = "Vintage",
	[6] = "Unique",
	
	[1] = "rarity1",
	[2] = "rarity2",
	[4] = "rarity3",
	[5] = "rarity4",
	
	[7] = "Community",
	[8] = "Developer",
	[9] = "SelfMade",
	[10] = "Customized",
	[11] = "Strange",
	[12] = "Completed",
	[13] = "Haunted",
	[14] = "Collectors",
	[69] = "Gey",
}

local QUALITY_TEXT = {
	[0] = "",
	[3] = "vintage",
	[6] = "",
	
	[1] = "common",
	[2] = "rare",
	[4] = "rare",
	[5] = "rarity4",
	
	[7] = "community",
	[8] = "developer",
	[9] = "selfmade",
	[10] = "customized",
	[11] = "strange",
	[12] = "completed", 
	[13] = "haunted",
	[14] = "collectors",
	[69] = "_kilburncorp",
}

function META:IsBaseTFWeapon()
	if not self.GetItemData then return true end
	if self:GetItemData().baseitem and table.Count(self.Attributes)==0 then return true end
	
	return false
end

function GetItemFullName(item, quality)
	if not item.item_name then return "" end
	
	local q = quality or (item.item_quality and Qualities[item.item_quality]) or 0
	
	if q == 0 then
		return tf_lang.GetRaw(item.item_name)
	elseif q==6 then
		if item.propername == 1 then
			return tf_lang.GetRaw("TF_Unique_Prepend_Proper") .. " " .. tf_lang.GetRaw(item.item_name) or item.item_name
		else
			return tf_lang.GetRaw(item.item_name) or item.item_name
		end
	else
		if QUALITY_TEXT[q] then
			return tf_lang.GetRaw(QUALITY_TEXT[q],true) .. " " .. tf_lang.GetRaw(item.item_name) or itf_lang.GetRaw(QUALITY_TEXT[q],true) .. " " .. item.item_name
		else
			return tf_lang.GetRaw(item.item_name) or item.item_name
		end
	end
end

function META:GetFullName()
	if self.GetCustomName then
		local name = self:GetCustomName()
		if name and name ~= "" then
			return Format("\"%s\"", name)
		end
	end
	
	local item = (self.GetItemData and self:GetItemData())
	
	if not item or not item.item_name then
		if self:IsWeapon() then
			return self:GetPrintName()
		else
			return ""
		end
	end
	
	local q = (self.GetQuality and self:GetQuality()) or 0
	return GetItemFullName(item, q)
end

function META:GetNameColor()
	local q = (self.GetQuality and self:GetQuality()) or 0
	
	return Colors["QualityColor"..QUALITY_COLORS[q]] or Colors.QualityColorUnique
end

function META:GetIconTextureID()
	local item = (self.GetItemData and self:GetItemData())
	
	if not item or not item.image_inventory then
		return
	end
	
	return surface.GetTextureID(item.image_inventory)
end

end

if SERVER then

META = FindMetaTable("Player")

function META:EmptyLoadoutSlot(slot, noupdate)
	if not self.ItemLoadout or not self.ItemProperties then return end
	
	local activeitem = self:GetActiveWeapon().GetItemData and self:GetActiveWeapon():GetItemData()
	local reselect = activeitem and activeitem.item_class
	local changed = false
	local removed
	
	for k,v in ipairs(self.ItemLoadout) do
		local item = Items[v]
		if item and item.item_slot == slot then
			if activeitem and activeitem.item_slot == slot then
				reselect = nil
			end
			
			changed = true
			table.remove(self.ItemLoadout, k)
			table.remove(self.ItemProperties, k)
			break
		end
	end
	
	if changed and self:Alive() and not noupdate then
		self:SetPlayerClass(self:GetPlayerClass())
		if reselect then
			self:SelectWeapon(reselect)
		end
	end
end

function META:EquipInLoadout(itemname, properties, noupdate)
	if not self.ItemLoadout or not self.ItemProperties then return end
	
	local activeitem = self:GetActiveWeapon().GetItemData and self:GetActiveWeapon():GetItemData()
	local reselect = activeitem and activeitem.item_class
	
	local newitem = Items[itemname]
	if not newitem then return end
	
	-- It's a bundle, don't equip it but equip all of its items instead
	if newitem.item_class == "bundle" then
		for _,v in ipairs(newitem.bundle or {}) do
			MsgFN("%s: Equipping item '%s'", itemname, v)
			self:EquipInLoadout(v, {}, true)
		end
		self:SetPlayerClass(self:GetPlayerClass())
		return
	end
	
	-- Looking for an item which is in the same slot as the item we want to equip
	local changed = false
	for k,v in ipairs(self.ItemLoadout) do
		local olditem = Items[v]
		if olditem and newitem.item_slot == olditem.item_slot and (string.find(newitem.item_class,"tf_weapon") || string.find(newitem.item_class,"demoshield") || string.find(newitem.prefab,"boots") || string.find(newitem.item_class,"tideturnr") || string.find(newitem.item_class,"chargintard") ) then
			changed = true
			self.ItemLoadout[k] = itemname
			self.ItemProperties[k] = properties
			if activeitem and activeitem.item_slot == newitem.item_slot then
				reselect = newitem.item_class
			end
			break
		end
	end
	
	-- The new item is in an empty slot, add it to the loadout
	if not changed then
		table.insert(self.ItemLoadout, itemname)
		self.ItemProperties[#self.ItemLoadout] = properties
		changed = true
	end
	
	if changed and self:Alive() and not noupdate then
		self:SetPlayerClass(self:GetPlayerClass())
		if reselect then
			self:SelectWeapon(reselect)
		end
	end
end

function META:ClearItemSetAttributes()
	self.ItemSetAttributes = nil
end

function META:GiveItemSetAttributes()
	local item_set
	if not self.ItemLoadout then return end
	
	for name, set in pairs(ItemSets) do
		local complete = true
		for _,n in ipairs(set.items or {}) do
			local found = false
			for _,m in ipairs(self.ItemLoadout) do
				if n == m then
					found = true
					break
				end
			end
			if not found then
				complete = false
				break
			end
		end
		
		if complete then
			item_set = set
			break
		end
	end
	
	if not item_set then return end
	self.ItemSetAttributes = item_set.attributes
	
	if self.ItemSetAttributes then
		self.ItemSetTable = {}
		ApplyAttributes(self.ItemSetAttributes, "equip", self.ItemSetTable, self)
	end
end

function META:GiveItem(itemname, properties)
	if not self:Alive() then return end
	
	local item
	if type(itemname)=="number" then
		item = ItemsByID[itemname]
	else
		item = Items[itemname]
	end
	
	if not item then
		--ErrorNoHalt(Format("Item '%s'does not exist!\n", itemname))
		return
	end
	--if not item.used_by_classes[self:GetPlayerClass()] then return end
	
	local class = item.item_class
	if item.use_class_suffix==1 then
		class = class.."_"..self:GetPlayerClass()
	end
	
	local reselectweapon
	
	if weapons.GetStored(class) then
		for _,w in pairs(self:GetWeapons()) do
			if w.GetItemData and w:GetItemData().item_slot == item.item_slot then
				if self:GetActiveWeapon() == w then
					reselectweapon = true
				end
				if self.AmmoMax[w.Primary.Ammo] then
					self:SetAmmoCount(self.AmmoMax[w.Primary.Ammo], w.Primary.Ammo)
				end
				self:StripWeapon(w:GetClass())
				break
			end
		end
	end
	
	--MsgN(Format("Giving '%s' to %s",itemname,tostring(self)))
	--self.WeaponItemIndex = item.id
	_G.TFWeaponItemOwner = self
	_G.TFWeaponItemIndex = item.id
	-- Initialization of the item is now done in SWEP:Deploy
	if (self:GetPlayerClass() == "spy" && class == "tf_weapon_builder") then
		class = "tf_weapon_sapper"
	end
	local weapon = NULL
	if scripted_ents.GetStored(class) then
		weapon = ents.Create(class)
		weapon.Owner = self
		weapon:SetOwner(self)
		weapon:SetPos(self:GetPos())
		weapon:SetAngles(self:GetAngles())
		weapon:SetItemIndex(item.id)
		weapon:Spawn()
	else
		weapon = self:Give(class)
	end
	
	local quality, level, custom_name, custom_desc
	
	if item.item_quality and tf_items.Qualities[item.item_quality] then
		quality = tf_items.Qualities[item.item_quality]
	end
	
	level = math.random(item.min_ilevel or 0, item.max_ilevel or 100)
	
	if properties then
		if properties.quality then
			quality = properties.quality
		end
		
		if properties.level then
			level = properties.level
		end
		
		if properties.custom_name then
			custom_name = properties.custom_name
		end
		
		if properties.custom_desc then
			custom_desc = properties.custom_desc
		end
		
		if properties.attributes and weapon.SetExtraAttributes then
			weapon:SetExtraAttributes(properties.attributes)
		end
	end
	
	if quality and weapon.SetQuality then
		weapon:SetQuality(quality)
	end
	
	if level and weapon.SetLevel then
		weapon:SetLevel(level)
	end
	
	if custom_name and weapon.SetCustomName then
		weapon:SetCustomName(custom_name)
	end
	
	if custom_desc and weapon.SetCustomDescription then
		weapon:SetCustomDescription(custom_desc)
	end
	
	if weapon.InitAttributes then
		weapon:InitAttributes(self, item.attributes)
	end
	
	if weapon.InitVisuals then
		if self:EntityTeam() == TEAM_BLU then
			weapon:InitVisuals(self, item.visuals_blu or item.visuals)
		elseif self:EntityTeam() == TF_TEAM_PVE_INVADERS then
			weapon:InitVisuals(self, item.visuals_blu or item.visuals)
		else
			weapon:InitVisuals(self, item.visuals_red or item.visuals)
		end
	end
	
	_G.TFWeaponItemOwner = nil
	_G.TFWeaponItemIndex = nil
	--self.WeaponItemIndex = nil
	--MsgN(Format("Done! (%s)",itemname))
	if not weapon.IsTFItem then
		--ErrorNoHalt(Format("Warning: item '%s' uses class '%s' which does not support the items system!\n", itemname, class))
	end
	
	if IsValid(weapon) and weapon:IsWeapon() and self.AmmoMax[weapon.Primary.Ammo] then
		self:SetAmmoCount(self.AmmoMax[weapon.Primary.Ammo], weapon.Primary.Ammo)
	end
	
	if reselectweapon then
		self:SelectWeapon(class)
	end
end

end

if SERVER then

function CC_GiveItem(pl,_,args)
	local resupply = nil

	if GetConVar("tf_competitive"):GetBool() then
		for k, v in pairs(ents.FindByClass("prop_dynamic")) do
			if v:GetModel() == "models/props_gameplay/resupply_locker.mdl" and v:GetPos():Distance(pl:GetPos()) <= 100 then
				resupply = v
			end
		end
		
		if !IsValid(resupply) then pl:ChatPrint("You need to be near a Resupply Locker!") return false end
	end

	for k,v in ipairs(args) do
		if string.find(v, " ") then
			args[k] = Format("%q", v)
		end
	end
	
	local str = string.Implode(" ",args)
	
	str = string.gsub(str, "Ol '", "Ol'") -- fucking shit ol' snaggletooth
	str = string.gsub(str, "Chargin '", "Chargin'") -- FUCKING SHIT CHARGIN' TARGE
	str = string.gsub(str, " '$", "'")
	str = string.gsub(str, " ' ", "'") -- dirty quickfix for item names such as "The Scotsman's Skullcutter"
	
	str = string.gsub(str, "%(%s*(%d+)%s+(%d+)%s+(%d+)%s*%)", function(r, g, b)
		return 65536*tonumber(r) + 256*tonumber(g) + tonumber(b)
	end)
	
	--MsgFN("%s: GiveItem %s", tostring(pl), str)
	
	local name, prop = string.match(str, "^(.-)%s*:(.+)$")
	if not name then
		name = str
	else
		local t = {}
		t.level = tonumber(string.match(prop, "[Ll]%s*=%s*(%d+)"))
		t.quality = tonumber(string.match(prop, "[Qq]%s*=%s*(%d+)"))
		t.custom_name = string.match(prop, "[Nn]%s*=%s*'(.-)'") or string.match(prop, "[Nn]%s*=%s*\"(.-)\"")
		t.custom_desc = string.match(prop, "[Dd]%s*=%s*'(.-)'") or string.match(prop, "[Dd]%s*=%s*\"(.-)\"")
		
		t.attributes = {}
		for a,v in string.gmatch(prop, "(%d+)%s*=%s*([0-9%.%-]+)") do
			if tonumber(a) and tonumber(v) then
				table.insert(t.attributes, {tonumber(a),tonumber(v)})
			end
		end
		
		--PrintTable(t)
		prop = t
	end
	
	--pl:GiveItem(name, prop)
	pl:EquipInLoadout(name, prop)
end

else

local filter_all = {slot={primary=true, secondary=true, melee=true, pda=true, pda2=true, building=true, head=true, misc=true}}
local filter_weapon = {slot={primary=true, secondary=true, melee=true, pda=true, pda2=true, building=true}}
local filter_head = {slot={head=true}}
local filter_misc = {slot={misc=true}}

local filter_bundle = {itemclass={bundle=true},not_an_entity=true,custom_filter=function(name, item, currentclass)
	-- This should filter out multi-class bundles, equipping all the polycount sets at the same time is just stupid
	-- (also no you can't do that, weapons from the same slot always override each other)
	for _,v in pairs(ItemSets) do
		if v.store_bundle == name then
			return true
		end
	end
	return false
end}

local function shouldShowItem(name, item, currentclass, filter)
	filter = filter or {}
	
	if not filter.show_hidden and item.hidden == 1 then return false end
	if not item.used_by_classes or not item.used_by_classes[currentclass] then return false end
	
	if not filter.not_an_entity then
		if not item.item_slot or (filter.slot and not filter.slot[item.item_slot]) then return false end
		if not scripted_ents.GetStored(item.item_class) and not weapons.GetStored(item.item_class) then return false end
	end
	
	if filter.itemclass and not filter.itemclass[item.item_class] then return false end
	if filter.custom_filter and not filter.custom_filter(name, item, currentclass) then return false end
	
	return true
end

local function GiveItemAutoComplete(cmd, args, slotfilter)
	local pl = LocalPlayer()
	
	classname = pl:GetPlayerClass()
	t = {}
	j = {}
	s = string.gsub(args, "^%s*", "^")
	
	if not classname then return t end
	
	class_lst = {}
	for k,v in pairs(Items) do
		if type(v)=="table" and shouldShowItem(k, v, classname, slotfilter) then
			table.insert(class_lst,k)
		end
	end
	
	table.sort(class_lst)
	
	for _,k in ipairs(class_lst) do
		if string.find(k, s) then
			table.insert(t,cmd.." "..k)
		end
	end
	
	for _,k in ipairs(class_lst) do
		if string.find(k, string.gsub("", "^%s*", "^")) then
			table.insert(j,k)
		end
	end
	
	
	return t
end

function AC_GiveItem(cmd, args)
	return GiveItemAutoComplete(cmd, args, filter_all)
end

function AC_GiveWeapon(cmd, args)
	return GiveItemAutoComplete(cmd, args, filter_weapon)
end

function AC_GiveHat(cmd, args)
	return GiveItemAutoComplete(cmd, args, filter_head)
end

function AC_GiveMisc(cmd, args)
	return GiveItemAutoComplete(cmd, args, filter_misc)
end

function AC_GiveBundle(cmd, args)
	return GiveItemAutoComplete(cmd, args, filter_bundle)
end

end


if SERVER then

concommand.Remove("__svgiveitem")
concommand.Remove("striphat")
concommand.Remove("stripmisc")

concommand.Add("__svgiveitem", CC_GiveItem)
concommand.Add("striphat", function(pl) pl:EmptyLoadoutSlot("head") end)
concommand.Add("stripmisc", function(pl) pl:EmptyLoadoutSlot("misc") end)

else

concommand.Remove("giveitem")
concommand.Remove("giveweapon")
concommand.Remove("givehat")
concommand.Remove("givemisc")
concommand.Remove("givebundle")

concommand.Add("giveitem", function(pl,_,args)
	if LocalPlayer():Team() == TEAM_SPECTATOR then return end
	
	if table.HasValue( args, "list") then
		PrintTable(j)
	end
	
	RunConsoleCommand("__svgiveitem", unpack(args))
end, AC_GiveItem)

concommand.Add("giveweapon", function(pl,_,args)
	if LocalPlayer():Team() == TEAM_SPECTATOR then return end
	
	if table.HasValue( args, "list") then
		PrintTable(j)
	end
		
	RunConsoleCommand("__svgiveitem", unpack(args))
end, AC_GiveWeapon)

concommand.Add("givehat", function(pl,_,args)
	if LocalPlayer():Team() == TEAM_SPECTATOR then return end
	
	if table.HasValue( args, "list") then
		PrintTable(j)
	end
	
	RunConsoleCommand("__svgiveitem", unpack(args))
end, AC_GiveHat)

concommand.Add("givemisc", function(pl,_,args)
	if LocalPlayer():Team() == TEAM_SPECTATOR then return end
	
	if table.HasValue( args, "list") then
		PrintTable(j)
	end
	
	RunConsoleCommand("__svgiveitem", unpack(args))
end, AC_GiveMisc)

concommand.Add("givebundle", function(pl,_,args)
	if LocalPlayer():Team() == TEAM_SPECTATOR then return end
	
	if table.HasValue( args, "list") then
		PrintTable(j)
	end
	
	RunConsoleCommand("__svgiveitem", unpack(args))
end, AC_GiveBundle)

end