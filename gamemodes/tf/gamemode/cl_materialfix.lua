
if matsystem then
	-- Reload killicons because those are most likely to change after SVN updates
	matsystem.ReloadMaterials("HUD/d_images_hl2")
	matsystem.ReloadMaterials("HUD/dneg_images_hl2")
	matsystem.ReloadMaterials("HUD/d_images_custom")
	matsystem.ReloadMaterials("HUD/dneg_images_custom")
end

local META = FindMetaTable("Entity")

-- Visual overrides
function META:CopyVisualOverrides(source)
	self.CustomColorOverride = source.CustomColorOverride
	self.CustomMaterialOverride = source.CustomMaterialOverride
end

function META:StartVisualOverrides()
	if self.CustomColorOverride then
		local c = self.CustomColorOverride
		render.SetColorModulation(c.r/255, c.g/255, c.b/255)
		render.SetBlend(c.a/255)
	end
	if self.CustomMaterialOverride then
		render.MaterialOverride(self.CustomMaterialOverride)
	end
end

function META:EndVisualOverrides()
	if self.CustomMaterialOverride then
		render.MaterialOverride(0)
	end
	if self.CustomColorOverride then
		render.SetBlend(1)
		render.SetColorModulation(1,1,1)
	end
end

if matproxy then
	-- Material proxy module loaded, no need to use those fixes
	function META:StartItemTint(tint)
		if self.__LastItemTint ~= tint then
			if tint then
				self.ProxyItemTint = {}
				
				self.ProxyItemTint[3] = bit.band(tint, 0xff) / 256
				tint = bit.rshift(tint, 8)
				self.ProxyItemTint[2] = bit.band(tint, 0xff) / 256
				tint = bit.rshift(tint, 8)
				self.ProxyItemTint[1] = bit.band(tint, 0xff) / 256
			else
				self.ProxyItemTint = nil
			end
			
			self.__LastItemTint = tint
		end
	end
	
	function META:EndItemTint() end
	return
end

local HatModelToMaterial = {
["models/player/items/sniper/tooth_hat.mdl"] = {
	"models/player/items/sniper/tooth_hat"
},
["models/player/items/demo/inquisitor.mdl"] = {
	"models/player/items/demo/witchhunter_red",
	"models/player/items/demo/witchhunter_blue",
},
["models/player/items/pyro/pyro_brainsucker.mdl"] = {
	"models/player/items/pyro/pyro_brainsucker",
},
["models/player/items/soldier/soldier_shako.mdl"] = {
	"models/player/items/soldier/soldier_shako",
	"models/player/items/soldier/soldier_shako_blue",
},
["models/player/items/heavy/pugilist_protector.mdl"] = {
	"models/player/items/heavy/sparring",
	"models/player/items/heavy/sparring_blue",
},
["models/player/items/pyro/fiesta_sombrero.mdl"] = {
	"models/player/items/pyro/sombrero_red",
	"models/player/items/pyro/sombrero_blu",
},
["models/player/items/spy/noblehair.mdl"] = {
	"models/player/items/spy/noblehair",
},
["models/player/items/pyro/pyro_beanie.mdl"] = {
	"models/player/items/pyro/winter_hat",
	"models/player/items/pyro/winter_hat_blue",
},
["models/player/items/pyro/pyro_pyrolean.mdl"] = {
	"models/player/items/pyro/pyro_pyrolean",
},
["models/player/items/all_class/parasite_hat.mdl"] = {
	"models/player/items/all_class/parasite_skin",
},
["models/player/items/all_class/voodoojuju_hat.mdl"] = {
	"models/player/items/all_class/voodoojuju_hat",
},
["models/player/items/sniper/sniper_fishinghat.mdl"] = {
	"models/player/items/sniper/sniper_fishinghat",
	"models/player/items/sniper/sniper_fishinghat_blue",
},
["models/player/items/heavy/ttg_visor.mdl"] = {
	"models/player/items/heavy/ttg_visor",
},
["models/player/items/heavy/heavy_stocking_cap.mdl"] = {
	"models/player/items/heavy/heavy_stocking_cap",
	"models/player/items/heavy/heavy_stocking_cap_blue",
},
["models/player/items/demo/demo_afro.mdl"] = {
	"models/player/items/demo/demo_afro",
	"models/player/items/demo/demo_afro_blue",
},
["models/player/items/engineer/engy_earphones.mdl"] = {
	"models/player/items/engineer/engy_earphones",
	"models/player/items/engineer/engy_earphones_blue",
},
["models/player/items/scout/newsboy_cap.mdl"] = {
	"models/player/items/scout/newsboy_cap",
},
["models/player/items/heavy/heavy_ushanka.mdl"] = {
	"models/player/items/heavy/heavy_ushanka",
},
["models/player/items/soldier/soldier_sargehat.mdl"] = {
	"models/player/items/soldier/soldier_sargehat",
},
["models/player/items/scout/bonk_helmet.mdl"] = {
	"models/player/items/scout/bonk_helmet",
	"models/player/items/scout/bonk_helmet_blue",
},
["models/player/items/spy/spy_beret.mdl"] = {
	"models/player/items/spy/spy_beret",
	"models/player/items/spy/spy_beret_blue",
},
["models/player/items/pyro/pyro_hat.mdl"] = {
	"models/player/items/pyro/pyro_hat",
	"models/player/items/pyro/pyro_hat_blue",
},
["models/player/items/pyro/pyro_plunger.mdl"] = {
	"models/player/items/pyro/pyro_plunger",
},
["models/player/items/all_class/all_domination.mdl"] = {
	"models/player/items/all_class/all_domination_hat",
},
["models/player/items/demo/demo_tricorne.mdl"] = {
	"models/player/items/demo/demo_tricorne",
},
["models/player/items/medic/medic_helmet.mdl"] = {
	"models/player/items/medic/medic_helmet",
	"models/player/items/medic/medic_helmet_blue",
},
["models/player/items/pyro/fireman_helmet.mdl"] = {
	"models/player/items/pyro/fireman_helmet",
	"models/player/items/pyro/fireman_helmet_blue",
},
["models/player/items/soldier/soldier_samurai.mdl"] = {
	"models/player/items/soldier/soldier_samurai_red",
	"models/player/items/soldier/soldier_samurai_blue",
},
["models/player/items/soldier/dappertopper.mdl"] = {
	"models/player/items/soldier/dappertopper",
	"models/player/items/soldier/dappertopper_blue",
},
["models/player/items/heavy/heavy_umbrella.mdl"] = {
	"models/player/items/heavy/heavy_uberella",
	"models/player/items/heavy/heavy_uberella_blue",
},
["models/player/items/demo/stunt_helmet.mdl"] = {
	"models/player/items/demo/stunt_helmet",
	"models/player/items/demo/stunt_helmet_blue",
},
["models/player/items/engineer/engineer_train_hat.mdl"] = {
	"models/player/items/engineer/train_hat",
	"models/player/items/engineer/train_hat_blue",
},
["models/player/items/spy/spy_hat.mdl"] = {
	"models/player/items/spy/spy_hat",
	"models/player/items/spy/spy_hat_blue",
},
["models/player/items/demo/drinking_hat.mdl"] = {
	"models/player/items/demo/drinking_hat",
	"models/player/items/demo/drinking_hat_blue",
},
["models/player/items/all_class/all_domination_2009.mdl"] = {
	"models/player/items/all_class/all_domination_hat_2009",
},
["models/player/items/sniper/jarate_headband.mdl"] = {
	"models/player/items/sniper/jarate_headband",
},
["models/player/items/engineer/engineer_cowboy_hat.mdl"] = {
	"models/player/items/engineer/cowboy_hat",
},
["models/player/items/soldier/grenadier_softcap.mdl"] = {
},
["models/player/items/spy/fez.mdl"] = {
},
["models/player/items/pyro/pyro_chicken.mdl"] = {
	"models/player/items/pyro/pyro_chicken",
	"models/player/items/pyro/pyro_chicken_blue",
},
["models/player/items/medic/medic_mask.mdl"] = {
	"models/player/items/medic/medic_mask_red",
	"models/player/items/medic/medic_mask_blue",
},
["models/player/items/medic/medic_tyrolean.mdl"] = {
	"models/player/items/medic/medic_tyrolean",
	"models/player/items/medic/medic_tyrolean_blue",
},
["models/player/items/heavy/hounddog.mdl"] = {
	"models/player/items/heavy/hounddog",
},
["models/player/items/demo/top_hat.mdl"] = {
	"models/player/items/demo/top_hat",
},
["models/player/items/demo/ttg_glasses.mdl"] = {
	"models/player/items/demo/ttg_glasses",
},
["models/player/items/spy/spy_camera_beard.mdl"] = {
	{"models/player/items/spy/spy_camera_beard_hair","models/player/items/spy/spy_camera_beard"},
},
["models/player/items/all_class/skull.mdl"] = {
	"models/player/items/all_class/skull",
},
["models/player/items/spy/derby_hat.mdl"] = {
	"models/player/items/spy/derby_hat",
	"models/player/items/spy/derby_hat_blue",
},
["models/player/items/demo/demo_scott.mdl"] = {
	"models/player/items/demo/demo_scott",
	"models/player/items/demo/demo_scott_blue",
},
["models/player/items/demo/hallmark.mdl"] = {
	"models/player/items/demo/hallmark_red",
	"models/player/items/demo/hallmark_blue",
},
["models/player/items/scout/batter_helmet.mdl"] = {
	"models/player/items/scout/batter_helmet_red",
	"models/player/items/scout/batter_helmet_blue",
},
["models/player/items/pyro/pyro_monocle.mdl"] = {
	"models/player/items/pyro/monocle_whiskers",
},
["models/player/items/heavy/football_helmet.mdl"] = {
	"models/player/items/heavy/football_helmet",
	"models/player/items/heavy/football_helmet_blue",
},
["models/player/items/soldier/soldier_viking.mdl"] = {
	"models/player/items/soldier/soldier_viking",
	"models/player/items/soldier/soldier_viking_blue",
},
["models/player/items/all_class/headsplitter.mdl"] = {
	"models/player/items/all_class/headsplitter",
},
["models/player/items/scout/scout_whoopee.mdl"] = {
	"models/player/items/scout/scout_whoopee",
	"models/player/items/scout/scout_whoopee_blue",
},
["models/player/items/scout/beanie.mdl"] = {
	"models/player/items/scout/beanie_red",
	"models/player/items/scout/beanie_blue",
},
["models/player/items/soldier/chief_rocketeer.mdl"] = {
	"models/player/items/soldier/eagle_red",
	"models/player/items/soldier/eagle_blue",
},
["models/player/items/sniper/pith_helmet.mdl"] = {
	"models/player/items/sniper/pith_helmet",
},
["models/player/items/soldier/soldier_hat.mdl"] = {
	"models/player/items/soldier/soldier_hat",
},
["models/player/items/all_class/wikicap.mdl"] = {
	"models/player/items/all_class/wikicap",
	"models/player/items/all_class/wikicap_blue",
},
["models/player/items/medic/medic_gatsby.mdl"] = {
	"models/player/items/medic/medic_gatsby_red",
	"models/player/items/medic/medic_gatsby_blue",
},
["models/player/items/scout/pilot_protector.mdl"] = {
	{"models/player/items/scout/tanker_helm_plainr","models/player/items/scout/tanker_helm_red"},
	{"models/player/items/scout/tanker_helm_plainb","models/player/items/scout/tanker_helm_blue"},
},
["models/player/items/heavy/heavy_bandana.mdl"] = {
	"models/player/items/heavy/heavy_bandana_red",
	"models/player/items/heavy/heavy_bandana_blue",
},
}

for mdl, dat in pairs(HatModelToMaterial) do
	for sk, mat in pairs(dat) do
		if type(mat) == "table" then
			for i,m in ipairs(mat) do
				mat[i] = Material(m)
				mat[i]:SetVector("$colortint_tmp", vector_origin)
			end
		else
			dat[sk] = Material(mat)
			dat[sk]:SetVector("$colortint_tmp", vector_origin)
		end
	end
end

function META:StartItemTint(tint)
	if not tint or tint <= 0 then return end
	if self.__ItemMaterial == false then return end
	if self.__ItemMaterial == nil then
		local dat = HatModelToMaterial[string.lower(self:GetModel())]
		self.__ItemMaterial = false
		
		if not dat then return end
		dat = dat[self:GetSkin()+1] or dat[1]
		
		if not dat then return end
		self.__ItemMaterial = dat
	end
	
	if self.__LastItemTint ~= tint then
		if not self.__ItemTint then
			self.__ItemTint = Vector(0, 0, 0)
		end
		
		self.__ItemTint.z = (tint % 256) / 256
		tint = math.floor(tint / 256)
		self.__ItemTint.y = (tint % 256) / 256
		self.__ItemTint.x = math.floor(tint / 256) / 256
		
		self.__LastItemTint = tint
	end
	
	local m = self.__ItemMaterial
	if m.MetaName == "IMaterial" then
		m:SetVector("$colortint_tmp", self.__ItemTint)
	else
		for _,v in ipairs(m) do
			v:SetVector("$colortint_tmp", self.__ItemTint)
		end
	end
	
	self.__StartedItemTint = true
end

function META:EndItemTint()
	if not self.__StartedItemTint then return end
	
	local m = self.__ItemMaterial
	if m.MetaName == "IMaterial" then
		m:SetVector("$colortint_tmp", vector_origin)
	else
		for _,v in ipairs(m) do
			v:SetVector("$colortint_tmp", vector_origin)
		end
	end
end
