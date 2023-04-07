-- Regular GMod player, as if you were playing sandbox

if CLIENT then
	CLASS.ScoreboardImage = {
		surface.GetTextureID("vgui/ui_logo.vmt"),
	}
end

CLASS.Name = "HL2 Player"
CLASS.Speed = 20
CLASS.Health = 100

CLASS.AdditionalAmmo = {
}

CLASS.Loadout = {
	"weapon_crowbar"
}

CLASS.ModelName = "player"

CLASS.IsHL2 = true

if SERVER then

function CLASS:Initialize()
	util.PrecacheModel("models/player.mdl")
	self:SetModel("models/player.mdl")
	self:GetHands():SetModel("models/weapons/c_arms_hev.mdl")

	local color = team.GetColor(self:Team())
	local vec = Vector(color.r / 255, color.g / 255, color.b / 255, 1)
	self:SetPlayerColor(vec)

	local cl_defaultweapon = self:GetInfo("cl_defaultweapon")

	if self:HasWeapon(cl_defaultweapon) then
		self:SelectWeapon(cl_defaultweapon) 
	end
end

end