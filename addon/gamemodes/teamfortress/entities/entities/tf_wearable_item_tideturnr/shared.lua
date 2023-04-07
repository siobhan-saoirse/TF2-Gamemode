
local tf_targe_enhanced_charge = CreateConVar("tf_targe_enhanced_charge", 1, {FCVAR_CHEAT})

ENT.Type 			= "anim"
ENT.Base 			= "tf_wearable_item_demoshield"

ENT.MeleeRange = 50

ENT.ForceMultiplier = 10000
ENT.CritForceMultiplier = 10000
ENT.ForceAddPitch = 0
ENT.CritForceAddPitch = 0

ENT.DefaultBaseDamage = 50
ENT.DamagePerHead = 10
--ENT.MaxHeads = 5

ENT.BaseDamage = 50
ENT.DamageRandomize = 0.1
ENT.MaxDamageRampUp = 0
ENT.MaxDamageFalloff = 0

ENT.HitPlayerSound = Sound("DemoCharge.HitFlesh")
ENT.HitPlayerRangeSound = Sound("DemoCharge.HitFleshRange")
ENT.HitWorldSound = Sound("DemoCharge.HitWorld")

ENT.CritStartSound = Sound("DemoCharge.ChargeCritOn")
ENT.CritStopSound = Sound("DemoCharge.ChargeCritOff")

ENT.DefaultChargeDuration = 1.5
ENT.ChargeCooldownDuration = 12

ENT.ChargeSteerConstraint = GetConVar( "sensitivity" )