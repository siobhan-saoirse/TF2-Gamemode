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
local defaultdeployspeed = CreateConVar( "tf_default_deploy_speed", "1.4", {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE}, "LEGS!" )
-- Sounds

if CLIENT then

function SWEP:DrawWorldModel(  )
		local _Owner = self:GetOwner()

		if (!IsValid(self.WModel)) then
			self.WModel = ents.CreateClientProp()
			self.WModel:Spawn()
			self.WModel:SetNoDraw(true)
		end
		if (IsValid(_Owner)) then
			local t2 = _Owner:GetProxyVar("CritTeam") 
			local s2 = _Owner:GetProxyVar("CritStatus")
			self.WModel:SetProxyVar("CritTeam",t2)
			self.WModel:SetProxyVar("CritStatus",s2)
            -- Specify a good position
			
			local model = self:GetItemData().model_world or self:GetItemData().model_player or self.WorldModel
			if (self.WModel:GetModel() != model) then
				self.WModel:SetModel(model)
			end
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
			if (self.WModel:GetMaterial() != "models/effects/invulnfx_"..ParticleSuffix(GAMEMODE:EntityTeam(self:GetOwner())) and _Owner:HasGodMode() and (_Owner:GetSkin() == 2 or _Owner:GetSkin() == 3) and !_Owner:GetNWBool("NoWeapon",false)) then
				self.WModel:SetMaterial("models/effects/invulnfx_"..ParticleSuffix(GAMEMODE:EntityTeam(self:GetOwner())))
			elseif (_Owner:GetNWBool("NoWeapon",false) == true or _Owner:GetMaterial() == "color") then 
				self.WModel:SetMaterial("color")
			else
				local mat = self.CustomMaterialOverride2 or self.MaterialOverride or self.WeaponMaterial or ""
				if (self.WModel:GetMaterial() != mat) then
					self.WModel:SetMaterial(mat)	
				end
			end
			self.WModel:SetSkin(self.WeaponSkin or self:GetOwner():GetSkin())
			self.WModel:SetPos(self:GetPos())
			self.WModel:SetAngles(self:GetAngles())
			self.WModel:SetParent(self.Owner)
			self.WModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))	
		else	
			self.WModel:SetPos(self:GetPos())
			self.WModel:SetAngles(self:GetAngles())
		end 
		self.WModel:DrawModel()
		
end

end

-- Viewmodel FOV should be constant, don't change this


SWEP.ViewModelFlip	= false
--eugh, another ugly hack.
if GetConVar("tf_righthand") then
	if GetConVar("tf_righthand"):GetInt() == 0 then
		SWEP.ViewModelFlip = true
	else
		SWEP.ViewModelFlip = false
	end
end

function SWEP:TranslateFOV( fov )
	return fov
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
SWEP.Secondary.Delay        = 0
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
SWEP.MaxDamageRampUp = 0.0
SWEP.MaxDamageFalloff = 0.0
SWEP.DamageModifier = 0

SWEP.IsRapidFire = false
SWEP.CriticalChance = 1
SWEP.CritSpreadDuration = 2

SWEP.HasSecondaryFire = false

SWEP.ProjectileShootOffset = Vector(0,0,0)

SWEP.CanInspect = true

SWEP.LastClass = "scout"

SWEP.g_lateralBob = 0
SWEP.g_verticalBob = 0
CreateClientConVar("viewmodel_fov_tf", "54", true, false)
CreateClientConVar("tf_use_viewmodel_fov", "1", true, false)
CreateClientConVar("tf_righthand", "1", true, true)
CreateClientConVar("tf_sprintinspect", "0", true, true)
CreateClientConVar("tf_reloadinspect", "1", true, true)
CreateClientConVar("tf_use_min_viewmodels", "0", true, false)
local cvar_bob = CreateClientConVar("tf_cl_bob", "0.005", false, false)
local cvar_bobup = CreateClientConVar("tf_cl_bobup", "0.5", false, false)
local cvar_bobcycle = CreateClientConVar("tf_cl_bobcycle", "0.8", false, false)

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

local bobtime = 0
local lastbobtime = 0
local lastspeed = 0
local cycle = 0
local speed = 0
local flmaxSpeedDelta = 0
local bob_offset = 0
function SWEP:CalcViewModelBobHelper(  )
	local cl_bob = cvar_bob:GetFloat()
	local cl_bobcycle = math.max(cvar_bobcycle:GetFloat(), 0.1)
	local cl_bobup = cvar_bobup:GetFloat()
	
	local ply = LocalPlayer()
	
	if ply:ShouldDrawLocalPlayer() then return 0 end

	local cltime = CurTime()
	local cycle = cltime - math.floor(cltime/cl_bobcycle)*cl_bobcycle
	cycle = cycle / cl_bobcycle
	if (cycle < cl_bobup) then
		cycle = math.pi * cycle / cl_bobup
	else
		cycle = math.pi + math.pi*(cycle-cl_bobup)/(1.0 - cl_bobup)
	end

	local velocity = ply:GetVelocity()

	self.g_verticalBob = math.Clamp(math.sqrt(velocity[1]*velocity[1] + velocity[2]*velocity[2]),-320.0,320.0) * cl_bob
	self.g_verticalBob = self.g_verticalBob*0.3 + self.g_verticalBob*0.7*math.sin(cycle)
	if (self.g_verticalBob > 4) then
		self.g_verticalBob = 4
	elseif (self.g_verticalBob < -7) then
		self.g_verticalBob = -7
	end
	
	local cycle2 = cltime - math.floor(cltime/(cl_bobcycle*2))*(cl_bobcycle*2)
	cycle2 = cycle2 / cl_bobcycle*0.5
	if (cycle2 < cl_bobup) then
		cycle2 = math.pi * cycle2 / cl_bobup
	else
		cycle2 = math.pi + math.pi*(cycle2-cl_bobup)/(1.0 - cl_bobup)
	end

	self.g_lateralBob = math.Clamp(math.sqrt(velocity[1]*velocity[1] + velocity[2]*velocity[2]),-320.0,320.0) * cl_bob
	self.g_lateralBob = self.g_lateralBob*0.3 + self.g_lateralBob*0.7*math.sin(cycle2)
	if (self.g_lateralBob > 4) then
		self.g_lateralBob = 4
	elseif (self.g_lateralBob < -7) then
		self.g_lateralBob = -7
	end
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
	return tf_util.CalculateDamage(self, self:GetPos(), self.Owner:GetPos())
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

function SWEP:VectorMA( start, scale, direction, dest )
	--[[
	dest.x = start.x + scale * direction.x;
	dest.y = start.y + scale * direction.y;
	dest.z = start.z + scale * direction.z;
	]]
	return Vector(start.x + scale * direction.x,start.y + scale * direction.y,start.z + scale * direction.z)
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
	if (string.StartWith(self.Owner:GetModel(),"models/infected/")) then
		return oldpos, oldang
	else
		-- actual code, for reference
		--[[
		
		Vector	forward, right;
		AngleVectors( angles, &forward, &right, NULL );

		CalcViewmodelBob();

		// Apply bob, but scaled down to 40%
		VectorMA( origin, g_verticalBob * 0.4f, forward, origin );

		// Z bob a bit more
		origin[2] += g_verticalBob * 0.1f;

		// bob the angles
		angles[ ROLL ]	+= g_verticalBob * 0.5f;
		angles[ PITCH ]	-= g_verticalBob * 0.4f;

		angles[ YAW ]	-= g_lateralBob  * 0.3f;

	//	VectorMA( origin, g_lateralBob * 0.2f, right, origin );

		]]
		if CLIENT then
			local forward = self.Owner:GetForward()
			local right = self.Owner:GetRight()
			local origin = oldpos
			local angles = oldang
			self:CalcViewModelBobHelper()

			// Apply bob, but scaled down to 40%
			origin = self:VectorMA( origin, self.g_verticalBob * 0.4, forward, origin );

			// Z bob a bit more
			origin.z = origin.z + self.g_verticalBob * 0.1;

			// bob the angles
			angles.r	= angles.r + self.g_verticalBob * 0.5;
			angles.p	= angles.p - self.g_verticalBob * 0.4;
			angles.y = angles.y - self.g_lateralBob  * 0.3;

			origin = self:VectorMA( origin, self.g_lateralBob * 0.2, right, origin );
			return origin, angles
		else
			return oldpos, oldang
		end
	end
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
	local vm = self.Owner:GetViewModel()
	if (IsValid(vm)) then
		if (self.Owner:IsHL2()) then
			self.Owner:GetViewModel():SetMaterial("")
		else
			if (string.find(self.ViewModel,"c_models")) then
				self.Owner:GetViewModel():SetMaterial("color")
			else
				self.Owner:GetViewModel():SetMaterial("")
			end
		end
	end
	if (self.Owner.anim_Deployed) then
		self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_POSTFIRE)
	end
	self:TFViewModelFOV()
	self:TFFlipViewmodel()
	self:InspectAnimCheck()
	if (self.MarkForDeath) then
		self.Owner:AddPlayerState(PLAYERSTATE_MARKED, true)
	end
	if CLIENT then
		if (self:GetItemData().image_inventory and self:GetItemData().item_iconname) then
			killicon.Add( self:GetItemData().item_iconname, ""..self:GetItemData().image_inventory.."_large", Color( 255, 255, 255, 255 ) )
		elseif (self:GetItemData().image_inventory and !self:GetItemData().item_iconname) then
			killicon.Add( string.Replace(self:GetClass(),"tf_weapon_",""), ""..self:GetItemData().image_inventory.."_large", Color( 255, 255, 255, 255 ) )
		end
	end
	if (self:GetItemData().item_name) then
		self.PrintName = self:GetItemData().name
	end
	if (self.Owner:IsHL2()) then
		self:SetWeaponHoldType(self.HoldTypeHL2 or self.HoldType)
	end
	
	if (self:GetClass() == "tf_weapon_shotgun") then
		if (self.Owner:GetPlayerClass() == "soldier"
		|| self.Owner:GetPlayerClass() == "heavy"
		|| self.Owner:GetPlayerClass() == "giantheavyshotgun"
		|| self.Owner:GetPlayerClass() == "heavyshotgun"
		|| self.Owner:GetPlayerClass() == "pyro") then
			self.VM_DRAW = ACT_SECONDARY_VM_DRAW	
			self.VM_IDLE = ACT_SECONDARY_VM_IDLE
			self.VM_PRIMARYATTACK = ACT_SECONDARY_VM_PRIMARYATTACK
			self.VM_RELOAD_START = ACT_SECONDARY_RELOAD_START
			self.VM_RELOAD = ACT_SECONDARY_VM_RELOAD
			self.VM_RELOAD_FINISH = ACT_SECONDARY_RELOAD_FINISH
			self.Slot				= 1
			self:SetHoldType("SECONDARY")
		elseif (self.Owner:GetPlayerClass() == "scout"
		|| self.Owner:GetPlayerClass() == "engineer") then
			self.VM_DRAW = ACT_PRIMARY_VM_DRAW	
			self.VM_IDLE = ACT_PRIMARY_VM_IDLE
			self.VM_PRIMARYATTACK = ACT_PRIMARY_VM_PRIMARYATTACK
			self.VM_RELOAD_START = ACT_PRIMARY_RELOAD_START
			self.VM_RELOAD = ACT_PRIMARY_VM_RELOAD
			self.VM_RELOAD_FINISH = ACT_PRIMARY_RELOAD_FINISH
			self.Slot				= 0
			self:SetHoldType("PRIMARY")
		else
			self.VM_DRAW = ACT_SECONDARY_VM_DRAW	
			self.VM_IDLE = ACT_SECONDARY_VM_IDLE
			self.VM_PRIMARYATTACK = ACT_SECONDARY_VM_PRIMARYATTACK
			self.VM_RELOAD_START = ACT_SECONDARY_RELOAD_START
			self.VM_RELOAD = ACT_SECONDARY_VM_RELOAD
			self.VM_RELOAD_FINISH = ACT_SECONDARY_RELOAD_FINISH
			self.Slot				= 1
			self:SetHoldType("SECONDARY")
		end
	end
	--MsgFN("Deploy %s", tostring(self))
	local wmodel = self:GetItemData().model_player or self.WorldModel
	if (self.Owner:GetNWBool("NoWeapon")) then
		--self.WorldModel = "models/empty.mdl"
	else
		--self.WorldModel = wmodel
	end
	local vm = self.Owner:GetViewModel()
	if (self:GetItemData()) then
		if (self:GetItemData().model_player) then

			if (self:GetItemData().model_player == "models/weapons/c_models/c_bigaxe/c_bigaxe.mdl") then
				self.HitWorld = "Halloween.HeadlessBossAxeHitWorld"
				self.HitFlesh = "Halloween.HeadlessBossAxeHitFlesh"
			end
			if (self:GetItemData().model_player == "models/workshop/weapons/c_models/c_demo_sultan_sword/c_demo_sultan_sword.mdl") then
				self:SetHoldType("MELEE_ALLCLASS")
				self.HoldType = "MELEE_ALLCLASS"
				local hold = "MELEE_ALLCLASS"
				self.VM_DRAW			= _G["ACT_"..hold.."_VM_DRAW"]
				self.VM_IDLE			= _G["ACT_"..hold.."_VM_IDLE"]
				self.VM_PRIMARYATTACK	= _G["ACT_"..hold.."_VM_PRIMARYATTACK"]
				self.VM_SECONDARYATTACK	= _G["ACT_"..hold.."_VM_SECONDARYATTACK"]
				self.VM_RELOAD			= _G["ACT_"..hold.."_VM_RELOAD"]
				self.VM_RELOAD_START	= _G["ACT_"..hold.."_RELOAD_START"]
				self.VM_RELOAD_FINISH	= _G["ACT_"..hold.."_RELOAD_FINISH"]
				
				-- Special activities
				self.VM_CHARGE			= _G["ACT_"..hold.."_VM_CHARGE"]
				self.VM_DRYFIRE			= _G["ACT_"..hold.."_VM_DRYFIRE"]
				self.VM_IDLE_2			= _G["ACT_"..hold.."_VM_IDLE_2"]
				self.VM_CHARGE_IDLE_3	= _G["ACT_"..hold.."_VM_CHARGE_IDLE_3"]
				self.VM_IDLE_3			= _G["ACT_"..hold.."_VM_IDLE_3"]
				self.VM_PULLBACK		= _G["ACT_"..hold.."_VM_PULLBACK"]
				self.VM_PREFIRE			= _G["ACT_"..hold.."_ATTACK_STAND_PREFIRE"]
				self.VM_POSTFIRE		= _G["ACT_"..hold.."_ATTACK_STAND_POSTFIRE"]
						
				self.VM_RELOAD_START	= getfenv()["ACT_"..hold.."_RELOAD_START"]
				self.VM_RELOAD	= getfenv()["ACT_"..hold.."_VM_RELOAD"]
				self.VM_RELOAD_FINISH		= getfenv()["ACT_"..hold.."_RELOAD_FINISH"]
				self.VM_INSPECT_START	= _G["ACT_"..hold.."_VM_INSPECT_START"]
				self.VM_INSPECT_IDLE	= _G["ACT_"..hold.."_VM_INSPECT_IDLE"]
				self.VM_INSPECT_END		= _G["ACT_"..hold.."_VM_INSPECT_END"]
				self.BACKSTAB_VM_UP		= getfenv()["ACT_"..hold.."_BACKSTAB_VM_UP"]
				self.BACKSTAB_VM_DOWN		= getfenv()["ACT_"..hold.."_BACKSTAB_VM_DOWN"]
			end
			
		end
	end
	if (self.Owner:GetPlayerClass() != "combinesoldier") then
		if CLIENT then
			if (self:GetClass() != "tf_weapon_pda_spy") then
				if IsValid(self.CModel) then
					self.CModel:SetModel(wmodel)
					self.CModel:SetNoDraw(true)
					self.CModel:SetParent(vm)
					self.CModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
					self.CModel:DrawModel()
					self.CModel:SetSkin(self.WeaponSkin or self:GetOwner():GetSkin())
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
					self.CModel:SetSkin(self.WeaponSkin or self:GetOwner():GetSkin())
				end
				if (self:GetItemData() and self:GetItemData().extra_wearable) then
					if IsValid(self.ExtraCModel) then
						self.ExtraCModel:SetModel(self:GetItemData().extra_wearable)
						self.ExtraCModel:SetNoDraw(true)
						self.ExtraCModel:SetParent(self.CModel)
						self.ExtraCModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
						self.ExtraCModel:DrawModel()
					elseif IsValid(vm) and !IsValid(self.ExtraCModel) then
						self.ExtraCModel = ClientsideModel(wmodel)
						if not IsValid(self.ExtraCModel) then return end
						self.ExtraCModel:SetModel(self:GetItemData().extra_wearable)
						self.ExtraCModel:SetNoDraw(true)
						self.ExtraCModel:SetParent(self.CModel)
						self.ExtraCModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
						self.ExtraCModel:Spawn()
						self.ExtraCModel:Activate()
						self.ExtraCModel:DrawModel()
					end
					if IsValid(self.ExtraWModel) then
						self.ExtraWModel:SetModel(self:GetItemData().extra_wearable)
						self.ExtraWModel:SetNoDraw(true)
						self.ExtraWModel:SetParent(vm)
						self.ExtraWModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
						self.ExtraWModel:DrawModel()
					elseif IsValid(vm) and !IsValid(self.ExtraWModel) then
						self.ExtraWModel = ClientsideModel(wmodel)
						if not IsValid(self.ExtraWModel) then return end
						self.ExtraWModel:SetModel(self:GetItemData().extra_wearable)
						self.ExtraWModel:SetNoDraw(false)
						self.ExtraWModel:SetParent(self)
						self.ExtraWModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
						self.ExtraWModel:Spawn()
						self.ExtraWModel:Activate()
						self.ExtraWModel:DrawModel()
					end
				end 
				if (self:GetVisuals() and self:GetVisuals().attached_models and self:GetVisuals().attached_models[0]["model"]) then
					if IsValid(self.ExtraCModel) then
						self.ExtraCModel:SetModel(self:GetVisuals().attached_models[0]["model"])
						self.ExtraCModel:SetNoDraw(true)
						self.ExtraCModel:SetParent(self.CModel)
						self.ExtraCModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
						self.ExtraCModel:DrawModel()
					elseif IsValid(vm) and !IsValid(self.ExtraCModel) then
						self.ExtraCModel = ClientsideModel(wmodel)
						if not IsValid(self.ExtraCModel) then return end
						self.ExtraCModel:SetModel(self:GetVisuals().attached_models[0]["model"])
						self.ExtraCModel:SetNoDraw(true)
						self.ExtraCModel:SetParent(self.CModel)
						self.ExtraCModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
						self.ExtraCModel:Spawn()
						self.ExtraCModel:Activate()
						self.ExtraCModel:DrawModel()
					end
					if IsValid(self.ExtraWModel) then
						self.ExtraWModel:SetModel(self:GetVisuals().attached_models[0]["model"])
						self.ExtraWModel:SetNoDraw(true)
						self.ExtraWModel:SetParent(vm)
						self.ExtraWModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
						self.ExtraWModel:DrawModel()
					elseif IsValid(vm) and !IsValid(self.ExtraWModel) then
						self.ExtraWModel = ClientsideModel(wmodel)
						if not IsValid(self.ExtraWModel) then return end
						self.ExtraWModel:SetModel(self:GetVisuals().attached_models[0]["model"])
						self.ExtraWModel:SetNoDraw(false)
						self.ExtraWModel:SetParent(self)
						self.ExtraWModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
						self.ExtraWModel:Spawn()
						self.ExtraWModel:Activate()
						self.ExtraWModel:DrawModel()
					end
				end
			else
				if (self:GetClass() != "tf_weapon_pda_spy") then
					if IsValid(self.CModel) then
						self.CModel:SetModel("models/empty.mdl")
						self.CModel:SetNoDraw(true)
						self.CModel:SetParent(vm)
						self.CModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
						self.CModel:DrawModel()
						self.CModel:SetSkin(self.WeaponSkin or self:GetOwner():GetSkin())
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
						self.CModel:SetSkin(self.WeaponSkin or self:GetOwner():GetSkin())
					end
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
				self:SetWeaponHoldType(self.HoldType)
			end
		end
	end	
	
	local hold = self.HoldType 
	--MsgN(Format("SetupCModelActivities %s", tostring(self)))
	if (self.Owner:GetNWBool("NoWeapon")) then
		--self.WorldModel = "models/empty.mdl"
	else
		--self.WorldModel = wmodel;
	end
	--self:InitializeWModel2()
	--self:InitializeAttachedModels()
	if SERVER then
		if IsValid(self.WModel) then 
			--self.WModel:SetSkin(self.WeaponSkin or self.Owner:GetSkin())
			--self.WModel:SetMaterial(self.MaterialOverride or self.WeaponMaterial or 0)
		end
	end
	if self.Owner:IsPlayer() and not self.Owner:IsHL2() and self.Owner:Team() == TEAM_BLU and string.find(game.GetMap(), "mvm_") then
		if SERVER then
			self.Owner:SetBloodColor(BLOOD_COLOR_MECH)
		end
	end
		if IsValid(self) then
			if IsValid(self.Owner) then
				if IsValid(self.Owner:GetViewModel()) then  
					if self.Owner.TempAttributes and self.Owner.TempAttributes.DeployTimeMultiplier then
						self:SetDeploySpeed(defaultdeployspeed:GetFloat() / self.Owner.TempAttributes.DeployTimeMultiplier)
					elseif self.DeployTimeMultiplier then
						self:SetDeploySpeed(defaultdeployspeed:GetFloat() / self.DeployTimeMultiplier)
					else
						self:SetDeploySpeed(defaultdeployspeed:GetFloat())
					end
				end
			end
		end
	if IsValid(self.CModel) then

		local t2 = self.Owner:GetProxyVar("CritTeam") 
		local s2 = self.Owner:GetProxyVar("CritStatus")
		self.CModel:SetProxyVar("CritTeam",t2)
		self.CModel:SetProxyVar("CritStatus",s2)

	end
	self:StopTimers()
	self.DeployPlayed = nil
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
			--self:SendWeaponAnimEx(ACT_INVALID)
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
		if !self.Owner:IsHL2() then
			self.Owner:ResetClassSpeed()
		end
	end
	
	if CLIENT and not self.DoneFirstDeploy then
		self.RestartClientsideDeployAnim = true
		self.DoneFirstDeploy = true
	end
	
	--MsgFN("SendWeaponAnim %s %d", tostring(self), self.VM_DRAW)
	--	print("DRAW ANIM")
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

	self:InspectAnimCheck()
	local hold = self.HoldType
	local drawAnim = self.VM_DRAW
	if (self.VM_DRAW != nil) then
		local draw_duration = self:SequenceDuration(self:SelectWeightedSequence(self.VM_DRAW)) / self:GetDeploySpeed()
		local deploy_duration = self.DeployDuration / self:GetDeploySpeed() 
		if SERVER then
			self:SendWeaponAnim(drawAnim)
			self.Owner:GetViewModel():SetPlaybackRate(self:GetDeploySpeed())
		end
			
		if self.Owner.TempAttributes and self.Owner.TempAttributes.DeployTimeMultiplier then
			draw_duration = draw_duration * self.Owner.TempAttributes.DeployTimeMultiplier
			deploy_duration = deploy_duration * self.Owner.TempAttributes.DeployTimeMultiplier
		elseif self.DeployTimeMultiplier then
			draw_duration = draw_duration * self.DeployTimeMultiplier
			deploy_duration = deploy_duration * self.DeployTimeMultiplier
		end
		if (self:GetClass() == "tf_weapon_syringegun_medic") then
			self.NextIdle = CurTime() + 0.5
			self.NextDeployed = CurTime() + 0.5
		elseif (self:GetClass() == "tf_weapon_crossbow") then
			self.NextIdle = CurTime() + 0.5
			self.NextDeployed = CurTime() + 0.5
		else
			self.NextIdle = CurTime() + draw_duration + 0.02
			self.NextDeployed = CurTime() + deploy_duration + 0.02
		end
	end
	if (IsValid(self.CModel)) then
		self.CModel:SetSkin(self.WeaponSkin or self:GetOwner():GetSkin())
	end
	return true
end

function SWEP:InspectAnimCheck()
	-- todo: find a better way to do this
	-- InspectAnimCheck probably isn't the best place for this...
	if (string.StartWith(self.Owner:GetModel(),"models/infected/")) then return end
	
	if (self:GetItemData()) then
		if (self:GetItemData().model_player) then

			if (self:GetItemData().model_player == "models/workshop/weapons/c_models/c_demo_sultan_sword/c_demo_sultan_sword.mdl") then
				self:SetWeaponHoldType("MELEE_ALLCLASS")
			end
			
		end
	end
	if CLIENT then
		if (self:GetItemData().image_inventory and self:GetItemData().item_iconname) then
			killicon.Add( self:GetItemData().item_iconname, self:GetItemData().image_inventory, Color( 255, 255, 255, 255 ) )
		elseif (self:GetItemData().image_inventory) then
			killicon.Add( string.Replace(self:GetClass(),"tf_weapon_",""), self:GetItemData().image_inventory, Color( 255, 255, 255, 255 ) )
		end
	end
		if self:GetVisuals() then
			local visuals = self:GetVisuals()
			if visuals.animation_replacement then 
				local replace = visuals.animation_replacement

				if replace.act_vm_draw then
					self.VM_DRAW = getfenv()[replace.act_vm_draw]
				end


				if replace.act_vm_idle then
					self.VM_IDLE = getfenv()[replace.act_vm_idle]
				end

				if replace.act_vm_primaryattack then
					self.VM_PRIMARYATTACK = getfenv()[replace.act_vm_primaryattack]
				end

				if replace.act_vm_reload then
					self.VM_RELOAD = getfenv()[replace.act_vm_reload]
				end

				if replace.act_reload_start then
					self.VM_RELOAD_START = getfenv()[replace.act_reload_start]
				end
				 
				if replace.act_reload_finish then
					self.VM_RELOAD_FINISH = getfenv()[replace.act_reload_finish]
				end

				if replace.act_primary_vm_inspect_end then
					self.VM_INSPECT_END = getfenv()[replace.act_primary_vm_inspect_end]
				end


				if replace.act_primary_vm_inspect_start then
					self.VM_INSPECT_START = getfenv()[replace.act_primary_vm_inspect_start]
				end

				if replace.act_primary_vm_inspect_idle then
					self.VM_INSPECT_IDLE = getfenv()[replace.act_primary_vm_inspect_idle]
				end
			else
				
				local hold = self.HoldType
				self.VM_DRAW			= getfenv()["ACT_"..hold.."_VM_DRAW"]
				self.VM_IDLE			= getfenv()["ACT_"..hold.."_VM_IDLE"] 
				self.VM_PRIMARYATTACK	= getfenv()["ACT_"..hold.."_VM_PRIMARYATTACK"]
				self.VM_SECONDARYATTACK	= getfenv()["ACT_"..hold.."_VM_SECONDARYATTACK"]
				 
				-- Special activities
				self.VM_CHARGE			= getfenv()["ACT_"..hold.."_VM_CHARGE"]
				self.VM_DRYFIRE			= getfenv()["ACT_"..hold.."_VM_DRYFIRE"]
				self.VM_IDLE_2			= getfenv()["ACT_"..hold.."_VM_IDLE_2"]
				self.VM_CHARGE_IDLE_3	= getfenv()["ACT_"..hold.."_VM_CHARGE_IDLE_3"]
				self.VM_IDLE_3			= getfenv()["ACT_"..hold.."_VM_IDLE_3"]
				self.VM_PULLBACK		= getfenv()["ACT_"..hold.."_VM_PULLBACK"]
				self.VM_PREFIRE			= getfenv()["ACT_"..hold.."_ATTACK_STAND_PREFIRE"]
				self.VM_POSTFIRE		= getfenv()["ACT_"..hold.."_ATTACK_STAND_POSTFIRE"]
				
				self.VM_INSPECT_START	= getfenv()["ACT_"..hold.."_VM_INSPECT_START"]
				self.VM_INSPECT_IDLE	= getfenv()["ACT_"..hold.."_VM_INSPECT_IDLE"]
				self.VM_INSPECT_END		= getfenv()["ACT_"..hold.."_VM_INSPECT_END"]
				self.VM_RELOAD_START	= getfenv()["ACT_"..hold.."_RELOAD_START"]
				self.VM_RELOAD	= getfenv()["ACT_"..hold.."_VM_RELOAD"] 
				self.VM_RELOAD_FINISH		= getfenv()["ACT_"..hold.."_RELOAD_FINISH"]
				 
				self.VM_HITLEFT		= getfenv()["ACT_"..hold.."_VM_HITLEFT"]
				self.VM_HITRIGHT		= getfenv()["ACT_"..hold.."_VM_HITRIGHT"]
				self.VM_HITCENTER		= getfenv()["ACT_"..hold.."_VM_HITCENTER"]
				self.VM_SWINGHARD		= getfenv()["ACT_"..hold.."_VM_SWINGHARD"]
				self.BACKSTAB_VM_UP		= getfenv()["ACT_"..hold.."_BACKSTAB_VM_UP"]
				self.BACKSTAB_VM_DOWN		= getfenv()["ACT_"..hold.."_BACKSTAB_VM_DOWN"]
			end

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

function SWEP:ResetInspect()

end

function SWEP:Inspect()
	if IsValid(self.CModel) then

		local t2 = self.Owner:GetProxyVar("CritTeam") 
		local s2 = self.Owner:GetProxyVar("CritStatus")
		self.CModel:SetProxyVar("CritTeam",t2)
		self.CModel:SetProxyVar("CritStatus",s2)

	end
	if (self:Ammo1() < 1 and self:Clip1() < 1 and self.Primary.ClipSize > 0 and self.AmmoType != nil || self:Ammo1() < 1 and self.AmmoType != nil) then
		if (CurTime() > self:GetNextPrimaryFire()) then
			if (self.HoldType == "PRIMARY") then
				if (IsValid(self.Owner:GetWeapons()[2])) then
					self.Owner:SelectWeapon(self.Owner:GetWeapons()[2]:GetClass())
				end
			elseif ((self.HoldType == "SECONDARY" or (self:GetClass() == "tf_weapon_jar" or self:GetClass() == "tf_weapon_jar_milk")) and self.Owner:GetPlayerClass() != "medic") then
				if (IsValid(self.Owner:GetWeapons()[3])) then
					self.Owner:SelectWeapon(self.Owner:GetWeapons()[3]:GetClass())
				end
			end
		end
	end
	self:InspectAnimCheck()
end	

--[[function SWEP:Inspect()
	self:InspectAnimCheck()
	
	if (self:GetOwner():GetMoveType()==MOVETYPE_NOCLIP) and inspecting == true and GetConVar("tf_haltinspect"):GetBool() or (self:GetOwner():GetMoveType()==MOVETYPE_NOCLIP) and inspecting_post == true and GetConVar("tf_haltinspect"):GetBool() then
		self:SendWeaponAnimEx( self.VM_IDLE ) 
		self:StopTimers()
		return false
	end

	if ( self:GetOwner():GetNWString("inspect") == "inspecting_start" and inspecting == false and GetConVar("tf_caninspect"):GetBool() ) then
		inspecting = true
		self:SendWeaponAnimEx( self.VM_INSPECT_START )
		timer.Create("StartInspection", self:SequenceDuration(), 1, function()self:SendWeaponAnimEx( self.VM_INSPECT_IDLE ) end )
	end
	
	if ( self:GetOwner():GetNWString("inspect") == "inspecting_released" and inspecting_post == false and GetConVar("tf_caninspect"):GetBool() ) then
		inspecting_post = true
		timer.Create("EndInspection", self:SequenceDuration(), 1, function()self:SendWeaponAnimEx( self.VM_INSPECT_END )
			timer.Create("PostInspection", self:SequenceDuration(), 1, function()
				self:SendWeaponAnimEx( self.VM_IDLE )
				inspecting_post = false
				inspecting = false 
			end )
		end)
	end
end]]
  
function SWEP:Holster()
	if (IsValid(self.Owner) and IsValid(self.Owner:GetViewModel())) then
		self.Owner:GetViewModel():SetMaterial("")
	end
	self:StopTimers()
	if IsValid(self.Owner) then
		if (self.MarkForDeath) then
			self.Owner:RemovePlayerState(PLAYERSTATE_MARKED, true)
		end
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
	
	self.NextIdle = nil
	self.NextReloadStart = nil
	self.NextReload = nil
	self.NextReload2 = nil
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
	if (IsValid(self:GetOwner())) then
		local VModel = self:GetOwner():GetViewModel()
		if (IsValid(VModel)) then
			VModel:SetMaterial("")
		end
	end
	--self:Holster() 
end

function SWEP:CanPrimaryAttack() 
	if (self.Owner:GetNWBool("Bonked")) then return false end
	if (((self.Primary.ClipSize == -1 and self:Ammo1() > 0) or self:Clip1() > 0) and self.Owner:GetNWBool("Bonked",false) == false) then
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
	self.Reloading = false
	self.NextReload = nil
	self.NextReload2 = nil
	self.NextReloadStart = nil
	return true
end

function SWEP:RustyBulletHole()
	--print(self.ProjectileShootOffset)
	if self.Base ~= "tf_weapon_melee_base" and self.GetClass ~= "tf_weapon_builder" and not self.IsPDA and self.ProjectileShootOffset == Vector(0,0,0) or self.ProjectileShootOffset == Vector(3,8,-5) and self.IsDeployed == true then
		--self:ShootBullet(0, self.BulletsPerShot, self.BulletSpread)
		if (self.Owner:GetEyeTrace()) then  
			if (self.Owner:GetEyeTrace().Entity) then
				local ent = self.Owner:GetEyeTrace().Entity
				if (ent:IsPlayer() and string.find(ent:GetModel(),"/bot_")) then 
					return
				end
			end
		end
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
			self.NextReload2 = nil
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
		if self.Owner:GetInfoNum("tf_autoreload", 1) == 1 || self.Owner:IsBot() then
			if self.Owner:Alive() then
				if self.Primary.ClipSize >= 0 and self:Ammo1() > 0 and not self:CanPrimaryAttack() then
				--MsgFN("Deployed with empty clip, reloading")
					self:Reload()
				end
			end
		end
	end
end

function SWEP:Reload()
	self:StopTimers()
	if CLIENT and _G.NOCLIENTRELOAD then return end
	
	if self.NextReloadStart or self.NextReload or self.Reloading then return end
	if CurTime() < self.Primary.Delay then return end
	
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
				--self:SendWeaponAnimEx(ACT_RELOAD_START)
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
					self.NextReloadStart = CurTime() + (self.ReloadTime - 0.2 or self.ReloadStartTime ) 
					if (self:Clip1() == 0) then
						self.Reloading = true
					end
					
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
					if (self:Clip1() == 0) then
						self.Reloading = true
					end
					if self.FastReloadTime and self.OldReloadTime then  
						if (!self.ReloadTimeMultiplier) then
							self.NextReloadStart = CurTime() + self:SequenceDuration() / self.FastReloadTime
						else
							self.NextReloadStart = CurTime() + self:SequenceDuration() / self.FastReloadTime / self.ReloadTimeMultiplier
						end
					else
						self.NextReloadStart = CurTime() + self:SequenceDuration()
					end
					self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
				end
			else
				if SERVER then
					self:SendWeaponAnimEx(self.VM_RELOAD)
				end
				self.Owner:SetAnimation(PLAYER_RELOAD)
				if (!self.Owner:KeyDown(IN_ATTACK)) then
					if self.FastReloadTime and self.OldReloadTime then  
						if (!self.ReloadTimeMultiplier) then
							self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() / self.FastReloadTime)
						else
							
							self:SetNextPrimaryFire(CurTime() + self:SequenceDuration() / self.FastReloadTime / self.ReloadTimeMultiplier)
						end
					else
						
						self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
					end
				end
				
				if self.FastReloadTime and self.OldReloadTime then  
					if (!self.ReloadTimeMultiplier) then
						
						self.Owner:GetViewModel():SetPlaybackRate(1.0 / self.FastReloadTime)
						self.ReloadTime = self.OldReloadTime * self.FastReloadTime
						self.NextIdle = CurTime() + self.ReloadTime
						self.NextReload = self.NextIdle
						self.NextReload2 = self.ReloadTime
					
					else
					
						self.Owner:GetViewModel():SetPlaybackRate(1.0 / self.FastReloadTime / self.ReloadTimeMultiplier)
						self.ReloadTime = self.OldReloadTime * (self.FastReloadTime * self.ReloadTimeMultiplier)
						self.NextIdle = CurTime() + self.ReloadTime
						self.NextReload = self.NextIdle
						self.NextReload2 = CurTime() + self.ReloadTime
						
					end
				elseif !self.FastReloadTime and self.ReloadTimeMultiplier then  
					self.Owner:GetViewModel():SetPlaybackRate(1.0 / self.ReloadTimeMultiplier)
					if (!self.OriginalReloadTime) then
						self.OriginalReloadTime = self.ReloadTime
					end
					self.NextIdle = self.OriginalReloadTime * self.ReloadTimeMultiplier
					self.NextReload = self.NextIdle
					self.NextReload2 = CurTime() + self.ReloadTime
				else
					self.NextIdle = CurTime() + (self.ReloadTime or self:SequenceDuration())
					self.NextReload = self.NextIdle
					self.NextReload2 = CurTime() + self.ReloadTime
				end
				
				self.AmmoAdded = math.min(self.Primary.ClipSize - ammo, available)
				self.Reloading = true
				
				if self.ReloadSound and SERVER then
					umsg.Start("PlayTFWeaponWorldReload")
						umsg.Entity(self)
					umsg.End()
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
	self:Inspect()
	self:InspectAnimCheck()
	if (((self.NextReload and self.NextReload>=CurTime()) or ((self.NextReloadStart and self.NextReloadStart>=CurTime()) or self.Reloading)) and self.ReloadSingle) then
	
		if self.FastReloadTime and SERVER then  
			if (!self.ReloadTimeMultiplier) then
			
				self.Owner:GetViewModel():SetPlaybackRate(1.0 / self.FastReloadTime)
				self.ReloadTime = self.FastReloadTime
			
			else
			
				self.Owner:GetViewModel():SetPlaybackRate(1.0 / self.FastReloadTime / self.ReloadTimeMultiplier)
				self.ReloadTime = self.FastReloadTime / self.ReloadTimeMultiplier
				
			end
		end
		
		if !self.FastReloadTime and self.ReloadTimeMultiplier and SERVER and self.ReloadTime then  
			self.Owner:GetViewModel():SetPlaybackRate(1.0 / self.ReloadTimeMultiplier)
			if (!self.OriginalReloadTime) then 
				self.OriginalReloadTime = self.ReloadTime
			end
			self.ReloadTime = self.OriginalReloadTime * self.ReloadTimeMultiplier
		end
			
	end
	if CLIENT then
		if (self:GetItemData().item_name) then
			self.PrintName = self:GetItemData().name
		end
		if IsValid(self.CModel) then
			self.CModel:DrawModel()
			self.CModel:SetSkin(self.WeaponSkin or self.Owner:GetSkin())
		end
		if IsValid(self.CModel) then
	
			local t2 = self.Owner:GetProxyVar("CritTeam") 
			local s2 = self.Owner:GetProxyVar("CritStatus")
			self.CModel:SetProxyVar("CritTeam",t2)
			self.CModel:SetProxyVar("CritStatus",s2)
	
		end
		if IsValid(self.WModel) then
			self.WModel:DrawModel()
			local skin = self.WeaponSkin or self.Owner:GetSkin()
			if (self.WModel:GetSkin() != skin) then
				self.WModel:SetSkin(skin)	
			end
			if (self.WModel:GetMaterial() != self.WeaponMaterial) then
				self.WModel:SetMaterial(self.WeaponMaterial)
			end
		end
		if IsValid(self.ExtraCModel) then
			self.ExtraCModel:DrawModel()
			self.ExtraCModel:SetParent(self.CModel)
			self.CModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
		end
	end
	
	local hold = self.HoldType
	
	
	if (!string.StartWith(self.Owner:GetModel(),"models/infected/")) then
		if (self:GetClass() == "tf_weapon_shotgun") then
			if (self.Owner:GetPlayerClass() == "soldier"
			|| self.Owner:GetPlayerClass() == "heavy"
			|| self.Owner:GetPlayerClass() == "pyro") then
				self.VM_DRAW = ACT_SECONDARY_VM_DRAW	
				self.VM_IDLE = ACT_SECONDARY_VM_IDLE
				self.VM_PRIMARYATTACK = ACT_SECONDARY_VM_PRIMARYATTACK
				self.VM_RELOAD_START = ACT_SECONDARY_RELOAD_START
				self.VM_RELOAD = ACT_SECONDARY_VM_RELOAD
				self.VM_RELOAD_FINISH = ACT_SECONDARY_RELOAD_FINISH
				self.Slot				= 1
				self:SetHoldType("SECONDARY")
			elseif (self.Owner:GetPlayerClass() == "scout"
			|| self.Owner:GetPlayerClass() == "engineer") then
				self.VM_DRAW = ACT_PRIMARY_VM_DRAW	
				self.VM_IDLE = ACT_PRIMARY_VM_IDLE
				self.VM_PRIMARYATTACK = ACT_PRIMARY_VM_PRIMARYATTACK
				self.VM_RELOAD_START = ACT_PRIMARY_RELOAD_START
				self.VM_RELOAD = ACT_PRIMARY_VM_RELOAD
				self.VM_RELOAD_FINISH = ACT_PRIMARY_RELOAD_FINISH
				self.Slot				= 0
				self:SetHoldType("PRIMARY")
			else
				self.VM_DRAW = ACT_SECONDARY_VM_DRAW	
				self.VM_IDLE = ACT_SECONDARY_VM_IDLE
				self.VM_PRIMARYATTACK = ACT_SECONDARY_VM_PRIMARYATTACK
				self.VM_RELOAD_START = ACT_SECONDARY_RELOAD_START
				self.VM_RELOAD = ACT_SECONDARY_VM_RELOAD
				self.VM_RELOAD_FINISH = ACT_SECONDARY_RELOAD_FINISH
				self.Slot				= 1
				self:SetHoldType("SECONDARY")
			end
		elseif (self:GetClass() == "tf_weapon_sword" and self.HoldType != "MELEE_ALLCLASS" || self:GetClass() == "tf_weapon_bat_wood" || (self:GetClass() == "tf_weapon_katana" and self.Owner:GetPlayerClass() == "demoman")) then
			self.VM_DRAW = ACT_VM_DRAW_SPECIAL
			self.VM_IDLE = ACT_VM_IDLE_SPECIAL
			self.VM_HITCENTER = ACT_VM_HITCENTER_SPECIAL
			self.VM_SWINGHARD = ACT_VM_SWINGHARD_SPECIAL
		elseif (self:GetClass() == "tf_weapon_handgun_scout" ) then
			
			self.VM_DRAW = ACT_SECONDARY_VM_DRAW_2
			self.VM_IDLE = ACT_SECONDARY_VM_IDLE_2
			self.VM_PRIMARYATTACK = ACT_SECONDARY_VM_PRIMARYATTACK_2
			self.VM_RELOAD = ACT_SECONDARY_VM_RELOAD_2
			self.VM_INSPECT_START = ACT_PRIMARY_ALT1_VM_INSPECT_START
			self.VM_INSPECT_IDLE = ACT_PRIMARY_ALT1_VM_INSPECT_IDLE
			self.VM_INSPECT_END = ACT_PRIMARY_ALT1_VM_INSPECT_END

		elseif self:GetItemData().model_player == "models/weapons/c_models/c_breadmonster_sapper/c_breadmonster_sapper.mdl" then
			self.VM_DRAW = ACT_BREADSAPPER_VM_DRAW
			self.VM_IDLE = ACT_BREADSAPPER_VM_IDLE
		elseif self:GetItemData().image_inventory == "backpack/weapons/v_models/v_fist_heavy" then			
			if self.Owner:GetPlayerClass() == "charger" then
				self.VM_IDLE = ACT_VM_IDLE
				self.VM_DRAW = ACT_VM_DRAW
				self.VM_HITLEFT = ACT_VM_PRIMARYATTACK
				self.VM_HITRIGHT = ACT_VM_PRIMARYATTACK
				self.VM_PRIMARYATTACK = ACT_VM_PRIMARYATTACK
				self.VM_SWINGHARD = ACT_VM_PRIMARYATTACK
			elseif self.Owner:GetPlayerClass() == "tank_l4d" then
				self.VM_IDLE = ACT_VM_IDLE
				self.VM_DRAW = self.Owner:GetViewModel():GetSequenceActivity(self.Owner:GetViewModel():LookupSequence("draw"))
				self.VM_HITLEFT = ACT_VM_PRIMARYATTACK
				self.VM_HITRIGHT = ACT_VM_PRIMARYATTACK
				self.VM_PRIMARYATTACK = ACT_VM_PRIMARYATTACK
				self.VM_SWINGHARD = ACT_VM_PRIMARYATTACK
			elseif self.Owner:GetPlayerClass() == "hunter" then
				self.VM_IDLE = ACT_VM_IDLE
				self.VM_DRAW = ACT_VM_DRAW
				self.VM_HITLEFT = ACT_VM_PRIMARYATTACK
				self.VM_HITRIGHT = ACT_VM_PRIMARYATTACK
				self.VM_PRIMARYATTACK = ACT_VM_PRIMARYATTACK
				self.VM_SWINGHARD = ACT_VM_PRIMARYATTACK
			elseif self.Owner:GetPlayerClass() == "boomer" || self.Owner:GetPlayerClass() == "boomette" then
				self.VM_IDLE = ACT_VM_IDLE
				self.VM_DRAW = ACT_VM_DEPLOY
				self.VM_HITLEFT = ACT_VM_PRIMARYATTACK
				self.VM_HITRIGHT = ACT_VM_PRIMARYATTACK
				self.VM_PRIMARYATTACK = ACT_VM_PRIMARYATTACK
				self.VM_SWINGHARD = ACT_VM_PRIMARYATTACK
			else
				self.VM_IDLE = ACT_FISTS_VM_IDLE
				self.VM_DRAW = ACT_FISTS_VM_DRAW
				self.VM_HITLEFT = ACT_FISTS_VM_HITLEFT
				self.VM_HITRIGHT = ACT_FISTS_VM_HITRIGHT
				self.VM_SWINGHARD = ACT_FISTS_VM_SWINGHARD
			end
			self.HoldType = "MELEE"
		else
			if (hold == "PRIMARY2") then
				self.VM_DRAW			= _G["ACT_PRIMARY_VM_DRAW"]
				self.VM_IDLE			= _G["ACT_PRIMARY_VM_IDLE"]
				self.VM_PRIMARYATTACK	= _G["ACT_PRIMARY_VM_PRIMARYATTACK"]
				self.VM_SECONDARYATTACK	= _G["ACT_PRIMARY_VM_SECONDARYATTACK"]
				self.VM_RELOAD			= _G["ACT_PRIMARY_VM_RELOAD_3"]
				self.VM_RELOAD_START	= _G["ACT_PRIMARY_RELOAD_START_3"]
				self.VM_RELOAD_FINISH	= _G["ACT_PRIMARY_RELOAD_FINISH_3"]
				
				-- Special activities
				self.VM_CHARGE			= _G["ACT_PRIMARY_VM_CHARGE"]
				self.VM_DRYFIRE			= _G["ACT_PRIMARY_VM_DRYFIRE"]
				self.VM_IDLE_2			= _G["ACT_PRIMARY_VM_IDLE_2"]
				self.VM_CHARGE_IDLE_3	= _G["ACT_PRIMARY_VM_CHARGE_IDLE_3"]
				self.VM_IDLE_3			= _G["ACT_PRIMARY_VM_IDLE_3"]
				self.VM_PULLBACK		= _G["ACT_PRIMARY_VM_PULLBACK"]
				self.VM_PREFIRE			= _G["ACT_PRIMARY_ATTACK_STAND_PREFIRE"]
				self.VM_POSTFIRE		= _G["ACT_PRIMARY_ATTACK_STAND_POSTFIRE"]
				
				self.VM_INSPECT_START	= _G["ACT_PRIMARY_VM_INSPECT_START"]
				self.VM_INSPECT_IDLE	= _G["ACT_PRIMARY_VM_INSPECT_IDLE"]
				self.VM_INSPECT_END		= _G["ACT_PRIMARY_VM_INSPECT_END"]
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
			if (self.Owner:GetPlayerClass() == "soldier"
			|| self.Owner:GetPlayerClass() == "heavy"
			|| self.Owner:GetPlayerClass() == "pyro") then
				self.item_slot = "SECONDARY"
				self.VM_DRAW = ACT_SECONDARY_VM_DRAW	
				self.VM_IDLE = ACT_SECONDARY_VM_IDLE
				self.VM_PRIMARYATTACK = ACT_SECONDARY_VM_PRIMARYATTACK
				self.VM_RELOAD_START = ACT_SECONDARY_RELOAD_START
				self.VM_RELOAD = ACT_SECONDARY_VM_RELOAD
				self.VM_RELOAD_FINISH = ACT_SECONDARY_RELOAD_FINISH
				self.Slot				= 1
				self.HoldType = "SECONDARY"
				self.Primary.Ammo			= TF_SECONDARY
				self:SetHoldType("SECONDARY")
			elseif (self.Owner:GetPlayerClass() == "scout"
			|| self.Owner:GetPlayerClass() == "engineer") then
				self.VM_DRAW = ACT_PRIMARY_VM_DRAW	
				self.VM_IDLE = ACT_PRIMARY_VM_IDLE
				self.VM_PRIMARYATTACK = ACT_PRIMARY_VM_PRIMARYATTACK
				self.VM_RELOAD_START = ACT_PRIMARY_RELOAD_START
				self.VM_RELOAD = ACT_PRIMARY_VM_RELOAD
				self.VM_RELOAD_FINISH = ACT_PRIMARY_RELOAD_FINISH
				self.Slot				= 0
				self.Primary.Ammo			= TF_PRIMARY
				self.HoldType = "PRIMARY"
				self:SetHoldType("PRIMARY")
			else
				self.VM_DRAW = ACT_SECONDARY_VM_DRAW	
				self.VM_IDLE = ACT_SECONDARY_VM_IDLE
				self.VM_PRIMARYATTACK = ACT_SECONDARY_VM_PRIMARYATTACK
				self.VM_RELOAD_START = ACT_SECONDARY_RELOAD_START
				self.VM_RELOAD = ACT_SECONDARY_VM_RELOAD
				self.VM_RELOAD_FINISH = ACT_SECONDARY_RELOAD_FINISH
				self.Slot				= 1
				self.Primary.Ammo			= TF_SECONDARY
				self.HoldType = "PRIMARY"
				self:SetHoldType("PRIMARY")
			end
		end
	end
	local wmodel = self:GetItemData().model_player or self.WorldModel
	if (self.Owner:GetNWBool("NoWeapon")) then
		--self.WorldModel = "models/empty.mdl"
	else
		--self.WorldModel = wmodel;
	end
	if (self.Owner:IsHL2()) then
		self:SetWeaponHoldType(self.HoldTypeHL2 or self.HoldType)
	else
		self:SetWeaponHoldType(self.HoldType)
	end
	self:AddFlags(EF_NOSHADOW)
	if (self.Owner:GetPlayerClass() == "pyro" and self:GetClass() == "tf_weapon_rocketlauncher_qrl") then
		self:SetHoldType("ITEM1")
		self.HoldType = "ITEM1"
	end
	if self:GetItemData().model_player == "models/weapons/c_models/c_breadmonster_sapper/c_breadmonster_sapper.mdl" then
		self.VM_DRAW = ACT_BREADSAPPER_VM_DRAW
		self.VM_IDLE = ACT_BREADSAPPER_VM_IDLE
	end
	local vm = self.Owner:GetViewModel()
	if (self.Owner:GetPlayerClass() != "combinesoldier") then
		if CLIENT then 
			if (self:GetClass() != "tf_weapon_pda_spy") then
				if IsValid(self.CModel) then
					self.CModel:SetModel(wmodel)
					self.CModel:SetNoDraw(true)
					self.CModel:DrawModel()
					self.CModel:SetSkin(self.WeaponSkin or self:GetOwner():GetSkin())
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
					self.CModel:SetSkin(self.WeaponSkin or self:GetOwner():GetSkin())
				end
			end
		end
	end
	if (IsValid(self.Owner:GetHands())) then
		if (self.Owner:Team() == TEAM_BLU) then
			self.Owner:GetHands():SetSkin( 1 )
		elseif (self.Owner:Team() == TF_TEAM_PVE_INVADERS) then
			self.Owner:GetHands():SetSkin( 1 )
		else 
			self.Owner:GetHands():SetSkin( 0 )
		end
	end
	self:InspectAnimCheck() 
	if (self.Owner:GetPlayerClass() == "superheavyweightchamp") then
		self.Primary.Delay = 1.0 * 0.6
	end
	if self.NextReload2 and CurTime()>=self.NextReload2 then
		self:SetClip1(self:Clip1() + self.AmmoAdded)
		if (self:GetClass() != "tf_weapon_particle_launcher") then
			if not self.ReloadSingle and self.ReloadDiscardClip then
				self.Owner:RemoveAmmo(self.Primary.ClipSize, self.Primary.Ammo, false)
			else
				self.Owner:RemoveAmmo(self.AmmoAdded, self.Primary.Ammo, false)
			end
		end
		self.NextReload2 = nil
	end
	if self.NextReload and CurTime()>=self.NextReload then
		//self:SetClip1(self:Clip1() + self.AmmoAdded)
		
		self.Delay = -1
		self.QuickDelay = -1
		
		if self:Clip1()>=self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo)==0 then
			-- Stop reloading
			self.Reloading = false
			self.CanInspect = true
			if self.ReloadSingle then
				--self:SendWeaponAnimEx(ACT_RELOAD_FINISH)
				
			if (self:GetClass() == "tf_weapon_grenadelauncher" or self:GetClass() == "tf_weapon_cannon") then
				if CLIENT then
					self.CModel:SetBodygroup(1,0)
				end
			end
				if SERVER then
					self:SendWeaponAnimEx(self.VM_RELOAD_FINISH)
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
				end
				self.NextIdle = CurTime() + self:SequenceDuration() 
			else
				
				local idleAnim = self.VM_IDLE or ACT_VM_IDLE
				self:SendWeaponAnimEx(idleAnim)
				self.NextIdle = nil
			end
			self.NextReload = nil
		else
			if self.FastReloadTime then  
				self.ReloadTime = self.FastReloadTime
			end
			if SERVER then
			self:SendWeaponAnimEx(self.VM_RELOAD)
			end
			self.NextReload2 = CurTime() + self.ReloadTime
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
			if self.ReloadTime == 1.1 then 
				if self:GetItemData().model_player == "models/weapons/c_models/c_dumpster_device/c_dumpster_device.mdl" then
					if CLIENT then
						self.Owner:EmitSound("Weapon_DumpsterRocket.Reload")
					end
				end
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
		//self:SetClip1(self:Clip1() + self.AmmoAdded)
		if self.FastReloadTime then  
			self.ReloadTime = self.FastReloadTime
		end
		if SERVER then
		self:SendWeaponAnimEx(self.VM_RELOAD)
		end
		if self.FastReloadTime then  
			self.Owner:GetViewModel():SetPlaybackRate(1.0 / self.FastReloadTime)
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
		if self.ReloadTime == 1.1 then 
			if self:GetItemData().model_player == "models/weapons/c_models/c_dumpster_device/c_dumpster_device.mdl" then
				if CLIENT then
					self.Owner:EmitSound("Weapon_DumpsterRocket.Reload")
				end
			end
		end
		self.NextReload = CurTime() + (self.ReloadTime)
		self.NextReload2 = CurTime() + (self.ReloadTime-(self.Primary.Delay*0.6))
		
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
		
		self.NextReloadStart = nil
	end
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
			--timer.Simple(0.1, function() self:SendWeaponAnimEx(self.VM_DRAW) end)
			self.NextReplayDeployAnim = nil
		end
	end
		if SERVER and self.NextIdle and CurTime()>=self.NextIdle and !self.Owner:KeyDown(IN_ATTACK) and !self.Owner:KeyDown(IN_ATTACK2) then
			local idleAnim = self.VM_IDLE or ACT_VM_IDLE
			self:SendWeaponAnimEx(idleAnim)
			if SERVER then
				self.NextIdle = CurTime() + self:SequenceDuration(self:SelectWeightedSequence(idleAnim))
			end
		end
		if self and SERVER then
			if self.IsDeployed and self.Owner:GetInfoNum("tf_autoreload", 1) == 1 or self.Owner:IsBot() then
				if self.Owner:Alive() then
					if (CurTime() > self:GetNextPrimaryFire() and CurTime() > self:GetNextSecondaryFire()) then
						self:CheckAutoReload()
					end
				end
			end
		end
	if not self.IsDeployed and self.NextDeployed and CurTime()>=self.NextDeployed and self:GetClass() != "tf_weapon_grapplinghook" then
		self.IsDeployed = true
		self.CanInspect = true
	end

	if not self.IsDeployed and self:GetClass() == "tf_weapon_grapplinghook" then

		self.IsDeployed = true
		self.CanInspect = true
		
	end
	if self.IsDeployed then
		self.CanInspect = true
	end

	//print(deployspeed)
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
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
