if SERVER then
	AddCSLuaFile( "shared.lua" )
	SWEP.HeadshotScore = 1
end
SWEP.PrintName			= "MVM Bowman 2"
SWEP.Category			= "Team Fortress 2"
SWEP.Spawnable 			= true

if CLIENT then

SWEP.HasCModel = true
SWEP.Slot				= 0

function SWEP:InspectAnimCheck()
inspect_start = NONE
inspect_idle = NONE
inspect_end = NONE
inspect_post = NONE
end

SWEP.CustomHUD = {HudBowCharge = true}
SWEP.ViewModelFlip = false 

function SWEP:ClientStartCharge()
	self.ClientCharging = true
	self.ClientChargeStart = CurTime()
end

function SWEP:ClientEndCharge()
	self.ClientCharging = false
end

end

SWEP.Base				= "tf_weapon_gun_base"

SWEP.ViewModel			= Model("models/weapons/c_models/c_sniper_arms.mdl")
SWEP.WorldModel			= Model("models/weapons/c_models/c_bow/c_bow.mdl")
SWEP.Crosshair = "tf_crosshair1"
SWEP.ViewModelFlip	= true

SWEP.MuzzleEffect = ""

SWEP.ShootSound = Sound("Weapon_CompoundBow.Single")
SWEP.ShootCritSound = Sound("Weapon_CompoundBow.SingleCrit")
SWEP.PullSound = Sound("Weapon_CompoundBow.SinglePull")
SWEP.ReloadSound = Sound("Weapon_CompoundBow.WorldReload")
SWEP.DeniedSound = Sound("Player.UseDeny")

SWEP.Primary.ClipSize		= 1
SWEP.Primary.DefaultClip	= 12
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= TF_PRIMARY
SWEP.Primary.Delay          = 1.94
SWEP.ReloadTimez          = 1.94 * 0.2

SWEP.Secondary.Automatic	= true

SWEP.IsRapidFire = false
SWEP.ReloadSingle = false

SWEP.HoldType = "ITEM2"
SWEP.HoldTypeHL2 = "crossbow"

SWEP.ProjectileShootOffset = Vector(0, 6, -5)

SWEP.Properties = {}


function SWEP:Deploy()
	if CLIENT then
		HudBowCharge:SetProgress(0)
	end
	
	self.ViewModelFlip = false
	
	return self:CallBaseFunction("Deploy")
end

function SWEP:SendSequence(seq)
	local s = self.Owner:GetViewModel():LookupSequence(seq)
	self:SetSequence(s)
	self.Owner:GetViewModel():SetSequence(s)
end

function SWEP:PrimaryAttack()
	if not self.IsDeployed then return false end
	
	-- Already charging
	if self.Charging or self.NextIdle then return end
	
	if not self:CanPrimaryAttack() then
		return
	end
	
	-- Start charging
	self.Charging = true
	if SERVER then
		self:CallOnClient("ClientStartCharge", "")
	end
	
	self:SendWeaponAnim(self.VM_CHARGE)
	--self:SendSequence("bw_charge")
	--self.Owner:SetAnimation(PLAYER_PREFIRE)
	--self.Owner:DoAnimationEvent(ACT_MP_DEPLOYED, true)
	
	if SERVER then
		self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_PREFIRE, true)
	end
	self.NextIdle2 = CurTime()+self:SequenceDuration()
	self.ChargeStartTime = CurTime()
	self:EmitSound(self.PullSound)
	--[[
	self:Critical(1)
	self:ShootProjectile()
	
	self:TakePrimaryAmmo(1)]]
	
	if SERVER then
		self.Owner:SetClassSpeed(3 * 45 * (self.DeployMoveSpeedMultiplier or 1))
		self.Owner:SetCrouchedWalkSpeed(0.33)
		self.Owner:SetJumpPower(0)
	end
end

function SWEP:SecondaryAttack()
	if not self.IsDeployed then return false end
	
	if self.Charging and not self.NextIdle2 then
		self.Charging = false
		self:SendWeaponAnim(self.VM_DRYFIRE)
		--self:SendSequence("bw_dryfire")
		if SERVER then
			self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_POSTFIRE, true)
		end
		self.Owner:DoAnimationEvent(ACT_MP_STAND_PRIMARY, true)
		self.NextIdle = CurTime()+self:SequenceDuration()
		
		if SERVER then
			self:CallOnClient("ClientEndCharge", "")
			if self.Owner:GetInfoNum("tf_giant_robot",0) != 1 then
			self.Owner:ResetClassSpeed()
			end
		end
	end
end

function SWEP:ShootProjectile()
	if SERVER then
		local arrow = ents.Create("tf_projectile_arrow")
		arrow:SetPos(self:ProjectileShootPos())
		
		if CurTime()-self.ChargeStartTime>5 then
			arrow:SetAngles(self.Owner:EyeAngles() + Angle(math.Rand(-15,15),math.Rand(-15,15),0))
		else
			arrow:SetAngles(self.Owner:EyeAngles())
		end
		
		--[[
		if arrow:Critical() then
			rocket.critical = true
		end]]
		
		for k,v in pairs(self.Properties) do
			arrow[k] = v
		end
		
		arrow.Charge = math.Clamp((CurTime()-self.ChargeStartTime) / 1.25, 0, 1)
		arrow.MinForce = self.MinForce
		arrow.MaxForce = self.MaxForce
		arrow.MinGravity = self.MinGravity
		arrow.MaxGravity = self.MaxGravity
		arrow:SetOwner(self.Owner)
		self:InitProjectileAttributes(arrow)
		
		arrow.NameOverride = self:GetItemData().item_iconname
		arrow:Spawn()
		arrow:Activate()
	end
	
	self:ShootEffects()
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
		----MsgN("Requested reload!")
		self.RequestedReload = true
		return false
	end
	
	self.CanInspect = false
	
	----MsgN("Reload!")
	self.RequestedReload = false
	
	if self.Primary and self.Primary.Ammo and self.Primary.ClipSize ~= -1 then
		local available = self.Owner:GetAmmoCount(self.Primary.Ammo)
		local ammo = self:Clip1()
		
		if ammo < self.Primary.ClipSize and available > 0 then
			self.NextIdle = nil
			if self.ReloadSingle then
				--self:SendWeaponAnim(ACT_RELOAD_START)
				self:SendWeaponAnimEx(self.VM_RELOAD_START)
				self.Owner:SetAnimation(PLAYER_RELOAD) -- reload start
				self.NextReloadStart = CurTime() + (self.ReloadStartTime or self:SequenceDuration())
			else
				self:SendWeaponAnimEx(self.VM_RELOAD)
				self.Owner:SetAnimation(PLAYER_RELOAD)
				self.NextIdle = CurTime() + (self.ReloadTime or self:SequenceDuration())
				self.NextReload = self.NextIdle
				
				self.AmmoAdded = math.min(self.Primary.ClipSize - ammo, available)
				self.Reloading = true
				
				timer.Simple(0.1, function()
					if self.ReloadSound and CLIENT then
					local w = self
		
						if IsValid(w) and w.ReloadSound and (w.Owner ~= self.Owner or self.Owner:ShouldDrawLocalPlayer()) then
							w.Owner:EmitSound("Weapon_Bow.Draw")
							w:EmitSound("Weapon_Bow.ArrowSlide")
						end
					end
				end)	
				timer.Simple(0.4, function()
					if self.ReloadSound and CLIENT then
						local w = self
	
						if IsValid(w) and w.ReloadSound and (w.Owner ~= self.Owner or self.Owner:ShouldDrawLocalPlayer()) then
							w:EmitSound("Weapon_Bow.PullShort")
						end
					end
				end)
				--self.reload_cur_start = CurTime()
			end
			--self:SetNextPrimaryFire( CurTime() + ( self.Primary.Delay || 0.25 ) + 1.4 )
			--self:SetNextSecondaryFire( CurTime() + ( self.Primary.Delay || 0.25 ) + 1.4 )
			return true
		end
	end
end

function SWEP:Think()
	self:TFViewModelFOV()

	if SERVER and self.NextReplayDeployAnim then
		if CurTime() > self.NextReplayDeployAnim then
			--MsgFN("Replaying deploy animation %d", self.VM_DRAW)
			timer.Simple(0.1, function() self:SendWeaponAnim(self.VM_DRAW) end)
			self.NextReplayDeployAnim = nil
		end
	end
	
	if CLIENT then
		if self.ClientCharging and self.ClientChargeStart then
			HudBowCharge:SetProgress((CurTime()-self.ClientChargeStart) / 1.25)
		else
			HudBowCharge:SetProgress(0)
		end
	end
	
	if not self.IsDeployed and self.NextDeployed and CurTime()>=self.NextDeployed then
		self.IsDeployed = true
		self.CanInspect = true
		self:CheckAutoReload()
	end
	
	if self.NextIdle and CurTime()>=self.NextIdle then
		self:SendWeaponAnim(self.VM_IDLE)
		self.NextIdle = nil
		self.NextIdle2 = nil
		self.NextCharge3 = nil
		self.NextIdle3 = nil
	end
	
	if self.NextIdle2 and CurTime()>=self.NextIdle2 then
		self:SendWeaponAnim(self.VM_IDLE_2)
		--self:SendSequence("bw_idle2")
		self.NextIdle2 = nil
		self.NextCharge3 = CurTime()+5
	end
	
	if self.NextCharge3 and CurTime()>=self.NextCharge3 then
		self:SendWeaponAnim(self.VM_CHARGE_IDLE_3)
		--self:SendSequence("bw_shake")
		self.NextCharge3 = nil
		self.NextIdle3 = CurTime()+self:SequenceDuration()
	end
	
	if self.NextIdle3 and CurTime()>=self.NextIdle3 then
		self:SendWeaponAnim(self.VM_IDLE_3)
		--self:SendSequence("bw_idle3")
		self.NextIdle3 = nil
	end
	
	if self.Charging and not self.Idle2 and not self.Owner:KeyDown(IN_ATTACK) and self.Owner:IsOnGround() then
		self.Charging = false
		if SERVER then
			self:CallOnClient("ClientEndCharge", "")
		end
		self.NextIdle = nil
		self.NextIdle2 = nil
		self.NextCharge3 = nil
		self.NextIdle3 = nil
		self:ShootProjectile()
		self:TakePrimaryAmmo(1)
		timer.Simple(0.85, function()
			if self.ReloadSound and CLIENT then
				local w = self
	
				if IsValid(w) and w.ReloadSound and (w.Owner ~= self.Owner or self.Owner:ShouldDrawLocalPlayer()) then
					w.Owner:EmitSound("Weapon_Bow.Draw")
					w:EmitSound("Weapon_Bow.ArrowSlide")
				end
			end
		end)	
		timer.Simple(1.2, function()
			if self.ReloadSound and CLIENT then
				local w = self
	
				if IsValid(w) and w.ReloadSound and (w.Owner ~= self.Owner or self.Owner:ShouldDrawLocalPlayer()) then
					w:EmitSound("Weapon_Bow.PullShort")
				end
			end
		end)	
		self:SendWeaponAnim(self.VM_PRIMARYATTACK)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self.Owner:DoAnimationEvent(ACT_MP_STAND_PRIMARY, true)
		if (self.Owner:GetPlayerClass() == "bowman_rapid_fire") then
			self.NextIdle = CurTime()+self:SequenceDuration() * 0.6
		else
			self.NextIdle = CurTime()+self:SequenceDuration()
		end
		if self.Owner:GetAmmoCount(self.Primary.Ammo)>0 then
			self.Reloading = true
			self.AmmoAdded = 1
			self.NextReload = self.NextIdle-0.1
		end
		
		if SERVER then
			if self.Owner:GetInfoNum("tf_giant_robot",0) != 1 then
			self.Owner:ResetClassSpeed()
			end
		end
	end
	
	if self.NextReload and CurTime()>=self.NextReload then
		self:SetClip1(self:Clip1() + self.AmmoAdded)
		self.Owner:RemoveAmmo(self.AmmoAdded, self.Primary.Ammo, false)
		self.NextReload = nil
	end
end
