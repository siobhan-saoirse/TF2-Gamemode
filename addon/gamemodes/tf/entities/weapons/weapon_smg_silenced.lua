
if (!IsMounted("left4dead2")) then return end
AddCSLuaFile()
SWEP.Category = "Left 4 Dead 2"
SWEP.PrintName = "Silenced SMG"
SWEP.Author = "Daisreich"
SWEP.IsL4DWeapon = true
SWEP.Slot = 0
SWEP.SlotPos = 4

SWEP.Spawnable = true

SWEP.ViewModel = Model( "models/v_models/v_silenced_smg.mdl" )
SWEP.WorldModel = "models/w_models/weapons/w_smg_a.mdl"
SWEP.ViewModelFOV = 50
SWEP.UseHands = true
SWEP.HoldType = "AR2"
SWEP.Primary.Delay = 0.06
SWEP.Primary.ClipSize = 50  -- How much bullets are in the mag
SWEP.Primary.DefaultClip = 150 -- How much bullets preloaded when spawned
SWEP.Primary.Damage = 28
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Spread = 0.9
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Ammo = "SMG1"
SWEP.Primary.Recoil = 0.25
SWEP.Primary.Automatic = true
SWEP.Secondary.Automatic = true
SWEP.WeaponSkin = 0

SWEP.HitDistance = 48
SWEP.ShootSound = Sound("SMG_Silenced.Fire")
if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)

	-- Settings...
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
            -- Specify a good position
			WorldModel:SetSkin(self.WeaponSkin)
			WorldModel:SetModel(self.WorldModel)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") or _Owner:LookupBone("weapon_bone") -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local offsetVec = Vector(0, -2, 0)
			local offsetAng = Angle(170, 180, 0)
			if (boneid == _Owner:LookupBone("weapon_bone")) then
				local offsetVec = Vector(0, -2, 5)
				local offsetAng = Angle(-90, -90, 0)
				local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

				WorldModel:SetPos(newPos)
				WorldModel:SetAngles(newAng)

				WorldModel:SetupBones()
				
			else
				local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

				WorldModel:SetPos(newPos)
				WorldModel:SetAngles(newAng)

				WorldModel:SetupBones()
			end
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end

function SWEP:Deploy()
	self:SetWeaponHoldType( self.HoldType )
	if SERVER then
		self:SendWeaponAnim(ACT_VM_DEPLOY)
	end
	local vm = self:GetOwner():GetViewModel()
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:SelectWeightedSequence(ACT_VM_DEPLOY)) , 1, function()
		self:SendWeaponAnim(ACT_VM_IDLE)
	end)
	return true
end 

function SWEP:Holster()

	self:SetNextMeleeAttack( 0 )

	return true

end

function SWEP:SetupDataTables()

	self:NetworkVar( "Float", 0, "NextMeleeAttack" )
	self:NetworkVar( "Float", 1, "NextIdle" )
	self:NetworkVar( "Int", 2, "Combo" )

end

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end 

function SWEP:PrimaryAttack()
 
	if ( !self:CanPrimaryAttack() ) then return end
	 
	local bullet = {} 
	bullet.Num = self.Primary.NumberofShots 
	bullet.Src = self.Owner:GetShootPos() 
	bullet.Dir = self.Owner:GetAimVector() 
	bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
	bullet.Tracer = 1
	bullet.Force = self.Primary.Force 
	bullet.Damage = self.Primary.Damage 
	bullet.AmmoType = self.Primary.Ammo 
	 
	local rnda = self.Primary.Recoil * -1 
	local rndb = self.Primary.Recoil * math.random(-1, 1) 
	 
	self:ShootEffects()
	 
	self.Owner:FireBullets( bullet ) 
	self:EmitSound(self.ShootSound, 75)	
	self.Owner:ViewPunch( Angle( rnda,0,0 ) ) 
	self:TakePrimaryAmmo(self.Primary.TakeAmmo) 
	 
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay ) 
	timer.Stop("Idle"..self.Owner:EntIndex())
	local vm = self:GetOwner():GetViewModel()
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:SelectWeightedSequence(ACT_VM_PRIMARYATTACK)) , 1, function()
		self:SendWeaponAnim(ACT_VM_IDLE)
	end)
end 

function SWEP:CalcViewModelView(vm, oldpos, oldang, newpos, newang)
	return oldpos, oldang
end

local function CopyPoseParams(pEntityFrom, pEntityTo)
	if (SERVER) then
		for i = 0, pEntityFrom:GetNumPoseParameters() - 1 do
			local sPose = pEntityFrom:GetPoseParameterName(i)
			pEntityTo:SetPoseParameter(sPose, pEntityFrom:GetPoseParameter(sPose))
		end
	else
		for i = 0, pEntityFrom:GetNumPoseParameters() - 1 do
			local flMin, flMax = pEntityFrom:GetPoseParameterRange(i)
			local sPose = pEntityFrom:GetPoseParameterName(i)
			pEntityTo:SetPoseParameter(sPose, math.Remap(pEntityFrom:GetPoseParameter(sPose), 0, 1, flMin, flMax))
		end
	end
end

function SWEP:SecondaryAttack( right )
	if SERVER then
		self.Owner:DoAnimationEvent( ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,true,true )
	end

	local anim = "melee"

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( anim ) )

	self:EmitSound( ")player/survivor/swing/swish_weaponswing_swipe"..math.random(5,6)..".wav", 75, 100 )

	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:LookupSequence("melee")) , 1, function()
		self:SendWeaponAnim(ACT_VM_IDLE)
	end)
	self:SetNextMeleeAttack( CurTime() + 0.1 )

	self:SetNextPrimaryFire( CurTime() + 0.7 )
	self:SetNextSecondaryFire( CurTime() + 0.7 )

end

local phys_pushscale = GetConVar( "phys_pushscale" )

function SWEP:DealDamage()

	local anim = self:GetSequenceName(self.Owner:GetViewModel():GetSequence())

	self.Owner:LagCompensation( true )

	local tr = util.TraceLine( {
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	} )

	if ( !IsValid( tr.Entity ) ) then
		tr = util.TraceHull( {
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
			filter = self.Owner,
			mins = Vector( -10, -10, -8 ),
			maxs = Vector( 10, 10, 8 ),
			mask = MASK_SHOT_HULL
		} )
	end

	-- We need the second part for single player because SWEP:Think is ran shared in SP
	if ( (IsValid(tr.Entity) and !tr.Entity:IsTFPlayer()) or tr.HitWorld ) then
		if SERVER then
			self.Owner:EmitSound( "player/survivor/hit/rifle_swing_hit_world.wav", 75, 100 )
		end
	end

	local hit = false
	local scale = phys_pushscale:GetFloat()

	if ( SERVER && IsValid( tr.Entity ) && ( tr.Entity:IsNPC() || tr.Entity:IsPlayer() || tr.Entity:Health() > 0 ) ) then
		if (!self.Owner:IsFriendly(tr.Entity)) then
			if (string.find(tr.Entity:GetModel(),"clown")) then
				self.Owner:EmitSound( table.Random({
					"player/survivor/hit/rifle_swing_hit_clown.wav",
					"player/survivor/hit/rifle_swing_hit_clown2.wav",
					"player/survivor/hit/rifle_swing_hit_clown3.wav",
					"player/survivor/hit/rifle_swing_hit_clown4.wav",
					"player/survivor/hit/rifle_swing_hit_clown5.wav",
					"player/survivor/hit/rifle_swing_hit_clown6.wav",
				}), 75, 100 )
			else
				self.Owner:EmitSound( table.Random({
					"player/survivor/hit/rifle_swing_hit_infected7.wav",
					"player/survivor/hit/rifle_swing_hit_infected8.wav",
					"player/survivor/hit/rifle_swing_hit_infected9.wav",
					"player/survivor/hit/rifle_swing_hit_infected10.wav",
					"player/survivor/hit/rifle_swing_hit_infected11.wav",
					"player/survivor/hit/rifle_swing_hit_infected12.wav"
				}), 75, 100 )
			end
		else
			self.Owner:EmitSound( table.Random({
				"player/survivor/hit/rifle_swing_hit_survivor1.wav",
				"player/survivor/hit/rifle_swing_hit_survivor2.wav"
			}), 75, 100 )
		end
		local dmginfo = DamageInfo()

		local attacker = self.Owner
		if ( !IsValid( attacker ) ) then attacker = self end
		dmginfo:SetAttacker( attacker )

		dmginfo:SetInflictor( self )
		dmginfo:SetDamage( 25 )
		dmginfo:SetDamageType(DMG_CLUB)
		dmginfo:SetDamageForce( self.Owner:GetRight() * 4912 * scale + self.Owner:GetForward() * 9998 * scale ) -- Yes we need those specific numbers
		SuppressHostEvents( NULL ) -- Let the breakable gibs spawn in multiplayer on client
		tr.Entity:TakeDamageInfo( dmginfo )
		SuppressHostEvents( self.Owner )
		if (!hit) then

			if (tr.Entity:IsNPC()) then
				if (string.find(tr.Entity:GetClass(),"l4d")) then
					if SERVER then
						if (string.find(tr.Entity:GetModel(),"boomer") or string.find(tr.Entity:GetModel(),"hunter") or string.find(tr.Entity:GetModel(),"common")) then
							if (string.find(tr.Entity:GetModel(),"common")) then
								
								local posA = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetForward() * 115
								local posB = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetForward() * -115
								local posC = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetRight() * -115
								local posD = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetRight() * 115
								local posTable = {posA,posB,posC,posD}
								local dist = 99999999999
								local pos = nil
								for _,v in ipairs(posTable) do
									if (v:Distance(self.Owner:GetPos()) < dist) then
										dist = v:Distance(self.Owner:GetPos())
										pos = v
									end
								end
								if pos == nil then return end
								local anim = (pos == posA && "Shoved_Backward_"..table.Random({"01","02","03","04e","04g","04i","04j","04m","04o"})) or (pos == posB && "Shoved_Forward_01") or (pos == posC && "Shoved_Rightward_01") or (pos == posD && "Shoved_Leftward_01") 
								tr.Entity.Flinching = true
								tr.Entity.PlayingAttackAnimation = false
								tr.Entity:EmitSound("Zombie.Shoved")
								tr.Entity:VJ_ACT_PLAYACTIVITY(anim,true,tr.Entity:SequenceDuration(tr.Entity:LookupSequence(anim)),true)
								timer.Simple(tr.Entity:SequenceDuration(tr.Entity:LookupSequence(anim)), function()
									tr.Entity.Flinching = false
								end)
							else
								local posA = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetForward() * 115
								local posB = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetForward() * -115
								local posC = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetRight() * -115
								local posD = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetRight() * 115
								local posTable = {posA,posB,posC,posD}
								local dist = 99999999999
								local pos = nil
								for _,v in ipairs(posTable) do
									if (v:Distance(self.Owner:GetPos()) < dist) then
										dist = v:Distance(self.Owner:GetPos())
										pos = v
									end
								end
								if pos == nil then return end
								local anim = (pos == posA && "Shoved_Backward_01") or (pos == posB && "Shoved_Forward") or (pos == posC && "Shoved_Rightward") or (pos == posD && "Shoved_Leftward") 
								tr.Entity.Flinching = true
								tr.Entity.PlayingAttackAnimation = false
								tr.Entity:VJ_ACT_PLAYACTIVITY(anim,true,tr.Entity:SequenceDuration(tr.Entity:LookupSequence(anim)),true)
								timer.Simple(tr.Entity:SequenceDuration(tr.Entity:LookupSequence(anim)) - 0.2, function()
									tr.Entity.Flinching = false
								end)
							end
						else
							local posA = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetForward() * 115
							local posB = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetForward() * -115
							local posC = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetRight() * -115
							local posD = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetRight() * 115
							local posTable = {posA,posB,posC,posD}
							local dist = 99999999999
							local pos = nil
							for _,v in ipairs(posTable) do
								if (v:Distance(self.Owner:GetPos()) < dist) then
									dist = v:Distance(self.Owner:GetPos())
									pos = v
								end
							end
							if pos == nil then return end
							local anim = (pos == posA && "Shoved_Backward") or (pos == posB && "Shoved_Forward") or (pos == posC && "Shoved_Rightward") or (pos == posD && "Shoved_Leftward") 
							tr.Entity.Flinching = true
							tr.Entity.PlayingAttackAnimation = false
							tr.Entity:EmitSound("Zombie.Shoved")
							tr.Entity:VJ_ACT_PLAYACTIVITY(anim,true,tr.Entity:SequenceDuration(tr.Entity:LookupSequence(anim)),true)
							timer.Simple(tr.Entity.ShovedAnimation:SequenceDuration(tr.Entity:LookupSequence(anim)) - 0.2, function()
								tr.Entity.ShovedAnimation.Flinching = false
							end)
						end
					end
				end
			end
			if (tr.Entity:IsPlayer()) then
				if (tr.Entity:GetPlayerClass() == "boomer" or tr.Entity:GetPlayerClass() == "hunter") then
					if (!tr.Entity.Shoved) then
						local ang = self.Owner:GetAngles()
						ang.z = 0
						--tr.Entity:SetAngles(ang + Angle(0,180,0))
						local posA = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetForward() * 115
						local posB = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetForward() * -115
						local posC = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetRight() * -115
						local posD = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetRight() * 115
						local posTable = {posA,posB,posC,posD}
						local dist = 99999999999
						local pos = nil
						for _,v in ipairs(posTable) do
							if (v:Distance(self.Owner:GetPos()) < dist) then
								dist = v:Distance(self.Owner:GetPos())
								pos = v
							end
						end
						if pos == nil then return end
						local anim = (pos == posA && "Shoved_Backward_01") or (pos == posB && "Shoved_Forward") or (pos == posC && "Shoved_Rightward") or (pos == posD && "Shoved_Leftward") 
						if SERVER then
							local animGuy = ents.Create("npc_vj_creature_base")
							animGuy:SetPos(tr.Entity:GetPos())
							animGuy:SetAngles(tr.Entity:GetAngles())
							animGuy:SetOwner(tr.Entity)
							tr.Entity:SetParent(animGuy)
							animGuy:SetModel(tr.Entity:GetModel())
							animGuy:Spawn()
							animGuy:Activate()
							animGuy.HasMeleeAttack = false
							tr.Entity.ShovedAnimation = animGuy
							timer.Stop("ShoveAnimation"..tr.Entity:EntIndex()) 
							timer.Create("ShoveAnimation"..tr.Entity:EntIndex(), 0.12, 0, function()
								animGuy.ShovedAnimation.Flinching = true
								animGuy.IsVJBaseSNPC = false
								tr.Entity.ShovedAnimation.PlayingAttackAnimation = false
								tr.Entity.ShovedAnimation:VJ_ACT_PLAYACTIVITY(anim,true,tr.Entity.ShovedAnimation:SequenceDuration(tr.Entity:LookupSequence(anim)),true)
								timer.Simple(tr.Entity.ShovedAnimation:SequenceDuration(tr.Entity:LookupSequence(anim)) - 0.2, function()
									tr.Entity.ShovedAnimation.Flinching = false
								end)
							end)
						end
						tr.Entity.Shoved = true
					end
					if (IsValid(tr.Entity.ShovedAnimation)) then
						local posA = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetForward() * 115
						local posB = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetForward() * -115
						local posC = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetRight() * -115
						local posD = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetRight() * 115
						local posTable = {posA,posB,posC,posD}
						local dist = 99999999999
						local pos = nil
						for _,v in ipairs(posTable) do
							if (v:Distance(self.Owner:GetPos()) < dist) then
								dist = v:Distance(self.Owner:GetPos())
								pos = v
							end
						end
						if pos == nil then return end
						local anim = (pos == posA && "Shoved_Backward_01") or (pos == posB && "Shoved_Forward") or (pos == posC && "Shoved_Rightward") or (pos == posD && "Shoved_Leftward") 
						if SERVER then
							timer.Stop("ShoveAnimation"..tr.Entity:EntIndex())
							timer.Create("ShoveAnimation"..tr.Entity:EntIndex(), 0.12, 0, function()
								tr.Entity.ShovedAnimation.IsVJBaseSNPC = false
							end) 
							tr.Entity.ShovedAnimation.IsVJBaseSNPC = false
							tr.Entity.ShovedAnimation.Flinching = true
							tr.Entity.ShovedAnimation.PlayingAttackAnimation = false
							tr.Entity.ShovedAnimation:VJ_ACT_PLAYACTIVITY(anim,true,tr.Entity.ShovedAnimation:SequenceDuration(tr.Entity:LookupSequence(anim)),true)
							timer.Simple(tr.Entity.ShovedAnimation:SequenceDuration(tr.Entity:LookupSequence(anim)) - 0.2, function()
								tr.Entity.ShovedAnimation.Flinching = false
							end)
						end
					end
					tr.Entity:SetNoDraw(true)
					tr.Entity:SetMoveType(MOVETYPE_NONE)
					tr.Entity:DoAnimationEvent(ACT_DOD_RELOAD_DEPLOYED_FG42)
					tr.Entity:SetNWBool("Taunting",true)
					if SERVER then
						net.Start("ActivateTauntCam")
						net.Send(tr.Entity)
					end
					timer.Stop("Shoved"..tr.Entity:EntIndex())
					timer.Stop("BoomerVomit"..tr.Entity:EntIndex())
					timer.Create("Shoved"..tr.Entity:EntIndex(), tr.Entity:SequenceDuration(tr.Entity:LookupSequence("Shoved_Backward_01")) + 0.8 , 1, function()
						tr.Entity:SetNWBool("Taunting", false)
						tr.Entity:SetMoveType(MOVETYPE_WALK)
						if SERVER then
							tr.Entity:SetParent()
							tr.Entity:SetNoDraw(false)
							tr.Entity.ShovedAnimation:Remove()
							net.Start("DeActivateTauntCam")
							net.Send(tr.Entity)
							tr.Entity.Shoved = false
						end
					end)
				else
					if (!string.find(tr.Entity:GetModel(),"hulk") && !string.find(tr.Entity:GetModel(),"charger")) then
						if (!tr.Entity.Shoved) then
							local posA = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetForward() * 115
							local posB = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetForward() * -115
							local posC = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetRight() * -115
							local posD = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetRight() * 115
							local posTable = {posA,posB,posC,posD}
							local dist = 99999999999
							local pos = nil
							for _,v in ipairs(posTable) do
								if (v:Distance(self.Owner:GetPos()) < dist) then
									dist = v:Distance(self.Owner:GetPos())
									pos = v
								end
							end
							if pos == nil then return end
							local anim = (pos == posA && "Shoved_Backward") or (pos == posB && "Shoved_Forward") or (pos == posC && "Shoved_Rightward") or (pos == posD && "Shoved_Leftward") 
							if SERVER then
								local animGuy = ents.Create("npc_vj_creature_base")
								animGuy:SetPos(tr.Entity:GetPos())
								--animGuy:SetAngles(ang + Angle(0,180,0))
								animGuy:SetAngles(tr.Entity:GetAngles())
								animGuy:SetOwner(tr.Entity)
								tr.Entity:SetParent(animGuy)
								animGuy:SetModel(tr.Entity:GetModel())
								animGuy:Spawn()
								animGuy:Activate()
								animGuy.IsVJBaseSNPC = false
								animGuy.HasMeleeAttack = false
								tr.Entity.ShovedAnimation = animGuy
								timer.Stop("ShoveAnimation"..tr.Entity:EntIndex()) 
								timer.Create("ShoveAnimation"..tr.Entity:EntIndex(), 0.12, 0, function()
									animGuy.IsVJBaseSNPC = false
								end)
								tr.Entity.ShovedAnimation.Flinching = true
								tr.Entity.ShovedAnimation.PlayingAttackAnimation = false
								tr.Entity.ShovedAnimation:VJ_ACT_PLAYACTIVITY(anim,true,tr.Entity.ShovedAnimation:SequenceDuration(tr.Entity:LookupSequence(anim)),true)
								timer.Simple(tr.Entity.ShovedAnimation:SequenceDuration(tr.Entity:LookupSequence(anim)), function()
									tr.Entity.ShovedAnimation.Flinching = false
								end)
							end
							tr.Entity.Shoved = true
						end
						if (IsValid(tr.Entity.ShovedAnimation)) then
							local posA = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetForward() * 115
							local posB = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetForward() * -115
							local posC = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetRight() * -115
							local posD = (tr.Entity:GetPos() + tr.Entity:OBBCenter()) + tr.Entity:GetRight() * 115
							local posTable = {posA,posB,posC,posD}
							local dist = 99999999999
							local pos = nil
							for _,v in ipairs(posTable) do
								if (v:Distance(self.Owner:GetPos()) < dist) then
									dist = v:Distance(self.Owner:GetPos())
									pos = v
								end
							end
							if pos == nil then return end
							local anim = (pos == posA && "Shoved_Backward") or (pos == posB && "Shoved_Forward") or (pos == posC && "Shoved_Rightward") or (pos == posD && "Shoved_Leftward") 
							if SERVER then
								timer.Stop("ShoveAnimation"..tr.Entity:EntIndex()) 
								timer.Create("ShoveAnimation"..tr.Entity:EntIndex(), 0.12, 0, function()
									tr.Entity.ShovedAnimation.IsVJBaseSNPC = false
								end)
									tr.Entity.ShovedAnimation.IsVJBaseSNPC = false
									tr.Entity.ShovedAnimation.Flinching = true
									tr.Entity.ShovedAnimation.PlayingAttackAnimation = false
									tr.Entity.ShovedAnimation:VJ_ACT_PLAYACTIVITY(anim,true,tr.Entity.ShovedAnimation:SequenceDuration(tr.Entity:LookupSequence(anim)),true)
									timer.Simple(tr.Entity.ShovedAnimation:SequenceDuration(tr.Entity:LookupSequence(anim)), function()
										tr.Entity.ShovedAnimation.Flinching = false
									end)
							end
						end
						tr.Entity:SetNoDraw(true)
						tr.Entity:SetMoveType(MOVETYPE_NONE)
						tr.Entity:DoAnimationEvent(ACT_DOD_DEPLOYED)
						tr.Entity:SetNWBool("Taunting",true)
						if SERVER then
							net.Start("ActivateTauntCam")
							net.Send(tr.Entity)
						end
						timer.Stop("Shoved"..tr.Entity:EntIndex())
						timer.Stop("BoomerVomit"..tr.Entity:EntIndex())
						timer.Stop("TongueAttack"..tr.Entity:EntIndex())
						timer.Create("Shoved"..tr.Entity:EntIndex(), tr.Entity:SequenceDuration(tr.Entity:LookupSequence("Shoved_Backward")) + 0.8 , 1, function()
							tr.Entity:SetNWBool("Taunting", false)
							tr.Entity:SetMoveType(MOVETYPE_WALK)
							if SERVER then
								tr.Entity:SetParent()
								tr.Entity:SetNoDraw(false)
								tr.Entity.ShovedAnimation:Remove()
								net.Start("DeActivateTauntCam")
								net.Send(tr.Entity)
								tr.Entity.Shoved = false
							end
						end)
					end
				end
			end
			hit = true
		end

	end

	if ( IsValid( tr.Entity ) ) then
		local phys = tr.Entity:GetPhysicsObject()
		if ( IsValid( phys ) ) then
			phys:ApplyForceOffset( self.Owner:GetAimVector() * 80 * phys:GetMass() * scale, tr.HitPos )
		end
	end

	if ( SERVER ) then
		if ( hit && anim != "fists_uppercut" ) then
			self:SetCombo( self:GetCombo() + 1 )
		else
			self:SetCombo( 0 )
		end
	end

	self.Owner:LagCompensation( false )

end

function SWEP:Think()
 
	local vm = self.Owner:GetViewModel()
	local curtime = CurTime()

	local meleetime = self:GetNextMeleeAttack()

	if ( meleetime > 0 && CurTime() > meleetime ) then

		self:DealDamage()

		self:SetNextMeleeAttack( 0 )

	end
	if SERVER then
		CopyPoseParams(self.Owner,vm)
	end
end


function SWEP:Reload()
	local vm = self:GetOwner():GetViewModel()
	self:DefaultReload(ACT_VM_RELOAD)
	if SERVER then
		if (string.find(self:GetClass(),"smg") or string.find(self:GetClass(),"rifle")) then
			self.Owner:DoAnimationEvent( ACT_HL2MP_GESTURE_RELOAD_SMG1,true,true )
			umsg.Start("PlaySMGWeaponWorldReload")
				umsg.Entity(self)
			umsg.End()
		end
	end
	timer.Stop("Idle"..self.Owner:EntIndex())
	timer.Create("Idle"..self.Owner:EntIndex(), vm:SequenceDuration(vm:SelectWeightedSequence(ACT_VM_RELOAD)) , 1, function()
		self:SendWeaponAnim(ACT_VM_IDLE)
	end)
end

	usermessage.Hook("PlaySMGWeaponWorldReload", function(msg)
		local w = msg:ReadEntity()
		
		if IsValid(w) and w.ReloadSound and (w.Owner ~= LocalPlayer() or LocalPlayer():ShouldDrawLocalPlayer()) then
			w.Owner:EmitSound("weapons/smg_silenced/gunother/smg_clip_out_1.wav",75)
			timer.Simple(0.8,function()
				w.Owner:EmitSound("weapons/smg_silenced/gunother/smg_clip_in_1.wav",75)
				timer.Simple(0.25,function()
					w.Owner:EmitSound("weapons/smg_silenced/gunother/smg_clip_locked_1.wav",75)
					timer.Simple(0.7,function()
						w.Owner:EmitSound("weapons/smg_silenced/gunother/smg_slideback_1.wav",75)
						timer.Simple(0.25,function()
							w.Owner:EmitSound("weapons/smg_silenced/gunother/smg_slideforward_1.wav",75)
						end)
					end)
				end)
			end)
		end
	end)