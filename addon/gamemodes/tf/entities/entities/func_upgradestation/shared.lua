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
			ent:SetHealth(125 + 150)
			ent:SetMaxHealth(125 + 150)
			ent:SetArmor(520)
		elseif ent:GetPlayerClass() == "soldier" then
			ent:SetHealth(200 + 150)
			ent:SetMaxHealth(200 + 150)
			ent:SetArmor(550)
		elseif ent:GetPlayerClass() == "pyro" then
			ent:SetHealth(175 + 150)
			ent:SetMaxHealth(175 + 150)
			ent:SetArmor(520)
		elseif ent:GetPlayerClass() == "demoman" then
			ent:SetHealth(150 + 175)
			ent:SetMaxHealth(150 + 175)
			ent:SetArmor(520)
		elseif ent:GetPlayerClass() == "heavy" then
			ent:SetHealth(300 + 175)
			ent:SetMaxHealth(300 + 175)
			ent:SetArmor(570)
		elseif ent:GetPlayerClass() == "engineer" then
			ent:SetHealth(125 + 150)
			ent:SetMaxHealth(125 + 150)
			ent:SetArmor(520)
		elseif ent:GetPlayerClass() == "medic" then
			ent:SetHealth(175 + 150)
			ent:SetMaxHealth(175 + 150)
			ent:SetArmor(520)
		elseif ent:GetPlayerClass() == "sniper" then
			ent:SetHealth(125 + 150)
			ent:SetMaxHealth(125 + 150)
			ent:SetArmor(300)
		elseif ent:GetPlayerClass() == "spy" then
			ent:SetHealth(125 + 150)
			ent:SetMaxHealth(125 + 150)
			ent:SetArmor(330)
		end
		currentweapon = ent:GetActiveWeapon()
		if currentweapon:GetClass() == "tf_weapon_rocketlauncher" then
			currentweapon.Primary.Delay          = 0.5
			currentweapon.Primary.ClipSize		= 12
			currentweapon.ReloadTime = 0.2
			ent.AmmoMax[TF_PRIMARY] = 120
			ent:ConCommand("tf_upgradewep05clientonly")
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $300 dollars for their "..self:GetItemData().item_name)
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_rocketlauncher_bbox" then
			currentweapon.Primary.Delay          = 0.5
			currentweapon.Primary.ClipSize		= 12
			currentweapon.ReloadTime = 0.2
			ent:ConCommand("tf_upgradewep05clientonly")
			ent.AmmoMax[TF_PRIMARY] = 120
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $300 dollars for their "..self:GetItemData().item_name)
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_rocketlauncher_qrl" then
			currentweapon.Primary.Delay          = 0.5
			currentweapon.Primary.ClipSize		= 12
			currentweapon.ReloadTime = 0.2
			ent:ConCommand("tf_upgradewep05clientonly")
			ent.AmmoMax[TF_PRIMARY] = 120
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $300 dollars for their "..self:GetItemData().item_name)
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_rocketlauncher_dh" then
			currentweapon.Primary.Delay          = 0.5
			currentweapon.Primary.ClipSize		= 12
			currentweapon.ReloadTime = 0.2
			ent:ConCommand("tf_upgradewep05clientonly")
			ent.AmmoMax[TF_PRIMARY] = 120
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $300 dollars for their "..self:GetItemData().item_name)
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_rocketlauncher_airstrike" then
			currentweapon.Primary.Delay          = 0.2
			currentweapon.Primary.ClipSize		= 12
			currentweapon.ReloadTime = 0.2
			ent:ConCommand("tf_upgradewep03clientonly")
			ent.AmmoMax[TF_PRIMARY] = 120
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $300 dollars for their "..self:GetItemData().item_name)
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_minigun" then
			currentweapon.Primary.Delay          = 0.06
			currentweapon.BaseDamage = 6
			currentweapon.MaxDamageRampUp = 0.75
			currentweapon.MaxDamageFalloff = 0.6
			ent.AmmoMax[TF_PRIMARY] = 400
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $300 dollars for their "..self:GetItemData().item_name)
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_pda_engineer_build" then
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $300 dollars for their existing Buildings" )
			for k,v in pairs(ents.FindByClass("obj_sentrygun")) do
				if v:GetOwner() == ent then
					v.FireRate = 0.065
					v:SetHealth(862)
					v:SetMaxHealth(862)
				end
			end
			for k,v in pairs(ents.FindByClass("obj_dispenser")) do
				if v:GetOwner() == ent then
					v.Range = 320
					v:SetHealth(862)
					v:SetMaxHealth(862)
				end
			end
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_minifun" then
			currentweapon.Primary.Delay          = 0.06
			currentweapon.BaseDamage = 6
			currentweapon.BaseDamage = 5
			ent.AmmoMax[TF_PRIMARY] = 400
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $300 dollars for their "..self:GetItemData().item_name)
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_minigun_tomislav" then
			currentweapon.Primary.Delay          = 0.06
			currentweapon.BaseDamage = 6
			currentweapon.BaseDamage = 9
			ent.AmmoMax[TF_PRIMARY] = 400
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $300 dollars for their "..self:GetItemData().item_name)
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_minigun_burner" then
			currentweapon.Primary.Delay          = 0.06
			currentweapon.BaseDamage = 6
			currentweapon.BaseDamage = 9
			ent.AmmoMax[TF_PRIMARY] = 400
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $300 dollars for their "..self:GetItemData().item_name)
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_minigun_bb" then
			currentweapon.Primary.Delay          = 0.06
			currentweapon.BaseDamage = 6
			currentweapon.BaseDamage = 9
			ent.AmmoMax[TF_PRIMARY] = 400
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $300 dollars for their "..self:GetItemData().item_name)
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_minigun_ic" then
			currentweapon.Primary.Delay          = 0.06
			currentweapon.BaseDamage = 6
			currentweapon.BaseDamage = 9
			ent.AmmoMax[TF_PRIMARY] = 400
			
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $300 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_shotgun_soldier" then
			currentweapon.Primary.Delay          = 0.3
			currentweapon.BaseDamage = 12
			currentweapon.Primary.ClipSize         = 12
			currentweapon.ReloadTime = 0.2
			ent:ConCommand("tf_upgradewep03clientonly")
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $600 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_revolver" then
			currentweapon.Primary.Delay          = 0.3
			currentweapon.BaseDamage = 12
			currentweapon.Primary.ClipSize         = 11
			currentweapon.ReloadTime = 0.71
			ent.AmmoMax[TF_PRIMARY] = 400
			ent:ConCommand("tf_upgradewep03clientonly")
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $600 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_sentry_revenge" then
			currentweapon.Primary.Delay          = 0.3
			currentweapon.BaseDamage = 12
			currentweapon.Primary.ClipSize         = 12
			currentweapon.ReloadTime = 0.2
			ent:ConCommand("tf_upgradewep03clientonly")
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $600 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_shotgun_imalreadywidowmaker" then
			currentweapon.Primary.Delay          = 0.3
			currentweapon.BaseDamage = 12
			currentweapon.ReloadTime = 0.2
			ent:ConCommand("tf_upgradewep03clientonly")
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $600 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_shotgun_hwg" then
			currentweapon.Primary.Delay          = 0.3
			currentweapon.BaseDamage = 12
			currentweapon.Primary.ClipSize         = 12
			currentweapon.ReloadTime = 0.2
			ent:ConCommand("tf_upgradewep03clientonly")
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $600 dollars for their S"..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_flaregun" then
			currentweapon.Primary.Delay          = 0.5
			ent:ConCommand("tf_upgradewep05clientonly")
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $600 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_shotgun_pyro" then
			currentweapon.Primary.Delay          = 0.3
			currentweapon.BaseDamage = 12
			currentweapon.Primary.ClipSize         = 12
			currentweapon.ReloadTime = 0.2
			ent:ConCommand("tf_upgradewep03clientonly")
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $500 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_shotgun_primary" then
			currentweapon.Primary.Delay          = 0.3
			currentweapon.BaseDamage = 12
			currentweapon.Primary.ClipSize         = 12
			currentweapon.ReloadTime = 0.2
			ent:ConCommand("tf_upgradewep03clientonly")
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_flamethrower" then
			
currentweapon.Primary.Delay          = 0.015
			currentweapon.BaseDamage = 6
			ent.AmmoMax[TF_PRIMARY] = 600
			ent.AmmoMax[TF_PRIMARY] = 600
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name)
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_flamethrower_bb" then
			
currentweapon.Primary.Delay          = 0.015
			currentweapon.BaseDamage = 6
			ent.AmmoMax[TF_PRIMARY] = 600
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name)
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_flamethrower_degreaser" then
			
currentweapon.Primary.Delay          = 0.015
			currentweapon.BaseDamage = 6
			ent.AmmoMax[TF_PRIMARY] = 600
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name)
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_flamethrower_rb" then
			
currentweapon.Primary.Delay          = 0.015
			currentweapon.BaseDamage = 6
			ent.AmmoMax[TF_PRIMARY] = 600
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their F"..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_phlogistinator" then
			
currentweapon.Primary.Delay          = 0.015
			currentweapon.BaseDamage = 6
			ent.AmmoMax[TF_PRIMARY] = 600
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_scattergun" then
			currentweapon.Primary.Delay          = 0.3
			currentweapon.BaseDamage = 12
			currentweapon.Primary.ClipSize         = 12
			currentweapon.ReloadTime = 0.2
			ent:ConCommand("tf_upgradewep03clientonly")
			ent.AmmoMax[TF_PRIMARY] = 120 
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $600 dollars for their "..self:GetItemData().item_name)
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_handgun_scout" then
			currentweapon.Primary.Delay          = 0.22
			currentweapon.BaseDamage = 23
			currentweapon.Primary.ClipSize         = 8
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $600 dollars for their "..self:GetItemData().item_name)
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_sniperrifle" then
			currentweapon.Primary.Delay          = 0.7
			currentweapon.BaseDamage = 120
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $600 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_smg" then
			currentweapon.Primary.Delay          = 0.08
			currentweapon.Primary.ClipSize          = 35	
			currentweapon.BaseDamage = 30
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $600 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_grenadelauncher" then
			currentweapon.Primary.Delay          = 0.4
			currentweapon.Primary.ClipSize         = 12
			currentweapon.ReloadTime = 0.2
			ent.AmmoMax[TF_PRIMARY] = 80
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their G"..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_pipebomblauncher" then
			currentweapon.Primary.Delay          = 0.3
			currentweapon.Primary.ClipSize         = 12
			currentweapon.ReloadTime = 0.2
			currentweapon.MaxBombs = 12
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $1200 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_pistol_scout" then
			currentweapon.Primary.Delay          = 0.08
			currentweapon.Primary.ClipSize         = 16
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_shortcircuit" then
			currentweapon.Primary.Delay          = 0.08
			currentweapon.Secondary.Delay          = 0.4
			currentweapon.BaseDamage = 140
			ent.AmmoMax[TF_METAL] = 550
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name)
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_pistol" then
			currentweapon.Primary.Delay          = 0.08
			currentweapon.BaseDamage = 12
			currentweapon.Primary.ClipSize         = 16
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_bat" then
			currentweapon.Primary.Delay          = 0.2
			currentweapon.BaseDamage = 95
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_bat_wood" then
			currentweapon.Primary.Delay          = 0.25
			currentweapon.Secondary.Delay          = 2
			currentweapon.BaseDamage = 95
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_club" then
			currentweapon.Primary.Delay          = 0.43
			currentweapon.BaseDamage = 95
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_wrench" then
			currentweapon.Primary.Delay          = 0.5
			currentweapon.BaseDamage = 95
			ent.AmmoMax[TF_METAL] = 450
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_robot_arm" then
			currentweapon.Primary.Delay          = 0.5
			currentweapon.BaseDamage = 95
			ent.AmmoMax[TF_METAL] = 450
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_engi_fist" then
			currentweapon.Primary.Delay          = 0.5
			currentweapon.BaseDamage = 95
			ent.AmmoMax[TF_METAL] = 450
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_bottle" then
			currentweapon.Primary.Delay          = 0.5
			currentweapon.BaseDamage = 95
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_fireaxe" then
			currentweapon.Primary.Delay          = 0.5
			currentweapon.BaseDamage = 95
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their	"..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_syringegun_medic" then
			currentweapon.Primary.Delay          = 0.07
			currentweapon.BaseDamage = 65
			currentweapon.Primary.ClipSize			= 80
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_medigun" then
			currentweapon.MinHealRate = 250
			currentweapon.MaxHealRate = 252
			currentweapon.MinLastDamageTime = 18
			currentweapon.MaxLastDamageTime = 19
			currentweapon.UberchargeRate = 12
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Medigun upgrades for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_medigun_vaccinator" then
			currentweapon.MinHealRate = 300
			currentweapon.MaxHealRate = 300
			currentweapon.MinLastDamageTime = 18
			currentweapon.MaxLastDamageTime = 19
			currentweapon.UberchargeRate = 16
			currentweapon.Overpowered = true
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Medigun upgrades for their Vaccinator" )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_medigun_quickfix" then
			currentweapon.MinHealRate = 330
			currentweapon.MaxHealRate = 332
			currentweapon.MinLastDamageTime = 18
			currentweapon.MaxLastDamageTime = 19
			currentweapon.UberchargeRate = 16
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Medigun upgrades for their Quick-Fix" )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_bonesaw" then
			currentweapon.Primary.Delay          = 0.5
			currentweapon.BaseDamage = 95
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_fists" then
			currentweapon.Primary.Delay          = 0.5
			currentweapon.BaseDamage = 95
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_shovel" then
			currentweapon.Primary.Delay          = 0.5
			currentweapon.BaseDamage = 95
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_sword" then
			currentweapon.Primary.Delay          = 0.5
			currentweapon.BaseDamage = 150
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_katana" then
			currentweapon.Primary.Delay          = 0.5
			currentweapon.BaseDamage = 150
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_allclass" and ent:GetPlayerClass() != "scout" then
			currentweapon.Primary.Delay	= 0.5
			currentweapon.BaseDamage = 100
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
		if currentweapon:GetClass() == "tf_weapon_allclass" and ent:GetPlayerClass() == "scout" then
			currentweapon.Primary.Delay	= 0.2
			currentweapon.BaseDamage = 100
			PrintMessage( HUD_PRINTTALK, "Player "..ent:Nick().." bought Rapid Fire with $400 dollars for their "..self:GetItemData().item_name )
			timer.Simple(0.1, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.4, function()
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
			timer.Simple(0.6, function() 
				ent:EmitSound("mvm/mvm_bought_upgrade.wav", 80, 100)
			end)
		end
	end
end

function ENT:EndTouch(ent)
	if ent:IsPlayer() then
		self.Players[ent] = nil
		if ent:GetPlayerClass() == "heavy" then
			ent:EmitSound("vo/heavy_mvm_get_upgrade0"..math.random(1,6)..".mp3", 80, 100)
		elseif ent:GetPlayerClass() == "soldier" then
			ent:EmitSound("vo/soldier_mvm_get_upgrade0"..math.random(1,3)..".mp3", 80, 100)
		elseif ent:GetPlayerClass() == "engineer" then
			ent:EmitSound("vo/engineer_mvm_get_upgrade0"..math.random(1,2)..".mp3", 80, 100)
		elseif ent:GetPlayerClass() == "medic" then
			ent:EmitSound("vo/medic_mvm_get_upgrade0"..math.random(1,4)..".mp3", 80, 100)
		end
	end
end
