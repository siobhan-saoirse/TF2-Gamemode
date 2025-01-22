--MsgN("Loading extra items and attributes")

if CLIENT then

local lang_data = [["lang" 
{ 
"Language" "English" 
"Tokens" 
{ 

"Attrib_Player_TurnGay" 				"Imbued with an ancestral gey power"
"Attrib_Player_TurnGay2" 				"On Hit: Victim turns gay\nGay players have a 50% probability\nto inflict negative damage"
"Attrib_Shoots_Nukes"					"Shoots massive nuclear payloads.\nHow can they even fit in there?"
"Attrib_Owner_Receives_Minicrits"		"All incoming hits are mini-crits"
"Attrib_CritVsNoclip"					"100% critical hits vs noclipping players"
"Attrib_EnableCrotchshots"				"Crits on an accurate shot between legs"
"Attrib_AltFire_Is_Vampire"				"Alt-Fire: +3 health on hit\n-75% damage done"
"Attrib_MilkDuration"					"On Hit: Mad Milk applied to target for %s1 seconds"
"Attrib_BouncyGrenades"					"Fires bouncy round grenades"
"Attrib_RadialHealOnHit"				"On Hit: +%s1 health on nearby teammates"
"Attrib_BurnDuration"					"On Hit: Victim catches fire for %s1 seconds"

"Attrib_DmgTaken_From_Fall_Reduced"		"+%s1% fall damage resistance on wearer"
"Attrib_DmgTaken_From_Fall_Increased"	"%s1% fall damage vulnerability on wearer"
"Attrib_DmgTaken_From_Phys_Reduced"		"+%s1% physics damage resistance on wearer"
"Attrib_DmgTaken_From_Phys_Increased"	"%s1% physics damage vulnerability on wearer"
"Attrib_JumpHeight_Bonus"				"+%s1% higher jump height on wearer"
"Attrib_JumpHeight_Penalty"				"%s1% lower jump height on wearer"

"Attrib_Charge_Is_Unstoppable"			"Running into an enemy does not end a charge"
"Attrib_Charge_Rate_Reduced"			"+%s1% longer cooldown"
"Attrib_Charge_Rate_Increased"			"%s1% shorter cooldown"

"Attrib_Rocket_Gravity"					"Fires heavy rockets that arc over distances\nRockets can be charged, increasing their velocity"

"Attrib_StoutShako_Launcher"			"Stout Shako for two refined!"

"TF_Unique_GayPride"		"Sexo de Pene Gay"
"TF_Unique_GayPride_Desc"	"Presumably stolen from an obscure\nbranch of the Spanish Inquisition, this\nweapon is imbued with sheer gey power"
"TF_Unique_Ludmila"			"Ludmila"
"TF_Unique_Bazooka"			"Bazooka"

"TF_Test_SyringeGun1"		"Syringe Gun Test 1"
"TF_Test_GrenadeLauncher1"	"Grenade Launcher Test 1"


"TF_Set_Demopan_Trader"		"The Demopan's Trading Kit"
}
}
]]

include("tf_lang_module.lua")
tf_lang.Parse(lang_data)

end


-- Attributes
local function VALID(e)			return IsValid(e) end
local function ISPLAYER(e)		return VALID(e) and e:IsTFPlayer() end
local function ONFIRE(e)		return VALID(e) and e:HasPlayerState(PLAYERSTATE_ONFIRE) end
local function ISBUILDING(e)	return VALID(e) and (not e:IsTFPlayer() or e:IsBuilding()) end

DF_GEY=128

desired = CreateClientConVar("wear_desired", "0", {FCVAR_CLIENTDLL}, "What wear type do you desire the most?")
sounds = CreateClientConVar("wear_sounds", "0", {FCVAR_CLIENTDLL}, "Do you want to hear sounds when you achieve something?")
lines = CreateClientConVar("wear_lines", "0", {FCVAR_CLIENTDLL}, "What to see messages alongside wear type?")

function PrintSkin()
	if desired:GetInt() == 0 and lines:GetInt() >= 2 then
		wear_strings = { 
			'Factory New. Well done!',
			'Minimal Wear. Few scratches, no jiffy.',
			'Feild Tested. Its good enough.',
			'Well Worn. This looks beat up!',
			'Battle Scarred. This looks like a car crash in slow motion!'
		}
	else
		wear_strings = { 
			'Factory New.',
			'Minimal Wear.',
			'Feild Tested.',
			'Well Worn.',
			'Battle Scarred.'
		}
	end

	if desired:GetInt() == 0 then
		wear_sounds = { 
			'misc/achievement_earned.wav',
			'misc/happy_birthday.wav',
			'misc/boring_applause_1.wav',
			'misc/clap_single_2.wav',
			'misc/hologram_stop.wav'
		}
	end
	
	if CLIENT then
		timer.Simple(0.02, function() if lines:GetInt() >= 1 then chat.AddText( Color(255,255,255), LocalPlayer(), " Your ", weapon_name:GetFullName() ," is ", Color( 100, 255, 100 ), wear_strings[wear_number]) end end)
		if desired:GetInt() == 0 and sounds:GetInt() >= 1 then surface.PlaySound(wear_sounds[wear_number]) end
	end
end

RegisterAttribute("material_override", {
	equip = function(v,weapon,owner)
		//weapon.CustomColorOverride = Color(255,30,150,255)
		if SERVER then
			weapon.CustomMaterialOverride = v
			weapon.CustomMaterialOverride2 = v
		else
			weapon.CustomMaterialOverride = Material(v)
			weapon.CustomMaterialOverride2 = v
		end
		
		if CLIENT then
			
			weapon.ViewModelDrawn0 = weapon.ViewModelDrawn
			weapon.ViewModelDrawn = function(self,t)
				//render.SetColorModulation(1,0.2,0.7)
				if IsValid(self.CModel) then
					self.CModel:SetMaterial(v)
				end
				self:ViewModelDrawn0()
				//render.SetColorModulation(1,1,1)
			end
		end
		
	end,
})

RegisterAttribute("material_override_team", {
	equip = function(v,weapon,owner)
	if owner:Team() == 2 then
		team_skin = "_blue"
	else
		team_skin = "_red"
	end
		if SERVER then
			weapon.CustomMaterialOverride = v..team_skin
			weapon.CustomMaterialOverride2 = v..team_skin
		else
			weapon.CustomMaterialOverride = Material(v..team_skin)
			weapon.CustomMaterialOverride2 = v..team_skin
		end
		
		if CLIENT then
			
			weapon.ViewModelDrawn0 = weapon.ViewModelDrawn
			weapon.ViewModelDrawn = function(self,t)
				if IsValid(self.CModel) then
					self.CModel:SetMaterial(v..team_skin)
				end
				self:ViewModelDrawn0()
			end
		end
		
	end,
})

RegisterAttribute("material_override_skin", {
	equip = function(v,weapon,owner)
		wear_types = { 
			'_factory_new_red',
			'_minimal_wear_red',
			'_feild_tested_red',
			'_well_worn_red',
			'_battle_scarred_red'
		}
		if desired:GetInt() >= 1 and desired:GetInt() <= 5 then
			wear_number = GetConVar("wear_desired"):GetInt()
		else
			wear_number = math.random( #wear_types )
		end
		
		if SERVER then
			weapon.CustomMaterialOverride = v..wear_types[wear_number]
			weapon.CustomMaterialOverride2 = v..wear_types[wear_number]
		else
			weapon.CustomMaterialOverride = Material(v..wear_types[wear_number])
			weapon.CustomMaterialOverride2 = v..wear_types[wear_number]
		end
		
		if CLIENT then
			
			weapon.ViewModelDrawn0 = weapon.ViewModelDrawn
			weapon.ViewModelDrawn = function(self,t)
				if IsValid(self.CModel) then
					self.CModel:SetMaterial(v..wear_types[wear_number])
				end
				self:ViewModelDrawn0()
			end
		end
		timer.Simple(0.02, function() weapon_name = weapon end)
		PrintSkin()
	end,
})

RegisterAttribute("material_override_skin_team", {
	equip = function(v,weapon,owner)
	if owner:Team() == 2 then
		wear_types = { 
			'_factory_new_blue',
			'_minimal_wear_blue',
			'_feild_tested_blue',
			'_well_worn_blue',
			'_battle_scarred_blue'
		}
	else
		wear_types = { 
			'_factory_new_red',
			'_minimal_wear_red',
			'_feild_tested_red',
			'_well_worn_red',
			'_battle_scarred_red'
		}
	end
		if desired:GetInt() >= 1 and desired:GetInt() <= 5 then
			wear_number = GetConVar("wear_desired"):GetInt()
		else
			wear_number = math.random( #wear_types )
		end
	
		if SERVER then
			weapon.CustomMaterialOverride = v..wear_types[wear_number]
			weapon.CustomMaterialOverride2 = v..wear_types[wear_number]
		else
			weapon.CustomMaterialOverride = Material(v..wear_types[wear_number])
			weapon.CustomMaterialOverride2 = v..wear_types[wear_number]
		end
		
		if CLIENT then
			
			weapon.ViewModelDrawn0 = weapon.ViewModelDrawn
			weapon.ViewModelDrawn = function(self,t)
				if IsValid(self.CModel) then
					self.CModel:SetMaterial(v..wear_types[wear_number])
				end
				self:ViewModelDrawn0()
			end
		end	
		timer.Simple(0.02, function() weapon_name = weapon end)
		PrintSkin()
	end,
})

RegisterAttribute("nuke", {
	projectile_fired = function(v,proj,weapon,owner)
		proj.Nuke = true
	end,
	
	post_damage = function(v,ent,hitgroup,dmginfo)
		dmginfo:ScaleDamage(5)
	end,
})

RegisterAttribute("owner_receive_minicrits", {
	equip = function(v,weapon,owner)
		if SERVER then
			owner.TempAttributes.ReceiveCrits = true
		end
	end,
})

RegisterAttribute("mod_crit_noclip", {
	boolean = true,
	crit_override = function(v,ent,hitgroup,dmginfo)
		if ISPLAYER(ent) and ent:GetMoveType()==MOVETYPE_NOCLIP then return true end
	end,
})

RegisterAttribute("mod_enable_crotchshots", {
	boolean = true,
	
	crit_override = function(v,ent,hitgroup,dmginfo)
		if SERVER and ISPLAYER(ent) then
			local inf, att = dmginfo:GetInflictor(), dmginfo:GetAttacker()
			
			if inf.NonCrotchshotNameOverride == nil then
				inf.NonCrotchshotNameOverride = inf.NameOverride or false
			end
			
			if not inf.NonCrotchshotNameOverride then
				inf.NameOverride = nil
			else
				inf.NameOverride = inf.NonCrotchshotNameOverride
			end
			
			-- Weapon must be a sniper-type weapon (Sniper Rifle or Ambassador)
			if inf.IsTFWeapon and inf.BulletSpread == 0 and (inf.ChargeTimerStart or inf.CritsOnHeadshot) then
				local f1, f2 = ent:GetAngles(), att:GetAngles()
				f1.p = 0
				f2.p = 0
				local dot = f1:Forward():Dot(f2:Forward())
				
				-- Attacker and victim must be facing each other
				if dot > -0.5 then return end
				
				-- Pelvis bone check
				local bone
				bone = ent:GetBoneMatrix(ent:LookupBone("ValveBiped.Bip01_Pelvis") or ent:LookupBone("bip_pelvis") or -1)
				
				local dist = dmginfo:GetDamagePosition():Distance(bone:GetTranslation() - 3 * vector_up + 6*ent:GetForward())
				
				if dist < 8 then
					inf.NameOverride = "crotchshot"
					return true
				end
			end
		end
	end,
})

RegisterAttribute("milk_duration", {
	pre_damage = function(v,ent,hitgroup,dmginfo)
		local inf = dmginfo:GetInflictor()
		if inf:GetClass() == "tf_weapon_sniperrifle" and inf.ChargeTime then
			if not inf.ChargeTimerStart or (CurTime()-inf.ChargeTimerStart)/inf.ChargeTime < 0.25 then
				return
			end
		end
		
		local att = dmginfo:GetAttacker()
		if ent:IsTFPlayer() and ent~=att and ent:CanReceiveCrits() and att:IsValidEnemy(ent) then
			ent:AddPlayerState(PLAYERSTATE_MILK, true)
			ent.NextEndMilk = CurTime() + v
		end
	end,
	
	equip = function(v,weapon,owner)
		weapon.UsesJarateChargeMeter = true
	end,
})

RegisterAttribute("burn_duration", {
	pre_damage = function(v,ent,hitgroup,dmginfo)
		local att = dmginfo:GetAttacker()
		if ent:IsFlammable() and att:IsValidEnemy(ent) then
			GAMEMODE:IgniteEntity(ent, dmginfo:GetInflictor(), dmginfo:GetAttacker(), v)
		end
	end,
})

RegisterAttribute("set_grenade_mode", {
	equip = function(v,weapon,owner)
		weapon.GrenadeMode = v
	end,
	projectile_fired = function(v,proj,weapon,owner)
		proj.GrenadeMode = v
	end,
})

RegisterAttribute("projectile_model_mod", {
	equip = function(v,weapon,owner)
		owner.TempAttributes.ProjectileModelModifier = v
	end,
})


RegisterAttribute("radial_onhit_addhealth", {
	post_damage = function(v,ent,hitgroup,dmginfo)
		local att = dmginfo:GetAttacker()
		local pos = dmginfo:GetDamagePosition()
		
		if IsValid(att) and ent~=att and ent:IsTFPlayer() and ent:Health()>0 and not ent:IsBuilding() then
			for _,p in pairs(ents.FindInSphere(pos, 250)) do
				if p:IsTFPlayer() and not p:IsBuilding() and p:Health()>0 and p:EntityTeam()==att:EntityTeam() then
					GAMEMODE:HealPlayer(att, p, v, true, false)
				end
			end
		end
	end,
	projectile_fired = function(v,proj,weapon,owner) end,
})

RegisterAttribute("mult_dmgtaken_from_fall", {
	_global_post_damage_received = function(v,pl,hitgroup,dmginfo)
		if dmginfo:IsDamageType(DMG_FALL) then
			dmginfo:ScaleDamage(v)
		end
	end,
})

RegisterAttribute("mult_dmgtaken_from_phys", {
	_global_post_damage_received = function(v,pl,hitgroup,dmginfo)
		if dmginfo:IsDamageType(DMG_CRUSH) then
			dmginfo:ScaleDamage(v)
		end
	end,
})

RegisterAttribute("mult_player_jumpheight", {
	equip = function(v,weapon,owner)
		if SERVER then
			owner.PlayerJumpPower = owner.PlayerJumpPower * v
			owner:SetJumpPower(owner.PlayerJumpPower)
		end
	end,
})

RegisterAttribute("mod_jump_height_from_weapon", {
	equip = function(v,weapon,owner)
		if SERVER then
			owner.PlayerJumpPower = owner.PlayerJumpPower * v
			owner:SetJumpPower(owner.PlayerJumpPower)
		end
	end,
})

RegisterAttribute("set_charge_mode", {
	boolean = true,
	equip = function(v,weapon,owner)
		if SERVER then
			owner.TempAttributes.ChargeIsUnstoppable = true
		end
	end,
})

RegisterAttribute("mult_cooldown_time", {
	equip = function(v,weapon,owner)
		if SERVER then
			owner.TempAttributes.ChargeCooldownMultiplier = (owner.TempAttributes.ChargeCooldownMultiplier or 1) * v
		end
	end,
})

if SERVER then

hook.Add("ShouldMiniCrit", "GAYPLAYER_MINICRIT", function(ent, inf, att, hitgroup, dmginfo)
	if ent.TempAttributes and ent.TempAttributes.ReceiveCrits then
		return true
	end
end)

hook.Add("PostScaleDamage", "GAYPLAYER_NEGDAMAGE", function(ent, hitgroup, dmginfo)
	if ent:IsTFPlayer() then
		if dmginfo:GetAttacker():GetNWBool("VeryGay") and math.random()<0.5 then
			GAMEMODE:HealPlayer(nil, ent, dmginfo:GetDamage(), true, false)
			dmginfo:SetDamage(0)
			dmginfo:SetDamageType(DMG_GENERIC)
		end
	end
end)
-- wtf?
hook.Add("DoPlayerDeath", "GAYREMOVE", function(pl,attacker,dmginfo)
	if CLIENT then
		timer.Simple(2.0, function()
		
			if (attacker:EntIndex() != pl:EntIndex() and attacker:IsTFPlayer()) then
				ply:SendLua('RunConsoleCommand("snd_soundmixer","Default_Mix")')
			end
			
		end)
	end
	pl:SetNWBool("VeryGay", false)
	pl.NextEndGay = 0
end)

end

if CLIENT then

hook.Add("SetupPlayerGib", "GEYGIB", function(pl, gib)
end)

hook.Add("SetupPlayerRagdoll", "GEYRAGDOLL_PLAYER", function(pl, rag)
end)

hook.Add("SetupNPCRagdoll", "GEYRAGDOLL_NPC", function(npc, rag)
end)

end

-- Loading everything up

--tf_items.ParseGameItems(item_data)

--MsgN("Done!")
