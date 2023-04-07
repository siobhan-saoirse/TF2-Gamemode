if SERVER then
	AddCSLuaFile( "shared.lua" )
end

SWEP.Base				= "tf_weapon_base"

SWEP.ViewModel			= "models/weapons/v_models/v_pda_spy.mdl"
SWEP.WorldModel			= "models/weapons/w_models/w_cigarette_case.mdl"

SWEP.HoldType = "PDA"
SWEP.UseHands = true
SWEP.IsPDA = true
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Delay 			= 1
SWEP.Slot				= 3
SWEP.Secondary.Delay		= 5

if CLIENT then

SWEP.PrintName			= "Disguise PDA"

SWEP.Crosshair = ""

end

function SWEP:SecondaryAttack()
end

function SWEP:Think()
	self.Owner:PrintMessage(HUD_PRINTCENTER,"Press MOUSE1 to disguise as a random class.")
	return self.BaseClass.Think(self)
end
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire( CurTime() + 1 )
	self.Owner:ConCommand("tf_spydisguise")
	local ply = self.Owner
	if SERVER then
		ply:SelectWeapon("tf_weapon_knife")
	end
	ply:EmitSound("player/spy_disguise.wav", 65, 100)
	local tbl = table.Random({"scout","soldier","pyro","demo","heavy","engineer","medic","sniper","hwm/spy"})
	timer.Simple(2, function()
		if SERVER then
			ply:SetModel("models/player/"..tbl..".mdl")
			
				if (ply:GetModel() == "models/player/scout.mdl") then
					ply.playerclass = "Scout"
				elseif (ply:GetModel() == "models/player/soldier.mdl") then
					ply.playerclass = "Soldier"
				elseif (self:GetModel() == "models/player/pyro.mdl") then
					ply.playerclass = "Pyro"
				elseif (ply:GetModel() == "models/player/demo.mdl") then
					ply.playerclass = "Demoman"
				elseif (ply:GetModel() == "models/player/heavy.mdl") then
					ply.playerclass = "Heavy"
				elseif (ply:GetModel() == "models/player/engineer.mdl") then
					ply.playerclass = "Engineer"
				elseif (ply:GetModel() == "models/player/medic.mdl") then
					ply.playerclass = "Medic"
				elseif (ply:GetModel() == "models/player/sniper.mdl") then
					ply.playerclass = "Medic"
				else
					ply.playerclass = string.upper(string.sub(class,1,1))..string.sub(class,2)	
				end
			if ply:Team() != TEAM_RED then
				ply:SetSkin(0)
			else
				ply:SetSkin(1)
			end
			timer.Create("RemoveDisguise"..ply:EntIndex(), 0.01, 0, function()
				if not ply:Alive() then 
					ply:SetModel("models/player/spy.mdl") 
					if ply:Team() == TEAM_BLU then 
						ply:SetSkin(1) 
					elseif ply:Team() == TF_TEAM_PVE_INVADERS then 
						ply:SetSkin(1) 
					else 
						ply:SetSkin(0) 
					end 
					if (ply:GetModel() == "models/player/scout.mdl") then
						ply.playerclass = "Scout"
					elseif (ply:GetModel() == "models/player/soldier.mdl") then
						ply.playerclass = "Soldier"
					elseif (self:GetModel() == "models/player/pyro.mdl") then
						ply.playerclass = "Pyro"
					elseif (ply:GetModel() == "models/player/demo.mdl") then
						ply.playerclass = "Demoman"
					elseif (ply:GetModel() == "models/player/heavy.mdl") then
						ply.playerclass = "Heavy"
					elseif (ply:GetModel() == "models/player/engineer.mdl") then
						ply.playerclass = "Engineer"
					elseif (ply:GetModel() == "models/player/medic.mdl") then
						ply.playerclass = "Medic"
					elseif (ply:GetModel() == "models/player/sniper.mdl") then
						ply.playerclass = "Medic"
					else
						local class = ply:GetPlayerClass()
						ply.playerclass = string.upper(string.sub(class,1,1))..string.sub(class,2)	
					end
					ply:EmitSound("player/spy_disguise.wav", 65, 100) 
					timer.Stop("RemoveDisguise"..ply:EntIndex()) 
				end
			end)
		end
	end)
	timer.Simple(3, function()
		for _,v in pairs(ents.GetAll()) do
			if v:IsNPC() and not v:IsFriendly(self.Owner) then
				if SERVER then
					v:AddEntityRelationship(self.Owner, D_LI, 99)
				end
			end
		end
	end)
	if self.Owner:GetNoDraw() == false then
		if self.Owner:Team() == TEAM_RED or self.Owner:Team() == TEAM_NEUTRAL then
			ParticleEffectAttach( "spy_start_disguise_red", PATTACH_ABSORIGIN_FOLLOW, self.Owner, 1 )
		else
			ParticleEffectAttach( "spy_start_disguise_blue", PATTACH_ABSORIGIN_FOLLOW, self.Owner, 1 )
		end
	end
end