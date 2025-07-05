AddCSLuaFile()

SWEP.Base = "tf_weapon_base"
SWEP.PrintName = "Invisibility Watch"
SWEP.Author = "Valve"
SWEP.Category = "Team Fortress 2"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.ViewModel = ""
SWEP.WorldModel = ""
SWEP.UseHands = false
SWEP.HoldType = "normal"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"

SWEP.Secondary = SWEP.Primary

-- Cloak stats (defaults)
SWEP.CloakMeter = 100
SWEP.IsStealthed = false
SWEP.FeignDeathReady = false
SWEP.NextStealthTime = 0

-- Rates
local cloak_consume_rate = GetConVar("tf_spy_cloak_consume_rate") or CreateConVar("tf_spy_cloak_consume_rate", "8")
local cloak_regen_rate   = GetConVar("tf_spy_cloak_regen_rate") or CreateConVar("tf_spy_cloak_regen_rate", "2")

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:Deploy()
    self:SetNextPrimaryFire(CurTime() + 1.5)
    return true
end

function SWEP:Holster()
    self:SetNextPrimaryFire(CurTime() + 10)
    return true
end

function SWEP:PrimaryAttack()
    -- Do nothing
end

function SWEP:SecondaryAttack()
    -- Do nothing
end

function SWEP:OnRemove()
    self:CleanupInvisibilityWatch()
end

function SWEP:OwnerChanged()
    self:CleanupInvisibilityWatch()
end

function SWEP:CleanupInvisibilityWatch()
    self.FeignDeathReady = false
    if self.IsStealthed then
        self:FadeInvis(1.0)
    end

    local owner = self:GetOwner()
    if IsValid(owner) and owner:GetNWEntity("TF_OffhandWeapon") == self then
        owner:SetNWEntity("TF_OffhandWeapon", nil)
    end
end

function SWEP:ActivateInvisibilityWatch()
    local owner = self:GetOwner()
    if not IsValid(owner) then return false end

    self:SetCloakRates()
    local bDoSkill = false

    if self.IsStealthed then
        self:FadeInvis(1.0)
    else
        if self:HasFeignDeath() then
            if self.FeignDeathReady then
                self:SetFeignDeathState(false)
            elseif self.CloakMeter >= 100 then
                self:SetFeignDeathState(true)
            end
        elseif self.CloakMeter > 8 then
            self.IsStealthed = true
            self:SetInvisibility(true)
            bDoSkill = true
        end
    end

    self.NextStealthTime = CurTime() + (bDoSkill and 0.5 or 0.1)
    return bDoSkill
end

function SWEP:SetFeignDeathState(enabled)
    local owner = self:GetOwner()
    if not IsValid(owner) then return end

    if enabled then
        self.FeignDeathReady = true
        owner:SetNWEntity("TF_OffhandWeapon", self)
        self.NextStealthTime = CurTime() + 0.5
    else
        self.FeignDeathReady = false
        if not self.IsStealthed then
            if owner:GetNWEntity("TF_OffhandWeapon") == self then
                owner:SetNWEntity("TF_OffhandWeapon", nil)
            end

            local wep = owner:GetActiveWeapon()
            if IsValid(wep) then
                wep:SetNextPrimaryFire(CurTime() + 0.1)
            end
        end
    end
end

function SWEP:SetCloakRates()
    local consume = cloak_consume_rate:GetFloat()
    local regen = cloak_regen_rate:GetFloat()

    -- Attributes can be applied here if needed (e.g., from item system)
    self.CloakConsumeRate = consume
    self.CloakRegenRate = regen
end

function SWEP:FadeInvis(duration)
    self.IsStealthed = false
    -- TODO: play uncloak effect, maybe notify player
end

function SWEP:HasFeignDeath()
    return self:GetClass() == "tf_weapon_invis_deadringer"
end

function SWEP:Think()
    if not IsValid(self:GetOwner()) then return end

    -- Handle cloak drain/regeneration
    local rate = self.IsStealthed and -self.CloakConsumeRate or self.CloakRegenRate
    self.CloakMeter = math.Clamp(self.CloakMeter + rate * FrameTime(), 0, 100)

    -- Auto uncloak when meter runs out
    if self.IsStealthed and self.CloakMeter <= 0 then
        self:FadeInvis(1.0)
    end
end

function SWEP:GetViewModel()
    local owner = self:GetOwner()
    if not IsValid(owner) then return "" end

    -- Optional: return a viewmodel path based on the player model
    return ""
end

function SWEP:GetControlPanelName()
    local vm = self:GetViewModel()
    if string.find(vm, "pocket") then
        return "pda_panel_spy_invis_pocket"
    elseif string.find(vm, "ttg_watch_spy") then
        return "pda_panel_spy_invis_pocket_ttg"
    elseif string.find(vm, "hm_watch") then
        return "pda_panel_spy_invis_pocket_hm"
    end
    return "pda_panel_spy_invis"
end

function SWEP:FadeInvis(duration)
    self.IsStealthed = false
    self:SetInvisibility(false)
end

function SWEP:SetInvisibility(state)
    local ply = self:GetOwner()
    if not IsValid(ply) then return end

    if state then
        ply:AddEffects(EF_NODRAW)
        local vm = ply:GetViewModel()
        if IsValid(vm) then vm:AddEffects(EF_NODRAW) end
    else
        ply:RemoveEffects(EF_NODRAW)
        local vm = ply:GetViewModel()
        if IsValid(vm) then vm:RemoveEffects(EF_NODRAW) end
    end
end
