
if tf_lang then return end

module("tf_lang", package.seeall)

Tokens = {}
Globals = {}

function Parse(data)
	data = string.gsub(data, "%s+%[%$ENGLISH%]\n", "")
	data = string.gsub(data, "%s+%[%$ENGLISH%]$", "")
	
	data = string.gsub(data, "%b\"\"%s+%b\"\"%s+%[%$!ENGLISH%]\n", "")
	
	data = string.gsub(data, "\\\\", "\\/")
	data = string.gsub(data, "\\\"([^\"])", "\\'%1")
	data = util.KeyValuesToTable(string.gsub(data, "\\\"([^\"])", "\\'%1"))
	
	if not data.tokens then
		return
	end
	
	for _,v in pairs(data.tokens) do
		v = string.gsub(v, "\\/", "\\")
		v = string.gsub(v, "\\'", "\"")
		v = string.gsub(v, "\\n", "\n")
	end
	
	table.Merge(Tokens, data.tokens)
end

function Load(path)
	Msg("Loading language script '"..path.."' ... ")
	local data = file.Read("resource/"..path, "GAME")
	
	if not data or data=="" then
		ErrorNoHalt("LANGUAGE SCRIPT ERROR: File is empty or does not exist!\n")
		return
	end
	
	Parse(data)
end

function Exists(id)
	if not id then return false end
	if string.sub(id,1,1)=="#" then id = string.sub(id,2) end
	
	return Tokens[string.lower(id)] ~= nil
end

function GetRaw(id, nosharp)
	if not id then return "" end
	local id0 = id
	if string.sub(id,1,1)=="#" then id = string.sub(id,2) end
	
	local t = Tokens[string.lower(id)]
	if t then
		return t
	else
		if nosharp then
			return id
		else
			return id0
		end
	end
end

function GetFormatted(id,...)
	if not id then return "" end
	if string.sub(id,1,1)=="#" then id = string.sub(id,2) end
	
	local t = Tokens[string.lower(id)]
	if t then
		local arg = {...}
		t = string.gsub(t, "%%s(%d+)", function(n) return arg[tonumber(n)] or "" end)
		t = string.gsub(t, "%%(%w+)%%", function(s) return Globals[s] or "" end)
		t = string.gsub(t, "%%%%", "%%")
		return t
	else
		return "#"..id
	end
end

function SetGlobal(k,v)
	Globals[k] = v
end
