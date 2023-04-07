
function SWEP:GetViewModelEntity()
	if not IsValid(self.Owner) then return self end
	return (IsValid(self.CModel) and self.CModel) or self.Owner:GetViewModel()
end

function SWEP:GetWorldModelEntity()
	return (IsValid(self.WModel2) and self.WModel2) or self
end

---------------------------------------------------------------

function SWEP:CallBaseFunction(f, ...)
	if not self.BaseClass or not self[f] then return end
	if not self.ClassStack then self.ClassStack = {} end
	
	if not self.ClassStack[f] then
		self.ClassStack[f] = {}
		if self.RealBaseClass then
			self.BaseClass = self.RealBaseClass
		else
			self.RealBaseClass = self.BaseClass
		end
	end
	
	table.insert(self.ClassStack[f], self.BaseClass)
	
	local func
	
	repeat
		func = self.BaseClass[f]
		self.BaseClass = self.BaseClass.BaseClass
	until func~=self[f]
	
	while self.BaseClass and self.BaseClass[f]==func do
		self.BaseClass = self.BaseClass.BaseClass
	end
	
	local result = {}
	if not func then
		ErrorNoHalt(Format("WARNING: Attempt to call undefined base function '%s'!", f))
	else
		result = {func(self,...)}
	end
	
	self.BaseClass = table.remove(self.ClassStack[f])
	if #self.ClassStack[f]==0 then
		self.ClassStack[f] = nil
	end
	
	return unpack(result)
end

function SWEP:BaseCall(...)
	local info = debug.getinfo(2)
	
	if info.name and self[info.name] then
		return self:CallBaseFunction(info.name, ...)
	else
		ErrorNoHalt(Format("WARNING:%s:%d: Attempt to call undefined base function '%s'!", info.short_src, info.currentline, info.name))
	end
end
