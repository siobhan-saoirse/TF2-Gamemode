include('shared.lua')

local Mat = Material( "effects/fluttercore" )
Mat:SetInt("$spriterendermode",5)
local MatWorld = Material( "sprites/blueflare1" )
MatWorld:SetInt("$spriterendermode",5)
ENT.RenderGroup 	= RENDERGROUP_TRANSLUCENT --RENDERGROUP_BOTH

function ENT:Initialize()
Mat:SetInt("$spriterendermode",5)
MatWorld:SetInt("$spriterendermode",5)
end

function ENT:Think()
self:Draw()
end

function ENT:Draw()
	local scale1 = self.Entity:GetNWInt("scgg_size")
	--local scale1 = math.Rand( 35, 37 )
	local scale7 = math.Rand( 18, 20 )
	local color = self.Entity:GetNWInt("scgg_color")
	if !IsValid(self) then return end
	local Owner = self.Entity:GetOwner()
	if (!Owner || Owner == NULL) then return end
	
	local StartPos 		= self.Entity:GetPos()
	local ViewModel 	= Owner == LocalPlayer()
	
	if ( ViewModel ) and Owner:GetNWBool("SCGG_NotFirstPerson") == false and Owner:Alive() then
		
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
		render.DrawSprite( StartPos, scale1, scale1, Color(255,255,255,color))
	
		
	elseif ( (!ViewModel) or Owner:GetNWBool("SCGG_NotFirstPerson") == true ) and Owner:Alive() then
		local vm = Owner:GetActiveWeapon()
		if (!vm || vm == NULL) then return end
		if !Owner:Alive() then return end
		if not ( Owner:GetActiveWeapon():GetClass() == "weapon_superphyscannon" ) then return end
		
		--if !IsValid(vm:LookupAttachment("core")) then return end
		local attachmentID=vm:LookupAttachment("core")
		local attachment = vm:GetAttachment(attachmentID)
		--if !IsValid(attachment.Pos) then return end
		StartPos = attachment.Pos
		
		render.SetMaterial( MatWorld )
		render.DrawSprite( StartPos, scale7, scale7, Color(255,255,255,color))
		end
end

function ENT:IsTranslucent()
	return true
end
