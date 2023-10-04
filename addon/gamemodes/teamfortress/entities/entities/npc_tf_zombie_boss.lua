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
	timer.Simple(0.2, function()
		if SERVER then
			self:SetModel( self.Model )
			self:ResetSequence(seq)
			if (self:GetModelScale() == 1) then
			
				timer.Create("Laugh"..self:EntIndex(), math.random(4,5), 0, function()
					self:EmitSound("Halloween.skeleton_laugh_medium")
				end)
			elseif (self:GetModel() == "models/bots/skeleton_sniper_boss/skeleton_sniper_boss.mdl") then
				timer.Create("Laugh"..self:EntIndex(), math.random(6,7), 0, function()
					self:EmitSound("Halloween.skeleton_laugh_giant")
				end)
			elseif (self:GetModelScale() == 0.5) then
				timer.Create("Laugh"..self:EntIndex(), math.random(2,3), 0, function()
					self:EmitSound("Halloween.skeleton_laugh_small")
				end)
			end
		end
	end)
		self:SetSkin(2)
		self:SetModelScale(2)
		timer.Simple(self:SequenceDuration(self:LookupSequence(seq)), function()
			self.Ready = true
		end)
		
	if SERVER then
		local axe = ents.Create("gmod_button")
		axe:SetModel("models/player/items/demo/crown.mdl")
		axe:SetPos(self:GetBonePosition(self:LookupBone("bip_head")))
		axe:SetAngles(self:GetAngles())
		axe:SetParent(self,self:LookupAttachment("head"))
		axe:SetModelScale(self:GetModelScale())
		self:SetNWEntity("Hat",axe)
	end
	for k,v in ipairs(ents.FindInSphere(self:GetPos(), 1300)) do

		if (self:GetModel() == "models/bots/skeleton_sniper/skeleton_sniper_boss.mdl" and IsValid(v) and (v:IsPlayer() or v:IsNPC()) and v:Health() > 0 and v:EntIndex() != self:EntIndex() and (!self.TerrifyAttackDelay or CurTime() > self.TerrifyAttackDelay)) then
			if (!self.TerrifyAttackDelay) then
				self.TerrifyAttackDelay = CurTime() + 10
				return
			end
			if (self:HaveEnemy() and v:GetPos():Distance(self:GetPos()) < 1200) then
				self.Ready = false
				self:AddGestureSequence(self:LookupSequence("melee_swing3"))
				timer.Simple(3.25, function()
					self.Ready = true
				end)
				
				timer.Simple(1.0, function()
					if (!self.Ready) then return end
					ParticleEffect( "hammer_impact_button", self:GetPos(), self:GetAngles() )
					util.ScreenShake( self:GetPos(), 15, 5, 1, 1000 )
					if (v:IsPlayer()) then
						v:ViewPunch( Angle( -30, 0, 0 ) )
					end
					self:EmitSound("Halloween.HeadlessBossAxeHitWorld")
					self:EmitSound("Halloween.HammerImpact")
					
					local toVictim = v:WorldSpaceCenter() - self:WorldSpaceCenter();
					toVictim:Normalize();
					local vecDir = toVictim;
					vecDir:Normalize();
					vecDir.z = vecDir.z + 0.7;
					vecDir = vecDir * 1300.0;
					v:SetVelocity(vecDir)
					for k,_ in ipairs(ents.FindInSphere(self:GetPos(),1200)) do
						if (_:EntIndex() != self:EntIndex() && _:EntIndex() != v:EntIndex()) then
							local toVictim = _:WorldSpaceCenter() - self:WorldSpaceCenter();
							toVictim:Normalize();
							local vecDir = toVictim;
							vecDir:Normalize();
							vecDir.z = vecDir.z + 0.7;
							vecDir = vecDir * 1300.0;
							_:SetVelocity(vecDir)
							if (_:IsPlayer()) then
								_:ViewPunch( Angle( -30, 0, 0 ) )
							end
						end
					end
				end)
			end
			self.MeleeAttackDelay = CurTime() + 1
			self.TerrifyAttackDelay = CurTime() + 10
		end
	end
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
			if (v:Team() == TEAM_BLU) then
            	v:SendLua('LocalPlayer():EmitSound("Announcer.Helltower_Blue_Skeleton_King0"..math.random(1,4))')
			else
            	v:SendLua('LocalPlayer():EmitSound("Announcer.Helltower_Red_Skeleton_King0"..math.random(1,4))')
			end
        end
	end
end

function ENT:OnInjured( dmginfo )
	if (math.random(1,20) == 1) then
		self:EmitSound("Halloween.HeadlessBossPain")
	end
	if not self.NextFlinch or CurTime() > self.NextFlinch then
		self:AddGesture(ACT_MP_GESTURE_FLINCH_CHEST)
		self.NextFlinch = CurTime() + 0.5
	end
	if (string.find(self:GetModel(),"skeleton")) then
		if (self:GetSkin() == 3) then
			ParticleEffect( "spell_skeleton_goop_green", dmginfo:GetDamagePosition(), self:GetAngles() )
		elseif (self:GetSkin() == 2) then
			ParticleEffect( "spell_skeleton_goop_green", dmginfo:GetDamagePosition(), self:GetAngles() )
		elseif (self:GetSkin() == 0) then
			ParticleEffect( "spell_pumpkin_mirv_goop_red", dmginfo:GetDamagePosition(), self:GetAngles() )
		elseif (self:GetSkin() == 1) then
			ParticleEffect( "spell_pumpkin_mirv_goop_blue", dmginfo:GetDamagePosition(), self:GetAngles() )
		end
	end
end

function ENT:OnKilled( dmginfo )

	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )

	local pos = self:GetPos()
		ParticleEffect( "halloween_boss_death", self:GetPos(), self:GetAngles() )
		self:EmitSound("misc/halloween/spell_meteor_impact.wav")
		self:EmitSound("misc/halloween/spell_spawn_boss.wav")
			local theskin = self:GetSkin()
			for i=1,3 do 
				timer.Simple(math.Rand(2,2.5), function()
					local mini_skeleton = ents.Create("npc_tf_zombie")
					local pos2 = pos + Vector(math.random(-32,32),math.random(-32,32),0) * math.random(1,6)
					mini_skeleton:SetPos(pos2)
					if (theskin == 3) then
						ParticleEffect( "spell_skeleton_goop_green", pos2, mini_skeleton:GetAngles() )
					elseif (theskin == 2) then
						ParticleEffect( "spell_skeleton_goop_green", pos2, mini_skeleton:GetAngles() )
					elseif (theskin == 0) then
						ParticleEffect( "spell_pumpkin_mirv_goop_red", pos2, mini_skeleton:GetAngles() )
					elseif (theskin == 1) then
						ParticleEffect( "spell_pumpkin_mirv_goop_blue", pos2, mini_skeleton:GetAngles() )
					end
					mini_skeleton:EmitSound("Cleaver.ImpactFlesh")
					mini_skeleton:Spawn()
					mini_skeleton:Activate()
					mini_skeleton.AttackDamage = 20
					mini_skeleton.AttackRange = 40
					timer.Simple(0.25, function()
						if (theskin != 2) then
							mini_skeleton:SetSkin(theskin)
						end
					end)
				end)
			end
	self:SetHealth(5000)
	self:PrecacheGibs()
	self:GibBreakClient(dmginfo:GetDamageForce() * 0.05)
	self:EmitSound("Halloween.skeleton_break")
	self:Remove()
end
function ENT:GetHat()
	return self:GetNWEntity("Hat")
end

list.Set( "NPC", "npc_tf_zombie_boss", {
	Name = "SKELETON KING",
	Class = "npc_tf_zombie_boss",
	Category = "TF2: Halloween"
}) 