hook.Add("Move", "TFMove", function(pl, move)
	if CLIENT and not pl.TempAttributes then
		pl.TempAttributes = {}
	end
	
	if pl:IsHL2() then return end
	
	-- Players run 10% slower when moving backwards
	local fwd = move:GetForwardSpeed()
	if fwd<0 and not pl:IsHL2() then
		local sp = -pl:GetRunSpeed() * 0.9
		if fwd<sp then
			--move:SetForwardSpeed(sp)
  			if not pl:Crouching() then 
  				move:SetMaxSpeed(math.abs(-pl:GetRunSpeed() * 0.9 ))
  				move:SetMaxClientSpeed(math.abs(-pl:GetRunSpeed() * 0.9 ))
  			end
		end
	end
	
	if pl:OnGround() then
		pl.Jumps=0
		pl.DoubleJumping = nil
	end
	
	if pl:KeyPressed(IN_JUMP) and pl.playerclass == "Scout" and pl:GetPlayerClass() != "spy" and not pl.TempAttributes.DisableDoubleJump then
		local vel = move:GetVelocity()
		if not pl:OnGround() then
			if not pl.Jumps then pl.Jumps = 0 end
			if pl.Jumps < 1 then
				local forward = pl:GetForward()
				forward.z = 0
				forward:Normalize()
				
				local right = pl:GetRight()
				right.z = 0
				right:Normalize()
				
				local vel = Vector(0, 0, 0)
				--vel = vel + pl.PlayerJumpPower * vector_up -- Add vertical force
				vel = vel + pl:GetJumpPower() * vector_up -- Add vertical force
				
				local spd = pl:GetRealClassSpeed()
				
				if pl:KeyDown(IN_FORWARD) then
					vel = vel + forward * spd
				elseif pl:KeyDown(IN_BACK) then
					vel = vel - forward * spd
				end
		
				if pl:KeyDown(IN_MOVERIGHT) then
					vel = vel + right * spd
				elseif pl:KeyDown(IN_MOVELEFT) then
					vel = vel - right * spd
				end

				move:SetVelocity(vel)
								
				--pl:SetAnimation(10002)
				pl:DoAnimationEvent(ACT_MP_DOUBLEJUMP, true)
				
				pl.Jumps = pl.Jumps + 1
				pl.DoubleJumping = true
			end
		end
		
		--MsgFN("Velocity : %f %f %f", vel.x, vel.y, vel.z)
		--MsgFN("On ground : %s", tostring(pl:OnGround()))
	end
end)

hook.Add("SetupMove", "TFSetupMove", function(pl, move)
	if pl:IsHL2() then return end

	-- Can't move when crouched in the loser state
	if pl:Crouching() then
		if pl:IsLoser() then
			move:SetForwardSpeed(0)
			move:SetSideSpeed(0)
		end
	end
	
	-- Fixes the 50% speed boost when jumping (probably residual code from HL2)
	if pl:OnGround() then
		pl.__JumpFixDone = false
	elseif not pl.__JumpFixDone then
		local vel = move:GetVelocity()
		
		local length = vel:Length2D()
		local max = pl:GetRealClassSpeed()
		
		if length > max then
			local r = max / length
			vel.x = vel.x * r
			vel.y = vel.y * r
			
			move:SetVelocity(vel)
		end
		
		pl.__JumpFixDone = true
	end
end)

--[[
local function GetAdditionalJumpCount(pl)
	local t = pl:GetPlayerClassTable()
	local j = 0
	
	if t and t.AdditionalJumpCount then
		j = t.AdditionalJumpCount
	end
	
	j = math.max(0, j
end]]

--[[
hook.Add("KeyPress", "TFMultipleJump", function(pl, k)
	if not pl or not pl:IsValid() or pl:GetPlayerClass()~="scout" or k~=IN_JUMP then
		return
	end
	
	if pl.TempAttributes and pl.TempAttributes.DisableDoubleJump then
		return
	end
	
	if not pl.Jumps or pl:IsOnGround() then
		pl.Jumps=0
	end

	if pl.Jumps==0 and not pl:IsOnGround() then
		pl.Jumps = 1
	end
	
	if pl.Jumps>=2 then return end
	
	pl.Jumps = pl.Jumps + 1
	if pl.Jumps>1 then
		local forward = pl:GetForward()
		forward.z = 0
		forward:Normalize()
		
		local right = pl:GetRight()
		right.z = 0
		right:Normalize()
		
		local vel = -1 * pl:GetVelocity() -- Nullify current velocity
		vel = vel + pl.PlayerJumpPower * vector_up -- Add vertical force
		
		local spd = pl:GetRealClassSpeed()
		
		if pl:KeyDown(IN_FORWARD) then
			vel = vel + forward * spd
		elseif pl:KeyDown(IN_BACK) then
			vel = vel - forward * spd
		end
		
		if pl:KeyDown(IN_MOVERIGHT) then
			vel = vel + right * spd
		elseif pl:KeyDown(IN_MOVELEFT) then
			vel = vel - right * spd
		end
		
		pl:SetVelocity(vel)
		
		--pl:SetAnimation(10002)
		pl:DoAnimationEvent(ACT_MP_DOUBLEJUMP, true)
		
		pl.DoubleJumping = 1
	end
end)
]]
