
--[[
A poor attempt at making a timer running on both the server and client, which can be progressively synchronized from the server
]]

module("tf_timer", package.seeall)

TIMERS = {}

if SERVER then

function Reset(i)
	TIMERS[i] = {}
	TIMERS[i].start = CurTime()
end

function Value(i)
	return CurTime() - TIMERS[i].start
end

function SynchronizeTimer(i, rp)
	umsg.Start("SynchronizeTFTimer", rp)
		umsg.Long(i)
		umsg.Float(Value(i))
	umsg.End()
end

end

if CLIENT then

function Reset(i)
	TIMERS[i] = {}
	TIMERS[i].start = CurTime()
	TIMERS[i].val0 = 0
	TIMERS[i].mul = 1
end

function Value(i)
	return TIMERS[i].val0 + (CurTime() - TIMERS[i].start) * TIMERS[i].mul
end

usermessage.Hook("SynchronizeTFTimer", function(msg)
	local i = msg:ReadLong()
	local newtime = msg:ReadFloat()
	
	TIMERS[i].val0 = Value(i)
	TIMERS[i].mul = newtime / TIMERS[i].val0
	TIMERS[i].start = CurTime()
end)

end