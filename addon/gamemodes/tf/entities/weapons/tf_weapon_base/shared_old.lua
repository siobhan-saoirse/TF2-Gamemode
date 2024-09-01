-- Not for use with Sandbox gamemode, so we don't care about this
SWEP.Author			= ""
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

-- Viewmodel FOV should be constant, don't change this
SWEP.ViewModelFOV	= 54
SWEP.ViewModelFlip	= false

-- View/World model
SWEP.ViewModel		= "models/weapons/v_pistol.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"

SWEP.IsTFWeapon = true

SWEP.HasTeamColouredVModel = true
SWEP.HasTeamColouredWModel = true

SWEP.Primary.ClipSize		= 8
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 0
SWEP.Primary.QuickDelay     = -1

SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay        = 0
SWEP.Secondary.QuickDelay   = -1

SWEP.m_WeaponDeploySpeed = 1000
SWEP.DeployDuration = 1

SWEP.ReloadType = 0

SWEP.BaseDamage = 0
SWEP.DamageRandomize = 0
SWEP.MaxDamageRampUp = 0.2
SWEP.MaxDamageFalloff = 0.5
SWEP.DamageModifier = 1

SWEP.IsRapidFire = false
SWEP.CriticalChance = 2
SWEP.CritSpreadDuration = 2
SWEP.CritDamageMultiplier = 3

SWEP.HasSecondaryFire = false

SWEP.ProjectileShootOffset = Vector(0,0,0)

SWEP.ShootSound = Sound("Weapon_Scatter_Gun.Single")
SWEP.ShootCritSound = Sound("Weapon_Scatter_Gun.SingleCrit")
SWEP.ReloadSound = Sound("Weapon_Scatter_Gun.WorldReload")

SWEP.VM_DRAW = ACT_VM_DRAW
SWEP.VM_IDLE = ACT_VM_IDLE
SWEP.VM_PRIMARYATTACK = ACT_VM_PRIMARYATTACK
SWEP.VM_SECONDARYATTACK = ACT_VM_SECONDARYATTACK
SWEP.VM_RELOAD = ACT_VM_RELOAD
SWEP.VM_RELOAD_START = ACT_RELOAD_START
SWEP.VM_RELOAD_FINISH = ACT_RELOAD_FINISH
SWEP.BACKSTAB_VM_DOWN	= ACT_BACKSTAB_VM_DOWN
SWEP.BACKSTAB_VM_UP	= ACT_BACKSTAB_VM_UP
SWEP.BACKSTAB_VM_IDLE	= ACT_BACKSTAB_VM_IDLE

PrecacheParticleSystem("critgun_weaponmodel_red")
PrecacheParticleSystem("critgun_weaponmodel_blu")

-------------------------------------------------------------

local SoundNameTranslate = {
	sound_single_shot		= "ShootSound",
	sound_double_shot		= "ShootSound2",
	sound_burst				= "ShootCritSound,SwingCrit",
	sound_empty				= "EmptySound",
	sound_reload			= "ReloadSound",
	
	sound_special1			= "SpecialSound1",
	sound_special2			= "SpecialSound2",
	sound_special3			= "SpecialSound3",
	custom_sound1			= "CustomSound1",
	
	sound_melee_miss		= "Swing",
	sound_melee_hit			= "HitFlesh",
	sound_melee_hit_world	= "HitWorld"
}

function SWEP:ModifySound(name,sound)
	local snd = string.gsub(SoundNameTranslate[name], "%s", "")
	util.PrecacheSound(sound)
	if snd then
		for _,v in ipairs(string.Explode(",", snd)) do
			self[v] = sound
		end
	end
end

-------------------------------------------------------------

function SWEP:GetViewModelEntity()
	return (IsValid(self.CModel) and self.CModel) or self.Owner:GetViewModel()
end

function SWEP:GetWorldModelEntity()
	return (IsValid(self.WModel2) and self.WModel2) or self
end

function SWEP:SetupDataTables()
	self:DTVar("Int", 0, "ItemID")
	if SERVER then self.dt.ItemID = -1 end
end

function SWEP:SetItemIndex(i)
	self.dt.ItemID = i
end

function SWEP:ItemIndex()
	return self.dt.ItemID
end

function SWEP:GetItemData()
	local item = tf_items.ItemsByID[self:ItemIndex()]
	return item or {}
end

function SWEP:GetAttributes()
	return self:GetItemData().attributes or {}
end

function SWEP:GetAttribute(class)
	for _,a in pairs(self:GetItemData().attributes or {}) do
		if a.attribute_class == class then return a end
	end 
end

function SWEP:IsAttributeEnabled(class)
	local att = self:GetAttribute(class)
	return att and att.value~=0
end

function SWEP:GetVisuals()
	return self:GetItemData().visuals or {}
end

function SWEP:CheckUpdateItem()
	local id = self:ItemIndex()
	if id>-1 and id~=self.CurrentItemID then
		local item = tf_items.ItemsByID[id]
		if item then
			MsgN(Format("SetupItem [%d] %s", id, tostring(self)))
			self:SetupItem(tf_items.ItemsByID[id])
		else
			MsgN(Format("WARNING: From '%s': Item #%d not found!", self:GetClass(), id))
		end
		self.CurrentItemID = id
	end
end

function SWEP:SetupCModelActivities(item)
	tf_util.ReadActivitiesFromModel(self)
	
	if item then
		local hold = item.anim_slot or string.upper(item.item_slot)
		MsgN(Format("SetupCModelActivities %s", tostring(self)))
		
		self.VM_DRAW			= _E["ACT_"..hold.."_VM_DRAW"]
		self.VM_IDLE			= _E["ACT_"..hold.."_VM_IDLE"]
		self.VM_PRIMARYATTACK	= _E["ACT_"..hold.."_VM_PRIMARYATTACK"]
		self.VM_SECONDARYATTACK	= _E["ACT_"..hold.."_VM_SECONDARYATTACK"]
		self.VM_RELOAD			= _E["ACT_"..hold.."_VM_RELOAD"]
		self.VM_RELOAD_START	= _E["ACT_"..hold.."_RELOAD_START"]
		self.VM_RELOAD_FINISH	= _E["ACT_"..hold.."_RELOAD_FINISH"]
		self.BACKSTAB_VM_DOWN	= ACT_BACKSTAB_VM_DOWN
		self.BACKSTAB_VM_UP	= ACT_BACKSTAB_VM_UP
		self.BACKSTAB_VM_IDLE	= ACT_BACKSTAB_VM_IDLE
	else
		self.VM_DRAW			= ACT_VM_DRAW
		self.VM_IDLE			= ACT_VM_IDLE
		self.VM_PRIMARYATTACK	= ACT_VM_PRIMARYATTACK
		self.VM_SECONDARYATTACK	= ACT_VM_SECONDARYATTACK
		self.VM_RELOAD			= ACT_VM_RELOAD
		self.VM_RELOAD_START	= ACT_RELOAD_START
		self.VM_RELOAD_FINISH	= ACT_RELOAD_FINISH
	end
	
	if self.UsesSpecialAnimations then
		self.VM_DRAW = ACT_VM_DRAW_SPECIAL
		self.VM_IDLE = ACT_VM_IDLE_SPECIAL
		self.VM_HITCENTER = ACT_VM_HITCENTER_SPECIAL
		self.VM_SWINGHARD = ACT_VM_SWINGHARD_SPECIAL
	end
end

function SWEP:InitAttributes(owner, attributes)
	MsgFN("InitAttributes (%s) %s",tostring(self),tostring(owner))
	attributes = attributes or {}
	
	for _,a in pairs(attributes) do
		if a.attribute_class == "mult_clipsize" then
			self.Primary.ClipSize = math.Round(self.Primary.ClipSize * a.value)
			self:SetClip1(self.Primary.ClipSize)
		elseif a.attribute_class == "mult_postfiredelay" then
			self.Primary.Delay = self.Primary.Delay * a.value
		elseif a.attribute_class == "mult_crit_chance" then
			self.CriticalChance = self.CriticalChance * a.value
		elseif a.attribute_class == "mult_maxammo_primary" then
			if SERVER and owner.AmmoMax and owner.AmmoMax[TF_PRIMARY] then
				owner.AmmoMax[TF_PRIMARY] = math.Round(owner.AmmoMax[TF_PRIMARY] * a.value)
			end
		elseif a.attribute_class == "mult_maxammo_secondary" then
			if SERVER and owner.AmmoMax and owner.AmmoMax[TF_SECONDARY] then
				owner.AmmoMax[TF_SECONDARY] = math.Round(owner.AmmoMax[TF_SECONDARY] * a.value)
			end
		elseif a.attribute_class == "add_maxhealth" then
			if SERVER then
				owner:SetMaxHealth(owner:GetMaxHealth() + a.value)
			end
		elseif a.attribute_class == "mult_spread_scale" and self.BulletSpread then
			self.BulletSpread = self.BulletSpread * a.value
		elseif a.attribute_class == "mult_bullets_per_shot" and self.BulletsPerShot then
			self.BulletsPerShot = math.Round(self.BulletsPerShot * a.value)
		end
	end
end

function SWEP:InitVisuals(owner, visuals)
	MsgFN("InitVisuals (%s) %s",tostring(self),tostring(owner))
	visuals = visuals or {}
	
	self.WeaponSkin = visuals.skin or (((owner:EntityTeam() == TEAM_BLU or owner:EntityTeam() == TF_TEAM_PVE_INVADERS)) and 1) or 0)
	self:SetSkin(self.WeaponSkin or self:GetSkin())
	self:SetMaterial(self.WeaponMaterial)
	
	if CLIENT then
		if visuals.attached_model_world and visuals.attached_model_world.model then
			self.AttachedWorldModel = visuals.attached_model_world.model
		elseif visuals.attached_model and visuals.attached_model.model then
			self.AttachedWorldModel = visuals.attached_model.model
		end
		
		if visuals.attached_model_view and visuals.attached_model_view.model then
			self.AttachedViewModel = visuals.attached_model_view.model
		elseif visuals.attached_model and visuals.attached_model.model then
			self.AttachedViewModel = visuals.attached_model.model
		end
	end
	
	for k,v in pairs(visuals) do
		if k=="muzzle_flash" then
			self.MuzzleEffect = v
		elseif k=="tracer_effect" then
			self.TracerEffect = v
		elseif SoundNameTranslate[k] then
			self:ModifySound(k, v)
		end
	end
end

---------------------------------------------------------------

function SWEP:CallBaseFunction(f, ...)
	if not self.BaseClass or not self[f] then return end
	if not self.ClassStack then self.ClassStack = {} end
	
	table.insert(self.ClassStack, self.BaseClass)
	
	local func
	
	repeat
		func = self.BaseClass[f]
		self.BaseClass = self.BaseClass.BaseClass
	until func~=self[f]
	
	while self.BaseClass and self.BaseClass[f]==func do
		self.BaseClass = self.BaseClass.BaseClass
	end
	
	local result = {func(self,...)}
	self.BaseClass = table.remove(self.ClassStack)
	
	return unpack(result)
end

function SWEP:BaseCall(...)
	local info = debug.getinfo(2)
	
	if info.name and self[info.name] then
		return self:CallBaseFunction(info.name, ...)
	else
		ErrorNoHalt(Format("WARNING:%s:%d: Attempt to call undefined base function '%s'!", info.short_src, info.currentline, info.name))
	end
end

function SWEP:SendWeaponAnimEx(anim)
	local t = type(anim)
	
	if t=="string" then
		if string.find(anim,",") then
			anim = string.Explode(",", anim)
			t = "table"
		end
	end
	
	if t=="table" then
		anim = table.Random(anim)
		t = type(anim)
	end
	
	if t=="number" then
		self:SendWeaponAnim(anim)
	elseif t=="string" then
		--print(anim)
		local s = self.Owner:GetViewModel():LookupSequence(anim)
		self:SetSequence(s)
		self.Owner:GetViewModel():SetSequence(s)
	end
end

if SERVER then

function SWEP:SetCritBoostEffect(i)
	if self.LastCritBoostEffect==i then return end
	
	umsg.Start("SetCritBoostEffect")
		umsg.Entity(self)
		umsg.Char(i)
	umsg.End()
	
	self.LastCritBoostEffect = i
end

end

function SWEP:ProjectileShootPos()
	local pos, ang = self.Owner:GetShootPos(), self.Owner:EyeAngles()
	return pos +
		self.ProjectileShootOffset.x * ang:Forward() + 
		self.ProjectileShootOffset.y * ang:Right() + 
		self.ProjectileShootOffset.z * ang:Up()
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

-- Call this function with any parameter to make the gamemode roll a critical hit for the owner
-- With rapidfire weapons, this will simply initialize the crit spread timer, as crits are automatically rolled every second
--[[
function SWEP:Critical(roll)
	if CLIENT then return self:GetNWBool("Critical") end
	
	if roll then
		if self.IsRapidFire then
			if self.Owner.NextShotIsCritical and not self.NextCritStop then
				self.NextCritStop = CurTime() + self.CritSpreadDuration
			end
		else
			GAMEMODE:RollCritical(self.Owner)
		end
	end
	
	self:PredictCriticalHit()
	
	if self.Owner.NextShotIsCritical or (self.NextCritStop and CurTime()<=self.NextCritStop) then
		self:SetNWBool("Critical", true)
		return true
	else
		self:SetNWBool("Critical", false)
		self.NextCritStop = nil
		return false
	end
end]]

function SWEP:RollCritical()
	if self.IsRapidFire then
		if self.Owner:GetNWBool("NextShotIsCritical") and not self.NextCritStop then
			self.NextCritStop = CurTime() + self.CritSpreadDuration
		end
	elseif SERVER then
		GAMEMODE:RollCritical(self.Owner)
	end
	
	return self:Critical()
end

function SWEP:Critical(ent,dmginfo)
	local force_crit
	if CLIENT or self.CritsOnHeadshot or self.MeleeAttack then
		force_crit = self:PredictCriticalHit()
	elseif IsValid(ent) then
		force_crit = self:ShouldOverrideCritical(ent)
	end
	
	if force_crit==nil and self.CritTime and CurTime()-self.CritTime<0.01 then
		return self.CurrentShotIsCrit
	end
	
	self.CritTime = CurTime()
	if force_crit == false then
		self.CurrentShotIsCrit = false
		self.NextCritStop = nil
		return false
	elseif force_crit or self.Owner:GetNWBool("NextShotIsCritical") or (self.NextCritStop and CurTime()<=self.NextCritStop) then
		self.CurrentShotIsCrit = true
		return true
	else
		self.CurrentShotIsCrit = false
		self.NextCritStop = nil
		return false
	end
end

-- Return true if the weapon should crit on that entity, false if it should NEVER crit on that entity, and nil to let the crit system decide
function SWEP:ShouldOverrideCritical(ent)
	local valid = IsValid(ent)
	local isplayer = valid and ent:IsTFPlayer()
	local onfire = valid and ent:HasPlayerState(PLAYERSTATE_ONFIRE)
	
	for _,a in pairs(self:GetAttributes()) do
		if a.attribute_class == "or_crit_vs_playercond" then
			if a.value == 1 and isplayer and onfire then
				return true
			end
		elseif a.attribute_class == "set_nocrit_vs_nonburning" then
			if a.value == 1 and not(isplayer and onfire) then
				return false
			end
		end
	end
end

-- Used when critical hits depend on a condition (such as headshots)
function SWEP:PredictCriticalHit()
	if self.CritsOnHeadshot then
		local tr = util.TraceLine{
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + 8000*self.Owner:GetAimVector(),
			filter = self.Owner,
		}
		
		if tr.Hit and tr.HitGroup == HITGROUP_HEAD then
			--self.Owner.NextShotIsCritical = true
			--self.Owner:SetNWBool("NextShotIsCritical", true)
			self.NameOverride = self.HeadshotName
			return true
		else
			--self.Owner.NextShotIsCritical = false
			--self.Owner:SetNWBool("NextShotIsCritical", false)
			self.NameOverride = nil
		end
	end
	
	if self.MeleeAttack then
		local tr = self:MeleeAttack(true) -- perform a dummy melee attack (doesn't do any damage)
		return self:ShouldOverrideCritical(tr.Entity)
	else
		return self:ShouldOverrideCritical(NULL)
	end
end

function SWEP:PreCalculateDamage(ent)
	
end

function SWEP:PostCalculateDamage(dmg, ent)
	return dmg
end

function SWEP:CalculateDamage(hitpos, ent)
	return self:PostCalculateDamage(tf_util.CalculateDamage(self, hitpos), ent)
end

function SWEP:Equip()
	if SERVER then
		MsgN(Format("Equip %s (owner:%s)",tostring(self),tostring(self:GetOwner())))
		
		--[[if IsValid(self.Owner) and self.Owner.WeaponItemIndex then
			self:SetItemIndex(self.Owner.WeaponItemIndex)
		end]]
		
		if self.DeployedBeforeEquip then
			-- Call the Deploy function again if the weapon is deployed before it has an owner attributed
			-- This happens when a player is given a weapon right after the ammo for that weapon has been stripped
			self:Deploy()
			self.DeployedBeforeEquip = nil
		elseif _G.TFWeaponItemIndex then
			self:SetItemIndex(_G.TFWeaponItemIndex)
		end
	end
end

function SWEP:Deploy()
	if SERVER then
		MsgN(Format("Deploy %s (owner:%s)",tostring(self),tostring(self:GetOwner())))
		
		--[[if IsValid(self.Owner) and self.Owner.WeaponItemIndex then
			self:SetItemIndex(self.Owner.WeaponItemIndex)
		end]]
		
		if not IsValid(self.Owner) then
			self.DeployedBeforeEquip = true
			return true
		end
		
		if _G.TFWeaponItemIndex then
			self:SetItemIndex(_G.TFWeaponItemIndex)
		end
		self:CheckUpdateItem()
		
		self.Owner.weaponmode = string.lower(self.HoldType)
		
		if self.HasTeamColouredWModel then
			if GAMEMODE:EntityTeam(self.Owner)==TEAM_BLU then
				self:SetSkin(1)
			elseif GAMEMODE:EntityTeam(self.Owner)==TF_TEAM_PVE_INVADERS then
				self:SetSkin(1)
			else
				self:SetSkin(0)
			end
		else
			self:SetSkin(0)
		end
	end
	self:SendWeaponAnimEx(self.VM_DRAW)
	self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
	self.NextDeployed = CurTime() + self.DeployDuration
	self.IsDeployed = false
	return true
end

function SWEP:Holster()
	self.NextIdle = nil
	self.NextReloadStart = nil
	self.NextReload = nil
	self.Reloading = nil
	self.Owner.LastWeapon = self:GetClass()
	return true
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

function SWEP:PrimaryAttack()
	if self.NextDeployed and CurTime()<self.NextDeployed then return false end
	if self.Reloading then return false end
	
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
	
	if self.NextReload or self.NextReloadStart then
		self.NextReload = nil
		self.NextReloadStart = nil
	end
	
	if SERVER then
		self.Owner:Speak("TLK_FIREWEAPON", true)
	end
	
	return true
end

--[[
function SWEP:SecondaryAttack()
		if not self.HasSecondaryFire then return end
		if not self:CanSecondaryAttack() or self.Reloading then return end
		
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
end]]

function SWEP:SecondaryAttack()
	if self.HasSecondaryFire then
		if self.NextDeployed and CurTime()<self.NextDeployed then return false end
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
		
		if SERVER then
			self.Owner:Speak("TLK_FIREWEAPON", true)
		end
		
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

function SWEP:Reload()
	if self.NextReloadStart or self.NextReload or self.Reloading then return end
	
	if self.RequestedReload then
		if self.Delay and CurTime() < self.Delay then
			return false
		end
	else
		MsgN("Requested reload!")
		self.RequestedReload = true
		return false
	end
	
	MsgN("Reload!")
	self.RequestedReload = false
	
	if self.Primary and self.Primary.Ammo and self.Primary.ClipSize ~= -1 then
		local available = self.Owner:GetAmmoCount(self.Primary.Ammo)
		local ammo = self:Clip1()
		
		if ammo < self.Primary.ClipSize and available > 0 then
			self.NextIdle = nil
			if self.ReloadSingle then
				--self:SendWeaponAnim(ACT_RELOAD_START)
				self:SendWeaponAnimEx(self.VM_RELOAD_START)
				--self.Owner:SetAnimation(PLAYER_RELOAD) -- reload start
				self.NextReloadStart = CurTime() + (self.ReloadStartTime or self:SequenceDuration())
			else 
				self:SendWeaponAnimEx(self.VM_RELOAD)
				--self.Owner:SetAnimation(PLAYER_RELOAD)
				self.NextIdle = CurTime() + (self.ReloadTime or self:SequenceDuration())
				self.NextReload = self.NextIdle
				
				self.AmmoAdded = math.min(self.Primary.ClipSize - ammo, available)
				self.Reloading = true
				--self.reload_cur_start = CurTime()
			end
			--self:SetNextPrimaryFire( CurTime() + ( self.Primary.Delay || 0.25 ) + 1.4 )
			--self:SetNextSecondaryFire( CurTime() + ( self.Primary.Delay || 0.25 ) + 1.4 )
			return true
		end
	end
end

function SWEP:Think()
	if self.NextIdle and CurTime()>=self.NextIdle then
		self:SendWeaponAnimEx(self.VM_IDLE)
		self.NextIdle = nil
	end
	
	if self.RequestedReload then
		self:Reload()
	end
	
	if not self.IsDeployed and self.NextDeploy and CurTime()>=self.NextDeploy then
		self.IsDeployed = true
		if not self:CanPrimaryAttack() then
			self:Reload()
		end
	end
	
	if self.NextReload and CurTime()>=self.NextReload then
		self:SetClip1(self:Clip1() + self.AmmoAdded)
		
		if not self.ReloadSingle and self.ReloadDiscardClip then
			self.Owner:RemoveAmmo(self.Primary.ClipSize, self.Primary.Ammo, false)
		else
			self.Owner:RemoveAmmo(self.AmmoAdded, self.Primary.Ammo, false)
		end
		
		self.Delay = -1
		self.QuickDelay = -1
		
		if self:Clip1()>=self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo)==0 then
			-- Stop reloading
			self.Reloading = false
			if self.ReloadSingle then
				--self:SendWeaponAnim(ACT_RELOAD_FINISH)
				self:SendWeaponAnimEx(self.VM_RELOAD_FINISH)
				--self.Owner:SetAnimation(10001) -- reload finish
				self.Owner:DoAnimationEvent(ACT_MP_RELOAD_STAND_END, false)
				self.NextIdle = CurTime() + self:SequenceDuration() - 0.2
			else
				self:SendWeaponAnimEx(self.VM_IDLE)
				self.NextIdle = nil
			end
			self.NextReload = nil
		else
			self:SendWeaponAnimEx(self.VM_RELOAD)
			--self.Owner:SetAnimation(10000)
			self.Owner:DoAnimationEvent(ACT_MP_RELOAD_STAND_LOOP, false)
			self.NextReload = CurTime() + (self.ReloadTime or self:SequenceDuration())
		end
	end
	
	if self.NextReloadStart and CurTime()>=self.NextReloadStart then
		self:SendWeaponAnimEx(self.VM_RELOAD)
		--self.Owner:SetAnimation(10000) -- reload loop
		self.Owner:DoAnimationEvent(ACT_MP_RELOAD_STAND_LOOP, false)
		self.NextReload = CurTime() + (self.ReloadTime or self:SequenceDuration())
		
		self.AmmoAdded = 1
		
		self.NextReloadStart = nil
	end
end


function SWEP:Initialize()
	self:SetWeaponHoldType(self.HoldType or "PRIMARY")
end

function SWEP:SetWeaponHoldType(t)
	if IsValid(self.Owner) then
		tf_util.ReadActivitiesFromModel(self.Owner)
	end
	
	if not _E["ACT_MP_STAND_"..t] then
		MsgN("SWEP:SetWeaponHoldType - Unknown TF2 weapon hold type '"..t.."'! Defaulting to PRIMARY")
		t = "PRIMARY"
	end

	self.ActivityTranslate = {}
	self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _E["ACT_MP_STAND_"..t]
	self.ActivityTranslate[ACT_MP_RUN] 								= _E["ACT_MP_RUN_"..t]
	self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _E["ACT_MP_CROUCH_"..t]
	self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _E["ACT_MP_CROUCHWALK_"..t]
	self.ActivityTranslate[ACT_MP_SWIM] 							= _E["ACT_MP_SWIM_"..t]
	self.ActivityTranslate[ACT_MP_AIRWALK] 							= _E["ACT_MP_AIRWALK_"..t]
	
	if t == "PRIMARY" then
		self.ActivityTranslate[ACT_MP_DEPLOYED_IDLE] 				= ACT_MP_DEPLOYED_IDLE
		self.ActivityTranslate[ACT_MP_DEPLOYED] 					= ACT_MP_DEPLOYED_PRIMARY
		self.ActivityTranslate[ACT_MP_CROUCH_DEPLOYED_IDLE] 		= ACT_MP_CROUCH_DEPLOYED_IDLE
		self.ActivityTranslate[ACT_MP_CROUCH_DEPLOYED] 				= ACT_MP_CROUCHWALK_DEPLOYED
		self.ActivityTranslate[ACT_MP_SWIM_DEPLOYED] 				= ACT_MP_SWIM_DEPLOYED_PRIMARY
	else
		self.ActivityTranslate[ACT_MP_DEPLOYED_IDLE] 				= _E["ACT_MP_DEPLOYED_IDLE_"..t]
		self.ActivityTranslate[ACT_MP_DEPLOYED] 					= _E["ACT_MP_DEPLOYED_"..t]
		self.ActivityTranslate[ACT_MP_CROUCH_DEPLOYED_IDLE] 		= _E["ACT_MP_CROUCH_DEPLOYED_IDLE_"..t]
		self.ActivityTranslate[ACT_MP_CROUCH_DEPLOYED] 				= _E["ACT_MP_CROUCHWALK_DEPLOYED_"..t]
		self.ActivityTranslate[ACT_MP_SWIM_DEPLOYED] 				= _E["ACT_MP_SWIM_DEPLOYED_"..t]
	end
	
	self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 		= _E["ACT_MP_ATTACK_STAND_"..t]
	self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]		= _E["ACT_MP_ATTACK_CROUCH_"..t]
	self.ActivityTranslate[ACT_MP_ATTACK_SWIM_PRIMARYFIRE]			= _E["ACT_MP_ATTACK_SWIM_"..t]
	
	self.ActivityTranslate[ACT_MP_ATTACK_STAND_SECONDARYFIRE] 		= _E["ACT_MP_ATTACK_STAND_"..t.."_SECONDARY"]
	self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_SECONDARYFIRE]		= _E["ACT_MP_ATTACK_CROUCH_"..t.."_SECONDARY"]
	self.ActivityTranslate[ACT_MP_ATTACK_SWIM_SECONDARYFIRE]		= _E["ACT_MP_ATTACK_SWIM_"..t.."_SECONDARY"]
	
	self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARY_DEPLOYED] 	= _E["ACT_MP_ATTACK_STAND_"..t.."_DEPLOYED"]
	self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARY_DEPLOYED] 	= _E["ACT_MP_ATTACK_CROUCH_"..t.."_DEPLOYED"]
	self.ActivityTranslate[ACT_MP_ATTACK_SWIM_PRIMARY_DEPLOYED or 0]= _E["ACT_MP_ATTACK_SWIM_"..t.."_DEPLOYED"]
	
	self.ActivityTranslate[ACT_MP_ATTACK_STAND_PREFIRE]				= ACT_MP_ATTACK_STAND_PREFIRE
	self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PREFIRE]			= ACT_MP_ATTACK_CROUCH_PREFIRE
	self.ActivityTranslate[ACT_MP_ATTACK_SWIM_PREFIRE]				= ACT_MP_ATTACK_SWIM_PREFIRE
	
	self.ActivityTranslate[ACT_MP_ATTACK_STAND_POSTFIRE]			= ACT_MP_ATTACK_STAND_POSTFIRE
	self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_POSTFIRE]			= ACT_MP_ATTACK_CROUCH_POSTFIRE
	self.ActivityTranslate[ACT_MP_ATTACK_SWIM_POSTFIRE]				= ACT_MP_ATTACK_SWIM_POSTFIRE
	
	self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= _E["ACT_MP_RELOAD_STAND_"..t]
	self.ActivityTranslate[ACT_MP_RELOAD_CROUCH]		 			= _E["ACT_MP_RELOAD_CROUCH_"..t]
	self.ActivityTranslate[ACT_MP_RELOAD_SWIM]		 				= _E["ACT_MP_RELOAD_SWIM_"..t]
	
	self.ActivityTranslate[ACT_MP_RELOAD_STAND_LOOP]		 		= _E["ACT_MP_RELOAD_STAND_"..t.."_LOOP"]
	self.ActivityTranslate[ACT_MP_RELOAD_CROUCH_LOOP]		 		= _E["ACT_MP_RELOAD_CROUCH_"..t.."_LOOP"]
	self.ActivityTranslate[ACT_MP_RELOAD_SWIM_LOOP]		 			= _E["ACT_MP_RELOAD_SWIM_"..t.."_LOOP"]
	
	self.ActivityTranslate[ACT_MP_RELOAD_STAND_END]		 			= _E["ACT_MP_RELOAD_STAND_"..t.."_END"]
	self.ActivityTranslate[ACT_MP_RELOAD_CROUCH_END]		 		= _E["ACT_MP_RELOAD_CROUCH_"..t.."_END"]
	self.ActivityTranslate[ACT_MP_RELOAD_SWIM_END]		 			= _E["ACT_MP_RELOAD_SWIM_"..t.."_END"]
	
	self.ActivityTranslate[ACT_MP_JUMP_START] 						= _E["ACT_MP_JUMP_START_"..t]
	self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= _E["ACT_MP_JUMP_FLOAT_"..t]
	self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= _E["ACT_MP_JUMP_LAND_"..t]
end

function SWEP:TranslateActivity(act)
	return self.ActivityTranslate[act] or -1
end
