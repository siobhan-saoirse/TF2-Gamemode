
local NWTables = {}

local UmsgReadFunc, UmsgWriteFunc
local PendingMessages = {}
local SetEntityVar

local function _zero() return 0 end
local function _zero_vec() return Vector(0,0,0) end
local function _zero_ang() return Angle(0,0,0) end
local function _zero_ent() return NULL end
local function _zero_str() return "" end

local UmsgDefaultValue = {
	Int = _zero,
	Long = _zero,
	Short = _zero,
	Char = _zero,
	Float = _zero,
	Vector = _zero_vec,
	Angle = _zero_ang,
	Entity = _zero_ent,
	String = _zero_str,
}

if CLIENT then

local META = FindMetaTable("bf_read")

UmsgReadFunc = {
	Int = META.ReadLong,
	Long = META.ReadLong,
	Short = META.ReadShort,
	Char = META.ReadChar,
	Float = META.ReadFloat,
	Vector = META.ReadVector,
	Angle = META.ReadAngle,
	Entity = META.ReadEntity,
	String = META.ReadString,
}

else

UmsgWriteFunc = {
	Int = umsg.Long,
	Long = umsg.Long,
	Short = umsg.Short,
	Char = umsg.Char,
	Float = umsg.Float,
	Vector = umsg.Vector,
	Angle = umsg.Angle,
	Entity = umsg.Entity,
	String = umsg.String,
}

end

function RegisterNetworkedTable(name, vars)
	local var_to_id = {}
	local id_to_var = {}
	local vars_id = {}
	
	for k,v in pairs(vars) do
		local i = #id_to_var + 1
		id_to_var[i] = k
		vars_id[i] = v
		var_to_id[k] = i
	end
	
	NWTables[name] = {
		_types = vars,
		_types_by_id = vars_id,
		_id_to_var = id_to_var,
		_var_to_id = var_to_id,
	}
	
	if CLIENT then
		usermessage.Hook("__nwtable_"..name, function(msg)
			local entid = msg:ReadShort()
			local ent = Entity(entid)
			
			local var = msg:ReadChar()
			local vartype = NWTables[name]._types_by_id[var]
			
			if not vartype then return end
			local read = UmsgReadFunc[vartype]
			if not read then return end
			
			local val = read(msg)
			
			if IsValid(ent) then
				if not ent.__nwtable_data then
					ent.__nwtable_data = {}
				end
				
				if not ent.__nwtable_data[name] then
					ent.__nwtable_data[name] = {}
				end
				
				local nwtable = ent.__nwtable_data[name]
				if nwtable then
					nwtable[var] = val
				end
			else
				if not PendingMessages[entid] then
					PendingMessages[entid] = {}
				end
				if not PendingMessages[entid][name] then
					PendingMessages[entid][name] = {}
				end
				
				MsgN(Format("Entity %d does not exist yet, pushing message into PendingMessages table", entid))
				PendingMessages[entid][name][var] = {val = value, timeout = RealTime() + 2}
			end
		end)
	end
end

if CLIENT then

hook.Add("OnEntityCreated", "__nwtable_ProcessPendingMessages", function(ent)
	if IsValid(ent) then
		local id = ent:EntIndex()
		if PendingMessages[id] then
			if not ent.__nwtable_data then
				ent.__nwtable_data = {}
			end
			
			for name, msgs in pairs(PendingMessages[id]) do
				if not ent.__nwtable_data[name] then
					ent.__nwtable_data[name] = {}
				end
				
				local nwtable = ent.__nwtable_data[name]
				for var, dat in pairs(msgs) do
					if RealTime() < dat.timeout then
						nwtable[var] = dat.val
					end
				end
			end
			
			PendingMessages[id] = nil
			MsgN(Format("Processed messages for Entity %d", id))
		end
	end
end)

end

local META = FindMetaTable("Entity")
function META:LoadNetworkedTable(name)
	if not NWTables[name] then
		return
	end
	
	if not self.__nwtable_data then
		self.__nwtable_data = {}
	end
	
	if not self.__nwtable_data[name] then
		self.__nwtable_data[name] = {}
		
		for id,vartype in pairs(NWTables[name]._types_by_id) do
			self.__nwtable_data[name][id] = UmsgDefaultValue[vartype]()
		end
	end
	
	return setmetatable({}, {
		__index = function(t, k)
			local id = NWTables[name]._var_to_id[k]
			if id then
				return self.__nwtable_data[name][id]
			end
		end,
		
		__newindex = function(t, k, v)
			local id = NWTables[name]._var_to_id[k]
			if id then
				local vartype = NWTables[name]._types_by_id[id]
				
				self.__nwtable_data[name][id] = v
				if SERVER then
					umsg.Start("__nwtable_"..name)
						umsg.Short(self:EntIndex())
						umsg.Char(id)
						UmsgWriteFunc[vartype](v)
					umsg.End()
				end
			end
		end,
	})
end
