-- Not for use with Sandbox gamemode, so we don't care about this
AddCSLuaFile()

SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""
SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false
SWEP.UseHands			= true 
SWEP.StartedReloading	= false
SWEP.HoldTypeHL2 = "normal"
SWEP.ShootSound = Sound("Weapon_Scatter_Gun.Single")
SWEP.ShootCritSound = Sound("Weapon_Scatter_Gun.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_Scatter_Gun.WorldReload") 
SWEP.ReloadSoundFinish = nil
SWEP.IsMeleeWeapon = false
 
-- Sounds

if CLIENT then

function SWEP:DrawWorldModel(  )
		local _Owner = self:GetOwner()

		if (!IsValid(self.WModel)) then
			self.WModel = ents.CreateClientProp()
		end
		self.WModel:SetNoDraw(true)
		self.WModel:SetModel(self:GetItemData().model_player or self.WorldModel)
		if (IsValid(_Owner)) then
            -- Specify a good position
			self.WModel:SetSkin(self.WeaponSkin or _Owner:GetSkin())
			self.WModel:SetBodyGroups(self:GetBodyGroups())
			local offsetVec = Vector(4, -2, 0)
			local offsetAng = Angle(170, 180, 0)
			if (_Owner:IsHL2()) then
				local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
				if !boneid then return end

				local matrix = _Owner:GetBoneMatrix(boneid) 
				if !matrix then return end

				local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

				self.WModel:SetPos(newPos)
				self.WModel:SetAngles(newAng)

				self.WModel:SetupBones()
			end
			self.WModel:SetPos(self:GetPos())
			self.WModel:SetAngles(self:GetAngles())
			self.WModel:SetParent(self.Owner)
			self.WModel:AddEffects(EF_BONEMERGE)
		else	
			self.WModel:SetPos(self:GetPos())
			self.WModel:SetAngles(self:GetAngles())
		end
	
		self.WModel:Spawn()
		self.WModel:DrawModel()
end

end

sound.Add( {
	name = "Heavy.BattleCry01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_battlecry01.wav" } 
} )
sound.Add( {
	name = "Heavy.Go01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_Go01.wav" } 
} )
sound.Add( {
	name = "Heavy.Go02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_Go02.wav" } 
} )
sound.Add( {
	name = "Heavy.Go03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_Go03.wav" } 
} )

sound.Add( {
	name = "Heavy.BattleCry02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_battlecry02.wav" } 
} )
sound.Add( {
	name = "Heavy.BattleCry03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_battlecry03.wav" } 
} )
sound.Add( {
	name = "Heavy.BattleCry04",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_battlecry04.wav" } 
} )
sound.Add( {
	name = "Heavy.BattleCry05",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_battlecry05.wav" } 
} )
sound.Add( {
	name = "Heavy.BattleCry06",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_battlecry06.wav" } 
} )
sound.Add( {
	name = "Heavy.PainSharp05",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_PainSharp05.wav" } 
} )
sound.Add( {
	name = "Heavy.PainSharp04",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_PainSharp04.wav" } 
} )

sound.Add( {
	name = "Heavy.PainSharp03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_PainSharp03.wav" } 
} )

sound.Add( {
	name = "Heavy.PainSharp02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_PainSharp02.wav" } 
} )


sound.Add( {
	name = "Heavy.PainSharp01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_PainSharp01.wav" } 
} )

sound.Add( {
	name = "Heavy.PainSevere01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_PainSevere01.wav" } 
} )

sound.Add( {
	name = "Heavy.PainSevere02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_PainSevere02.wav" } 
} )

sound.Add( {
	name = "Heavy.PainSevere03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_PainSevere03.wav" } 
} )


sound.Add( {
	name = "Scout.PainSharp05",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_PainSharp05.wav" } 
} )

sound.Add( {
	name = "Scout.PainSharp06",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_PainSharp06.wav" } 
} )

sound.Add( {
	name = "Scout.PainSharp07",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_PainSharp07.wav" } 
} )


sound.Add( {
	name = "Scout.PainSharp08",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_PainSharp08.wav" } 
} )
sound.Add( {
	name = "Scout.PainSharp04",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_PainSharp04.wav" } 
} )

sound.Add( {
	name = "Scout.PainSharp03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_PainSharp03.wav" } 
} )

sound.Add( {
	name = "Heavy.PainSharp02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Heavy_PainSharp02.wav" } 
} )

sound.Add( {
	name = "Heavy.Cheers01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Heavy_Cheers01.wav" } 
} )
sound.Add( {
	name = "Heavy.Cheers02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Heavy_Cheers02.wav" } 
} )
sound.Add( {
	name = "Heavy.Cheers03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Heavy_Cheers03.wav" } 
} )
sound.Add( {
	name = "Heavy.Cheers04",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Heavy_Cheers04.wav" } 
} )

sound.Add( {
	name = "Heavy.Cheers05",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Heavy_Cheers05.wav" } 
} )

sound.Add( {
	name = "Heavy.Cheers06",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Heavy_Cheers06.wav" } 
} )


sound.Add( {
	name = "Heavy.Cheers07",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Heavy_Cheers07.wav" } 
} )


sound.Add( {
	name = "Heavy.Cheers08",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Heavy_Cheers08.wav" } 
} )

sound.Add( {
	name = "Heavy.Generic01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Heavy_Generic01.wav" } 
} )








sound.Add( {
	name = "Scout.PainSharp01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_PainSharp01.wav" } 
} )

sound.Add( {
	name = "Scout.PainSevere01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_PainSevere01.wav" } 
} )

sound.Add( {
	name = "Scout.PainSevere02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_PainSevere02.wav" } 
} )

sound.Add( {
	name = "Scout.PainSevere03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_PainSevere03.wav" } 
} )
sound.Add( {
	name = "Scout.PainSevere04",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_PainSevere04.wav" } 
} )
sound.Add( {
	name = "Scout.PainSevere05",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_PainSevere05.wav" } 
} )
sound.Add( {
	name = "Scout.PainSevere06",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_PainSevere06.wav" } 
} )
sound.Add( {
	name = "Scout.BattleCry01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_BattleCry01.wav" } 
} )
sound.Add( {
	name = "Scout.BattleCry02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_BattleCry02.wav" } 
} )
sound.Add( {
	name = "Scout.BattleCry03",
	volume = 1.0,
	level = 75,
	channel = CHAN_VOICE,
	pitch = { 100 },
	sound = { "vo/Scout_BattleCry03.wav" } 
} )
sound.Add( {
	name = "Scout.BattleCry04",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_BattleCry04.wav" } 
} )
sound.Add( {
	name = "Scout.BattleCry05",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_BattleCry05.wav" } 
} )
sound.Add( {
	name = "Scout.Medic01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_Medic01.wav" } 
} )
sound.Add( {
	name = "Scout.Medic02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_Medic02.wav" } 
} )
sound.Add( {
	name = "Scout.Medic03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_Medic03.wav" } 
} )
sound.Add( {
	name = "Scout.Thanks01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_Thanks01.wav" } 
} )


sound.Add( {
	name = "Scout.Thanks02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_Thanks02.wav" } 
} )

sound.Add( {
	name = "Scout.Go01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_Go01.wav" } 
} )

sound.Add( {
	name = "Scout.Go02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_Go02.wav" } 
} )

sound.Add( {
	name = "Scout.Go03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_Go03.wav" } 
} )

sound.Add( {
	name = "Scout.Go04",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_Go04.wav" } 
} )
sound.Add( {
	name = "Scout.MoveUp01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_MoveUp01.wav" } 
} )

sound.Add( {
	name = "Scout.MoveUp02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_MoveUp02.wav" } 
} )

sound.Add( {
	name = "Scout.MoveUp03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/Scout_MoveUp03.wav" } 
} )

sound.Add( {
	name = "Scout.Incoming01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/scout_incoming01.wav" } 
} )
sound.Add( {
	name = "Scout.Incoming02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/scout_incoming02.wav" } 
} )
sound.Add( {
	name = "Scout.Incoming03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/scout_incoming03.wav" } 
} )
sound.Add( {
	name = "Scout.HeadLeft01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/scout_HeadLeft01.wav" } 
} )
sound.Add( {
	name = "Scout.HeadLeft02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/scout_HeadLeft02.wav" } 
} )
sound.Add( {
	name = "Scout.HeadLeft03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/scout_HeadLeft03.wav" } 
} )
sound.Add( {
	name = "Scout.HeadRight01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/scout_HeadRight01.wav" } 
} )
sound.Add( {
	name = "Scout.HeadRight02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/scout_HeadRight02.wav" } 
} )
sound.Add( {
	name = "Scout.HeadRight03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/scout_HeadRight03.wav" } 
} )



sound.Add( {
	name = "Heavy.AutoOnFire01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_autoonfire01.wav" } 
} )
sound.Add( {
	name = "Heavy.AutoOnFire02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_autoonfire02.wav" } 
} )
sound.Add( {
	name = "Heavy.AutoOnFire03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_autoonfire03.wav" } 
} )
sound.Add( {
	name = "Heavy.AutoOnFire04",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_autoonfire04.wav" } 
} )
sound.Add( {
	name = "Heavy.AutoOnFire05",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_autoonfire05.wav" } 
} )
sound.Add( {
	name = "Heavy.CloakedSpyIdentify01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_CloakedSpyIdentify01.wav" } 
} )
sound.Add( {
	name = "Heavy.CloakedSpyIdentify02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_CloakedSpyIdentify02.wav" } 
} )
sound.Add( {
	name = "Heavy.CloakedSpyIdentify03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_CloakedSpyIdentify03.wav" } 
} )
sound.Add( {
	name = "Heavy.CloakedSpyIdentify04",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_CloakedSpyIdentify04.wav" } 
} )
sound.Add( {
	name = "Heavy.CloakedSpyIdentify05",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_CloakedSpyIdentify05.wav" } 
} )
sound.Add( {
	name = "Heavy.CloakedSpyIdentify06",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_CloakedSpyIdentify06.wav" } 
} )
sound.Add( {
	name = "Heavy.CloakedSpyIdentify07",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_CloakedSpyIdentify07.wav" } 
} )
sound.Add( {
	name = "Heavy.CloakedSpyIdentify08",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_CloakedSpyIdentify08.wav" } 
} )
sound.Add( {
	name = "Heavy.CloakedSpyIdentify09",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_CloakedSpyIdentify09.wav" } 
} )
sound.Add( {
	name = "Heavy.CloakedSpy01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_CloakedSpy01.wav" } 
} )
sound.Add( {
	name = "Heavy.CloakedSpy02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_CloakedSpy01.wav" } 
} )
sound.Add( {
	name = "Heavy.CloakedSpy03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_CloakedSpy03.wav" } 
} )
sound.Add( {
	name = "Heavy.CloakedSpy04",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_CloakedSpy04.wav" } 
} )
sound.Add( {
	name = "Heavy.CloakedSpy05",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_CloakedSpy05.wav" } 
} )
sound.Add( {
	name = "Heavy.Medic01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_medic01.wav" } 
} )
sound.Add( {
	name = "Heavy.Medic02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_medic02.wav" } 
} )
sound.Add( {
	name = "Heavy.Medic03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_medic03.wav" } 
} )
sound.Add( {
	name = "Heavy.HelpMe01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_helpme01.wav" } 
} )
sound.Add( {
	name = "Heavy.HelpMe02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_helpme02.wav" } 
} )
sound.Add( {
	name = "Heavy.HelpMe03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_helpme03.wav" } 
} )
sound.Add( {
	name = "Heavy.Meleeing01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleeing01.wav" } 
} )
sound.Add( {
	name = "Heavy.Meleeing02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleeing02.wav" } 
} )
sound.Add( {
	name = "Heavy.Meleeing03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleeing03.wav" } 
} )
sound.Add( {
	name = "Heavy.Meleeing04",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleeing04.wav" } 
} )
sound.Add( {
	name = "Heavy.Meleeing05",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleeing05.wav" } 
} )
sound.Add( {
	name = "Heavy.Meleeing06",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleeing06.wav" } 
} )
sound.Add( {
	name = "Heavy.Meleeing07",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleeing07.wav" } 
} )
sound.Add( {
	name = "Heavy.Meleeing08",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleeing08.wav" } 
} )
sound.Add( {
	name = "Heavy.Meleeing09",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleeing09.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_SandwichTaunt01.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_SandwichTaunt02.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_SandwichTaunt03.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt04",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_SandwichTaunt04.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt05",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_SandwichTaunt05.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichEat",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/SandwichEat09.wav" } 
} )
sound.Add( {
	name = "Heavy.MeleeDare01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleedare01.wav" } 
} )
sound.Add( {
	name = "Heavy.MeleeDare02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleedare02.wav" } 
} )
sound.Add( {
	name = "Heavy.MeleeDare03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleedare03.wav" } 
} )
sound.Add( {
	name = "Heavy.MeleeDare04",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleedare04.wav" } 
} )
sound.Add( {
	name = "Heavy.MeleeDare05",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleedare05.wav" } 
} )
sound.Add( {
	name = "Heavy.MeleeDare06",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleedare06.wav" } 
} )
sound.Add( {
	name = "Heavy.MeleeDare07",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleedare07.wav" } 
} )
sound.Add( {
	name = "Heavy.MeleeDare08",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleedare08.wav" } 
} )
sound.Add( {
	name = "Heavy.MeleeDare09",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleedare09.wav" } 
} )
sound.Add( {
	name = "Heavy.MeleeDare10",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleedare10.wav" } 
} )
sound.Add( {
	name = "Heavy.MeleeDare11",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleedare11.wav" } 
} )
sound.Add( {
	name = "Heavy.MeleeDare12",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleedare12.wav" } 
} )
sound.Add( {
	name = "Heavy.MeleeDare13",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_meleedare13.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt06",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_SandwichTaunt06.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt07",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_SandwichTaunt07.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt08",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	sound = { "vo/heavy_SandwichTaunt08.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt09",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_SandwichTaunt09.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt10",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_SandwichTaunt10.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt11",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_SandwichTaunt11.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt12",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_SandwichTaunt12.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt13",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_SandwichTaunt13.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt14",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_SandwichTaunt14.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt15",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_SandwichTaunt15.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt16",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_SandwichTaunt16.wav" } 
} )
sound.Add( {
	name = "Heavy.SandwichTaunt17",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_SandwichTaunt17.wav" } 
} )
sound.Add( {
	name = "Heavy.PainCrticialDeath01",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_PainCrticialDeath01.wav" } 
} )
sound.Add( {
	name = "Heavy.PainCrticialDeath02",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_PainCrticialDeath02.wav" } 
} )
sound.Add( {
	name = "Heavy.PainCrticialDeath03",
	volume = 1.0,
	level = 75,
	pitch = { 100 },
	channel = CHAN_VOICE,
	sound = { "vo/heavy_PainCrticialDeath03.wav" } 
} )
sound.Add( {
	name = "Weapon_GrenadeLauncherDM.Cock_Forward",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "weapons/grenade_launcher_dm_cock_forward.wav" } 
} )
sound.Add( {
	name = "Weapon_GrenadeLauncherDM.DrumLoad",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "weapons/grenade_launcher_dm_drum_load.wav" } 
} )
sound.Add( {
	name = "Engineer.Battlecry01",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "vo/engineer_battlecry01.wav" } 
} )
sound.Add( {
	name = "Engineer.Battlecry02",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "vo/engineer_battlecry02.wav" } 
} )

sound.Add( {
	name = "Engineer.Battlecry03",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "vo/engineer_battlecry03.wav" } 
} )

sound.Add( {
	name = "Engineer.Battlecry04",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "vo/engineer_battlecry04.wav" } 
} )

sound.Add( {
	name = "Engineer.Battlecry05",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "vo/engineer_battlecry05.wav" } 
} )

sound.Add( {
	name = "Engineer.Battlecry06",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "vo/engineer_battlecry06.wav" } 
} )

sound.Add( {
	name = "Engineer.Battlecry07",
	volume = 1.0,
	level = 90,
	pitch = { 100 },
	sound = { "vo/engineer_battlecry07.wav" } 
} )

-- Viewmodel FOV should be constant, don't change this
SWEP.ViewModelFOV	= GetConVar( "viewmodel_fov" )
-- Ugly hack for the viewmodel resetting on draw
if GetConVar("tf_use_viewmodel_fov") then
	if GetConVar("tf_use_viewmodel_fov"):GetInt() >= 0 then
		SWEP.ViewModelFOV	= GetConVar( "viewmodel_fov_tf" ):GetInt()
	else
		SWEP.ViewModelFOV	= GetConVar( "viewmodel_fov" )
	end
end

SWEP.ViewModelFlip	= false
--eugh, another ugly hack.
if GetConVar("tf_righthand") then
	if GetConVar("tf_righthand"):GetInt() == 0 then
		SWEP.ViewModelFlip = true
	else
		SWEP.ViewModelFlip = false
	end
end


function SWEP:TFViewModelFOV()
	if GetConVar("tf_use_viewmodel_fov"):GetInt() > 0 then
		self.ViewModelFOV	= GetConVar( "viewmodel_fov_tf" ):GetInt()
	else
		self.ViewModelFOV	= GetConVar( "viewmodel_fov" )
	end
end

function SWEP:TFFlipViewmodel()
	if GetConVar("tf_righthand"):GetInt() > 0 then
		self.ViewModelFlip = false
	else
		self.ViewModelFlip = true
	end
end
-- View/World model
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"

SWEP.IsTFWeapon = true

SWEP.HasTeamColouredVModel = true
SWEP.HasTeamColouredWModel = true
SWEP.VMMinOffset = Vector(5, 0, -7)
SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 0
SWEP.Primary.QuickDelay     = -1
SWEP.Primary.NoFiringScene	= false

SWEP.Secondary.Automatic	= true
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay        = 0.1
SWEP.Secondary.QuickDelay   = -1
SWEP.Secondary.NoFiringScene	= false

SWEP.m_WeaponDeploySpeed = 1.4
SWEP.DeployDuration = 0.8
SWEP.ReloadTime = 0.5
SWEP.ReloadType = 0

SWEP.BulletsPerShot = 1
SWEP.BulletSpread = 0.00

SWEP.BaseDamage = 0
SWEP.DamageRandomize = 0
SWEP.MaxDamageRampUp = 0.2
SWEP.MaxDamageFalloff = 0.5
SWEP.DamageModifier = 1

SWEP.IsRapidFire = false
SWEP.CriticalChance = 0
SWEP.CritSpreadDuration = 2
SWEP.CritDamageMultiplier = 3

SWEP.HasSecondaryFire = false

SWEP.ProjectileShootOffset = Vector(0,0,0)

SWEP.CanInspect = true

SWEP.LastClass = "scout"

SWEP.m_flBobTime = 0
SWEP.m_flLastBobTime = 0
SWEP.m_flLastSpeed = 0
SWEP.m_flVerticalBob = 0
SWEP.m_flLateralBob = 0
CreateClientConVar("viewmodel_fov_tf", "54", true, false)
CreateClientConVar("tf_use_viewmodel_fov", "1", true, false)
CreateClientConVar("tf_righthand", "1", true, true)
CreateClientConVar("tf_sprintinspect", "0", true, true)
CreateClientConVar("tf_reloadinspect", "1", true, true)
CreateClientConVar("tf_use_min_viewmodels", "0", true, false)
CreateClientConVar("cl_bobup", "0.5", false, false)
CreateClientConVar("cl_bobcycle", "0.8", false, false)

-- Initialize the weapon as a TF item
tf_item.InitializeAsBaseItem(SWEP)

include("shd_util.lua")
include("shd_anim.lua")
include("shd_sound.lua")
include("shd_crits.lua")

function SWEP:StopTimers()
	timer.Stop("StartInspection")
	timer.Stop("EndInspection")
	timer.Stop("PostInspection")
	inspecting = false
	inspecting_post = false
end 

function SWEP:CalcViewModelBobHelper(  )
	local cycle;

	--NOTENOTE: For now, let this cycle continue when in the air, because it snaps badly without it
	//Find the speed of the player
	local speed = self.Owner:GetAbsVelocity():Length2D()
	local flmaxSpeedDelta = math.max( 0, (CurTime() - self.m_flLastBobTime ) * 320 );

	-- don't allow too big speed changes
	speed = math.Clamp( speed, self.m_flLastSpeed-flmaxSpeedDelta, self.m_flLastSpeed+flmaxSpeedDelta );
	speed = math.Clamp( speed, -320, 320 );

	self.m_flLastSpeed = speed;

	--[[FIXME: This maximum speed value must come from the server.
			 MaxSpeed() is not sufficient for dealing with sprinting - jdw]]

	local bob_offset = math.Remap( speed, 0, 320, 0, 1 );

	self.m_flBobTime = self.m_flBobTime + ( CurTime() - self.m_flLastBobTime ) * bob_offset;
	self.m_flLastBobTime = CurTime();

	//Calculate the vertical bob
	cycle = self.m_flBobTime - (self.m_flBobTime/0.8)*0.8
	cycle = cycle / 0.8;

	if ( cycle < 0.5 ) then
		cycle = 3.14159265358979323846 * cycle / 0.5;
	else
		cycle = 3.14159265358979323846 + 3.14159265358979323846*(cycle-0.5)/(1.0 - 0.5);
	end

	self.m_flVerticalBob = speed*0.005;
	self.m_flVerticalBob = self.m_flVerticalBob*0.3 + self.m_flVerticalBob*0.7*math.sin(cycle);

	self.m_flVerticalBob = math.Clamp( self.m_flVerticalBob, -7, 4 );

	//Calculate the lateral bob
	cycle = self.m_flBobTime - (self.m_flBobTime/0.8*2)*0.8*2;
	cycle = cycle / 0.8*2;

	if ( cycle < 0.5 ) then
		cycle = 3.14159265358979323846 * cycle / 0.5;
	else
		cycle = 3.14159265358979323846 + 3.14159265358979323846*(cycle-0.5)/(1.0 - 0.5);
	end

	self.m_flLateralBob = speed*0.005;
	self.m_flLateralBob = self.m_flLateralBob*0.3 + self.m_flLateralBob*0.7*math.sin(cycle);
	self.m_flLateralBob = math.Clamp( self.m_flLateralBob, -7, 4 );
	--NOTENOTE: We don't use this return value in our case (need to restructure the calculation function setup!)
	return 0.0
end

function SWEP:ProjectileShootPos()
	local pos, ang = self.Owner:GetShootPos(), self.Owner:EyeAngles()
	if self then
		if self.Owner:GetInfoNum("tf_righthand", 1) == 0 then
		return pos +
			self.ProjectileShootOffset.x * ang:Forward() - 
			self.ProjectileShootOffset.y * ang:Right() + 
			self.ProjectileShootOffset.z * ang:Up()
		else return pos +
			self.ProjectileShootOffset.x * ang:Forward() + 
			self.ProjectileShootOffset.y * ang:Right() + 
			self.ProjectileShootOffset.z * ang:Up()
		end
	end
end

function SWEP:Precache()
	if self.MuzzleEffect then
		PrecacheParticleSystem(self.MuzzleEffect)
	end
	
	if self.TracerEffect then
		PrecacheParticleSystem(self.TracerEffect.."_red")
		PrecacheParticleSystem(self.TracerEffect.."_blue")
		PrecacheParticleSystem(self.TracerEffect.."_red_crit")
		PrecacheParticleSystem(self.TracerEffect.."_blue_crit")
	end
end



function SWEP:PreCalculateDamage(ent)
	
end

function SWEP:PostCalculateDamage(dmg, ent)
	return dmg
end

function SWEP:CalculateDamage(hitpos, ent)
	if (string.find(self:GetClass(),"shotgun") || string.find(self:GetClass(),"scattergun")) then
		return self:PostCalculateDamage(tf_util.CalculateDamageRanged(self, hitpos), ent)
	else
		return self:PostCalculateDamage(tf_util.CalculateDamage(self, hitpos), ent)
	end
end

function SWEP:Equip()
	self.CurrentOwner = self.Owner
	
--	if not inspectMessage and self.Owner:IsPlayer() then
	--	self.Owner:ChatPrint("Press 'SHIFT' to Inspect!")
	--	inspectMessage = true
	--	timer.Simple(30, function() inspectMessage = false end)
--	end
	
	self:StopTimers()
	
	if SERVER then
		--MsgN(Format("Equip %s (owner:%s)",tostring(self),tostring(self:GetOwner())))
		
		--[[if IsValid(self.Owner) and self.Owner.WeaponItemIndex then
			self:SetItemIndex(self.Owner.WeaponItemIndex)
		end]]
		--MsgFN("Equip %s", tostring(self))
		
		if self.DeployedBeforeEquip then
			-- FIXED since gmod update 104, this does not seem to be called anymore
			
			-- Call the Deploy function again if the weapon is deployed before it has an owner attributed
			-- This happens when a player is given a weapon right after the ammo for that weapon has been stripped
			self:Deploy()
			self.DeployedBeforeEquip = nil
			--MsgN("Deployed before equip!")
		elseif _G.TFWeaponItemIndex then
			self:SetItemIndex(_G.TFWeaponItemIndex)
		end
		 
		-- quickfix for deploy animations since gmod update 104
		--self.NextReplayDeployAnim = CurTime() + 0.1
	end
end
function SWEP:CalcViewModelView(vm, oldpos, oldang, newpos, newang)
	if not self.VMMinOffset and self:GetItemData() then
		local data = self:GetItemData()
		if data.static_attrs and data.static_attrs.min_viewmodel_offset then
			self.VMMinOffset = Vector(data.static_attrs.min_viewmodel_offset)
		end
	end
 

	if GetConVar("tf_use_min_viewmodels"):GetBool() then -- TODO: Check for inspecting
		newpos = newpos + (newang:Forward() * self.VMMinOffset.x)
		newpos = newpos + (newang:Right() * self.VMMinOffset.y)
		newpos = newpos + (newang:Up() * self.VMMinOffset.z)
		if (string.StartWith(self.Owner:GetModel(),"models/infected/")) then
			oldpos = oldpos + (newang:Forward() * self.VMMinOffset.x)
			oldpos = oldpos + (newang:Right() * self.VMMinOffset.y)
			oldpos = oldpos + (newang:Up() * self.VMMinOffset.z)
		end
	end
	return newpos, newang
end


hook.Add("EntityRemoved", "TFWeaponRemoved", function(ent)
	if ent.IsTFWeapon then
		if IsValid(ent.WModel2) then ent.WModel2:Remove() end
		if IsValid(ent.AttachedWModel) then ent.AttachedWModel:Remove() end
	end
end)



-- Instead of using using DrawWorldModel to render the world model, do it here (at least it guarantees that it will be always drawn if the player is visible)
-- any potential problem with this?
hook.Add("PostPlayerDraw", "ForceDrawTFWorldModel", function(pl)

end)

function SWEP:InitializeWModel2()
--Msg("InitializeWModel2\n")
	if SERVER then
		if self:GetItemData().model_player then
			if IsValid(self.WModel2) then
				--self.WModel2:SetModel(self:GetItemData().model_player)
			else
				self.WModel2 = ents.Create( 'base_gmodentity' )
				if not IsValid(self.WModel2) then return end
					
				--self.WModel2:SetPos(self.Owner:GetPos())
				--self.WModel2:SetModel(self:GetItemData().model_player)
				--self.WModel2:SetAngles(self.Owner:GetAngles())
				--self.WModel2:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE))
				--self.WModel2:SetParent(self.Owner)
				--self.WModel2:SetColor(Color(255, 255, 255))
				--self.WModel2:DrawShadow( false )
				--self.WModel2:FrameAdvance( 0 )
				function self.WModel2:Think()
					--self.WModel2:NextThink(CurTime())
					return true
				end
				if self:GetClass() == "tf_weapon_rocketpack" then
					--self.WModel2:ResetSequence("deploy")
					--self.WModel2:SetPlaybackRate(1)
					--self.WModel2:SetCycle(0)
				end
				if wmodel == "models/weapons/c_models/c_shotgun/c_shotgun.mdl" then
					--self.WModel2:SetMaterial("models/weapons/w_shotgun_tf/w_shotgun_tf")
				end
				if self.Owner:GetNWBool("NoWeapon") == true then 
					--self.WModel2:SetNoDraw(true)
				else
					--self.WModel2:SetNoDraw(true)
				end				
			end
			
			if IsValid(self.WModel2) then
				self.WModel2.Player = self.Owner
				self.WModel2.Weapon = self
					
				if self.MaterialOverride then
					--self.WModel2:SetMaterial(self.MaterialOverride)
				end
				
			end
		end
	end
end

function SWEP:InitializeAttachedModels()
--Msg("InitializeAttachedModels\n")
	if SERVER then
		if IsValid(self.AttachedWModel) then
			if self.AttachedWorldModel then
				self.AttachedWModel:SetModel(self.AttachedWorldModel)
			else
				self.AttachedWModel:Remove()
			end
		elseif self.AttachedWorldModel then
			local ent = (IsValid(self.WModel2) and self.WModel2) or self
			
			self.AttachedWModel = ents.Create( 'base_gmodentity' )
			self.AttachedWModel:SetPos(ent:GetPos())
			self.AttachedWModel:SetModel(self:GetItemData().model_player)
			self.AttachedWModel:SetAngles(ent:GetAngles())
			self.AttachedWModel:AddEffects(EF_BONEMERGE)
			self.AttachedWModel:SetParent(ent)
		end
		
		if IsValid(self.AttachedWModel) then
			self.AttachedWModel.Player = self.Owner
			self.AttachedWModel.Weapon = self
			
			if self.MaterialOverride then
				self.AttachedWModel:SetMaterial(self.MaterialOverride)
			end
		end
	end
end

function SWEP:Deploy() 
	if CLIENT then
		if (self:GetItemData().image_inventory and self:GetItemData().item_iconname) then
			killicon.Add( self:GetItemData().item_iconname, ""..self:GetItemData().image_inventory.."_large", Color( 255, 255, 255, 255 ) )
		elseif (self:GetItemData().image_inventory) then
			killicon.Add( string.Replace(self:GetClass(),"tf_weapon_",""), ""..self:GetItemData().image_inventory.."_large", Color( 255, 255, 255, 255 ) )
		end
	end
	if (self:GetItemData().item_name) then
		self.PrintName = self:GetItemData().name
	end
	if (self.Primary and self.Primary.Ammo and self.Primary.ClipSize ~= -1) then
		if (self:Ammo1() < 0) then
			if (self.HoldType == "PRIMARY" or self.HoldType == "ITEM2") then
				if SERVER then
					local wpn = self.Owner:GetWeapons()[2]
					if (wpn) then
						self.Owner:SelectWeapon(tostring(wpn:GetClass()))
					end
				end
			elseif (self.HoldType == "SECONDARY" or self.HoldType == "ITEM1" or self.HoldType == "ITEM4") then
				if SERVER then
					local wpn = self.Owner:GetWeapons()[3]
					if (wpn) then
						self.Owner:SelectWeapon(tostring(wpn:GetClass()))
					end
				end
			end
		end
	end
	if (self.Owner:IsHL2()) then
		self:SetWeaponHoldType(self.HoldTypeHL2 or self.HoldType)
	end
	if (self:GetClass() == "tf_weapon_shotgun") then
		
		self.ViewModel			= "models/weapons/v_models/v_shotgun_"..self.Owner:GetPlayerClass()..".mdl"
		if (self:GetModel() != self.ViewModel) then
			self.Owner:GetViewModel():SetModel(self.ViewModel)
			self:SetModel(self.ViewModel)
		end
		if (self.Owner:GetPlayerClass() == "soldier"
		|| self.Owner:GetPlayerClass() == "heavy"
		|| self.Owner:GetPlayerClass() == "giantheavyshotgun"
		|| self.Owner:GetPlayerClass() == "heavyshotgun"
		|| self.Owner:GetPlayerClass() == "pyro") then
			self.Slot				= 1
			self:SetHoldType("SECONDARY")
		elseif (self.Owner:GetPlayerClass() == "scout") then
			self.item_slot = "SECONDARY"
			self.Slot				= 1
			self.HoldType = "ITEM2"
			self.Primary.Ammo			= TF_SECONDARY
			self:SetHoldType("ITEM2")
		elseif (self.Owner:GetPlayerClass() == "engineer") then
			self.Slot				= 0
			self:SetHoldType("PRIMARY")
		else
			self.Slot				= 1
			self:SetHoldType("SECONDARY")
		end
	end
	--MsgFN("Deploy %s", tostring(self))

	local wmodel = self:GetItemData().model_player or self.WorldModel
	if (self.Owner:GetNWBool("NoWeapon")) then
		self.WorldModel = "models/empty.mdl"
	else
		if (self.Owner:GetPlayerClass() == "spy" and self:GetClass() == "tf_weapon_builder") then
			self.WorldModel = "models/weapons/w_models/w_sapper.mdl"
		else
			self.WorldModel = wmodel;
		end
	end
	local vm = self.Owner:GetViewModel()
	if (self.Owner:GetPlayerClass() != "combinesoldier") then
		if CLIENT then
			if (self:GetClass() != "tf_weapon_pda_spy") then
				if IsValid(self.CModel) then
					self.CModel:SetModel(wmodel)
					self.CModel:SetNoDraw(true)
					self.CModel:SetParent(vm)
					self.CModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
					self.CModel:DrawModel()
					self.CModel:SetSkin(self:GetOwner():GetSkin())
				elseif IsValid(vm) and !IsValid(self.CModel) then
					self.CModel = ClientsideModel(wmodel)
					if not IsValid(self.CModel) then return end
					self.CModel:SetModel(wmodel)
					self.CModel:SetNoDraw(true)
					self.CModel:SetParent(vm)
					self.CModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
					self.CModel:Spawn()
					self.CModel:Activate()
					self.CModel:DrawModel()
					self.CModel:SetSkin(self:GetOwner():GetSkin())
				end
			else
				if IsValid(self.CModel) then
					self.CModel:SetModel("models/empty.mdl")
					self.CModel:SetNoDraw(true)
					self.CModel:SetParent(vm)
					self.CModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
					self.CModel:DrawModel()
					self.CModel:SetSkin(self:GetOwner():GetSkin())
				elseif IsValid(vm) and !IsValid(self.CModel) then
					self.CModel = ClientsideModel(wmodel)
					if not IsValid(self.CModel) then return end
					self.CModel:SetModel("models/empty.mdl")
					self.CModel:SetNoDraw(true)
					self.CModel:SetParent(vm)
					self.CModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
					self.CModel:Spawn()
					self.CModel:Activate()
					self.CModel:DrawModel()
					self.CModel:SetSkin(self:GetOwner():GetSkin())
				end
			end
		end
	end
	for k, v in pairs(player.GetAll()) do
		if v == self.Owner then		
			if v:IsHL2() then 
				self:SetHoldType(self.HoldTypeHL2)
				if self.DeploySound then
					self:EmitSound(self.DeploySound)
				end
			else
				self:SetHoldType(self.HoldType)
			end
		end
	end	
	
	local hold = self.HoldType
	--MsgN(Format("SetupCModelActivities %s", tostring(self)))
	if (self.Owner:GetNWBool("NoWeapon")) then
		self.WorldModel = "models/empty.mdl"
	else
		if (self.Owner:GetPlayerClass() == "spy" and self:GetClass() == "tf_weapon_builder") then
			self.WorldModel = "models/weapons/w_models/w_sapper.mdl"
		else
			self.WorldModel = wmodel;
		end
	end
	local vm = self.Owner:GetViewModel()
	--self:InitializeWModel2()
	--self:InitializeAttachedModels()
	self:InspectAnimCheck()
	if SERVER then
		if IsValid(self.WModel2) then
			--self.WModel2:SetSkin(self.Owner:GetSkin() or self.WeaponSkin)
			--self.WModel2:SetMaterial(self.MaterialOverride or self.WeaponMaterial or 0)
		end
	end
	if self.Owner:IsPlayer() and not self.Owner:IsHL2() and self.Owner:Team() == TEAM_BLU and string.find(game.GetMap(), "mvm_") then
		if SERVER then
			self.Owner:SetBloodColor(BLOOD_COLOR_MECH)
		end
	end
	self:StopTimers()
	self.DeployPlayed = nil
	if self:GetItemData().hide_bodygroups_deployed_only then
		local visuals = self:GetVisuals()
		local owner = self.Owner
		
		if visuals.hide_player_bodygroup_names then
			for _,group in ipairs(visuals.hide_player_bodygroup_names) do
				local b = PlayerNamedBodygroups[owner:GetPlayerClass()]
				if b and b[group] then
					owner:SetBodygroup(b[group], 1)
				end
				
				b = PlayerNamedViewmodelBodygroups[owner:GetPlayerClass()]
				if b and b[group] then
					if IsValid(owner:GetViewModel()) then
						owner:GetViewModel():SetBodygroup(b[group], 1)
					end
				end
			end
		end	
	end
	
	for k,v in pairs(self:GetVisuals()) do
		if k=="hide_player_bodygroup" then
			self.Owner:SetBodygroup(v,1)
		end
	end
	if GetConVar("tf_righthand") and not self:GetClass() == "tf_weapon_compound_bow" then
	if GetConVar("tf_righthand"):GetInt() == 0	then
		self.ViewModelFlip = true
	else
		self.ViewModelFlip = false
	end
	end
	
	if GetConVar("tf_use_viewmodel_fov"):GetInt() > 0 then
		self.ViewModelFOV	= GetConVar( "viewmodel_fov_tf" ):GetInt()
	else
		self.ViewModelFOV	= GetConVar( "viewmodel_fov" )
	end

	if SERVER then
		--MsgN(Format("Deploy %s (owner:%s)",tostring(self),tostring(self:GetOwner())))
		
		--[[if IsValid(self.Owner) and self.Owner.WeaponItemIndex then
			self:SetItemIndex(self.Owner.WeaponItemIndex)
		end]]
		
		if not IsValid(self.Owner) then
			--MsgFN("Deployed before equip %s",tostring(self))
			self.DeployedBeforeEquip = true
			self.NextReplayDeployAnim = nil
			--self:SendWeaponAnim(ACT_INVALID)
			return true
		end
		
		if _G.TFWeaponItemIndex then
			self:SetItemIndex(_G.TFWeaponItemIndex)
		end
		self:CheckUpdateItem()
		
		self.Owner.weaponmode = string.lower(self.HoldType)
		
		if self.HasTeamColouredWModel then
			if GAMEMODE:EntityTeam(self.Owner)==TEAM_BLU then
				self:SetSkin(self.WeaponSkin or 1)
			elseif GAMEMODE:EntityTeam(self.Owner)==TF_TEAM_PVE_INVADERS then
				self:SetSkin(self.WeaponSkin or 1)
			else
				self:SetSkin(self.WeaponSkin or 0)
			end
		else
			self:SetSkin(self.WeaponSkin)
		end
	end
	
	if CLIENT and not self.DoneFirstDeploy then
		self.RestartClientsideDeployAnim = true
		self.DoneFirstDeploy = true
	end
	
	--MsgFN("SendWeaponAnim %s %d", tostring(self), self.VM_DRAW)
	if SERVER then
		self:SendWeaponAnim(self.VM_DRAW)
	end
	--	print("DRAW ANIM")
	self:InspectAnimCheck()
	local drawAnim = self.VM_DRAW or ACT_VM_DRAW
	local draw_duration = vm:SequenceDuration(vm:SelectWeightedSequence(drawAnim))
	local deploy_duration = self.DeployDuration
	
	if self.Owner.TempAttributes and self.Owner.TempAttributes.DeployTimeMultiplier then
		draw_duration = draw_duration * self.Owner.TempAttributes.DeployTimeMultiplier
		deploy_duration = deploy_duration * self.Owner.TempAttributes.DeployTimeMultiplier
	end
	if (self:GetClass() == "tf_weapon_syringegun_medic") then
		self.NextIdle = CurTime() + 0.5
		self.NextDeployed = CurTime() + 0.5
	elseif (self:GetClass() == "tf_weapon_crossbow") then
		self.NextIdle = CurTime() + 0.5
		self.NextDeployed = CurTime() + 0.5
	else
		self.NextIdle = CurTime() + draw_duration
		self.NextDeployed = CurTime() + deploy_duration
	end
	--[[
	if CLIENT and self.DeploySound and not self.DeployPlayed then
		self:EmitSound(self.DeploySound)
		self.DeployPlayed = true
	end]]
	
	--self.IsDeployed = false
	
	self:RollCritical()
	if self.Owner.ForgetLastWeapon then
		self.Owner.ForgetLastWeapon = nil
		return false
	end
	return true
end

function SWEP:InspectAnimCheck()
	-- todo: find a better way to do this
	-- InspectAnimCheck probably isn't the best place for this...
	if (string.StartWith(self.Owner:GetModel(),"models/infected/")) then return end
	if CLIENT then
		if (self:GetItemData().image_inventory and self:GetItemData().item_iconname) then
			killicon.Add( self:GetItemData().item_iconname, self:GetItemData().image_inventory, Color( 255, 255, 255, 255 ) )
		elseif (self:GetItemData().image_inventory) then
			killicon.Add( string.Replace(self:GetClass(),"tf_weapon_",""), self:GetItemData().image_inventory, Color( 255, 255, 255, 255 ) )
		end
	end
	self:SetModel(self.ViewModel)
	
	self.VM_DRAW			= ACT_VM_DRAW
	self.VM_IDLE			= ACT_VM_IDLE
	self.VM_PRIMARYATTACK	= ACT_VM_PRIMARYATTACK
	self.VM_SECONDARYATTACK	= ACT_VM_SECONDARYATTACK
	self.VM_RELOAD			= ACT_VM_RELOAD
	self.VM_RELOAD_START	= ACT_RELOAD_START
	self.VM_RELOAD_FINISH	= ACT_RELOAD_FINISH
	
	self.VM_CHARGE			= ACT_INVALID
	self.VM_DRYFIRE			= ACT_INVALID
	self.VM_IDLE_2			= ACT_INVALID
	self.VM_CHARGE_IDLE_3	= ACT_INVALID
	self.VM_IDLE_3			= ACT_INVALID
	self.VM_PULLBACK		= ACT_VM_PULLBACK
	self.VM_PREFIRE			= ACT_MP_ATTACK_STAND_PREFIRE
	self.VM_POSTFIRE		= ACT_MP_ATTACK_STAND_POSTFIRE
	
	self.VM_INSPECT_START	= ACT_PRIMARY_VM_INSPECT_START
	self.VM_INSPECT_IDLE	= ACT_PRIMARY_VM_INSPECT_IDLE
	self.VM_INSPECT_GND		= ACT_PRIMARY_VM_INSPECT_GND
	
	self.VM_HITLEFT			= ACT_VM_HITLEFT
	self.VM_HITRIGHT		= ACT_VM_HITRIGHT
	self.VM_HITCENTER		= ACT_VM_HITCENTER
	self.VM_SWINGHARD		= ACT_VM_SWINGHARD
	if !self.AnimReplaced then
		if self:GetVisuals() then
			local visuals = self:GetVisuals()

				if visuals.sound_single_shot then
					self.ShootSound = Sound(visuals.sound_single_shot)
				end

				if visuals.sound_burst then
					self.ShootCritSound = Sound(visuals.sound_burst)
				end

				if visuals.sound_double_shot then
					self.ShootSound2 = Sound(visuals.sound_double_shot)
				end

				if visuals.sound_empty then
					self.EmptySound = Sound(visuals.sound_empty)
				end

				if visuals.sound_reload then
					self.ReloadSound = Sound(visuals.sound_reload)
				end

				if visuals.sound_special1 then
					self.SpecialSound1 = Sound(visuals.sound_special1)
				end

				if visuals.sound_special2 then
					self.SpecialSound2 = Sound(visuals.sound_special2)
				end

				if visuals.sound_special3 then
					self.SpecialSound3 = Sound(visuals.sound_special3)
				end
		end
	end

end

function SWEP:ResetInspect()

end

function SWEP:Inspect()
	-- fuck off
	if (self.Primary and self.Primary.Ammo and self.Primary.ClipSize ~= -1) then
		if (self:Ammo1() < 0) then
			if (self.HoldType == "PRIMARY" or self.HoldType == "ITEM2") then
				if SERVER then
					local wpn = self.Owner:GetWeapons()[2]
					if (wpn) then
						self.Owner:SelectWeapon(tostring(wpn:GetClass()))
					end
				end
			elseif (self.HoldType == "SECONDARY" or self.HoldType == "ITEM1" or self.HoldType == "ITEM4") then
				if SERVER then
					local wpn = self.Owner:GetWeapons()[3]
					if (wpn) then
						self.Owner:SelectWeapon(tostring(wpn:GetClass()))
					end
				end
			end
		end
	end
end

--[[function SWEP:Inspect()
	self:InspectAnimCheck()
	
	if (self:GetOwner():GetMoveType()==MOVETYPE_NOCLIP) and inspecting == true and GetConVar("tf_haltinspect"):GetBool() or (self:GetOwner():GetMoveType()==MOVETYPE_NOCLIP) and inspecting_post == true and GetConVar("tf_haltinspect"):GetBool() then
		self:SendWeaponAnim( self.VM_IDLE ) 
		self:StopTimers()
		return false
	end

	if ( self:GetOwner():GetNWString("inspect") == "inspecting_start" and inspecting == false and GetConVar("tf_caninspect"):GetBool() ) then
		inspecting = true
		self:SendWeaponAnim( self.VM_INSPECT_START )
		timer.Create("StartInspection", self:SequenceDuration(), 1, function()self:SendWeaponAnim( self.VM_INSPECT_IDLE ) end )
	end
	
	if ( self:GetOwner():GetNWString("inspect") == "inspecting_released" and inspecting_post == false and GetConVar("tf_caninspect"):GetBool() ) then
		inspecting_post = true
		timer.Create("EndInspection", self:SequenceDuration(), 1, function()self:SendWeaponAnim( self.VM_INSPECT_END )
			timer.Create("PostInspection", self:SequenceDuration(), 1, function()
				self:SendWeaponAnim( self.VM_IDLE )
				inspecting_post = false
				inspecting = false 
			end )
		end)
	end
end]]
  
function SWEP:Holster()
	self:StopTimers()
	if IsValid(self.Owner) then
		if CLIENT then
			if IsValid(self.CModel) then
				self.CModel:Remove()
			end
			if IsValid(self.WModel) then
				self.WModel:Remove()
			end
			if IsValid(self.ExtraCModel) then
				self.ExtraCModel:Remove()
			end
			if IsValid(self.ExtraWModel) then
				self.ExtraWModel:Remove()
			end
		end
	end
	if IsValid(self.Owner) then
		if self:GetItemData().hide_bodygroups_deployed_only then
			local visuals = self:GetVisuals()
			local owner = self.Owner
			
			if visuals.hide_player_bodygroup_names then
				for _,group in ipairs(visuals.hide_player_bodygroup_names) do
					local b = PlayerNamedBodygroups[owner:GetPlayerClass()]
					if b and b[group] then
						owner:SetBodygroup(b[group], 0)
					end
					
					b = PlayerNamedViewmodelBodygroups[owner:GetPlayerClass()]
					if b and b[group] then
						if IsValid(owner:GetViewModel()) then
							owner:GetViewModel():SetBodygroup(b[group], 0)
						end
					end
				end
			end
		end
	
		for k,v in pairs(self:GetVisuals()) do
			if k=="hide_player_bodygroup" then
				self.Owner:SetBodygroup(v,0)
			end
		end
	end
	
	self.NextIdle = nil
	self.NextReloadStart = nil
	self.NextReload = nil
	self.Reloading = nil
	self.RequestedReload = nil
	self.NextDeployed = nil
	self.IsDeployed = nil
	if SERVER then
		if IsValid(self.WModel2) then
			--self.WModel2:Remove()
		end
	end
	if IsValid(self.Owner) then
		self.Owner.LastWeapon = self:GetClass()
	end
	
	return true
end

function SWEP:OwnerChanged()
	self:Holster()
end
 
function SWEP:OnRemove()
	self:StopTimers()
	--self:Holster() 
end

function SWEP:CanPrimaryAttack() 
	if (self.Primary.ClipSize == -1 and self:Ammo1() > 0) or self:Clip1() > 0 then
		return true
	end
	
	return false
end

function SWEP:CanSecondaryAttack()
	if (self.Secondary.ClipSize == -1 and self:Ammo2() > 0) or self:Clip2() > 0 then
		return true
	end
	
	return false
end

function SWEP:PrimaryAttack(noscene)
	if self.Owner:GetMaterial() == "models/shadertest/predator" then return false end
	if not self.IsDeployed then return false end
	if self.Owner:GetNWBool("Bonked") == true then
		return false
	end
	//if self.Reloading then return false end
	
	self.NextDeployed = nil
	
	local Delay = self.Delay or -1
	local QuickDelay = self.QuickDelay or -1
	
	if (not(self.Primary.QuickDelay>=0 and self.Owner:KeyPressed(IN_ATTACK)) and Delay>=0 and CurTime()<Delay)
	or (self.Primary.QuickDelay>=0 and self.Owner:KeyPressed(IN_ATTACK) and QuickDelay>=0 and CurTime()<QuickDelay) then
		return
	end
	
	self.Delay =  CurTime() + self.Primary.Delay
	self.QuickDelay =  CurTime() + self.Primary.QuickDelay
	
	if not self:CanPrimaryAttack() then
		return
	end
	
			if (string.find(self:GetClass(),"smg") or string.find(self:GetClass(),"pistol")) and CLIENT then
				--PrintTable(self.CModel:GetAttachments())
				if (self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass"))) then
					local effectdata = EffectData()
					effectdata:SetEntity( self.Owner:GetViewModel() )
					effectdata:SetOrigin( self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass")).Pos )
					effectdata:SetAngles( Angle(self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass")).Ang.x,self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass")).Ang.y,self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass")).Ang.z) )
					util.Effect( "ShellEject", effectdata )
				end
			end
	if self.NextReload or self.NextReloadStart then
		self.NextReload = nil
		self.NextReloadStart = nil
	end
	self:RustyBulletHole()
	if SERVER and not self.Primary.NoFiringScene and not noscene then
		self.Owner:Speak("TLK_FIREWEAPON", true)
	end
	--print(self.Base)
	self.NextIdle = nil
	
	return true
end

function SWEP:RustyBulletHole()
	--print(self.ProjectileShootOffset)
	if self.Base ~= "tf_weapon_melee_base" and self.GetClass ~= "tf_weapon_builder" and not self.IsPDA and self.ProjectileShootOffset == Vector(0,0,0) or self.ProjectileShootOffset == Vector(3,8,-5) and self.IsDeployed == true then
		--self:ShootBullet(0, self.BulletsPerShot, self.BulletSpread)
		self:FireBullets({Num = self.BulletsPerShot, Src = self.Owner:GetShootPos(), Dir = self.Owner:GetAimVector(), Spread = Vector(self.BulletSpread, self.BulletSpread, 0), Tracer = 0, Force = 0, Damage = 0, AmmoType = ""})
	end
end

function SWEP:SecondaryAttack(noscene)
	if self.HasSecondaryFire then
		if not self.IsDeployed then return false end
		if not self:CanSecondaryAttack() or self.Reloading then return false end
		
		self.NextDeployed = nil
		
		local Delay = self.Delay or -1
		local QuickDelay = self.QuickDelay or -1
		
		if (not(self.Secondary.QuickDelay>=0 and self.Owner:KeyPressed(IN_ATTACK2)) and Delay>=0 and CurTime()<Delay)
		or (self.Secondary.QuickDelay>=0 and self.Owner:KeyPressed(IN_ATTACK2) and QuickDelay>=0 and CurTime()<QuickDelay) then
			return
		end
		
		if self.NextReload or self.NextReloadStart then
			self.NextReload = nil
			self.NextReloadStart = nil
		end
		
		self.Delay = CurTime() + self.Secondary.Delay
		self.QuickDelay = CurTime() + self.Secondary.QuickDelay
		
		if SERVER and not self.Secondary.NoFiringScene and not noscene then
			self.Owner:Speak("TLK_FIREWEAPON", true)
		end

		self.NextIdle = nil
		
		return true
	else
		for _,w in pairs(self.Owner:GetWeapons()) do
			if w.GlobalSecondaryAttack then
				w:GlobalSecondaryAttack()
			end
		end
		return false
	end
end

function SWEP:CheckAutoReload()
	if self then
		if self.Owner:GetInfoNum("tf_autoreload", 1) == 1 then
			if self.Owner:Alive() then
				if self.Primary.ClipSize >= 0 and self:Ammo1() > 0 and not self:CanPrimaryAttack() then
				--MsgFN("Deployed with empty clip, reloading")
					self:Reload()
				end
	

				self:Reload()
			end
		end
	end
end

function SWEP:Reload()
	self:StopTimers()
	if CLIENT and _G.NOCLIENTRELOAD then return end
	
	if self.NextReloadStart or self.NextReload or self.Reloading then return end
	
	if self.RequestedReload then
		if self.Delay and CurTime() < self.Delay then
			return false
		end
	else
		--MsgN("Requested reload!")
		self.RequestedReload = true
		return false
	end
	
	self.CanInspect = false 
	
	--MsgN("Reload!")
	self.RequestedReload = false
	
	if self.Primary and self.Primary.Ammo and self.Primary.ClipSize ~= -1 then
		local available = self.Owner:GetAmmoCount(self.Primary.Ammo)
		local ammo = self:Clip1()
		
		if ammo < self.Primary.ClipSize and available > 0 then
			self.NextIdle = nil
			if self.ReloadSingle then
				--self:SendWeaponAnim(ACT_RELOAD_START)
				if self.ReloadTime == 1.1 then 
					self:SendWeaponAnimEx(self.VM_RELOAD_START)
					--[[
					if self.Owner.anim_InSwim then
						self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_SWIM, true)
					elseif self.Owner:Crouching() then
						self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_CROUCH, true)
					else
						self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_STAND, true)
					end]]
					self.NextReloadStart = CurTime() + (self.ReloadStartTime or self:SequenceDuration() + 0.5)

					self.Owner:GetViewModel():SetPlaybackRate(0.6)
				else
					if SERVER then
					self:SendWeaponAnimEx(self.VM_RELOAD_START)
					end
					--[[
					if self.Owner.anim_InSwim then
						self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_SWIM, true)
					elseif self.Owner:Crouching() then
						self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_CROUCH, true)
					else
						self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_MP_RELOAD_STAND, true)
					end]]
					if self.ReloadTime == 0.2 then
						self.Owner:GetViewModel():SetPlaybackRate(2)
						self.NextReloadStart = CurTime() + (self.ReloadStartTime or self:SequenceDuration()) - 0.25
					else
						self.NextReloadStart = CurTime() + (self.ReloadStartTime or self:SequenceDuration())
					end
				end
			else
				if SERVER then
				self:SendWeaponAnimEx(self.VM_RELOAD)
				end
				self.Owner:SetAnimation(PLAYER_RELOAD)
				self.NextIdle = CurTime() + (self.ReloadTime or self:SequenceDuration())
				self.NextReload = self.NextIdle
				
				self.AmmoAdded = math.min(self.Primary.ClipSize - ammo, available)
				self.Reloading = true
				
				if self.ReloadSound and SERVER then
					umsg.Start("PlayTFWeaponWorldReload")
						umsg.Entity(self)
					umsg.End()
				end
				if self.ReloadTime == 0.71 then  
					self.Owner:GetViewModel():SetPlaybackRate(1.51)
				end
				--self.reload_cur_start = CurTime()
			end
			--self:SetNextPrimaryFire( CurTime() + ( self.Primary.Delay || 0.25 ) + 1.4 )
			--self:SetNextSecondaryFire( CurTime() + ( self.Primary.Delay || 0.25 ) + 1.4 )
			return true
		end
	end
end

function TranslateKilliconName(name)
	return KilliconTranslate[name] or "d_"..name
end


function SWEP:Think()
	
	
	if CLIENT then
		if (self:GetItemData().item_name) then
			self.PrintName = self:GetItemData().name
		end
		if IsValid(self.CModel) then
			self.CModel:DrawModel()
		end
		if IsValid(self.WModel) then
			self.WModel:DrawModel()
		end
		if IsValid(self.ExtraCModel) then
			self.ExtraCModel:SetParent(self.CModel)
			self.CModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
		end
	end
	if (CLIENT) then
		if IsValid(self.CModel) then
			if (self.CModel:GetSkin() != self:GetSkin()) then
				self.CModel:SetSkin(self:GetSkin())
			elseif (self.CModel:GetMaterial() != self:GetMaterial()) then
				self.CModel:SetMaterial(self:GetMaterial())
			end
		elseif IsValid(self.WModel) then
			if (self.WModel:GetSkin() != self.CModel:GetSkin()) then
				self.WModel:SetSkin(self.CModel:GetSkin())
			elseif (self.WModel:GetMaterial() != self.CModel:GetMaterial()) then
				self.WModel:SetMaterial(self.CModel:GetMaterial())
			end
		end
	end
	if (self.WeaponMaterial and self.WeaponSkin) then
		self:SetMaterial(self.WeaponMaterial)
		self:SetSkin(self.WeaponSkin)
	end
	local hold = self.HoldType
	
	if (!string.StartWith(self.Owner:GetModel(),"models/infected/")) then
		if (self:GetClass() == "tf_weapon_shotgun") then
			self.ViewModel			= "models/weapons/v_models/v_shotgun_"..self.Owner:GetPlayerClass()..".mdl"
			if (self.Owner:GetPlayerClass() == "soldier"
			|| self.Owner:GetPlayerClass() == "heavy"
			|| self.Owner:GetPlayerClass() == "pyro") then
				self.Slot				= 1
				self:SetHoldType("SECONDARY")
			elseif (self.Owner:GetPlayerClass() == "scout") then
				self.item_slot = "SECONDARY"
				self.Slot				= 1
				self.HoldType = "ITEM2"
				self.Primary.Ammo			= TF_SECONDARY
				self:SetHoldType("ITEM2")
			elseif (self.Owner:GetPlayerClass() == "engineer") then
				self.Slot				= 0
				self:SetHoldType("PRIMARY")
			else
				self.Slot				= 1
				self:SetHoldType("SECONDARY")
			end
		end
	end
	if (self.HoldType == "PRIMARY2") then
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= ACT_MP_STAND_PRIMARY
		self.ActivityTranslate[ ACT_MP_WALK ]						= ACT_MP_RUN_PRIMARY
		self.ActivityTranslate[ ACT_MP_RUN ]						= ACT_MP_RUN_PRIMARY
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= ACT_MP_CROUCH_PRIMARY
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= ACT_MP_CROUCHWALK_PRIMARY
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= _G["ACT_MP_ATTACK_STAND_PRIMARY_ALT"]
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= _G["ACT_MP_ATTACK_CROUCH_PRIMARY_ALT"]
		self.ActivityTranslate[ ACT_MP_ATTACK_SWIM_PRIMARYFIRE ]	= _G["ACT_MP_ATTACK_CROUCH_PRIMARY_ALT"]
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= _G["ACT_MP_RELOAD_STAND_PRIMARY_ALT"]
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= _G["ACT_MP_RELOAD_CROUCH_PRIMARY_ALT"]
		self.ActivityTranslate[ ACT_MP_RELOAD_SWIM ]				= _G["ACT_MP_RELOAD_STAND_PRIMARY_ALT"]
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND_LOOP ]				= _G["ACT_MP_RELOAD_STAND_PRIMARY_LOOP_ALT"]
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH_LOOP ]				= _G["ACT_MP_RELOAD_CROUCH_PRIMARY_LOOP_ALT"]
		self.ActivityTranslate[ ACT_MP_RELOAD_SWIM_LOOP ]				= _G["ACT_MP_RELOAD_CROUCH_PRIMARY_LOOP_ALT"]
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND_END ]				= _G["ACT_MP_RELOAD_STAND_PRIMARY_END_ALT"]
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH_END ]				= _G["ACT_MP_RELOAD_CROUCH_PRIMARY_END_ALT"]
		self.ActivityTranslate[ ACT_MP_RELOAD_SWIM_END ]				= _G["ACT_MP_RELOAD_CROUCH_PRIMARY_END_ALT"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= ACT_MP_JUMP_START_PRIMARY
		self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= _G["ACT_MP_ATTACK_STAND_PRIMARY_ALT"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= ACT_MP_SWIM_PRIMARY
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_PRIMARY
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_PRIMARY
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= ACT_MP_JUMP_LAND_PRIMARY
	end
	if (self:GetClass() == "tf_weapon_shotgun") then

		if (IsValid(self.Owner)) then
			self.ViewModel			= "models/weapons/v_models/v_shotgun_"..self.Owner:GetPlayerClass()..".mdl"
			if (self.Owner:GetPlayerClass() == "soldier"
			|| self.Owner:GetPlayerClass() == "heavy"
			|| self.Owner:GetPlayerClass() == "pyro") then
				self.Slot				= 1
				self.HoldType = "SECONDARY"
				self.Primary.Ammo			= TF_SECONDARY
				self:SetHoldType("SECONDARY")
			elseif (self.Owner:GetPlayerClass() == "scout") then
				self.Slot				= 1
				self.HoldType = "ITEM2"
				self.Primary.Ammo			= TF_SECONDARY
				self:SetHoldType("ITEM2")
			elseif (self.Owner:GetPlayerClass() == "engineer") then
				self.Slot				= 0
				self.Primary.Ammo			= TF_PRIMARY
				self.HoldType = "PRIMARY"
				self:SetHoldType("PRIMARY")
			else
				self.Slot				= 1
				self.Primary.Ammo			= TF_SECONDARY
				self.HoldType = "PRIMARY"
				self:SetHoldType("PRIMARY")
			end
		end
	end
	local wmodel = self:GetItemData().model_player or self.WorldModel
	if (self.Owner:GetNWBool("NoWeapon")) then
		self.WorldModel = "models/empty.mdl"
	else
		if (self.Owner:GetPlayerClass() == "spy" and self:GetClass() == "tf_weapon_builder") then
			self.WorldModel = "models/weapons/w_models/w_sapper.mdl"
		else
			self.WorldModel = wmodel;
		end
	end
	if (self.Owner:GetPlayerClass() == "pyro" and self:GetClass() == "tf_weapon_rocketlauncher_qrl") then
		self:SetHoldType("ITEM1")
		self.HoldType = "ITEM1"
	end
	if self:GetItemData().model_player == "models/weapons/c_models/c_breadmonster_sapper/c_breadmonster_sapper.mdl" then
		self.VM_DRAW = ACT_BREADSAPPER_VM_DRAW
		self.VM_IDLE = ACT_BREADSAPPER_VM_IDLE
	end
	if (self.Owner:GetPlayerClass() != "combinesoldier") then
		if CLIENT then
			if IsValid(self.CModel) then
				self.CModel:SetModel(wmodel)
				self.CModel:SetNoDraw(true)
				self.CModel:SetSkin(self:GetOwner():GetSkin())
			elseif IsValid(vm) and !IsValid(self.CModel) then
				self.CModel = ClientsideModel(wmodel)
				if not IsValid(self.CModel) then return end
				self.CModel:SetModel(wmodel)
				self.CModel:SetNoDraw(true)
				self.CModel:SetParent(vm)
				self.CModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
				self.CModel:Spawn()
				self.CModel:Activate()
				self.CModel:SetSkin(self:GetOwner():GetSkin())
			end
			
		end
	end
	if (self.Owner:Team() == TEAM_BLU) then
		self.Owner:GetHands():SetSkin( 1 )
	elseif (self.Owner:Team() == TF_TEAM_PVE_INVADERS) then
		self.Owner:GetHands():SetSkin( 1 )
	else
		self.Owner:GetHands():SetSkin( 0 )
	end
	self:InspectAnimCheck()
	
	if (self.Owner:GetPlayerClass() == "superheavyweightchamp") then
		self.Primary.Delay = 1.0 * 0.6
	end
	if self.NextReload and CurTime()>=self.NextReload then
		self:SetClip1(self:Clip1() + self.AmmoAdded)
		if (self:GetClass() != "tf_weapon_particle_launcher") then
			if not self.ReloadSingle and self.ReloadDiscardClip then
				self.Owner:RemoveAmmo(self.Primary.ClipSize, self.Primary.Ammo, false)
			else
				self.Owner:RemoveAmmo(self.AmmoAdded, self.Primary.Ammo, false)
			end
		end
		
		self.Delay = -1
		self.QuickDelay = -1
		
		if self:Clip1()>=self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo)==0 then
			-- Stop reloading
			self.Reloading = false
			self.CanInspect = true
			if self.ReloadSingle then
				--self:SendWeaponAnim(ACT_RELOAD_FINISH)
				
				if (self:GetClass() == "tf_weapon_grenadelauncher" or self:GetClass() == "tf_weapon_cannon") then
					if CLIENT then
						self.CModel:SetBodygroup(1,0)
					end
				end
				self.CanInspect = true
				self.StartedReloading = false
				--self.Owner:SetAnimation(10001) -- reload finish	
				if SERVER then
					if self.Owner.anim_InSwim then
						self.Owner:DoAnimationEvent(ACT_MP_RELOAD_SWIM_END, true)
					elseif self.Owner:Crouching() then
						self.Owner:DoAnimationEvent(ACT_MP_RELOAD_CROUCH_END, true)
					else
						self.Owner:DoAnimationEvent(ACT_MP_RELOAD_STAND_END, true)
					end
					self:SendWeaponAnim(self.VM_RELOAD_FINISH)
				end
				self.NextIdle = CurTime() + self:SequenceDuration() 
			else
				
				local idleAnim = self.VM_IDLE or ACT_VM_IDLE
				self:SendWeaponAnim(idleAnim)
				self.NextIdle = nil
			end
			self.NextReload = nil
		else
			if SERVER then
			self:SendWeaponAnim(self.VM_RELOAD)
			end
			if CLIENT then
				if self:GetItemData().model_player == "models/weapons/c_models/c_scattergun.mdl" then
					--PrintTable(self.CModel:GetAttachments())
					local effectdata = EffectData()
					effectdata:SetEntity( self.Owner:GetViewModel() )
					effectdata:SetOrigin( self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass")).Pos )
					effectdata:SetAngles( Angle(self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass")).Ang.x,self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass")).Ang.y,self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass")).Ang.z) )
					util.Effect( "ShotgunShellEject", effectdata )
				end
			end
			--self.Owner:SetAnimation(10000)	
				if (!(self:Clip1()>=self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo)==0)) then
					if SERVER then
						if SERVER then
							if self.Owner.anim_InSwim then
								self.Owner:DoAnimationEvent(ACT_MP_RELOAD_SWIM_LOOP, true)
							elseif self.Owner:Crouching() then
								self.Owner:DoAnimationEvent(ACT_MP_RELOAD_CROUCH_LOOP, true)
							else
								self.Owner:DoAnimationEvent(ACT_MP_RELOAD_STAND_LOOP, true)
							end
						end
					end
				end
			if self.ReloadTime == 0.2 then
				self.Owner:GetViewModel():SetPlaybackRate(2)
			end
			if self.ReloadTime == 1.1 then 
				if self:GetItemData().model_player == "models/weapons/c_models/c_dumpster_device/c_dumpster_device.mdl" then
					if CLIENT then
						self.Owner:EmitSound("Weapon_DumpsterRocket.Reload")
					end
				end
				self.Owner:GetViewModel():SetPlaybackRate(0.7)
			end
			self.NextReload = CurTime() + (self.ReloadTime)
			if (self:GetClass() == "tf_weapon_grenadelauncher" or self:GetClass() == "tf_weapon_cannon") then
				if CLIENT then
					self.CModel:SetBodygroup(1,1)
				end
			end
			if (self:GetClass() == "tf_weapon_particle_launcher") then
	
				if (self:Clip1()==self.Primary.ClipSize-1) then
					if SERVER then
						if (IsValid(self.ReloadSoundFinish)) then
							self.Owner:EmitSound(self.ReloadSoundFinish)
						else
							self.Owner:EmitSound(self.ReloadSound)
						end
					end
				else
					if SERVER then
						self.Owner:EmitSound(self.ReloadSound)
					end
				end
	
			else
				
				if (self:Clip1()==self.Primary.ClipSize-1) then
					if (self.ReloadSoundFinish != nil and SERVER) then
						umsg.Start("PlayTFWeaponWorldReloadFinish")
							umsg.Entity(self)
						umsg.End()
					elseif (self.ReloadSound and SERVER) then
						umsg.Start("PlayTFWeaponWorldReload")
							umsg.Entity(self)
						umsg.End()
					end
				else
					if self.ReloadSound and SERVER then
						umsg.Start("PlayTFWeaponWorldReload")
							umsg.Entity(self)
						umsg.End()
					end
				end
			end
			
		end
	end
	
	if self.NextReloadStart and CurTime()>=self.NextReloadStart then
		if SERVER then
		self:SendWeaponAnim(self.VM_RELOAD)
		end
		if CLIENT then
			if self:GetItemData().model_player == "models/weapons/c_models/c_scattergun.mdl" then
				--PrintTable(self.CModel:GetAttachments())
				local effectdata = EffectData()
				effectdata:SetEntity( self.Owner:GetViewModel() )
				effectdata:SetOrigin( self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass")).Pos )
				effectdata:SetAngles( Angle(self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass")).Ang.x,self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass")).Ang.y,self.CModel:GetAttachment(self.CModel:LookupAttachment("eject_brass")).Ang.z) )
				util.Effect( "ShotgunShellEject", effectdata )
			end
		end
		--self.Owner:SetAnimation(10000) -- reload loop	 	
		if self.ReloadTime == 0.2 then
			self.Owner:GetViewModel():SetPlaybackRate(2)
		end
		if self.ReloadTime == 1.1 then 
			if self:GetItemData().model_player == "models/weapons/c_models/c_dumpster_device/c_dumpster_device.mdl" then
				if CLIENT then
					self.Owner:EmitSound("Weapon_DumpsterRocket.Reload")
				end
			end
			self.Owner:GetViewModel():SetPlaybackRate(0.7)
		end
		self.NextReload = CurTime() + (self.ReloadTime)
		
		self.AmmoAdded = 1
		

		if (!(self:Clip1()>=self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo)==0)) then
			if SERVER then
				if self.Owner.anim_InSwim then
					self.Owner:DoAnimationEvent(ACT_MP_RELOAD_SWIM, true)
				elseif self.Owner:Crouching() then
					self.Owner:DoAnimationEvent(ACT_MP_RELOAD_CROUCH, true)
				else
					self.Owner:DoAnimationEvent(ACT_MP_RELOAD_STAND, true)
				end
			end
		end
		if (self:GetClass() == "tf_weapon_grenadelauncher") then
			if CLIENT then
				self.CModel:SetBodygroup(1,1)
			end
		end
		if (self:GetClass() == "tf_weapon_particle_launcher") then

			if (self:Clip1()==self.Primary.ClipSize-1) then
				if SERVER then
					if (IsValid(self.ReloadSoundFinish)) then
						self.Owner:EmitSound(self.ReloadSoundFinish)
					else
						self.Owner:EmitSound(self.ReloadSound)
					end
				end
			else
				if SERVER then
					self.Owner:EmitSound(self.ReloadSound)
				end
			end

		else
			
			if (self:Clip1()==self.Primary.ClipSize-1) then
				if (self.ReloadSoundFinish != nil and SERVER) then
					umsg.Start("PlayTFWeaponWorldReloadFinish")
						umsg.Entity(self)
					umsg.End()
				elseif (self.ReloadSound and SERVER) then
					umsg.Start("PlayTFWeaponWorldReload")
						umsg.Entity(self)
					umsg.End()
				end
			else
				if self.ReloadSound and SERVER then
					umsg.Start("PlayTFWeaponWorldReload")
						umsg.Entity(self)
					umsg.End()
				end
			end
		end
		
		self.NextReloadStart = nil
	end
	self:TFViewModelFOV()
	self:TFFlipViewmodel()
	if SERVER then	
		if IsValid(self.WModel2) then
			if self.Owner:GetNoDraw() == true then
				--self.WModel2:SetNoDraw(true)
			else
				--self.WModel2:SetNoDraw(true)	
			end
		else
			
			if CLIENT then
				self.RenderGroup = RENDERGROUP_BOTH
			end
		
		end
	end
	if IsValid(self.WModel2) then
		if self.Owner:GetNWBool("NoWeapon") == true then 
			if SERVER then
				--self.WModel2:SetNoDraw(true)
			end
		else
			if SERVER then
				--self.WModel2:SetNoDraw(true)
			end
		end
	end
	//deployspeed = math.Round(GetConVar("tf_weapon_deploy_speed"):GetFloat() - GetConVar("tf_weapon_deploy_speed"):GetInt(), 2)
	//deployspeed = math.Round(GetConVar("tf_weapon_deploy_speed"):GetFloat(),2)
	if SERVER and self.NextReplayDeployAnim then
		if CurTime() > self.NextReplayDeployAnim then
			--MsgFN("Replaying deploy animation %d", self.VM_DRAW)
			--timer.Simple(0.1, function() self:SendWeaponAnim(self.VM_DRAW) end)
			self.NextReplayDeployAnim = nil
		end
	end
		if self.NextIdle and CurTime()>=self.NextIdle then
			local idleAnim = self.VM_IDLE or ACT_VM_IDLE
			self:SendWeaponAnim(idleAnim)
			
			self.NextIdle = CurTime() + self:SequenceDuration(self:SelectWeightedSequence(idleAnim))
		end
		
		if self.RequestedReload then
			self:Reload()
		end
	if not self.IsDeployed and self.NextDeployed and CurTime()>=self.NextDeployed then
		self.IsDeployed = true
		self.CanInspect = true
		self:CheckAutoReload()
	end
	
	if self.IsDeployed then
		self.CanInspect = true
	end

	//print(deployspeed)
	
	
	self:Inspect()
end

function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType)
	if (self:GetItemData().item_name) then
		self.PrintName = self:GetItemData().name
	end
	if CLIENT then
		if (self:GetItemData().image_inventory and self:GetItemData().item_iconname) then
			killicon.Add( self:GetItemData().item_iconname, self:GetItemData().image_inventory, Color( 255, 255, 255, 255 ) )
		elseif (self:GetItemData().image_inventory) then
			killicon.Add( string.Replace(self:GetClass(),"tf_weapon_",""), self:GetItemData().image_inventory, Color( 255, 255, 255, 255 ) )
		end
	end
end
