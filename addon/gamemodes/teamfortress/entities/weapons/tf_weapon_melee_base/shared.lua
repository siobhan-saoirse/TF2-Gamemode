if SERVER then
	AddCSLuaFile( "shared.lua" )
end

if CLIENT then
	SWEP.PrintName			= "Melee"
end

SWEP.Base				= "tf_weapon_base"

SWEP.ViewModel			= "models/weapons/v_models/v_bat_scout.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_bat.mdl"

SWEP.Primary.Ammo			= "none"

SWEP.HoldType = "MELEE"
SWEP.IsMeleeWeapon = true
SWEP.Swing = Sound("")
SWEP.SwingCrit = Sound("")
SWEP.HitFlesh = Sound("")
SWEP.HitRobot = Sound("MVM_Weapon_Default.HitFlesh")
SWEP.HitWorld = Sound("")

SWEP.MeleeAttackDelay = 0.15
--SWEP.MeleeAttackDelayCritical = 0.25
SWEP.MeleeRange = 60

SWEP.MaxDamageRampUp = 0
SWEP.MaxDamageFalloff = 0

SWEP.CriticalChance = 15
SWEP.HasThirdpersonCritAnimation = false
SWEP.NoHitSound = false

SWEP.ForceMultiplier = 5000
SWEP.CritForceMultiplier = 10000
SWEP.ForceAddPitch = 0
SWEP.CritForceAddPitch = 0

SWEP.DamageType = DMG_CLUB
SWEP.CritDamageType = DMG_CLUB

SWEP.MeleePredictTolerancy = 0.5

SWEP.HasCustomMeleeBehaviour = false

SWEP.VM_HITCENTER = ACT_VM_HITCENTER
SWEP.VM_SWINGHARD = ACT_VM_SWINGHARD

SWEP.CriticalChance = 18
SWEP.HullAttackVector = Vector(10, 10, 15)

local FleshMaterials = {
	[MAT_ANTLION] = true,
	[MAT_BLOODYFLESH] = true,
	[MAT_FLESH] = true,
	[MAT_ALIENFLESH] = true,
}

function SWEP:GetPrimaryFireActivity()
	if self.UsesLeftRightAnim then
		return self.VM_HITLEFT
	else
		return self.VM_HITCENTER
	end
end

function SWEP:GetSecondaryFireActivity()
	if self.UsesLeftRightAnim then
		return self.VM_HITRIGHT
	else
		return ACT_INVALID
	end
end

function SWEP:CanPrimaryAttack()
	if (self.Owner:GetNWBool("Bonked",false) == true) then return false end
	return true
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:OnMeleeAttack(tr)
end


function SWEP:InspectAnimCheck()
	-- todo: find a better way to do this
	-- InspectAnimCheck probably isn't the best place for this...
	if (string.StartWith(self.Owner:GetModel(),"models/infected/")) then return end
		if self:GetVisuals() then
			if self:GetItemData().image_inventory == "backpack/weapons/v_models/v_fist_heavy" then			
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
				elseif self.Owner:GetPlayerClass() == "boomer" then
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
				self.HoldType = "FISTS"
				self:SetHoldType("MELEE")
			else
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

					if replace.act_vm_hitcenter then
						self.VM_HITCENTER = getfenv()[replace.act_vm_hitcenter]
					end
					if replace.act_vm_hitcenter2 then
						self.VM_HITCENTER2 = getfenv()[replace.act_vm_hitcenter2]
					end
					if replace.act_vm_hitleft then
						self.VM_HITLEFT = getfenv()[replace.act_vm_hitleft]
					end

					if replace.act_vm_hitright then
						self.VM_HITRIGHT = getfenv()[replace.act_vm_hitright]
					end

					if replace.act_vm_swinghard then
						self.VM_SWINGHARD = getfenv()[replace.act_vm_swinghard]
					end

					if replace.act_vm_reload then
						self.VM_RELOAD = getfenv()[replace.act_vm_reload]
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

					if replace.act_backstab_vm_down then
						self.BACKSTAB_VM_DOWN = getfenv()[replace.act_backstab_vm_down]
					end

					if replace.act_backstab_vm_idle then
						self.BACKSTAB_VM_IDLE = getfenv()[replace.act_backstab_vm_idle]
					end

					if replace.act_backstab_vm_up then
						self.BACKSTAB_VM_UP = getfenv()[replace.act_backstab_vm_up]
					end
				end

				if visuals.sound_single_shot then
					self.ShootSound = Sound(visuals.sound_single_shot)
				end

				if visuals.sound_melee_miss then
					self.Swing = Sound(visuals.sound_melee_miss)
				end

				if visuals.sound_melee_hit then
					self.HitFlesh = Sound(visuals.sound_melee_hit)
				end
				if visuals.sound_melee_hit_world then
					self.HitWorld = Sound(visuals.sound_melee_hit_world)
				end


				if visuals.sound_burst then
					self.SwingCrit = Sound(visuals.sound_burst)
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

		if (self:GetItemData().name == "Your Eternal Reward" or self:GetItemData().name == "Wanga Prick" ) then

			self.VM_DRAW = ACT_ITEM2_VM_DRAW
			self.VM_IDLE = ACT_ITEM2_VM_IDLE
			self.VM_HITCENTER = ACT_ITEM2_VM_HITCENTER
			self.VM_SWINGHARD = ACT_ITEM2_VM_SWINGHARD
			self.BACKSTAB_VM_DOWN = ACT_ITEM2_BACKSTAB_VM_DOWN
			self.BACKSTAB_VM_IDLE = ACT_ITEM2_BACKSTAB_VM_IDLE
			self.BACKSTAB_VM_UP = ACT_ITEM2_BACKSTAB_VM_UP
			
		end
	self:CallBaseFunction("InspectAnimCheck")
end

local function OpenLinkedAreaPortal(ent)
	local name = ent:GetName()
	if not name or name == "" then return end
	
	for _,v in pairs(ents.FindByClass("func_areaportal")) do
		if v.TargetDoorName == name then
			v:Fire("Open")
		end
	end
end
function SWEP:OnMeleeHit(tr)
	if CLIENT then return end
	if (tr.Entity:GetModel() and string.find(tr.Entity:GetModel(),"door")) then
		local ang = self.Owner:EyeAngles()
		dir = ang:Forward()
		if (!self.HitDoor) then
			self.HitDoor = 1
		else
			self.HitDoor = self.HitDoor + 1
		end
		if (self.Owner:GetPlayerClass() != "tank") then
			if (self.HitDoor > 2) then
				self.HitDoor = 0
				local p = ents.Create("prop_physics")
				p:SetModel(tr.Entity:GetModel())
				p:SetBodygroup(1, 1)
				p:SetSkin(tr.Entity:GetSkin())
				p:SetPos(tr.Entity:GetPos())
				p:SetAngles(tr.Entity:GetAngles())
				
				OpenLinkedAreaPortal(tr.Entity)
				tr.Entity:Remove()
				p:Spawn()
				
				local vel = self.Owner:GetAimVector():Angle()
				vel.p = vel.p + self.AddPitch
				vel = vel:Forward() * 1000 * 100 
				local phys = p:GetPhysicsObject()
				if phys and phys:IsValid() then
					phys:ApplyForceCenter(vel)
					p:SetPhysicsAttacker(self.Owner)
				end
			end
		else
			if (self.HitDoor > 0) then
				self.HitDoor = 0
				local p = ents.Create("prop_physics")
				p:SetModel(tr.Entity:GetModel())
				p:SetBodygroup(1, 1)
				p:SetSkin(tr.Entity:GetSkin())
				p:SetPos(tr.Entity:GetPos())
				p:SetAngles(tr.Entity:GetAngles())
				
				OpenLinkedAreaPortal(tr.Entity)
				tr.Entity:Remove()
				p:Spawn()
				
				local vel = self.Owner:GetAimVector():Angle()
				vel.p = vel.p + self.AddPitch
				vel = vel:Forward() * self.Force * 100 
				local phys = p:GetPhysicsObject()
				if phys and phys:IsValid() then
					phys:ApplyForceCenter(vel)
					p:SetPhysicsAttacker(self.Owner)
				end
			end
		end

	end
	if self:GetItemData().model_player == "models/workshop/weapons/c_models/c_xms_gloves/c_xms_gloves.mdl" then
		local ent = tr.Entity
		if not (ent:IsTFPlayer() and self.Owner:CanDamage(ent) and not ent:IsBuilding()) then return end
		
		local InflictorClass = gamemode.Call("GetInflictorClass", ent, self.Owner, self)
		
		umsg.Start("Notice_EntityHumiliationLaughCounter")
			umsg.String(GAMEMODE:EntityName(ent))
			umsg.Short(GAMEMODE:EntityTeam(ent))
			umsg.Short(GAMEMODE:EntityID(ent))
			
			umsg.String(InflictorClass)
			
			umsg.String(GAMEMODE:EntityName(self.Owner))
			umsg.Short(GAMEMODE:EntityTeam(self.Owner))
			umsg.Short(GAMEMODE:EntityID(self.Owner))
			
			--[[
			umsg.String(GAMEMODE:EntityName(cooperator))
			umsg.Short(GAMEMODE:EntityTeam(cooperator))
			umsg.Short(GAMEMODE:EntityID(cooperator))]]
			
			umsg.Bool(self.CurrentShotIsCrit)
		umsg.End()
	end
end

function SWEP:MeleeHitSound(tr)
	--MsgFN("MeleeHitSound %f", CurTime())
	if CLIENT then
		return
	end
	
	if tr.Entity and IsValid(tr.Entity) then
		if tr.Entity:IsTFPlayer() then
			if tr.Entity:IsBuilding() then
				--self:EmitSound(self.HitWorld)
				--sound.Play(self.HitWorld, tr.HitPos)
				if SERVER then
				sound.Play(self.HitWorld, self:GetPos())
				end
			else
				--self:EmitSound(self.HitFlesh)
				--sound.Play(self.HitFlesh, tr.HitPos)
				if tr.Entity:IsPlayer() and not tr.Entity:IsHL2() and tr.Entity:GetInfoNum("tf_robot",0) == 1 then
					
					if SERVER then
						sound.Play(self.HitRobot, self:GetPos())
					end
				elseif tr.Entity:IsPlayer() and not tr.Entity:IsHL2() and tr.Entity:GetInfoNum("tf_giant_robot",0) == 1 then
					
					if SERVER then
						sound.Play(self.HitRobot, self:GetPos())
					end

					
				elseif tr.Entity:IsPlayer() and not tr.Entity:IsHL2() and tr.Entity:Team() == TEAM_BLU and string.find(game.GetMap(), "mvm_") then
					if SERVER then
						sound.Play(self.HitRobot, self:GetPos())
					end
					
				elseif tr.Entity:IsPlayer() and not tr.Entity:IsHL2() and tr.Entity:Team() == TF_TEAM_PVE_INVADERS then
					if SERVER then
						sound.Play(self.HitRobot, self:GetPos())
					end

					

				elseif tr.Entity:IsPlayer() and not tr.Entity:IsHL2() and tr.Entity:GetInfoNum("tf_sentrybuster",0) == 1 then
					if SERVER then
						sound.Play(self.HitRobot, self:GetPos())
					end


				elseif tr.Entity:IsPlayer() and tr.Entity:IsHL2() then
					if SERVER then
						sound.Play(self.HitFlesh, self:GetPos())
					end

				elseif tr.Entity:IsPlayer() and not tr.Entity:IsHL2() and tr.Entity:GetInfoNum("tf_robot",0) != 1 and tr.Entity:GetInfoNum("tf_giant_robot",0) != 1 and tr.Entity:GetInfoNum("tf_sentrybuster",0) != 1 then
				
					if SERVER then
						sound.Play(self.HitFlesh, self:GetPos())
					end
				
				elseif tr.Entity:IsNPC() then
				
					if SERVER then
						sound.Play(self.HitFlesh, self:GetPos())
					end
					
				elseif tr.Entity.Base == "npc_tf2base" or tr.Entity.Base == "npc_demo_red" or tr.Entity.Base == "npc_hwg_red" or tr.Entity.Base == "npc_soldier_red" or tr.Entity.Base == "npc_sniper_red" or tr.Entity.Base == "npc_spy_red" or tr.Entity.Base == "npc_scout_red" or tr.Entity.Base == "npc_pyro_red" or tr.Entity.Base == "npc_medic_red" or tr.Entity.Base == "npc_engineer_red" or tr.Entity:GetClass() == "headless_hatman" then
				
					if SERVER then
						sound.Play(self.HitFlesh, self:GetPos())
					end
					
				elseif tr.Entity:GetClass() == "tf_zombie" then 				
					if SERVER then
						sound.Play(self.HitFlesh, self:GetPos())
					end
					
				elseif tr.Entity.Base == "npc_tf2base_mvm" or tr.Entity.Base == "npc_heavy_mvm" then
				
					if SERVER then
						sound.Play(self.HitRobot, self:GetPos())
					end
					
				end
					
			end
		else
			if not self.NoHitSound then
				if FleshMaterials[tr.Entity:GetMaterialType()] then
					--self:EmitSound(self.HitFlesh)
					--sound.Play(self.HitFlesh, tr.HitPos)
					sound.Play(self.HitFlesh, self:GetPos())
				else
					--self:EmitSound(self.HitWorld)
					--sound.Play(self.HitWorld, tr.HitPos)
					
					if (string.find(tr.Entity:GetModel(),"door")) then
						sound.Play(self.HitWorld, self:GetPos())
						self.Owner:EmitSound("physics/wood/wood_panel_impact_hard1.wav",95)
					else
						sound.Play(self.HitWorld, self:GetPos())
					end
				end
			end
		end
	else
		if not self.NoHitSound then
			--self:EmitSound(self.HitWorld)
			--sound.Play(self.HitWorld, tr.HitPos)
			sound.Play(self.HitWorld, self:GetPos())
		end
	end
end

function SWEP:MeleeCritical(tr)
	local b = gamemode.Call("ShouldCrit", tr.Entity, self, self.Owner)
	
	if b ~= nil and b ~= self.CurrentShotIsCrit then
		self.CurrentShotIsCrit = b
		self.CritTime = CurTime()
		return b
	end
end

function SWEP:MeleeAttack(dummy)
	local pos = self.Owner:GetShootPos()
	local ang = self.Owner:GetAimVector()
	local endpos
	
	if SERVER and not dummy and game.SinglePlayer() then
		self:CallOnClient("MeleeAttack","")
	end
	
	if self.Owner:GetInfoNum("tf_giant_robot",0) == 1 then
		self.MeleeRange = 200
	end
	
	if CLIENT and dummy=="" then
		dummy = false
	end
	
	local scanmul = 1 + self.MeleePredictTolerancy
	
	if dummy then
		-- When doing a dummy melee attack, perform a wider scan for better prediction
		endpos = pos + self.Owner:GetAimVector() * (self.MeleeRange * self.Owner:GetModelScale()) * scanmul
	else
		endpos = pos + self.Owner:GetAimVector() * (self.MeleeRange * self.Owner:GetModelScale())
	end
	
	local hitent, hitpos
	
	if not dummy then
		self.Owner:LagCompensation(true)
	end
	
	local tr = util.TraceLine {
		start = pos,
		endpos = endpos,
		filter = self.Owner
	}
	
	if not tr.Hit then
		local mins, maxs
		local v = self.HullAttackVector
		if dummy then
			mins, maxs = scanmul * Vector(-v.x, -v.y, -v.z), scanmul * Vector(v.x, v.y, v.z)
		else
			mins, maxs = Vector(-v.x, -v.y, -v.z), Vector(v.x, v.y, v.z)
		end
		
		tr = util.TraceHull {
			start = pos,
			endpos = endpos,
			filter = self.Owner,
		
			mins = mins,
			maxs = maxs,
		}
	end
	if self.Owner:GetPlayerClass() == "spy" then
		if self.Owner:GetModel() == "models/player/scout.mdl" or  self.Owner:GetModel() == "models/player/soldier.mdl" or  self.Owner:GetModel() == "models/player/pyro.mdl" or  self.Owner:GetModel() == "models/player/demo.mdl" or  self.Owner:GetModel() == "models/player/heavy.mdl" or  self.Owner:GetModel() == "models/player/engineer.mdl" or  self.Owner:GetModel() == "models/player/medic.mdl" or  self.Owner:GetModel() == "models/player/sniper.mdl" or  self.Owner:GetModel() == "models/player/hwm/spy.mdl" or self.Owner:GetModel() == "models/player/kleiner.mdl" then
			if self.Owner:KeyDown( IN_ATTACK ) then
				if self.Owner:GetInfoNum("tf_robot", 0) == 0 then
					self.Owner:SetModel("models/player/spy.mdl") 
				else
					self.Owner:SetModel("models/bots/spy/bot_spy.mdl")
				end
				if IsValid( button) then 
					button:Remove() 
				end
				for _,v in pairs(ents.GetAll()) do
					if v:IsNPC() and not v:IsFriendly(self.Owner) then
						if SERVER then
							v:AddEntityRelationship(self.Owner, D_HT, 99)
						end
					end
				end
				if self.Owner:Team() == TEAM_BLU then 
					self.Owner:SetSkin(1) 
				elseif self.Owner:Team() == TF_TEAM_PVE_INVADERS then 
					self.Owner:SetSkin(1) 
				else 
					self.Owner:SetSkin(0) 
				end
				 
				local ply = self.Owner
				if (ply:GetModel() == "models/player/scout.mdl") then
					ply.playerclass = "Scout"
				elseif (ply:GetModel() == "models/player/soldier.mdl") then
					ply.playerclass = "Soldier"
				elseif (self:GetModel() == "models/player/pyro.mdl") then
					ply.playerclass = "Pyro"
				elseif (ply:GetModel() == "models/player/demo.mdl") then
					ply.playerclass = "Demoman"
				elseif (ply:GetModel() == "models/player/heavy.mdl") then
					ply.playerclass = "Heavy"
				elseif (ply:GetModel() == "models/player/engineer.mdl") then
					ply.playerclass = "Engineer"
				elseif (ply:GetModel() == "models/player/medic.mdl") then
					ply.playerclass = "Medic"
				elseif (ply:GetModel() == "models/player/sniper.mdl") then
					ply.playerclass = "Medic"
				else
					local class = ply:GetPlayerClass()
					ply.playerclass = string.upper(string.sub(class,1,1))..string.sub(class,2)	
				end			
				self.Owner:EmitSound("player/spy_disguise.wav", 65, 100) 
			end
		end
	end
	
	if not dummy then
		self.Owner:LagCompensation(false)
	end
	
	--MsgN(Format("HELLO %s",tostring(dummy)))
	if dummy then return tr end
	
	self:OnMeleeAttack(tr)
	
	local damagedself = false
	if self.MeleeHitSelfOnMiss and not tr.HitWorld and not IsValid(tr.Entity) then
		damagedself = true
		tr.Entity = self.Owner
	end
	local l4dRange = (90 * self.Owner:GetModelScale())
	if (self.Owner:GetPlayerClass() == "tank_l4d") then
		l4dRange = (118 * self.Owner:GetModelScale())
	end
	for k,v in ipairs(ents.FindInSphere(self.Owner:GetPos(), l4dRange)) do
		if (v and v:IsValid() and self.Owner:IsL4D() and v:IsTFPlayer() and v:EntIndex() != self.Owner:EntIndex() and v:Health() > 0) then

			--local ang = (endpos - pos):GetNormal():Angle()
			local ang = self.Owner:EyeAngles()
			local dir = ang:Forward()
			hitpos = v:NearestPoint(self.Owner:GetShootPos()) - 2 * dir
			tr.HitPos = hitpos
		
				if SERVER then
					local mcrit = self:MeleeCritical(tr)
					
					local pitch, mul, dmgtype
					if self.CurrentShotIsCrit then
						dmgtype = self.CritDamageType
						pitch, mul = self.CritForceAddPitch, self.CritForceMultiplier
					else
						dmgtype = self.DamageType
						pitch, mul = self.ForceAddPitch, self.ForceMultiplier
					end

					
					if v:ShouldReceiveDefaultMeleeType() then
						dmgtype = DMG_CLUB
					end
					
					ang.p = math.Clamp(math.NormalizeAngle(ang.p - pitch), -90, 90)
					local force_dir = ang:Forward() * 0.2
					
					self:PreCalculateDamage(v)
					local dmg = self:CalculateDamage(nil, v)
					--dmg = self:PostCalculateDamage(dmg, v)
					
					local dmginfo = DamageInfo()
						dmginfo:SetAttacker(self.Owner)
						dmginfo:SetInflictor(self)
						dmginfo:SetDamage(dmg)
						dmginfo:SetDamageType(dmgtype)
						dmginfo:SetDamagePosition(hitpos)
						dmginfo:SetDamageForce(dmg * force_dir * (mul * 0.2))
					if damagedself then
						force_dir.x = -force_dir.x
						force_dir.y = -force_dir.y
						dmginfo:SetDamageForce(dmg * force_dir * (mul * 0.5))
						v:DispatchBloodEffect()
						v:TakeDamageInfo(dmginfo)
					else
						v:DispatchTraceAttack(dmginfo, hitpos, hitpos + 5*dir)
						if (self.Owner:GetPlayerClass() == "tank_l4d") then
							
							local vel = self.Owner:GetAimVector():Angle()
							vel.p = vel.p + self.AddPitch
							vel = vel:Forward() * 1000
							v:SetVelocity(vel)
						end
					end
					
					local phys = v:GetPhysicsObject()
					if phys and phys:IsValid() then
						v:SetPhysicsAttacker(self.Owner)
						if (self.Owner:GetPlayerClass() == "tank_l4d") then
							
							if phys and phys:IsValid() then
								local vel = self.Owner:GetAimVector():Angle()
								vel.p = vel.p + self.AddPitch
								vel = vel:Forward() * 4000 * 100 * (phys:GetMass() * 0.004)
								phys:ApplyForceCenter(vel)
							end
						end
					end
					-- Fire a bullet clientside, just for decals and blood effects
					
				if util.TraceLine({start=hitpos,endpos=hitpos+4*dir}).Entity == v then
					if CLIENT then
						self:FireBullets{
							Src=hitpos,
							Dir=dir,
							Spread=Vector(0,0,0),
							Num=1,
							Damage=1,
							Tracer=0,
						}
					end
				end
				end
			
			if SERVER then
				v:EmitSound(self.HitFlesh)
				if (self.Owner:GetPlayerClass() == "charger") then
					v:EmitSound(self.HitFlesh)
				end
			end
			
		end
	end
	if tr.Entity and tr.Entity:IsValid() then
		--local ang = (endpos - pos):GetNormal():Angle()
		local ang = self.Owner:EyeAngles()
		local dir = ang:Forward()
		hitpos = tr.Entity:NearestPoint(self.Owner:GetShootPos()) - 2 * dir
		tr.HitPos = hitpos
		if (tr.Entity:IsTFPlayer() and self.Owner:IsL4D()) then return end
			if SERVER then
				local mcrit = self:MeleeCritical(tr)
				
				local pitch, mul, dmgtype
				if self.CurrentShotIsCrit then
					dmgtype = self.CritDamageType
					pitch, mul = self.CritForceAddPitch, self.CritForceMultiplier
				else
					dmgtype = self.DamageType
					pitch, mul = self.ForceAddPitch, self.ForceMultiplier
				end

				
				if tr.Entity:ShouldReceiveDefaultMeleeType() then
					dmgtype = DMG_CLUB
				end
				
				ang.p = math.Clamp(math.NormalizeAngle(ang.p - pitch), -90, 90)
				local force_dir = ang:Forward()
				
				self:PreCalculateDamage(tr.Entity)
				local dmg = self:CalculateDamage(nil, tr.Entity)
				--dmg = self:PostCalculateDamage(dmg, tr.Entity)
				
				local dmginfo = DamageInfo()
					dmginfo:SetAttacker(self.Owner)
					dmginfo:SetInflictor(self)
					dmginfo:SetDamage(dmg)
					dmginfo:SetDamageType(dmgtype)
					dmginfo:SetDamagePosition(hitpos)
					dmginfo:SetDamageForce(dmg * force_dir * (mul * 0.2))
				if damagedself then
					force_dir.x = -force_dir.x
					force_dir.y = -force_dir.y
					dmginfo:SetDamageForce(dmg * force_dir * (mul * 0.5))
					tr.Entity:DispatchBloodEffect()
					tr.Entity:TakeDamageInfo(dmginfo)
				else
					tr.Entity:DispatchTraceAttack(dmginfo, hitpos, hitpos + 5*dir)
					if (self.Owner:GetPlayerClass() == "tank_l4d") then
						
						local vel = self.Owner:GetAimVector():Angle()
						vel.p = vel.p + self.AddPitch
						vel = vel:Forward() * 1000
						tr.Entity:SetVelocity(vel)
					end
				end
				
				local phys = tr.Entity:GetPhysicsObject()
				if phys and phys:IsValid() then
					tr.Entity:SetPhysicsAttacker(self.Owner)
					if (self.Owner:GetPlayerClass() == "tank_l4d") then
						
						if phys and phys:IsValid() then
							local vel = self.Owner:GetAimVector():Angle()
							vel.p = vel.p + self.AddPitch
							vel = vel:Forward() * 4000 * 100 * (phys:GetMass() * 0.004)
							phys:ApplyForceCenter(vel)
						end
					end
				end
				-- Fire a bullet clientside, just for decals and blood effects
				
			if util.TraceLine({start=hitpos,endpos=hitpos+4*dir}).Entity == tr.Entity then
				if CLIENT then
					self:FireBullets{
						Src=hitpos,
						Dir=dir,
						Spread=Vector(0,0,0),
						Num=1,
						Damage=1,
						Tracer=0,
					}
				end
			end
			end
		local range = (self.MeleeRange * self.Owner:GetModelScale()) + 18
		local dir = self.Owner:GetAimVector()
		
		if not util.TraceLine({start=pos,endpos=pos+range*dir}).Hit then
			local ang = self.Owner:EyeAngles()
			ang.y = ang.y + 25
			local dir1 = ang:Forward()
			ang.y = ang.y - 50
			local dir2 = ang:Forward()
			
			local tr1 = util.TraceLine({start=pos,endpos=pos+range*dir1})
			local tr2 = util.TraceLine({start=pos,endpos=pos+range*dir2})
			
			if not tr1.Hit and not tr2.Hit then
				dir = nil
			elseif tr1.Fraction > tr2.Fraction then
				dir = dir2
				tr.HitPos = tr2.HitPos
			else
				dir = dir1
				tr.HitPos = tr1.HitPos
			end
		end
		if dir and !self.Owner:IsL4D() then
			if CLIENT then
				if (!tr.Entity:IsFriendly(self.Owner)) then
					self:FireBullets{
						Src=pos,
						Dir=dir,
						Spread=Vector(0,0,0),
						Num=1,
						Damage=1,
						Tracer=0,
					}
				end
			end
		end
		self:MeleeHitSound(tr)
		self:OnMeleeHit(tr)
	elseif tr.HitWorld then
		local range = (self.MeleeRange * self.Owner:GetModelScale()) + 18
		local dir = self.Owner:GetAimVector()
		
		if not util.TraceLine({start=pos,endpos=pos+range*dir}).Hit then
			local ang = self.Owner:EyeAngles()
			ang.y = ang.y + 25
			local dir1 = ang:Forward()
			ang.y = ang.y - 50
			local dir2 = ang:Forward()
			
			local tr1 = util.TraceLine({start=pos,endpos=pos+range*dir1})
			local tr2 = util.TraceLine({start=pos,endpos=pos+range*dir2})
			
			if not tr1.Hit and not tr2.Hit then
				dir = nil
			elseif tr1.Fraction > tr2.Fraction then
				dir = dir2
				tr.HitPos = tr2.HitPos
			else
				dir = dir1
				tr.HitPos = tr1.HitPos
			end
		end
		if dir and !self.Owner:IsL4D() then
			if CLIENT then
				self:FireBullets{
					Src=pos,
					Dir=dir,
					Spread=Vector(0,0,0),
					Num=1,
					Damage=1,
					Tracer=0,
				}
			end
		end
		
		self:MeleeHitSound(tr)
		self:OnMeleeHit(tr)
	end
end

--[[
usermessage.Hook("DoMeleeSwing", function(msg)
	local wp = msg:ReadEntity()
	local crit = msg:ReadBool()
	
	if crit then
		wp:EmitSound(wp.SwingCrit, 100, 100)
	else
		wp:EmitSound(wp.Swing, 100, 100)
	end
end)]]

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	local vm = self.Owner:GetViewModel()
	if self:CriticalEffect() then
		--MsgN(Format("[%f] From SWEP:PrimaryAttack (%s) : Critical hit!", CurTime(), tostring(self)))
		self:EmitSound(self.SwingCrit, 100, 100)
		--[[if SERVER then
			self:EmitSound(self.SwingCrit, 100, 100)
			umsg.Start("DoMeleeSwing",self.Owner)
				umsg.Entity(self)
				umsg.Bool(true)
			umsg.End()
		end]]
		
		if IsValid(vm) then
			if SERVER then
				self:SendWeaponAnimEx(self.VM_SWINGHARD)
			end
		end
		if self.HasThirdpersonCritAnimation then
			self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_SECONDARYFIRE, true)
		elseif self.HasThirdpersonCritAnimation2 then
			self.Owner:DoAnimationEvent(ACT_DOD_PRONE_ZOOMED, true)
		else
			self.Owner:SetAnimation(PLAYER_ATTACK1)
		end
	else
		self:EmitSound(self.Swing, 100, 100)
		--[[if SERVER then
			self:EmitSound(self.Swing, 100, 100)
			umsg.Start("DoMeleeSwing",self.Owner)
				umsg.Entity(self)
				umsg.Bool(false)
			umsg.End()
		end]]
		
		if self.UsesLeftRightAnim then
			if IsValid(vm) then
				if SERVER then
					self:SendWeaponAnimEx(self.VM_HITLEFT)
				end
			end
		else
			if IsValid(vm) then
				if SERVER then
					self:SendWeaponAnimEx(self.VM_HITCENTER)
				end
			end
		end
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
	
	if self.HasCustomMeleeBehaviour then return true end
	
	if SERVER and IsValid(self.Owner.TargeEntity) then
		self.Owner.TargeEntity:OnMeleeSwing()
	end
	
	if SERVER  then
		self.Owner:Speak("TLK_FIREWEAPON", true)
	end
	
	self.NextIdle = CurTime() + self:SequenceDuration(vm:SelectWeightedSequence(self.VM_HITCENTER))  
	
	--self.NextMeleeAttack = CurTime() + self.MeleeAttackDelay
	if not self.NextMeleeAttack then
		self.NextMeleeAttack = {}
	end
	
	self:StopTimers()
	
	if IsFirstTimePredicted() then 
		table.insert(self.NextMeleeAttack, CurTime() + self.MeleeAttackDelay)
	end
	return true
end

function SWEP:SecondaryAttack()
	if not self:CallBaseFunction("SecondaryAttack") then return false end
	
	if self.HasCustomMeleeBehaviour then return true end
	
	if self:CriticalEffect() then
		self:EmitSound(self.SwingCrit, 100, 100)
		--[[if SERVER then
			self:EmitSound(self.SwingCrit, 100, 100)
			umsg.Start("DoMeleeSwing",self.Owner)
				umsg.Entity(self)
				umsg.Bool(true)
			umsg.End()
		end]]
		self:SendWeaponAnimEx(self.VM_SWINGHARD)
		if self.HasThirdpersonCritAnimation then
			self.Owner:DoAnimationEvent(ACT_MP_ATTACK_STAND_SECONDARYFIRE, true)
		elseif self.HasThirdpersonCritAnimation2 then
			self.Owner:DoAnimationEvent(_G["ACT_MP_THROW"], true)
		else
			self.Owner:SetAnimation(PLAYER_ATTACK1)
		end
	else
		self:EmitSound(self.Swing, 100, 100)
		--[[if SERVER then
			self:EmitSound(self.Swing, 100, 100)
			umsg.Start("DoMeleeSwing",self.Owner)
				umsg.Entity(self)
				umsg.Bool(false)
			umsg.End()
		end]]
		
		self:SendWeaponAnim(self.VM_HITRIGHT)
		self.Owner:SetAnimation(PLAYER_ATTACK1)
	end
	
	--self.NextMeleeAttack = CurTime() + self.MeleeAttackDelay
	if not self.NextMeleeAttack then
		self.NextMeleeAttack = {}
	end
	
	if IsFirstTimePredicted() then 
		table.insert(self.NextMeleeAttack, CurTime() + self.MeleeAttackDelay)
	end
end

function SWEP:CanPrimaryAttack()
	if (self.Owner:GetNWBool("Bonked",false) == true) then return false end
	return true
end

function SWEP:CanSecondaryAttack()
	return true
end

function SWEP:ShootEffects()
end

function SWEP:Deploy()
	self:StopTimers()
	
	return self:CallBaseFunction("Deploy")
end

function SWEP:OnRemove()
	self:StopTimers()
	
	return self:CallBaseFunction("OnRemove")
end

function SWEP:Think()
	if self.WorldModel == "models/weapons/c_models/c_headtaker/c_headtaker.mdl" then
		self.HitFlesh = Sound("Halloween.HeadlessBossAxeHitFlesh")
		self.HitWorld = Sound("Halloween.HeadlessBossAxeHitWorld")
	end	

	while self.NextMeleeAttack and self.NextMeleeAttack[1] and CurTime() > self.NextMeleeAttack[1] and IsFirstTimePredicted() do
		self:MeleeAttack()
		table.remove(self.NextMeleeAttack, 1)
		
		self:RollCritical()
	end
	self:CallBaseFunction("Think")
	
	--if self.NextMeleeAttack and CurTime()>=self.NextMeleeAttack then
end

function SWEP:Holster()
	self.NextMeleeAttack = nil
	
	self:StopTimers()
	
	return self:CallBaseFunction("Holster")
end