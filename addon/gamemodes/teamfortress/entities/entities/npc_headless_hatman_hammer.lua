AddCSLuaFile()

PrecacheParticleSystem( "halloween_boss_summon" );
PrecacheParticleSystem( "halloween_boss_axe_hit_world" );
PrecacheParticleSystem( "halloween_boss_injured" );
PrecacheParticleSystem( "halloween_boss_death" );
PrecacheParticleSystem( "halloween_boss_foot_impact" );
PrecacheParticleSystem( "halloween_boss_eye_glow" );
ENT.Base 			= "npc_headless_hatman"
ENT.Spawnable		= false
ENT.Hammer = true 


list.Set( "NPC", "npc_headless_hatman_hammer", {
	Name = "HHH (Big Mallet)",
	Class = "npc_headless_hatman_hammer",
	Category = "TF2: Halloween"
})