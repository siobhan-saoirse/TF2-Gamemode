-- todo: fully replace all of shd_ragdoll's functions so we can delete it
-- todo: better physics (headsheadsheadsheads had very good physics, could it have been using custom models?)
-- todo: find a way that doesn't use stencils (lags with just 8-18 decapitations)
-- todo: headshot

local DecapDeathPose = {
    PhysParams = {
        ["ValveBiped.Bip01_Pelvis"] = {
            f = true,
            d = {2000, 12000},
            m = {0.05, 0.2}
        },
        ["ValveBiped.Bip01_Spine2"] = {
            f = true,
            d = {2000, 12000},
            rd = {800, 1200},
            m = {0.05, 0.2}
        },
        ["ValveBiped.Bip01_Head1"] = {
            m = {0.1, 0.3}
        },
        ["ValveBiped.Bip01_L_Upperarm"] = {
            f = true,
            m = {0.05, 0.15}
        },
        ["ValveBiped.Bip01_L_Forearm"] = {
            f = true,
            m = {0.05, 0.15}
        },
        ["ValveBiped.Bip01_L_Hand"] = {
            f = true,
            m = {0.05, 0.15}
        },
        ["ValveBiped.Bip01_R_Upperarm"] = {
            f = true,
            m = {0.05, 0.15}
        },
        ["ValveBiped.Bip01_R_Forearm"] = {
            f = true,
            m = {0.05, 0.15}
        },
        ["ValveBiped.Bip01_R_Hand"] = {
            f = true,
            m = {0.05, 0.15}
        },
        ["ValveBiped.Bip01_L_Thigh"] = {
            f = true,
            d = {800, 1200},
            m = {7, 13},
            rd = {20, 800}
        },
        ["ValveBiped.Bip01_L_Calf"] = {
            f = true,
            d = {800, 1200},
            rd = {20, 800}
        },
        ["ValveBiped.Bip01_L_Foot"] = {
            f = true,
            d = {800, 1200},
            m = {70, 130}
        },
        ["ValveBiped.Bip01_R_Thigh"] = {
            f = true,
            d = {800, 1200},
            m = {7, 13},
            rd = {20, 800}
        },
        ["ValveBiped.Bip01_R_Calf"] = {
            f = true,
            d = {800, 1200},
            rd = {20, 800}
        },
        ["ValveBiped.Bip01_R_Foot"] = {
            f = true,
            d = {800, 1200},
            m = {70, 130}
        }
    },
    Probability = 0.7,
    MinDuration = 0.4,
    MaxDuration = 1.2
}

local GenericDeathPose = {
    PhysParams = {
        ["ValveBiped.Bip01_Pelvis"] = {
            f = true,
            d = {2000, 12000},
            m = {0.05, 0.2}
        },
        ["ValveBiped.Bip01_Spine2"] = {
            f = true,
            d = {2000, 12000},
            rd = {1200, 2400},
            m = {0.05, 0.2}
        },
        ["ValveBiped.Bip01_Head1"] = {
            m = {0.02, 0.1},
            d = {300, 550}
        },
        ["ValveBiped.Bip01_L_Upperarm"] = {
            f = false,
            m = {0.05, 0.15},
            rd = {800, 1200}
        },
        ["ValveBiped.Bip01_L_Forearm"] = {
            f = false,
            m = {0.05, 0.15},
            rd = {800, 1200}
        },
        ["ValveBiped.Bip01_L_Hand"] = {
            f = false,
            m = {0.05, 0.15},
            rd = {800, 1200}
        },
        ["ValveBiped.Bip01_R_Upperarm"] = {
            f = false,
            m = {0.05, 0.15},
            rd = {800, 1200}
        },
        ["ValveBiped.Bip01_R_Forearm"] = {
            f = false,
            m = {0.05, 0.15},
            rd = {800, 1200}
        },
        ["ValveBiped.Bip01_R_Hand"] = {
            f = false,
            m = {0.05, 0.15},
            rd = {800, 1200}
        },
        ["ValveBiped.Bip01_L_Thigh"] = {
            f = false,
            d = {2000, 12000},
            m = {7, 13},
            rd = {20, 800}
        },
        ["ValveBiped.Bip01_L_Calf"] = {
            f = false,
            d = {2000, 12000},
            rd = {20, 800}
        },
        ["ValveBiped.Bip01_L_Foot"] = {
            f = false,
            d = {2000, 12000},
            m = {70, 130}
        },
        ["ValveBiped.Bip01_R_Thigh"] = {
            f = false,
            d = {2000, 12000},
            m = {7, 13},
            rd = {20, 800}
        },
        ["ValveBiped.Bip01_R_Calf"] = {
            f = false,
            d = {2000, 12000},
            rd = {20, 800}
        },
        ["ValveBiped.Bip01_R_Foot"] = {
            f = false,
            d = {2000, 12000},
            m = {70, 130}
        }
    },
    Probability = 0.7,
    MinDuration = 0.3,
    MaxDuration = 0.8
}

local function Val(x)
    if type(x) == "number" then
        return x
    else
        return math.Rand(x[1], x[2])
    end
end

local function StartDeathPose(ent, dp)
    if !IsValid(ent) then return end
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

            if CLIENT then return end -- unable to fix this due to physics being delayed :(

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

local function EndDeathPose(ent)
    if !IsValid(ent) then return end

    for id, tab in pairs(ent.OldPhysParams) do
        local phys = ent:GetPhysicsObjectNum(id)
        phys:SetDamping(tab[1], tab[2])
        phys:SetMass(tab[3])
    end
end

local function PlayDeathPose(ent, dp)
    if math.random() < dp.Probability then
        StartDeathPose(ent, dp)

        timer.Simple(math.Rand(dp.MinDuration, dp.MaxDuration), function()
            EndDeathPose(ent)
        end)
    end
end

if SERVER then
    util.AddNetworkString("TF_DeathNPC")

    hook.Add("ScaleNPCDamage", "TF_HeadshotNPC", function(npc, hitbox, dmginfo)
        npc.LastHitGroup = hitbox
        npc.LastInflictor = dmginfo:GetInflictor()
    end)

    hook.Add("CreateEntityRagdoll", "TF_DeathNPC", function(npc, ragdoll)
        if npc:IsNPC() then
            npc.RagdollEntity = ragdoll
            local head = ragdoll:LookupBone("ValveBiped.Bip01_Head1")
            if npc:Health() < 1 then
                if head and npc.DeathFlags == DF_DECAP then
                    PlayDeathPose(ragdoll, DecapDeathPose)
                    ragdoll:ManipulateBoneScale(head, Vector(0, 0, 0))
                    npc:EmitSound("player/flow.wav")
                    timer.Simple(0, function()
                        net.Start("TF_DeathNPC")
                        net.WriteEntity(npc)
                        net.WriteFloat(DF_DECAP)
                        net.WriteEntity(ragdoll)
                        net.Broadcast()
                    end)
                elseif npc.LastHitGroup == HITGROUP_HEAD and IsValid(npc.LastInflictor) and npc.LastInflictor:GetClass() == "tf_weapon_sniperrifle" and npc.LastInflictor.ZoomStatus then
                    PlayDeathPose(ragdoll, DecapDeathPose)
                end
            end
        end
    end)

    hook.Add("OnNPCKilled", "TFDecap", function(npc, attacker, inflictor)
        -- somehow this isn't called before death?
        -- will separate it into its own hook later...
        if inflictor.OnPlayerKilled then
            inflictor:OnPlayerKilled(npc)
        end

        if npc.DeathFlags and !GetConVar("ai_serverragdolls"):GetBool() then
            net.Start("TF_DeathNPC")
            net.WriteEntity(npc)
            net.WriteFloat(npc.DeathFlags)
            net.Broadcast()
        end
    end)
else
    hook.Add("CreateClientsideRagdoll", "TF_DeathNPC", function(npc, ragdoll)
        npc.RagdollEntity = ragdoll
    end)

    local function AddDecapFX(rag, headbone, npc)
        local eyes = rag:LookupAttachment("eyes") or 0
        ParticleEffectAttach("blood_decap", PATTACH_POINT_FOLLOW, rag, eyes)
        ParticleEffectAttach("blood_decap_arterial_spray", PATTACH_POINT_FOLLOW, rag, eyes)
        ParticleEffectAttach("blood_decap_fountain", PATTACH_POINT_FOLLOW, rag, eyes)
        ParticleEffectAttach("blood_decap_streaks", PATTACH_POINT_FOLLOW, rag, eyes)
        local head = ClientsideRagdoll(rag:GetModel())

        if rag:GetClass() == "prop_ragdoll" then
            for i = 1, rag:GetBoneCount() do
                local pon = head:TranslateBoneToPhysBone(i)

                if pon ~= -1 then
                    local phys = head:GetPhysicsObjectNum(pon)

                    if IsValid(phys) then
                        local pos, ang = rag:GetBonePosition(i)
                        local physh = head:GetPhysicsObjectNum(head:TranslateBoneToPhysBone(i))
                        physh:EnableMotion(false)
                        physh:SetVelocity(Vector(0, 0, 0))
                        physh:SetPos(pos, true)
                        physh:SetAngles(ang)

                        if i ~= headbone and i ~= head:LookupBone("ValveBiped.Bip01_Spine4") and i ~= head:LookupBone("ValveBiped.Bip01_Neck1") and i ~= head:LookupBone("ValveBiped.forward") then
                            timer.Simple(0.03, function()
                                physh:SetVelocity(rag:GetUp() * 550 + VectorRand() * 300)
                                physh:EnableMotion(true)
                            end)

                            physh:EnableCollisions(false)
                            physh:SetMass(0.0001)
                            physh:SetDamping(0.0001, 0.0001)
                        else
                            physh:EnableCollisions(true)
                            physh:EnableMotion(true)
                            physh:SetMass(physh:GetMass() * 3)
                        end
                    end
                end
            end
        else
            for i = 1, rag:GetBoneCount() do
                local pon = rag:TranslateBoneToPhysBone(i)

                if pon ~= -1 then
                    local phys = rag:GetPhysicsObjectNum(pon)

                    if IsValid(phys) then
                        phys:EnableMotion(false)
                        phys:SetVelocity(Vector(0, 0, 0))
                        phys:EnableMotion(true)
                        local physh = head:GetPhysicsObjectNum(head:TranslateBoneToPhysBone(i))
                        physh:SetPos(phys:GetPos(), true)
                        physh:SetAngles(phys:GetAngles())
                        physh:EnableMotion(false)
                        physh:SetVelocity(Vector(0, 0, 0))

                        if i ~= headbone then
                            timer.Simple(0, function()
                                physh:SetVelocity(rag:GetUp() * 550 + VectorRand() * 300)
                                physh:EnableMotion(true)
                            end)
                        else
                            physh:EnableCollisions(true)
                            physh:EnableMotion(true)
                            physh:SetMass(physh:GetMass() * 2)
                        end
                    end
                end
            end
        end

        head.OwnerRag = rag
        head.IsHead = true

        timer.Simple(35, function()
            if IsValid(head) then
                head:SetSaveValue("m_bFadingOut", true)

                if IsValid(head.IsHeadHide) then
                    head.IsHeadHide:SetSaveValue("m_bFadingOut", true)
                end
            end
        end)

        ParticleEffectAttach("blood_decap_streaks", PATTACH_POINT_FOLLOW, head, head:LookupAttachment("eyes") or 0)

        for i = 1, head:GetBoneCount() do
            if i ~= headbone then
                head:ManipulateBoneScale(i, Vector(0, 0, 0))
            end
        end

        rag:CallOnRemove("RemoveMyHead", function()
            if IsValid(head) then
                head:Remove()
            end
        end)
    end

    net.Receive("TF_DeathNPC", function()
        local npc = net.ReadEntity()
        if !IsValid(npc) then return end
        local flags = net.ReadFloat() or 0
        local rag = net.ReadEntity()

        timer.Simple(0.01, function()
            local ragdoll = npc.RagdollEntity or rag
            if !IsValid(ragdoll) then return end

            if flags == DF_DECAP then
                local head = ragdoll:LookupBone("ValveBiped.Bip01_Head1")

                if head then
                    if !IsValid(rag) then
                        PlayDeathPose(ragdoll, DecapDeathPose)
                        npc:EmitSound("player/flow.wav")
                        ragdoll:ManipulateBoneScale(head, Vector(0, 0, 0))
                    end

                    AddDecapFX(ragdoll, head, npc)
                end
            end
        end)
    end)

    -- this is really ugly, probably should go into a effect like before instead...
    hook.Add("PostDrawOpaqueRenderables", "TF_Decapitation", function()
        for _, head in pairs(ents.FindByClass("class C_ClientRagdoll")) do
            if head.IsHead then
                render.SetStencilWriteMask(0xFF)
                render.SetStencilTestMask(0xFF)
                render.SetStencilReferenceValue(0)
                render.SetStencilPassOperation(STENCIL_KEEP)
                render.SetStencilZFailOperation(STENCIL_KEEP)
                render.ClearStencil()
                render.SetStencilEnable(true)
                render.SetStencilReferenceValue(1)
                render.SetStencilCompareFunction(STENCIL_NEVER)
                render.SetStencilFailOperation(STENCIL_REPLACE)
                if !IsValid(head.IsHeadHide) then
                    head.IsHeadHide = ClientsideModel(head:GetModel())
                    head.IsHeadHide:SetNoDraw(true)
                    for i = 1, head.IsHeadHide:GetBoneCount() do
                        head.IsHeadHide:ManipulateBoneScale(i, Vector(0.04, 0.04, 0.04))
                    end

                    head.IsHeadHide:ManipulateBoneScale(head.IsHeadHide:LookupBone("ValveBiped.Bip01_Head1"), Vector(0, 0, 0))
                    head.IsHeadHide:ManipulateBoneScale(head.IsHeadHide:LookupBone("ValveBiped.Bip01_Neck1"), Vector(0, 0, 0))
                    head.IsHeadHide:ManipulateBoneScale(head.IsHeadHide:LookupBone("ValveBiped.Bip01_Spine4"), Vector(0, 0, 0))
                end
                head.IsHeadHide:DrawModel()
                head.IsHeadHide:SetParent(head)
                head.IsHeadHide:AddEffects(EF_BONEMERGE)
                render.SetStencilCompareFunction(STENCIL_NOTEQUAL)
                render.SetStencilFailOperation(STENCIL_KEEP)
                head:DrawModel()
                render.SetStencilEnable(false)

                if !IsValid(head.OwnerRag) then
                    if IsValid(head.IsHeadHide) then
                        head.IsHeadHide:Remove()
                    end

                    head:Remove()
                end
            end
        end
    end)
end