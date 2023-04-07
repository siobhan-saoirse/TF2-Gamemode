
local function PrecacheTFContent()
	MsgN("Precaching TF2 models")
	for _,v in pairs(HumanGibs) do
		util.PrecacheModel0(v)
	end
	
	for _,v in pairs(RobotGibs) do
		util.PrecacheModel0(v)
	end
	
	for _,v in pairs(RobotBossGibs) do
		util.PrecacheModel0(v)
	end

	for _,v in pairs(PlayerModels) do
		util.PrecacheModel0(v)
	end

	for _,v in pairs(AnimationModels) do
		util.PrecacheModel0(v)
	end
end

if SERVER and game.SinglePlayer() then
	hook.Add("PostGamemodeLoaded", "PrecacheTFContent", function()
		PrecacheTFContent()
	end)
else
	PrecacheTFContent()
end

PrecacheParticleSystem("crit_text")
PrecacheParticleSystem("minicrit_text")
PrecacheParticleSystem("healthgained_red")
PrecacheParticleSystem("healthgained_blu")
PrecacheParticleSystem("healthlost_red")
PrecacheParticleSystem("healthlost_blu")

PrecacheParticleSystem("blood_decap")
PrecacheParticleSystem("blood_decap_arterial_spray")
PrecacheParticleSystem("blood_decap_fountain")
PrecacheParticleSystem("blood_decap_streaks")

PrecacheParticleSystem("rocketjump_smoke")
PrecacheParticleSystem("burningplayer_flyingbits")
PrecacheParticleSystem("particle_nemesis_red")
PrecacheParticleSystem("particle_nemesis_blue")

PrecacheParticleSystem("muzzle_raygun_red")
PrecacheParticleSystem("bullet_tracer_raygun_red")