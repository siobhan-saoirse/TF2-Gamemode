
if CLIENT then

local lang_data = [["lang" 
{ 
"Language" "English" 
"Tokens" 
{ 
"Gametype_HL2" 			"Half Life 2 Campaign"
"Gametype_Sandbox" 		"Sandbox"
"Gametype_ZombieSurvival "Zombie Survival"
}
}
]]

include("tf_lang_module.lua")
tf_lang.Parse(lang_data)

end

MapTypes = {

hl2 = {
	"^d[0-9]_",
	"^ep[0-9]_",
	"^c[0-9]",
	"^hls0[0-9]",
},
cp = {
	"^cp_"
},
ctf = {
	"^ctf_"
},
tc = {
	"^tc_"
},
pl = {
	"^pl_"
},
plr = {
	"^plr_"
},
arena = {
	"^arena_"
},
koth = {
	"^koth_"
},
tr = {
	"^tr_"
},
sandbox = {
	"^sb_",
	"^gm_",
},
zombiesurvival = {
	"^zs_",
},

}

function GetMapType(name)
	for k,v in pairs(MapTypes) do
		for _,p in ipairs(v) do
			if string.find(name, p) then
				return k
			end
		end
	end
	return ""
end

GameTypes = {
	hl2 = "#Gametype_HL2",
	sandbox = "#Gametype_Sandbox",
	zombiesurvival = "Zombie Survival",
	cp = "#Gametype_CP",
	ctf = "#Gametype_CTF",
	tc = "#Gametype_CP",
	pl = "#Gametype_Escort",
	plr = "#Gametype_EscortRace",
	arena = "#Gametype_Arena",
	koth = "#Gametype_Koth",
	tr = "#Gametype_Training",
}

function GetTFMapName(name)
	for k,v in pairs(MapTypes) do
		for _,p in ipairs(v) do
			if string.find(name, p) then
				name = string.gsub(name, p, "")
				break
			end
		end
	end
	
	return string.upper(string.gsub(name, "_", " "))
end

function GetTFMapType(name)
	return GameTypes[GetMapType(name)] or ""
end
