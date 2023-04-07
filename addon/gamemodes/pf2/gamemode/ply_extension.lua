
-- General player extensions
local allowedtaunts = {
	"1",
	"2",
	"3",
	}
	
	rockpaperscissors = {
		"taunt_rps_scissors_win",
		"taunt_rps_scissors_lose",
		"taunt_rps_paper_win",
		"taunt_rps_paper_lose",
		"taunt_rps_rock_win",
		"taunt_rps_rock_lose",
	}
	rockpaperscissors2 = {
		"taunt_rps_scissors_lose",
		"taunt_rps_scissors_win",
		"taunt_rps_paper_lose",
		"taunt_rps_paper_win",
		"taunt_rps_rock_lose",
		"taunt_rps_rock_win",
	}
	rockpaperscissorsact = {
		ACT_DOD_SPRINT_IDLE_BAR,
		ACT_DOD_PRONEWALK_IDLE_BAR,
		ACT_DOD_ZOOMLOAD_BAZOOKA,
		ACT_DOD_RELOAD_PSCHRECK,
		ACT_DOD_ZOOMLOAD_PSCHRECK,
		ACT_DOD_RELOAD_DEPLOYED_FG42,
	}
	
	local class_hidewep = {
	"scout",
	"soldier",
	"pyro",
	"engineer",
	"medic",
	}
	
	local wep = {
	"tf_weapon_medigun",
	"tf_weapon_pistol_scout",
	"tf_weapon_rocketlauncher",
	"tf_weapon_shotgun_pyro",
	"tf_weapon_shotgun_primary",
	"tf_weapon_syringegun_medic",
	}
	
local meta = FindMetaTable( "Player" )
if (!meta) then return end 
local builds = {}
builds[2] = "obj_sentrygun"
builds[0] = "obj_dispenser"
builds[1] = "obj_teleporter"
local Player = FindMetaTable("Player")
local oNick = Player.Nick
local oPlayer = Player.IsPlayer
 
function Player:DoTauntEvent(data)	
	self:AddVCDSequenceToGestureSlot(GESTURE_SLOT_CUSTOM, self:LookupSequence(data), 0, true)
end  
function Player:IsPlayer()
	return oPlayer(self)
end
function Player:Nick()
	return oNick(self)
end
Player.Name = Player.Nick
Player.GetName = Player.Nick

function RegisterStatType(obj, name)
	local name_get = name
	local name_set = "Set"..name
	local name_add = "Add"..name
	local name_umsg = "__playerSet"..name
	
	obj[name_get] = function(self)
		if not self.Stats then self.Stats = {} end
		return self.Stats[name] or 0
	end
	
	if SERVER then
		obj[name_set] = function(self, val)
			if not self.Stats then self.Stats = {} end
			self.Stats[name] = val
			umsg.Start(name_umsg)
				umsg.Entity(self)
				umsg.Long(val)
			umsg.End()
		end
		
		obj[name_add] = function(self, val)
			self[name_set](self, self[name_get](self) + val)
		end
	else
		usermessage.Hook(name_umsg, function(msg)
			local self = msg:ReadEntity()
			if not IsValid(self) or not self:IsPlayer() then return end
			if not self.Stats then self.Stats = {} end
			self.Stats[name] = msg:ReadLong()
		end)
	end
end

RegisterStatType(meta, "Kills")
RegisterStatType(meta, "Assists")
RegisterStatType(meta, "Destructions")

RegisterStatType(meta, "Captures")
RegisterStatType(meta, "Defenses")
RegisterStatType(meta, "Dominations")
RegisterStatType(meta, "Revenges")

RegisterStatType(meta, "Healing")
RegisterStatType(meta, "Invulns")
RegisterStatType(meta, "Teleports")
RegisterStatType(meta, "Headshots")

RegisterStatType(meta, "Backstabs")
RegisterStatType(meta, "Bonus")

-- Serverside

if SERVER then

if not meta.SetFrags0 then
	meta.SetFrags0 = meta.SetFrags
end
function meta:SetFrags(n)
	if not self.Stats then self.Stats = {} end
	self.Stats.Points = n
	self:SetFrags0(math.floor(self.Stats.Points))
end

function meta:AddFrags(n)
	if not self.Stats then self.Stats = {} end
	self.Stats.Points = (self.Stats.Points or self:Frags()) + n
	self:SetFrags0(math.floor(self.Stats.Points))
end

function meta:Explode(dmginfo)
		self.ShouldGib = true
		umsg.Start("GibPlayer")
			umsg.Long(self:UserID())
			umsg.Short(self.DeathFlags)	
		umsg.End()
	--self:EmitSound(")player/gib"..math.random(1,3)..".wav", 95)
	--self:EmitSound(")player/gibexplosion"..math.random(1,3)..".wav", 115) 
end

function meta:Decap()
	self.ShouldGib = true
	if self:IsHL2() then
		umsg.Start("GibNPCHead")
			umsg.Long(self:UserID())
			umsg.Short(self.DeathFlags)
		umsg.End()
	else
		umsg.Start("GibPlayerHead")
			umsg.Long(self:UserID())
			umsg.Short(self.DeathFlags)
		umsg.End()
	end
end


function meta:SetBuilding(group, mode)
	local builder = self:GetWeapon("tf_weapon_builder")
	if self.Buildings[group] and self.Buildings[group][mode] then
		local cost = self.Buildings[group][mode].cost
		if self:GetAmmoCount(TF_METAL) < cost then
			return false
		end
		
		builder.dt.BuildGroup = group
		builder.dt.BuildMode = mode
		return true
	end
end

function meta:SetBuilding2(group, mode)
	if self.Buildings[group] and self.Buildings[group][mode] then
		self.dt.BuildGroup = group
		self.dt.BuildMode = mode
		return true
	end
end

local old_group_translate = {
	[0] = {0,0},
	[1] = {1,0},
	[2] = {1,1},
	[3] = {2,0},
	[4] = {3,0},
}

function meta:Build(number1,number2)
	local args
	local group = tonumber(number1)
	local sub = tonumber(number2)
	
	local builder = self:GetWeapon("tf_weapon_builder")
	
	if builds[group] and (!GetConVar("tf_unlimited_buildings"):GetBool()) then
		local tab = ents.FindByClass(builds[group])
		for k, v in pairs(tab) do
			if v.Player == self and builds[group] ~= "obj_teleporter" then
				return
			elseif v.Player == self and builds[group] == "obj_teleporter" then
				for i, o in pairs(tab) do
					if (sub == 0 and v:IsEntrance() and o:IsEntrance()) or (sub == 1 and v:IsExit() and o:IsExit()) then
						return
					end
				end
			end
		end
	end
	builder:SetHoldType("BUILDING")
	
	builder.Moving = false
	
	timer.Simple(25, function()
		if ( builder:IsValid() and builder.Moving != false and self:KeyPressed( IN_FORWARD ) ) then 
			self:EmitSound("vo/engineer_sentrymoving0"..math.random(1,2)..".wav", 80, 100)
		else
			return
		end
	end)	
	
	if not IsValid(builder) then return end
	if not group then return end
	
	if not sub then
		if not old_group_translate[group] then return end
		
		group, sub = unpack(old_group_translate[group])
	end
	local Buildings = {}
	local Buildings2 = {}
	local Buildings3 = {}
	local Buildings4 = {}
	table.remove(Buildings, 1) 
	table.remove(Buildings2, 1) 
	local current = self:GetActiveWeapon()
	for k,v in ipairs(ents.FindByClass("obj_sentrygun")) do
		if IsValid(v) and v:GetOwner() == self then
			table.insert(Buildings, v:EntIndex()) 
			PrintTable(Buildings)
		elseif !IsValid(v) then
			table.remove(Buildings, 1) 
		end
	end
	for k,v in ipairs(ents.FindByClass("obj_dispenser")) do
		if IsValid(v) and v:GetOwner() == self then
			table.insert(Buildings2, v:EntIndex())
		elseif !IsValid(v) then
			table.remove(Buildings2, 1) 
		end
	end
	for k,v in ipairs(ents.FindByClass("obj_teleporter")) do 
		if IsValid(v) and v:GetOwner() == self then
			table.insert(Buildings3, v:EntIndex())
		elseif !IsValid(v) then
			table.remove(Buildings3, 1) 
			table.remove(Buildings3, 2)
		end
	end
	if self:SetBuilding(group, sub) and current ~= builder then
		if current.IsPDA then
			local last = self:GetWeapon(self.LastWeapon)
			if not IsValid(last) or last.IsPDA then
			last = self:GetWeapons()[1]
		end
		builder.LastWeapon = last:GetClass()
		self:SelectWeapon(last:GetClass())
	else
		builder.LastWeapon = current:GetClass()
	end
	self:SelectWeapon("tf_weapon_builder")
end
 
end
function meta:Move(number1,number2)
	local group = tonumber(number1)
	local sub = tonumber(number2) 
	if self:GetInfoNum("tf_robot", 0) == 1 then
		self:EmitSound("vo/mvm/norm/engineer_mvm_sentrypacking0"..math.random(1,3)..".wav", 80, 100)
	else
		self:EmitSound("vo/engineer_sentrypacking0"..math.random(1,3)..".wav", 80, 100)		
	end
	local builder = self:GetWeapon("tf_weapon_builder")
	
	if not IsValid(builder) then return end
	if not group then return end
	
	builder:SetHoldType("BUILDING_DEPLOYED")
	builder.HoldType = "BUILDING_DEPLOYED"
	
	if not sub then
		if not old_group_translate[group] then return end
		
		group, sub = unpack(old_group_translate[group])
	end
	
	local current = self:GetActiveWeapon()
	if builder:SetBuilding2(group, sub) and current ~= builder then
		if current.IsPDA then
			local last = self:GetWeapon(self.LastWeapon)
			if not IsValid(last) or last.IsPDA then
				last = self:GetWeapons()[1]
			end
			builder.LastWeapon = last:GetClass()
			self:SelectWeapon(last:GetClass())
		else
			builder.LastWeapon = current:GetClass()
		end
		self:SelectWeapon("tf_weapon_builder")
		builder.Moving = true
	end
end
function meta:TFTaunt(args)

	if self:IsHL2() then return end
	if self:GetNWBool("Taunting") == true then return end
	if not self:IsOnGround() then return end
	if self:WaterLevel() ~= 0 then return end

	if self:GetPlayerClass() == "combinesoldier" then
		EmitSentence( "COMBINE_THROW_GRENADE" .. math.random( 0, 4 ), self:GetPos(), 1, CHAN_AUTO, 1, 75, 0, 100 )
	end
	--[[if self:GetInfoNum("tf_robot", 0) == 1 then self:ChatPrint("You can't taunt as a robot!") return end
	if self:GetInfoNum("tf_giantrobot", 0) == 1 then self:ChatPrint("You can't taunt as a mighty robot!") return end]]
	if not table.HasValue(allowedtaunts, args[1]) then return end
	for k,v in ipairs(ents.FindInSphere(self:GetPos(), 120)) do
		if v:GetNWBool("IWantToTaunt") ==  true then
			self:SetNWBool("IWantToTauntToo", true)
		end
	end
		if table.KeyFromValue(allowedtaunts,args[1]) == 1 then
	
			if self:GetWeapons()[1]:GetClass() == "weapon_crowbar" then
			
				self:SelectWeapon(self:GetWeapons()[1]:GetClass())
				self:DoAnimationEvent(ACT_GMOD_TAUNT_LAUGH, true)
	
			elseif self:GetPlayerClass() == "combinesoldier" then
				self:DoAnimationEvent(ACT_SPECIAL_ATTACK1, true)
				self:SetNWBool("Taunting", true)
				self:SetNWBool("NoWeapon", true) 
				local frag = ents.Create("npc_grenade_frag")
				net.Start("ActivateTauntCam")
				net.Send(self)
				frag:SetPos(self:EyePos() + ( self:GetAimVector() * 16 ) )
				frag:SetAngles( self:EyeAngles() )
				frag:SetOwner(self)

				timer.Simple(0.6, function()
					frag:Spawn()
					
					local phys = frag:GetPhysicsObject()
						if ( !IsValid( phys ) ) then frag:Remove() return end
						
						
						
						local velocity = self:GetAimVector()
						velocity = velocity * 1000
						velocity = velocity + ( VectorRand() * 10 ) -- a random element
						phys:ApselfForceCenter( velocity )
						frag:Fire("SetTimer",5,0)
						frag:SetOwner(self)
						--timer.Simple(3.5,function() frag:Ignite() end)
				end)
				timer.Simple(1.2, function()
					if not IsValid(self) or (not self:Alive() and not self:GetNWBool("Taunting")) then return end
					self:SetNWBool("Taunting", false)
					self:SetNWBool("NoWeapon", false)
					print("Taunt Finished")
					net.Start("DeActivateTauntCam")
					net.Send(self)
				end)
					
			end
			
			if self:GetPlayerClass() == "pyro" then
				if self:GetWeapons()[1]:GetItemData().model_player == "models/weapons/c_models/c_rainblower/c_rainblower.mdl" then
					self:SelectWeapon(self:GetWeapons()[1]:GetClass())
					self:DoAnimationEvent(ACT_90_RIGHT, true)
					self:EmitSound("player/taunt_pyro_hellicorn.wav", 100)
					timer.Simple(3.15, function()
						self:EmitSound("tf/weapons/explode1.wav")
						for k,v in pairs(ents.FindInSphere(self:GetPos(), 90)) do 
							if v:IsTFPlayer() and not v:IsFriendly(self) then
								v:TakeDamage(500, self, self)
							end
						end
					end)
				else
				
					self:SelectWeapon(self:GetWeapons()[1]:GetClass())
					self:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)		
				end

			elseif self:GetPlayerClass() == "sniper" then
				if self:GetWeapons()[1]:GetClass() == "tf_weapon_compound_bow" then
					self:SelectWeapon(self:GetWeapons()[1]:GetClass())
					self:DoAnimationEvent(ACT_DOD_CROUCH_IDLE_PISTOL, true)
					self:SetNWBool("Taunting", true)
					self:SetNWBool("NoWeapon", true)
					self:GetActiveWeapon().NameOverride = "taunt_sniper" 
					timer.Simple(0.8, function()
						for k,v in pairs(ents.FindInSphere(self:GetPos(), 90)) do 
							if v:IsTFPlayer() and not v:IsPlayer() and not v:IsFriendly(self) then
								v:TakeDamage(50, self, self)
							elseif v:IsPlayer() and not v:IsFriendly(self) then
								v:ConCommand("tf_stun_me")
								v:TakeDamage(50, self, self)
							end
						end
					end)
					timer.Simple(2.3, function()
						for k,v in pairs(ents.FindInSphere(self:GetPos(), 90)) do 
							if v:IsTFPlayer() and not v:IsPlayer() and not v:IsFriendly(self) then
								v:TakeDamage(500, self, self)
							elseif v:IsPlayer() and not v:IsFriendly(self) then
								v:TakeDamage(500, self, self)
							end
						end
					end)
				else					
					self:SelectWeapon(self:GetWeapons()[1]:GetClass())
					self:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)
				end
			elseif self:GetPlayerClass() == "heavy" then
				if self:GetInfoNum("tf_robot", 0) == 1 and table.KeyFromValue(allowedtaunts,args[1]) == 1 then
					timer.Simple(2, function()
						self:EmitSound("vo/mvm/norm/heavy_mvm_goodjob0"..math.random(1,3)..".wav", 95, 100)
					end)
					timer.Simple(8, function()
						if not IsValid(self) or (not self:Alive() and not self:GetNWBool("Taunting")) then return end
						self:SetNWBool("Taunting", false)
						self:SetNWBool("NoWeapon", false)
						print("Taunt Finished")
						net.Start("DeActivateTauntCam")
						net.Send(self)
					end)
				else
					self:SelectWeapon(self:GetWeapons()[1]:GetClass())
					self:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)				
				end
			elseif self:GetPlayerClass() == "medic" then
				if self:GetInfoNum("tf_robot", 0) == 1 and table.KeyFromValue(allowedtaunts,args[1]) == 1 then
					timer.Simple(0.1, function()
						self:EmitSound("vo/mvm/norm/medic_mvm_specialcompleted01.wav", 95, 100)
					end)
					timer.Simple(3, function()
						self:EmitSound("player/taunt_rubberglove_snap.wav")
					end)
					timer.Simple(1, function()
						self:EmitSound("player/taunt_rubberglove_stretch.wav")
					end)
					timer.Simple(6, function()
						if not IsValid(self) or (not self:Alive() and not self:GetNWBool("Taunting")) then return end
						self:SetNWBool("Taunting", false)
						self:SetNWBool("NoWeapon", false)
						print("Taunt Finished")
						net.Start("DeActivateTauntCam")
						net.Send(self)
					end)
				else				
					self:SelectWeapon(self:GetWeapons()[1]:GetClass())
					self:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)		
			end
			elseif self:GetPlayerClass() == "soldier" then
				if self:GetInfoNum("tf_robot", 0) == 1 and table.KeyFromValue(allowedtaunts,args[1]) == 1 then
					timer.Simple(1.6, function()
						self:EmitSound("vo/mvm/norm/taunts/soldier_mvm_taunts01.wav", 95, 100)
					end)
					timer.Simple(3, function()
						if not IsValid(self) or (not self:Alive() and not self:GetNWBool("Taunting")) then return end
						self:SetNWBool("Taunting", false)
						self:SetNWBool("NoWeapon", false)
						print("Taunt Finished")
						net.Start("DeActivateTauntCam")
						net.Send(self)
					end)
				elseif self:GetInfoNum("tf_robot", 0) == 1 and table.KeyFromValue(allowedtaunts,args[1]) == 2 then
					timer.Simple(3, function()
						self:EmitSound("vo/mvm/norm/soldier_mvm_cheers0"..math.random(5,6)..".wav", 95, 100)
					end)
					timer.Simple(5, function()
						if not IsValid(self) or (not self:Alive() and not self:GetNWBool("Taunting")) then return end
						self:SetNWBool("Taunting", false)
						self:SetNWBool("NoWeapon", false)
						print("Taunt Finished")
						net.Start("DeActivateTauntCam")
						net.Send(self)
					end)
				elseif self:GetInfoNum("tf_robot", 0) == 1 and table.KeyFromValue(allowedtaunts,args[1]) == 3 then
					timer.Simple(0.1, function()
						self:EmitSound("vo/mvm/norm/soldier_mvm_directhittaunt02.wav", 95, 100)
					end)
					timer.Simple(5, function()
						if not IsValid(self) or (not self:Alive() and not self:GetNWBool("Taunting")) then return end
						self:SetNWBool("Taunting", false)
						self:SetNWBool("NoWeapon", false)
						print("Taunt Finished")
						net.Start("DeActivateTauntCam")
						net.Send(self)
					end)
				else
					if self:GetWeapons()[1]:GetClass() == "tf_weapon_rocketlauncher_dh" then
						self:SelectWeapon(self:GetWeapons()[1]:GetClass())
						self:DoAnimationEvent(ACT_DOD_RELOAD_DEPLOYED, true)	
					else
						self:SelectWeapon(self:GetWeapons()[1]:GetClass())
						self:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)		
					end
				end
			
			elseif self:GetPlayerClass() == "scout" then
				
				self:DoAnimationEvent(ACT_DOD_CROUCHWALK_AIM_MP40, true)
				
			elseif self:GetPlayerClass() == "demoman" then
				if self:GetWeapons()[1]:GetClass() == "tf_weapon_grenadelauncher" then
					self:PlayScene("scenes/player/demoman/low/taunt08.vcd")
					self:DoAnimationEvent(ACT_DOD_CROUCHWALK_AIM_MP40, true)
					self:SelectWeapon(self:GetWeapons()[1]:GetClass())
				else
					self:DoAnimationEvent(ACT_DOD_CROUCHWALK_AIM_MP40, true)
					self:SelectWeapon(self:GetWeapons()[1]:GetClass())				
				end
			elseif self:GetPlayerClass() == "engineer" then
				if self:GetWeapons()[1]:GetClass() == "tf_weapon_sentry_revenge" then
					self:SelectWeapon(self:GetWeapons()[1]:GetClass())
					self:DoAnimationEvent(ACT_DOD_RELOAD_DEPLOYED, true)
					self:PlayScene("scenes/player/engineer/low/taunt07.vcd")
					self:SetNWBool("Taunting", true)
					self:SetNWBool("NoWeapon", true)
					self:GetActiveWeapon().NameOverride = "taunt_guitar_kill"
					local animent2 = ents.Create( 'base_gmodentity' ) -- The entity used for the death animation	
					animent2:SetModel("models/player/items/engineer/guitar.mdl") 
					animent2:SetAngles(self:GetAngles())
					animent2:SetPos(self:GetPos())
					animent2:Spawn()
					animent2:Activate()
					animent2:SetParent(self)
					animent2:AddEffects(EF_BONEMERGE)
					animent2:SetName("GuitarModel"..self:EntIndex())
					timer.Simple(1.5, function()
						self:EmitSound("player/taunt_eng_strum.wav")
					end)
					timer.Simple(4.2, function()
						if not IsValid(self) or (not self:Alive() and not self:GetNWBool("Taunting")) then return end
						self:SetNWBool("Taunting", false)
						self:SetNWBool("NoWeapon", false)
						print("Taunt Finished")
						net.Start("DeActivateTauntCam")
						net.Send(self)
						animent2:Fire("Kill", "", 0.1)
					end)
					timer.Simple(3.7, function()
						self:EmitSound("player/taunt_eng_smash"..math.random(1,3)..".wav")
						for k,v in pairs(ents.FindInSphere(self:GetPos(), 90)) do 
							if v:IsNPC() and not v:IsFriendly(self) then
								v:TakeDamage(500, self, self)
							elseif v:IsPlayer() and not v:IsFriendly(self) then
								v:TakeDamage(500, self, self)
							end
						end
					end)
				else					
					self:SelectWeapon(self:GetWeapons()[1]:GetClass())
					self:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)
				end
			else
			
			self:SelectWeapon(self:GetWeapons()[1]:GetClass())
			self:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)
			end
		elseif table.KeyFromValue(allowedtaunts,args[1]) == 2 then
	
			if self:GetPlayerClass() == "combinesoldier" then
				self:DoAnimationEvent(ACT_SPECIAL_ATTACK1, true)
				self:SetNWBool("Taunting", true)
				self:SetNWBool("NoWeapon", true) 
				local frag = ents.Create("npc_grenade_frag")
				net.Start("ActivateTauntCam")
				net.Send(self)
				frag:SetPos(self:EyePos() + ( self:GetAimVector() * 16 ) )
				frag:SetAngles( self:EyeAngles() )
				frag:SetOwner(self)
				timer.Simple(0.6, function()
					frag:Spawn()
					
					local phys = frag:GetPhysicsObject()
						if ( !IsValid( phys ) ) then frag:Remove() return end
						
						
						
						local velocity = self:GetAimVector()
						velocity = velocity * 1000
						velocity = velocity + ( VectorRand() * 10 ) -- a random element
						phys:ApselfForceCenter( velocity )
						frag:Fire("SetTimer",5,0)
						frag:SetOwner(self)
						--timer.Simple(3.5,function() frag:Ignite() end)
				end)
				timer.Simple(1.2, function()
					if not IsValid(self) or (not self:Alive() and not self:GetNWBool("Taunting")) then return end
					self:SetNWBool("Taunting", false)
					self:SetNWBool("NoWeapon", false)
					print("Taunt Finished")
					net.Start("DeActivateTauntCam")
					net.Send(self)
				end)
					 

			elseif self:GetPlayerClass() == "demoman" then
				if self:GetWeapons()[2]:GetItemData().model_player == "models/weapons/c_models/c_scottish_resistance/c_scottish_resistance.mdl" then
					self:SelectWeapon(self:GetWeapons()[2]:GetClass())
					self:DoAnimationEvent(ACT_SIGNAL2)
				else
					self:SelectWeapon(self:GetWeapons()[2]:GetClass())
					self:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)
				end
			elseif self:GetPlayerClass() == "soldier" then
				self:SelectWeapon(self:GetWeapons()[2]:GetClass())
				self:DoAnimationEvent(ACT_DOD_SPRINT_AIM_SPADE, true)
			elseif self:GetPlayerClass() == "pyro" then
				if self:GetWeapons()[2]:GetClass() == "tf_weapon_flaregun" then
					self:SelectWeapon(self:GetWeapons()[2]:GetClass())
					self:DoAnimationEvent(ACT_RUN_HURT,true)
					timer.Simple(2, function()
						self:GetWeapons()[2]:PrimaryAttack()
						self:GetWeapons()[2]:ShootEffects()
					end)
					timer.Simple(4, function()
						if not IsValid(self) or (not self:Alive() and not self:GetNWBool("Taunting")) then return end
						self:SetNWBool("Taunting", false)
						self:SetNWBool("NoWeapon", false)
						print("Taunt Finished")
						net.Start("DeActivateTauntCam")
						net.Send(self)
					end)
				else
					self:GetActiveWeapon().NameOverride = "taunt_pyro"
					timer.Simple(1.8, function()
						for k,v in pairs(ents.FindInSphere(self:GetPos(), 90)) do 
							if v:IsTFPlayer() and not v:IsFriendly(self) then
								GAMEMODE:IgniteEntity(v, self:GetActiveWeapon(), self, 10)
							end
						end
					end)
					timer.Simple(2, function()
						for k,v in pairs(ents.FindInSphere(self:GetPos(), 90)) do 
							if v:IsTFPlayer() and not v:IsFriendly(self) then
								v:TakeDamage(500, self, self)
							end
						end
					end)
				
				self:SelectWeapon(self:GetWeapons()[2]:GetClass())
				self:DoAnimationEvent(ACT_DOD_CROUCHWALK_AIM_MP40, true)
				
				end
			else
			self:SelectWeapon(self:GetWeapons()[2]:GetClass())
			self:DoAnimationEvent(ACT_DOD_CROUCHWALK_AIM_MP40, true)
			end
		elseif table.KeyFromValue(allowedtaunts,args[1]) == 3 then	
			if self:GetPlayerClass() == "pyro" then
				if self:GetWeapons()[3]:GetClass() == "tf_weapon_neonsign" then
					self:EmitSound("player/sign_bass_solo.wav", 95, 100)
				end
				self:SelectWeapon(self:GetWeapons()[3]:GetClass())
				self:DoAnimationEvent(ACT_DOD_STAND_AIM_30CAL, true)
			end
			if self:GetPlayerClass() == "soldier" then
				if self:GetWeapons()[3]:GetClass() == "tf_weapon_pickaxe" then
					self:GetWeapons()[3].NameOverride = "taunt_soldier"
					timer.Simple(3.5, function()
						if !self:Alive() then return end
						for k,v in pairs(ents.FindInSphere(self:GetPos(), 90)) do 
							if v:IsNPC() and not v:IsFriendly(self) then
								local d = DamageInfo()
								d:SetDamage( v:Health() )
								d:SetAttacker( self )
								d:SetInflictor( self:GetWeapons()[3] )
								d:SetDamageType( DMG_BLAST )
								v:TakeDamageInfo( d )
								v:EmitSound("BaseExplosionEffect.Sound")
							elseif v:IsPlayer() and not v:IsFriendly(self) then
								local d = DamageInfo()
								d:SetDamage( v:Health() )
								d:SetAttacker( self )
								d:SetInflictor( self:GetWeapons()[3] )
								d:SetDamageType( DMG_BLAST )
								v:TakeDamageInfo( d )
								v:EmitSound("BaseExplosionEffect.Sound")
							end
						end
						timer.Simple(0.3, function()
						
							self:EmitSound("BaseExplosionEffect.Sound")
							local dmg = DamageInfo()
							dmg:SetDamage( self:Health() )
							dmg:SetAttacker( self )
							dmg:SetInflictor( self:GetWeapons()[3] )
							dmg:SetDamageType( DMG_BLAST )
							self:TakeDamageInfo( dmg )
						end)
					end)
					self:SelectWeapon(self:GetWeapons()[3]:GetClass())
					self:DoAnimationEvent(ACT_COVER_LOW, true)
				else
					self:SelectWeapon(self:GetWeapons()[3]:GetClass())
					self:DoAnimationEvent(ACT_DOD_STAND_AIM_30CAL, true)
				end
			elseif self:GetPlayerClass() == "heavy" then
				self:GetActiveWeapon().NameOverride = "taunt_heavy"
				timer.Simple(1.7, function()
					if self:GetEyeTrace().Entity:IsNPC() and not self:GetEyeTrace().Entity:IsFriendly(self) then
						self:GetEyeTrace().Entity:TakeDamage(500, self, self)
					elseif self:GetEyeTrace().Entity:IsPlayer() and not self:GetEyeTrace().Entity:IsFriendly(self) then
						self:GetEyeTrace().Entity:TakeDamage(500, self, self)
					end
				end)
				
				self:SelectWeapon(self:GetWeapons()[3]:GetClass())
				self:DoAnimationEvent(ACT_DOD_STAND_AIM_30CAL, true)
			elseif self:GetPlayerClass() == "scout" then
				if self:GetWeapons()[3]:GetClass() == "tf_weapon_bat_wood" then
					self:GetActiveWeapon().NameOverride = "taunt_scout"
					timer.Simple(4.2, function()
						for k,v in pairs(ents.FindInSphere(self:GetPos(), 90)) do 
							if v:IsTFPlayer() and not v:IsFriendly(self) then
								v:TakeDamage(500, self, self)
								v:EmitSound("player/pl_impact_stun_range.wav", 95)
							end
						end
					end)
					self:SelectWeapon(self:GetWeapons()[3]:GetClass())
					self:DoAnimationEvent(ACT_COVER_LOW, true)
				else
					self:SelectWeapon(self:GetWeapons()[3]:GetClass())
					self:DoAnimationEvent(ACT_DOD_STAND_AIM_30CAL, true)				
				end
			elseif self:GetPlayerClass() == "medic" then
				self:SelectWeapon(self:GetWeapons()[3]:GetClass())
				self:DoAnimationEvent(ACT_DOD_CROUCH_AIM_C96, true)	
			elseif (self:GetPlayerClass() == "spy") then
				
				timer.Simple(2, function()
					for k,v in pairs(ents.FindInSphere(self:GetPos(), 90)) do 
						if v:IsTFPlayer() and not v:IsFriendly(self) then
							v:TakeDamage(10, self, self)
							self:GetActiveWeapon().NameOverride = "taunt_spy"
						end
					end
				end)		
				timer.Simple(2.5, function()
					for k,v in pairs(ents.FindInSphere(self:GetPos(), 90)) do 
						if v:IsTFPlayer() and not v:IsFriendly(self) then
							v:TakeDamage(10, self, self)
							self:GetActiveWeapon().NameOverride = "taunt_spy"
						end
					end
				end)	
				timer.Simple(4, function()
					for k,v in pairs(ents.FindInSphere(self:GetPos(), 90)) do 
						if v:IsTFPlayer() and not v:IsFriendly(self) then
							v:TakeDamage(500, self, self)
							self:GetActiveWeapon().NameOverride = "taunt_spy"
						end
					end
				end)	
				self:SelectWeapon(self:GetWeapons()[3]:GetClass())
				self:DoAnimationEvent(ACT_DOD_STAND_AIM_30CAL, true)
			elseif self:GetPlayerClass() == "demoman" then
				if self:GetWeapons()[3]:GetClass() == "tf_weapon_sword" or self:GetWeapons()[3]:GetClass() == "tf_weapon_katana" then
					self:GetActiveWeapon().NameOverride = "taunt_demoman"
					timer.Simple(2.5, function()
						for k,v in pairs(ents.FindInSphere(self:GetPos(), 90)) do 
							if v:IsTFPlayer() and not v:IsFriendly(self) then
								v:AddDeathFlag(DF_DECAP)
								v:TakeDamage(500, self, self)
							end
						end
					end)
					self:SelectWeapon(self:GetWeapons()[3]:GetClass())
					self:DoAnimationEvent(ACT_DOD_STAND_AIM_KNIFE, true)
				else
					self:SelectWeapon(self:GetWeapons()[3]:GetClass())
					self:DoAnimationEvent(ACT_DOD_STAND_AIM_30CAL, true)
				end
			else
				
				self:SelectWeapon(self:GetWeapons()[3]:GetClass())
				self:DoAnimationEvent(ACT_DOD_STAND_AIM_30CAL, true)
				
			end
		end
	self:Taunt("TLK_PLAYER_TAUNT")
	self:SetNWBool("Taunting", true)
	if IsValid(self:GetActiveWeapon()) and table.HasValue(wep, self:GetActiveWeapon():GetClass()) then self:SetNWBool("NoWeapon", true) end
	net.Start("ActivateTauntCam")
	net.Send(self)
	
	if self:GetPlayerClass() != "combinesoldier" then
		print(self:GetNWBool("SpeechTime"))
		timer.Simple(self:GetNWBool("SpeechTime"), function()
			if not IsValid(self) or (not self:Alive() and not self:GetNWBool("Taunting")) then return end
			self:SetNWBool("Taunting", false)
			self:SetNWBool("NoWeapon", false)
			print("Taunt Finished")
			net.Start("DeActivateTauntCam")
			net.Send(self)
			if !self:IsHL2() then
				self:GetActiveWeapon().NameOverride = self:GetActiveWeapon():GetItemData().item_iconname
			end
		end)
	end
end
function meta:RandomSentence(group)
	
	local class = self.playerclass
	if not class then return end
	
	--[[local tbl = class.Sounds[group]
	self:EmitSound(tbl[math.random(1,#tbl)])]]

	self:EmitSound("TFPlayer."..group)
end

function meta:StripTFItems()
	self:StripWeapons()
	self:StripAmmo()
	
	if self.PlayerItemList then
		for _,v in ipairs(self.PlayerItemList) do
			v:Remove()
		end
	end
end

function meta:StripHats()
	for _,v in pairs(ents.FindByClass("tf_hat")) do
		if v:GetOwner() == self then
			v:Remove()
		end
	end
	
	for i=1,10 do
		self:SetBodygroup(i,0)
	end
end

function meta:GiveTFAmmo(c, am, is_fraction)
	if c==0 then return end
	
	if not self.AmmoMax then
		if c>0 then
			return self:GiveAmmo(c, am)
		else
			return self:RemoveAmmo(-c, am)
		end
	end
	
	if (self.TFBot) then
		self:AnimRestartGesture(GESTURE_SLOT_GRENADE, ACT_MP_ATTACK_STAND_GRENADE)
	end
	local a = self:GetAmmoCount(am)
	
	if is_fraction then
		if c ~= nil and not self:IsHL2() then
			c = math.ceil(c * self.AmmoMax[am])
		else
			c = 0
		end
	end
	
	if c>0 then
		c = math.min(self.AmmoMax[am] - a, c)
		if c>0 then
			self:GiveAmmo(c, am)
			if am == TF_METAL then
				umsg.Start("PlayerMetalBonus", self)
					umsg.Short(c)
				umsg.End()
			end
			return true
		end
	else
		self:RemoveAmmo(-c, am)
		if am == TF_METAL then
			umsg.Start("PlayerMetalBonus", self)
				umsg.Short(-c)
			umsg.End()
		end
	end
	
	return false
end

function meta:SetAmmoCount(c, am)
	local a = self:GetAmmoCount(am)
	
	if c > a then
		self:GiveAmmo(c - a, am)
	elseif c < a then
		self:RemoveAmmo(a - c, am)
	end
end

function meta:HasFullAmmo()
	for k,v in pairs(self.AmmoMax or {}) do
		if self:GetAmmoCount(k) < v then
			return false
		end
	end
	return true
end

function meta:ResetAttributes()
	local c = self:GetPlayerClassTable()
	
	self.TempAttributes = {}
	self:ResetClassSpeed(c.Speed or 100)
	self:ResetMaxHealth()
	self.AmmoMax = table.Copy(c.AmmoMax or {})
end

end

-- Shared

--[[function meta:GetCrouchedWalkSpeed()
	return self:GetNWFloat("CrouchedWalkSpeed")
end

function meta:GetWalkSpeed()
	return 1
end

function meta:GetRunSpeed()
	return 1
end

function meta:GetDuckSpeed()
	return self:GetNWFloat("TimeToDuck")
end

function meta:GetUnDuckSpeed()
	return self:GetNWFloat("TimeToUnDuck")
end]]

function meta:IsHL2()
	return self:GetNWBool("IsHL2")
end
function meta:IsL4D()
	return false
end

function meta:ShouldUseDefaultHull()
	if self ~= nil then
		if GetConVar("tf_use_hl_hull_size") then
			return self:GetNWBool("IsHL2") or GetConVar("tf_use_hl_hull_size"):GetInt() == 1
		end
	end
end

function meta:GetTFItems()
	local t = self:GetWeapons()
	if self.PlayerItemList then
		table.Add(t, self.PlayerItemList)
	end
	return t
end

function meta:HasTFItem(name)
	if not name then return false end
	
	for _,v in ipairs(self:GetTFItems()) do
		if v.IsTFItem and v:GetItemData().name == name then
			return true
		end
	end
	
	return false
end

--[[
if CLIENT then

usermessage.Hook("SendWeaponAnim", function(msg)
	local act = msg:ReadShort()
	local seq = GAMEMODE.Viewmodels[1][2]:SelectWeightedSequence(act)
	if seq>=0 then
		GAMEMODE.Viewmodels[1][2]:ResetSequence(seq)
		GAMEMODE.Viewmodels[1][2]:SetCycle(0)
	end
end)

end

meta.SendWeaponAnim0 = meta.SendWeaponAnim

function meta:SendWeaponAnim(act)
	self:SendWeaponAnim0(act)
	
	if SERVER then
		umsg.Start("SendWeaponAnim", self)
			umsg.Short(act)
		umsg.End()
	else
		local seq = GAMEMODE.Viewmodels[1][2]:SelectWeightedSequence(act)
		if seq>=0 then
			GAMEMODE.Viewmodels[1][2]:ResetSequence(seq)
			GAMEMODE.Viewmodels[1][2]:ResetSequenceInfo()
		end
	end
end
]]
