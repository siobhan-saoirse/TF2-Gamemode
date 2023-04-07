if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Bottle"
end

sound.Add( {
	name = "Taunt.Demo03BottleCatch",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_hand_clap.wav"} 
} )
sound.Add( {
	name = "Taunt.Demo03BottleSlosh",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_bottle_slosh.wav"} 
} )
sound.Add( {
	name = "Taunt.Demo03BottleAh",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = {"player/taunt_bottle_ah.wav"} 
} )

SWEP.Base				= "tf_weapon_melee_base"

SWEP.Slot				= 2
SWEP.ViewModel			= "models/weapons/v_models/v_bottle_demoman.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_bottle/c_bottle.mdl"
SWEP.Crosshair = "tf_crosshair3"

SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.Category = "Team Fortress 2"

SWEP.Swing = Sound("Weapon_Bottle.Miss")
SWEP.SwingCrit = Sound("Weapon_Bottle.MissCrit")

SWEP.HitFlesh = Sound("Weapon_Bottle.IntactHitFlesh")
SWEP.HitRobot = Sound("MVM_Weapon_Bottle.HitFlesh")
SWEP.HitWorld = Sound("Weapon_Bottle.IntactHitWorld")

SWEP.BrokenHitFlesh = Sound("Weapon_Bottle.BrokenHitFlesh")
SWEP.BrokenHitWorld = Sound("Weapon_Bottle.BrokenHitWorld")

SWEP.BreakSound = Sound("Weapon_Bottle.BreakSound")

SWEP.BaseDamage = 65
SWEP.DamageRandomize = 0.1
SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay = 0.8
SWEP.ReloadTime = 0.8

SWEP.HoldType = "MELEE"

SWEP.HoldTypeHL2 = "melee"

function SWEP:SetupDataTables()
	self:CallBaseFunction("SetupDataTables")
	self:DTVar("Bool", 0, "Broken")
end

function SWEP:ViewModelDrawn()
	if IsValid(self.CModel) then
		if self.dt.Broken ~= self.VBrokenState then
			self.CModel:SetBodygroup(0,(self.dt.Broken and 1) or 0)
			
			self.VBrokenState = self.dt.Broken
		end
	end
	
	self:CallBaseFunction("ViewModelDrawn")
end

function SWEP:DrawWorldModel(from_postplayerdraw)
	if SERVER then

	end
	
	self:CallBaseFunction("DrawWorldModel", from_postplayerdraw)
end

function SWEP:OnMeleeHit(trace)
	if self:Critical() and not self.dt.Broken then
		if SERVER then
			self.dt.Broken = true
				
			--self.WModel2:SetBodygroup(0,(self.dt.Broken and 1) or 0)
			
			self.Owner:GetViewModel():SetBodygroup(1,1)
		end
		
		self.HitFlesh = self.BrokenHitFlesh
		self.HitWorld = self.BrokenHitWorld
		self.Broken = true
		
		self:EmitSound(self.BreakSound)
	end
end

function SWEP:Deploy()
	if SERVER and self.dt.Broken then
		self.Owner:GetViewModel():SetBodygroup(1,1)
	end
		if IsValid(self.WModel2) then
			if self.dt.Broken ~= self.BrokenState then
				if self.dt.Broken then
					MsgN("Breaking bottle worldmodel")
				end
				
				--self.WModel2:SetBodygroup(0,(self.dt.Broken and 1) or 0)
				self.BrokenState = self.dt.Broken
			end
		end
	return self:CallBaseFunction("Deploy")
end

function SWEP:Holster()
	self:OnRemove()
	
	return self:CallBaseFunction("Holster")
end

function SWEP:OnRemove()
	if SERVER and self.dt.Broken then
		if IsValid(self.Owner) and self.Owner:GetActiveWeapon()==self then
			self.Owner:GetViewModel():SetBodygroup(1,0)
		end
	end
end