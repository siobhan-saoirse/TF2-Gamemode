include('shared.lua')

local Zap = Material( "sprites/physcannon_bluelight1b" )
Zap:SetInt("$spriterendermode",5)

local ZapWorld = Material( "sprites/lgtning" )
ZapWorld:SetInt("$spriterendermode",5)

local Mat = Material( "sprites/blueflare1_noz" )
Mat:SetInt("$spriterendermode",5)

local MatWorld = Material( "sprites/blueflare1" )
MatWorld:SetInt("$spriterendermode",5)

ENT.RenderGroup 	= RENDERGROUP_TRANSLUCENT

function ENT:Initialize()
Zap:SetInt("$spriterendermode",5)
ZapWorld:SetInt("$spriterendermode",5)
Mat:SetInt("$spriterendermode",5)
MatWorld:SetInt("$spriterendermode",5)
end

function ENT:Think()
end

function ENT:Draw()
	local scale = math.Rand( 8, 10 )
	local scale2 = math.Rand( 25, 27 )
	local scale3 = math.Rand( 3, 5 )
	if !IsValid(self) then return end
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
		if !IsValid(self) then return end
		
		local attachmentID=vm:LookupAttachment("muzzle")
		local attachment = vm:GetAttachment(attachmentID)
		StartPos = attachment.Pos
		
		local attachmentID5=vm:LookupAttachment("fork1t")
		local attachment_O = vm:GetAttachment( attachmentID5 )
		StartPosO = attachment_O.Pos
		
	render.SetMaterial( Mat )
	self.Length = (StartPosO - StartPos):Length()
	render.DrawSprite( StartPosO, scale, scale, Color(255,255,255,80))
	render.SetMaterial( Zap )
	
	render.DrawBeam( StartPosO, StartPos, 3, math.Rand( 0, 1 ), math.Rand( 0, 1 ) + self.Length / 128	, Color( 255, 255, 255, 195 ) ) 
	
	elseif ( (!ViewModel) or GetViewEntity() != Owner ) then
		local vm = Owner:GetActiveWeapon()
		if (!vm || vm == NULL) then return end
		if !IsValid(vm) then return end
		if !Owner:Alive() then return end
		if not ( Owner:GetActiveWeapon():GetClass() == "weapon_superphyscannon" ) then return end
		if !IsValid(self) then return end
		
		local attachmentID=vm:LookupAttachment("core")
		local attachment = vm:GetAttachment(attachmentID)
		StartPos = attachment.Pos
		
		local attachmentID2=vm:LookupAttachment("fork1t")
		local attachment_O = vm:GetAttachment( attachmentID2 )
		StartPosO = attachment_O.Pos
		
		render.SetMaterial( MatWorld )
		render.DrawSprite( StartPos, scale3, scale3, Color(255,255,255,240))
	--local scale = math.Rand( 8, 10 )
	--local scale2 = math.Rand( 25, 27 )
	--local scale3 = math.Rand( 3, 5 )
	render.SetMaterial( MatWorld )
	self.Length = (StartPosO - StartPos):Length()
	render.DrawSprite( StartPosO, scale, scale, Color(255,255,255,80))
	render.SetMaterial( ZapWorld )
	
	render.DrawBeam( StartPosO, StartPos, 3, math.Rand( 0, 1 ), math.Rand( 0, 1 ) + self.Length / 128	, Color( 255, 255, 255, 255 ) ) 
	end
end

function ENT:IsTranslucent()
	return true
end
