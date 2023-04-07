
local meta = FindMetaTable("Entity")

if CLIENT then

function TestSound(snd)
	local s = tf_soundscript.Sounds[string.lower(snd)]
	if s then
		local snd = table.Random(s.wave)
		local pitch
		if s.rndpitch then
			pitch = math.random(unpack(s.rndpitch))
		else
			pitch = s.pitch
		end
		
		local lvl = s.soundlevel
		
		print(snd, lvl, pitch)
		LocalPlayer():EmitSound(snd, lvl, pitch)
	end
end

end

if not meta.EmitSoundOLD then
	meta.EmitSoundOLD = meta.EmitSound
end
function meta:EmitSound(snd, lvl, pitch)
	local s = tf_soundscript.Sounds[string.lower(snd)]
	--print(snd)
	if s then
		snd = table.Random(s.wave)
		local pitch
		if s.rndpitch then
			pitch = math.random(unpack(s.rndpitch))
		else
			pitch = s.pitch
		end
		
		local lvl = s.soundlevel
		
		self:EmitSoundOLD(snd, lvl, pitch)
	else
		self:EmitSoundOLD(snd, lvl, pitch)
	end
end

if not util.PrecacheSoundOLD then
	util.PrecacheSoundOLD = util.PrecacheSound
end
function util.PrecacheSound(snd)
	local s = tf_soundscript.Sounds[string.lower(snd)]
	if s then
		for _,v in ipairs(s.wave) do
			util.PrecacheSound(v)
		end
	else
		util.PrecacheSoundOLD(snd)
	end
end

if not CreateSoundOLD then
	CreateSoundOLD = CreateSound
end
function CreateSound(ent, snd)
	local s = tf_soundscript.Sounds[string.lower(snd)]
	
	if s then
		snd = table.Random(s.wave)
		local pitch
		if s.rndpitch then
			pitch = math.random(unpack(s.rndpitch))
		else
			pitch = s.pitch
		end
		
		local lvl = s.soundlevel
		
		local sound_ent = CreateSoundOLD(ent, snd)
		sound_ent:ChangePitch(pitch)
		sound_ent:ChangeVolume(volume)
		sound_ent:SetSoundLevel(lvl)
		return sound_ent
	else
		return CreateSoundOLD(ent, snd)
	end
end

local string = string
local util = util
local file = file
local pairs = pairs
local tonumber = tonumber

module("tf_soundscript")

Sounds = {}

local VolumeNames = {
	
}

local PitchNames = {
	PITCH_NORM = 100,
	PITCH_LOW  = 95,
	PITCH_HIGH = 120,
}

local SoundlevelNames = {
	SNDLVL_NONE = 0,
	SNDLVL_20dB	= 20,
	SNDLVL_25dB = 25,
	SNDLVL_30dB = 30,
	SNDLVL_35dB = 35,
	SNDLVL_40dB = 40,
	SNDLVL_45dB = 45,
	SNDLVL_50dB = 50,
	SNDLVL_55dB = 55,
	SNDLVL_IDLE = 60,
	SNDLVL_TALKING = 60,
	SNDLVL_65dB = 65,
	SNDLVL_STATIC = 66,
	SNDLVL_70dB = 70,
	SNDLVL_NORM = 75,
	SNDLVL_80dB = 80,
	SNDLVL_85dB = 85,
	SNDLVL_90dB = 90,
	SNDLVL_95dB = 95,
	SNDLVL_100dB = 100,
	SNDLVL_105dB = 105,
	SNDLVL_110dB = 110,
	SNDLVL_120dB = 120,
	SNDLVL_130dB = 130,
	SNDLVL_GUNFIRE = 140,
	SNDLVL_140dB = 140,
	SNDLVL_150dB = 150,
}

-- Adds an unique number before each key which has the given name
local function FormatNamedBlocks(str, name)
	local counter = 0
	return string.gsub(str, '(%s*)"'..name..'"', function(s)
		counter = counter + 1
		return string.format('%s"%d-'..name..'"', s, counter)
	end)
end

function Parse(data)
	data = "data\n{\n"..data.."\n}\n"
	data = string.gsub(data, '("rndwave"%s*%b{})', function(s) return FormatNamedBlocks(s, "wave") end)
	
	for name,d in pairs(util.KeyValuesToTable(data)) do
		local t = {}
		
		t.wave = {}
		if d.rndwave then
			for k,v in pairs(d.rndwave) do
				local i = tonumber(string.match(k, "wave-(%d+)"))
				if i then
					t.wave[i] = v
				end
			end
		else
			t.wave[1] = d.wave or ""
		end
		
		t.channel = d.channel or "CHAN_STATIC"
		t.volume = tonumber(d.volume) or 1.0
		
		if d.pitch then
			local min, max = string.match(d.pitch, "(%d+)%s*,%s*(%d+)")
			if min then
				t.rndpitch = {min, max}
			else
				t.pitch = (tonumber(d.pitch) or PitchNames[d.pitch]) or 100
			end
		else
			t.pitch = 100
		end
		
		t.soundlevel = (tonumber(d.soundlevel) or SoundlevelNames[d.soundlevel or ""]) or 75
		
		Sounds[string.lower(name)] = t
	end
end

function Load(path)
	local data = file.Read(path, "DATA")
	if data and data ~= "" then
		Parse(data)
	end
end
