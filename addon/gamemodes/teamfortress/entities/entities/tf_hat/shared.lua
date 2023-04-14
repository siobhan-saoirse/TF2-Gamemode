
DEFINE_BASECLASS( "base_gmodentity" )

local TranslateCModelToVModel = {
	["models/weapons/c_models/c_targe/c_targe.mdl"] = "models/weapons/c_models/c_v_targe/c_v_targe.mdl",
}

function ENT:GetHatData()
	return PlayerHats[self:GetNWString("HatName")]
end

function ENT:GetHatModel()
	local name = self:GetNWString("HatName")
	local data = PlayerHats[name]
	if data and not data.nomodel then
		return "models/player/items/"..(data.model or name)..".mdl"
	end
end

function ENT:SetupSkinAndBodygroups(ent)
	local hatdata = self:GetHatData()
	
	if hatdata then
		if hatdata.skin then
			ent:SetSkin(hatdata.skin)
		else
			if self:GetOwner():Team()==TEAM_BLU then
				ent:SetSkin(1)
			else
				ent:SetSkin(0)
			end
		end
		
		if hatdata.perclassbodygroup then
			local mdlname = self:GetOwner():GetPlayerClassTable().ModelName
			if mdlname and ClassToMedalBodygroup[mdlname] then
				ent:SetBodygroup(1, ClassToMedalBodygroup[mdlname])
			end
		end
		
		ent:StopParticles()
		if hatdata.particles then
			for a,p in pairs(hatdata.particles) do
				local att = ent:LookupAttachment(a)
				if att and att > 0 then
					ParticleEffectAttach(p, PATTACH_POINT_FOLLOW, ent, att)
				else
					ParticleEffectAttach(p, PATTACH_ABSORIGIN_FOLLOW, ent, 0)
				end
			end
		end
	end
end

function ENT:SetupPlayerBodygroups(pl)
	local hatdata = self:GetHatData()
	
	pl = pl or self:GetOwner()
	
	if hatdata and hatdata.hide then
		local mdlname = self:GetOwner():GetPlayerClassTable().ModelName
		if PlayerNamedBodygroups[mdlname] then
			for _,v in ipairs(hatdata.hide) do
				local d = PlayerNamedBodygroups[mdlname][v]
				if d then
					pl:SetBodygroup(d,1)
				end
			end
		end
	end
end

function ENT:SetupDataTables()
	self:DTVar("Bool", 0, "ShowInViewModel")
end

function ENT:ShowsInViewModel()
	return self.dt.ShowInViewModel
end

if CLIENT then

function ENT:DrawInViewModel(vm, wep)
	print(self:GetOwner())
	if not wep.AddedCModels then
		wep.AddedCModels = {}
	end
	
	if not IsValid(wep.AddedCModels[self]) then
		local mdlname = TranslateCModelToVModel[self:GetModel()] or self:GetModel()
		
		cm = ClientsideModel(mdlname)
		cm:SetPos(vm:GetPos())
		cm:SetAngles(vm:GetAngles())
		cm:AddEffects(EF_BONEMERGE)
		cm:SetParent(vm)
		cmself.WModel2:SetNoDraw(true)
		
		wep.AddedCModels[self] = cm
	end
	
	wep.AddedCModels[self]:DrawModel()
end

end

if SERVER then

AddCSLuaFile( "shared.lua" )

function ENT:Initialize()
	local hatdata
	
	if self.HatName then
		hatdata = PlayerHats[self.HatName]
	end
	
	if hatdata then
		self:SetNWString("HatName", self.HatName)
		self.Model = self:GetHatModel()
	else
		self:SetNWString("HatName", "")
	end
	
	if self.Model then
		self:SetModel(self.Model)
		self:SetKeyValue("effects", "1")
	else
		self:SetNoDraw(true)
		self:DrawShadow(false)
	end
	
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	
	local pl = self.Player or player.GetAll()[1]
	self:SetPos(pl:GetPos())
	self:SetAngles(pl:GetAngles())
	self:SetParent(pl)
	self:SetOwner(pl)
	
	self:SetupSkinAndBodygroups(self)
	self:SetupPlayerBodygroups()
	
	local att = self.Attributes or {}
	if att.show_in_vmodel then
		self.dt.ShowInViewModel = true
	else
		self.dt.ShowInViewModel = false
	end
end

hook.Add("DoPlayerDeath", "TFHatDisable", function(pl)
	for _,v in pairs(ents.FindByClass("tf_hat")) do
		if v:GetOwner()==pl then
			v:SetKeyValue("effects", "0")
			v:SetParent()
			v:SetNoDraw(true)
			v:DrawShadow(false)
			v.Dead = true
		end
	end
end)

hook.Add("PlayerHurt", "TFHatDisable2", function(pl)
	for k,v in pairs(ents.FindByClass("tf_weapon_invis_dringer")) do
		if v.Owner == pl then
			for _,v in pairs(ents.FindByClass("tf_hat")) do
				if v:GetOwner()==pl then
					v:SetKeyValue("effects", "0")
					v:SetParent()
					v:SetNoDraw(true)
					v:DrawShadow(false)
					v.Dead = true
				end
			end
		end
	end
end)

hook.Add("PlayerSpawn", "TFHatCleanup", function(pl)
	for _,v in pairs(ents.FindByClass("tf_hat")) do
		if v:GetOwner()==pl and v.Dead then
			v:Remove()
		end
	end
end)

end

local ActivityTranslateFixTF2 = {} 
if CLIENT then
	
	hook.Add("PlayerFireAnimationEvent","OnStepEventPlayStepSound",function( pl, pos, ang, event, name )
		if (event == 7001) then
			
			local tr = util.TraceLine( {
				start = pl:GetPos() + Vector(0,0,72),
				endpos = pl:GetPos() - Vector(0,0,4) * 16,
				mask = MASK_PLAYERSOLID_BRUSHONLY,
				collisiongroup = COLLISION_GROUP_PLAYER_MOVEMENT
			} )
			--debugoverlay.Line( pl:GetPos() + Vector(0,0,72), pl:GetPos() - Vector(0,0,4) * 4, 1, Color(255,255,255) )
			if (tr.MatType == MAT_CONCRETE) then

				pl:EmitSound("Concrete.Step"..table.Random({"Right","Left"}))

			elseif (tr.MatType == MAT_DEFAULT) then

				pl:EmitSound("Concrete.Step"..table.Random({"Right","Left"}))

			elseif (tr.MatType == MAT_GRASS) then

				pl:EmitSound("Grass.Step"..table.Random({"Right","Left"}))

			elseif (tr.MatType == MAT_DIRT) then

				pl:EmitSound("Dirt.Step"..table.Random({"Right","Left"}))

			elseif (tr.MatType == MAT_METAL) then

				pl:EmitSound("Metal.Step"..table.Random({"Right","Left"}))

			elseif (tr.MatType == MAT_SNOW) then

				pl:EmitSound("Snow.Step"..table.Random({"Right","Left"}))

			elseif (tr.MatType == MAT_PLASTIC) then

				pl:EmitSound("Plastic.Step"..table.Random({"Right","Left"}))

			elseif (tr.MatType == MAT_FLESH || tr.MatType == MAT_BLOODYFLESH) then

				pl:EmitSound("Flesh.Step"..table.Random({"Right","Left"}))

			elseif (tr.MatType == MAT_SAND) then

				pl:EmitSound("Sand.Step"..table.Random({"Right","Left"}))

			elseif (tr.MatType == MAT_SLOSH) then

				pl:EmitSound("Mud.Step"..table.Random({"Right","Left"}))

			elseif (tr.MatType == MAT_TILE) then

				pl:EmitSound("Tile.Step"..table.Random({"Right","Left"}))

			elseif (tr.MatType == MAT_VENT) then

				pl:EmitSound("MetalVent.Step"..table.Random({"Right","Left"}))

			elseif (tr.MatType == MAT_COMPUTER) then

				pl:EmitSound("MetalVent.Step"..table.Random({"Right","Left"}))

			elseif (tr.MatType == MAT_FOLIAGE) then

				pl:EmitSound("Wood.Step"..table.Random({"Right","Left"}))

			elseif (tr.MatType == MAT_WOOD) then

				pl:EmitSound("Wood.Step"..table.Random({"Right","Left"}))

			elseif (tr.MatType == MAT_GRATE) then

				pl:EmitSound("MetalGrate.Step"..table.Random({"Right","Left"}))

			end
			 
		end
	end)

end

hook.Add( "PlayerSwitchWeapon", "SetTF2Hands", function( ply, oldWeapon, newWeapon )
	if SERVER then
		if (!ply:IsHL2() and !ply:IsL4D()) then
			timer.Simple(0.1, function()
			
				GAMEMODE:PlayerSetHandsModel( ply, ply:GetHands() )

			end)
		end
	end
end)

hook.Add("EntityTakeDamage", "InfectedHurt", function(ent,dmginfo)
	if (ent:IsPlayer()) then 
		if (dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():IsL4D() and dmginfo:GetAttacker():EntityTeam(ent) != ent:Team()) then
			if (ent:Health() > 0) then
				ent:EmitSound("PlayerZombie.AttackHit") 
			end
		end
		if (dmginfo:GetAttacker():IsPlayer() and dmginfo:GetAttacker():EntityTeam(ent) == ent:Team()) then
			if (ent:IsL4D() and ent:Health() > 0) then
				dmginfo:ScaleDamage(0.3)
				ent:SetViewPunchAngles(Angle(math.random(-4,4),math.random(-4,4),math.random(-4,4)))
				dmginfo:SetDamageForce(Vector(0,0,0))
				timer.Simple(0.0001, function()
					ent:SetLocalVelocity(ent:GetAimVector() * ent:GetClassSpeed())
				end)
				--[[
				if (ent:GetPlayerClass() == "tank_l4d") then
					dmginfo:SetDamageForce(Vector(0,0,0))
					timer.Simple(0.0001, function()
						ent:SetLocalVelocity(ent:GetAimVector() * ent:GetClassSpeed())
					end)
				else
					dmginfo:SetDamageForce(Vector(0,0,0))
					timer.Simple(0.0001, function()
						ent:SetLocalVelocity(Vector(0,0,0))
					end)
				end
				]]
				if (ent:GetPlayerClass() == "boomer") then
					if (dmginfo:IsDamageType(DMG_BURN)) then
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.0)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_BoomerZombie.Pain")

							else

								ent:EmitSound("BoomerZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.65
						end
						--ent:Ignite(30,90)
						--dmginfo:ScaleDamage(3)
					else
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.0)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_BoomerZombie.PainShort")

							else

								ent:EmitSound("BoomerZombie.PainShort")

							end
							ent.NextSpeak = CurTime() + 0.7
						end
						--dmginfo:ScaleDamage(1.5)
					end
				elseif (ent:GetPlayerClass() == "smoker") then
					if (dmginfo:IsDamageType(DMG_BURN)) then
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.5)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_SmokerZombie.Pain")

							else

								ent:EmitSound("SmokerZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.65
						end
						--ent:Ignite(30,90)
						--dmginfo:ScaleDamage(3)
					else
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.0)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_SmokerZombie.PainShort")

							else

								ent:EmitSound("SmokerZombie.PainShort")

							end
							ent.NextSpeak = CurTime() + 0.7
						end
						--dmginfo:ScaleDamage(1.5)
					end
				elseif (ent:GetPlayerClass() == "hunter") then
					if (dmginfo:IsDamageType(DMG_BURN)) then
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.5)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_HunterZombie.Pain")

							else

								ent:EmitSound("HunterZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.65
						end
						--ent:Ignite(30,90)
						--dmginfo:ScaleDamage(3)
					else
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.0)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_HunterZombie.PainShort")

							else

								ent:EmitSound("HunterZombie.PainShort")

							end
							ent.NextSpeak = CurTime() + 0.7
						end
						--dmginfo:ScaleDamage(1.5)
					end
				elseif (ent:GetPlayerClass() == "tank_l4d") then
					if (dmginfo:IsDamageType(DMG_BURN)) then
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.5)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_HulkZombie.Pain")

							else

								ent:EmitSound("HulkZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.65
						end
						--ent:Ignite(30,90)
						--dmginfo:ScaleDamage(3)
					else
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.0)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_HulkZombie.Pain")

							else

								ent:EmitSound("HulkZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.7
						end
						--dmginfo:ScaleDamage(1.5)
					end
				elseif (ent:GetPlayerClass() == "charger") then
					if (dmginfo:IsDamageType(DMG_BURN)) then
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.5)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_ChargerZombie.Pain")

							else

								ent:EmitSound("ChargerZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.65
						end
						--ent:Ignite(30,90)
						--dmginfo:ScaleDamage(3)
					else
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.0)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_ChargerZombie.Pain")

							else

								ent:EmitSound("ChargerZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.7
						end
						--dmginfo:ScaleDamage(1.5)
					end
				elseif (ent:GetPlayerClass() == "jockey") then
					if (dmginfo:IsDamageType(DMG_BURN)) then
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.5)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_JockeyZombie.Pain")

							else

								ent:EmitSound("JockeyZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.65
						end
						--ent:Ignite(30,90)
						--dmginfo:ScaleDamage(3)
					else
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.0)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_JockeyZombie.PainShort")

							else

								ent:EmitSound("JockeyZombie.PainShort")

							end
							ent.NextSpeak = CurTime() + 0.7
						end
						--dmginfo:ScaleDamage(1.5)
					end
				elseif (ent:GetPlayerClass() == "spitter") then
					if (dmginfo:IsDamageType(DMG_BURN)) then
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.5)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("SpitterZombie.Pain")

							else

								ent:EmitSound("SpitterZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.65
						end
						--ent:Ignite(30,90)
						--dmginfo:ScaleDamage(3)
					else
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.0)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("SpitterZombie.PainShort")

							else

								ent:EmitSound("SpitterZombie.PainShort")

							end
							ent.NextSpeak = CurTime() + 0.7
						end
						--dmginfo:ScaleDamage(1.5)
					end
				end
			end
		else
			if (ent:IsL4D() and ent:Health() > 0) then
				dmginfo:SetDamageForce(Vector(0,0,0))
				ent:SetViewPunchAngles(Angle(math.random(-4,4),math.random(-4,4),math.random(-4,4)))
				local oldvelocity = ent:GetVelocity()
				if (ent:GetPlayerClass() == "tank_l4d") then
					dmginfo:SetDamageForce(Vector(0,0,0))
					timer.Simple(0.0001, function()
						ent:SetLocalVelocity(oldvelocity + ent:GetAimVector() * 4)
					end)
				else
					dmginfo:SetDamageForce(Vector(0,0,0))
					timer.Simple(0.0001, function()
						ent:SetLocalVelocity(Vector(0,0,0))
					end)
				end
				if (ent:GetPlayerClass() == "boomer") then
					if (dmginfo:IsDamageType(DMG_BURN)) then
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.0)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_BoomerZombie.Pain")

							else

								ent:EmitSound("BoomerZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.65
						end
						ent:Ignite(30,90)
						dmginfo:ScaleDamage(3)
					else
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.0)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_BoomerZombie.PainShort")

							else

								ent:EmitSound("BoomerZombie.PainShort")

							end
							ent.NextSpeak = CurTime() + 0.7
						end
						dmginfo:ScaleDamage(1.2)
					end
				elseif (ent:GetPlayerClass() == "smoker") then
					if (dmginfo:IsDamageType(DMG_BURN)) then
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.5)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_SmokerZombie.Pain")

							else

								ent:EmitSound("SmokerZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.65
						end
						ent:Ignite(30,90)
						dmginfo:ScaleDamage(3)
					else
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.0)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_SmokerZombie.PainShort")

							else

								ent:EmitSound("SmokerZombie.PainShort")

							end
							ent.NextSpeak = CurTime() + 0.7
						end
						dmginfo:ScaleDamage(1.2)
					end
				elseif (ent:GetPlayerClass() == "hunter") then
					if (dmginfo:IsDamageType(DMG_BURN)) then
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.5)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_HunterZombie.Pain")

							else

								ent:EmitSound("HunterZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.65
						end
						ent:Ignite(30,90)
						dmginfo:ScaleDamage(3)
					else
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.0)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_HunterZombie.PainShort")

							else

								ent:EmitSound("HunterZombie.PainShort")

							end
							ent.NextSpeak = CurTime() + 0.7
						end
						dmginfo:ScaleDamage(1.2)
					end
				elseif (ent:GetPlayerClass() == "tank_l4d") then
					if (dmginfo:IsDamageType(DMG_BURN)) then
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.5)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_HulkZombie.Pain")

							else

								ent:EmitSound("HulkZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.65
						end
						ent:Ignite(30,90)
						dmginfo:ScaleDamage(3)
					else
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.0)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_HulkZombie.Pain")

							else

								ent:EmitSound("HulkZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.7
						end
						dmginfo:ScaleDamage(1.5)
					end
				elseif (ent:GetPlayerClass() == "charger") then
					if (dmginfo:IsDamageType(DMG_BURN)) then
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.5)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_ChargerZombie.Pain")

							else

								ent:EmitSound("ChargerZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.65
						end
						ent:Ignite(30,90)
						dmginfo:ScaleDamage(3)
					else
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.0)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_ChargerZombie.Pain")

							else

								ent:EmitSound("ChargerZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.7
						end
						dmginfo:ScaleDamage(1.2)
					end
				elseif (ent:GetPlayerClass() == "jockey") then
					if (dmginfo:IsDamageType(DMG_BURN)) then
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.5)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_JockeyZombie.Pain")

							else

								ent:EmitSound("JockeyZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.65
						end
						ent:Ignite(30,90)
						dmginfo:ScaleDamage(3)
					else
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.0)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("L4D1_JockeyZombie.PainShort")

							else

								ent:EmitSound("JockeyZombie.PainShort")

							end
							ent.NextSpeak = CurTime() + 0.7
						end
						dmginfo:ScaleDamage(1.2)
					end
				elseif (ent:GetPlayerClass() == "spitter") then
					if (dmginfo:IsDamageType(DMG_BURN)) then
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.5)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("SpitterZombie.Pain")

							else

								ent:EmitSound("SpitterZombie.Pain")

							end
							ent.NextSpeak = CurTime() + 0.65
						end
						ent:Ignite(30,90)
						dmginfo:ScaleDamage(3)
					else
						if (!ent.NextSpeak or CurTime() > ent.NextSpeak) then
							timer.Adjust("VoiceL4d"..ent:EntIndex(), 1.0)
							if (string.find(ent:GetModel(),"l4d1")) then

								ent:EmitSound("SpitterZombie.PainShort")

							else

								ent:EmitSound("SpitterZombie.PainShort")

							end
							ent.NextSpeak = CurTime() + 0.7
						end
						dmginfo:ScaleDamage(1.2)
					end
				end
			end
		end
	end
end)
-- Porting from Latest TF2 GM Builds, and edited.
hook.Add("EntityEmitSound", "MouthFix", function(snd)
	local p = snd.Pitch

	if ( game.GetTimeScale() != 1 ) then
		p = p * game.GetTimeScale()
	end

	if ( GetConVarNumber( "host_timescale" ) != 1 && GetConVarNumber( "sv_cheats" ) >= 1 ) then
		p = p * GetConVarNumber( "host_timescale" )
	end

	if ( p != snd.Pitch ) then
		snd.Pitch = math.Clamp( p, 0, 255 )
		return true
	end

	if ( CLIENT && engine.GetDemoPlaybackTimeScale() != 1 ) then
		snd.Pitch = math.Clamp( snd.Pitch * engine.GetDemoPlaybackTimeScale(), 0, 255 )
		return true
	end
	if CLIENT and !IsValid(snd.Entity) then return end
	if (IsValid(snd.Entity)) then
		if (GetConVar("civ2_randomizer"):GetBool()) then	
			if (!snd.Entity.IsRandomized) then
				for i=0,snd.Entity:GetBoneCount() do
					snd.Entity:ManipulateBoneJiggle( i, 1 )	
				end
			snd.Entity.IsRandomized = true
			end
		elseif (!GetConVar("civ2_randomizer"):GetBool()) then
			if (snd.Entity.IsRandomized) then
				for i=0,snd.Entity:GetBoneCount() do
					snd.Entity:ManipulateBoneJiggle( i, 0 )	
				end
				snd.Entity.IsRandomized = false
			end
		end
	end
	if (GetConVar("civ2_randomizer"):GetBool()) then
			snd.DSP = table.Random({0,0,0,0,134,135})
		if (IsMounted("hl1") and math.random(1,5) == 1) then
			if (math.random(1,42) == 1) then
				snd.SoundName = table.Random({"agrunt/"..table.Random(file.Find("sound/agrunt/*","hl1"))})
			elseif (math.random(1,42) == 2) then
				snd.SoundName = table.Random({"ambience/"..table.Random(file.Find("sound/ambience/*","hl1"))})
			elseif (math.random(1,42) == 3) then
				snd.SoundName = table.Random({"apache/"..table.Random(file.Find("sound/apache/*","hl1"))})
			elseif (math.random(1,42) == 4) then
				snd.SoundName = table.Random({"aslave/"..table.Random(file.Find("sound/aslave/*","hl1"))})
			elseif (math.random(1,42) == 5) then
				snd.SoundName = table.Random({"barnacle/"..table.Random(file.Find("sound/barnacle/*","hl1"))})
			elseif (math.random(1,42) == 6) then
				snd.SoundName = table.Random({"barney/"..table.Random(file.Find("sound/barney/*","hl1"))})
			elseif (math.random(1,42) == 7) then
				snd.SoundName = table.Random({"boid/"..table.Random(file.Find("sound/boid/*","hl1"))})
			elseif (math.random(1,42) == 8) then
				snd.SoundName = table.Random({"bullchicken/"..table.Random(file.Find("sound/bullchicken/*","hl1"))})
			elseif (math.random(1,42) == 9) then
				snd.SoundName = table.Random({"buttons/"..table.Random(file.Find("sound/buttons/*","hl1"))})
			elseif (math.random(1,42) == 10) then
				snd.SoundName = table.Random({"common/"..table.Random(file.Find("sound/common/*","hl1"))})
			elseif (math.random(1,42) == 11) then
				snd.SoundName = table.Random({"controller/"..table.Random(file.Find("sound/controller/*","hl1"))})
			elseif (math.random(1,42) == 12) then
				snd.SoundName = table.Random({"debris/"..table.Random(file.Find("sound/debris/*","hl1"))})
			elseif (math.random(1,42) == 13) then
				snd.SoundName = table.Random({"doors/"..table.Random(file.Find("sound/doors/*","hl1"))})
			elseif (math.random(1,42) == 14) then
				snd.SoundName = table.Random({"fans/"..table.Random(file.Find("sound/fans/*","hl1"))})
			elseif (math.random(1,42) == 15) then
				snd.SoundName = table.Random({"fvox/"..table.Random(file.Find("sound/fvox/*","hl1"))})
			elseif (math.random(1,42) == 16) then
				snd.SoundName = table.Random({"garg/"..table.Random(file.Find("sound/garg/*","hl1"))})
			elseif (math.random(1,42) == 17) then
				snd.SoundName = table.Random({"gman/"..table.Random(file.Find("sound/gman/*","hl1"))})
			elseif (math.random(1,42) == 18) then
				snd.SoundName = table.Random({"gonarch/"..table.Random(file.Find("sound/gonarch/*","hl1"))})
			elseif (math.random(1,42) == 19) then
				snd.SoundName = table.Random({"hassault/"..table.Random(file.Find("sound/hassault/*","hl1"))})
			elseif (math.random(1,42) == 20) then
				snd.SoundName = table.Random({"headcrab/"..table.Random(file.Find("sound/headcrab/*","hl1"))})
			elseif (math.random(1,42) == 21) then
				snd.SoundName = table.Random({"hgrunt/"..table.Random(file.Find("sound/hgrunt/*","hl1"))})
			elseif (math.random(1,42) == 22) then
				snd.SoundName = table.Random({"holo/"..table.Random(file.Find("sound/holo/*","hl1"))})
			elseif (math.random(1,42) == 23) then
				snd.SoundName = table.Random({"hornet/"..table.Random(file.Find("sound/hornet/*","hl1"))})
			elseif (math.random(1,42) == 24) then
				snd.SoundName = table.Random({"houndeye/"..table.Random(file.Find("sound/houndeye/*","hl1"))})
			elseif (math.random(1,42) == 25) then
				snd.SoundName = table.Random({"ichy/"..table.Random(file.Find("sound/ichy/*","hl1"))})
			elseif (math.random(1,42) == 26) then
				snd.SoundName = table.Random({"items/"..table.Random(file.Find("sound/items/*","hl1"))})
			elseif (math.random(1,42) == 27) then
				snd.SoundName = table.Random({"misc/"..table.Random(file.Find("sound/misc/*","hl1"))})
			elseif (math.random(1,42) == 28) then
				snd.SoundName = table.Random({"plats/"..table.Random(file.Find("sound/plats/*","hl1"))})
			elseif (math.random(1,42) == 29) then
				snd.SoundName = table.Random({"player/"..table.Random(file.Find("sound/player/*","hl1"))})
			elseif (math.random(1,42) == 30) then
				snd.SoundName = table.Random({"roach/"..table.Random(file.Find("sound/roach/*","hl1"))})
			elseif (math.random(1,42) == 31) then
				snd.SoundName = table.Random({"scientist/"..table.Random(file.Find("sound/scientist/*","hl1"))})
			elseif (math.random(1,42) == 32) then
				snd.SoundName = table.Random({"squeek/"..table.Random(file.Find("sound/squeek/*","hl1"))})
			elseif (math.random(1,42) == 33) then
				snd.SoundName = table.Random({"tentacle/"..table.Random(file.Find("sound/tentacle/*","hl1"))})
			elseif (math.random(1,42) == 34) then
				snd.SoundName = table.Random({"tride/"..table.Random(file.Find("sound/tride/*","hl1"))})
			elseif (math.random(1,42) == 35) then
				snd.SoundName = table.Random({"turret/"..table.Random(file.Find("sound/turret/*","hl1"))})
			elseif (math.random(1,42) == 36) then
				snd.SoundName = table.Random({"ui/"..table.Random(file.Find("sound/ui/*","hl1"))})
			elseif (math.random(1,42) == 37) then
				snd.SoundName = table.Random({"vox/"..table.Random(file.Find("sound/vox/*","GAME"))})
			elseif (math.random(1,42) == 38) then
				snd.SoundName = table.Random({"weapons/"..table.Random(file.Find("sound/weapons/*","hl1"))})
			elseif (math.random(1,42) == 39) then
				snd.SoundName = table.Random({"x/"..table.Random(file.Find("sound/x/*","hl1"))})
			elseif (math.random(1,42) == 40) then
				snd.SoundName = table.Random({"zombie/"..table.Random(file.Find("sound/zombie/*","hl1"))})
			else
				snd.SoundName = table.Random({"hgrunt/"..table.Random(file.Find("sound/hgrunt/*","hl1"))})
			end
			return true
		else
			local theTable = table.Random(sound.GetTable())
			snd.SoundName = sound.GetProperties(theTable).sound
			return true
		end
	end
	if (snd.Entity:IsPlayer() and !snd.Entity:IsHL2()) then
		if CLIENT then
			if !IsValid(snd.Entity) then return end
			local pl = snd.Entity
			if (!pl:IsL4D() and !pl:IsBot()) then
				if (pl:GetPlayerClass() != "gmodplayer") then
					pl:SetModel(pl:GetNWString("PlayerClassModel"))
				end
			elseif (pl:IsL4D()) then
				pl:SetModel(pl:GetNWString("L4DModel"))
			end

			if (string.find(snd.Entity:GetModel(),"hwm")) then

				if (snd.Entity.playerclass == "medicshotgun") then	
					snd.Entity:SetupPhonemeMappings( "player/hwm/medic/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "heavy") then 
					snd.Entity:SetupPhonemeMappings( "player/hwm/heavy/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "scout") then
					snd.Entity:SetupPhonemeMappings( "player/hwm/scout/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "pyro") then
					snd.Entity:SetupPhonemeMappings( "player/hwm/scout/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "soldier") then
					snd.Entity:SetupPhonemeMappings( "player/hwm/soldier/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "demoman") then
					snd.Entity:SetupPhonemeMappings( "player/hwm/demo/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "engineer") then
					snd.Entity:SetupPhonemeMappings( "player/hwm/engineer/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "medic") then
					snd.Entity:SetupPhonemeMappings( "player/hwm/medic/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "sniper") then
					snd.Entity:SetupPhonemeMappings( "player/hwm/sniper/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "spy") then
					snd.Entity:SetupPhonemeMappings( "player/hwm/spy/phonemes/phonemes" )
				else
					snd.Entity:SetupPhonemeMappings( "player/hwm/heavy/phonemes/phonemes" )
				end

			else
				if (snd.Entity.playerclass == "medicshotgun") then	
					snd.Entity:SetupPhonemeMappings( "player/medic/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "heavy") then
					snd.Entity:SetupPhonemeMappings( "player/heavy/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "scout") then
					snd.Entity:SetupPhonemeMappings( "player/scout/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "soldier") then
					snd.Entity:SetupPhonemeMappings( "player/soldier/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "demoman") then
					snd.Entity:SetupPhonemeMappings( "player/demo/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "engineer") then
					snd.Entity:SetupPhonemeMappings( "player/engineer/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "medic") then
					snd.Entity:SetupPhonemeMappings( "player/medic/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "sniper") then
					snd.Entity:SetupPhonemeMappings( "player/sniper/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "spy") then
					snd.Entity:SetupPhonemeMappings( "player/spy/phonemes/phonemes" )
				else
					snd.Entity:SetupPhonemeMappings( "player/heavy/phonemes/phonemes" )
				end
			end
		end
	elseif (snd.Entity:IsPlayer() and snd.Entity:IsHL2()) then
		if CLIENT and !snd.Entity:IsBot() then
			if !IsValid(snd.Entity) then return end
			snd.Entity:SetupPhonemeMappings("phonemes")
			snd.Entity:SetModel(snd.Entity:GetNWString("PlayerClassModel"))
		end
		
		--[[
if (IsMounted("left4dead") or IsMounted("left4dead2")) then 
			local pos = snd.Entity:GetPos()
			if (snd.Pos) then
				pos = snd.Pos
			end
			if (snd.Channel == CHAN_BODY) then
				if (math.random(1,6) != 1) then
					snd.Channel = CHAN_STATIC
					return true
				end
			end
		end]]
		if (snd.Entity:GetClass() == "infected") then
			if (string.find(snd.Entity:GetModel(),"clown")) then

				for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
					if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
						if (IsValid(snd.Entity:GetEnemy())) then
							v:SetEnemy(snd.Entity:GetEnemy())
							v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
						end
					end
				end

			end
		end
		if (snd.Entity:IsTFPlayer() and GAMEMODE:EntityTeam(snd.Entity) != TEAM_GREEN) then

			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
				if (v:IsPlayer() and v:IsL4D() and !IsValid(v.TargetEnt) and v.TFBot) then
					v.TargetEnt = snd.Entity

					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end

		end
		if (snd.Entity:IsTFPlayer() and !snd.Entity:IsNextBot()) then
			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),400)) do
				if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
					v:SetEnemy(snd.Entity)
					v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
	
					if SERVER then
						local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
						v:AddGestureSequence(anim,true)
					end
	
					timer.Stop("IdleExpression"..v:EntIndex())
					timer.Stop("AngryExpression"..v:EntIndex())
					timer.Create("AngryExpression"..v:EntIndex(), 3, 0, function()
						
						if SERVER then
							local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
							v:AddGestureSequence(anim,true)
						end
	
						timer.Adjust("AngryExpression"..v:EntIndex(),v:SequenceDuration(anim))
					end)
					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end
		end
	elseif (!snd.Entity:IsPlayer()) then
		if CLIENT then
			if !IsValid(snd.Entity) then return end
			if (string.find(snd.Entity:GetModel(),"hwm")) then
 
				if (snd.Entity.playerclass == "medicshotgun") then	
					snd.Entity:SetupPhonemeMappings( "player/hwm/medic/emotions/emotions" )
					snd.Entity:SetupPhonemeMappings( "player/hwm/medic/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "heavy") then 
					snd.Entity:SetupPhonemeMappings( "player/hwm/heavy/emotions/emotions" )
					snd.Entity:SetupPhonemeMappings( "player/hwm/heavy/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "scout") then
					snd.Entity:SetupPhonemeMappings( "player/hwm/scout/emotions/emotions" )
					snd.Entity:SetupPhonemeMappings( "player/hwm/scout/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "soldier") then
					snd.Entity:SetupPhonemeMappings( "player/hwm/soldier/emotions/emotions" )
					snd.Entity:SetupPhonemeMappings( "player/hwm/soldier/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "demoman") then
					snd.Entity:SetupPhonemeMappings( "player/hwm/demo/emotions/emotions" )
					snd.Entity:SetupPhonemeMappings( "player/hwm/demo/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "engineer") then
					snd.Entity:SetupPhonemeMappings( "player/hwm/engineer/emotions/emotions" )
					snd.Entity:SetupPhonemeMappings( "player/hwm/engineer/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "medic") then
					snd.Entity:SetupPhonemeMappings( "player/hwm/medic/emotions/emotions" )
					snd.Entity:SetupPhonemeMappings( "player/hwm/medic/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "sniper") then
					snd.Entity:SetupPhonemeMappings( "player/hwm/sniper/emotions/emotions" )
					snd.Entity:SetupPhonemeMappings( "player/hwm/sniper/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "spy") then
					snd.Entity:SetupPhonemeMappings( "player/hwm/spy/emotions/emotions" )
					snd.Entity:SetupPhonemeMappings( "player/hwm/spy/phonemes/phonemes" )
				else
					snd.Entity:SetupPhonemeMappings( "player/hwm/heavy/emotions/emotions" )
					snd.Entity:SetupPhonemeMappings( "player/hwm/heavy/phonemes/phonemes" )
				end

			else
				if (snd.Entity.playerclass == "medicshotgun") then	
					snd.Entity:SetupPhonemeMappings( "player/medic/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "heavy") then
					snd.Entity:SetupPhonemeMappings( "player/heavy/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "scout") then
					snd.Entity:SetupPhonemeMappings( "player/scout/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "soldier") then
					snd.Entity:SetupPhonemeMappings( "player/soldier/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "demoman") then
					snd.Entity:SetupPhonemeMappings( "player/demo/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "engineer") then
					snd.Entity:SetupPhonemeMappings( "player/engineer/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "medic") then
					snd.Entity:SetupPhonemeMappings( "player/medic/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "sniper") then
					snd.Entity:SetupPhonemeMappings( "player/sniper/phonemes/phonemes" )
				elseif (snd.Entity.playerclass == "spy") then
					snd.Entity:SetupPhonemeMappings( "player/spy/phonemes/phonemes" )
				else
					snd.Entity:SetupPhonemeMappings( "player/heavy/phonemes/phonemes" )
				end
			end
		end
	end
end)

hook.Add("Think","Bacterias",function()
	if (math.random(1,150) == 1 and SERVER) then
		for k,v in ipairs(player.GetAll()) do
			if (v:Alive()) then
				if (v:GetPlayerClass() == "boomer") then
					if (math.random(1,5) == 1) then
						v:EmitSound(table.Random({"Event.BoomerAlert","Event.BoomerAlert","Event.BoomerAlert","Event.BoomerAlertClose"}))
					end
				elseif (v:GetPlayerClass() == "charger") then
					if (math.random(1,5) == 1) then
						v:EmitSound(table.Random({"Event.ChargerAlert","Event.ChargerAlert","Event.ChargerAlert","Event.ChargerAlertClose"}))	
					end
				elseif (v:GetPlayerClass() == "hunter") then
					if (math.random(1,5) == 1) then
						v:EmitSound(table.Random({"Event.HunterAlert","Event.HunterAlert","Event.HunterAlert","Event.HunterAlertClose"}))
					end
				elseif (v:GetPlayerClass() == "smoker") then
					if (math.random(1,5) == 1) then
						v:EmitSound(table.Random({"Event.SmokerAlert","Event.SmokerAlert","Event.SmokerAlert","Event.SmokerAlertClose"}))
					end
				elseif (v:GetPlayerClass() == "jockey") then
					if (math.random(1,5) == 1) then
						v:EmitSound(table.Random({"Event.JockeyAlert","Event.JockeyAlert","Event.JockeyAlert","Event.JockeyAlertClose"}))
					end
				elseif (v:GetPlayerClass() == "spitter") then
					if (math.random(1,5) == 1) then
						v:EmitSound(table.Random({"Event.SpitterAlert","Event.SpitterAlert","Event.SpitterAlert","Event.SpitterAlertClose"}))
					end
				end
			end
		end
	end
end)

timer.Create("FixImprovedNPCsConflict",0.1,0, function()
	hook.Remove("Think","DeviantartistThink")
	hook.Remove("Think","DeviantartistThink2")
	--hook.Remove("EntityTakeDamage", "DamageShit")
end)

hook.Remove("TranslateActivity", "TF2PMStuff")
hook.Add("TranslateActivity", "TF2PMStuff", function(pl, act) 
	local holdtype
    if (IsValid(pl:GetActiveWeapon())) then
       holdtype = pl:GetActiveWeapon().HoldType or pl:GetActiveWeapon():GetHoldType() 
    end
	if (pl:GetModel() == "models/player/hwm/scout.mdl" || pl:GetModel() == "models/player/hwm/engineer.mdl" || pl:GetModel() == "models/player/scout.mdl" || pl:GetModel() == "models/player/engineer.mdl") then
		if (IsValid(pl:GetActiveWeapon())) then
			if (holdtype == "normal") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_SWIM] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_walk_MELE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_SWIM] 						= pl:GetSequenceActivity(pl:LookupSequence("swim_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE 
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			elseif (holdtype == "shotgun" || holdtype == "crossbow" || holdtype == "physgun" || holdtype == "rpg" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_PRIMARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_PRIMARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_PRIMARY				
			elseif (holdtype == "pistol" || holdtype == "revolver" || holdtype == "smg" || holdtype == "ar2" || holdtype == "dual" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_SECONDARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_SECONDARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_SECONDARY	
			elseif (holdtype == "melee" || holdtype == "melee2" || holdtype == "grenade" || holdtype == "fist" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_MELEE
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_MELEE	
			end
			
			if (!pl:GetActiveWeapon().HoldTypeHL2) then
				return ActivityTranslateFixTF2[act] or act
			end
		end
	elseif (pl:GetModel() == "models/player/hwm/soldier.mdl" or pl:GetModel() == "models/player/soldier.mdl") then
		if (IsValid(pl:GetActiveWeapon())) then
			if (holdtype == "normal") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_SWIM] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_walk_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_SWIM] 						= pl:GetSequenceActivity(pl:LookupSequence("swim_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			elseif (holdtype == "pistol" || holdtype == "revolver") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_SECONDARY2"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_SECONDARY2"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_SECONDARY2"))
                ActivityTranslateFixTF2[ACT_MP_SWIM] 							= pl:GetSequenceActivity(pl:LookupSequence("run_SECONDARY2"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_SECONDARY2"))
                ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_SECONDARY2"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_walk_SECONDARY2"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackstand_SECONDARY2"))
                ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackcrouch_SECONDARY2"))
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= pl:GetSequenceActivity(pl:LookupSequence("reloadstand_SECONDARY2"))
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= pl:GetSequenceActivity(pl:LookupSequence("reloadcrouch_SECONDARY2"))
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= pl:GetSequenceActivity(pl:LookupSequence("jump_start_SECONDARY2"))
                ActivityTranslateFixTF2[ACT_MP_SWIM] 						= pl:GetSequenceActivity(pl:LookupSequence("swim_SECONDARY2"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_SECONDARY2"))				
			elseif (holdtype == "rpg" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_PRIMARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_PRIMARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_PRIMARY				
			elseif (holdtype == "shotgun" || holdtype == "crossbow" || holdtype == "physgun" || holdtype == "smg" || holdtype == "ar2" || holdtype == "dual" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_SECONDARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_SECONDARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_SECONDARY	
			elseif (holdtype == "melee" || holdtype == "melee2" || holdtype == "grenade" || holdtype == "fist" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_MELEE
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= pl:GetSequenceActivity(pl:LookupSequence("swim_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_MELEE			
			end
			if (!pl:GetActiveWeapon().HoldTypeHL2) then
				return ActivityTranslateFixTF2[act] or act
			end
		end
	elseif (pl:GetModel() == "models/player/hwm/heavy.mdl" or pl:GetModel() == "models/player/heavy.mdl") then
		if (IsValid(pl:GetActiveWeapon())) then
			if (holdtype == "normal") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_SWIM] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_walk_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_SWIM] 						= pl:GetSequenceActivity(pl:LookupSequence("swim_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))			
			elseif (holdtype == "rpg" || holdtype == "crossbow" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_PRIMARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_PRIMARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_PRIMARY				
			elseif (holdtype == "shotgun" || holdtype == "physgun" || holdtype == "pistol" || holdtype == "revolver" || holdtype == "smg" || holdtype == "ar2" || holdtype == "dual" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_SECONDARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_SECONDARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_SECONDARY	
			elseif ( holdtype == "fist" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_MELEE
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_MELEE
			elseif ( holdtype == "melee" || holdtype == "melee2" || holdtype == "grenade" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_walk_MELEE_ALLCLASS"))
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackStand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackCrouch_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= pl:GetSequenceActivity(pl:LookupSequence("swim_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_MELEE_ALLCLASS"))			
			end
			
			if (!pl:GetActiveWeapon().HoldTypeHL2) then
				return ActivityTranslateFixTF2[act] or act
			end
		end
	elseif (pl:GetModel() == "models/player/hwm/sniper.mdl" or pl:GetModel() == "models/player/sniper.mdl") then
		if (IsValid(pl:GetActiveWeapon())) then
			if (holdtype == "normal") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_SWIM] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_walk_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_SWIM] 						= pl:GetSequenceActivity(pl:LookupSequence("swim_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			elseif (holdtype == "rpg" || holdtype == "crossbow" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_PRIMARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_PRIMARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_PRIMARY				
			elseif (holdtype == "shotgun" || holdtype == "physgun" || holdtype == "pistol" || holdtype == "revolver" || holdtype == "smg" || holdtype == "ar2" || holdtype == "dual" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_SECONDARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_SECONDARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_SECONDARY	
			elseif ( holdtype == "melee" || holdtype == "knife" || holdtype == "fist" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_MELEE
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_MELEE
			elseif ( holdtype == "melee2" || holdtype == "grenade" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_walk_MELEE_ALLCLASS"))
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackStand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackCrouch_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= pl:GetSequenceActivity(pl:LookupSequence("swim_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_MELEE_ALLCLASS"))			
			end
			
			if (!pl:GetActiveWeapon().HoldTypeHL2) then
				return ActivityTranslateFixTF2[act] or act
			end
		end
	elseif (pl:GetModel() == "models/player/hwm/demo.mdl" or pl:GetModel() == "models/player/demo.mdl") then
		if (IsValid(pl:GetActiveWeapon())) then
			if (holdtype == "normal") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_SWIM] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_walk_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_SWIM] 						= pl:GetSequenceActivity(pl:LookupSequence("swim_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			elseif (holdtype == "rpg" || holdtype == "crossbow" || holdtype == "pistol" || holdtype == "smg" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_PRIMARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_PRIMARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_PRIMARY				
			elseif (holdtype == "shotgun" || holdtype == "physgun" || holdtype == "revolver" || holdtype == "ar2" || holdtype == "dual" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_SECONDARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_SECONDARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_SECONDARY	
			elseif ( holdtype == "melee" || holdtype == "knife" || holdtype == "fist" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_MELEE
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_MELEE
			elseif ( holdtype == "melee2" || holdtype == "grenade" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_walk_MELEE_ALLCLASS"))
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackStand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackCrouch_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= pl:GetSequenceActivity(pl:LookupSequence("swim_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_MELEE_ALLCLASS"))			
			end
			
			if (!pl:GetActiveWeapon().HoldTypeHL2) then
				return ActivityTranslateFixTF2[act] or act
			end
		end
	elseif (pl:GetModel() == "models/player/hwm/medic.mdl") then
		if (IsValid(pl:GetActiveWeapon())) then
			if (holdtype == "normal") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_SWIM] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_walk_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_SWIM] 						= pl:GetSequenceActivity(pl:LookupSequence("swim_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			elseif (holdtype == "shotgun" || holdtype == "rpg" || holdtype == "crossbow" || holdtype == "pistol" || holdtype == "smg" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_PRIMARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_PRIMARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_PRIMARY				
			elseif (holdtype == "physgun" || holdtype == "revolver" || holdtype == "ar2" || holdtype == "dual" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_SECONDARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_SECONDARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_SECONDARY	
			elseif ( holdtype == "melee" || holdtype == "knife" || holdtype == "fist" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_MELEE
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_MELEE
			elseif ( holdtype == "melee2" || holdtype == "grenade" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_walk_MELEE_ALLCLASS"))
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackStand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackCrouch_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= pl:GetSequenceActivity(pl:LookupSequence("swim_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_MELEE_ALLCLASS"))			
			end
			
			if (!pl:GetActiveWeapon().HoldTypeHL2) then
				return ActivityTranslateFixTF2[act] or act
			end
		end
	elseif (pl:GetModel() == "models/player/hwm/pyro.mdl" or pl:GetModel() == "models/player/pyro.mdl") then
		if (IsValid(pl:GetActiveWeapon())) then
			if (holdtype == "normal") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_SWIM] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_walk_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_SWIM] 						= pl:GetSequenceActivity(pl:LookupSequence("swim_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			elseif (holdtype == "rpg" || holdtype == "crossbow" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_PRIMARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_PRIMARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_PRIMARY				
			elseif (holdtype == "shotgun" || holdtype == "pistol" || holdtype == "smg" ||  holdtype == "physgun" || holdtype == "revolver" || holdtype == "ar2" || holdtype == "dual" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_SECONDARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_SECONDARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_SECONDARY	
			elseif ( holdtype == "melee2" || holdtype == "knife" || holdtype == "fist" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_MELEE
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_MELEE
			elseif (  holdtype == "melee" || holdtype == "grenade" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_walk_MELEE_ALLCLASS"))
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackStand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackCrouch_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= pl:GetSequenceActivity(pl:LookupSequence("swim_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_MELEE_ALLCLASS"))			
			end
			
			if (!pl:GetActiveWeapon().HoldTypeHL2) then
				return ActivityTranslateFixTF2[act] or act
			end
		end
	elseif (pl:GetModel() == "models/player/hwm/spy.mdl" or pl:GetModel() == "models/player/spy.mdl") then
		if (IsValid(pl:GetActiveWeapon())) then
			if (holdtype == "normal") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_SWIM] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_walk_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_SWIM] 						= pl:GetSequenceActivity(pl:LookupSequence("swim_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))						
			elseif (holdtype == "rpg" || holdtype == "crossbow" || holdtype == "shotgun" || holdtype == "physgun" || holdtype == "pistol" || holdtype == "revolver" || holdtype == "smg" || holdtype == "ar2" || holdtype == "dual" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_SECONDARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_SECONDARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_SECONDARY	
			elseif ( holdtype == "knife") then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= ACT_MP_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_MELEE
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= ACT_MP_ATTACK_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_MELEE
			elseif ( holdtype == "melee" || holdtype == "melee2" || holdtype == "grenade" || holdtype == "fist" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_CROUCH_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("crouch_walk_MELEE_ALLCLASS"))
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("MELEE_ALLCLASS_swing"))
				ActivityTranslateFixTF2[ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("MELEE_ALLCLASS_crouch_swing"))
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_CROUCH_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_SWIM_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_MELEE_ALLCLASS"))			
			end
			
			if (!pl:GetActiveWeapon().HoldTypeHL2) then
				return ActivityTranslateFixTF2[act] or act
			end
		end
	elseif (pl:GetModel() == "models/bots/scout/bot_scout.mdl" || pl:GetModel() == "models/bots/engineer/bot_engineer.mdl") then
		if (IsValid(pl:GetActiveWeapon())) then
			if (holdtype == "normal") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			elseif (holdtype == "shotgun" || holdtype == "crossbow" || holdtype == "physgun" || holdtype == "rpg" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_PRIMARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_PRIMARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_PRIMARY				
			elseif (holdtype == "pistol" || holdtype == "revolver" || holdtype == "smg" || holdtype == "ar2" || holdtype == "dual" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_SECONDARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_SECONDARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_SECONDARY	
			elseif (holdtype == "melee" || holdtype == "melee2" || holdtype == "grenade" || holdtype == "fist" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_MELEE
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_MELEE
			else 
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			end
			
			if (!pl:GetActiveWeapon().HoldTypeHL2) then
				return ActivityTranslateFixTF2[act] or act
			end
		end
	elseif (pl:GetModel() == "models/bots/soldier/bot_soldier.mdl") then
		if (IsValid(pl:GetActiveWeapon())) then
			if (holdtype == "normal") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			elseif (holdtype == "rpg" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_PRIMARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_PRIMARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_PRIMARY				
			elseif (holdtype == "shotgun" || holdtype == "crossbow" || holdtype == "physgun" || holdtype == "pistol" || holdtype == "revolver" || holdtype == "smg" || holdtype == "ar2" || holdtype == "dual" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_SECONDARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_SECONDARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_SECONDARY	
			elseif (holdtype == "melee" || holdtype == "melee2" || holdtype == "grenade" || holdtype == "fist" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_MELEE
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_MELEE
			else 
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			end
			
			if (!pl:GetActiveWeapon().HoldTypeHL2) then
				return ActivityTranslateFixTF2[act] or act
			end
		end
	elseif (pl:GetModel() == "models/bots/heavy/bot_heavy.mdl") then
		if (IsValid(pl:GetActiveWeapon())) then
			if (holdtype == "normal") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))			
			elseif (holdtype == "rpg" || holdtype == "crossbow" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_PRIMARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_PRIMARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_PRIMARY				
			elseif (holdtype == "shotgun" || holdtype == "physgun" || holdtype == "pistol" || holdtype == "revolver" || holdtype == "smg" || holdtype == "ar2" || holdtype == "dual" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_SECONDARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_SECONDARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_SECONDARY	
			elseif ( holdtype == "fist" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_MELEE
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_MELEE
			elseif ( holdtype == "melee" || holdtype == "melee2" || holdtype == "grenade" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackStand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackstand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_MELEE_ALLCLASS"))
			else 
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			end
			
			if (!pl:GetActiveWeapon().HoldTypeHL2) then
				return ActivityTranslateFixTF2[act] or act
			end
		end
	elseif (pl:GetModel() == "models/bots/sniper/bot_sniper.mdl") then
		if (IsValid(pl:GetActiveWeapon())) then
			if (holdtype == "normal") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			elseif (holdtype == "rpg" || holdtype == "crossbow" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_PRIMARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_PRIMARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_PRIMARY				
			elseif (holdtype == "shotgun" || holdtype == "physgun" || holdtype == "pistol" || holdtype == "revolver" || holdtype == "smg" || holdtype == "ar2" || holdtype == "dual" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_SECONDARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_SECONDARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_SECONDARY	
			elseif ( holdtype == "melee" || holdtype == "knife" || holdtype == "fist" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_MELEE
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_MELEE
			elseif ( holdtype == "melee2" || holdtype == "grenade" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackStand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackstand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_MELEE_ALLCLASS"))
			else 
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			end
			
			if (!pl:GetActiveWeapon().HoldTypeHL2) then
				return ActivityTranslateFixTF2[act] or act
			end
		end
	elseif (pl:GetModel() == "models/bots/demo/bot_demo.mdl") then
		if (IsValid(pl:GetActiveWeapon())) then
			if (holdtype == "normal") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			elseif (holdtype == "rpg" || holdtype == "crossbow" || holdtype == "pistol" || holdtype == "smg" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_PRIMARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_PRIMARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_PRIMARY				
			elseif (holdtype == "shotgun" || holdtype == "physgun" || holdtype == "revolver" || holdtype == "ar2" || holdtype == "dual" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_SECONDARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_SECONDARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_SECONDARY	
			elseif ( holdtype == "melee" || holdtype == "knife" || holdtype == "fist" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_MELEE
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_MELEE
			elseif ( holdtype == "melee2" || holdtype == "grenade" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackStand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackstand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_MELEE_ALLCLASS"))
			else 
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			end
			
			if (!pl:GetActiveWeapon().HoldTypeHL2) then
				return ActivityTranslateFixTF2[act] or act
			end
		end
	elseif (pl:GetModel() == "models/bots/medic/bot_medic.mdl") then
		if (IsValid(pl:GetActiveWeapon())) then
			if (holdtype == "normal") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			elseif (holdtype == "shotgun" || holdtype == "rpg" || holdtype == "crossbow" || holdtype == "pistol" || holdtype == "smg" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_PRIMARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_PRIMARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_PRIMARY				
			elseif (holdtype == "physgun" || holdtype == "revolver" || holdtype == "ar2" || holdtype == "dual" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_SECONDARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_SECONDARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_SECONDARY	
			elseif ( holdtype == "melee" || holdtype == "knife" || holdtype == "fist" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_MELEE
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_MELEE
			elseif ( holdtype == "melee2" || holdtype == "grenade" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackStand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackstand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_MELEE_ALLCLASS"))
			else 
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			end
			
			if (!pl:GetActiveWeapon().HoldTypeHL2) then
				return ActivityTranslateFixTF2[act] or act
			end
		end
	elseif (pl:GetModel() == "models/bots/pyro/bot_pyro.mdl") then
		if (IsValid(pl:GetActiveWeapon())) then
			if (holdtype == "normal") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			elseif (holdtype == "rpg" || holdtype == "crossbow" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= ACT_MP_RUN_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_AIRWALK_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_PRIMARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_PRIMARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_PRIMARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_PRIMARY				
			elseif (holdtype == "shotgun" || holdtype == "pistol" || holdtype == "smg" ||  holdtype == "physgun" || holdtype == "revolver" || holdtype == "ar2" || holdtype == "dual" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_AIRWALK_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_SECONDARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_SECONDARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_SECONDARY	
			elseif ( holdtype == "melee2" || holdtype == "knife" || holdtype == "fist" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= ACT_MP_AIRWALK_MELEE
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_MELEE
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_MELEE
			elseif (  holdtype == "melee" || holdtype == "grenade" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_SWIM] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackStand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("attackstand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_MELEE_ALLCLASS"))
			else 
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			end
			
			if (!pl:GetActiveWeapon().HoldTypeHL2) then
				return ActivityTranslateFixTF2[act] or act
			end
		end
	elseif (pl:GetModel() == "models/bots/spy/bot_spy.mdl") then
		if (IsValid(pl:GetActiveWeapon())) then
			if (holdtype == "normal") then
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))						
			elseif (holdtype == "rpg" || holdtype == "crossbow" || holdtype == "shotgun" || holdtype == "physgun" || holdtype == "pistol" || holdtype == "revolver" || holdtype == "smg" || holdtype == "ar2" || holdtype == "dual" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= ACT_MP_RUN_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_SECONDARY
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_SECONDARY
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_SECONDARY
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_SECONDARY	
			elseif ( holdtype == "knife") then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= ACT_MP_RUN_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= ACT_MP_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= ACT_MP_CROUCHWALK_MELEE
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= ACT_MP_JUMP_LAND_MELEE
			elseif ( holdtype == "melee" || holdtype == "melee2" || holdtype == "grenade" || holdtype == "fist" ) then
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK
				ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_MELEE_ALLCLASS"))
				ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE_ALLCLASS"))
				
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("MELEE_ALLCLASS_swing"))
				ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= pl:GetSequenceActivity(pl:LookupSequence("MELEE_ALLCLASS_stand_swing"))
				ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_MP_RELOAD_STAND_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= ACT_MP_AIRWALK_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
				ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
				ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_MELEE_ALLCLASS"))
			else 
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 						= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_RUN] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_WALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("airwalk_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_STAND_IDLE] 							= pl:GetSequenceActivity(pl:LookupSequence("stand_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_CROUCHWALK] 							= pl:GetSequenceActivity(pl:LookupSequence("run_MELEE"))

                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_ATTACK_STAND_PRIMARYFIRE] 						= ACT_MP_ATTACK_STAND_PRIMARYFIRE
                ActivityTranslateFixTF2[ACT_MP_RELOAD_STAND] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_RELOAD_CROUCH] 						= ACT_RELOAD
                ActivityTranslateFixTF2[ACT_MP_JUMP] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_AIRWALK] 						= pl:GetSequenceActivity(pl:LookupSequence("AIRWALK_LOSER"))
                ActivityTranslateFixTF2[ACT_MP_JUMP_START] 						= ACT_MP_JUMP_START_MELEE
                ActivityTranslateFixTF2[ACT_MP_JUMP_FLOAT] 						= ACT_MP_JUMP_FLOAT_MELEE
                ActivityTranslateFixTF2[ACT_LAND] 						= pl:GetSequenceActivity(pl:LookupSequence("jumpland_LOSER"))				
			end
			
			if (!pl:GetActiveWeapon().HoldTypeHL2) then
				return ActivityTranslateFixTF2[act] or act
			end
		end
	end
end)
hook.Add("EntityEmitSound", "MVMVoices", function(snd)
	
	local p = snd.Pitch

	if ( game.GetTimeScale() != 1 ) then
		p = p * game.GetTimeScale()
	end

	if ( GetConVarNumber( "host_timescale" ) != 1 && GetConVarNumber( "sv_cheats" ) >= 1 ) then
		p = p * GetConVarNumber( "host_timescale" )
	end

	if ( p != snd.Pitch ) then
		snd.Pitch = math.Clamp( p, 0, 255 )
	end

	if ( CLIENT && engine.GetDemoPlaybackTimeScale() != 1 ) then
		snd.Pitch = math.Clamp( snd.Pitch * engine.GetDemoPlaybackTimeScale(), 0, 255 )
	end

	

	if string.StartWith(snd.SoundName,"physics/body/") and string.find(snd.SoundName, "impact") and GetConVar("tf_enable_l4d2_ragdoll_sounds"):GetBool() then
		snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "l4d2/physics/body/body_medium_impact_soft"..table.Random({"1","2","5","6","7"})..".wav")
		snd.Volume = 0.6
		return true
	elseif string.StartWith(snd.SoundName,"physics/body/") and string.find(snd.SoundName, "impact") and GetConVar("tf_enable_hl2_ragdoll_sounds"):GetBool() == false then
		snd.SoundName = string.Replace(snd.SoundName, "physics/", "tf/physics/")
		return true
	end
	--[[
	if (IsMounted("left4dead") or IsMounted("left4dead2")) then 
		local pos = snd.Entity:GetPos()
		if (snd.Pos) then
			pos = snd.Pos
		end
		if (snd.Channel == CHAN_WEAPON) then
			if (math.random(1,6) != 1) then
				snd.Channel = CHAN_STATIC
				return true
			end
		end
	end]]
	if CLIENT and !IsValid(snd.Entity) then return end
	if IsValid(snd.Entity) and snd.Entity:GetModel() and string.find(snd.Entity:GetModel(),"bot_") and !string.find(snd.Entity:GetModel(),"boss") and string.find(snd.SoundName, "step") then
		
		if (string.find(snd.Entity:GetModel(),"demo") and string.find(snd.Entity:GetModel(),"buster")) then
			snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/sentrybuster/mvm_sentrybuster_step_0"..math.random(1,4)..".wav")
			snd.SoundLevel = 95
			snd.Channel = CHAN_BODY
			snd.Pitch = 100
			local speed = snd.Entity:GetVelocity():Length()
			local groundspeed = snd.Entity:GetVelocity():Length2DSqr()
			if (snd.Entity:IsPlayer()) then
				if (snd.Entity:GetMoveType() == MOVETYPE_LADDER) then
					snd.Volume = 1 * (groundspeed * 0.000006)
				elseif (snd.Entity:IsPlayer() and snd.Entity:Crouching()) then
					snd.Volume = 1 * (groundspeed * 0.000006)
				else
					if (CLIENT and snd.Entity:EntIndex() == LocalPlayer():EntIndex()) then
						if (LocalPlayer():ShouldDrawLocalPlayer()) then
							if (snd.Entity:GetNWBool("Taunting",false) == true) then
								snd.Volume = 0
							else
								snd.Volume = 1 * (groundspeed * 0.000006 * (snd.Entity:GetRunSpeed() * 0.008))
							end
						else
							snd.Volume = 1 * (groundspeed * 0.00005 * (snd.Entity:GetRunSpeed() * 0.008))
						end
					else
						if (snd.Entity:GetNWBool("Taunting",false) == true) then
							snd.Volume = 0
						else
							snd.Volume = 1 * (groundspeed * 0.000009 * (snd.Entity:GetRunSpeed() * 0.008))
						end
					end
				end
			end
		else
			local speed = snd.Entity:GetVelocity():Length()
			local groundspeed = snd.Entity:GetVelocity():Length2DSqr()
			snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "mvm/player/footsteps/robostep_"..table.Random({
				"01",
				"02",
				"03",
				"04",
				"05",
				"06",
				"07",
				"08",
				"09",
				"10",
				"11",
				"12",
				"13",
				"14",
				"15",
				"16",
				"17",
				"18",
			})..".wav")
			
			snd.Channel = CHAN_BODY
			snd.Pitch = math.random(95,100)
			if (snd.Entity:IsPlayer()) then
				if (snd.Entity:GetMoveType() == MOVETYPE_LADDER) then
					snd.Volume = 1 * (groundspeed * 0.000006)
				elseif (snd.Entity:IsPlayer() and snd.Entity:Crouching()) then
					snd.Volume = 1 * (groundspeed * 0.000006)
				else
					if (CLIENT and snd.Entity:EntIndex() == LocalPlayer():EntIndex()) then
						if (LocalPlayer():ShouldDrawLocalPlayer()) then
							if (snd.Entity:GetNWBool("Taunting",false) == true) then
								snd.Volume = 0
							else
								snd.Volume = 1 * (groundspeed * 0.000006 * (snd.Entity:GetRunSpeed() * 0.008))
							end
						else
							snd.Volume = 1 * (groundspeed * 0.00005 * (snd.Entity:GetRunSpeed() * 0.008))
						end
					else
						if (snd.Entity:GetNWBool("Taunting",false) == true) then
							snd.Volume = 0
						else
							snd.Volume = 1 * (groundspeed * 0.000009 * (snd.Entity:GetRunSpeed() * 0.008))
						end
					end
				end
			end
			if (snd.Entity:GetClass() == "infected") then
				if (string.find(snd.Entity:GetModel(),"clown")) then
	
					for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
						if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
							if (IsValid(snd.Entity:GetEnemy())) then
								v:SetEnemy(snd.Entity:GetEnemy())
								v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
							end
						end
					end
	
				end
			end
			if (snd.Entity:IsTFPlayer() and GAMEMODE:EntityTeam(snd.Entity) != TEAM_GREEN) then
	
				for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
					if (v:IsPlayer() and v:IsL4D() and !IsValid(v.TargetEnt) and v.TFBot) then
						v.TargetEnt = snd.Entity
	
						if SERVER then
							--[[for _,npc in ipairs(ents.GetAll()) do
								if npc:IsNPC() then
									npc:AddEntityRelationship(v,D_HT,99)
								end
							end]]
						end
					end
				end
	
			end
			if (snd.Entity:IsTFPlayer() and !snd.Entity:IsNextBot()) then
				for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
					if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
						v:SetEnemy(snd.Entity)
						v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
		
						if SERVER then
							local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
							v:AddGestureSequence(anim,true)
						end
		
						timer.Stop("IdleExpression"..v:EntIndex())
						timer.Stop("AngryExpression"..v:EntIndex())
						timer.Create("AngryExpression"..v:EntIndex(), 3, 0, function()
							
							if SERVER then
								local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
								v:AddGestureSequence(anim,true)
							end
		
							timer.Adjust("AngryExpression"..v:EntIndex(),v:SequenceDuration(anim))
						end)
						if SERVER then
							--[[for _,npc in ipairs(ents.GetAll()) do
								if npc:IsNPC() then
									npc:AddEntityRelationship(v,D_HT,99)
								end
							end]]
						end
					end
				end
			end
		end
		return true
	elseif IsValid(snd.Entity) and snd.Entity:GetModel() and string.find(snd.Entity:GetModel(),"infected") and (string.find(snd.SoundName, "fallpain") or string.find(snd.SoundName, "damage")) then
		return false
	elseif IsValid(snd.Entity) and snd.Entity:GetModel() and snd.Entity:IsPlayer() and snd.Entity:IsHL2() and (string.find(snd.SoundName, "fallpain") or string.find(snd.SoundName, "damage")) then
		snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/pl_fallpain"..table.Random({1,3})..".wav")
		return true
	elseif IsValid(snd.Entity) and snd.Entity:GetModel() and snd.Entity:IsPlayer() and (snd.Entity:GetPlayerClass() == "hl1scientist" || snd.Entity:GetPlayerClass() == "hl1barney") and (string.find(snd.SoundName, "fallpain") or string.find(snd.SoundName, "damage")) then
		snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "hl1/player/pl_fallpain"..math.random(1,3)..".wav")
		return true
	elseif IsValid(snd.Entity) and snd.Entity:GetModel() and string.find(snd.Entity:GetModel(),"bot_") and string.find(snd.Entity:GetModel(),"buster") and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/sentrybuster/mvm_sentrybuster_step_0"..math.random(1,4)..".wav")
		snd.SoundLevel = 95
		snd.Channel = CHAN_BODY
		snd.Pitch = 100
		local speed = snd.Entity:GetVelocity():Length()
		local groundspeed = snd.Entity:GetVelocity():Length2DSqr()
		if (snd.Entity:IsPlayer()) then
			if (snd.Entity:GetMoveType() == MOVETYPE_LADDER) then
				snd.Volume = 1 * (groundspeed * 0.000006)
			elseif (snd.Entity:IsPlayer() and snd.Entity:Crouching()) then
				snd.Volume = 1 * (groundspeed * 0.000006)
			else
				if (CLIENT and snd.Entity:EntIndex() == LocalPlayer():EntIndex()) then
					if (LocalPlayer():ShouldDrawLocalPlayer()) then
						if (snd.Entity:GetNWBool("Taunting",false) == true) then
							snd.Volume = 0
						else
							snd.Volume = 1 * (groundspeed * 0.000006 * (snd.Entity:GetRunSpeed() * 0.008))
						end
					else
						snd.Volume = 1 * (groundspeed * 0.00005 * (snd.Entity:GetRunSpeed() * 0.008))
					end
				else
					if (snd.Entity:GetNWBool("Taunting",false) == true) then
						snd.Volume = 0
					else
						snd.Volume = 1 * (groundspeed * 0.000009 * (snd.Entity:GetRunSpeed() * 0.008))
					end
				end
			end
		end
		return true
	elseif IsValid(snd.Entity) and snd.Entity:GetModel() and string.StartWith(snd.Entity:GetModel(), "models/player") and !string.find(snd.Entity:GetModel(), "tfc") and snd.Entity:LookupBone("bip_head") and !string.find(snd.Entity:GetModel(), "bot") and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
		snd.SoundName = string.Replace(snd.SoundName, "snow5", "snow1")
		snd.SoundName = string.Replace(snd.SoundName, "snow6", "snow2")
			snd.Channel = CHAN_BODY
		local speed = snd.Entity:GetVelocity():Length()
		local groundspeed = snd.Entity:GetVelocity():Length2DSqr()
		if (snd.Entity:WaterLevel() < 1) then
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "tf/player/footsteps/")
		elseif (snd.Entity:WaterLevel() < 2) then
			snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "tf/player/footsteps/slosh"..math.random(1,4)..".wav")
		else
			snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "tf/player/footsteps/wade"..math.random(1,4)..".wav")
		end
		--[[
if (IsMounted("left4dead") or IsMounted("left4dead2")) then 
			local pos = snd.Entity:GetPos()
			if (snd.Pos) then
				pos = snd.Pos
			end
			if (snd.Channel == CHAN_BODY) then
				if (math.random(1,6) != 1) then
					snd.Channel = CHAN_STATIC
					return true
				end
			end
		end]]
		snd.Pitch = math.random(95,105)
		if (snd.Entity:IsPlayer()) then
			if (snd.Entity:GetMoveType() == MOVETYPE_LADDER) then
				snd.Volume = 1 * (groundspeed * 0.000006)
			elseif (snd.Entity:IsPlayer() and snd.Entity:Crouching()) then
				snd.Volume = 1 * (groundspeed * 0.000006)
			else
				if (CLIENT and snd.Entity:EntIndex() == LocalPlayer():EntIndex()) then
					if (LocalPlayer():ShouldDrawLocalPlayer()) then
						if (snd.Entity:GetNWBool("Taunting",false) == true) then
							snd.Volume = 0
						else
							snd.Volume = 1 * (groundspeed * 0.000006 * (snd.Entity:GetRunSpeed() * 0.008))
						end
					else
						snd.Volume = 1 * (groundspeed * 0.00005 * (snd.Entity:GetRunSpeed() * 0.008))
					end
				else
					if (snd.Entity:GetNWBool("Taunting",false) == true) then
						snd.Volume = 0
					else
						snd.Volume = 1 * (groundspeed * 0.000009 * (snd.Entity:GetRunSpeed() * 0.008))
					end
				end
			end
		end
		if (snd.Entity:GetClass() == "infected") then
			if (string.find(snd.Entity:GetModel(),"clown")) then

				for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
					if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
						if (IsValid(snd.Entity:GetEnemy())) then
							v:SetEnemy(snd.Entity:GetEnemy())
							v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
						end
					end
				end

			end
		end
		if (snd.Entity:IsTFPlayer() and GAMEMODE:EntityTeam(snd.Entity) != TEAM_GREEN) then

			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
				if (v:IsPlayer() and v:IsL4D() and !IsValid(v.TargetEnt) and v.TFBot) then
					v.TargetEnt = snd.Entity

					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end

		end
		if (snd.Entity:IsTFPlayer() and !snd.Entity:IsNextBot()) then
			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),400)) do
				if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
					v:SetEnemy(snd.Entity)
					v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
	
					if SERVER then
						local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
						v:AddGestureSequence(anim,true)
					end
	
					timer.Stop("IdleExpression"..v:EntIndex())
					timer.Stop("AngryExpression"..v:EntIndex())
					timer.Create("AngryExpression"..v:EntIndex(), 3, 0, function()
						
						if SERVER then
							local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
							v:AddGestureSequence(anim,true)
						end
	
						timer.Adjust("AngryExpression"..v:EntIndex(),v:SequenceDuration(anim))
					end)
					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end
		end
		return true
	elseif IsValid(snd.Entity) and snd.Entity:GetModel() and string.StartWith(snd.Entity:GetModel(), "models/infected/common_") and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
		snd.SoundName = string.Replace(snd.SoundName, "snow5", "snow1")
		snd.SoundName = string.Replace(snd.SoundName, "snow6", "snow2")
		snd.Channel = CHAN_BODY
		local speed = snd.Entity:GetVelocity():Length()
		local groundspeed = snd.Entity:GetVelocity():Length2DSqr()
		snd.Volume = 0.5
		--[[
if (IsMounted("left4dead") or IsMounted("left4dead2")) then 
			local pos = snd.Entity:GetPos()
			if (snd.Pos) then
				pos = snd.Pos
			end
			if (snd.Channel == CHAN_BODY) then
				if (math.random(1,6) != 1) then
					snd.Channel = CHAN_STATIC
					return true
				end
			end
		end]]
		if (string.find(snd.Entity:GetModel(),"clown")) then
			if (snd.Entity:WaterLevel() < 1) then
				snd.SoundName = "player/footsteps/clown/concrete"..math.random(1,8)..".wav"
				snd.Volume = 0.5
			elseif (snd.Entity:WaterLevel() < 2) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/boomer/run/wade"..math.random(1,4)..".wav")
				snd.Volume = 0.5
			else
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/boomer/run/wade"..math.random(1,4)..".wav")
				snd.Volume = 0.5
			end
		elseif (string.find(snd.Entity:GetModel(),"mud")) then
			if (snd.Entity:WaterLevel() < 1) then
				if (!string.find(snd.Entity:GetSequenceName(snd.Entity:SelectWeightedSequence(snd.Entity:GetNWInt("NetworkedActivity",-1))),"run_")) then
					snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/boomer/walk/")
					snd.Volume = 0.85
				else
					snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/boomer/run/")
					snd.Volume = 0.5
				end
			elseif (snd.Entity:WaterLevel() < 2) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/boomer/run/wade"..math.random(1,4)..".wav")
				snd.Volume = 0.5
			else
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/boomer/run/wade"..math.random(1,4)..".wav")
				snd.Volume = 0.5
			end
		elseif (string.find(snd.Entity:GetModel(),"riot")) then
			snd.SoundName = table.Random(
				{
					"player/footsteps/infected/run/concrete1.wav",
					"player/footsteps/infected/run/concrete2.wav",
					"player/footsteps/infected/run/concrete3.wav",
					"player/footsteps/infected/run/concrete4.wav",
					"player/footsteps/survivor/run/tile1.wav",
					"player/footsteps/survivor/run/tile2.wav",
					"player/footsteps/survivor/run/tile3.wav",
					"player/footsteps/survivor/run/tile4.wav",
				}
			)
		else
			if (snd.Entity:WaterLevel() < 1) then
					
				if (!string.find(snd.Entity:GetSequenceName(snd.Entity:SelectWeightedSequence(snd.Entity:GetNWInt("NetworkedActivity",-1))),"run_")) then
					snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/infected/walk/")
					snd.Volume = 0.85
				else
					snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/infected/run/")
					snd.Volume = 0.5
				end

			elseif (snd.Entity:WaterLevel() < 2) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/infected/run/wade"..math.random(1,4)..".wav")
				snd.Volume = 0.5
			else
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/infected/run/wade"..math.random(1,4)..".wav")
				snd.Volume = 0.5
			end
		end
		if (snd.Entity:GetClass() == "infected") then
			if (string.find(snd.Entity:GetModel(),"clown")) then

				for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
					if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
						if (IsValid(snd.Entity:GetEnemy())) then
							v:SetEnemy(snd.Entity:GetEnemy())
							v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
						end
					end
				end

			end
		end
		if (snd.Entity:IsTFPlayer() and GAMEMODE:EntityTeam(snd.Entity) != TEAM_GREEN) then

			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
				if (v:IsPlayer() and v:IsL4D() and !IsValid(v.TargetEnt) and v.TFBot) then
					v.TargetEnt = snd.Entity

					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end

		end
		if (snd.Entity:IsTFPlayer() and !snd.Entity:IsNextBot()) then
			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),400)) do
				if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
					v:SetEnemy(snd.Entity)
					v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
	
					if SERVER then
						local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
						v:AddGestureSequence(anim,true)
					end
	
					timer.Stop("IdleExpression"..v:EntIndex())
					timer.Stop("AngryExpression"..v:EntIndex())
					timer.Create("AngryExpression"..v:EntIndex(), 3, 0, function()
						
						if SERVER then
							local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
							v:AddGestureSequence(anim,true)
						end
	
						timer.Adjust("AngryExpression"..v:EntIndex(),v:SequenceDuration(anim))
					end)
					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end
		end
		snd.Pitch = math.random(95,105)
		return true
	elseif IsValid(snd.Entity) and snd.Entity:GetModel() and string.StartWith(snd.Entity:GetModel(), "models/bots/small_headless_hatman") and string.find(snd.SoundName, "step") then
		snd.Channel = CHAN_BODY
		local speed = snd.Entity:GetVelocity():Length()
		local groundspeed = snd.Entity:GetVelocity():Length2DSqr()
		snd.Volume = 0.5
		snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/giant"..math.random(1,2)..".wav")
		snd.Pitch = math.random(95,100)
		if (snd.Entity:IsPlayer()) then
			if (snd.Entity:GetMoveType() == MOVETYPE_LADDER) then
				snd.Volume = 1 * (groundspeed * 0.000006)
			elseif (snd.Entity:IsPlayer() and snd.Entity:Crouching()) then
				snd.Volume = 1 * (groundspeed * 0.000006)
			else
				if (snd.Entity:EntIndex() == LocalPlayer():EntIndex()) then
					if (LocalPlayer():ShouldDrawLocalPlayer()) then
						if (snd.Entity:GetNWBool("Taunting",false) == true) then
							snd.Volume = 0
						else
							snd.Volume = 1 * (groundspeed * 0.000006 * (snd.Entity:GetRunSpeed() * 0.008))
						end
					else
						snd.Volume = 1 * (groundspeed * 0.00005 * (snd.Entity:GetRunSpeed() * 0.008))
					end
				else
					if (snd.Entity:GetNWBool("Taunting",false) == true) then
						snd.Volume = 0
					else
						snd.Volume = 1 * (groundspeed * 0.000009 * (snd.Entity:GetRunSpeed() * 0.008))
					end
				end
			end
		end
		if (snd.Entity:GetClass() == "infected") then
			if (string.find(snd.Entity:GetModel(),"clown")) then

				for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
					if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
						if (IsValid(snd.Entity:GetEnemy())) then
							v:SetEnemy(snd.Entity:GetEnemy())
							v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
						end
					end
				end

			end
		end
		if (snd.Entity:IsTFPlayer() and GAMEMODE:EntityTeam(snd.Entity) != TEAM_GREEN) then

			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
				if (v:IsPlayer() and v:IsL4D() and !IsValid(v.TargetEnt) and v.TFBot) then
					v.TargetEnt = snd.Entity

					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end

		end
		if (snd.Entity:IsTFPlayer() and !snd.Entity:IsNextBot()) then
			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),400)) do
				if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
					v:SetEnemy(snd.Entity)
					v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
	
					if SERVER then
						local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
						v:AddGestureSequence(anim,true)
					end
	
					timer.Stop("IdleExpression"..v:EntIndex())
					timer.Stop("AngryExpression"..v:EntIndex())
					timer.Create("AngryExpression"..v:EntIndex(), 3, 0, function()
						
						if SERVER then
							local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
							v:AddGestureSequence(anim,true)
						end
	
						timer.Adjust("AngryExpression"..v:EntIndex(),v:SequenceDuration(anim))
					end)
					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end
		end
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and snd.Entity:IsHL2() and string.find(snd.SoundName, "step")  and snd.Entity:GetInfoNum("civ2_enable_survivor_steps",0) == 1 then
		if (snd.Entity:KeyDown(IN_WALK)) then
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/survivor/walk/")
		else
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/survivor/run/")
		end 
		
		--[[
if (IsMounted("left4dead") or IsMounted("left4dead2")) then 
			local pos = snd.Entity:GetPos()
			if (snd.Pos) then
				pos = snd.Pos
			end
			if (snd.Channel == CHAN_BODY) then
				if (math.random(1,6) != 1) then
					snd.Channel = CHAN_STATIC
					return true
				end
			end
		end]]
		if (GetConVar("tf_enable_server_footsteps"):GetBool()) then
			sound.Play(snd.SoundName,snd.Entity:GetPos(),snd.SoundLevel,snd.Pitch,1)
			return false
		end
		if (snd.Entity:GetClass() == "infected") then
			if (string.find(snd.Entity:GetModel(),"clown")) then

				for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
					if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
						if (IsValid(snd.Entity:GetEnemy())) then
							v:SetEnemy(snd.Entity:GetEnemy())
							v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
						end
					end
				end

			end
		end
		if (snd.Entity:IsTFPlayer() and GAMEMODE:EntityTeam(snd.Entity) != TEAM_GREEN) then

			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
				if (v:IsPlayer() and v:IsL4D() and !IsValid(v.TargetEnt) and v.TFBot) then
					v.TargetEnt = snd.Entity

					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end

		end
		if (snd.Entity:IsTFPlayer() and !snd.Entity:IsNextBot()) then
			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),400)) do
				if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
					v:SetEnemy(snd.Entity)
					v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
	
					if SERVER then
						local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
						v:AddGestureSequence(anim,true)
					end
	
					timer.Stop("IdleExpression"..v:EntIndex())
					timer.Stop("AngryExpression"..v:EntIndex())
					timer.Create("AngryExpression"..v:EntIndex(), 3, 0, function()
						
						if SERVER then
							local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
							v:AddGestureSequence(anim,true)
						end
	
						timer.Adjust("AngryExpression"..v:EntIndex(),v:SequenceDuration(anim))
					end)
					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end
		end
		return true
	elseif IsValid(snd.Entity) and snd.Entity:GetModel() and string.find(snd.SoundName,"female") and string.find(snd.Entity:GetModel(),"boomer") then
		snd.SoundName = string.Replace(snd.SoundName, "female", "male")
		
		return true
	elseif IsValid(snd.Entity) and snd.Entity:GetModel() and string.find(snd.SoundName,"/male") and string.find(snd.Entity:GetModel(),"boomette") then
		snd.SoundName = string.Replace(snd.SoundName, "male", "female")
		
		return true
	elseif IsValid(snd.Entity) and snd.Entity:GetModel() and string.StartWith(snd.Entity:GetModel(), "models/player") and string.find(snd.Entity:GetModel(), "tfc") and !string.find(snd.Entity:GetModel(), "bot") and snd.Entity:LookupBone("bip_head") and string.find(snd.SoundName, "step") and (IsMounted("hl1") || IsMounted("hl1mp")) then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
		snd.Channel = CHAN_BODY
		local speed = snd.Entity:GetVelocity():Length()
		local groundspeed = snd.Entity:GetVelocity():Length2DSqr() 
		if (snd.Entity:WaterLevel() < 1) then
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/pl_") 
			snd.SoundName = string.Replace(snd.SoundName, "concrete", "step")
			snd.SoundName = string.Replace(snd.SoundName, "grass", "step")
			snd.SoundName = string.Replace(snd.SoundName, "sand", "step")
			snd.SoundName = string.Replace(snd.SoundName, "metalgrate", "grate")
			snd.SoundName = string.Replace(snd.SoundName, "tile4", "tile"..math.random(4,5))
		elseif (snd.Entity:WaterLevel() < 2) then
			snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/pl_slosh"..math.random(1,4)..".wav")
		else
			snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/pl_wade"..math.random(1,4)..".wav")
		end
		if (snd.Entity:IsPlayer()) then
			if (snd.Entity:GetMoveType() == MOVETYPE_LADDER) then
				snd.Volume = 1 * (groundspeed * 0.000006)
			elseif (snd.Entity:IsPlayer() and snd.Entity:Crouching()) then
				snd.Volume = 1 * (groundspeed * 0.000006)
			else
				if (snd.Entity:EntIndex() == LocalPlayer():EntIndex()) then
					if (LocalPlayer():ShouldDrawLocalPlayer()) then
						if (snd.Entity:GetNWBool("Taunting",false) == true) then
							snd.Volume = 0
						else
							snd.Volume = 1 * (groundspeed * 0.000006 * (snd.Entity:GetRunSpeed() * 0.008))
						end
					else
						snd.Volume = 1 * (groundspeed * 0.00005 * (snd.Entity:GetRunSpeed() * 0.008))
					end
				else
					if (snd.Entity:GetNWBool("Taunting",false) == true) then
						snd.Volume = 0
					else
						snd.Volume = 1 * (groundspeed * 0.000009 * (snd.Entity:GetRunSpeed() * 0.008))
					end
				end
			end
		end
		if (snd.Entity:GetClass() == "infected") then
			if (string.find(snd.Entity:GetModel(),"clown")) then

				for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
					if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
						if (IsValid(snd.Entity:GetEnemy())) then
							v:SetEnemy(snd.Entity:GetEnemy())
							v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
						end
					end
				end

			end
		end
		if (snd.Entity:IsTFPlayer() and GAMEMODE:EntityTeam(snd.Entity) != TEAM_GREEN) then

			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
				if (v:IsPlayer() and v:IsL4D() and !IsValid(v.TargetEnt) and v.TFBot) then
					v.TargetEnt = snd.Entity

					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end

		end
		if (snd.Entity:IsTFPlayer() and !snd.Entity:IsNextBot()) then
			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),400)) do
				if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
					v:SetEnemy(snd.Entity)
					v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
	
					if SERVER then
						local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
						v:AddGestureSequence(anim,true)
					end
	
					timer.Stop("IdleExpression"..v:EntIndex())
					timer.Stop("AngryExpression"..v:EntIndex())
					timer.Create("AngryExpression"..v:EntIndex(), 3, 0, function()
						
						if SERVER then
							local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
							v:AddGestureSequence(anim,true)
						end
	
						timer.Adjust("AngryExpression"..v:EntIndex(),v:SequenceDuration(anim))
					end)
					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end
		end
		snd.Pitch = 100
		return true
	elseif IsValid(snd.Entity) and snd.Entity:GetModel() and (snd.Entity:GetModel() == "models/infected/hulk.mdl" or snd.Entity:GetModel() == "models/infected/hulk_l4d1.mdl" or snd.Entity:GetModel() == "models/infected/hulk_dlc3.mdl") and string.find(snd.SoundName, "step") then
		if (snd.Entity:WaterLevel() > 0) then
			snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/tank/walk/tank_walk_water_0"..math.random(1,6)..".wav")
		else
			snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/tank/walk/tank_walk0"..math.random(1,6)..".wav")
		end
		
		snd.Channel = CHAN_STATIC
		snd.Pitch = math.random(95,105)
		snd.SoundLevel = 80
		snd.Volume = 1
		if (snd.Entity:GetClass() == "infected") then
			if (string.find(snd.Entity:GetModel(),"clown")) then

				for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
					if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
						if (IsValid(snd.Entity:GetEnemy())) then
							v:SetEnemy(snd.Entity:GetEnemy())
							v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
						end
					end
				end

			end
		end
		if (snd.Entity:IsTFPlayer() and GAMEMODE:EntityTeam(snd.Entity) != TEAM_GREEN) then

			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
				if (v:IsPlayer() and v:IsL4D() and !IsValid(v.TargetEnt) and v.TFBot) then
					v.TargetEnt = snd.Entity

					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end

		end
		if (snd.Entity:IsTFPlayer() and !snd.Entity:IsNextBot()) then
			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),400)) do
				if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
					v:SetEnemy(snd.Entity)
					v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
	
					if SERVER then
						local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
						v:AddGestureSequence(anim,true)
					end
	
					timer.Stop("IdleExpression"..v:EntIndex())
					timer.Stop("AngryExpression"..v:EntIndex())
					timer.Create("AngryExpression"..v:EntIndex(), 3, 0, function()
						
						if SERVER then
							local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
							v:AddGestureSequence(anim,true)
						end
	
						timer.Adjust("AngryExpression"..v:EntIndex(),v:SequenceDuration(anim))
					end)
					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end
		end
		return true
	elseif IsValid(snd.Entity) and snd.Entity:GetModel() and (snd.Entity:GetModel() == "models/infected/boomer.mdl" or snd.Entity:GetModel() == "models/infected/boomer_l4d1.mdl" or snd.Entity:GetModel() == "models/infected/boomette.mdl") and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
		snd.SoundName = string.Replace(snd.SoundName, "1", math.random(1,4))
		snd.SoundName = string.Replace(snd.SoundName, "2", math.random(1,4))
		snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/boomer/run/")
		
		snd.Pitch = math.random(95,105)
		
		--[[
if (IsMounted("left4dead") or IsMounted("left4dead2")) then 
			local pos = snd.Entity:GetPos()
			if (snd.Pos) then
				pos = snd.Pos
			end
			if (snd.Channel == CHAN_BODY) then
				if (math.random(1,6) != 1) then
					snd.Channel = CHAN_STATIC
					return true
				end
			end
		end]]
		if (snd.Entity:GetClass() == "infected") then
			if (string.find(snd.Entity:GetModel(),"clown")) then

				for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
					if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
						if (IsValid(snd.Entity:GetEnemy())) then
							v:SetEnemy(snd.Entity:GetEnemy())
							v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
						end
					end
				end

			end
		end
		if (snd.Entity:IsTFPlayer() and GAMEMODE:EntityTeam(snd.Entity) != TEAM_GREEN) then

			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
				if (v:IsPlayer() and v:IsL4D() and !IsValid(v.TargetEnt) and v.TFBot) then
					v.TargetEnt = snd.Entity

					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end

		end
		if (snd.Entity:IsTFPlayer() and !snd.Entity:IsNextBot()) then
			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),400)) do
				if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
					v:SetEnemy(snd.Entity)
					v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
	
					if SERVER then
						local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
						v:AddGestureSequence(anim,true)
					end
	
					timer.Stop("IdleExpression"..v:EntIndex())
					timer.Stop("AngryExpression"..v:EntIndex())
					timer.Create("AngryExpression"..v:EntIndex(), 3, 0, function()
						
						if SERVER then
							local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
							v:AddGestureSequence(anim,true)
						end
	
						timer.Adjust("AngryExpression"..v:EntIndex(),v:SequenceDuration(anim))
					end)
					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end
		end
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and snd.Entity:GetPlayerClass() == "jockey" and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
		snd.SoundName = string.Replace(snd.SoundName, "1", math.random(1,4))
		snd.SoundName = string.Replace(snd.SoundName, "2", math.random(1,4))
		snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/boomer/run/")
		
		--[[
if (IsMounted("left4dead") or IsMounted("left4dead2")) then 
			local pos = snd.Entity:GetPos()
			if (snd.Pos) then
				pos = snd.Pos
			end
			if (snd.Channel == CHAN_BODY) then
				if (math.random(1,6) != 1) then
					snd.Channel = CHAN_STATIC
					return true
				end
			end
		end]]
		snd.Pitch = math.random(95,105)
		
		if (snd.Entity:GetClass() == "infected") then
			if (string.find(snd.Entity:GetModel(),"clown")) then

				for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
					if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
						if (IsValid(snd.Entity:GetEnemy())) then
							v:SetEnemy(snd.Entity:GetEnemy())
							v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
						end
					end
				end

			end
		end
		if (snd.Entity:IsTFPlayer() and GAMEMODE:EntityTeam(snd.Entity) != TEAM_GREEN) then

			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
				if (v:IsPlayer() and v:IsL4D() and !IsValid(v.TargetEnt) and v.TFBot) then
					v.TargetEnt = snd.Entity

					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end

		end
		if (snd.Entity:IsTFPlayer() and !snd.Entity:IsNextBot()) then
			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),400)) do
				if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
					v:SetEnemy(snd.Entity)
					v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
	
					if SERVER then
						local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
						v:AddGestureSequence(anim,true)
					end
	
					timer.Stop("IdleExpression"..v:EntIndex())
					timer.Stop("AngryExpression"..v:EntIndex())
					timer.Create("AngryExpression"..v:EntIndex(), 3, 0, function()
						
						if SERVER then
							local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
							v:AddGestureSequence(anim,true)
						end
	
						timer.Adjust("AngryExpression"..v:EntIndex(),v:SequenceDuration(anim))
					end)
					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end
		end
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and snd.Entity:GetPlayerClass() == "hunter" and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
		snd.SoundName = string.Replace(snd.SoundName, "1", math.random(1,4))
		snd.SoundName = string.Replace(snd.SoundName, "2", math.random(1,4))
		
		
		if (snd.Entity:KeyDown(IN_WALK)) then
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/infected/walk/")
		else
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/infected/run/")
		end
		
		snd.Pitch = math.random(95,105)
		snd.Volume = 0
		
		--[[
if (IsMounted("left4dead") or IsMounted("left4dead2")) then 
			local pos = snd.Entity:GetPos()
			if (snd.Pos) then
				pos = snd.Pos
			end
			if (snd.Channel == CHAN_BODY) then
				if (math.random(1,6) != 1) then
					snd.Channel = CHAN_STATIC
					return true
				end
			end
		end]]
		if (snd.Entity:GetClass() == "infected") then
			if (string.find(snd.Entity:GetModel(),"clown")) then

				for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
					if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
						if (IsValid(snd.Entity:GetEnemy())) then
							v:SetEnemy(snd.Entity:GetEnemy())
							v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
						end
					end
				end

			end
		end
		if (snd.Entity:IsTFPlayer() and GAMEMODE:EntityTeam(snd.Entity) != TEAM_GREEN) then

			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
				if (v:IsPlayer() and v:IsL4D() and !IsValid(v.TargetEnt) and v.TFBot) then
					v.TargetEnt = snd.Entity

					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end

		end
		if (snd.Entity:IsTFPlayer() and !snd.Entity:IsNextBot()) then
			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),400)) do
				if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
					v:SetEnemy(snd.Entity)
					v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
	
					if SERVER then
						local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
						v:AddGestureSequence(anim,true)
					end
	
					timer.Stop("IdleExpression"..v:EntIndex())
					timer.Stop("AngryExpression"..v:EntIndex())
					timer.Create("AngryExpression"..v:EntIndex(), 3, 0, function()
						
						if SERVER then
							local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
							v:AddGestureSequence(anim,true)
						end
	
						timer.Adjust("AngryExpression"..v:EntIndex(),v:SequenceDuration(anim))
					end)
					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end
		end
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and snd.Entity:GetPlayerClass() == "smoker" and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
		snd.SoundName = string.Replace(snd.SoundName, "1", math.random(1,4))
		snd.SoundName = string.Replace(snd.SoundName, "2", math.random(1,4))
		if (snd.Entity:KeyDown(IN_WALK)) then
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/infected/walk/")
		else
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/infected/run/")
		end
		--[[
if (IsMounted("left4dead") or IsMounted("left4dead2")) then 
			local pos = snd.Entity:GetPos()
			if (snd.Pos) then
				pos = snd.Pos
			end
			if (snd.Channel == CHAN_BODY) then
				if (math.random(1,6) != 1) then
					snd.Channel = CHAN_STATIC
					return true
				end
			end
		end]]
		snd.Pitch = math.random(95,105)
		
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and snd.Entity:GetPlayerClass() == "spitter" and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
		snd.SoundName = string.Replace(snd.SoundName, "1", math.random(1,4))
		snd.SoundName = string.Replace(snd.SoundName, "2", math.random(1,4))
		if (snd.Entity:KeyDown(IN_WALK)) then
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/infected/walk/")
		else
			snd.SoundName = string.Replace(snd.SoundName, "player/footsteps/", "player/footsteps/infected/run/")
		end
		snd.Pitch = math.random(95,105)
		
		--[[
if (IsMounted("left4dead") or IsMounted("left4dead2")) then 
			local pos = snd.Entity:GetPos()
			if (snd.Pos) then
				pos = snd.Pos
			end
			if (snd.Channel == CHAN_BODY) then
				if (math.random(1,6) != 1) then
					snd.Channel = CHAN_STATIC
					return true
				end
			end
		end]]
		if (snd.Entity:GetClass() == "infected") then
			if (string.find(snd.Entity:GetModel(),"clown")) then

				for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
					if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
						if (IsValid(snd.Entity:GetEnemy())) then
							v:SetEnemy(snd.Entity:GetEnemy())
							v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
						end
					end
				end

			end
		end
		if (snd.Entity:IsTFPlayer() and GAMEMODE:EntityTeam(snd.Entity) != TEAM_GREEN) then

			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
				if (v:IsPlayer() and v:IsL4D() and !IsValid(v.TargetEnt) and v.TFBot) then
					v.TargetEnt = snd.Entity

					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end

		end
		if (snd.Entity:IsTFPlayer() and !snd.Entity:IsNextBot()) then
			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),400)) do
				if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
					v:SetEnemy(snd.Entity)
					v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
	
					if SERVER then
						local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
						v:AddGestureSequence(anim,true)
					end
	
					timer.Stop("IdleExpression"..v:EntIndex())
					timer.Stop("AngryExpression"..v:EntIndex())
					timer.Create("AngryExpression"..v:EntIndex(), 3, 0, function()
						
						if SERVER then
							local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
							v:AddGestureSequence(anim,true)
						end
	
						timer.Adjust("AngryExpression"..v:EntIndex(),v:SequenceDuration(anim))
					end)
					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end
		end
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and snd.Entity:GetPlayerClass() == "charger" and string.find(snd.SoundName, "step") then
		snd.SoundName = string.Replace(snd.SoundName, "wade5", "wade1")
		snd.SoundName = string.Replace(snd.SoundName, "wade6", "wade2")
		snd.SoundName = string.Replace(snd.SoundName, "wade7", "wade3")
		snd.SoundName = string.Replace(snd.SoundName, "wade8", "wade4")
		snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "player/footsteps/charger/run/charger_run_"..table.Random({"left","right"}).."_0"..math.random(1,4)..".wav")
		
		snd.Pitch = math.random(95,105)

		
		return true
	elseif IsValid(snd.Entity) and snd.Entity:GetModel() and string.find(snd.Entity:GetModel(),"bot_") and (!snd.Entity:IsPlayer() and string.find(snd.Entity:GetModel(),"boss") or (snd.Entity:IsPlayer() and snd.Entity:GetInfoNum("tf_giant_robot",0) == 1 or (string.find(snd.Entity:GetModel(),"bot") and string.find(snd.Entity:GetModel(),"boss")))) and string.find(snd.SoundName, "step") then
		if (GetConVar("tf_enable_unused_mvm_sounds"):GetBool()) then
			if (string.find(snd.Entity:GetModel(),"scout") || string.find(snd.Entity:GetModel(),"superscout") || string.find(snd.Entity:GetModel(),"superscoutfan") || string.find(snd.Entity:GetModel(),"gianscout")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_scout/giant_scout_step_0"..math.random(1,4)..".wav")
				snd.SoundLevel = 87
			elseif (string.find(snd.Entity:GetModel(),"soldier")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_soldier/giant_soldier_step0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			elseif (string.find(snd.Entity:GetModel(),"pyro")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_pyro/giant_pyro_step_0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			elseif (string.find(snd.Entity:GetModel(),"demo") and !string.find(snd.Entity:GetModel(),"buster")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_demoman/giant_demoman_step_0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			elseif (string.find(snd.Entity:GetModel(),"demo") and string.find(snd.Entity:GetModel(),"buster")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/sentrybuster/mvm_sentrybuster_step_0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			elseif (string.find(snd.Entity:GetModel(),"heavy")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_heavy/giant_heavy_step0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			elseif (string.find(snd.Entity:GetModel(),"engineer")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_heavy/giant_heavy_step0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			elseif (string.find(snd.Entity:GetModel(),"medic")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_soldier/giant_soldier_step0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			elseif (string.find(snd.Entity:GetModel(),"sniper")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_heavy/giant_heavy_step0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			elseif (string.find(snd.Entity:GetModel(),"spy")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_scout/giant_scout_step_0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			end
		else
			if (string.find(snd.Entity:GetModel(),"buster")) then
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/sentrybuster/mvm_sentrybuster_step_0"..math.random(1,4)..".wav")
				snd.SoundLevel = 95
			else
				snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "^mvm/giant_common/giant_common_step_0"..math.random(1,8)..".wav")
				if (string.find(snd.Entity:GetModel(),"scout") || string.find(snd.Entity:GetModel(),"superscout") || string.find(snd.Entity:GetModel(),"superscoutfan") || string.find(snd.Entity:GetModel(),"gianscout")) then
					snd.SoundLevel = 87
				elseif (string.find(snd.Entity:GetModel(),"soldier")) then
					snd.SoundLevel = 95
				elseif (string.find(snd.Entity:GetModel(),"pyro")) then
					snd.SoundLevel = 95
				elseif (string.find(snd.Entity:GetModel(),"demo")) then
					snd.SoundLevel = 95
				elseif (string.find(snd.Entity:GetModel(),"heavy")) then
					snd.SoundLevel = 95
				elseif (string.find(snd.Entity:GetModel(),"engineer")) then
					snd.SoundLevel = 95
				elseif (string.find(snd.Entity:GetModel(),"medic")) then
					snd.SoundLevel = 95
				elseif (string.find(snd.Entity:GetModel(),"sniper")) then
					snd.SoundLevel = 95
				elseif (string.find(snd.Entity:GetModel(),"spy")) then
					snd.SoundLevel = 87
				end
			end
		end
		snd.Volume = 1
		snd.Channel = CHAN_BODY
		snd.Pitch = 100
		if (snd.Entity:GetClass() == "infected") then
			if (string.find(snd.Entity:GetModel(),"clown")) then

				for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
					if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
						if (IsValid(snd.Entity:GetEnemy())) then
							v:SetEnemy(snd.Entity:GetEnemy())
							v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
						end
					end
				end

			end
		end
		if (snd.Entity:IsTFPlayer() and GAMEMODE:EntityTeam(snd.Entity) != TEAM_GREEN) then

			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),800)) do
				if (v:IsPlayer() and v:IsL4D() and !IsValid(v.TargetEnt) and v.TFBot) then
					v.TargetEnt = snd.Entity

					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end

		end
		if (snd.Entity:IsTFPlayer() and !snd.Entity:IsNextBot()) then
			for k,v in ipairs(ents.FindInSphere(snd.Entity:GetPos(),400)) do
				if (v:GetClass() == "infected" and !IsValid(v:GetEnemy()) and v.Ready) then
					v:SetEnemy(snd.Entity)
					v:EmitSound(table.Random({"Zombie.Alert","Zombie.BecomeAlert"}))
	
					if SERVER then
						local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
						v:AddGestureSequence(anim,true)
					end
	
					timer.Stop("IdleExpression"..v:EntIndex())
					timer.Stop("AngryExpression"..v:EntIndex())
					timer.Create("AngryExpression"..v:EntIndex(), 3, 0, function()
						
						if SERVER then
							local anim = v:LookupSequence("exp_angry_0"..math.random(1,6))
							v:AddGestureSequence(anim,true)
						end
	
						timer.Adjust("AngryExpression"..v:EntIndex(),v:SequenceDuration(anim))
					end)
					if SERVER then
						--[[for _,npc in ipairs(ents.GetAll()) do
							if npc:IsNPC() then
								npc:AddEntityRelationship(v,D_HT,99)
							end
						end]]
					end
				end
			end
		end
		return true
	elseif IsValid(snd.Entity) and string.StartWith(snd.SoundName, "player/")  and snd.Entity:IsPlayer() then
		if (snd.Entity:GetInfoNum("tf_special_dsp_type",-1) > -1) then
			snd.DSP = snd.Entity:GetInfoNum("tf_special_dsp_type",-1);
		end
		return true
	elseif IsValid(snd.Entity) and string.StartWith(snd.SoundName, "npc/") and snd.Entity:IsPlayer() then
		if (snd.Entity:GetInfoNum("tf_special_dsp_type",-1) > -1) then
			snd.DSP = snd.Entity:GetInfoNum("tf_special_dsp_type",-1);
		end
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and (snd.Entity:GetInfoNum("tf_robot",0) == 1 and string.StartWith(snd.SoundName, "vo/") or (string.find(snd.Entity:GetModel(),"bot_") and !string.find(snd.Entity:GetModel(),"boss")) and string.StartWith(snd.SoundName, "vo/")) then
		if (snd.Entity:IsPlayer() and snd.Entity:GetInfoNum("tf_special_dsp_type",-1) > -1) then
			snd.DSP = snd.Entity:GetInfoNum("tf_special_dsp_type",-1);
		end
		
		
		if (snd.Entity:IsPlayer() and snd.Entity:GetPlayerClass() == "wtfdemoman") then
			snd.Pitch = 130
		else
			if (GetConVar("tf_pyrovision"):GetBool()) then
				snd.SoundName = string.Replace(snd.SoundName, "PainCrticialDeath", "laughlong")
				snd.SoundName = string.Replace(snd.SoundName, "PainSharp", "laughshort")
				snd.SoundName = string.Replace(snd.SoundName, "PainSevere", "laughhappy")
				snd.SoundName = string.Replace(snd.SoundName, "AutoOnFire", "PositiveVocalization")
				snd.SoundName = string.Replace(snd.SoundName, "heavy_laughshort04", "heavy_laughshort01")
				snd.SoundName = string.Replace(snd.SoundName, "heavy_laughshort05", "heavy_laughshort02")
				snd.SoundName = string.Replace(snd.SoundName, "heavy_laughlong03", "heavy_laughlong02")
			end
			snd.SoundName = string.Replace(snd.SoundName, "vo/scout", "vo/mvm/norm/scout_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/soldier", "vo/mvm/norm/soldier_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/pyro", "vo/mvm/norm/pyro_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/demoman", "vo/mvm/norm/demoman_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/heavy", "vo/mvm/norm/heavy_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/engineer", "vo/mvm/norm/engineer_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/medic", "vo/mvm/norm/medic_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/sniper", "vo/mvm/norm/sniper_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/spy", "vo/mvm/norm/spy_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/scout", "vo/mvm/norm/taunts/scout_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/soldier", "vo/mvm/norm/taunts/soldier_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/pyro", "vo/mvm/norm/taunts/pyro_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/demoman", "vo/mvm/norm/taunts/demoman_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/heavy", "vo/mvm/norm/taunts/heavy_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/engineer", "vo/mvm/norm/taunts/engineer_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/medic", "vo/mvm/norm/taunts/medic_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/sniper", "vo/mvm/norm/taunts/sniper_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "vo/taunts/spy", "vo/mvm/norm/taunts/spy_mvm")
			
			if (file.Exists(string.Replace(snd.SoundName, ".mp3", ".wav"), "WORKSHOP")) then
				snd.SoundName = string.Replace(snd.SoundName, ".mp3", ".wav")
			else
				snd.SoundName = string.Replace(snd.SoundName, ".wav", ".mp3")
			end
		end
		return true
	elseif IsValid(snd.Entity) and string.find(snd.SoundName, "vo/") and GetConVar("tf_pyrovision"):GetBool() then
		if (snd.Entity:GetInfoNum("tf_special_dsp_type",-1) > -1) then
			snd.DSP = snd.Entity:GetInfoNum("tf_special_dsp_type",-1);
		end
		snd.SoundName = string.Replace(snd.SoundName, "PainCrticialDeath", "laughlong")
		snd.SoundName = string.Replace(snd.SoundName, "PainSharp", "laughshort")
		snd.SoundName = string.Replace(snd.SoundName, "PainSevere", "laughhappy")
		snd.SoundName = string.Replace(snd.SoundName, "AutoOnFire", "PositiveVocalization")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughshort02", "pyro_laughshort01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughshort03", "pyro_laughshort01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughshort04", "pyro_laughshort01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughshort05", "pyro_laughshort01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughshort06", "pyro_laughshort01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughshort07", "pyro_laughshort01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughhappy02", "pyro_laughhappy01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughhappy03", "pyro_laughhappy01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughhappy04", "pyro_laughhappy01")
		snd.SoundName = string.Replace(snd.SoundName, "pyro_laughhappy05", "pyro_laughhappy01")
		snd.SoundName = string.Replace(snd.SoundName, "heavy_laughshort04", "heavy_laughshort01")
		snd.SoundName = string.Replace(snd.SoundName, "heavy_laughshort05", "heavy_laughshort02")
		snd.SoundName = string.Replace(snd.SoundName, "heavy_laughlong03", "heavy_laughlong02")
		
		if (file.Exists(string.Replace(snd.SoundName, ".mp3", ".wav"), "WORKSHOP")) then
			snd.SoundName = string.Replace(snd.SoundName, ".mp3", ".wav")
		else 
			snd.SoundName = string.Replace(snd.SoundName, ".wav", ".mp3")
		end
		snd.Pitch = 100 * 1.3
		return true
	elseif IsValid(snd.Entity) and snd.Entity:IsPlayer() and !snd.Entity:IsHL2() and snd.Entity:GetModel() and ((snd.Entity:GetInfoNum("tf_giant_robot",0) == 1 or (string.find(snd.Entity:GetModel(),"bot") and string.find(snd.Entity:GetModel(),"boss")))) and string.StartWith(snd.SoundName, "vo/") then
		if (snd.Entity:GetInfoNum("tf_special_dsp_type",-1) > -1) then
			snd.DSP = snd.Entity:GetInfoNum("tf_special_dsp_type",-1)
		end
		if (string.find(snd.Entity:GetModel(),"boss") or string.find(snd.Entity:GetModel(),"bot_sentry_buster")) then
			snd.SoundName = string.Replace(snd.SoundName, "vo/", "vo/mvm/mght/")
			snd.SoundName = string.Replace(snd.SoundName, "scout", "scout_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, "soldier", "soldier_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, "pyro", "pyro_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, "demoman", "demoman_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, "heavy", "heavy_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, "engineer", "engineer_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, "medic", "medic_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, "sniper", "sniper_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, "spy", "spy_mvm_m")
			snd.SoundName = string.Replace(snd.SoundName, ".wav", ".mp3")
		else
			snd.SoundName = string.Replace(snd.SoundName, "vo/", "vo/mvm/norm/")
			snd.SoundName = string.Replace(snd.SoundName, "scout", "scout_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "soldier", "soldier_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "pyro", "pyro_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "demoman", "demoman_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "heavy", "heavy_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "engineer", "engineer_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "medic", "medic_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "sniper", "sniper_mvm")
			snd.SoundName = string.Replace(snd.SoundName, "spy", "spy_mvm")
			snd.SoundName = string.Replace(snd.SoundName, ".wav", ".mp3")
			snd.DSP = 38
			snd.Pitch = 100 * 0.8
		end
		return true
	elseif IsValid(snd.Entity) and string.StartWith(snd.SoundName, "vo/") and snd.Entity:GetModel() and snd.Entity:IsPlayer() and !snd.Entity:IsHL2() and string.StartWith(snd.Entity:GetModel(),"models/player/") and snd.Entity.playerclass != "spy"  then
		if (snd.Entity:GetInfoNum("tf_special_dsp_type",-1) > -1) then
			snd.DSP = snd.Entity:GetInfoNum("tf_special_dsp_type",-1);
		end
		local tr = snd.Entity:GetEyeTrace()
		if (tr.Entity) then
			if (tr.Entity:IsPlayer() and tr.Entity:IsHL2()) then
				if (string.find(snd.SoundName, "CloakedSpyIdentify")) then
					if (snd.Entity.playerclass == "Soldier" || snd.Entity.playerclass == "Spy") then

						snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "vo/"..snd.Entity.playerclass.."_cloakedspyidentifygmodplayer.wav")

					else
						snd.SoundName = string.Replace(snd.SoundName, snd.SoundName, "vo/"..snd.Entity.playerclass.."_cloakedspyidentifygmod.wav")
					end
				end
			end
		end
		if (GetConVar("tf_pyrovision"):GetBool()) then
			snd.SoundName = string.Replace(snd.SoundName, "PainCrticialDeath", "laughlong")
			snd.SoundName = string.Replace(snd.SoundName, "PainSharp", "laughshort")
			snd.SoundName = string.Replace(snd.SoundName, "PainSevere", "laughhappy")
			snd.SoundName = string.Replace(snd.SoundName, "AutoOnFire", "PositiveVocalization")
			snd.SoundName = string.Replace(snd.SoundName, "heavy_laughshort04", "heavy_laughshort01")
			snd.SoundName = string.Replace(snd.SoundName, "heavy_laughshort05", "heavy_laughshort02")
			snd.SoundName = string.Replace(snd.SoundName, "heavy_laughlong03", "heavy_laughlong02")
		end
		if (!string.find(snd.SoundName,"announcer_") && !string.find(snd.SoundName,"mvm_") && !string.find(snd.SoundName,"burp")) then
			
			if snd.Entity:GetInfoNum("tf_player_use_female_models", 0) == 1 && snd.Entity:GetPlayerClass() == "soldier" then
				snd.Pitch = 130
			end 
			if (file.Exists(string.Replace(snd.SoundName, ".mp3", ".wav"), "WORKSHOP")) then
				snd.SoundName = string.Replace(snd.SoundName, ".mp3", ".wav")
			else
				snd.SoundName = string.Replace(snd.SoundName, ".wav", ".mp3")
			end
		end
		return true	
	elseif IsValid(snd.Entity) and string.StartWith(snd.SoundName, "vo/") and snd.Entity:IsPlayer() and snd.Entity.playerclass == "spy" then
		if (string.find(snd.Entity:GetModel(), "scout")) then
			snd.SoundName = string.Replace(snd.SoundName, "spy_", "scout_")
		elseif (string.find(snd.Entity:GetModel(), "soldier")) then
			snd.SoundName = string.Replace(snd.SoundName, "spy_", "soldier_")
		elseif (string.find(snd.Entity:GetModel(), "pyro")) then
			snd.SoundName = string.Replace(snd.SoundName, "spy_", "pyro_")
		elseif (string.find(snd.Entity:GetModel(), "demo")) then
			snd.SoundName = string.Replace(snd.SoundName, "spy_", "demoman_")
		elseif (string.find(snd.Entity:GetModel(), "heavy")) then
			snd.SoundName = string.Replace(snd.SoundName, "spy_", "heavy_")
		elseif (string.find(snd.Entity:GetModel(), "engineer")) then
			snd.SoundName = string.Replace(snd.SoundName, "spy_", "engineer_")
		elseif (string.find(snd.Entity:GetModel(), "medic")) then
			snd.SoundName = string.Replace(snd.SoundName, "spy_", "medic_")
		elseif (string.find(snd.Entity:GetModel(), "sniper")) then
			snd.SoundName = string.Replace(snd.SoundName, "spy_", "sniper_")
		end
		if (snd.Entity:GetInfoNum("tf_special_dsp_type",-1) > -1) then
			snd.DSP = snd.Entity:GetInfoNum("tf_special_dsp_type",-1);
		end
		if (GetConVar("tf_pyrovision"):GetBool()) then
			snd.SoundName = string.Replace(snd.SoundName, "painsharp", "laughshort")
			snd.SoundName = string.Replace(snd.SoundName, "painsevere", "laughhappy")
			snd.SoundName = string.Replace(snd.SoundName, "paincrticialdeath", "laughlong")
			snd.SoundName = string.Replace(snd.SoundName, "autoonfire", "laughhappy")
		end
		if (!string.find(snd.SoundName,"announcer_") && !string.find(snd.SoundName,"mvm_")) then
			
			if (file.Exists(string.Replace(snd.SoundName, ".mp3", ".wav"), "WORKSHOP")) then
				snd.SoundName = string.Replace(snd.SoundName, ".mp3", ".wav")
			else
				snd.SoundName = string.Replace(snd.SoundName, ".wav", ".mp3")
			end

		end
		return true
	elseif IsValid(snd.Entity) and string.StartWith(snd.SoundName, "vo/") and snd.Entity:IsPlayer() and snd.Entity:Team() == TEAM_BLU and string.find(game.GetMap(), "mvm") then
		snd.SoundName = string.Replace(snd.SoundName, "vo/", "vo/mvm/norm/")
		snd.SoundName = string.Replace(snd.SoundName, "scout", "scout_mvm")
		snd.SoundName = string.Replace(snd.SoundName, "soldier", "soldier_mvm")
		snd.SoundName = string.Replace(snd.SoundName, "pyro", "pyro_mvm")
		snd.SoundName = string.Replace(snd.SoundName, "demoman", "demoman_mvm")
		snd.SoundName = string.Replace(snd.SoundName, "heavy", "heavy_mvm")
		snd.SoundName = string.Replace(snd.SoundName, "engineer", "engineer_mvm")
		snd.SoundName = string.Replace(snd.SoundName, "medic", "medic_mvm")
		snd.SoundName = string.Replace(snd.SoundName, "sniper", "sniper_mvm")
		snd.SoundName = string.Replace(snd.SoundName, "spy", "spy_mvm")
		snd.SoundName = string.Replace(snd.SoundName, ".wav", ".mp3")
		return true 
	end
	return true
end) 

hook.Add("PlayerStepSoundTime", "FootTime", function(ply, iType, iWalking)
	if (ply:GetPlayerClass() == "tank_l4d") then
		if (ply:Crouching() || ply:GetMoveType() == MOVETYPE_LADDER) then
			local speed = 250 + 100
			return speed
		else
			local speed = 250
			return speed
		end
	end
	if (ply:GetPlayerClass() == "boomer") then
		if (ply:Crouching() || ply:GetMoveType() == MOVETYPE_LADDER) then
			local speed = 400 + 100
			return speed
		else
			local speed = 350
			return speed
		end
	end
	if (ply:GetPlayerClass() == "charger") then
		if (ply:Crouching() || ply:GetMoveType() == MOVETYPE_LADDER) then
			local speed = 300 + 100
			return speed
		else
			local speed = 270
			return speed
		end
	end
	if (ply:GetPlayerClass() == "smoker") then
		if (ply:Crouching() || ply:GetMoveType() == MOVETYPE_LADDER) then
			local speed = 400 + 100
			return speed
		else
			local speed = 370
			return speed
		end
	end
	if (ply:GetPlayerClass() == "hunter") then
		if (ply:Crouching() || ply:GetMoveType() == MOVETYPE_LADDER) then
			local speed = 400 + 100
			return speed
		else
			local speed = 360
			return speed
		end
	end
	if (iType == STEPSOUNDTIME_ON_LADDER) then
		local speed = 350
		return speed
	end
	if (iType == STEPSOUNDTIME_NORMAL || iType == STEPSOUNDTIME_WATER_FOOT) then
		if (ply:GetMoveType() == MOVETYPE_LADDER) then
			local speed = math.Remap(ply:GetMaxSpeed(), 200, 450, 400, 200) + 100
			return speed
		else
			if (ply:Crouching()) then
				local speed = math.Remap(ply:GetMaxSpeed(), 200, 450, 400, 200) + 100 + ply:GetVelocity():Length2D() / (ply:GetMaxSpeed() * 0.8)
				return speed
			else
				if (ply:GetWalkSpeed() > 450) then
				
					local speed = 200 + ply:GetVelocity():Length2D() / (ply:GetMaxSpeed() * 0.8)
					return speed
					
				else
					if (ply:GetWalkSpeed() < 229 and !ply:KeyDown(IN_SPEED)) then
					
						local speed = 400 + ply:GetVelocity():Length2D() / (ply:GetMaxSpeed() * 0.8)
						return speed 
						
					else
						local speed = math.Remap(ply:GetMaxSpeed(), 200, 450, 400, 200) + ply:GetVelocity():Length2D() / (ply:GetMaxSpeed() * 0.8)
						return speed
					end
				end
			end
		end
	end
	if (iType == STEPSOUNDTIME_WATER_KNEE) then
		if (ply:Crouching()) then
			local speed = math.Remap(ply:GetMaxSpeed(), 200, 450, 600, 200) + 100
			return speed
		else
			if (ply:GetWalkSpeed() > 450) then
			
				local speed = 200
				return speed
				
			else
				if (ply:GetWalkSpeed() < 229 and !ply:KeyDown(IN_SPEED)) then
					
					local speed = 400
					return speed 
						
				else
					local speed = math.Remap(ply:GetMaxSpeed(), 200, 450, 600, 200)
					return speed
				end
			end
		end
	end
end)
