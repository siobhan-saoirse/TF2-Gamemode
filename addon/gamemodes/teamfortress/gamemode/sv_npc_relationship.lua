
-- Those classes will keep default relationship regardless of which team concerns them
local IgnoredClasses = {
	[CLASS_FLARE] = 1,
	[CLASS_EARTH_FAUNA] = 1,
	[CLASS_BULLSEYE] = 1,
}

local function CalcRelationship(ent1, ent2)
	local t1, t2 = GAMEMODE:EntityTeam(ent1), GAMEMODE:EntityTeam(ent2)
	if t1==t2 then
		if (ent2:IsPlayer() and ent2:IsL4D() and ent1:Classify() != CLASS_ZOMBIE) then
			return D_HT
		elseif (ent1:IsPlayer() and ent1:IsL4D() and ent2:Classify() != CLASS_ZOMBIE) then
			return D_HT 
		elseif t1==TEAM_RED or t1==TEAM_BLU or t1==TEAM_GREEN or t1==TEAM_YELLOW or t1==TF_TEAM_PVE_INVADERS or t1==TEAM_INFECTED then
			return D_LI
		else
			--return D_NU
		end
	else
		if (ent2:IsPlayer() and ent2:IsL4D() and t2 == TEAM_BLU and ent1:Classify() == CLASS_ZOMBIE) then
			return D_LI
		elseif (ent1:IsPlayer() and ent1:IsL4D() and t1 == TEAM_BLU and ent2:Classify() == CLASS_ZOMBIE) then
			return D_LI
		elseif (ent2:IsPlayer() and ent2:IsL4D() and t2 == TEAM_BLU and ent1:Classify() != CLASS_ZOMBIE) then
			return D_HT
		elseif (ent1:IsPlayer() and ent1:IsL4D() and t1 == TEAM_BLU and ent2:Classify() != CLASS_ZOMBIE) then
			return D_HT 
		elseif (ent1:IsPlayer() and t1 == TEAM_FRIENDLY) then
			return D_LI
		elseif (ent2:IsPlayer() and t2 == TEAM_FRIENDLY) then
			return D_LI
		elseif (ent1:IsPlayer() and !ent2.HatesNeutral and t1 == TEAM_NEUTRAL) then
			return D_LI
		elseif (ent2:IsPlayer() and !ent1.HatesNeutral and t2 == TEAM_NEUTRAL) then
			return D_LI
		elseif (ent1:IsPlayer() and ent2.HatesNeutral and t1 == TEAM_NEUTRAL) then
			return D_HT
		elseif (ent2:IsPlayer() and ent1.HatesNeutral and t2 == TEAM_NEUTRAL) then
			return D_HT
		elseif (ent1:IsPlayer() and t1 == TEAM_SPECTATOR) then
			return D_LI
		elseif (ent2:IsPlayer() and t2 == TEAM_SPECTATOR) then
			return D_LI
		else
			return D_HT
		end
	end
end

function GM:UpdateEntityRelationship(ent)
	-- Use default relationships in the first maps of the first chapter
	if GetGlobalBool("GordonIsPrecriminal") or self.GordonIsPrecriminal then
		return
	end
	
	for _,v in pairs(ents.GetAll()) do
		if (v:IsNPC() and v:EntityTeam()~=TEAM_HIDDEN and not IgnoredClasses[v:Classify()]) or v:IsPlayer() then
			if (v.TargetEnt == ent) then return end
			local rel = CalcRelationship(v, ent)
			if (!v:IsFlagSet(FL_CLIENT)) then
				v:AddFlags(FL_CLIENT)
				v:AddFlags(FL_FAKECLIENT)
			end
			if rel then
				if v:IsNPC() then
					v:AddEntityRelationship(ent, rel)
				end
				if v:GetClass() == "pill_puppet" then
					v:AddEntityRelationship(ent, D_LI, 99)
				end
				if ent:GetClass() == "pill_puppet" then
					ent:AddEntityRelationship(v, D_LI, 99)
				end
				if ent:IsNPC() then
					ent:AddEntityRelationship(v, rel)
				end
			end
		end
	end
end

hook.Add("OnEntityCreated", "TF_UpdateNPCRelationship", function(ent)
	if (GetConVar("civ2_randomizer"):GetBool()) then
		timer.Simple(1.0, function()
		
			if (IsValid(ent)) then
				for i=0,ent:GetBoneCount() do
					ent:ManipulateBoneJiggle( i, math.random(1,1.2) )	
				end 
			end
			
		end)
	end
	if (ent:IsNPC()) then
		ent:AddFlags(FL_NPC)
		ent:AddFlags(FL_CLIENT)
		ent:AddFlags(FL_FAKECLIENT)
	end
	if ent:IsNPC() and ent:EntityTeam()~=TEAM_HIDDEN and not IgnoredClasses[ent:Classify()] and !ent:HasNPCFlag(NPC_NORELATIONSHIP) then
		GAMEMODE:UpdateEntityRelationship(ent)
		timer.Simple(0.1, function()
			GAMEMODE:UpdateEntityRelationship(ent)
		end)
		if (GetConVar("civ2_randomizer"):GetBool() and ent:IsNPC() and !ent.IsRandomizedNPC) then
			ent.IsRandomizedNPC = true
			local mahogany = {
					"npc_alyx",
					"npc_antlion",
					"npc_antlionguard",
					"npc_barnacle",
					"npc_barney",
					"npc_breen",
					"npc_citizen",
					"npc_clawscanner",
					"npc_combine_camera",
					"npc_combine_s",
					"npc_crow",
					"npc_cscanner",
					"npc_dog",
					"npc_eli",
					"npc_fastzombie",
					"npc_fastzombie_torso",
					"npc_gman",
					"npc_headcrab",
					"npc_headcrab_black",
					"npc_headcrab_poison",
					"npc_headcrab_fast",
					"npc_icthyosaur",
					"npc_kleiner",
					"npc_manhack",
					"npc_metropolice",
					"npc_monk",
					"npc_mossman",
					"npc_pigeon",
					"npc_poisonzombie",
					"npc_rollermine",
					"npc_seagull",
					"npc_sniper",
					"npc_stalker",
					"npc_strider",
					"npc_turret_floor",
					"npc_vortigaunt",
					"npc_zombie",
					"npc_zombie_torso",
				}
			if (IsMounted("hl1")) then
				local hl1npcs = {
						"monster_scientist",
						"monster_barney",
						"monster_alien_grunt",
						"monster_alien_slave",
						"monster_human_assassin",
						"monster_babycrab",
						"monster_barnacle",
						"monster_flyer",
						"monster_bullchicken",
						"monster_cockroach",
						"monster_alien_controller",
						"monster_bloater",
						"monster_gman",
						"monster_gargantua",
						"monster_bigmomma",
						"monster_bigmomma_strong",
						"monster_human_grunt",
						"monster_headcrab",
						"monster_houndeye",
						"monster_ichthyosaur",
						"monster_leech",
						"monster_sentry",
						"monster_sitting_scientist",
						"monster_snark",
						"monster_tentacle",
						"monster_zombie"
				}
				table.Merge(mahogany, hl1npcs)
			end
			local newEntity = ents.Create(table.Random(mahogany))
			if (ent:EntIndex() != newEntity:EntIndex()) then
				newEntity.IsRandomizedNPC = true
				newEntity.RandomNPC = true
				timer.Simple(0.1, function()
					if (!ent.RandomNPC) then
						if (IsValid(ent:GetActiveWeapon())) then
							newEntity:Give(ent:GetActiveWeapon():GetClass())
						end
						timer.Simple(0.3, function()
							newEntity:Spawn()
							newEntity:Activate()
							newEntity:SetPos(ent:GetPos())
							newEntity:SetAngles(ent:GetAngles())
							timer.Simple(0.1, function()
								ent:Remove()
							end)
						end)
					end
				end)
			end
		end
	end
end)
hook.Add("Think", "TF_UpdateNPCRelationshipLoop", function(ent)
	
end)
