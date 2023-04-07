CLASS.Name = "Sentry Buster"
CLASS.Speed = 400
CLASS.Health = 3600

if CLIENT then
	CLASS.CharacterImage = {
		surface.GetTextureID("vgui/entities/npc_mvm_sentrybuster"),
		surface.GetTextureID("vgui/entities/npc_mvm_sentrybuster")
	}
	CLASS.ScoreboardImage = {
		surface.GetTextureID("hud/leaderboard_class_sentry_buster"),
		surface.GetTextureID("hud/leaderboard_class_sentry_buster")
	}
end

CLASS.Loadout = {"tf_weapon_grenadelauncher", "tf_weapon_pipebomblauncher", "tf_weapon_bottle"}
CLASS.DefaultLoadout = {"Ullapool Caber"}
CLASS.ModelName = "demo"

CLASS.Gibs = {
	[GIB_LEFTLEG]		= GIBS_DEMOMAN_START,
	[GIB_RIGHTLEG]		= GIBS_DEMOMAN_START+1,
	[GIB_LEFTARM]		= GIBS_DEMOMAN_START+2,
	[GIB_RIGHTARM]		= GIBS_DEMOMAN_START+3,
	[GIB_TORSO]			= GIBS_DEMOMAN_START+4,
	[GIB_HEAD]			= GIBS_DEMOMAN_START+5,
	[GIB_ORGAN]			= GIBS_ORGANS_START,
}

CLASS.Sounds = {
	paincrticialdeath = {
		Sound("vo/demoman_paincrticialdeath01.wav"),
		Sound("vo/demoman_paincrticialdeath02.wav"),
		Sound("vo/demoman_paincrticialdeath03.wav"),
		Sound("vo/demoman_paincrticialdeath04.wav"),
		Sound("vo/demoman_paincrticialdeath05.wav"),
	},
	painsevere = {
		Sound("vo/demoman_painsevere01.wav"),
		Sound("vo/demoman_painsevere02.wav"),
		Sound("vo/demoman_painsevere03.wav"),
		Sound("vo/demoman_painsevere04.wav"),
	},
	painsharp = {
		Sound("vo/demoman_painsharp01.wav"),
		Sound("vo/demoman_painsharp02.wav"),
		Sound("vo/demoman_painsharp03.wav"),
		Sound("vo/demoman_painsharp04.wav"),
		Sound("vo/demoman_painsharp05.wav"),
		Sound("vo/demoman_painsharp06.wav"),
		Sound("vo/demoman_painsharp07.wav"),
	},
}

CLASS.AmmoMax = {
	[TF_PRIMARY]	= 16,		-- primary
	[TF_SECONDARY]	= 24,		-- secondary
	[TF_METAL]		= 100,		-- metal
	[TF_GRENADES1]	= 0,		-- grenades1
	[TF_GRENADES2]	= 0,		-- grenades2
}

if SERVER then

	function CLASS:Initialize()
		self:SetModel("models/bots/demo/bot_sentry_buster.mdl")
		self:SetModelScale(1.75)
		self:SetViewOffset(Vector(0, 0, 126))
			for k,v in pairs(player.GetAll()) do
				if not v:IsFriendly(self) and v:Alive() and not v:IsHL2() then
					if v:GetPlayerClass() == "heavy" then
						v:EmitSound("vo/heavy_mvm_sentry_buster01.mp3", 85, 100, 1, CHAN_REPLACE)
					elseif v:GetPlayerClass() == "medic" then
						v:EmitSound("vo/medic_mvm_sentry_buster01.mp3", 85, 100, 1, CHAN_REPLACE)
					elseif v:GetPlayerClass() == "soldier" then
						v:EmitSound("vo/soldier_mvm_sentry_buster01.mp3", 85, 100, 1, CHAN_REPLACE)
					elseif v:GetPlayerClass() == "engineer" then
						v:EmitSound("vo/engineer_mvm_sentry_buster01.mp3", 85, 100, 1, CHAN_REPLACE)
					end
				end
			end
			for k,v in ipairs(player.GetAll()) do
				v:EmitSound("Announcer.MVM_Sentry_Buster_Alert")
			end
			self:EmitSound("MVM.SentryBusterIntro")
			self:EmitSound("BusterLoop")
			self:SetModel("models/bots/demo/bot_sentry_buster.mdl")
			self:SetHealth(3600)
			self:StripWeapon("tf_weapon_grenadelauncher")
			self:StripWeapon("tf_weapon_pipebomblauncher")
			self:SetModelScale(1.75)

			timer.Create("SentryBusterIntroLoop", 4, 0, function()
				if not self:Alive() then timer.Stop("SentryBusterIntroLoop") return end
				if self:GetPlayerClass() != "sentrybuster"	then timer.Stop("SentryBusterIntroLoop") return end
				self:EmitSound("MVM.SentryBusterIntro")
			end)
		
			timer.Create("SentryBusterExplodeNearSentry"..self:EntIndex(), 0.1, 0, function()
				if !self:Alive() then timer.Stop("SentryBusterExplodeNearSentry"..self:EntIndex()) return end
				if self:GetPlayerClass() != "sentrybuster"	then timer.Stop("SentryBusterExplodeNearSentry"..self:EntIndex()) return end
				if self:GetPlayerClass() != "sentrybuster"	then return end
				for _,building in pairs(ents.FindInSphere(self:GetPos(), 80)) do
					if building:GetClass() == "obj_sentrygun" then	
					self:SetNoDraw(true)
					self:EmitSound("MVM.SentryBusterSpin")
					self:SetNWBool("Taunting", true)
					self:SetNWBool("NoWeapon", true)
					net.Start("ActivateTauntCam")
					net.Send(self)
					local animent = ents.Create( 'base_gmodentity' ) -- The entity used as a reference for the bone positioning
					animent:SetModel( self:GetModel() )
					animent:SetModelScale( self:GetModelScale() )
					timer.Create("SetAnimPos", 0.01, 0, function()
						if not animent:IsValid() then timer.Stop("SetAnimPos") return end
						animent:SetPos( self:GetPos() )
						animent:SetAngles( self:GetAngles() )
					end )
					animent:SetNoDraw( false ) -- The ragdoll is the thing getting seen
					animent:Spawn()
										
					animent:SetSequence( "sentry_buster_preexplode" ) -- If the sequence isn't valid, the sequence length is 0, so the timer takes care of things
					animent:SetPlaybackRate( 1 )
					animent.AutomaticFrameAdvance = true
											
					animent:SetSolid( SOLID_OBB ) -- This stuff isn't really needed, but just for physics
					animent:PhysicsInit( SOLID_OBB )
					animent:SetMoveType( MOVETYPE_FLYGRAVITY )
					animent:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
					animent:PhysWake()
										
					function animent:Think() -- This makes the animation work
						self:NextThink( CurTime() )
						return true
					end
					timer.Simple(2.5, function()
						ParticleEffect("asplode_hoodoo_shockwave", self:GetPos() + Vector(0,0,35), self:GetAngles())
						ParticleEffect("asplode_hoodoo_shockwave", self:GetPos() + Vector(0,0,35), self:GetAngles())
						ParticleEffect("asplode_hoodoo_shockwave", self:GetPos() + Vector(0,0,35), self:GetAngles())
						ParticleEffect("asplode_hoodoo_shockwave", self:GetPos() + Vector(0,0,35), self:GetAngles())
										
						ParticleEffect("cinefx_goldrush_flash", self:GetPos(), self:GetAngles())
							ParticleEffect("fireSmoke_Collumn_mvmAcres", self:GetPos(), Angle())
						ParticleEffect("fluidSmokeExpl_ring_mvm", self:GetPos() + Vector(50,50,25), self:GetAngles())
						ParticleEffect("fluidSmokeExpl_ring_mvm", self:GetPos() + Vector(-50,-50,25), self:GetAngles())
						ParticleEffect("fluidSmokeExpl_ring_mvm", self:GetPos() + Vector(-50,50,25), self:GetAngles())
						ParticleEffect("fluidSmokeExpl_ring_mvm", self:GetPos() + Vector(50,-50,25), self:GetAngles())

						ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", self:GetPos() + Vector(50,50,25), self:GetAngles())
						ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", self:GetPos() + Vector(-50,-50,25), self:GetAngles())
						ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", self:GetPos() + Vector(-50,50,25), self:GetAngles())
						ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", self:GetPos() + Vector(50,-50,25), self:GetAngles())

						if animent:IsValid() then
							animent:Remove() 
						end

						self:EmitSound("MvM.SentryBusterExplode")
						self:EmitSound("MvM.SentryBusterExplode")
						self:EmitSound("MvM.SentryBusterExplode")
						self:SetNoDraw(false)

						self:SetNWBool("Taunting", false)
						self:SetNWBool("NoWeapon", false)
						net.Start("DeActivateTauntCam")
						net.Send(self)
						if self:GetRagdollEntity():IsValid() then
							self:GetRagdollEntity():Remove()
						end
						for k,v in pairs(ents.FindInSphere(self:GetPos(), 800)) do 
							if !v:IsPlayer() and v:Health() >= 0 and not v:IsFriendly(self) then
								v:TakeDamage( v:Health(), self, self:GetActiveWeapon() )
							elseif v:IsPlayer() and not v:IsFriendly(self) and v:Alive() and v:Nick() != self:Nick() then
								v:TakeDamage( v:Health(), self, self:GetActiveWeapon() )
							end
						end
						self:TakeDamage( self:Health(), self, self:GetActiveWeapon() )
					end)
					timer.Stop("SentryBusterExplodeNearSentry"..self:EntIndex())
					end
				end
			end)
			timer.Create("SentryBusterExplodeOnDeath", 0.1, 0, function()
				if !self:Alive() then timer.Stop("SentryBusterExplodeOnDeath"..self:EntIndex()) return end
				if self:GetPlayerClass() != "sentrybuster"	then timer.Stop("SentryBusterExplodeOnDeath"..self:EntIndex()) return end
				if self:GetPlayerClass() != "sentrybuster"	then return end
				if self:Health() <= 30 then
				self:EmitSound("MVM.SentryBusterSpin")
				timer.Simple(0.1, function()
				self:GodEnable()
				self:SetNoDraw(true)
				self:SetNWBool("Taunting", true)
				self:SetNWBool("NoWeapon", true)
				net.Start("ActivateTauntCam")
				local animent = ents.Create( 'base_gmodentity' ) -- The entity used as a reference for the bone positioning
				animent:SetModel( self:GetModel() )
				animent:SetModelScale( self:GetModelScale() )
				timer.Create("SetAnimPos", 0.01, 0, function()
					if not animent:IsValid() then timer.Stop("SetAnimPos") return end
					animent:SetPos( self:GetPos() )
					animent:SetAngles( self:GetAngles() )
				end )
				animent:SetNoDraw( false ) -- The ragdoll is the thing getting seen
				animent:Spawn()
	
				animent:SetSequence( "sentry_buster_preexplode" ) -- If the sequence isn't valid, the sequence length is 0, so the timer takes care of things
				animent:SetPlaybackRate( 1 )
				animent.AutomaticFrameAdvance = true
	
				animent:SetSolid( SOLID_OBB ) -- This stuff isn't really needed, but just for physics
				animent:PhysicsInit( SOLID_OBB )
				animent:SetMoveType( MOVETYPE_FLYGRAVITY )
				animent:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
				animent:PhysWake()
	
				function animent:Think() -- This makes the animation work
					self:NextThink( CurTime() - 5 )
					return true
				end
				timer.Simple(2, function()
					ParticleEffect("asplode_hoodoo_shockwave", self:GetPos() + Vector(0,0,35), self:GetAngles())
					ParticleEffect("asplode_hoodoo_shockwave", self:GetPos() + Vector(0,0,35), self:GetAngles())
					ParticleEffect("asplode_hoodoo_shockwave", self:GetPos() + Vector(0,0,35), self:GetAngles())
					ParticleEffect("asplode_hoodoo_shockwave", self:GetPos() + Vector(0,0,35), self:GetAngles())
	
					ParticleEffect("cinefx_goldrush_flash", self:GetPos(), self:GetAngles())
					ParticleEffect("fireSmoke_Collumn_mvmAcres", self:GetPos(), Angle())
					ParticleEffect("fluidSmokeExpl_ring_mvm", self:GetPos() + Vector(50,50,25), self:GetAngles())
					ParticleEffect("fluidSmokeExpl_ring_mvm", self:GetPos() + Vector(-50,-50,25), self:GetAngles())
					ParticleEffect("fluidSmokeExpl_ring_mvm", self:GetPos() + Vector(-50,50,25), self:GetAngles())
					ParticleEffect("fluidSmokeExpl_ring_mvm", self:GetPos() + Vector(50,-50,25), self:GetAngles())

					ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", self:GetPos() + Vector(50,50,25), self:GetAngles())
					ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", self:GetPos() + Vector(-50,-50,25), self:GetAngles())
					ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", self:GetPos() + Vector(-50,50,25), self:GetAngles())
					ParticleEffect("fireSmoke_Collumn_mvmAcres_sm", self:GetPos() + Vector(50,-50,25), self:GetAngles())
		
					if animent:IsValid() then
						animent:Remove()
					end
	
					self:EmitSound("MvM.SentryBusterExplode")
					self:SetNoDraw(false)
					self:GodDisable()

					self:SetNWBool("Taunting", false)
					self:SetNWBool("NoWeapon", false)
					net.Start("DeActivateTauntCam")
					if self:GetRagdollEntity():IsValid() then
						self:GetRagdollEntity():Remove()
					end
					for k,v in pairs(ents.FindInSphere(self:GetPos(), 800)) do 
						if v:IsNPC() and not v:IsFriendly(self) then
							v:TakeDamage( v:Health(), self, self:GetActiveWeapon() )
						elseif v:IsPlayer() and not v:IsFriendly(self) and self:Alive() then
							v:TakeDamage( v:Health(), self, self:GetActiveWeapon() )
						end
					end
					self:Kill()
				end)
				end)
				timer.Stop("SentryBusterExplodeOnDeath")
				end
			end)
	end
	
end
