-- Include all clientside or shared gamemode files

local basepath = string.Replace(GM.Folder, "gamemodes/", "").."/gamemode/"
local path

AddCSLuaFile("ent_extension.lua")
AddCSLuaFile("ply_extension.lua")
AddCSLuaFile("vmatrix_extension.lua")
AddCSLuaFile("tf_draw_module.lua")
AddCSLuaFile("tf_util_module.lua")
AddCSLuaFile("tf_item_module.lua")
AddCSLuaFile("tf_timer_module.lua")
AddCSLuaFile("tf_lang_module.lua")
AddCSLuaFile("tf_soundscript_module.lua")
AddCSLuaFile("particle_manifest.lua")

path = basepath

for _,f in pairs(file.Find(path.."*.lua", "LUA")) do
	if string.find(f, "^cl_")
	or string.find(f, "^shd_")
	or string.find(f, "^shared") then
		AddCSLuaFile(path..f)
	end
end

-- Include VGUI files

path = basepath.."vgui/"

for _,f in pairs(file.Find(path.."*.lua", "LUA")) do
	AddCSLuaFile(path..f)
end

-- Include proxies

path = basepath.."proxies/"

for _,f in pairs(file.Find(path.."*.lua", "LUA")) do
	AddCSLuaFile(path..f)
end
