
module("tf_objects", package.seeall)

Objects = {}
ObjectsByName = {}

function Register(tab)
	tab.id = #Objects
	table.insert(Objects, tab)
	ObjectsByName[tab.name] = tab
	
	if tab.v_model then
		util.PrecacheModel(tab.v_model)
	end
	if tab.w_model then
		util.PrecacheModel(tab.w_model)
	end
	if tab.blueprint_model then
		util.PrecacheModel(tab.blueprint_model)
	end
end

function NumObjects()
	return #Objects
end

function IsValid(group, mode)
	local obj
	if type(group)=="number" then
		obj = Objects[group+1]
	else
		obj = ObjectsByName[group]
	end
	
	if obj and (mode == 0 or (obj.modes and obj.modes[mode+1])) then
		return true
	end
	return false
end

function NumModes(group)
	local obj
	if type(group)=="number" then
		obj = Objects[group+1]
	else
		obj = ObjectsByName[group]
	end
	
	if obj then
		if obj.modes then
			return #(obj.modes)
		else
			return 1
		end
	end
	
	return 0
end

function Get(group, mode)
	if IsValid(group, mode) then
		local tab
		if type(group)=="number" then
			tab = table.Copy(Objects[group+1])
		else
			tab = table.Copy(ObjectsByName[group])
		end
		
		if tab.modes then
			local modes = tab.modes[mode+1]
			tab.modes = nil
			table.Merge(tab, modes)
		end
		
		return tab
	end
end

function GetBuildables(buildables)
	local tab = {}
	
	for _,name in pairs(buildables) do
		for mode=0,NumModes(name)-1 do
			local obj = Get(name, mode)
			if obj then
				if not tab[obj.id] then
					tab[obj.id] = {}
				end
				tab[obj.id][mode] = obj
			end
		end
	end
	
	return tab
end

Register({
	name = "OBJ_DISPENSER",
	objtype = "dispenser",
	class_name = "obj_dispenser",
	status_name = "#TF_Object_Dispenser",
	build_time = 20,
	max_objects = 1,
	cost = 100,
	upgrade_cost = 200,
	upgrade_duration = 1.5,
	placement_type = 1,
	metal_gibs = 50,
	
	slot = 5,
	hidden = true,
	--v_model = "models/weapons/v_models/v_toolbox_engineer.mdl",
	--w_model = "models/weapons/w_models/w_toolbox.mdl",
	blueprint_model = "models/buildables/dispenser_blueprint.mdl"
})

Register({
	name = "OBJ_TELEPORTER",
	objtype = "teleporter",
	class_name = "obj_teleporter",
	status_name = "#TF_Object_Tele",
	build_time = 20,
	max_objects = 1,
	cost = 100,
	upgrade_cost = 200,
	upgrade_duration = 1.5,
	placement_type = 1,
	metal_gibs = 60,
	
	slot = 5,
	hidden = true,
	--v_model = "models/weapons/v_models/v_toolbox_engineer.mdl",
	--w_model = "models/weapons/w_models/w_toolbox.mdl",
	
	modes = {
		{
			mode_name = "#TF_Teleporter_Mode_Entrance",
			blueprint_model = "models/buildables/teleporter_blueprint_enter.mdl"
		},
		{
			mode_name = "#TF_Teleporter_Mode_Exit",
			blueprint_model = "models/buildables/teleporter_blueprint_exit.mdl"
		},
	}
})

Register({
	name = "OBJ_SENTRYGUN",
	objtype = "sentrygun",
	class_name = "obj_sentrygun",
	status_name = "#TF_Object_Sentry",
	build_time = 10,
	max_objects = 1,
	cost = 130,
	upgrade_cost = 200,
	upgrade_duration = 1.5,
	placement_type = 1,
	metal_gibs = 60,
	
	slot = 5,
	hidden = true,
	--v_model = "models/weapons/v_models/v_toolbox_engineer.mdl",
	--w_model = "models/weapons/w_models/w_toolbox.mdl",
	blueprint_model = "models/buildables/sentry1_blueprint.mdl"
})
