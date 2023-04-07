ENT.Type = "point"

local TimeRemainingToOutput = {
{1	, "On1SecRemain"	, Sound("Announcer.RoundBegins1Seconds")	, Sound("Announcer.RoundEnds1seconds")},
{2	, "On2SecRemain"	, Sound("Announcer.RoundBegins2Seconds")	, Sound("Announcer.RoundEnds2seconds")},
{3	, "On3SecRemain"	, Sound("Announcer.RoundBegins3Seconds")	, Sound("Announcer.RoundEnds3seconds")},
{4	, "On4SecRemain"	, Sound("Announcer.RoundBegins4Seconds")	, Sound("Announcer.RoundEnds4seconds")},
{5	, "On5SecRemain"	, Sound("Announcer.RoundBegins5Seconds")	, Sound("Announcer.RoundEnds5seconds")},
{6	, "On6SecRemain"	, nil	, nil},
{7	, "On7SecRemain"	, nil	, nil},
{8	, "On8SecRemain"	, nil	, nil},
{9	, "On9SecRemain"	, nil	, nil},
{10	, "On10SecRemain"	, Sound("Announcer.RoundBegins10Seconds")	, Sound("Announcer.RoundEnds10seconds")},
{20	, "On20SecRemain"	, nil	, nil},
{30	, "On30SecRemain"	, Sound("Announcer.RoundBegins30Seconds")	, Sound("Announcer.RoundEnds30seconds")},
{60	, "On1MinRemain"	, Sound("Announcer.RoundBegins60Seconds")	, Sound("Announcer.RoundEnds60seconds")},
{120, "On2MinRemain"	, nil										, nil},
{180, "On3MinRemain"	, nil										, nil},
{240, "On4MinRemain"	, nil										, nil},
{300, "On5MinRemain"	, nil										, Sound("Announcer.RoundEnds5minutes")},
}

function ENT:Initialize()
end

function ENT:InitPostEntity()
	print(self)
	PrintTable(self.Properties or {})
	
	self.StartPaused = (self.Properties.start_paused == 1)
	self.SetupLength = self.Properties.setup_length or 0
	self.TimerLength = self.Properties.timer_length
	self.MaxLength = self.Properties.max_length or 0
	self.AutoCountdown = (self.Properties.auto_countdown == 1)
	self.ShowInHUD = (self.Properties.show_in_hud == 1)
	
	if self.MaxLength == 0 then self.MaxLength = math.huge end
	
	if self.ShowInHUD then
		GAMEMODE.CurrentHUDTimer = self
	end
	
	self:RestartTimer()
end

function ENT:RestartTimer(endsetup)
	self.LastPlayedTimeSignal = nil
	self.RoundFinished = false
	
	if not endsetup and self.SetupLength>0 then
		self.IsSetupPhase = true
		if self.StartPaused then
			self:SetAndPauseTimer(self.SetupLength, true)
		else
			self:SetAndResumeTimer(self.SetupLength, true)
		end
		self:TriggerOutput("OnSetupStart")
	else
		
		self.IsSetupPhase = false
		timer.Simple(1, function()
			if (!self.WaitingForPlayers) then
				umsg.Start("TF_PlayGlobalSound")
					umsg.String("Ambient.Siren")
				umsg.End()
			end
			if self.StartPaused then
				self:SetAndPauseTimer(self.TimerLength, true)
			else
				self:SetAndResumeTimer(self.TimerLength, true)
			end
			if (string.find(game.GetMap(),"mvm")) then
				self.StartPaused = true
				self:SetAndPauseTimer(0,true)
			end
			self:TriggerOutput("OnRoundStart")
			if endsetup then
				self:TriggerOutput("OnSetupFinished")
			end

		end)
	end
end

function ENT:RestartTimer2(endsetup)
	self.LastPlayedTimeSignal = nil
	self.RoundFinished = false
	
	if not endsetup and self.SetupLength>0 then
		self.IsSetupPhase = true
		if self.StartPaused then
			self:SetAndPauseTimer(self.SetupLength, true)
		else
			self:SetAndResumeTimer(self.SetupLength, true)
		end
		self:TriggerOutput("OnSetupStart")
	else
		
		self.IsSetupPhase = false
		umsg.Start("TF_PlayGlobalSound")
			umsg.String("Ambient.Siren")
		umsg.End()
		if self.StartPaused then
			self:SetAndPauseTimer(self.TimerLength, true)
		else
			self:SetAndResumeTimer2(self.TimerLength, true)
		end
		if (string.find(game.GetMap(),"mvm")) then
			self.StartPaused = true
			self:SetAndPauseTimer(0,true)
		end
		self:TriggerOutput("OnRoundStart")
		if endsetup then
			self:TriggerOutput("OnSetupFinished")
		end
	end
end

function ENT:GetTime()
	if not self.TimerReference or not self.TimerLastUpdated then
		return 0
	end
	
	if self.TimerPaused then
		return math.Clamp(self.TimerPaused, 0, math.huge)
	else
		return math.Clamp(self.TimerReference - (CurTime() - self.TimerLastUpdated), 0, math.huge)
	end
end

function ENT:SetTime(sec)
	sec = math.Clamp(sec, 0, self.MaxLength)
	
	if self.TimerPaused then
		self:SetAndPauseTimer(sec)
	else
		self:SetAndResumeTimer(sec)
	end
end

function ENT:SetAndResumeTimer(sec, setmax)
	sec = math.Clamp(sec, 0, self.MaxLength)
	
	self.TimerReference = sec
	self.TimerLastUpdated = CurTime()
	self.TimerPaused = nil
	
	if self==GAMEMODE.CurrentHUDTimer then
		umsg.Start("TF_SetAndResumeTimer")
			umsg.Float(sec)
			umsg.Float((setmax and sec) or 0)
			umsg.Bool(self.IsSetupPhase)
		umsg.End()
	end
end
function ENT:SetAndResumeTimer2(sec, setmax)
	sec = math.Clamp(sec, 0, self.MaxLength)
	
	self.TimerReference = sec
	self.TimerLastUpdated = CurTime()
	self.TimerPaused = nil
	
	if self==GAMEMODE.CurrentHUDTimer then
		umsg.Start("TF_SetAndResumeTimerWaiting")
			umsg.Float(sec)
			umsg.Float((setmax and sec) or 0)
			umsg.Bool(true)
		umsg.End()
	end
end

function ENT:SetAndPauseTimer(sec, setmax)
	sec = math.Clamp(sec, 0, self.MaxLength)
	
	self.TimerPaused = sec
	
	if self==GAMEMODE.CurrentHUDTimer then
		umsg.Start("TF_SetAndPauseTimer")
			umsg.Float(sec)
			umsg.Float((setmax and sec) or 0)
			umsg.Bool(self.IsSetupPhase)
		umsg.End()
	end
end

function ENT:ResumeTimer()
	self:SetAndResumeTimer(self:GetTime())
end

function ENT:PauseTimer()
	self:SetAndPauseTimer(self:GetTime())
end

function ENT:KeyValue(key,value)
	self:StoreOutput(key, value)
	
	key = string.lower(key)
	
	if not self.Properties then
		self.Properties = {}
	end
	if tonumber(value) then value=tonumber(value) end
	self.Properties[key] = value
end

function ENT:Think()
	if not GAMEMODE.PostEntityDone then return end
	if GAMEMODE.PostEntityDone and not self.PostEntityDone then
		self:InitPostEntity()
		self.PostEntityDone = true
		
		-- return (I want you to start thinking, immediately)
	end
	
	local t = self:GetTime()
	if t<=0 then
		if self.IsSetupPhase then
			self:RestartTimer(true)
		elseif not self.RoundFinished then
			self.RoundFinished = true
			self:TriggerOutput("OnFinished")
		end
		return
	end
	
	for k,v in ipairs(TimeRemainingToOutput) do
		if k == self.LastPlayedTimeSignal then
			break
		end
		
		if t <= v[1] then
			self:TriggerOutput(v[2])
			self.LastPlayedTimeSignal = k
			if (!self.WaitingForPlayers) then
				if self.IsSetupPhase and v[3] then
					umsg.Start("TF_PlayGlobalSound")
						umsg.String(v[3])
					umsg.End()
				elseif not self.IsSetupPhase and self.AutoCountdown and v[4] then
					umsg.Start("TF_PlayGlobalSound")
						umsg.String(v[4])
					umsg.End()
				end
			end
			break
		end
	end
end

function ENT:Input_Pause(activator, caller, data)
	self:PauseTimer()
end

function ENT:Input_Resume(activator, caller, data)
	self:ResumeTimer()
end

function ENT:Input_SetTime(activator, caller, data)
	local sec = tonumber(data)
	if sec then
		self:SetTime(sec)
	end
end

function ENT:Input_AddTime(activator, caller, data)
	local sec = tonumber(data)
	if sec then
		self:SetTime(self:GetTime() + sec)
	end
end

function ENT:Input_AddTeamTime(activator, caller, data)
	local t, sec = string.match("(.*)%s+(.*)")
	t, sec = tonumber(t), tonumber(sec)
	
	if t and sec then
		print(Format("Added %d seconds due to team %d", sec, t))
		self:SetTime(self:GetTime() + sec)
	end
end

function ENT:Input_Restart(activator, caller, data)
	self:RestartTimer()
end

function ENT:Input_ShowInHUD(activator, caller, data)
	if tonumber(data)==1 then
		self.ShowInHUD = true
		GAMEMODE.CurrentHUDTimer = self
	else
		self.ShowInHUD = false
		if GAMEMODE.CurrentHUDTimer == self then
			GAMEMODE.CurrentHUDTimer = nil
			for _,v in pairs(ents.FindByClass("team_round_timer")) do
				if v.ShowInHUD then
					GAMEMODE.CurrentHUDTimer = v
					break
				end
			end
		end
	end
end

function ENT:Input_SetMaxTime(activator, caller, data)
	local sec = tonumber(data)
	if sec then
		self.MaxLength = sec
		if self.MaxLength <= 0 then self.MaxLength = math.huge end
		
		if self:GetTime()>self.MaxLength then
			self:SetTime(self.MaxLength)
		end
	end
end

function ENT:OnRemove()
	umsg.Start("TF_RemoveTimer")
	umsg.End()
end
function ENT:Input_AutoCountdown(activator, caller, data)
	self.AutoCountdown = (tonumber(data)==1)
end

function ENT:Input_SetSetupTime(activator, caller, data)
	local sec = tonumber(data)
	if sec then
		self.SetupLength = sec
	end
end

function ENT:AcceptInput(name, activator, caller, data)
	print(self, "received input", name)
	local f = self["Input_"..name]
	if f then
		f(self, activator, caller, data)
	end
end
