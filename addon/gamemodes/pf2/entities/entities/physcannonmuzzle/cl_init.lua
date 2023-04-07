include('shared.lua')

local Mat = Material( "sprites/blueflare1_noz" )
Mat:SetInt("$spriterendermode",5)
local MatWorld = Material( "sprites/blueflare1" )
MatWorld:SetInt("$spriterendermode",5)


function ENT:Initialize()
Mat:SetInt("$spriterendermode",5)
end

function ENT:Think()
end

function ENT:Draw()
	local scale4 = math.Rand( 45, 47 )
	local scale5 = math.Rand( 34, 36 )
	local Owner = self.Entity:GetOwner()
	if (!Owner || Owner == NULL) then return end
	local StartPos 		= self.Entity:GetPos()
	local ViewModel 	= Owner == LocalPlayer()
	
	if ( ViewModel ) and GetViewEntity() == Owner then
		
		local vm = Owner:GetViewModel()
		if (!vm || vm == NULL) then return end
		if !Owner:Alive() then return end
		if IsValid(Owner:GetActiveWeapon()) then
		if not ( Owner:GetActiveWeapon():GetClass() == "weapon_superphyscannon" ) then return end
		end
		
		local attachmentID=vm:LookupAttachment("muzzle")
		local attachment = vm:GetAttachment(attachmentID)
		StartPos = attachment.Pos
		
		render.SetMaterial( Mat )
		render.DrawSprite( StartPos, scale4, scale4, Color(255,255,255,240))
	
	elseif ( (!ViewModel) or GetViewEntity() != Owner ) then
		local vm = Owner:GetActiveWeapon()
		if (!vm || vm == NULL) then return end
		if !Owner:Alive() then return end
		if not ( Owner:GetActiveWeapon():GetClass() == "weapon_superphyscannon" ) then return end
		if GetViewEntity() == Owner then return end
		
		local attachmentID=vm:LookupAttachment("core")
		local attachment = vm:GetAttachment(attachmentID)
		StartPos = attachment.Pos
		
		render.SetMaterial( MatWorld )
		render.DrawSprite( StartPos, scale5, scale5, Color(255,255,255,240))
	end
end

function ENT:IsTranslucent()
	return true
end
