
ENT.Type = "anim"  
ENT.Base = "item_base"    

ENT.Model = "models/items/medkit_small.mdl"
ENT.HealthPercentage = 1
ENT.TouchSound = Sound("HealthKit.Touch")

if SERVER then

AddCSLuaFile("shared.lua")

function ENT:CanPickup(ply)
	return ply:Health()<ply:GetMaxHealth()
end

function ENT:PlayerTouched(pl)
	local h = self.HealthPercentage
	if pl.TempAttributes and pl.TempAttributes.HealthFromPacksMultiplier then
		h = h * pl.TempAttributes.HealthFromPacksMultiplier
	end
	
	self:EmitSound(self.TouchSound)
	self:Hide()
	GAMEMODE:GiveHealthPercent(pl, h)
	GAMEMODE:ExtinguishEntity(pl)
	GAMEMODE:EntityStopBleeding(pl)
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	
	if key=="touchsound" then
		local wep = tostring(value)
		self.TouchSound = tostring(value) 
		timer.Create("SetWeapon", 0.5, 0, function()
			self.TouchSound = tostring(value) 
		end)
	elseif key=="model" then
		local model = tostring(value) 
		self.Model = model
		self:SetModel(model)
		timer.Create("SetModel", 0.5, 0, function()
			self:SetModel(model)
		end)
		print(model)
	elseif key=="healthpercentage" then
		local health = tostring(value) 
		self.HealthPercentage = model
		timer.Create("SetModel", 0.5, 0, function()
			self.HealthPercentage = model
		end)
		print(model)
	end
end

end
