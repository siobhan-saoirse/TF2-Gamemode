AddCSLuaFile()
include('shared.lua')


SWEP.PrintName			= "Scripted Weapon"

SWEP.Slot				= 0
SWEP.SlotPos			= 10
SWEP.DrawAmmo			= true
SWEP.DrawCrosshair		= true
SWEP.DrawWeaponInfoBox	= false
SWEP.BounceWeaponIcon   = false
SWEP.WepSelectIcon = surface.GetTextureID( "weapons/swep" )
SWEP.SwayScale			= 0 -- 0.5
SWEP.BobScale			= 0.25
 
--[[
hook.Add("HUDPaint", "testlol", function()
	draw.Text{text="Current sequence = "..LocalPlayer():GetViewModel():GetSequence(),pos={10, 10}}
	draw.Text{text="Cycle = "..LocalPlayer():GetViewModel():GetCycle(),pos={10, 40}}
end)]]

hook.Add("Think", "TFCheckWeaponChanged", function()
	for _,v in pairs(player.GetAll()) do
		if v:GetActiveWeapon() ~= v.LastActiveWeapon then
			if IsValid(v.LastActiveWeapon) and v.LastActiveWeapon.ClearParticles then
				v.LastActiveWeapon:ClearParticles()
			end
			
			--MsgFN("Old weapon : %s", tostring(v.LastActiveWeapon))
			if IsValid(v.LastActiveWeapon) and v.LastActiveWeapon.NextDeployed and v.LastActiveWeapon.Holster then
				v.LastActiveWeapon:Holster()
			end
			v.LastActiveWeapon = v:GetActiveWeapon()
			if IsValid(v.LastActiveWeapon) and not v.LastActiveWeapon.NextDeployed and v.LastActiveWeapon.Deploy then
				v.LastActiveWeapon:Deploy()
			end
			--MsgFN("New weapon : %s", tostring(v.LastActiveWeapon))
			
			if IsValid(v.LastActiveWeapon) and v.LastActiveWeapon.ResetParticles then
				v.LastActiveWeapon:ResetParticles()
			end
		end
	end
end)

function SWEP:InitializeCModel()
end

function SWEP:InitializeWModel2()
	if not self.WorldModelOverride then return end
--Msg("InitializeWModel2\n")
	local wmodel = self.WorldModelOverride2 or self.WorldModelOverride or self.WorldModel
	
	if IsValid(self.WModel2) then
		--self.WModel2:SetModel(wmodel)
	else
		self.WModel2 = ClientsideModel(wmodel)
		if not IsValid(self.WModel2) then return end
		
		--self.WModel2:SetPos(self.Owner:GetPos())
		--self.WModel2:SetAngles(self.Owner:GetAngles())
		--self.WModel2:AddEffects(bit.bor(EF_BONEMERGE, EF_BONEMERGE_FASTCULL))
		--self.WModel2:SetParent(self.Owner)
		--self.WModel2:SetNoDraw(true)
		--self.WModel2:SetColor(Color(255, 255, 255))
		
		if wmodel == "models/weapons/c_models/c_shotgun/c_shotgun.mdl" then
			--self.WModel2:SetMaterial("models/weapons/w_shotgun_tf/w_shotgun_tf")
		end
	end
	
	if IsValid(self.WModel2) then
		self.WModel2.Player = self.Owner
		self.WModel2.Weapon = self
		
		if self.MaterialOverride then
			--self.WModel2:SetMaterial(self.MaterialOverride)
		end
	end
end

function SWEP:InitializeAttachedModels()
--Msg("InitializeAttachedModels\n")
	if IsValid(self.AttachedWModel) then
		if self.AttachedWorldModel then
			self.AttachedWModel:SetModel(self.AttachedWorldModel)
		else
			self.AttachedWModel:Remove()
		end
	elseif self.AttachedWorldModel then
		local ent = (IsValid(self.WModel2) and self.WModel2) or self
		
		self.AttachedWModel = ClientsideModel(self.AttachedWorldModel)
		self.AttachedWModel:SetPos(ent:GetPos())
		self.AttachedWModel:SetAngles(ent:GetAngles())
		self.AttachedWModel:AddEffects(EF_BONEMERGE)
		self.AttachedWModel:SetParent(ent)
		self.AttachedWModel:SetNoDraw(true)
	end
	
	if IsValid(self.AttachedWModel) then
		self.AttachedWModel.Player = self.Owner
		self.AttachedWModel.Weapon = self
		
		if self.MaterialOverride then
			self.AttachedWModel:SetMaterial(self.MaterialOverride)
		end
	end
	
	if IsValid(self.AttachedVModel) then
		if self.AttachedViewModel then
			self.AttachedVModel:SetModel(self.AttachedViewModel)
		else
			self.AttachedVModel:Remove()
		end
	elseif self.AttachedViewModel then
		local ent = (IsValid(self.CModel) and self.CModel) or self.Owner:GetViewModel()
		
		if not IsValid(ent) then return end
		
		self.AttachedVModel = ClientsideModel(self.AttachedViewModel)
		self.AttachedVModel:SetPos(ent:GetPos())
		self.AttachedVModel:SetAngles(ent:GetAngles())
		self.AttachedVModel:AddEffects(EF_BONEMERGE)
		self.AttachedVModel:SetParent(ent)
		self.AttachedVModel:SetNoDraw(true)
	end
	
	if IsValid(self.AttachedVModel) then
		self.AttachedVModel.Player = self.Owner
		self.AttachedVModel.Weapon = self
		
		if self.MaterialOverride then
			self.AttachedVModel:SetMaterial(self.MaterialOverride)
		end
	end
end

-- Attached viewmodels seem to lose their parent when the player exits a vehicle, we'll force ViewModelDrawn to re-parent them to the player's viewmodel if the player has entered a vehicle
local LastVehicle = NULL
hook.Add("Think", "TFCheckPlayerInVehicle", function()
	local v = LocalPlayer():GetVehicle()
	
	if v ~= LastVehicle then
		if IsValid(v) then
			for _,w in pairs(LocalPlayer():GetWeapons()) do
				w.FixViewModel = true
			end
		end
		LastVehicle = v
	end
end)

function SWEP:RenderCModel()
	if IsValid(self.CModel) then
		self.CModel:DrawModel()
	end
	
	if IsValid(self.ExtraCModel) then
		self.ExtraCModel:DrawModel()
	end
	
	if IsValid(self.AttachedVModel) then
		self.AttachedVModel:DrawModel()
	end
end

function SWEP:RenderWModel()
	if IsValid(self.WModel2) then
		----self.WModel2:CreateShadow()
		--self.WModel2:DrawModel()
	end
	
	if IsValid(self.AttachedWModel) then
		--self.AttachedWModel:CreateShadow()
		self.AttachedWModel:DrawModel()
	end
end

function SWEP:DrawWeaponSelection(x, y, w, h, alpha)
	surface.SetDrawColor(255, 255, 255, alpha)
	local tex = self:GetIconTextureID() or nil
	if tex == nil then
		draw.SimpleText(self.PrintName, "TFHudSelectionText", x + w / 2, y + h * 0.4, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		return
	end
	surface.SetTexture(tex)
	local rx, ry = surface.GetTextureSize(tex)

	-- Borders
	y = y - 10
	x = x + 50
	w = w - 20

	-- Draw that mother
	surface.DrawTexturedRect( x, y,  w * 0.6 , ( w / 1.2 ) )

	-- Draw weapon info box
	self:PrintWeaponInfo( x + w + 20, y + h * 0.95, alpha )
end

function SWEP:ViewModelDrawn()

	//deployspeed = math.Round(GetConVar("tf_weapon_deploy_speed"):GetFloat(),2)
	local vm = self.Owner:GetViewModel()
	vm.Player = self.Owner
	
	if not self.IsDeployed then
		local seq = vm:GetSequence()
		if vm:GetSequenceActivity(seq) == self.VM_DRAW then
			self.DeploySequence = seq
		end
		
		if self.Owner.TempAttributes and self.Owner.TempAttributes.DeployTimeMultiplier then
			vm:SetPlaybackRate(1.2 / self.Owner.TempAttributes.DeployTimeMultiplier)
		elseif self.DeployTimeMultiplier then
			vm:SetPlaybackRate(1.2 / self.DeployTimeMultiplier)
		else
			vm:SetPlaybackRate(1.2)
		end
	else
		if self.DeploySequence ~= true and vm:GetSequence() ~= self.DeploySequence then
			self.DeploySequence = true
		end
	end	
	 
	if self.FixViewModel then
		if IsValid(self.CModel) then
			self.CModel:SetParent(vm)
			self.CModel:AddEffects(bit.bor(EF_BONEMERGE,EF_BONEMERGE_FASTCULL))
		end
		if IsValid(self.ExtraCModel) then
			self.ExtraCModel:SetParent(self.CModel)
		end
		self.FixViewModel = false
	end

	if IsValid(self.ExtraCModel) then
		self.ExtraCModel:SetParent(self.CModel)
	end
	if self.ViewModelOverride and (!string.StartWith(self.Owner:GetModel(), "models/infected/")) --[[and self:GetModel()~=self.ViewModelOverride]] then
		self.ViewModel = self.ViewModelOverride
		vm:SetModel(self.ViewModelOverride)
	end
	
	if self.HasCModel and not IsValid(self.CModel) then
		return
	end
	
	self.DrawingViewModel = true
	
	if self.ViewModelFlip then
		render.CullMode(MATERIAL_CULLMODE_CW)
	end

	if IsValid(self.ShieldEntity) and IsValid(self.ShieldEntity.CModel) then
		self.ShieldEntity:StartVisualOverrides()
		self.ShieldEntity.CModel:DrawModel()
		self.ShieldEntity:EndVisualOverrides()
	end

	self:StartVisualOverrides()
	
	self:RenderCModel()
	
	self:EndVisualOverrides()
	if self.ViewModelFlip then
		render.CullMode(MATERIAL_CULLMODE_CCW)
	end
	
	self:ModelDrawn(true)
end


-- Instead of using using DrawWorldModel to render the world model, do it here (at least it guarantees that it will be always drawn if the player is visible)
-- any potential problem with this?
hook.Add("PostPlayerDraw", "ForceDrawTFWorldModel", function(pl)
	if pl.RenderingWorldModel then
		render.SetBlend(1)
		return
	end
	
	if IsValid(pl:GetActiveWeapon()) and IsValid(pl:GetActiveWeapon().WModel2) then
		pl.RenderingWorldModel = true
		pl:GetActiveWeapon():DrawWorldModel(true)
		pl.RenderingWorldModel = false
	end
end)

-- Drawing the world model seems to redraw the player as well, this is quite annoying when a material is forced on the world model
-- as the player will be redrawn using that material as well
-- Just make players invisible if their world model is being rendered
hook.Add("PrePlayerDraw", "TFWorldModelHidePlayer", function(pl)
	if pl.RenderingWorldModel then
		render.SetBlend(0)
	end
end)

function SWEP:ModelDrawn(viewmode)
	
end

function SWEP:DoMuzzleFlash()
	local betaeffect = self.BetaMuzzle
	local ent
	
	if self.Owner==LocalPlayer() and not LocalPlayer():ShouldDrawLocalPlayer() then
		ent = self.CModel
	else
		ent = self:GetWorldModelEntity()
	end
	
	self:ResetParticles()
	
	if betaeffect then
		local effectdata = EffectData()
			effectdata:SetEntity(self)
		util.Effect(betaeffect, effectdata)
	else
		--ent:MuzzleFlash()
		ParticleEffectAttach(self.MuzzleEffect, PATTACH_POINT_FOLLOW, ent, ent:LookupAttachment("muzzle"))
	end
end

function SWEP:Draw()
end

usermessage.Hook("DoMuzzleFlash", function(msg)
	local w = msg:ReadEntity()
	if IsValid(w) and w.DoMuzzleFlash then
		w:DoMuzzleFlash()
	end
end)

usermessage.Hook("CallTFWeaponFunction", function(msg)
	local w = msg:ReadEntity()
	local f = msg:ReadString()
	local p = msg:ReadString()
	
	if IsValid(w) and w[f] then
		w[f](w, p)
	end
end)

usermessage.Hook("TF2ShellEject", function(msg)
	local w = msg:ReadEntity()
	
	if IsValid(w) then
		if (string.find(w:GetClass(),"smg") or string.find(w:GetClass(),"pistol") or string.find(w:GetClass(),"revolver")) then 
			--PrintTable(self.CModel:GetAttachments())
			if (IsValid(w.CModel)) then
				if (w.CModel:GetAttachment(w.CModel:LookupAttachment("eject_brass"))) then
					local effectdata = EffectData()
					if (LocalPlayer():ShouldDrawLocalPlayer()) then

						effectdata:SetEntity( w.Owner:GetViewModel() )
						effectdata:SetOrigin( w.WModel:GetAttachment(w.WModel:LookupAttachment("eject_brass")).Pos )
						effectdata:SetAngles( Angle(w.WModel:GetAttachment(w.WModel:LookupAttachment("eject_brass")).Ang.x,w.WModel:GetAttachment(w.WModel:LookupAttachment("eject_brass")).Ang.y,w.WModel:GetAttachment(w.CModel:LookupAttachment("eject_brass")).Ang.z) )

					else

						effectdata:SetEntity( w.Owner:GetViewModel() )
						effectdata:SetOrigin( w.CModel:GetAttachment(w.CModel:LookupAttachment("eject_brass")).Pos )
						effectdata:SetAngles( Angle(w.CModel:GetAttachment(w.CModel:LookupAttachment("eject_brass")).Ang.x,w.CModel:GetAttachment(w.CModel:LookupAttachment("eject_brass")).Ang.y,w.CModel:GetAttachment(w.CModel:LookupAttachment("eject_brass")).Ang.z) )

					end
					util.Effect( "ShellEject", effectdata )
				end
			end 
		end
	end
end)
usermessage.Hook("PlayTFWeaponWorldReload", function(msg)
	local w = msg:ReadEntity()
	
	if IsValid(w) and w.ReloadSound and (w.Owner ~= LocalPlayer() or LocalPlayer():ShouldDrawLocalPlayer()) then
		w:StopSound(w.ReloadSound)
		w:EmitSound(w.ReloadSound)
	end
end)
usermessage.Hook("PlayTFWeaponWorldReloadFinish", function(msg)
	local w = msg:ReadEntity()
	
	if IsValid(w) and w.ReloadSoundFinish and (w.Owner ~= LocalPlayer() or LocalPlayer():ShouldDrawLocalPlayer()) then
		w:StopSound(w.ReloadSoundFinish)
		w:EmitSound(w.ReloadSoundFinish)
	end
end)

hook.Add("EntityRemoved", "TFWeaponRemoved", function(ent)
	if ent.IsTFWeapon then
		if IsValid(ent.CModel) then ent.CModel:Remove() end
		if IsValid(ent.WModel2) then ent.WModel2:Remove() end
		if IsValid(ent.AttachedVModel) then ent.AttachedVModel:Remove() end
		if IsValid(ent.AttachedWModel) then ent.AttachedWModel:Remove() end
	end
end)
