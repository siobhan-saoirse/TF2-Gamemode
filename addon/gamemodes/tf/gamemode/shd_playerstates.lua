
local meta = FindMetaTable("Entity")
if not meta then return end 

PLAYERSTATE_ONFIRE		= 1
PLAYERSTATE_WATERDROPS	= 2
PLAYERSTATE_OVERHEALED	= 4
PLAYERSTATE_CRITBOOST	= 8
PLAYERSTATE_MINICRIT	= 16
PLAYERSTATE_JARATED		= 32
PLAYERSTATE_EYELANDER	= 64
PLAYERSTATE_BLEEDING	= 128
PLAYERSTATE_MILK		= 256
PLAYERSTATE_STUNNED		= 512
PLAYERSTATE_PUKEDON		= 1024
PLAYERSTATE_MARKED		= 2048
PLAYERSTATE_SPEED		= 4096
--[[
= 8192
= 16384
= 32768
]]

local function DefaultParticleNameFunc(v, p)
	return string.format(v.particle,ParticleSuffix(p:EntityTeam()))
end

function meta:GetPlayerState()
	return self:GetNWInt("PlayerState")
end

function meta:SetPlayerState(st, upd)
	local old = self:GetNWInt("PlayerState", st)
	
	if old~=st then
		self:SetNWInt("PlayerState", st)
		if upd then
			self:UpdateState()
		end
	end
end

function meta:AddPlayerState(st, upd)
	local old = self:GetNWInt("PlayerState")
	local state = bit.bor(old, st)
	
	
	if old~=state then
		self:SetNWInt("PlayerState", state)
		if upd then
			self:UpdateState()
		end
	end
end

function meta:RemovePlayerState(st, upd)
	local old = self:GetNWInt("PlayerState")
	-- won't be using more than 16 bits anyway, so...
	local state = bit.band(old, (65535-st))
	
	if self:HasPlayerState(PLAYERSTATE_ONFIRE) then
		self:SetNWInt("BurnLevel", 0)
	end
	if old~=state then
		self:SetNWInt("PlayerState", state)
		if upd then
			self:UpdateState()
		end
	end
end

function meta:HasPlayerState(st, state_override)
	local state = state_override or self:GetNWInt("PlayerState")
	return bit.band(state, st)>0
end

function meta:UpdateState(delay)
	if not IsValid(self) then return end
	if delay then
		timer.Simple(delay, function() self:UpdateState() end)
		return
	end
	self:UpdateStateProxies()
	self:UpdateStateColor()
	self:UpdateStateParticles()
end

function meta:UpdateStateProxies(state_override)
	if SERVER then return end
	
	self:ClearProxyVars()
	
	for k,v in pairs(PlayerStates) do
		if v.proxyvars and self:HasPlayerState(k, state_override) then
			for _,p in ipairs(v.proxyvars) do
				local f = p[2]
				if type(f) == "function" then
					self:SetProxyVar(p[1], f(self))
				else
					local wep = self:GetActiveWeapon()
					if CLIENT then
						if (IsValid(wep)) then
							if (IsValid(wep.CModel)) then
								wep.CModel:SetProxyVar(p[1], f)
							elseif (IsValid(wep.WModel)) then
								wep.WModel:SetProxyVar(p[1], f)
							end
						end
					end
					self:SetProxyVar(p[1], f)
				end
			end
		end
	end
end

function meta:UpdateStateParticles(state_override)
	if SERVER and self:IsPlayer() then
		umsg.Start("UpdatePlayerStateParticles")
			umsg.Entity(self)
			umsg.Long(self:GetPlayerState())
		umsg.End()
	else
		if CLIENT then
			self:UpdateStateProxies(state_override)
		end
		self:StopParticles()
		
		if self:IsPlayer() then
			local w = self:GetActiveWeapon()
			if w.ResetParticles then
				w:ResetParticles(state_override)
			end
			
			if self.PlayerItemList then
				for _,v in pairs(self.PlayerItemList) do
					if v.ResetParticles then
						v:ResetParticles(state_override)
					end
				end
			end
		end
		
		if CLIENT and self==LocalPlayer() then
			if not LocalPlayer():ShouldDrawLocalPlayer() and state_override != PLAYERSTATE_SPEED then
				return
			end
		end
		
		for k,v in pairs(PlayerStates) do
			if v.particle and self:HasPlayerState(k, state_override) then
				local f = v.particlenamefunc or DefaultParticleNameFunc
				local att = v.particleattachment or 0
				if type(att)=="string" then
					att = self:LookupAttachment(att)
				end
				
				ParticleEffectAttach(
					f(v, self),
					v.particleattachtype or PATTACH_ABSORIGIN_FOLLOW,
					self,
					att
				)
			end
			if v.particle2 and self:HasPlayerState(k, state_override) and GetConVar("tf_pyrovision"):GetBool() then
				local f = v.particlenamefunc or DefaultParticleNameFunc
				local att = v.particleattachment or 0
				if type(att)=="string" then
					att = self:LookupAttachment(att)
				end
				
				ParticleEffectAttach(
					f(v, self),
					v.particleattachtype or PATTACH_ABSORIGIN_FOLLOW,
					self,
					att
				)
			end
		end
	end
end

function meta:UpdateStateColor()
	local col = {255, 255, 255, 255}
	
	for k,v in pairs(PlayerStates) do
		if v.color and self:HasPlayerState(k) then
			col[1] = math.Clamp(col[1] + v.color[1], 0, 255)
			col[2] = math.Clamp(col[2] + v.color[2], 0, 255)
			col[3] = math.Clamp(col[3] + v.color[3], 0, 255)
			col[4] = math.Clamp(col[4] + v.color[4], 0, 255)
		end
	end
	
	if self:IsPlayer() then
		if col[1]<255 or col[2]<255 or col[3]<255 or col[4]<255 then
			self:SetRenderMode(RENDERMODE_TRANSCOLOR)
		else
			self:SetRenderMode(RENDERMODE_NORMAL)
		end
	end
	
	-- Set the actual color now
	//self:SetColor(unpack(col))
end

if CLIENT then

function meta:DrawStateOverlay()
	for k,v in pairs(PlayerStates) do
		if type(v.overlay)=="string" then
			v.overlay = Material(v.overlay)
		end
		
		if v.overlay and self:HasPlayerState(k) then
			v.overlay:SetFloat("$burnlevel", 1)
			render.UpdateScreenEffectTexture()
			render.SetMaterial(v.overlay)
			render.DrawScreenQuad()
		end
	end
end

usermessage.Hook("SetPlayerState", function(msg)
	local ent = msg:ReadEntity()
	ent:SetPlayerState(msg:ReadLong())
end)

usermessage.Hook("UpdatePlayerStateParticles", function(msg)
	local ent = msg:ReadEntity()
	ent:UpdateStateParticles(msg:ReadLong())
end)

end

/*
hook.Add("OnEntityCreated","lo",function(e) if e:GetClass()=="entityflame" then local p=e:GetParent() if IsValid(p) then e:StopParticles() ParticleEffectAttach("burningplayer_red", PATTACH_ABSORIGIN_FOLLOW, p, 0) end end end)


*/

PlayerStates = {
	[PLAYERSTATE_ONFIRE] = {
		particle = "burningplayer_%s",
		particle2 = "burningplayer_rainbow_%s",
		overlay = "Effects/imcookin",
		proxyvars = {
			{"BurnLevel", 0.5},
		},
	},
	[PLAYERSTATE_WATERDROPS] = {
			particle = "peejar_drips",
		color = {0,0,-255,0},
	},
	[PLAYERSTATE_JARATED] = {
		particle = "peejar_drips",
		color = {0,0,-255,0},
		overlay = "Effects/jarate_overlay",
		proxyvars = {
			{"Jarated", true},
			{"YellowLevel", 1},
		},
	},
	[PLAYERSTATE_SPEED] = {
		particle = "speed_boost_trail",
	},
	[PLAYERSTATE_PUKEDON] = {
		color = {0,0,-255,0},
		overlay = "effects/gas_overlay",
		proxyvars = {
			{"Jarated", true},
			{"YellowLevel", 0.5},
		},
	},
	[PLAYERSTATE_STUNNED] = {
		--particle = "peejar_drips",
		color = {0,0,-255,0},
	},
	[PLAYERSTATE_MARKED] = {
		particle = "mark_for_death",
		particleattachtype = PATTACH_POINT_FOLLOW,
		particleattachment = "head"
	},
	[PLAYERSTATE_EYELANDER] = {
		particle = "eye_powerup_%s_lvl_%d",
		particleattachtype = PATTACH_POINT_FOLLOW,
		particleattachment = "righteye",
		particlenamefunc = function(v,p)
			return string.format(v.particle,ParticleSuffix(p:EntityTeam()),math.Clamp(p:GetNWInt("Heads"), 1, 4))
		end,
	},
	[PLAYERSTATE_BLEEDING] = {
		overlay = "Effects/bleed_overlay",
	},
	[PLAYERSTATE_CRITBOOST] = {
		proxyvars = {
			{"CritTeam", function(ent) return ((GAMEMODE:EntityTeam(ent)==TEAM_BLU or GAMEMODE:EntityTeam(ent)==TF_TEAM_PVE_INVADERS) and 2) or 1 end},
			{"CritStatus", 1},
		},
	},
	[PLAYERSTATE_MINICRIT] = {
		proxyvars = {
			{"CritTeam", function(ent) return ((GAMEMODE:EntityTeam(ent)==TEAM_BLU or GAMEMODE:EntityTeam(ent)==TF_TEAM_PVE_INVADERS) and 2) or 1 end},
			{"CritStatus", 2},
		},
	},
	[PLAYERSTATE_MILK] = {
		particle = "peejar_drips_milk",
	},
}

PrecacheParticleSystem("burningplayer_red")
PrecacheParticleSystem("burningplayer_blue")
PrecacheParticleSystem("burningplayer_corpse")

PrecacheParticleSystem("overhealedplayer_red_pluses")
PrecacheParticleSystem("overhealedplayer_blue_pluses")

PrecacheParticleSystem("blood_antlionguard_injured_heavy")
PrecacheParticleSystem("peejar_drips")
PrecacheParticleSystem("peejar_drips_milk")

PrecacheParticleSystem("eye_powerup_red_lvl_1")
PrecacheParticleSystem("eye_powerup_blue_lvl_1")

PrecacheParticleSystem("eye_powerup_red_lvl_2")
PrecacheParticleSystem("eye_powerup_blue_lvl_2")

PrecacheParticleSystem("eye_powerup_red_lvl_3")
PrecacheParticleSystem("eye_powerup_blue_lvl_3")

PrecacheParticleSystem("eye_powerup_red_lvl_4")
PrecacheParticleSystem("eye_powerup_blue_lvl_4")
PrecacheParticleSystem("mark_for_death")
PrecacheParticleSystem("speed_boost_trail")

