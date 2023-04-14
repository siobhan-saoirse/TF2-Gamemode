AddCSLuaFile()

ENT.Type = "anim"  
ENT.Base = "item_base"    

ENT.Model = "models/flag/briefcase.mdl"

local FlagReturnTime = 60

if SERVER then

hook.Add("DoPlayerDeath", "IntelSafeHelp", function(ply)
	for _,v in pairs(ents.FindByClass("item_teamflag")) do
		if v.Carrier==ply then
			v:Drop() 
		end 
	end
end)

concommand.Add("drop_flag", function(pl)
	for _,v in pairs(ents.FindByClass("item_teamflag")) do
		if v.Carrier==pl then
			v:Drop()
		end
	end
end)
 
function ENT:Initialize()
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:DrawShadow(false)
	--self:SetNoDraw(true)
	
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetTrigger(true)
	
	self.Prop = ents.Create("prop_dynamic")
	self.Prop:SetMoveType(MOVETYPE_NONE)
	self.Prop:SetSolid(SOLID_NONE)
	if game.GetMap() == "mvm_terroristmission_v7_1" then
		self.Prop:SetModel("models/weapons/w_c4_planted.mdl")
	else
		self.Prop:SetModel(self.Model)
	end
	self.Prop:SetPos(self:GetPos())
	self.Prop:SetAngles(self:GetAngles())
	self.Prop:Spawn()

	self:SetNWEntity("prop", self.Prop)
	
	self.Prop:SetParent(self)
	
	local sequence = self.Prop:LookupSequence("spin")
	self.Prop:ResetSequence(sequence)
	self.Prop:SetPlaybackRate(1)
	self.Prop:SetCycle(1)
	
	if self.TeamNum==0 then
		self:SetSkin(2)
		self.Prop:SetSkin(2)
	elseif self.TeamNum==TEAM_RED then
		self:SetSkin(0)
		self.Prop:SetSkin(0)
	elseif self.TeamNum==TEAM_BLU then
		self:SetSkin(1)
		self.Prop:SetSkin(1)
	end
	
	self.State = 0
	
	
	self.Trail = ents.Create("info_particle_system")
	self.Trail:SetPos(self:GetPos())
	self.Trail:SetAngles(self:GetAngles())
	self.Trail:SetKeyValue("effect_name", "player_intel_trail_"..ParticleSuffix(self.TeamNum))
	self.Trail:Spawn()
	self.Trail:SetParent(self)
	
	self.PickupLock = {}
	--[[
	timer.Simple(0.1, function()
		if (string.find(game.GetMap(),"mvm_")) then
		
			local ent = ents.Create( "item_teamflag_mvm" )
			ent:SetPos( self:GetPos() )
			ent.TeamNum = TEAM_RED
			ent:Spawn()
			ent:Activate()
			timer.Simple(0.1, function()
				self:Remove()
			end)

		end
	end)]]
	--[[
	0 : home
	1 : carried
	2 : dropped
	]]
	
	--effectdata = EffectData()
	--	effectdata:SetEntity(self)
	--util.Effect("tf_flagtimer", effectdata)
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	
	if key=="gametype" then
		self.GameType = tonumber(value)
	elseif key=="teamnum" then
		self.te = tonumber(value)
		local t = tonumber(value)
		
		if t==0 then
			self.TeamNum = 0
		elseif t==2 then
			self.TeamNum = TEAM_RED
		elseif t==3 then
			self.TeamNum = TEAM_BLU
		end
	end
end

function ENT:Think()
	self:SetNWEntity("carrier", self.Carrier)

	for k, v in pairs(player.GetAll()) do
				local trace = util.QuickTrace(self:GetPos(), v:EyePos() - self:GetPos(), self.Prop)
		if self:GetSkin() == 1 and v:IsBot() and !v:IsHL2() then
			local color = Color(255, 0, 0)
			if trace.Entity == v then
				color = Color(0, 255, 255)
			end
			debugoverlay.Line(trace.StartPos, trace.HitPos, 1.1, color, true)
			--print(trace.Entity)
		end

		if v:GetPos():Distance(self:GetPos()) <= 80 and self:CanPickup(v) and util.QuickTrace(self:GetPos(), v:EyePos() - self:GetPos(), self.Prop).Entity == v then
			self:PlayerTouched(v)
		end

		--print(self.PickupLock[v])

		if v:GetPos():Distance(self:GetPos()) >= 80 and self.PickupLock[v] then
			self.PickupLock[v] = nil
		end
	end

	if self.NextReturn then
		if not self.NextClientUpdateTimer or CurTime()>self.NextClientUpdateTimer then
			self:SetNWFloat("TimeRemaining", self.NextReturn - CurTime())
			self.NextClientUpdateTimer = CurTime() + 0.5
		end
		
		if CurTime()>self.NextReturn then
			self:Return()
		end
	else
		self.NextClientUpdateTimer = nil
	end
	
	if IsValid(self.Carrier) and isstring(self.Carrier.Team) and (self.Carrier.Team == "RED" or self.Carrier.Team == "BLU" ) then
		local intel = nil
		local fintel = nil
		local intelcap = nil
		local fintelcap = nil
		if self.Carrier:Health() <= 1 then
			self:Drop()
		elseif !IsValid(self.Carrier) then
			self:Drop()
		end
		if self.Carrier:Health() >= 1 then
			for k, v in pairs(ents.FindByClass("item_teamflag")) do
				if v.TeamNum ~= GAMEMODE:EntityTeam(self.Carrier) then
					intel = v
				else
					fintel = v
				end
			end
	
			for k, v in pairs(ents.FindByClass("func_capturezone")) do
				if v.TeamNum ~= GAMEMODE:EntityTeam(self.Carrier) then
					intelcap = v
				else
					fintelcap = v
				end
			end

			self.Carrier:RunToPos(fintel:GetPos(), {tolerance = 60}	)
		end
	end

end

function ENT:CanPickup(ply)
	return ply:Team()~=self.TeamNum or GAMEMODE:EntityTeam(ply)~=self.TeamNum and not self.PickupLock[v]
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() and self:CanPickup(ent) and not self.PickupLock[ent] then
		self:PlayerTouched(ent)
	end 
	if isstring(ent.Team) and (ent.Team == "RED" or ent.Team == "BLU" ) then
		if ent.Team == "BLU" and self.TeamNum == TEAM_RED then
			self:PlayerTouched(ent)
		elseif ent.Team == "RED" and self.TeamNum == TEAM_BLU then
			self:PlayerTouched(ent)
		end
	end
end

function ENT:EndTouch(ent)
	if self.PickupLock[ent] then
		self.PickupLock[ent] = nil
	end
end

function ENT:PlayerTouched(pl)
	self:Pickup(pl)
end

function ENT:Capture()
	self:Return(true)
	if IsValid(self.Carrier) then
		self:TriggerOutput("OnCapture", self.Carrier)
	end
end

function ENT:Return(nosound)
	if self.State~=0 then
		self:Drop(true)
		self.State = 0
		self:SetNWBool("TimerActive", false)
		self.NextReturn = nil
		self:SetPos(self.HomePosition)
		self:SetAngles(self.HomeAngles)
		print(self.HomePosition)
		self:TriggerOutput("OnReturn")

		if nosound then
			return
		end

		for _, ply in pairs(player.GetAll()) do
			if ply:Team() ~= self.TeamNum then
				ply:SendLua([[surface.PlaySound("vo/intel_teamreturned.wav")]])
			else
				ply:SendLua([[surface.PlaySound("vo/intel_enemyreturned.wav")]])
			end
		end
	end
end

function ENT:Pickup(ply)
	if self.State~=1 and not IsValid(self.Carrier) then
		if not self.HomePosition or not self.HomeAngles then
			self.HomePosition = self:GetPos()
			self.HomeAngles = self:GetAngles()
		end
		
		self:SetNWBool("TimerActive", false)
		self.NextReturn = nil
		
		self.State = 1
		self.Trail:Fire("Start")
		self.Carrier = ply
		self.Prop:ResetSequence(self.Prop:LookupSequence("idle"))
		self.Prop:SetPlaybackRate(1)
		self.Prop:SetCycle(1)
		self:SetNotSolid(true)
		self:SetTrigger(false)
		self:SetParent(ply)
		ply:Speak("TLK_FLAGPICKUP")
		self:Fire("SetParentAttachment", "flag", 0)
		if ply:IsPlayer() and ply:IsHL2() then
			self:Fire("SetParentAttachment", "chest", 0)
		end
		self:TriggerOutput("OnPickup", ply)

		for _, ply in pairs(player.GetAll()) do
			if ply:Team() ~= self.TeamNum then
				ply:SendLua([[surface.PlaySound("vo/intel_teamstolen.wav")]])
			else
				ply:SendLua([[surface.PlaySound("vo/intel_enemystolen.wav")]])
			end
		end
	end
end

function ENT:Drop(nosound)
	if self.State==1 and IsValid(self.Carrier) then
		self:SetNWBool("TimerActive", true)
		self:SetNWFloat("TimeRemaining", FlagReturnTime)
		self.NextReturn = CurTime() + FlagReturnTime
		
		local ply = self.Carrier
		self.PickupLock[ply] = 1 -- Prevent the player who dropped it to pick it up immediately again
		self.State = 2
		self.Trail:Fire("Stop")
		self.Carrier = nil
		self.Prop:ResetSequence(self.Prop:LookupSequence("spin"))
		self.Prop:SetPlaybackRate(1)
		self.Prop:SetCycle(1)
		self:SetNotSolid(false)
		self:SetTrigger(true)
		self:SetParent()
		self:SetAngles(Angle(0, self:GetAngles().y, 0))
		self:DropToFloor()
		self:TriggerOutput("OnDrop", ply)

		if nosound then
			return
		end

		for _, ply in pairs(player.GetAll()) do
			if ply:Team() ~= self.TeamNum then
				ply:SendLua([[surface.PlaySound("vo/intel_teamdropped.wav")]])
			else
				ply:SendLua([[surface.PlaySound("vo/intel_enemydropped.wav")]])
			end
		end
	end
end

function ENT:AcceptInput(name, activator, caller, value)
	name = string.lower(name)
	if name=="skin" then
		self:SetSkin(tonumber(value) or 0)
	elseif name=="setteam" then
		local t = tonumber(value)
		
		if t==0 then
			self.TeamNum = 0
			self:SetSkin(2)
			self.Prop:SetSkin(2)
		elseif t==2 then
			self.TeamNum = TEAM_RED
			self:SetSkin(0)
			self.Prop:SetSkin(0)
		elseif t==3 then
			self.TeamNum = TEAM_BLU
			self:SetSkin(1)
			self.Prop:SetSkin(1)
		end
	end
end

end

if CLIENT then

ENT.RenderGroup = RENDERGROUP_BOTH

local colors = {
	[0]=Color(255,0,0,255),
	[1]=Color(0,0,255,255),
	[2]=Color(255,255,255,255),
}

function ENT:Initialize()
	self.Progress = vgui.Create("CircularProgressBar")
	self.Progress:SetSize(128, 128)
	self.Progress:SetBackgroundTexture("vgui/flagtime_empty")
	self.Progress:SetForegroundTexture("vgui/flagtime_full")
	self.Progress:SetProgress(0)
	self.Progress:SetCentered(true)
	self.Progress:SetVisible(false)
	
	local min, max = self:GetRenderBounds()
	max.z = max.z + 100
	self:SetRenderBounds(min, max)
end

function ENT:Draw()
	if IsValid(self:GetNWEntity("prop", self)) and IsValid(self:GetParent()) then
		if self:GetParent() == LocalPlayer() and !LocalPlayer():ShouldDrawLocalPlayer() then
			self:GetNWEntity("prop", self):SetNoDraw(true) -- true)
		else
			self:GetNWEntity("prop", self):SetNoDraw(false)
		end

		if self:GetParent():IsHL2() and self:GetParent():LookupAttachment("chest") > 0 then
			local att = self:GetParent():GetAttachment(self:GetParent():LookupAttachment("chest"))
			local ang = att.Ang
			local pos = att.Pos
			local pos2, ang2 = LocalToWorld(ang:Forward() * 10, Angle(90, 0, 180), pos, ang)
			self:GetNWEntity("prop", self):SetAngles(ang2)
			self:GetNWEntity("prop", self):SetPos(pos - ang:Forward() * 10)
			--self:Fire("SetParentAttachment", "chest", 0)
		end
	end

	if not self:GetNWBool("TimerActive") then return end
	
	local s = self:GetSkin()
	if self.OldSkin~=s then
		self.Progress:SetBackgroundColor(colors[s])
		self.Progress:SetForegroundColor(colors[s])
		self.OldSkin = s
	end
	
	local ang = EyeAngles()
	ang:RotateAroundAxis(ang:Right(), 90)
	ang:RotateAroundAxis(ang:Up(), -90)
	
	local W,H = ScrW(), ScrH()
	
	cam.Start3D2D(self:GetPos()+Vector(0,0,70), ang, 0.3)
		self.Progress:Paint()
	cam.End3D2D()
end

function ENT:Think()
	if self:GetNWBool("TimerActive") then
		if not self.NextReturn or self.OldTimeRemaining~=self:GetNWFloat("TimeRemaining") then
			self.OldTimeRemaining = self:GetNWFloat("TimeRemaining")
			self.NextReturn = CurTime() + self.OldTimeRemaining
		end
	end
	
	if self.NextReturn then
		self.Progress:SetProgress((self.NextReturn - CurTime())/FlagReturnTime)
	end
	
	self:NextThink(CurTime())
end

end