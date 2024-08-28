
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

ENT.Model = "models/weapons/c_models/c_demo_arms.mdl"

ENT.Animations={
cm_idle="ACT_VM_IDLE_SPECIAL",
cm_draw="ACT_VM_DRAW_SPECIAL",
cm_swing_a="ACT_VM_HITCENTER_SPECIAL",
cm_swing_b="ACT_VM_HITCENTER_SPECIAL",
cm_swing_c="ACT_VM_SWINGHARD_SPECIAL",
sb_idle="ACT_PRIMARY_VM_IDLE",
sb_draw="ACT_PRIMARY_VM_DRAW",
sb_autofire="ACT_PRIMARY_VM_PULLBACK",
sb_fire="ACT_PRIMARY_VM_PRIMARYATTACK",
sb_reload_start="ACT_PRIMARY_VM_RELOAD_START",
sb_reload_loop="ACT_PRIMARY_VM_RELOAD",
sb_reload_end="ACT_PRIMARY_VM_RELOAD_FINISH",
}

--[[
ENT.Animations={
AttackStand_PRIMARY="ACT_MP_ATTACK_STAND_PRIMARY",
AttackCrouch_PRIMARY="ACT_MP_ATTACK_CROUCH_PRIMARY",
AttackSwim_PRIMARY="ACT_MP_ATTACK_SWIM_PRIMARY",
AttackCrouch_PRIMARY_DEPLOYED="ACT_MP_ATTACK_CROUCH_PRIMARY_DEPLOYED",
AttackSwim_PRIMARY_DEPLOYED="ACT_MP_ATTACK_SWIM_PRIMARY_DEPLOYED",
ReloadStand_PRIMARY_DEPLOYED="ACT_MP_RELOAD_STAND_PRIMARY_DEPLOYED",
ReloadCrouch_PRIMARY_DEPLOYED="ACT_MP_RELOAD_CROUCH_PRIMARY_DEPLOYED",
ReloadSwim_PRIMARY_DEPLOYED="ACT_MP_RELOAD_SWIM_PRIMARY_DEPLOYED",
ReloadStand_PRIMARY="ACT_MP_RELOAD_STAND_PRIMARY",
ReloadCrouch_PRIMARY="ACT_MP_RELOAD_CROUCH_PRIMARY",
ReloadSwim_PRIMARY="ACT_MP_RELOAD_SWIM_PRIMARY",
attackstand_Primary_deployed_fire="ACT_MP_ATTACK_STAND_PRIMARY_DEPLOYED",
a_flinch01="ACT_MP_GESTURE_FLINCH_CHEST",
PRIMARY_placeSapper="ACT_MP_ATTACK_STAND_GRENADE",
AttackStand_SECONDARY="ACT_MP_ATTACK_STAND_SECONDARY",
AttackCrouch_SECONDARY="ACT_MP_ATTACK_CROUCH_SECONDARY",
AttackSwim_SECONDARY="ACT_MP_ATTACK_SWIM_SECONDARY",
ReloadStand_SECONDARY="ACT_MP_RELOAD_STAND_SECONDARY",
ReloadAirwalk_SECONDARY="ACT_MP_RELOAD_AIRWALK_SECONDARY",
ReloadCrouch_SECONDARY="ACT_MP_RELOAD_CROUCH_SECONDARY",
ReloadSwim_SECONDARY="ACT_MP_RELOAD_SWIM_SECONDARY",
Melee_Swing="ACT_MP_ATTACK_STAND_MELEE",
Melee_Crouch_Swing="ACT_MP_ATTACK_CROUCH_MELEE",
MELEE_swim_swing="ACT_MP_ATTACK_SWIM_MELEE",
ITEM1_fire="ACT_MP_ATTACK_STAND_ITEM1",
ITEM1_Crouch_fire="ACT_MP_ATTACK_CROUCH_ITEM1",
ITEM2_fire="ACT_MP_ATTACK_STAND_ITEM2",
ITEM2_reload="ACT_MP_RELOAD_STAND_ITEM2",
ITEM2_crouch_fire="ACT_MP_ATTACK_CROUCH_ITEM2",
ITEM2_crouch_reload="ACT_MP_RELOAD_CROUCH_ITEM2",
gesture_primary_go="ACT_MP_GESTURE_VC_FINGERPOINT_PRIMARY",
gesture_primary_cheer="ACT_MP_GESTURE_VC_FISTPUMP_PRIMARY",
gesture_primary_help="ACT_MP_GESTURE_VC_HANDMOUTH_PRIMARY",
gesture_primary_positive="ACT_MP_GESTURE_VC_THUMBSUP_PRIMARY",
gesture_secondary_go="ACT_MP_GESTURE_VC_FINGERPOINT_SECONDARY",
gesture_secondary_cheer="ACT_MP_GESTURE_VC_FISTPUMP_SECONDARY",
gesture_secondary_help="ACT_MP_GESTURE_VC_HANDMOUTH_SECONDARY",
gesture_secondary_positive="ACT_MP_GESTURE_VC_THUMBSUP_SECONDARY",
gesture_melee_go="ACT_MP_GESTURE_VC_FINGERPOINT_MELEE",
gesture_melee_cheer="ACT_MP_GESTURE_VC_FISTPUMP_MELEE",
gesture_melee_help="ACT_MP_GESTURE_VC_HANDMOUTH_MELEE",
gesture_melee_positive="ACT_MP_GESTURE_VC_THUMBSUP_MELEE",
PRIMARY_Stun_begin="ACT_MP_STUN_BEGIN",
PRIMARY_stun_middle="ACT_MP_STUN_MIDDLE",
PRIMARY_stun_end="ACT_MP_STUN_END",
Stand_PRIMARY="ACT_MP_STAND_PRIMARY",
Stand_SECONDARY="ACT_MP_STAND_SECONDARY",
Stand_MELEE="ACT_MP_STAND_MELEE",
Stand_ITEM1="ACT_MP_STAND_ITEM1",
Stand_ITEM2="ACT_MP_STAND_ITEM2",
Stand_LOSER="ACT_MP_STAND_LOSERSTATE",
Crouch_PRIMARY="ACT_MP_CROUCH_PRIMARY",
Crouch_SECONDARY="ACT_MP_CROUCH_SECONDARY",
Crouch_MELEE="ACT_MP_CROUCH_MELEE",
Crouch_ITEM1="ACT_MP_CROUCH_ITEM1",
Crouch_ITEM2="ACT_MP_CROUCH_ITEM2",
Crouch_ITEM2_DEPLOYED="ACT_MP_CROUCH_DEPLOYED_IDLE_ITEM2",
Crouch_LOSER="ACT_MP_CROUCH_LOSERSTATE",
a_jumpStart_primary="ACT_MP_JUMP_START_primary",
a_jumpfloat_primary="ACT_MP_JUMP_FLOAT_primary",
jumpLand_primary="ACT_MP_JUMP_LAND_primary",
a_jumpStart_secondary="ACT_MP_JUMP_START_secondary",
a_jumpfloat_secondary="ACT_MP_JUMP_FLOAT_secondary",
jumpLand_secondary="ACT_MP_JUMP_LAND_secondary",
a_jumpStart_Melee="ACT_MP_JUMP_START_Melee",
a_jumpfloat_Melee="ACT_MP_JUMP_FLOAT_Melee",
jumpLand_Melee="ACT_MP_JUMP_LAND_Melee",
a_jumpStart_ITEM1="ACT_MP_JUMP_START_ITEM1",
a_jumpfloat_ITEM1="ACT_MP_JUMP_FLOAT_ITEM1",
jumpLand_ITEM1="ACT_MP_JUMP_LAND_ITEM1",
a_jumpStart_ITEM2="ACT_MP_JUMP_START_ITEM2",
a_jumpfloat_ITEM2="ACT_MP_JUMP_FLOAT_ITEM2",
jumpLand_ITEM2="ACT_MP_JUMP_LAND_ITEM2",
a_jumpStart_LOSER="ACT_MP_JUMP_START_LOSERSTATE",
a_jumpfloat_LOSER="ACT_MP_JUMP_FLOAT_LOSERSTATE",
jumpLand_LOSER="ACT_MP_JUMP_LAND_LOSERSTATE",
Swim_Primary="ACT_MP_SWIM_Primary",
Swim_Secondary="ACT_MP_SWIM_Secondary",
Swim_Melee="ACT_MP_SWIM_Melee",
Swim_Primary_Deployed="ACT_MP_SWIM_DEPLOYED_PRIMARY",
Swim_ITEM1="ACT_MP_SWIM_ITEM1",
Swim_ITEM2="ACT_MP_SWIM_ITEM2",
Swim_LOSER="ACT_MP_SWIM_LOSERSTATE",
Crouch_Deployed_PRIMARY="ACT_MP_CROUCH_DEPLOYED_IDLE",
Stand_Deployed_PRIMARY="ACT_MP_DEPLOYED_IDLE",
PRIMARY_Deployed_Movement="ACT_MP_DEPLOYED_PRIMARY",
Deployed_Crouch_Walk_Primary="ACT_MP_CROUCHWALK_DEPLOYED",
Run_PRIMARY="ACT_MP_RUN_PRIMARY",
crouch_walk_PRIMARY="ACT_MP_CROUCHWALK_PRIMARY",
Run_SECONDARY="ACT_MP_RUN_SECONDARY",
Crouch_Walk_SECONDARY="ACT_MP_CROUCHWALK_SECONDARY",
Run_MELEE="ACT_MP_RUN_MELEE",
Crouch_Walk_MELEE="ACT_MP_CROUCHWALK_MELEE",
Run_item1="ACT_MP_RUN_item1",
Crouch_Walk_item1="ACT_MP_CROUCHWALK_item1",
Run_ITEM2="ACT_MP_RUN_ITEM2",
Crouch_Walk_ITEM2="ACT_MP_CROUCHWALK_ITEM2",
Stand_Deployed_ITEM2="ACT_MP_DEPLOYED_IDLE_ITEM2",
ITEM2_Deployed_Movement="ACT_MP_DEPLOYED_ITEM2",
Crouch_Walk_ITEM2_Deployed="ACT_MP_CROUCHWALK_DEPLOYED_ITEM2",
Run_loser="ACT_MP_RUN_LOSERSTATE",
Airwalk_PRIMARY="ACT_MP_AIRWALK_PRIMARY",
Airwalk_SECONDARY="ACT_MP_AIRWALK_SECONDARY",
Airwalk_MELEE="ACT_MP_AIRWALK_MELEE",
Airwalk_ITEM1="ACT_MP_AIRWALK_ITEM1",
Airwalk_ITEM2="ACT_MP_AIRWALK_ITEM2",
Airwalk_LOSER="ACT_MP_AIRWALK_LOSERSTATE",
}]]

concommand.Add("activity_seek", function(pl)
	local pos = pl:GetEyeTrace().HitPos
	
	local ent = ents.Create("act_finder")
	ent:SetPos(pos+Vector(0,0,20))
	ent:Spawn()
	ent:Activate()
end)

function ENT:Initialize()
	self:SetMoveType(MOVETYPE_NONE)
	self:SetModel(self.Model)
	
	self.NumAnim = 0
	self.Animations2 = {}
	for k,v in pairs(self.Animations) do
		local s = self:LookupSequence(k)
		if s>=0 then
			self.Animations2[self:LookupSequence(k)] = v
			self.NumAnim = self.NumAnim + 1
		end
	end
	Msg(self.NumAnim.." animations.\n")
end

function ENT:Think()
	if not self.Act then
		self.Act=-1
		self.NumAnim2=0
		Msg("Search started : "..self:GetModel().."\n")
	end
	
	for i=1,100 do
		local seq = self:SelectWeightedSequence(self.Act)
		if seq>=0 then
			if self.Animations2[seq] then
				self.NumAnim2 = self.NumAnim2 + 1
				ErrorNoHalt(self.Animations2[seq].." = "..self.Act.."\n")
			end
		end
		self.Act = self.Act+1
	end
	
	if self.Act>5000 then
		ErrorNoHalt("Done\n")
		Msg(self.NumAnim2.." valid animations found.\n")
		self:Remove()
	end
end