
PlayerHats = {
	-- Hats
	["demo/demo_afro"]=			{nodrop=true},
	["demo/demo_scott"]=		{nodrop=true},
	["demo/top_hat"]=			{nodrop=true},
	["demo/hallmark"]=			{},
	["demo/demo_tricorne"]=		{},
	
	["engineer/hatless"]=				{hide={"hat"},nomodel=true},
	["engineer/engineer_cowboy_hat"]=	{hide={"hat"}},
	["engineer/mining_hat"]=			{nodrop=true},
	["engineer/engineer_train_hat"]=	{hide={"hat"}},
	["engineer/weldingmask"]=			{hide={"hat"}},
	["engineer/engy_earphones"]=		{hide={"hat"}},

	["heavy/football_helmet"]=		{},
	["heavy/heavy_stocking_cap"]=	{},
	["heavy/heavy_ushanka"]=		{},
	["heavy/hounddog"]=				{nodrop=true},
	["heavy/heavy_bandana"]=		{nodrop=true},

	["medic/medic_helmet"]=			{},
	["medic/medic_mirror"]=			{nodrop=true},
	["medic/medic_tyrolean"]=		{},
	["medic/medic_goggles"]=		{},
	["medic/medic_gatsby"]=			{},

	["pyro/pyro_hat"]=			{},
	["pyro/fireman_helmet"]=	{},
	["pyro/pyro_chicken"]=		{},
	["pyro/pyro_brainsucker"]=	{nodrop=true},
	["pyro/pyro_pyrolean"]=		{},
	
	["scout/hatless"]=				{hide={"hat","headphones"},nomodel=true},
	["scout/batter_helmet"]=		{},
	["scout/bonk_helmet"]=			{hide={"hat","headphones"}},
	["scout/newsboy_cap"]=			{hide={"hat","headphones"}},
	["scout/beanie"]=				{hide={"hat","headphones"},nodrop=true},
	["scout/scout_whoopee"]=		{hide={"hat","headphones"}},
	
	["sniper/hatless"]=				{hide={"hat"},nomodel=true},
	["sniper/knife_shield"]=		{nodrop=true},
	["sniper/tooth_hat"]=			{nodrop=true},
	["sniper/jarate_headband"]=		{hide={"hat"},nodrop=true},
	["sniper/straw_hat"]=			{hide={"hat"}},
	["sniper/pith_helmet"]=			{hide={"hat"}},
	["sniper/sniper_fishinghat"]=	{hide={"hat"}},

	["soldier/hatless"]=				{hide={"hat"},nomodel=true},
	["soldier/soldier_hat"]=			{nodrop=true},
	["soldier/soldier_pot"]=			{hide={"hat"}},
	["soldier/soldier_viking"]=			{hide={"hat"}},
	["soldier/soldier_samurai"]=		{hide={"hat"}},
	["soldier/soldier_sargehat"]=		{hide={"hat"}},

	["spy/spy_hat"]=			{},
	["spy/derby_hat"]=			{},
	["spy/noblehair"]=			{nodrop=true},
	["spy/spy_beret"]=			{},
	
	["all_class/all_halo"]=		{hide={"hat","headphones"}, nodrop=true, particles={halopoint1="halopoint"}},
	["%s/%s_bill"]=				{hide={"hat","headphones"}},
	["%s/%s_domination"]=		{hide={"hat","headphones"}},
	["%s/%s_ttg_max"]=			{hide={"hat","headphones"}},
	["%s/%s_halloween"]=		{hide={"hat","headphones"}},
	["%s/hat_first"]=			{hide={"hat","headphones"}},
	["%s/hat_first_nr"]=		{hide={"hat","headphones"}},
	["%s/hat_second"]=			{hide={"hat","headphones"}},
	["%s/hat_second_nr"]=		{hide={"hat","headphones"}},
	["%s/hat_third"]=			{hide={"hat","headphones"}},
	["%s/hat_third_nr"]=		{hide={"hat","headphones"}},
	
	-- Misc items
	["medic/medic_mask"]=			{slot="misc", nodrop=true},
	
	["pyro/pyro_monocle"]=			{slot="misc", nodrop=true},
	
	["soldier/medal"]=				{slot="misc", hide={"medal"},nomodel=true},
	
	["spy/spy_camera_beard"]=		{slot="misc", nodrop=true},
	
	["all_class/id_badge_bronze"]=	{slot="misc", model="all_class/id_badge", nodrop=true, skin=2, perclassbodygroup=true},
	["all_class/id_badge_silver"]=	{slot="misc", model="all_class/id_badge", nodrop=true, skin=1, perclassbodygroup=true},
	["all_class/id_badge_gold"]=	{slot="misc", model="all_class/id_badge", nodrop=true, skin=0, perclassbodygroup=true},
	["all_class/id_badge_platinum"]={slot="misc", model="all_class/id_badge", nodrop=true, skin=3, perclassbodygroup=true},
	["all_class/xms_soldier_beard"]={slot="misc", model="all_class/xms_soldier_beard", nodrop=true, skin=0 perclassbodygroup=true},
	["%s/%s_earbuds"]=				{slot="misc", nodrop=true, particles={ear_R="headphone_notes", ear_L="headphone_notes"}},
}

-- Generate disabled gibs lists
for k,v in pairs(PlayerHats) do
	if v.hide then
		v.disabledgibs = {}
		for _,h in ipairs(v.hide) do
			if h=="hat" then
				table.insert(v.disabledgibs, GIB_HEADGEAR1)
			elseif h=="headphones" then
				table.insert(v.disabledgibs, GIB_HEADGEAR2)
			end
		end
	end
end

-- Generate all-class hats
for k,v in pairs(PlayerHats) do
	if string.find(k,"%%") then
		for c,_ in pairs(PlayerNamedBodygroups) do
			-- no need for copying the table
			PlayerHats[Format(k,c,c)] = PlayerHats[k]
		end
		PlayerHats[k] = nil
	end
end

-- Precache models and particles
for k,v in pairs(PlayerHats) do
	if SERVER then
		umsg.PoolString(k)
	end
	
	if not v.nomodel then
		if v.model then k = v.model end
		util.PrecacheModel("models/player/items/"..k..".mdl")
	end
	
	if v.particles then
		for _,w in pairs(v.particles) do
			PrecacheParticleSystem(w)
		end
	end
end

if SERVER then

local function TranslateHatName(pl, hatname)
	local mdl0 = string.lower(hatname)
	local mdl = mdl0
	local hat = PlayerHats[mdl]
	local mdlname = pl:GetPlayerClassTable().ModelName
	
	if not hat then
		mdl = mdlname.."/"..mdl0
		hat = PlayerHats[mdl]
		if not hat then
			mdl = "all_class/"..mdl0
			hat = PlayerHats[mdl]
		end
	end
	
	if hat then
		return mdl
	end
end

function GM:SetHat(pl, hatname)
	local mdl = TranslateHatName(pl, hatname)
	if not mdl then return end
	
	local hat = PlayerHats[mdl]
	if hat.slot and hat.slot~="hat" then return end
	
	if IsValid(pl.HatEntity) then
		pl.HatEntity:Remove()
	end
	
	local h = ents.Create("tf_hat")
		h.HatName = mdl
		h.Player = pl
	h:Spawn()
	
	pl.HatEntity = h
	pl:SetNWString("CurrentHat", hatname)
end

function GM:SetMiscItem(pl, hatname)
	local mdl = TranslateHatName(pl, hatname)
	if not mdl then return end
	
	local hat = PlayerHats[mdl]
	if hat.slot~="misc" then return end
	
	if IsValid(pl.MiscItemEntity) then
		pl.MiscItemEntity:Remove()
	end
	
	local h = ents.Create("tf_hat")
		h.HatName = mdl
		h.Player = pl
	h:Spawn()
	
	pl.MiscItemEntity = h
	pl:SetNWString("CurrentMiscItem", hatname)
end

end

local function HatListAutoComplete(cmd, slot, args)
	local pl
	if SERVER then
		pl = Entity(1)
	else
		pl = LocalPlayer()
	end
	
	local mdlname = pl:GetPlayerClassTable().ModelName
	local t = {}
	local s = string.gsub(args, "^%s*", "^")
	
	if not mdlname then return t end
	
	local class_lst = {}
	local other_lst = {}
	for k,v in pairs(PlayerHats) do
		if v.slot==slot or (not v.slot and slot=="hat") then
			local n = string.match(k, "^"..mdlname.."/(.*)$")
			if n then
				table.insert(class_lst,n)
			else
				n = string.match(k, "^all_class/(.*)$")
				if n then
					table.insert(class_lst,n)
				else
					table.insert(other_lst,k)
				end
			end
		end
	end
	
	table.sort(class_lst)
	table.sort(other_lst)
	
	for _,k in ipairs(class_lst) do
		if string.find(k, s) then
			table.insert(t,cmd.." "..k)
		end
	end
	
	for _,k in ipairs(other_lst) do
		if string.find(k, s) then
			table.insert(t,cmd.." "..k)
		end
	end
	
	return t
end

concommand.Add("set_hat", function(pl, cmd, args)
	if SERVER then GAMEMODE:SetHat(pl, args[1]) end
end, function(cmd, args)
	return HatListAutoComplete(cmd, "hat", args)
end)

concommand.Add("set_misc", function(pl, cmd, args)
	if SERVER then GAMEMODE:SetMiscItem(pl, args[1]) end
end, function(cmd, args)
	return HatListAutoComplete(cmd, "misc", args)
end)

