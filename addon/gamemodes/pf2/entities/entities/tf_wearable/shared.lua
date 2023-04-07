
DEFINE_BASECLASS( "base_gmodentity" )

ENT.IsTFWearableItem = true

tf_item.InitializeAsBaseItem(ENT)
ENT.SetupDataTables0 = ENT.SetupDataTables

function ENT:SetupDataTables()
	self:SetupDataTables0()
	self:DTVar("Int", 1, "ItemTint")
end

function ENT:GetItemTint(t)
	return self.dt.ItemTint
end

if SERVER then

AddCSLuaFile("shared.lua")

function ENT:SetItemTint(t)
	self.dt.ItemTint = t
end

end

if CLIENT then

function ENT:Think()
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
end

function ENT:Draw()
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
	if IsValid(self.Owner) and self.Model and string.find(self.Model,"_zombie") then
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
	elseif IsValid(self.Owner) and self.Model then
		if (self.Owner:Team() == TEAM_BLU) then
			self:SetSkin(1)
		else
			self:SetSkin(0)
		end
	end
	if CLIENT then
		self:SetPredictable( true )
	end
end
function ENT:Initialize()
	self.Owner = self:GetOwner()
	self:AddToPlayerItems()
		
	local item = self:GetItemData()
	
	if item.model_player then
		print(item.model_player)
		if (string.find(item.model_player,"zombie") || (string.find(item.model_player,"/all_class/all_") and !string.find(item.model_player,"all_halo")) || string.find(item.model_player,"ugc_season12") ) then
			if (string.find(item.model_player,"/zombie_"..self.Owner:GetPlayerClass()..".mdl")) then
				self.Owner:SetSkin(self.Owner:GetSkin())
			end
			self.Model = string.Replace(string.Replace(string.Replace(item.model_player,"%s",self.Owner:GetPlayerClass()),"all_class",self.Owner:GetPlayerClass()),"demoman","demo")
		else
			if (string.find(item.model_player,"zombie")) then
				self.Owner:SetSkin(self.Owner:GetSkin())
			end
			self.Model = string.Replace(string.Replace(item.model_player,"%s",self.Owner:GetPlayerClass()),"demoman","demo")
		end
	elseif item.model_player_per_class then
		if (item.model_player_per_class[self.Owner:GetPlayerClass()]) then
			local modelperclass = item.model_player_per_class[self.Owner:GetPlayerClass()]
			modelperclass = string.Replace(modelperclass,"%s",self.Owner:GetPlayerClass())

			if (string.find(item.model_player_per_class[self.Owner:GetPlayerClass()],"_demo.mdl")) then
				modelperclass = string.Replace(modelperclass,"demoman","demo")
			end
			self.Model = modelperclass
		else
			print(item.model_player_per_class)
			PrintTable(item.model_player_per_class)
			local modelperclass = tostring(item.model_player_per_class.basename)
			modelperclass = string.Replace(modelperclass,"%s",self.Owner:GetPlayerClass())
			self.Model = string.Replace(modelperclass,"demoman","demo")
		end
	end
	if SERVER then
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)
		if (!self:GetOwner():IsHL2()) then
			self:SetParent(self:GetOwner())
		end
		
		if self.Model then
			self:SetModel(self.Model)
			if (self:GetOwner():IsHL2()) then
				self:FollowBone(self:GetOwner(),self:GetOwner():LookupBone("ValveBiped.Bip01_Head1"))
			else
				self:AddEffects(EF_BONEMERGE)
			end
			
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

function ENT:OnRemove()
	self:RemoveFromPlayerItems()
end

function ENT:OnOwnerDeath()
	self.Dead = true
	self:SetNoDraw(true)
	self:DrawShadow(false)
	SafeRemoveEntityDelayed(self, 1)
end

hook.Add("DoPlayerDeath", "DetachPlayerHat", function(pl)
	for _,v in pairs(pl:GetTFItems()) do
		if v.OnOwnerDeath then
			v:OnOwnerDeath()
		end
	end
end)
