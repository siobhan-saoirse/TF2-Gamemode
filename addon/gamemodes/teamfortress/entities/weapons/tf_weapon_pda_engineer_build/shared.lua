if SERVER then

AddCSLuaFile("shared.lua")

end

SWEP.Base				= "tf_weapon_base"

SWEP.ViewModel			= "models/weapons/c_models/c_engineer_arms.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_builder.mdl"

SWEP.HoldType = "PDA"
SWEP.IsPDA = true
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

if CLIENT then

SWEP.PrintName			= "Build PDA"
SWEP.Slot				= 3
SWEP.Crosshair = "tf_crosshair6"

SWEP.CustomHUD = {HudEngyMenuBuild = true}

local BuilderParams = {
	{2,0},
	{0,0},
	{1,0},
	{1,1},
}

hook.Add("PlayerBindPress", "TFBuildPDASlot", function(pl, bind)
	if IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == "tf_weapon_pda_engineer_build" then
		local num = tonumber(string.match(bind, "^slot(%d)") or "")
		if num then
			local param = BuilderParams[num]
		
			if param then
				RunConsoleCommand("build", unpack(param))
				return true
			end
		end
	end
end)
	
end
