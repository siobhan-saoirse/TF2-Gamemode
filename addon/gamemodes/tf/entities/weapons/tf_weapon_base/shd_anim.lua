
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
		local hold = "PRIMARY"
		if item.anim_slot then
			hold = string.upper(item.anim_slot)
		elseif item.item_slot then
			hold = string.upper(item.item_slot)
		end
		----MsgN(Format("SetupCModelActivities %s", tostring(self)))
		
		self.VM_DRAW			= getfenv()["ACT_"..hold.."_VM_DRAW"]
		self.VM_IDLE			= getfenv()["ACT_"..hold.."_VM_IDLE"]
		self.VM_PRIMARYATTACK	= getfenv()["ACT_"..hold.."_VM_PRIMARYATTACK"]
		self.VM_SECONDARYATTACK	= getfenv()["ACT_"..hold.."_VM_SECONDARYATTACK"]
		self.VM_RELOAD			= getfenv()["ACT_"..hold.."_VM_RELOAD"]
		self.VM_RELOAD_START	= getfenv()["ACT_"..hold.."_RELOAD_START"]
		self.VM_RELOAD_FINISH	= getfenv()["ACT_"..hold.."_RELOAD_FINISH"]
		 
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
		
		self.VM_HITLEFT			= ACT_VM_HITLEFT
		self.VM_HITRIGHT		= ACT_VM_HITRIGHT
		
		-- those melee activities are just so weird, sometimes it's ACT_VM_HITCENTER, sometimes it's ACT_MELEE_VM_HITCENTER
		if self:SelectWeightedSequence(ACT_VM_HITCENTER) < 0 then
			self.VM_HITCENTER		= getfenv()["ACT_"..hold.."_VM_HITCENTER"] or ACT_VM_HITCENTER
			self.VM_SWINGHARD		= getfenv()["ACT_"..hold.."_VM_SWINGHARD"] or ACT_VM_SWINGHARD
		else
			self.VM_HITCENTER		= ACT_VM_HITCENTER
			self.VM_SWINGHARD		= ACT_VM_SWINGHARD
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
		
		self.VM_HITLEFT		= getfenv()["ACT_"..hold.."_VM_HITCENTER"]
		self.VM_HITRIGHT		= getfenv()["ACT_"..hold.."_VM_SWINGHARD"]
		self.VM_HITCENTER		= getfenv()["ACT_"..hold.."_VM_HITCENTER"]
		self.VM_SWINGHARD		= getfenv()["ACT_"..hold.."_VM_SWINGHARD"]
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
					self[ActivityNameTranslate[act]] = getfenv()[rep]
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
		--print(anim)
		local s = self.Owner:GetViewModel():LookupSequence(anim)
		self:SetSequence(s)
		self.Owner:GetViewModel():ResetSequence(s)
	end
end

--==================================================================
-- THIRDPERSON ANIMATIONS
--==================================================================

function SWEP:SetWeaponHoldType(t)
	if (t == "PRIMARY2") then
		t = "PRIMARY"
	end
	if (t == "ITEM3") then
		t = "MELEE"
	end
	if (t == "FISTS") then
		t = "MELEE"
	end
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
		tf_util.ReadActivitiesFromModel(v)
	end	
	self.ActivityTranslate = {}
	self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_MP_STAND_"..t]
	self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_MP_RUN_"..t]
	self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_MP_RUN_"..t]
	self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_MP_CROUCH_"..t]
	self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_MP_CROUCHWALK_"..t]
	self.ActivityTranslate[ACT_MP_SWIM] 							= getfenv()["ACT_MP_SWIM_"..t]
	self.ActivityTranslate[ACT_MP_AIRWALK] 							= getfenv()["ACT_MP_AIRWALK_"..t]
	if (t == "MELEE_ALLCLASS") then

		self.ActivityTranslate[ACT_MP_GESTURE_VC_HANDMOUTH] 			= getfenv()["ACT_MP_GESTURE_VC_HANDMOUTH_MELEE"]
		self.ActivityTranslate[ACT_MP_GESTURE_VC_THUMBSUP] 				= getfenv()["ACT_MP_GESTURE_VC_THUMBSUP_MELEE"]
		self.ActivityTranslate[ACT_MP_GESTURE_VC_FINGERPOINT] 			= getfenv()["ACT_MP_GESTURE_VC_FINGERPOINT_MELEE"]
		self.ActivityTranslate[ACT_MP_GESTURE_VC_FISTPUMP] 				= getfenv()["ACT_MP_GESTURE_VC_FISTPUMP_MELEE"]

	else
		self.ActivityTranslate[ACT_MP_GESTURE_VC_HANDMOUTH] 			= getfenv()["ACT_MP_GESTURE_VC_HANDMOUTH_"..t]
		self.ActivityTranslate[ACT_MP_GESTURE_VC_THUMBSUP] 				= getfenv()["ACT_MP_GESTURE_VC_THUMBSUP_"..t]
		self.ActivityTranslate[ACT_MP_GESTURE_VC_FINGERPOINT] 			= getfenv()["ACT_MP_GESTURE_VC_FINGERPOINT_"..t]
		self.ActivityTranslate[ACT_MP_GESTURE_VC_FISTPUMP] 				= getfenv()["ACT_MP_GESTURE_VC_FISTPUMP_"..t]
	end
	self.ActivityTranslate[ACT_MP_GESTURE_VC_NODYES] 				= getfenv()["ACT_MP_GESTURE_VC_NODYES_"..t]
	self.ActivityTranslate[ACT_MP_GESTURE_VC_NODNO] 				= getfenv()["ACT_MP_GESTURE_VC_NODNO_"..t]
	if v:GetPlayerClass() == "hl1scientist" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CROUCH"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= getfenv()["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= v:GetSequenceActivity(v:LookupSequence("fallingloop"))
		self.ActivityTranslate[ACT_MP_AIRWALK] 						= v:GetSequenceActivity(v:LookupSequence("fallingloop"))
		self.ActivityTranslate[ACT_MP_SWIM] 						= v:GetSequenceActivity(v:LookupSequence("fallingloop"))
	end
	if v:GetPlayerClass() == "zombie" and v:GetActiveWeapon():GetClass() == "tf_weapon_fists"  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= getfenv()["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= getfenv()["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "antlion" and v:GetActiveWeapon():GetClass() == "tf_weapon_fists"  then
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
	end
	if v:GetPlayerClass() == "headcrab" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= getfenv()["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= getfenv()["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "fastzombie" and v:GetActiveWeapon():GetClass() == "tf_weapon_fists"  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_INVALID"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_HL2MP_RUN_ZOMBIE_FAST"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_HL2MP_RUN_ZOMBIE_FAST"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_HL2MP_IDLE_CROUCH_ZOMBIE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_HL2MP_WALK_CROUCH_ZOMBIE_0"..math.random(1,5)]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= getfenv()["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= getfenv()["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "poisonzombie" and v:GetActiveWeapon():GetClass() == "tf_weapon_fists"  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= getfenv()["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= getfenv()["ACT_RUN"] 
	end
	if v:GetPlayerClass() == "rebel" and v:GetActiveWeapon():GetClass() != "tf_weapon_trenchknife" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE_ANGRY_SMG1"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_RUN_AIM_RIFLE"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_RUN_RIFLE"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CROUCH"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_WALK_CROUCH_RIFLE"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= getfenv()["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= getfenv()["ACT_JUMP"]
	end		
	if v:GetPlayerClass() == "boomer" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_RUN_CROUCH"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "spitter" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_RUN_CROUCH"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "boomette" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_RUN_CROUCH"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "smoker" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_RUN_CROUCH"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_CLIMB_UP"]
	end
	if !v:IsHL2() and !v:IsL4D() and self.Owner:GetMoveType() == MOVETYPE_LADDER then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= getfenv()["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_MP_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_MP_SWIM_"..t]
	end	  
	if v:GetPlayerClass() == "hunter" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_RUN_CROUCH"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "jockey" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_RUN_CROUCH"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "witch" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "charger" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK"] 
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_RUN_CROUCH"]

		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 		= getfenv()["ACT_MP_ATTACK_STAND_"..t]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]		= getfenv()["ACT_MP_ATTACK_CROUCH_"..t]
		self.ActivityTranslate[ACT_MP_ATTACK_SWIM_PRIMARYFIRE]			= getfenv()["ACT_MP_ATTACK_SWIM_"..t]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_TERROR_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_TERROR_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "l4d_zombie" and self.Owner:GetMoveType() != MOVETYPE_LADDER then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK2"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK2"] 
		self.ActivityTranslate[ ACT_MP_SWIM ]						= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "boomer" and self.Owner:GetMoveType() == MOVETYPE_LADDER then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "spitter" and self.Owner:GetMoveType() == MOVETYPE_LADDER then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "boomette" and self.Owner:GetMoveType() == MOVETYPE_LADDER then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "tank_l4d" and self.Owner:GetMoveType() != MOVETYPE_LADDER  then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_RUN_CROUCH"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "tank_l4d" and self.Owner:GetMoveType() == MOVETYPE_LADDER then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_CLIMB_UP"]
	end
	if v:GetPlayerClass() == "l4d_zombie" and self.Owner:GetMoveType() == MOVETYPE_LADDER then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ ACT_MP_SWIM ]						= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_CLIMB_UP"]
		self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_CLIMB_UP"]
	end
	
	if v:GetPlayerClass() == "metrocop" and v:GetActiveWeapon():GetClass() == "tf_weapon_trenchknife" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE_ANGRY_SMG1"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_RUN_AIM_RIFLE"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK_RIFLE"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CROUCHIDLE_RIFLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_WALK_CROUCH_RIFLE"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= getfenv()["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= getfenv()["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "metrocop" and v:GetActiveWeapon():GetClass() == "tf_weapon_pistol_m9" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE_ANGRY_PISTOL"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_RUN_AIM_PISTOL"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK_PISTOL"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CROUCHIDLE_RIFLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_WALK_CROUCH_RIFLE"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= getfenv()["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= getfenv()["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "metrocop" and v:GetActiveWeapon():GetClass() == "tf_weapon_wrench_vagineer" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_RUN"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_WALK"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_WALK_CROUCH"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_MELEE_ATTACK1"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= getfenv()["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= getfenv()["ACT_JUMP"]
	end
	if v:GetPlayerClass() == "rebel" and v:GetActiveWeapon():GetClass() == "tf_weapon_trenchknife" then
		self.ActivityTranslate[ACT_MP_STAND_IDLE] 						= getfenv()["ACT_IDLE_ANGRY_SMG1"]
		self.ActivityTranslate[ACT_MP_RUN] 								= getfenv()["ACT_RUN_RIFLE"]
		self.ActivityTranslate[ACT_MP_WALK] 								= getfenv()["ACT_RUN_RIFLE"]
		self.ActivityTranslate[ACT_MP_CROUCH_IDLE] 						= getfenv()["ACT_CROUCHIDLE"]
		self.ActivityTranslate[ACT_MP_CROUCHWALK] 						= getfenv()["ACT_WALK_CROUCH_RIFLE"]
		self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_RANGE_ATTACK_SMG1"]
		self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_RANGE_ATTACK_SMG1_LOW"]
		self.ActivityTranslate[ ACT_MP_JUMP ]						= getfenv()["ACT_JUMP"]
		self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= getfenv()["ACT_RELOAD"]
		self.ActivityTranslate[ACT_MP_JUMP] 						= getfenv()["ACT_JUMP"]
	end
	
		if t == "PRIMARY" then
			self.ActivityTranslate[ACT_MP_DEPLOYED_IDLE] 				= ACT_MP_DEPLOYED_IDLE
			self.ActivityTranslate[ACT_MP_DEPLOYED] 					= ACT_MP_DEPLOYED_PRIMARY
			self.ActivityTranslate[ACT_MP_CROUCH_DEPLOYED_IDLE] 		= ACT_MP_CROUCH_DEPLOYED_IDLE
			self.ActivityTranslate[ACT_MP_CROUCH_DEPLOYED] 				= ACT_MP_CROUCHWALK_DEPLOYED
			self.ActivityTranslate[ACT_MP_SWIM_DEPLOYED] 				= ACT_MP_SWIM_DEPLOYED_PRIMARY
		else
			self.ActivityTranslate[ACT_MP_DEPLOYED_IDLE] 				= getfenv()["ACT_MP_DEPLOYED_IDLE_"..t]
			self.ActivityTranslate[ACT_MP_DEPLOYED] 					= getfenv()["ACT_MP_DEPLOYED_"..t]
			self.ActivityTranslate[ACT_MP_CROUCH_DEPLOYED_IDLE] 		= getfenv()["ACT_MP_CROUCH_DEPLOYED_IDLE_"..t]
			self.ActivityTranslate[ACT_MP_CROUCH_DEPLOYED] 				= getfenv()["ACT_MP_CROUCHWALK_DEPLOYED_"..t]
			self.ActivityTranslate[ACT_MP_SWIM_DEPLOYED] 				= getfenv()["ACT_MP_SWIM_DEPLOYED_"..t]
		end

			self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 		= getfenv()["ACT_MP_ATTACK_STAND_"..t]
			self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]		= getfenv()["ACT_MP_ATTACK_CROUCH_"..t]
			self.ActivityTranslate[ACT_MP_ATTACK_SWIM_PRIMARYFIRE]			= getfenv()["ACT_MP_ATTACK_SWIM_"..t]
			
			self.ActivityTranslate[ACT_MP_ATTACK_STAND_SECONDARYFIRE] 		= getfenv()["ACT_MP_ATTACK_STAND_"..t.."_SECONDARY"]
			self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_SECONDARYFIRE]		= getfenv()["ACT_MP_ATTACK_CROUCH_"..t.."_SECONDARY"]
			self.ActivityTranslate[ACT_MP_ATTACK_SWIM_SECONDARYFIRE]		= getfenv()["ACT_MP_ATTACK_SWIM_"..t.."_SECONDARY"]
			
			self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARY_DEPLOYED] 	= getfenv()["ACT_MP_ATTACK_STAND_"..t.."_DEPLOYED"]
			self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARY_DEPLOYED] 	= getfenv()["ACT_MP_ATTACK_CROUCH_"..t.."_DEPLOYED"]
			self.ActivityTranslate[ACT_MP_ATTACK_SWIM_PRIMARY_DEPLOYED or 0]= getfenv()["ACT_MP_ATTACK_SWIM_"..t.."_DEPLOYED"]
			if (self:GetClass() == "tf_weapon_slap") then 
				self.ActivityTranslate[ACT_MP_ATTACK_STAND_PRIMARYFIRE]			= getfenv()["ACT_MP_ATTACK_STAND_ITEM3"]
				self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]			= getfenv()["ACT_MP_ATTACK_CROUCH_ITEM3"]
				self.ActivityTranslate[ACT_MP_ATTACK_SWIM_PRIMARYFIRE]			= getfenv()["ACT_MP_ATTACK_SWIM_ITEM3"]
			end
			
			self.ActivityTranslate[ACT_MP_ATTACK_STAND_PREFIRE]				= ACT_MP_ATTACK_STAND_PREFIRE
			self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_PREFIRE]			= ACT_MP_ATTACK_CROUCH_PREFIRE
			self.ActivityTranslate[ACT_MP_ATTACK_SWIM_PREFIRE]				= ACT_MP_ATTACK_SWIM_PREFIRE
			
			self.ActivityTranslate[ACT_MP_ATTACK_STAND_POSTFIRE]			= ACT_MP_ATTACK_STAND_POSTFIRE
			self.ActivityTranslate[ACT_MP_ATTACK_CROUCH_POSTFIRE]			= ACT_MP_ATTACK_CROUCH_POSTFIRE
			self.ActivityTranslate[ACT_MP_ATTACK_SWIM_POSTFIRE]				= ACT_MP_ATTACK_SWIM_POSTFIRE
			
			self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= getfenv()["ACT_MP_RELOAD_STAND_"..t]
			self.ActivityTranslate[ACT_MP_RELOAD_CROUCH]		 			= getfenv()["ACT_MP_RELOAD_CROUCH_"..t]
			self.ActivityTranslate[ACT_MP_RELOAD_SWIM]		 				= getfenv()["ACT_MP_RELOAD_SWIM_"..t]
			
			self.ActivityTranslate[ACT_MP_RELOAD_STAND_LOOP]		 		= getfenv()["ACT_MP_RELOAD_STAND_"..t.."_LOOP"]
			self.ActivityTranslate[ACT_MP_RELOAD_CROUCH_LOOP]		 		= getfenv()["ACT_MP_RELOAD_CROUCH_"..t.."_LOOP"]
			self.ActivityTranslate[ACT_MP_RELOAD_SWIM_LOOP]		 			= getfenv()["ACT_MP_RELOAD_SWIM_"..t.."_LOOP"]
		 
			self.ActivityTranslate[ACT_MP_RELOAD_STAND_END]		 		= getfenv()["ACT_MP_RELOAD_STAND_"..t.."_END"]
			self.ActivityTranslate[ACT_MP_RELOAD_CROUCH_END]		 		= getfenv()["ACT_MP_RELOAD_CROUCH_"..t.."_END"]
			self.ActivityTranslate[ACT_MP_RELOAD_SWIM_END]		 			= getfenv()["ACT_MP_RELOAD_SWIM_"..t.."_END"]

			self.ActivityTranslate[ACT_MP_JUMP] 						= getfenv()["ACT_MP_JUMP_START_"..t]
			self.ActivityTranslate[ACT_MP_JUMP_START] 						= getfenv()["ACT_MP_JUMP_START_"..t]
			self.ActivityTranslate[ACT_MP_JUMP_FLOAT] 						= getfenv()["ACT_MP_JUMP_FLOAT_"..t]
			self.ActivityTranslate[ACT_MP_JUMP_LAND] 						= getfenv()["ACT_MP_JUMP_LAND_"..t]
			self.ActivityTranslate[ACT_LAND] 						= getfenv()["ACT_MP_JUMP_LAND_"..t]
			if (v:GetPlayerClass() == "soldier") then

				self.ActivityTranslate[ACT_MP_RELOAD_STAND]		 				= getfenv()["ACT_MP_RELOAD_STAND_"..t]
				self.ActivityTranslate[ACT_MP_RELOAD_CROUCH]		 			= getfenv()["ACT_MP_RELOAD_STAND_"..t]
				self.ActivityTranslate[ACT_MP_RELOAD_SWIM]		 				= getfenv()["ACT_MP_RELOAD_STAND_"..t]
				
				self.ActivityTranslate[ACT_MP_RELOAD_STAND_LOOP]		 		= getfenv()["ACT_MP_RELOAD_STAND_"..t.."_LOOP"]
				self.ActivityTranslate[ACT_MP_RELOAD_CROUCH_LOOP]		 		= getfenv()["ACT_MP_RELOAD_STAND_"..t.."_LOOP"]
				self.ActivityTranslate[ACT_MP_RELOAD_SWIM_LOOP]		 			= getfenv()["ACT_MP_RELOAD_STAND_"..t.."_LOOP"]
			 
				self.ActivityTranslate[ACT_MP_RELOAD_STAND_END]		 			= getfenv()["ACT_MP_RELOAD_STAND_"..t.."_END"]
				self.ActivityTranslate[ACT_MP_RELOAD_CROUCH_END]		 		= getfenv()["ACT_MP_RELOAD_STAND_"..t.."_END"]
				self.ActivityTranslate[ACT_MP_RELOAD_SWIM_END]		 			= getfenv()["ACT_MP_RELOAD_STAND_"..t.."_END"]

			end
		end
		end
	end
end

function SWEP:TranslateActivity(act)
	return self.ActivityTranslate[act] or -1
end
