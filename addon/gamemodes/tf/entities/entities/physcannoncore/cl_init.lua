include('shared.lua')

local Mat = Material( "sprites/blueflare1_noz" )
Mat:SetInt("$spriterendermode",5)
local MatWorld = Material( "sprites/blueflare1" )
MatWorld:SetInt("$spriterendermode",5)
local Main = Material( "effects/fluttercore" )
Main:SetInt("$spriterendermode",5)
ENT.RenderGroup 	= RENDERGROUP_TRANSLUCENT --RENDERGROUP_BOTH

function ENT:Initialize()
Mat:SetInt("$spriterendermode",5)
Main:SetInt("$spriterendermode",9)
MatWorld:SetInt("$spriterendermode",5)
end

function ENT:Think()
self:Draw()
end

function ENT:Draw()
	local scale = math.Rand( 8, 10 )
	--local scale2 = math.Rand( 25, 27 )
	local scale2 = math.Rand( 20, 24 )
	local scale3 = math.Rand( 3, 4 )
	local scale7 = math.Rand( 12, 14 )
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
		
		local attachmentID=vm:LookupAttachment("muzzle")
		local attachment = vm:GetAttachment(attachmentID)
		StartPos = attachment.Pos
		
		local attachmentID2=vm:LookupAttachment("fork1t")
		local attachment_O = vm:GetAttachment( attachmentID2 )
		StartPosO = attachment_O.Pos
		
		local attachmentID3=vm:LookupAttachment("fork2t")
		local attachment_L = vm:GetAttachment( attachmentID3 )
		StartPosL = attachment_L.Pos
		
		local attachmentID4=vm:LookupAttachment("fork1b")
		local attachment_OH = vm:GetAttachment( attachmentID4)
		StartPosOH = attachment_OH.Pos
		
		local attachmentID5=vm:LookupAttachment("fork2b")
		local attachment_LH = vm:GetAttachment( attachmentID5 )
		StartPosLH = attachment_LH.Pos
		--if !IsValid(attachment) then return end
		render.SetMaterial( Main )
		--render.DrawSprite( StartPos, scale2, scale2, Color(255,255,255,240))
		render.DrawSprite( StartPos, scale2, scale2, Color(255,255,255,90))
		--if !IsValid(attachment_O) then return end
		render.SetMaterial( Mat )
		render.DrawSprite( StartPosO, scale, scale, Color(255,255,255,80))
		--if !IsValid(attachment_L) then return end
		render.DrawSprite( StartPosL, scale, scale, Color(255,255,255,80))
		--if !IsValid(attachment_OH) then return end
		render.DrawSprite( StartPosOH, scale, scale, Color(255,255,255,80))
		--if !IsValid(attachment_LH) then return end
		render.DrawSprite( StartPosLH, scale, scale, Color(255,255,255,80))
		
	
		
	elseif ( (!ViewModel) or GetViewEntity() != Owner ) then
		local vm = Owner:GetActiveWeapon()
		if (!vm || vm == NULL) then return end
		if !Owner:Alive() then return end
		if not ( Owner:GetActiveWeapon():GetClass() == "weapon_superphyscannon" ) then return end
		if GetViewEntity() == Owner then return end
		
		--if !IsValid(vm:LookupAttachment("core")) then return end
		local attachmentID=vm:LookupAttachment("core")
		local attachment = vm:GetAttachment(attachmentID)
		--if !IsValid(attachment.Pos) then return end
		StartPos = attachment.Pos
		
		--if !IsValid(vm:LookupAttachment("fork1t")) then return end
		local attachmentID2=vm:LookupAttachment("fork1t")
		local attachment_O = vm:GetAttachment( attachmentID2 )
		--if !IsValid(attachment_O.Pos) then return end
		StartPosO = attachment_O.Pos
		
		--if !IsValid(vm:LookupAttachment("fork2t")) then return end
		local attachmentID3=vm:LookupAttachment("fork2t")
		local attachment_L = vm:GetAttachment( attachmentID3 )
		--if !IsValid(attachment_L.Pos) then return end
		StartPosL = attachment_L.Pos
		
		--if !IsValid(vm:LookupAttachment("fork3t")) then return end
		local attachmentID4=vm:LookupAttachment("fork3t")
		local attachment_R = vm:GetAttachment( attachmentID4 )
		--if !IsValid(attachment_R.Pos) then return end
		StartPosR = attachment_R.Pos
		
		--if !IsValid(vm:LookupAttachment("fork1m")) then return end
		local attachmentID5=vm:LookupAttachment("fork1m")
		local attachment_OH = vm:GetAttachment( attachmentID5 )
		--if !IsValid(attachment_OH.Pos) then return end
		StartPosOH = attachment_OH.Pos
		
		--if !IsValid(vm:LookupAttachment("fork2m")) then return end
		local attachmentID6=vm:LookupAttachment("fork2m")
		local attachment_LH = vm:GetAttachment( attachmentID6 )
		--if !IsValid(attachment_LH.Pos) then return end
		StartPosLH = attachment_LH.Pos

		--if !IsValid(vm:LookupAttachment("fork3m")) then return end
		local attachmentID7=vm:LookupAttachment("fork3m")
		local attachment_RH = vm:GetAttachment( attachmentID7 )
		--if !IsValid(attachment_RH.Pos) then return end
		StartPosRH = attachment_RH.Pos
		
--		render.SetMaterial( Main )
		render.SetMaterial( MatWorld )
		render.DrawSprite( StartPos, scale7, scale7, Color(255,255,255,240))
--		render.DrawSprite( StartPos, scale7, scale7, Color(255,255,255,130))
--		render.SetMaterial( MatWorld )
		render.DrawSprite( StartPosO, scale3, scale3, Color(255,255,255,80))
		render.DrawSprite( StartPosL, scale3, scale3, Color(255,255,255,80))
		render.DrawSprite( StartPosR, scale3, scale3, Color(255,255,255,80))
		render.DrawSprite( StartPosOH, scale3, scale3, Color(255,255,255,80))
		render.DrawSprite( StartPosLH, scale3, scale3, Color(255,255,255,80))
		render.DrawSprite( StartPosRH, scale3, scale3, Color(255,255,255,80)) end
end

function ENT:IsTranslucent()
	return true
end
