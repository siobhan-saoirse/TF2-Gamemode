AddCSLuaFile()

ENT.Base 			= "npc_tf_zombie"
ENT.Spawnable		= false
ENT.Model = "models/bots/skeleton_sniper_boss/skeleton_sniper_boss.mdl"
ENT.AttackDelay = 50
ENT.AttackDamage = 100
ENT.AttackRange = 100


function ENT:Initialize() 

	self:SetModel( self.Model )
	local rand = math.random(1,7)
	local seq = "spawn0"..rand
	if SERVER then
		local axe = ents.Create("gmod_button")
		axe:SetModel("models/player/items/demo/crown.mdl")
		axe:SetPos(self:GetPos())
		axe:SetAngles(self:GetAngles())
		axe:SetParent(self)
		axe:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
		self:SetNWEntity("Hat",axe)
	end
		self:SetSkin(2)
		self:SetModelScale(2)
		timer.Simple(self:SequenceDuration(self:LookupSequence(seq)), function()
			self.Ready = true
		end)
	self.Ready = false
	self.LoseTargetDist	= 4000	-- How far the enemy has to be before we lose them
	self.SearchRadius 	= 3000	-- How far to search for enemies
	self:SetHealth(5000)
	self:SetCollisionGroup( COLLISION_GROUP_INTERACTIVE_DEBRIS )
	if SERVER then
		self:SetBloodColor(DONT_BLEED)
		self:AddFlags(FL_OBJECT)
		if SERVER then
			for k,v in ipairs(ents.GetAll()) do
				if v:IsNPC() then
					v:AddEntityRelationship(self,D_HT,99)
				end
			end
		end
        for k,v in ipairs(player.GetAll()) do
            v:Speak("TLK_PLAYER_SKELETON_KING_APPEAR")
            v:SendLua('LocalPlayer():EmitSound("Announcer.Helltower_Blue_Skeleton_King0"..math.random(1,4))')
        end
		self:PlaySequenceAndWait("spawn0"..rand)
	end
end

function ENT:GetHat()
	return self:GetNWEntity("Hat")
end

list.Set( "NPC", "npc_tf_zombie_boss", {
	Name = "SKELETON KING",
	Class = "npc_tf_zombie_boss",
	Category = "TF2: Halloween"
}) 