require("matproxy")

local META = FindMetaTable("Entity")

function META:GetProxyVar(k)
	if self.__ProxyVars then
		return self.__ProxyVars[k]
	end
end

function META:SetProxyVar(k, v)
	if not self.__ProxyVars then self.__ProxyVars = {} end
	self.__ProxyVars[k] = v
end

function META:ClearProxyVars()
	self.__ProxyVars = {}
end
if true then MsgN("Skipping Material Proxies") return end
if not matproxy then
	MsgN("gmcl_matproxy module not found, not installing TF2 proxies")
	return
end

function GM:LoadTFProxies()
	local path = string.Replace(self.Folder, "gamemodes/", "").."/gamemode/proxies/"
	for _,f in pairs(file.Find(path.."*.lua", "LUA")) do
		PROXY = {}
		include(path..f)
		
		local proxyname = string.Replace(f, ".lua", "")
		
		if type(PROXY.Init)=="function" and type(PROXY.OnBind)=="function" and type(PROXY.GetMaterial)=="function" then
			matproxy.Add(proxyname, proxyname.."_TF", PROXY)
			MsgN(Format("Registered proxy '%s'", proxyname))
		else
			MsgN(Format("Error while loading proxy '%s'!", proxyname))
		end
	end
	
	-- Reload all cached materials to update their proxies
	matsystem.ReloadMaterials()
end

GM:LoadTFProxies()
