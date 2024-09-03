
DEFINE_BASECLASS( "base_gmodentity" )

ENT.IsTFWearableItem = true

tf_item.InitializeAsBaseItem(ENT)
ENT.SetupDataTables0 = ENT.SetupDataTables

function ENT:SetupDataTables()
	self:SetupDataTables0()
	self:DTVar("Int", 1, "ItemTint")
	self:NetworkVar("Vector", 1, "CosmeticTint")
end

function ENT:GetItemTint(t)
	return self.dt.ItemTint
end

if SERVER then

AddCSLuaFile("shared.lua")

function ENT:SetItemTint(t)
	self.dt.ItemTint = t
end

function ENT:Think()
	if (!IsValid(self.Owner) or (IsValid(self.Owner) && !self.Owner:Alive())) then
		self:Remove()
	end
	if self:GetOwner() ~= LocalPlayer() or LocalPlayer():ShouldDrawLocalPlayer() then
		if self.ShadowCreated ~= true then
			self.ShadowCreated = true
			self:CreateShadow()
		end
	else
		if self.ShadowCreated ~= false then
			self.ShadowCreated = false
			self:DestroyShadow()
		end
	end

	if CLIENT then
		if self:GetOwner() ~= LocalPlayer() or LocalPlayer():ShouldDrawLocalPlayer() then
			if self.ShadowCreated ~= true then
				self.ShadowCreated = true
				self:CreateShadow()
			end
		else
			if self.ShadowCreated ~= false then
				self.ShadowCreated = false
				self:DestroyShadow()
			end
		end
	elseif SERVER then
		if self:GetOwner():GetNoDraw() == true then
			self:SetNoDraw(true)
		else
			self:SetNoDraw(false)
		end
		local item = self:GetItemData()
		if self:GetItemData()["item_slot"] == "head" then
			if self:GetOwner():GetInfoNum("tf_hatcolor_rainbow", 0) == 1 then 
				self:SetCosmeticTint(Vector(math.random(5, 255)/255, math.random(5, 255)/255, math.random(5, 255)/255))
			else
				self:SetCosmeticTint(Vector(string.ToColor(self:GetOwner():GetInfo("tf_hatcolor")).r/255, string.ToColor(self:GetOwner():GetInfo("tf_hatcolor")).g/255, string.ToColor(self:GetOwner():GetInfo("tf_hatcolor")).b/255))
			end
		elseif self:GetItemData()["item_slot"] == "misc" then
			if self:GetOwner():GetInfoNum("tf_hatcolor_rainbow", 0) == 1 then
				self:SetCosmeticTint(Vector(math.random(5, 255)/255, math.random(5, 255)/255, math.random(5, 255)/255))
			else
				self:SetCosmeticTint(Vector(string.ToColor(self:GetOwner():GetInfo("tf_misccolor")).r/255, string.ToColor(self:GetOwner():GetInfo("tf_misccolor")).g/255, string.ToColor(self:GetOwner():GetInfo("tf_misccolor")).b/255))
			end
		end
	end
end

end

if CLIENT then

CreateClientConVar( "tf_hatcolor", "0 0 0 255", true, true )
CreateClientConVar( "tf_misccolor", "0 0 0 255", true, true )
CreateClientConVar( "tf_hatcolor_rainbow", "0", true, true )
CreateClientConVar( "tf_misccolor_rainbow", "0", true, true )

function ENT:Draw()
	if (file.Exists(self:GetModel(),"GAME")) then
		if self:GetOwner() ~= LocalPlayer() or LocalPlayer():ShouldDrawLocalPlayer() then
			self:StartVisualOverrides()
			self:StartItemTint(self:GetItemTint())
			self:GetOwner().RenderingWorldModel = true
			self:DrawModel()
			self:GetOwner().RenderingWorldModel = false
			self:EndItemTint()
			self:EndVisualOverrides()
		end
	end
end

-- Called when the player is ragdolled or gibbed (if gibbed, rag = NULL)
function ENT:SetupPlayerRagdoll(rag)
		local item = self:GetItemData()
		
		self.CheckUpdateItem = nil
		self:ClearParticles()
		
		if not self.Model or not util.IsValidModel(self.Model) then return end
		
		local effectdata = EffectData()
		effectdata:SetEntity(self)
		if item.drop_type == "drop" then
			local mat = self:GetBoneMatrix(0)
			
			-- Spawn a hat gib
			effectdata:SetMagnitude(GIB_HAT)
			if mat then
				effectdata:SetOrigin(mat:GetTranslation())
				effectdata:SetAngles(mat:GetAngles())
			else
				effectdata:SetOrigin(self:GetOwner():GetPos())
				effectdata:SetAngles(self:GetOwner():GetAngles())
			end
			effectdata:SetNormal(Vector(0,0,0.8))
			effectdata:SetRadius(0.8)
			util.Effect("tf_gib", effectdata)
		else
			if IsValid(rag) then
				-- This hat doesn't drop, attach it to the player's ragdoll
				util.Effect("tf_hat_attached", effectdata)
			end
		end
end

end

function ENT:Think()
	
	
	if (file.Exists(self:GetModel(),"GAME") and CLIENT) then
		local item = self:GetItemData()
		if (IsValid(self.Owner)) then
			if (item.visuals) then
				if item.visuals.player_bodygroups then
					local bodygroups = item.visuals.player_bodygroups
					if (bodygroups.hat) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("hat"),1)
					elseif (bodygroups.head) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("head"),1)
					elseif (bodygroups.headphones) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("headphones"),1)
					elseif (bodygroups.medal) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("medal"),1)
					elseif (bodygroups.grenades) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("grenades"),1)
					elseif (bodygroups.bullets) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("bullets"),1)
					elseif (bodygroups.arrows) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("arrows"),1)
					elseif (bodygroups.rightarm) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("rightarm"),1)
					elseif (bodygroups.shoes_socks) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("shoes_socks"),1)
					end
				end
			end
			if (item and item.visuals) then
				if item.visuals.player_bodygroups then
					local bodygroups = item.visuals.player_bodygroups
					if (bodygroups.hat) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("hat"),1)
					elseif (bodygroups.head) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("head"),1)
					elseif (bodygroups.headphones) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("headphones"),1)
					elseif (bodygroups.medal) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("medal"),1)
					elseif (bodygroups.grenades) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("grenades"),1)
					elseif (bodygroups.bullets) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("bullets"),1)
					elseif (bodygroups.arrows) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("arrows"),1)
					elseif (bodygroups.rightarm) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("rightarm"),1)
					elseif (bodygroups.shoes_socks) then
						self.Owner:SetBodygroup(self.Owner:FindBodygroupByName("shoes_socks"),1)
					end
				end
			end
		end
		if self.Model and string.find(self.Model,"_zombie") then
			if (IsValid(self.Owner)) then
				if (self.Owner:GetPlayerClass() == "spy") then
					if (self.Owner:Team() == TEAM_BLU) then
						self.Owner:SetSkin(23)
						self:SetSkin(1)
					else
						self.Owner:SetSkin(22)
						self:SetSkin(0)
					end
				else
					if (self.Owner:Team() == TEAM_BLU) then
						self.Owner:SetSkin(5)
						self:SetSkin(1)
					else
						self.Owner:SetSkin(4)
						self:SetSkin(0)
					end
				end
			end
		else
			if (IsValid(self.Owner)) then
				if (self.Owner:GetPlayerClass() == "spy") then
					if (self.Owner:Team() == TEAM_BLU) then
						self:SetSkin(1)
					else
						self:SetSkin(0)
					end
				else
					if (self.Owner:Team() == TEAM_BLU) then
						self:SetSkin(1)
					else
						self:SetSkin(0)
					end
				end
			end
		end

		if (self:GetModel() == "models/error.mdl") then -- no errors for people who don't have TF2 mounted!
			self:SetModel("models/empty.mdl")
		end
	end

end
function ENT:Initialize()
	self.Owner = self:GetOwner()
	self:DrawShadow(false)
	
	if (file.Exists(self:GetModel(),"GAME")) then
		self:AddToPlayerItems()
		self.ProxyentPaintColor = self
			
		local item = self:GetItemData()
		if item.model_player then
			--print(item.model_player)
			if (string.find(item.model_player,"zombie") || (string.find(item.model_player,"/all_class/all_") and !string.find(item.model_player,"all_halo")) || string.find(item.model_player,"ugc_season12") ) then
				if (string.find(item.model_player,"/zombie_"..self.Owner:GetPlayerClass()..".mdl")) then
					self.Owner:SetSkin(self.Owner:GetSkin())
				end
				self.Model = string.Replace(string.Replace(item.model_player,"%s",self.Owner.playerclass),"demoman","demo")
			else
				if (string.find(item.model_player,"zombie")) then
					self.Owner:SetSkin(self.Owner:GetSkin())   
				end
				self.Model = string.Replace(string.Replace(item.model_player,"%s",self.Owner:GetPlayerClass()),"demoman","demo")
			end
		elseif item.model_player_per_class then
			if (item.model_player_per_class[self.Owner:GetPlayerClass()]) then
				local modelperclass = item.model_player_per_class[self.Owner:GetPlayerClass()]
				modelperclass = string.Replace(modelperclass,"%s",self.Owner.playerclass)

				modelperclass = string.Replace(modelperclass,"demoman","demo")
				self.Model = modelperclass
			else
				--print(item.model_player_per_class)
				PrintTable(item.model_player_per_class)
				local modelperclass = tostring(item.model_player_per_class.basename)
				modelperclass = string.Replace(modelperclass,"%s",self.Owner:GetPlayerClass())
				self.Model = string.Replace(modelperclass,"demoman","demo")
			end
		end
		
		if SERVER then
			self:SetMoveType(MOVETYPE_NONE)
			self:SetSolid(SOLID_NONE)
			self:SetParent(self:GetOwner())
			
			if self.Model then
				self:SetModel(self.Model)
				self:SetKeyValue("effects", "1") 
				
				if item.set_sequence_to_class then
					self:AddEffects(EF_NOINTERP)
					self:ResetSequence(self:LookupSequence(self.Owner:GetPlayerClass()))
				end
			else
				self:SetNoDraw(true)
				self:DrawShadow(false)
			end
		end
	end
end

function ENT:OnRemove()
	self:RemoveFromPlayerItems()
end

function ENT:OnOwnerDeath()
	self.Dead = true
	self:SetNoDraw(true)
	self:DrawShadow(false)
	SafeRemoveEntityDelayed(self, 1)
end


hook.Add("PlayerHurt", "TFHatDisable2", function(pl)
	for k,dringer in pairs(ents.FindByClass("tf_weapon_invis_dringer")) do
		if dringer.Owner == pl and dringer.dt.Ready == true then
			for _,v in pairs(ents.FindByClass("tf_wearable_item")) do
				if v:GetOwner()==pl then
					vself.WModel2:SetNoDraw(true)
					v:DrawShadow(false)
					timer.Create("Decloak", 0.001, 0, function()
						if dringer.dt.Charging == false then
							vself.WModel2:SetNoDraw(false)
							v:DrawShadow(true)	
							v:SetMaterial("models/shadertest/predator")  
							timer.Simple(1, function() 
								v:SetMaterial("")
								timer.Stop("Decloak")
							end)
						end
					end)
				end
			end
		end
	end
end)


hook.Add("DoPlayerDeath", "DetachPlayerHat", function(pl)
	for _,v in pairs(pl:GetTFItems()) do
		if v.OnOwnerDeath then
			v:OnOwnerDeath()
		end
	end
end)
