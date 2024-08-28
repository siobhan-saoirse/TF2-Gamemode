ENT.Base = "base_brush"
ENT.Type = "brush"


function ENT:Initialize()
	self.Team = 0
	self.Players = {}
end
 
function ENT:KeyValue(key,value)
	key = string.lower(key)

	if key=="teamnum" then
		self.Team = tonumber(value)
	end
end
function ENT:StartTouch(ent)
	if ent:IsPlayer() and ent:Team() == TEAM_RED then
		self.Players[ent] = -1
		if ent:GetPlayerClass() == "scout" then
			ent:SetArmor(2000)
		elseif ent:GetPlayerClass() == "soldier" then
			ent:SetArmor(2950)
		elseif ent:GetPlayerClass() == "gmodplayer" then
			ent:SetArmor(2950)
		elseif ent:GetPlayerClass() == "pyro" then
			ent:SetArmor(2220)
		elseif ent:GetPlayerClass() == "demoman" then
			ent:SetArmor(2220)
		elseif ent:GetPlayerClass() == "heavy" then
			ent:SetArmor(2320)
		elseif ent:GetPlayerClass() == "engineer" then
			ent:SetArmor(2420)
		elseif ent:GetPlayerClass() == "medic" then
			ent:SetArmor(2620)
		elseif ent:GetPlayerClass() == "sniper" then
			ent:SetArmor(2420)
		elseif ent:GetPlayerClass() == "spy" then
			ent:SetArmor(2920)
		end
		for _,currentweapon in ipairs(ent:GetWeapons()) do
			if (IsValid(currentweapon)) then
				if (currentweapon.Primary and currentweapon.Secondary and currentweapon.ReloadTime) then
					if (!currentweapon.Primary.OldDelay and !currentweapon.Secondary.OldDelay and !currentweapon.OldReloadTime) then
						currentweapon.Primary.OldDelay          = currentweapon.Primary.Delay
						currentweapon.Secondary.OldDelay          = currentweapon.Secondary.Delay 
						currentweapon.OldReloadTime          = currentweapon.ReloadTime
					end
					currentweapon.Primary.FastDelay          = currentweapon.Primary.OldDelay * 0.6 
					currentweapon.Secondary.FastDelay          = currentweapon.Secondary.OldDelay * 0.6
					currentweapon.Primary.Delay          = currentweapon.Primary.FastDelay
					currentweapon.Secondary.Delay          = currentweapon.Secondary.FastDelay
					currentweapon.FastReloadTime          = currentweapon.OldReloadTime * 0.4
					if (currentweapon.BaseDamage) then
						if (!currentweapon.OldBaseDamage) then
							currentweapon.ProjectileDamageMultiplier = 2.0
							currentweapon.OldBaseDamage = currentweapon.BaseDamage
							currentweapon.BaseDamage = currentweapon.OldBaseDamage * 2.0
						end
					end
					if (currentweapon.ReloadStartTime) then
						if (!currentweapon.FastReloadStartTime) then
							currentweapon.FastReloadStartTime          = currentweapon.ReloadStartTime * 0.6
						end
					elseif (currentweapon.Primary.ClipSize) then
						if (!currentweapon.Primary.OldClipSize) then
							currentweapon.Primary.OldClipSize          = currentweapon.Primary.ClipSize
							currentweapon.Primary.ClipSize          = currentweapon.Primary.OldClipSize * 3.0
						end
						currentweapon:SetClip1(currentweapon.Primary.ClipSize)
					end
				end
			end
		end
			ent.AmmoMax[TF_PRIMARY] = math.Round(ent.AmmoMax[TF_PRIMARY] * 2.5)
			ent.AmmoMax[TF_SECONDARY] = math.Round(ent.AmmoMax[TF_SECONDARY] * 2.5)
			ent.AmmoMax[TF_GRENADES1] = math.Round(ent.AmmoMax[TF_GRENADES1] * 7.0)
			ent.AmmoMax[TF_METAL] = math.Round(ent.AmmoMax[TF_METAL] * 3.0)

		GAMEMODE:GiveAmmoPercent(ent,100)
		ent:EmitSound("MVM.PlayerUpgraded")
	end
end

function ENT:EndTouch(ent)
	if ent:IsPlayer() then
		self.Players[ent] = nil
		ent:Speak("TLK_MVM_UPGRADE_COMPLETE")
	end
end
