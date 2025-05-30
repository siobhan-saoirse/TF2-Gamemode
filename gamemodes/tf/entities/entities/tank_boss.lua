AddCSLuaFile()
PrecacheParticleSystem("explosionTrail_seeds_mvm")
PrecacheParticleSystem("fluidSmokeExpl_ring_mvm")
DEFINE_BASECLASS("base_nextbot")
ENT.Outputs = {
    ["OnBombDropped"] = "output"
}

ENT.Type = "nextbot"
ENT.Base = "base_nextbot"
ENT.PrintName = "Tank"
ENT.Spawnable = false
ENT.AutomaticFrameAdvance = true

local TANK_MODELS = {
    "models/bots/boss_bot/boss_tank.mdl",
    "models/bots/boss_bot/boss_tank_damage1.mdl",
    "models/bots/boss_bot/boss_tank_damage2.mdl",
    "models/bots/boss_bot/boss_tank_damage3.mdl"
}

local TRACK_MODEL_LEFT = "models/bots/boss_bot/tank_track_L.mdl"
local TRACK_MODEL_RIGHT = "models/bots/boss_bot/tank_track_R.mdl"
local TANK_HEALTH = 10000
local MOVE_SPEED = 75

local function CatmullRom(p0, p1, p2, p3, t)
    local t2 = t * t
    local t3 = t2 * t

    return 0.5 * (
        (2 * p1) +
        (-p0 + p2) * t +
        (2*p0 - 5*p1 + 4*p2 - p3) * t2 +
        (-p0 + 3*p1 - 3*p2 + p3) * t3
    )
end

function ENT:Initialize()
	if SERVER then
		self:SetModel(TANK_MODELS[1])
		self:SetSolid(SOLID_BBOX)
		self:SetMoveType(MOVETYPE_STEP)
		self:PhysicsInit(SOLID_VPHYSICS)

		self:SetHealth(TANK_HEALTH)
		self:SetMaxHealth(TANK_HEALTH)
		self:SetCollisionBounds(Vector(-100, -100, 0), Vector(100, 100, 180))
		self:SetBloodColor(BLOOD_COLOR_MECH)
		self.damageModelIndex = 1
		self.bombDeployed = false
		self.lastThink = CurTime()
		self:SetUseType(SIMPLE_USE)
		self:SetPlaybackRate(1)

		-- Find first path_track
		self.currentNode = self:FindFirstPathNode()
		if IsValid(self.currentNode) then
			self:SetPos(self.currentNode:GetPos())
		end

		self.totalDistance = self:CalculatePathLength()
		self.distanceTraveled = 0
		self.startPos = self:GetPos()

		self:EmitSoundEx("MVM.TankEngineLoop")
		self:NextThink(CurTime())
		self:ResetSequence("idle")
		timer.Create("TankPing"..self:EntIndex(), 5, 0, function()
			if (IsValid(self)) then
				self:EmitSoundEx("MVM.TankPing")
			end
		end)
		-- Track props
		self.leftTrack = ents.Create("prop_dynamic")
		self.leftTrack:SetModel(TRACK_MODEL_LEFT)
		self.leftTrack:SetPos(self:GetPos() + self:GetRight() * -56)
		self.leftTrack:SetAngles(self:GetAngles())
		self.leftTrack:SetParent(self)
		self.leftTrack:Spawn()
		self.leftTrack:ResetSequence("forward")

		self.rightTrack = ents.Create("prop_dynamic")
		self.rightTrack:SetModel(TRACK_MODEL_RIGHT)
		self.rightTrack:SetPos(self:GetPos() + self:GetRight() * 56)
		self.rightTrack:SetAngles(self:GetAngles())
		self.rightTrack:SetParent(self)
		self.rightTrack:Spawn()
		self.rightTrack:ResetSequence("forward")

		self.lastTrackUpdate = CurTime()
		self.lastPos = self:GetPos()
		self.rawPath = self:BuildRawPath()
		self.smoothPath = self:GenerateSmoothPath(self.rawPath, 8) -- 8 points per segment
		self.pathIndex = 1
		
		local tankCount = 0

		-- Find all entities with class name "tank_boss"
		for _, ent in ipairs(ents.FindByClass("tank_boss")) do
			tankCount = tankCount + 1
		end

		if tankCount > 1 then

			umsg.Start("TF_PlayGlobalSound")
				umsg.String("Announcer.MVM_Tank_Alert_Multiple")
			umsg.End() 
			umsg.Start("TF_PlayGlobalSound")
				umsg.String("MVM.TankStart")
			umsg.End() 
		else
			umsg.Start("TF_PlayGlobalSound")
				umsg.String("Announcer.MVM_Tank_Alert_Spawn")
			umsg.End() 
			umsg.Start("TF_PlayGlobalSound")
				umsg.String("MVM.TankStart")
			umsg.End() 
		end
	end
end
function ENT:BuildRawPath()
    local nodes = {}
    local node = self:FindFirstPathNode()
    while IsValid(node) do
        table.insert(nodes, node:GetPos())
        node = node:GetInternalVariable("m_pNext")
    end
    return nodes
end

function ENT:GenerateSmoothPath(points, resolution)
    local result = {}

    for i = 2, #points - 2 do
        for t = 0, 1, 1 / resolution do
            local p = CatmullRom(points[i-1], points[i], points[i+1], points[i+2], t)
            table.insert(result, p)
        end
    end

    -- Add final point
    if points[#points] then
        table.insert(result, points[#points])
    end

    return result
end
function ENT:UpdateTrackAnimations(dt)
    local speed = self:GetPos():Distance(self.lastPos) / dt
    local maxSpeed = 150 -- Tune this as needed
    local playbackRate = math.Clamp(speed / maxSpeed, 0.1, 1.5)

    if IsValid(self.leftTrack) then
        self.leftTrack:SetPlaybackRate(playbackRate)
    end
    if IsValid(self.rightTrack) then
        self.rightTrack:SetPlaybackRate(playbackRate)
    end

    self.lastPos = self:GetPos()
end

function ENT:FindFirstPathNode()
    local first = ents.FindByClass("path_track")[1]
    while IsValid(first:GetInternalVariable("m_pPrevious")) do
        first = first:GetInternalVariable("m_pPrevious")
    end
    return first
end

function ENT:GetNextPathNode()
    return IsValid(self.currentNode) and self.currentNode:GetInternalVariable("m_pNext") or nil
end

function ENT:CalculatePathLength()
    local total = 0
    local node = self:FindFirstPathNode()
    while IsValid(node) do
        local next = node:GetInternalVariable("m_pNext")
        if not IsValid(next) then break end
        total = total + node:GetPos():Distance(next:GetPos())
        node = next
    end
    return total
end

function ENT:Think()
	if SERVER then
		local now = CurTime()
		local delta = now - (self.lastThink or now)
		self.lastThink = now

		self:UpdateModelByHealth()
		self:UpdateProgressAlerts()

		if self.bombDeployed then return end

		local path = self.smoothPath
		local target = path[self.pathIndex]

		if not target then
			self:DeployBomb()
			return
		end

		local dir = (target - self:GetPos())
		dir.z = 0
		local dist = dir:Length()

		if dist < 10 then
			self.pathIndex = self.pathIndex + 1
		else
			local step = dir:GetNormalized() * MOVE_SPEED * delta
			self:SetPos(self:GetPos() + step)
			self:SetAngles(step:Angle() )
		end

		self:UpdateTrackAnimations(delta)
		

		for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 100)) do
			if (ent:EntIndex() == self:GetNextPathNode():EntIndex()) then
				ent:Fire("InPass")
			end
		end
		for _, ent in ipairs(ents.FindInSphere(self:GetPos(), 100)) do
			if ent:IsPlayer() or ent:GetClass():find("npc") then
				local dmg = DamageInfo()
				dmg:SetAttacker(self)
				dmg:SetInflictor(self)
				dmg:SetDamage(9999999)
				dmg:SetDamageType(DMG_CRUSH)
				ent:TakeDamageInfo(dmg)
			end
		end
	end
	self:NextThink(CurTime())
	return true
end

function ENT:UpdateModelByHealth()
    local health = self:Health()
    local perModel = self:GetMaxHealth() / #TANK_MODELS
    local index = math.Clamp(#TANK_MODELS - math.floor(health / perModel), 1, #TANK_MODELS)
    if index ~= self.damageModelIndex then
        self.damageModelIndex = index
        self:SetModel(TANK_MODELS[index])
    end
end

function ENT:UpdateProgressAlerts()
    if not self.totalDistance then return end
    local progress = self:GetPos():Distance(self.startPos) / self.totalDistance
    if not self.halfwayAlerted and progress > 0.5 then
        self.halfwayAlerted = true
        print("[TANK] Halfway to goal!")
		local tankCount = 0

		-- Find all entities with class name "tank_boss"
		for _, ent in ipairs(ents.FindByClass("tank_boss")) do
			tankCount = tankCount + 1
		end

		if tankCount > 1 then
			umsg.Start("TF_PlayGlobalSound")
				umsg.String("Announcer.MVM_Tank_Alert_Halfway_Multiple")
			umsg.End() 
		else
			umsg.Start("TF_PlayGlobalSound")
				umsg.String("Announcer.MVM_Tank_Alert_Halfway")
			umsg.End() 
		end
    elseif not self.nearGoalAlerted and progress > 0.75 then
        self.nearGoalAlerted = true
        print("[TANK] Near the goal!")
        umsg.Start("TF_PlayGlobalSound")
			umsg.String("Announcer.MVM_Tank_Alert_Near_Hatch")
		umsg.End() 
    end
end

function ENT:DeployBomb()
    self.bombDeployed = true
        umsg.Start("TF_PlayGlobalSound")
			umsg.String("Announcer.MVM_Tank_Alert_Deploying")
		umsg.End() 
	self:EmitSound("MVM.TankDeploy")
	self:SetSequence("deploy")
	self:SetCycle(0)
	self:ResetSequenceInfo()


    timer.Simple(self:SequenceDuration("deploy"), function()
        if IsValid(self) then 
			self:ExplodeEffect() 
			self:Remove()
			GAMEMODE:RoundWin(3)
		end
		self:TriggerOutput("OnBombDropped")
    end)
end

function ENT:ExplodeEffect()
    local pos = self:GetPos()
    ParticleEffect("explosionTrail_seeds_mvm", pos, Angle(0, 0, 0), self)
    ParticleEffect("fluidSmokeExpl_ring_mvm", pos, Angle(0, 0, 0), self)
    util.ScreenShake(pos, 25, 5, 5, 1000)
	self:EmitSound("MVM.TankExplodes")

    for _, ent in ipairs(ents.FindInSphere(pos, 400)) do
        if ent:IsPlayer() or ent:GetClass():find("npc") then
            local dmg = DamageInfo()
            dmg:SetAttacker(self)
            dmg:SetInflictor(self)
            dmg:SetDamage(200)
            dmg:SetDamageType(DMG_BLAST)
            ent:TakeDamageInfo(dmg)
        end
    end
end

function ENT:OnInjured(dmginfo)
	self:EmitSound("MVM_Tank.BulletImpact")
    if self:Health() <= 0 then
        self:ExplodeEffect()
        umsg.Start("TF_PlayGlobalSound")
			umsg.String("Announcer.Announcer.MVM_General_Destruction")
		umsg.End() 
        umsg.Start("TF_PlayGlobalSound")
			umsg.String("MVM.TankEnd")
		umsg.End() 
        self:Remove()
    end
end
function ENT:OnRemove()
	self:StopSound("MVM.TankEngineLoop")
end

-- Console Commands
concommand.Add("tank_kill", function(ply)
    for _, ent in ipairs(ents.FindByClass("tank_boss")) do
        local dmg = DamageInfo()
        dmg:SetAttacker(ply or ent)
        dmg:SetDamage(99999)
        dmg:SetDamageType(DMG_CRUSH)
        ent:TakeDamageInfo(dmg)
    end
end)

concommand.Add("tank_set_health", function(ply, cmd, args)
    local val = tonumber(args[1]) or TANK_HEALTH
    for _, ent in ipairs(ents.FindByClass("tank_boss")) do
        ent:SetMaxHealth(val)
        ent:SetHealth(val)
    end
end)


list.Set( "NPC", "tank_boss", {
	Name = "Tank",
	Class = "tank_boss",
	Category = "TFBots: MVM",
	AdminOnly = true
})

function ENT:AcceptInput(inputName, activator, caller)
    if inputName == "KillTank" then
        self:TakeDamage(99999, activator or self, self)
        return true
    elseif inputName == "SetHealth" and IsValid(activator) then
        local val = tonumber(activator:GetName())
        if val then self:SetHealth(val) end
        return true
    end
    return false
end

function ENT:TriggerOutput(outputName)
    if self.Outputs[outputName] then
        self:Fire(outputName, "", 0)
    end
end