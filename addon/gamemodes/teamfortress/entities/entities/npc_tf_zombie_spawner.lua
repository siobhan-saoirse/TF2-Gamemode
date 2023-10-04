AddCSLuaFile()

ENT.Base 			= "base_entity"
ENT.Spawnable		= false
function ENT:Initialize()
	self:SetModel("models/empty.mdl")
	self:EmitSound("Halloween.spell_skeleton_horde_rise")
	if SERVER then
		local pos = self:GetPos()
		timer.Create("HordeIncoming"..self:EntIndex(), 0.1, math.random(10,30), function()
			timer.Simple(math.Rand(2,2.5), function()
				local mini_skeleton = ents.Create("npc_tf_zombie")
				if (math.random(1,100) == 1) then
					mini_skeleton = ents.Create("npc_tf_zombie_boss")
				end
				local pos2 = pos + Vector(math.random(-32,32),math.random(-32,32),0) * math.random(1,6)
				mini_skeleton:SetPos(pos2)
				ParticleEffect( "spell_skeleton_goop_green", pos2, mini_skeleton:GetAngles() )
				mini_skeleton:EmitSound("Cleaver.ImpactFlesh")
				mini_skeleton:Spawn()
				mini_skeleton:Activate()
				timer.Simple(0.21, function()
					mini_skeleton:SetSkin(math.random(0,3))
					mini_skeleton:SetHealth(math.random(30,125))
				end)
			end)
		end)
		self:Remove()
	end
end
 
list.Set( "NPC", "npc_tf_zombie_spawner", {
	Name = "Skeleton Horde",
	Class = "npc_tf_zombie_spawner",
	Category = "TF2: Halloween",
	AdminOnly = true
})