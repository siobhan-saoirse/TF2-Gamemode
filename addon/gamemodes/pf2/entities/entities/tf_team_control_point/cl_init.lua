include("shared.lua")

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT

local function UpdateControlPointTexture(cp)	
	local str
	if cp.locked then	str = "tex_icon_locked_"
	else				str = "tex_icon_"
	end
	
	cp.tex_icon = cp[str..cp.owner] or cp[str.."0"]
	cp.tex_overlay = cp["tex_overlay_"..cp.owner] or cp["tex_overlay_0"]
end

local function GetTextureID(tex)
	if tex=="" then
		return -1
	else
		return surface.GetTextureID(tex)
	end
end

usermessage.Hook("TF_SetControlPointLayout", function(msg)
	local str = msg:ReadString()
	local y = 1
	local m = {{}}
	
	str=string.gsub(str, "(%S),", "%1 ,")
	str=string.gsub(str, ",(%S)", ", %1")
	for n in string.gmatch(str, "[0-9,]+") do
		if tonumber(n) then
			table.insert(m[y], tonumber(n)+1)
		else
			y = y+1
			m[y] = {}
		end
	end
	
	GAMEMODE.ControlPointLayout = m
	
	for _,v in ipairs(m) do
		for _,n in ipairs(v) do
			Msg(n.." ")
		end
		Msg("\n")
	end
end)

usermessage.Hook("TF_AddControlPoint", function(msg)
	if not GAMEMODE.ControlPoints then GAMEMODE.ControlPoints = {} end
	
	local id = msg:ReadChar()
	local cp = {}
	
	cp.name 			= msg:ReadString()
	
	cp.icon_neutral		= msg:ReadString()
	cp.icon_red			= msg:ReadString()
	cp.icon_blu			= msg:ReadString()
	cp.tex_icon_0			= GetTextureID(cp.icon_neutral)
	cp.tex_icon_2			= GetTextureID(cp.icon_red)
	cp.tex_icon_3			= GetTextureID(cp.icon_blu)
	cp.tex_icon_locked_0	= GetTextureID(cp.icon_neutral.."_locked")
	cp.tex_icon_locked_2	= GetTextureID(cp.icon_red.."_locked")
	cp.tex_icon_locked_3	= GetTextureID(cp.icon_blu.."_locked")
	
	cp.overlay_neutral	= msg:ReadString()
	cp.overlay_red		= msg:ReadString()
	cp.overlay_blu		= msg:ReadString()
	cp.tex_overlay_0	= GetTextureID(cp.overlay_neutral)
	cp.tex_overlay_2	= GetTextureID(cp.overlay_red)
	cp.tex_overlay_3	= GetTextureID(cp.overlay_blu)
	
	cp.owner			= msg:ReadChar()
	cp.locked			= false
	
	UpdateControlPointTexture(cp)
	
	MsgN("Control point "..id)
	PrintTable(cp)
	
	GAMEMODE.ControlPoints[id] = cp
end)

usermessage.Hook("TF_SetControlPointTeam", function(msg)
	local id = msg:ReadChar()
	local cp = GAMEMODE.ControlPoints[id]
	
	if not cp then return end
	
	cp.owner = msg:ReadChar()
	UpdateControlPointTexture(cp)
end)

usermessage.Hook("TF_LockControlPoint", function(msg)
	local id = msg:ReadChar()
	local cp = GAMEMODE.ControlPoints[id]
	
	if not cp then return end
	
	cp.locked = true
	UpdateControlPointTexture(cp)
end)

usermessage.Hook("TF_OpenControlPoint", function(msg)
	local id = msg:ReadChar()
	local cp = GAMEMODE.ControlPoints[id]
	
	if not cp then return end
	
	cp.locked = false
	UpdateControlPointTexture(cp)
end)

usermessage.Hook("TF_EnterControlPoint", function(msg)
	LocalPlayer().CurrentControlPoint = msg:ReadChar()
end)

usermessage.Hook("TF_ExitControlPoint", function(msg)
	LocalPlayer().CurrentControlPoint = -1
end)

usermessage.Hook("TF_SetAndResumeTimer", function(msg)
	GAMEMODE.RoundTimeReference = msg:ReadFloat()
	
	local t = msg:ReadFloat()
	if t>0 then GAMEMODE.MaxRoundTime = t end
	
	GAMEMODE.RoundTimeIsSetupPhase = msg:ReadBool()
	GAMEMODE.RoundTimeLastUpdated = CurTime()
	GAMEMODE.RoundTimePaused = nil
end)

usermessage.Hook("TF_SetAndPauseTimer", function(msg)
	GAMEMODE.RoundTimePaused = msg:ReadFloat()
	
	local t = msg:ReadFloat()
	if t>0 then GAMEMODE.MaxRoundTime = t end
	
	GAMEMODE.RoundTimeIsSetupPhase = msg:ReadBool()
end)

usermessage.Hook("TF_PlayGlobalSound", function(msg)
	LocalPlayer():EmitSound(msg:ReadString())
end)

function ENT:Draw()
	-- fuck AutomaticFrameAdvance, this is better
	if self.LastDrawn then
		self:FrameAdvance(CurTime() - self.LastDrawn)
	end
	self.LastDrawn = CurTime()
	
	self:DrawModel()
end