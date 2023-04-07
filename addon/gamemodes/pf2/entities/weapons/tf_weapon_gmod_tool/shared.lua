SWEP.Base				= "gmod_tool"

SWEP.ViewModel			= "models/weapons/v_models/v_revolver_spy.mdl"
SWEP.WorldModel			= "models/weapons/c_models/c_revolver/c_revolver.mdl"
SWEP.ShootSound = Sound("Weapon_Revolver.Single")
SWEP.Primary.Automatic = true

--==================================================================
-- FIRSTPERSON ANIMATIONS
--==================================================================

SWEP.VM_DRAW = ACT_VM_DRAW
SWEP.VM_IDLE = ACT_VM_IDLE
SWEP.VM_PRIMARYATTACK = ACT_VM_PRIMARYATTACK
SWEP.VM_SECONDARYATTACK = ACT_VM_SECONDARYATTACK
SWEP.VM_RELOAD = ACT_VM_RELOAD
SWEP.VM_RELOAD_START = ACT_RELOAD_START
SWEP.VM_RELOAD_FINISH = ACT_RELOAD_FINISH
SWEP.HoldType = "SECONDARY"

local ActivityNameTranslate = {
	ACT_VM_DRAW				= "VM_DRAW",
	ACT_VM_IDLE				= "VM_IDLE",
	ACT_VM_PRIMARYATTACK	= "VM_PRIMARYATTACK",
	ACT_VM_SECONDARYATTACK	= "VM_SECONDARYATTACK",
	ACT_VM_RELOAD			= "VM_RELOAD",
	ACT_RELOAD_START		= "VM_RELOAD_START",
	ACT_RELOAD_FINISH		= "VM_RELOAD_FINISH",
	ACT_VM_HITLEFT			= "VM_HITLEFT",
	ACT_VM_HITRIGHT			= "VM_HITRIGHT",
	ACT_VM_HITCENTER		= "VM_HITCENTER",
	ACT_VM_SWINGHARD		= "VM_SWINGHARD",
}

local ActIndex = {
	[ "pistol" ]		= ACT_HL2MP_IDLE_PISTOL,
	[ "smg" ]			= ACT_HL2MP_IDLE_SMG1,
	[ "grenade" ]		= ACT_HL2MP_IDLE_GRENADE,
	[ "ar2" ]			= ACT_HL2MP_IDLE_AR2,
	[ "shotgun" ]		= ACT_HL2MP_IDLE_SHOTGUN,
	[ "rpg" ]			= ACT_HL2MP_IDLE_RPG,
	[ "physgun" ]		= ACT_HL2MP_IDLE_PHYSGUN,
	[ "crossbow" ]		= ACT_HL2MP_IDLE_CROSSBOW,
	[ "melee" ]			= ACT_HL2MP_IDLE_MELEE,
	[ "slam" ]			= ACT_HL2MP_IDLE_SLAM,
	[ "normal" ]		= ACT_HL2MP_IDLE,
	[ "fist" ]			= ACT_HL2MP_IDLE_FIST,
	[ "melee2" ]		= ACT_HL2MP_IDLE_MELEE2,
	[ "passive" ]		= ACT_HL2MP_IDLE_PASSIVE,
	[ "knife" ]			= ACT_HL2MP_IDLE_KNIFE,
	[ "duel" ]			= ACT_HL2MP_IDLE_DUEL,
	[ "camera" ]		= ACT_HL2MP_IDLE_CAMERA,
	[ "magic" ]			= ACT_HL2MP_IDLE_MAGIC,
	[ "revolver" ]		= ACT_HL2MP_IDLE_REVOLVER
}

function SWEP:SetupCModelActivities(item, noreplace)
	tf_util.ReadActivitiesFromModel(self)
	
	if item then
		local hold = self.HoldType
		--MsgN(Format("SetupCModelActivities %s", tostring(self)))
		if (hold == "PRIMARY2") then
			self.VM_DRAW			= _G["ACT_PRIMARY_VM_DRAW"]
			self.VM_IDLE			= _G["ACT_PRIMARY_VM_IDLE"]
			self.VM_PRIMARYATTACK	= _G["ACT_PRIMARY_VM_PRIMARYATTACK"]
			self.VM_SECONDARYATTACK	= _G["ACT_PRIMARY_VM_SECONDARYATTACK"]
			self.VM_RELOAD			= _G["ACT_PRIMARY_VM_RELOAD"]
			self.VM_RELOAD_START	= _G["ACT_PRIMARY_RELOAD_START"]
			self.VM_RELOAD_FINISH	= _G["ACT_PRIMARY_RELOAD_FINISH"]
			
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
			self.VM_INSPECT_GND		= _G["ACT_PRIMARY_VM_INSPECT_GND"]
		else
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
			
			self.VM_INSPECT_START	= _G["ACT_"..hold.."_VM_INSPECT_START"]
			self.VM_INSPECT_IDLE	= _G["ACT_"..hold.."_VM_INSPECT_IDLE"]
			self.VM_INSPECT_GND		= _G["ACT_"..hold.."_VM_INSPECT_GND"]
		end
		
		self.VM_HITLEFT			= ACT_VM_HITLEFT
		self.VM_HITRIGHT		= ACT_VM_HITRIGHT
		
		-- those melee activities are just so weird, sometimes it's ACT_VM_HITCENTER, sometimes it's ACT_MELEE_VM_HITCENTER
		if self:SelectWeightedSequence(ACT_VM_HITCENTER) < 0 then
			self.VM_HITCENTER		= _G["ACT_"..hold.."_VM_HITCENTER"] or ACT_VM_HITCENTER
			self.VM_SWINGHARD		= _G["ACT_"..hold.."_VM_SWINGHARD"] or ACT_VM_SWINGHARD
		else
			self.VM_HITCENTER		= ACT_VM_HITCENTER
			self.VM_SWINGHARD		= ACT_VM_SWINGHARD
		end
	else
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
	end
	
	if self.UsesSpecialAnimations then
		self.VM_DRAW = ACT_VM_DRAW_SPECIAL
		self.VM_IDLE = ACT_VM_IDLE_SPECIAL
		--self.VM_HITLEFT = ACT_VM_HITLEFT_SPECIAL
		--self.VM_HITRIGHT = ACT_VM_HITRIGHT_SPECIAL
		self.VM_HITCENTER = ACT_VM_HITCENTER_SPECIAL
		self.VM_SWINGHARD = ACT_VM_SWINGHARD_SPECIAL
	end
	
	if not noreplace then
		local visuals = self:GetVisuals()
		if visuals and visuals.animations then
			for act,rep in pairs(visuals.animations) do
				if ActivityNameTranslate[act] then
					self[ActivityNameTranslate[act]] = _G[rep]
				end
			end
		end
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
		print(anim)
		local s = self.Owner:GetViewModel():LookupSequence(anim)
		self:SetSequence(s)
		self.Owner:GetViewModel():ResetSequence(s)
	end
end

--==================================================================
-- THIRDPERSON ANIMATIONS
--==================================================================

function SWEP:SetWeaponHoldType(t)
	for k, v in pairs(player.GetAll()) do
		if v == self.Owner then		
		if v:IsHL2() then 	
		t = string.lower( t )
		local index = ActIndex[ t ]

		if ( index == nil ) then
			Msg( "SWEP:SetWeaponHoldType - ActIndex[ \"" .. t .. "\" ] isn't set! (defaulting to normal)\n" )
			t = "normal"
			index = ActIndex[ t ]
		end

		self.ActivityTranslate = {}
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= index
		self.ActivityTranslate[ ACT_MP_WALK ]						= index + 1
		self.ActivityTranslate[ ACT_MP_RUN ]						= index + 2
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= index + 3
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= index + 4
		self.ActivityTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index + 5
		self.ActivityTranslate[ ACT_MP_RELOAD_STAND ]				= index + 6
		self.ActivityTranslate[ ACT_MP_RELOAD_CROUCH ]				= index + 6
		self.ActivityTranslate[ ACT_MP_JUMP ]						= index + 7
		self.ActivityTranslate[ ACT_RANGE_ATTACK1 ]					= index + 8
		self.ActivityTranslate[ ACT_MP_SWIM ]						= index + 9

		-- "normal" jump animation doesn't exist
		if ( t == "normal" ) then
			self.ActivityTranslate[ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
		end

		else	
	if IsValid(v) then
		tf_util.ReadActivitiesFromModel(self.Owner)
	end

	self.ActivityTranslate = {}
	self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_MP_STAND_"..t]
	self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_MP_RUN_"..t]
	if v:GetInfoNum("tf_robot",0) == 1 then
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_MP_STAND_"..t]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_MP_RUN_"..t]
		self.ActivityTranslate[ACT_MP_SWIM] 							= _G["ACT_MP_RUN_"..t]
	else
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_MP_CROUCH_"..t]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_MP_CROUCHWALK_"..t]
		self.ActivityTranslate[ACT_MP_SWIM] 							= _G["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_AIRWALK] 							= _G["ACT_MP_AIRWALK_"..t]
	end
	if v:GetPlayerClass() == "combinesoldier" and v:GetActiveWeapon():GetClass() != "tf_weapon_trenchknife" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE_ANGRY"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN_AIM_RIFLE"]
		self.ActivityTranslate[ACT_MP_WALK] 								= _G["ACT_WALK_AIM_RIFLE"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_WALK_CROUCH_RIFLE"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= _G["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= _G["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "zombie" and v:GetActiveWeapon():GetClass() == "tf_weapon_fists"  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_WALK] 								= _G["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= _G["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= _G["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "headcrab" and v:GetActiveWeapon():GetClass() == "tf_weapon_fists"  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= _G["ACT_HL2MP_WALK_ZOMBIE_0"..math.random(1,6)]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_HL2MP_IDLE_CROUCH_ZOMBIE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_HL2MP_WALK_CROUCH_ZOMBIE_0"..math.random(1,5)]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= _G["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= _G["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "fastzombie" and v:GetActiveWeapon():GetClass() == "tf_weapon_fists"  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_INVALID"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_HL2MP_RUN_ZOMBIE_FAST"]
		self.ActivityTranslate[ACT_MP_WALK] 								= _G["ACT_HL2MP_RUN_ZOMBIE_FAST"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_HL2MP_IDLE_CROUCH_ZOMBIE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_HL2MP_WALK_CROUCH_ZOMBIE_0"..math.random(1,5)]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= _G["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= _G["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "poisonzombie" and v:GetActiveWeapon():GetClass() == "tf_weapon_fists"  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_WALK] 								= _G["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= _G["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= _G["ACT_RUN"] 
	end
	if v:GetPlayerClass() == "zombine" and v:GetActiveWeapon():GetClass() == "tf_weapon_fists" and self:GetHoldType() == "MELEE" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= _G["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= _G["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= _G["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "zombine" and v:GetActiveWeapon():GetClass() == "tf_weapon_fists" and self:GetHoldType() == "GRENADE" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= _G["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_ZOMBINE_GRENADE_WALK"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= _G["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= _G["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "combinesoldier" and v:GetActiveWeapon():GetClass() == "tf_weapon_trenchknife" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE_ANGRY_SMG1"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN_AIM_RIFLE"]
		self.ActivityTranslate[ACT_MP_WALK] 								= _G["ACT_WALK_AIM_RIFLE"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_WALK_CROUCH_RIFLE"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= _G["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= _G["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "combinesoldier" and v:GetActiveWeapon():GetClass() == "tf_weapon_tranqulizer" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE_ANGRY_SHOTGUN"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN_AIM_SHOTGUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= _G["ACT_WALK_AIM_SHOTGUN"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CROUCHIDLE_SHOTGUN"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_WALK_CROUCH_SHOTGUN"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SHOTGUN"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SHOTGUN"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= _G["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= _G["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "rebel" and v:GetActiveWeapon():GetClass() != "tf_weapon_trenchknife" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE_ANGRY_SMG1"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN_AIM_RIFLE"]
		self.ActivityTranslate[ACT_MP_WALK] 								= _G["ACT_WALK_ANGRY_RIFLE"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CROUCHIDLE_RIFLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_WALK_CROUCH_RIFLE"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= _G["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= _G["ACT_JUMP"]
	end		
	if v:GetPlayerClass() == "boomer" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_RUN_CROUCH"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= _G["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "boomette" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_RUN_CROUCH"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= _G["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "smoker" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_RUN_CROUCH"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= _G["ACT_CLIMB_UP"]
	end
	if !v:IsHL2() and !v:IsL4D() and self.Owner:GetMoveType() == MOVETYPE_LADDER then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= _G["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= _G["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= _G["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= _G["ACT_MP_SWIM_"..t]
	end	  
	if v:GetPlayerClass() == "hunter" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_RUN_CROUCH"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= _G["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "jockey" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_RUN_CROUCH"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= _G["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "witch" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= _G["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "charger" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN"] 
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_RUN_CROUCH"]

		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 		= _G["ACT_MP_ATTACK_STAND_"..t]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]		= _G["ACT_MP_ATTACK_CROUCH_"..t]
		self.ActivityTranslate[ACT_MP_ATTACK_SWIM_PRIMARYFIRE]			= _G["ACT_MP_ATTACK_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_TERROR_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_TERROR_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= _G["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "l4d_zombie" and self.Owner:GetMoveType() != MOVETYPE_LADDER then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK2"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK2"] 
		self.ActivityTranslate[ ACT_MP_SWIM ]						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= _G["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "boomer" and self.Owner:GetMoveType() == MOVETYPE_LADDER then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= _G["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "boomette" and self.Owner:GetMoveType() == MOVETYPE_LADDER then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= _G["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "tank" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_RUN_CROUCH"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= _G["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "tank" and self.Owner:GetMoveType() == MOVETYPE_LADDER then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= _G["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "l4d_zombie" and self.Owner:GetMoveType() == MOVETYPE_LADDER then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= _G["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= _G["ACT_CLIMB_UP"]
	end
	
	if v:GetPlayerClass() == "metrocop" and v:GetActiveWeapon():GetClass() == "tf_weapon_trenchknife" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE_ANGRY_SMG1"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN_AIM_RIFLE"]
		self.ActivityTranslate[ACT_MP_WALK] 								= _G["ACT_WALK_RIFLE"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CROUCHIDLE_RIFLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_WALK_CROUCH_RIFLE"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= _G["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= _G["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "metrocop" and v:GetActiveWeapon():GetClass() == "tf_weapon_pistol_m9" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE_ANGRY_PISTOL"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN_AIM_PISTOL"]
		self.ActivityTranslate[ACT_MP_WALK] 								= _G["ACT_WALK_PISTOL"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CROUCHIDLE_RIFLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_WALK_CROUCH_RIFLE"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= _G["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= _G["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "metrocop" and v:GetActiveWeapon():GetClass() == "tf_weapon_wrench_vagineer" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= _G["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_WALK_CROUCH"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= _G["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= _G["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "rebel" and v:GetActiveWeapon():GetClass() == "tf_weapon_trenchknife" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= _G["ACT_IDLE_ANGRY_SMG1"]
		self.ActivityTranslate[ACT_MP_RUN] 								= _G["ACT_RUN_RIFLE"]
		self.ActivityTranslate[ACT_MP_WALK] 								= _G["ACT_WALK_RIFLE"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= _G["ACT_CROUCHIDLE_RIFLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= _G["ACT_WALK_CROUCH_RIFLE"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= _G["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= _G["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= _G["ACT_JUMP"]
	end
	
	
	if t == "PRIMARY" then
		self.ActivityTranslate[ACT_MP_DEPLOYED_IDLE] 				= ACT_MP_DEPLOYED_IDLE
		self.ActivityTranslate[ACT_MP_DEPLOYED] 					= ACT_MP_DEPLOYED_PRIMARY
		self.ActivityTranslate[ACT_MP_CROUCH_DEPLOYED_IDLE] 		= ACT_MP_CROUCH_DEPLOYED_IDLE
		self.ActivityTranslate[ACT_MP_CROUCH_DEPLOYED] 				= ACT_MP_CROUCHWALK_DEPLOYED
		self.ActivityTranslate[ACT_MP_SWIM_DEPLOYED] 				= ACT_MP_SWIM_DEPLOYED_PRIMARY
	else
		self.ActivityTranslate[ACT_MP_DEPLOYED_IDLE] 				= _G["ACT_MP_DEPLOYED_IDLE_"..t]
		self.ActivityTranslate[ACT_MP_DEPLOYED] 					= _G["ACT_MP_DEPLOYED_"..t]
		self.ActivityTranslate[ACT_MP_CROUCH_DEPLOYED_IDLE] 		= _G["ACT_MP_CROUCH_DEPLOYED_IDLE_"..t]
		self.ActivityTranslate[ACT_MP_CROUCH_DEPLOYED] 				= _G["ACT_MP_CROUCHWALK_DEPLOYED_"..t]
		self.ActivityTranslate[ACT_MP_SWIM_DEPLOYED] 				= _G["ACT_MP_SWIM_DEPLOYED_"..t]
	end
	
	if t == "ITEM4" then
		self.ActivityTranslate[ ACT_MP_STAND_IDLE ]					= _G["ACT_MP_STAND_ITEM4"]
		self.ActivityTranslate[ ACT_MP_RUN ]						= _G["ACT_MP_RUN_ITEM4"]
		self.ActivityTranslate[ ACT_MP_CROUCH_IDLE ]				= _G["ACT_MP_CROUCH_ITEM4"]
		self.ActivityTranslate[ ACT_MP_CROUCHWALK ]					= _G["ACT_MP_CROUCHWALK_ITEM4"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= _G["ACT_MP_JUMP_START_ITEM4"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= _G["ACT_MP_SWIM_ITEM4"]
	end

	self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 		= _G["ACT_MP_ATTACK_STAND_"..t]
	self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]		= _G["ACT_MP_ATTACK_CROUCH_"..t]
	self.ActivityTranslate[ACT_MP_ATTACK_SWIM_PRIMARYFIRE]			= _G["ACT_MP_ATTACK_SWIM_"..t]
	
	self.ActivityTranslate[ACT_MP_ATTACK_STAND_SECONDARYFIRE] 		= _G["ACT_MP_ATTACK_STAND_"..t.."_SECONDARY"]
	self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_SECONDARYFIRE]		= _G["ACT_MP_ATTACK_CROUCH_"..t.."_SECONDARY"]
	self.ActivityTranslate[ACT_MP_ATTACK_SWIM_SECONDARYFIRE]		= _G["ACT_MP_ATTACK_SWIM_"..t.."_SECONDARY"]
	
	self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARY_DEPLOYED] 	= _G["ACT_MP_ATTACK_STAND_"..t.."_DEPLOYED"]
	self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARY_DEPLOYED] 	= _G["ACT_MP_ATTACK_CROUCH_"..t.."_DEPLOYED"]
	self.ActivityTranslate[ACT_MP_ATTACK_SWIM_PRIMARY_DEPLOYED or 0]= _G["ACT_MP_ATTACK_SWIM_"..t.."_DEPLOYED"]
	
	self.ActivityTranslate[ACT_MP_ATTACK_STAND_PREFIRE]				= ACT_MP_ATTACK_STAND_PREFIRE
	self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PREFIRE]			= ACT_MP_ATTACK_CROUCH_PREFIRE
	self.ActivityTranslate[ACT_MP_ATTACK_SWIM_PREFIRE]				= ACT_MP_ATTACK_SWIM_PREFIRE
	
	self.ActivityTranslate[ACT_MP_ATTACK_STAND_POSTFIRE]			= ACT_MP_ATTACK_STAND_POSTFIRE
	self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_POSTFIRE]			= ACT_MP_ATTACK_CROUCH_POSTFIRE
	self.ActivityTranslate[ACT_MP_ATTACK_SWIM_POSTFIRE]				= ACT_MP_ATTACK_SWIM_POSTFIRE
	
	self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= _G["ACT_MP_RELOAD_STAND_"..t]
	self.ActivityTranslate[ACT_MP_RELOAD_CROUCH]		 			= _G["ACT_MP_RELOAD_CROUCH_"..t]
	self.ActivityTranslate[ACT_MP_RELOAD_SWIM]		 				= _G["ACT_MP_RELOAD_SWIM_"..t]
	
	self.ActivityTranslate[ACT_MP_RELOAD_STAND_LOOP]		 		= _G["ACT_MP_RELOAD_STAND_"..t.."_LOOP"]
	self.ActivityTranslate[ACT_MP_RELOAD_CROUCH_LOOP]		 		= _G["ACT_MP_RELOAD_CROUCH_"..t.."_LOOP"]
	self.ActivityTranslate[ACT_MP_RELOAD_SWIM_LOOP]		 			= _G["ACT_MP_RELOAD_SWIM_"..t.."_LOOP"]

	self.ActivityTranslate[ACT_MP_JUMP_START] 						= _G["ACT_MP_JUMP_START_"..t]
	self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= _G["ACT_MP_JUMP_FLOAT_"..t]
	self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= _G["ACT_MP_JUMP_LAND_"..t]
		end
		end
	end
end

function SWEP:TranslateActivity(act)
	return self.ActivityTranslate[act] or -1
end

-- Trace a line then send the result to a mode function
function SWEP:PrimaryAttack()

	local mode = self:GetMode()
	local tr = util.GetPlayerTrace( self.Owner )
	tr.mask = bit.bor( CONTENTS_SOLID, CONTENTS_MOVEABLE, CONTENTS_MONSTER, CONTENTS_WINDOW, CONTENTS_DEBRIS, CONTENTS_GRATE, CONTENTS_AUX )
	local trace = util.TraceLine( tr )
	if ( !trace.Hit ) then return end

	local tool = self:GetToolObject()
	if ( !tool ) then return end

	tool:CheckObjects()
 
	-- Does the server setting say it's ok?
	if ( !tool:Allowed() ) then return end

	-- Ask the gamemode if it's ok to do this
	if ( !gamemode.Call( "CanTool", self.Owner, trace, mode ) ) then return end

	if ( !tool:LeftClick( trace ) ) then return end

	self:DoShootEffect( trace.HitPos, trace.HitNormal, trace.Entity, trace.PhysicsBone, IsFirstTimePredicted() )
	self:SetNextPrimaryFire(CurTime() + 0.5)

end