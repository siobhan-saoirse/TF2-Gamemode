AddCSLuaFile()
ENT.PrintName		= "Bomb"
ENT.Information		= "A Bomb."
ENT.Category		= "Team Fortress 2"

ENT.Spawnable			= true
ENT.AdminSpawnable		= true
ENT.Type = "anim"  
ENT.Base = "item_base"    

ENT.Model = "models/flag/briefcase.mdl"
ENT.Model2 = "models/props_td/atom_bomb.mdl"

game.AddParticles( "particles/mvm.pcf" )
PrecacheParticleSystem( "mvm_levelup1" )
PrecacheParticleSystem( "mvm_levelup2" )
PrecacheParticleSystem( "mvm_levelup3" )  

local FlagReturnTime = 60

if SERVER then

hook.Add("DoPlayerDeath", "IntelSafeHelp2", function(ply)
	for _,v in pairs(ents.FindByClass("item_teamflag_mvm")) do
		if v.Carrier==ply then
			v:Drop()
		end
	end
end)

concommand.Add("drop_flag_mvm", function(pl)
	for _,v in pairs(ents.FindByClass("item_teamflag_mvm")) do
		if v.Carrier==pl then
			v:Drop()
		end
	end
end)


function ENT:SpawnFunction( ply, tr, ClassName )

	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 16

	local ent = ents.Create( "item_teamflag_mvm" )
	ent:SetPos( SpawnPos )
	ent.TeamNum = TEAM_RED
	ent:Spawn()
	ent:Activate()

	return ent

end

function ENT:Initialize()
	self:SetSolid(SOLID_VPHYSICS)
	self:SetModel(self.Model)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_NONE)
	self:DrawShadow(false)
	--self:SetNoDraw(true)
	
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetTrigger(true)
	self:SetNoDraw(true)
	
	self.Prop = ents.Create("prop_dynamic")
	self.Prop:SetMoveType(MOVETYPE_NONE)
	self.Prop:SetSolid(SOLID_NONE)
	self.Prop:SetModel(self.Model)
	self.Prop:SetPos(self:GetPos())
	self.Prop:SetAngles(self:GetAngles())
	self.Prop:Spawn()
	self.Prop:SetNoDraw(true)	
	

	self.Prop2 = ents.Create("prop_dynamic")
	self.Prop2:SetMoveType(MOVETYPE_NONE)
	self.Prop2:SetSolid(SOLID_NONE)
	self.Prop2:SetModel("models/props_td/atom_bomb.mdl")
	self.Prop2:SetPos(self:GetPos())
	self.Prop2:SetAngles(self:GetAngles())
	self.Prop2:Spawn()
	self.Prop2:SetParent(self.Prop)
	ParticleEffectAttach( "cart_flashinglight", PATTACH_POINT_FOLLOW, self.Prop2, self.Prop2:LookupAttachment("siren") )
	self:SetNWEntity("prop2", self.Prop2)
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
		if (self.PickupLock) then
			if v:GetPos():Distance(self:GetPos()) >= 80 and self.PickupLock[v] then
				self.PickupLock[v] = nil
			end
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
end

function ENT:CanPickup(ply)
	return ply:Team()~=self.TeamNum and not self.PickupLock[v]
end

function ENT:StartTouch(ent)
	if ent:IsPlayer() and self:CanPickup(ent) and not self.PickupLock[ent] then
		self:PlayerTouched(ent)
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
	self.Prop2:SetNoDraw(false)
	self.Prop2:SetNoDraw(true)
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

		--ParticleEffectAttach( "cart_flashinglight", PATTACH_POINT_FOLLOW, self.Prop2, self.Prop2:LookupAttachment("siren") )
		if nosound then
			return
		end

		for _, ply in pairs(player.GetAll()) do
			ply:SendLua([[LocalPlayer():EmitSound("MVM.AttackDefend.EnemyReturned")]])
		end
	end
end

function ENT:Pickup(ply)
	if self.State~=1 and not IsValid(self.Carrier) then
		if not self.HomePosition or not self.HomeAngles then
			self.HomePosition = self:GetPos()
			self.HomeAngles = self:GetAngles()
		end
		self.isCarryingIntel = true
		
		self:SetNWBool("TimerActive", false)
		self.NextReturn = nil
	
		for _,capturezone in ipairs(ents.FindByClass("func_capturezone")) do
			ply.botPos = capturezone.Pos
		end
		self.State = 1
		self.Carrier = ply
		self.Prop:ResetSequence(self.Prop:LookupSequence("idle"))
		self.Prop:SetPlaybackRate(1)
		self.Prop:SetCycle(1)
		self:SetNotSolid(true)
		self:SetTrigger(false)
		self:SetParent(ply)
		self:Fire("SetParentAttachment", "flag", 0)
		if ply:IsHL2() then
			self:Fire("SetParentAttachment", "chest", 0)
		end
		self:TriggerOutput("OnPickup", ply)

		for _, ply in pairs(player.GetAll()) do
			if ply:Team() == self.TeamNum then
				ply:Speak("TLK_MVM_BOMB_PICKUP") 
			end
		end  
	
		timer.Create("DropIfCarrierNotAlive", 0.001, 0, function()
			if ply:Alive() then
				if !string.find(ply:GetModel(),"_boss.mdl") then
					ply:SetClassSpeed(ply:GetPlayerClassTable().Speed * 0.5)		
				end  
				if ply:HasGodMode() then
					self.Prop2:SetMaterial("models/effects/invulnfx_blue")
				else
					self.Prop2:SetMaterial("")
				end
			end
	
			if not ply:Alive() then
				ply:Freeze(false)
				ply:SetNoDraw(false)
				self:SetNoDraw(false)
				timer.Stop("Warning1")
				timer.Stop("Warning2")
				timer.Stop("Warning3")
				timer.Stop("WarningEnd1")
				timer.Stop("WarningEnd2")
				timer.Stop("WarningEnd3")
				timer.Stop("CarrierGetsHealed") 
				timer.Stop("CarrierGetsResistance") 
				for k,v in pairs(player.GetAll()) do 
					if not ply:IsFriendly(v) then
						v:Speak("TLK_MVM_BOMB_DROPPED")
					end
				end
				self:Drop()
				self.Carrier = nil
				timer.Stop("DropIfCarrierNotAlive")
			end
		end)
		timer.Create("Warning1", 10, 1, function()
			ParticleEffectAttach( "mvm_levelup1", PATTACH_POINT_FOLLOW, ply, ply:LookupAttachment("head") )
			ply:EmitSound("mvm/mvm_warning.wav", 0, 100)
			if (!ply:IsMiniBoss()) then
				ply:TFTaunt(tostring(ply:GetActiveWeapon():GetSlot() + 1))
			end
			timer.Create("CarrierGetsHealed", 5.0, 0, function()
				--ply:SetArmor( 50 )
			end)
		
		end)
		
		timer.Create("Warning2", 45, 1, function()
			ParticleEffectAttach( "mvm_levelup2", PATTACH_POINT_FOLLOW, ply, ply:LookupAttachment("head") )
			ply:EmitSound("mvm/mvm_warning.wav", 0, 100)
			if (!ply:IsMiniBoss()) then
				ply:TFTaunt(tostring(ply:GetActiveWeapon():GetSlot() + 1))
			end
			timer.Create("CarrierGetsResistance", 2, 0, function()
				GAMEMODE:HealPlayer(self.Carrier, self.Carrier, 5, true, false) 
			end)
			for k,v in pairs(player.GetAll()) do
				if not v:IsFriendly(ply) then
					if v:GetPlayerClass() == "heavy" then
						v:EmitSound("vo/heavy_mvm_bomb_upgrade0"..math.random(1,2)..".wav", 80, 100, 1, CHAN_VOICE)
					elseif v:GetPlayerClass() == "soldier" then
						v:EmitSound("vo/soldier_mvm_bomb_upgrade0"..math.random(1,3)..".wav", 80, 100, 1, CHAN_VOICE)
					elseif v:GetPlayerClass() == "medic" then 
						v:EmitSound("vo/medic_mvm_bomb_upgrade0"..math.random(1,3)..".wav", 80, 100, 1, CHAN_VOICE)
					elseif v:GetPlayerClass() == "engineer" then
						v:EmitSound("vo/engineer_mvm_bomb_upgrade0"..math.random(1,3)..".wav", 80, 100, 1, CHAN_VOICE)
					end
				end
			end
		end)
		timer.Create("Warning3", 65, 1, function()
			ParticleEffectAttach( "mvm_levelup3", PATTACH_POINT_FOLLOW, ply, ply:LookupAttachment("head") )
			ply:EmitSound("mvm/mvm_warning.wav", 0, 100)
			if (!ply:IsMiniBoss()) then
				ply:TFTaunt(tostring(ply:GetActiveWeapon():GetSlot() + 1))
			end
			for _,pl in pairs(player.GetAll()) do
				if not pl:IsFriendly(ply) then
					if pl:GetPlayerClass() == "heavy" then
						pl:EmitSound("vo/heavy_mvm_bomb_upgrade0"..math.random(1,2)..".wav", 80, 100, 1, CHAN_VOICE)
					elseif pl:GetPlayerClass() == "soldier" then
						pl:EmitSound("vo/soldier_mvm_bomb_upgrade0"..math.random(1,3)..".wav", 80, 100, 1, CHAN_VOICE)
					elseif pl:GetPlayerClass() == "medic" then
						pl:EmitSound("vo/medic_mvm_bomb_upgrade0"..math.random(1,3)..".wav", 80, 100, 1, CHAN_VOICE)
					elseif pl:GetPlayerClass() == "engineer" then
						pl:EmitSound("vo/engineer_mvm_bomb_upgrade0"..math.random(1,3)..".wav", 80, 100, 1, CHAN_VOICE)
					end
				end
			end
		end)
		timer.Create("WarningEnd3", 65 + ply:SequenceDuration(ply:LookupSequence("taunt01")), 1, function() 
			ply:ConCommand("tf_firstperson")
			ply:Freeze(false)
		end)
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
		self.Carrier = nil
		self.Prop:ResetSequence(self.Prop:LookupSequence("spin"))
		self.Prop:SetPlaybackRate(1)
		self.Prop:SetCycle(1)
		self.Prop2:SetPlaybackRate(1)
		self.Prop2:SetCycle(1)
		self:SetNotSolid(false)
		self:SetTrigger(true)
		self:SetParent()
		self:SetAngles(Angle(0, self:GetAngles().y, 0))
		self:DropToFloor()
		self:TriggerOutput("OnDrop", ply)

		self:SetMoveType(MOVETYPE_FLYGRAVITY)
		self:SetMoveCollide(MOVECOLLIDE_FLY_BOUNCE)
		
		--ParticleEffectAttach( "cart_flashinglight", PATTACH_POINT_FOLLOW, self.Prop2, self.Prop2:LookupAttachment("siren") )
		if nosound then
			return
		end
		self:GetNWEntity("prop2", self):SetNoDraw(false)
		for _, ply in pairs(player.GetAll()) do
			if ply:Team() == self.TeamNum then
				ply:Speak("TLK_MVM_BOMB_DROPPED")
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
	
	local s = 1
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
	if (self.Carrier and self.Carrier.TFBot) then

		for _,capturezone in ipairs(ents.FindByClass("func_capturezone")) do
			self.Carrier.botPos = capturezone.Pos
		end

	end
	self:NextThink(CurTime())
end

end