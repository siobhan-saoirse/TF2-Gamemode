-- Deathposes

local debug_deathposes = CreateConVar("debug_deathposes",0)

local PhysBones = {
	"ValveBiped.Bip01_Pelvis",
	"ValveBiped.Bip01_Spine2",
	"ValveBiped.Bip01_Head1",
	"ValveBiped.Bip01_L_Upperarm",
	"ValveBiped.Bip01_L_Forearm",
	"ValveBiped.Bip01_L_Hand",
	"ValveBiped.Bip01_R_Upperarm",
	"ValveBiped.Bip01_R_Forearm",
	"ValveBiped.Bip01_R_Hand",
	"ValveBiped.Bip01_L_Thigh",
	"ValveBiped.Bip01_L_Calf",
	"ValveBiped.Bip01_L_Foot",
	"ValveBiped.Bip01_R_Thigh",
	"ValveBiped.Bip01_R_Calf",
	"ValveBiped.Bip01_R_Foot",
}

local function BuildBoneLookupTable(ent)
	ent.BoneTable = {}
	for _,v in ipairs(PhysBones) do
		ent.BoneTable[v] = ent:LookupBone(v)
	end
	
	ent.PhysBoneTable = {}
	for i=0,ent:GetPhysicsObjectCount()-1 do
		ent.PhysBoneTable[ent:TranslatePhysBoneToBone(i)] = i
	end
end

local function BoneToPhysBone(ent, bone)
	if not ent.BoneTable or not ent.PhysBoneTable then
		BuildBoneLookupTable(ent)
	end
	
	if not ent.BoneTable[bone] or not ent.PhysBoneTable[ent.BoneTable[bone]] then
		return
	end
	
	return ent.PhysBoneTable[ent.BoneTable[bone]]
end

DecapDeathPose = {
	PhysParams = {
		["ValveBiped.Bip01_Pelvis"]		 = {f=true,d={2000,12000},m={0.05,0.2}},
		["ValveBiped.Bip01_Spine2"]		 = {f=true,d={2000,12000},rd={800,1200},m={0.05,0.2}},
		["ValveBiped.Bip01_Head1"]		 = {m={0.1,0.3}},
		["ValveBiped.Bip01_L_Upperarm"]	 = {f=true,m={0.05,0.15}},
		["ValveBiped.Bip01_L_Forearm"]	 = {f=true,m={0.05,0.15}},
		["ValveBiped.Bip01_L_Hand"]		 = {f=true,m={0.05,0.15}},
		["ValveBiped.Bip01_R_Upperarm"]	 = {f=true,m={0.05,0.15}},
		["ValveBiped.Bip01_R_Forearm"]	 = {f=true,m={0.05,0.15}},
		["ValveBiped.Bip01_R_Hand"]		 = {f=true,m={0.05,0.15}},
		["ValveBiped.Bip01_L_Thigh"]	 = {f=true,d={800,1200},m={7,13},rd={20,800}},
		["ValveBiped.Bip01_L_Calf"]		 = {f=true,d={800,1200},rd={20,800}},
		["ValveBiped.Bip01_L_Foot"]		 = {f=true,d={800,1200},m={70,130}},
		["ValveBiped.Bip01_R_Thigh"]	 = {f=true,d={800,1200},m={7,13},rd={20,800}},
		["ValveBiped.Bip01_R_Calf"]		 = {f=true,d={800,1200},rd={20,800}},
		["ValveBiped.Bip01_R_Foot"]		 = {f=true,d={800,1200},m={70,130}},
	},
	Probability = 0.7,
	MinDuration = 0.4,
	MaxDuration = 1.2
}

HeadshotDeathPose = {
	PhysParams = {
		["ValveBiped.Bip01_Pelvis"]		 = {f=true,d={2000,12000},m={0.05,0.2}},
		["ValveBiped.Bip01_Spine2"]		 = {f=true,d={2000,12000},rd={1200,2400},m={0.05,0.2}},
		["ValveBiped.Bip01_Head1"]		 = {m={0.02,0.1},d={300,550}},
		["ValveBiped.Bip01_L_Upperarm"]	 = {f=false,m={0.05,0.15},rd={800,1200}},
		["ValveBiped.Bip01_L_Forearm"]	 = {f=false,m={0.05,0.15},rd={800,1200}},
		["ValveBiped.Bip01_L_Hand"]		 = {f=false,m={0.05,0.15},rd={800,1200}},
		["ValveBiped.Bip01_R_Upperarm"]	 = {f=false,m={0.05,0.15},rd={800,1200}},
		["ValveBiped.Bip01_R_Forearm"]	 = {f=false,m={0.05,0.15},rd={800,1200}},
		["ValveBiped.Bip01_R_Hand"]		 = {f=false,m={0.05,0.15},rd={800,1200}},
		["ValveBiped.Bip01_L_Thigh"]	 = {f=false,d={2000,12000},m={7,13},rd={20,800}},
		["ValveBiped.Bip01_L_Calf"]		 = {f=false,d={2000,12000},rd={20,800}},
		["ValveBiped.Bip01_L_Foot"]		 = {f=false,d={2000,12000},m={70,130}},
		["ValveBiped.Bip01_R_Thigh"]	 = {f=false,d={2000,12000},m={7,13},rd={20,800}},
		["ValveBiped.Bip01_R_Calf"]		 = {f=false,d={2000,12000},rd={20,800}},
		["ValveBiped.Bip01_R_Foot"]		 = {f=false,d={2000,12000},m={70,130}},
	},
	Probability = 0.7,
	MinDuration = 0.3,
	MaxDuration = 0.8,
}

local function Val(x)
	if type(x)=="number" then
		return x
	else
		return math.Rand(x[1], x[2])
	end
end

local function StartDeathPose(ent, dp)
	if not IsValid(ent) then return end
	ent.OldPhysParams = {}

	for bone, tab in pairs(dp.PhysParams) do
		local physn = ent:TranslateBoneToPhysBone(ent:LookupBone(bone))
		if physn ~= -1 then
			local phys = ent:GetPhysicsObjectNum(physn)
			ent.OldPhysParams[physn] = {phys:GetSpeedDamping(), phys:GetRotDamping(), phys:GetMass()}
			if tab.f then
				phys:EnableMotion(false)
				phys:SetVelocity(Vector(0, 0, 0))
				phys:EnableMotion(true)
			end

			if tab.d and tab.rd then
				phys:SetDamping(Val(tab.d), Val(tab.rd))
			elseif tab.d then
				phys:SetDamping(Val(tab.d), phys:GetRotDamping())
			elseif tab.rd then
				phys:SetDamping(phys:GetSpeedDamping(), Val(tab.rd))
			end

			if tab.m then
				phys:SetMass(phys:GetMass() * Val(tab.m))
			end
		end
	end
end

function EndDeathPose(ent)
	if !IsValid(ent) then return end

	for id, tab in pairs(ent.OldPhysParams) do
		local phys = ent:GetPhysicsObjectNum(id)
		phys:SetDamping(tab[1], tab[2])
		phys:SetMass(tab[3])
	end
end

function PlayDeathPose(ent, dp)
	-- Deathposes should be played serverside on serverside ragdolls
	if CLIENT and ent.IsServerRagdoll then return end

	if math.random() < dp.Probability then
		StartDeathPose(ent, dp)
		timer.Simple(math.Rand(dp.MinDuration, dp.MaxDuration), function() EndDeathPose(ent) end)
	end
end

if CLIENT then

local Tolerancy = 150
-- Keeping track of player and npc ragdolls
hook.Add("OnEntityCreated", "TFPlayerRagdollCreated", function(ent)
	if IsValid(ent) then
		if ent:GetClass()=="class C_HL2MPRagdoll" then
			for _,v in pairs(player.GetAll()) do
				if v:GetRagdollEntity()==ent then
					gamemode.Call("SetupPlayerRagdoll", v, ent)
					return
				end
			end
		elseif ent:GetClass()=="class C_ClientRagdoll" then
			local mindist, best
			
			--timer.Simple(0.01, function() ent.StopParticles(ent) end)
			
			--MsgN(Format("Ragdoll:%s '%s'",tostring(ent),ent:GetModel()))
			
			for _,v in pairs(ents.GetAll()) do
				if v:IsNPC() and v:GetModel()==ent:GetModel() then
					--Msg(Format("Candidate:%s  %s %s %s"),tostring(v),tostring(v:GetSequence()),tostring(v:SelectWeightedSequence(ACT_DIERAGDOLL)),tostring(v:SelectWeightedSequence(ACT_DIESIMPLE)))
					
					-- actually, we wouldn't even need a health check
					
					--[[if v:Health()>0 and v:GetSequence()~=0 then
						MsgN(Format(" Not dead! (health=%d)",v:Health()))
					else]]
					if v.DoneSetupRagdoll then
						--MsgN(" Already processed!")
					else
						local v1,v2 = v:GetPos(), ent:GetPos()
						local d = v1:Distance(v2)
						
						--MsgN(Format(" Distance: %f",d))
						
						if not mindist or d<mindist then
							mindist,best = d,v
						end
					end
				end
			end
			
			if best then
				--MsgN(Format("Best candidate:%s Distance:%f",tostring(best),mindist))
				best.DoneSetupRagdoll = true
				gamemode.Call("SetupNPCRagdoll", best, ent)
			else
				--MsgN(Format("No match!"))
			end
		end
	end
end)


local function Decap_HL2(ent)
	--print("nyoooooooooooooooooo")
	local b1 = ent:LookupBone("ValveBiped.Bip01_Head1")
	local b2 = ent:LookupBone("ValveBiped.Bip01_Spine2")
	
	local m1 = ent:GetBoneMatrix(b1)
	local m2 = ent:GetBoneMatrix(b2)
	
	if IsValid(ent.Owner) and not ent.SpawnedHeadGib then
		local ang = m1:GetAngles()
		ang:RotateAroundAxis(ang:Right(), -90)
		ang:RotateAroundAxis(ang:Up(), -90)
		local pos = m1:GetTranslation() - 73 * ang:Up()
		local data = EffectData()
			data:SetOrigin(pos)
			data:SetAngles(ang)
			data:SetEntity(ent.Owner)
		util.Effect("tf_hl2_head_gib", data)
		
		ent.SpawnedHeadGib = true
	end
	
	if IsValid(ent.DecapLocator) then
		ent.DecapLocator:SetPos(m1:GetTranslation())
		local ang = m2:GetAngles()
		ang:RotateAroundAxis(ang:Right(), -90)
		ent.DecapLocator:SetAngles(ang)
		
		if not ent.DecapLocator.PlayedSound then
			ent.DecapLocator:EmitSound("TFPlayer.Decapitated")
			ent.DecapLocator.PlayedSound = true
		end
		
		if CurTime()>ent.NextDecapEnd then
			ent.DecapLocator:SetParent()
			SafeRemoveEntityDelayed(ent.DecapLocator, 0.1)
			ent.DecapLocator = nil
		end
	end
	
	m1:SetTranslation(m2:GetTranslation())
	m1:Scale(Vector(0,0,0))
	
	ent:SetBoneMatrix(b1, m1)
end

local function Decap_TF2(ent)
	local b1 = ent:LookupBone("bip_head")
	local b2 = ent:LookupBone("bip_neck")
	
	local m1 = ent:GetBoneMatrix(b1)
	local m2 = ent:GetBoneMatrix(b2)
	
	if IsValid(ent.Owner) and not ent.SpawnedHeadGib then
		local ang = m1:GetAngles()
		local pos = m1:GetTranslation() - 73 * ang:Up()
		local data = EffectData()
			data:SetOrigin(pos)
			data:SetAngles(ang)
			data:SetNormal(Vector(0,0,0.04))
			data:SetEntity(ent.Owner)
		util.Effect("tf_tf2_head_gib", data)
		
		ent.SpawnedHeadGib = true
	end
	
	if IsValid(ent.DecapLocator) then
		ent.DecapLocator:SetPos(m1:GetTranslation())
		ent.DecapLocator:SetAngles(m1:GetAngles())
		
		if not ent.DecapLocator.PlayedSound then
			ent.DecapLocator:EmitSound("TFPlayer.Decapitated")
			ent.DecapLocator.PlayedSound = true
		end
		
		if CurTime()>ent.NextDecapEnd then
			ent.DecapLocator:SetParent()
			SafeRemoveEntityDelayed(ent.DecapLocator, 0.1)
			ent.DecapLocator = nil
		end
	end
	
	m1:Scale(Vector(0,0,0))
	m2:Scale(Vector(0,0,0))
	
	ent:SetBoneMatrix(b1, m1)
	ent:SetBoneMatrix(b2, m2)
end

hook.Add("CreateClientsideRagdoll", "TF_Decapitate", function(ent, rag)
	if ent:IsNPC() and ent:HasDeathFlag(DF_DECAP) then
		--print("Decapme!")
	end
end)

function GM:DecapitateRagdoll(rag, owner, deathpose)
	local b
	----print("decap1")
	b = rag:LookupBone("ValveBiped.Bip01_Head1")
	if b and b>0 then
		rag.NextDecapEnd = CurTime() + 5
		rag.DecapLocator = ClientsideModel("models/props_junk/watermelon01.mdl")
		rag.DecapLocator:SetPos(rag:GetBonePosition(b))
		rag.DecapLocator:SetNoDraw(true)
		rag.DecapLocator:SetParent(rag)
		----print("decap2")
		ParticleEffectAttach("blood_decap", PATTACH_ABSORIGIN_FOLLOW, rag.DecapLocator, 0)
		rag.Owner = owner
		--rag.BuildBonePositions = Decap_HL2
		--rag:AddBuildBoneHook("RagdollDecap", Decap_HL2)
		rag:EmitSound("player/flow.wav")
		rag:ManipulateBoneScale(b, Vector(0, 0, 0))
		
		if deathpose  then
			PlayDeathPose(rag, DecapDeathPose)
		end
		
		return 1
	end
	----print("decap3")
	b = rag:LookupBone("bip_head")
	if b and b>0 then
		rag.NextDecapEnd = CurTime() + 5
		rag.DecapLocator = ClientsideModel("models/props_junk/watermelon01.mdl")
		rag.DecapLocator:SetNoDraw(true)
		rag.DecapLocator:SetParent(rag)
		
		ParticleEffectAttach("blood_decap", PATTACH_ABSORIGIN_FOLLOW, rag.DecapLocator, 0)
		rag.Owner = owner
		--rag.BuildBonePositions = Decap_TF2
		--rag:AddBuildBoneHook("RagdollDecap", Decap_TF2)
		rag:EmitSound("player/flow.wav")
		rag:ManipulateBoneScale(b, Vector(0, 0, 0))
		return 0
	end
end

function GM:SetupNPCRagdoll(ent, rag)
	ent.DeathRagdoll = rag
	
	----print(rag,ent:GetNWBool("ShouldDropDecapitatedRagdoll"))
	
	-- Ignite the ragdoll if the NPC died from fire damage
	rag:StopParticles()
	if ent:HasDeathFlag(DF_FIRE) then
		ParticleEffectAttach("burningplayer_corpse", PATTACH_ABSORIGIN_FOLLOW, rag, 0)
	end
	
	if ent:HasDeathFlag(DF_DECAP) then
		if ent:IsOnGround() and SERVER then
			-- self:DecapitateRagdoll(rag, ent, true)
		end
	elseif ent:HasDeathFlag(DF_HEADSHOT) then
		PlayDeathPose(rag, HeadshotDeathPose)
	end
	
	rag.NPCRagdollProcessed = true
	
	-- Transmit the arrows stuck into the NPC to its ragdoll
	for k,_ in pairs(ent.StuckArrows or {}) do
		k.Parent = rag
	end
	ent.StuckArrows = {}
	
	timer.Simple(0.1, function() self:CheckAllNPCRagdolls() end)
	timer.Simple(0.2, function() self:CheckAllNPCRagdolls() end)
end

usermessage.Hook("TFServerRagdollInit", function(msg)
	local npc = msg:ReadEntity()
	local rag = msg:ReadEntity()
	----print(npc,rag)
	if IsValid(npc) and IsValid(rag) then
		rag.IsServerRagdoll = true
		
		--npc:SetNWBool("ShouldDropBurningRagdoll", msg:ReadBool())
		npc:SetNWBool("ShouldDropDecapitatedRagdoll", msg:ReadBool())
		--npc:SetNWBool("DeathByHeadshot", msg:ReadBool())
		
		gamemode.Call("SetupNPCRagdoll", npc, rag)
	end
end)

-- Since the NPC ragdoll detection isn't perfectly accurate, unwanted effects might occur, such as the HL2 fire not disappearing like it should
-- We'll just fix those unprocessed ragdolls here
function GM:CheckAllNPCRagdolls()
	for _,v in pairs(ents.FindByClass("class C_ClientRagdoll")) do
		if not v.NPCRagdollProcessed then
			v:StopParticles()
			v.NPCRagdollProcessed = true
		end
	end
end

function GM:SetupPlayerGib(pl, gib, gibtype)
end

function GM:SetupPlayerRagdoll(pl, rag)
	pl.DeathRagdoll = rag
	
	rag:SetupBones()
	
	rag:StopParticles()
	if pl:Team()==TEAM_BLU or pl:Team()==TF_TEAM_PVE_INVADERS then
		rag:SetSkin(1)
	else
		rag:SetSkin(0)
	end
	
	if pl:HasDeathFlag(DF_FIRE) then
		ParticleEffectAttach("burningplayer_corpse", PATTACH_ABSORIGIN_FOLLOW, rag, 0)
	end
	
	if pl:HasDeathFlag(DF_DECAP) then
		local dp
		if pl:IsHL2() and pl:IsOnGround() then
			dp = true
		end
		
		self:DecapitateRagdoll(rag, pl, dp)
	end
	
	for k,_ in pairs(pl.StuckArrows or {}) do
		k.Parent = rag
	end
	pl.StuckArrows = {}
	
	-- Apply the bodygroup settings from the player's hat data
	for i=1,10 do
		rag:SetBodygroup(i,0)
	end
	
	for _,v in pairs(pl:GetTFItems()) do
		if v.ApplyPlayerBodygroups then
			v:ApplyPlayerBodygroups(rag)
		end
		
		if v.SetupPlayerRagdoll then
			v:SetupPlayerRagdoll(rag)
		end
	end
	
	--[[
	for _,h in pairs(ents.FindByClass("tf_hat")) do
		MsgN(Format("Hat owner : %s - Model : %s",tostring(h:GetOwner()),h:GetHatModel()))
		if h:GetOwner()==pl then
			local hat = h:GetHatData()
			local hatmodel = h:GetHatModel()
			if hat then
				h:SetupPlayerBodygroups(rag)
				
				if not hat.nomodel and util.IsValidModel(hatmodel) then
					local effectdata = EffectData()
					effectdata:SetEntity(h)
					
					if hat.nodrop then
						-- This hat doesn't drop, attach it to the player's ragdoll
						util.Effect("tf_hat_attached", effectdata)
					else
						-- Spawn a hat gib
						effectdata:SetMagnitude(GIB_HAT)
						effectdata:SetOrigin(pl:GetPos())
						effectdata:SetAngles(pl:GetAngles())
						effectdata:SetNormal(Vector(0,0,0.8))
						effectdata:SetRadius(0.8)
						util.Effect("tf_gib", effectdata)
					end
				end
			end
		end
	end]]
end

end


if SERVER then

GoldenMassParams = {
	["ValveBiped.Bip01_Pelvis"]		 = 0.5,
	["ValveBiped.Bip01_Spine2"]		 = 0.5,
	["ValveBiped.Bip01_Head1"]		 = 2,
	["ValveBiped.Bip01_L_Upperarm"]	 = 1,
	["ValveBiped.Bip01_L_Forearm"]	 = 2,
	["ValveBiped.Bip01_L_Hand"]		 = 4,
	["ValveBiped.Bip01_R_Upperarm"]	 = 1,
	["ValveBiped.Bip01_R_Forearm"]	 = 2,
	["ValveBiped.Bip01_R_Hand"]		 = 4,
	["ValveBiped.Bip01_L_Thigh"]	 = 2,
	["ValveBiped.Bip01_L_Calf"]		 = 5,
	["ValveBiped.Bip01_L_Foot"]		 = 15,
	["ValveBiped.Bip01_R_Thigh"]	 = 2,
	["ValveBiped.Bip01_R_Calf"]		 = 5,
	["ValveBiped.Bip01_R_Foot"]		 = 15,
}

hook.Add("CreateEntityRagdoll", "TFServersideNPCRagdoll", function(npc, rag)
	umsg.Start("TFServerRagdollInit")
		umsg.Entity(npc)
		umsg.Entity(rag)
	umsg.End()
	
	if npc.LastArrowHitPos then
		local phys = rag:GetPhysicsObjectNum(npc.LastArrowHitBone)
		if IsValid(phys) then
			local pos = npc.LastArrowHitPos
			local dir = npc.LastArrowHitAng:Forward()
			
			local tr = util.TraceLine{
				start = pos,
				endpos = pos + dir * 80,
				mask = MASK_SOLID_BRUSHONLY,
			}
			if tr.Hit and not tr.HitSky then
				-- Pin the ragdoll
				pos = tr.HitPos - dir * 5
				phys:SetPos(pos)
				
				-- do some fancier pinning, since we have serverside constraints
				local hitent = (IsValid(tr.Entity) and tr.Entity) or game.GetWorld()
				constraint.Ballsocket(rag, hitent, npc.LastArrowHitBone, 0, hitent:WorldToLocal(pos), 0, 0, 0)
			end
		end
		
		npc.LastArrowHitPos = nil
		npc.LastArrowHitAng = nil
		npc.LastArrowHitBone = nil
	elseif npc:HasDeathFlag(DF_GOLDEN) then
		-- Straight copy from the Statue tool (you can even un-statue the whole ragdoll using that tool this way)
		
		rag.StatueInfo = {}
		rag.StatueInfo.Welds = {}
		
		local bones = rag:GetPhysicsObjectCount()
		
		-- Weld each physics object together
		
		for k,v in pairs(GoldenMassParams) do
			local p = BoneToPhysBone(rag, k)
			if p then
				local phys = rag:GetPhysicsObjectNum(p)
				if phys and phys:IsValid() then
					phys:SetMass(phys:GetMass() * v)
				end
				
				
			end
		end
		
		for bone=1, bones do
			local bone1 = bone - 1
			local bone2 = bones - bone
			
			local phys = rag:GetPhysicsObjectNum(bone1)
			phys:EnableMotion(false)
			phys:SetVelocity(Vector(0,0,0))
			phys:EnableMotion(true)
			
			-- Don't do identical two welds
			if not rag.StatueInfo.Welds[bone2] then
				local constraint1 = constraint.Weld(rag, rag, bone1, bone2, 0)
				
				if constraint1 then
					rag.StatueInfo.Welds[bone1] = constraint1
				end
			end
			
			local constraint2 = constraint.Weld(rag, rag, bone1, 0, 0)
			
			if constraint2 then
				rag.StatueInfo.Welds[bone1+bones] = constraint2
			end
		end
		
		rag:SetMaterial("models/player/shared/gold_player")
	elseif npc:HasDeathFlag(DF_DECAP) then
		PlayDeathPose(rag, DecapDeathPose)
	elseif npc:HasDeathFlag(DF_HEADSHOT) then
		PlayDeathPose(rag, HeadshotDeathPose)
	end
end)

end