
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()

	self.Entity:DrawShadow( false )
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:SetNWInt("scgg_size", 25)
	self.Entity:SetNWInt("scgg_color", 40)
	
end

function ENT:Think()
	local Owner = self.Entity:GetOwner()
	if !IsValid(Owner) then self.Entity:Remove() return end
	
	if Owner:GetViewEntity():GetClass() == "gmod_cameraprop" then
		Owner:SetNWBool(	"Camera",			true)
	else
		Owner:SetNWBool(	"Camera",			false)
	end
	
	if !Owner:Alive() then
		self.Entity:Remove()
	return end
	
	local color = self.Entity:GetNWInt("scgg_color")
	if color < 203 then
	local value = 30
	value = value + math.Rand( 2, 3 )
	self.Entity:SetNWInt("scgg_color", color+value)
	end
	local scale1 = self.Entity:GetNWInt("scgg_size")
	if scale1 < 203 then
	local value = 8
	value = value-6
	self.Entity:SetNWInt("scgg_size", scale1+value)
	end
	
	self.Entity:NextThink( CurTime() + 0.01 )
end

