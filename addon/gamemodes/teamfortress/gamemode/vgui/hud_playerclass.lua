local PANEL = {}

local W = ScrW()
local H = ScrH()
local Scale = H/480

local character_bg = {
	surface.GetTextureID("hud/character_red_bg"),
	surface.GetTextureID("hud/character_blue_bg"),
	surface.GetTextureID("hud/character_yellow_bg"),
	surface.GetTextureID("hud/character_green_bg"),
}
local character_default = surface.GetTextureID("hud/class_scoutred")
local character3d_default = "models/player/spy.mdl"
local convar = CreateClientConVar("cl_hud_playerclass_use_playermodel", "1", true, false)

function PANEL:Init()
	self:SetPaintBackgroundEnabled(false)
	self:ParentToHUD()
	self:SetVisible(true)
end

function PANEL:PerformLayout()
	self:SetPos(0,0)
	self:SetSize(W,H)
end

function PANEL:OnRemove()
	if self.ClassModel then
		self.ClassModel:Remove()
	end
end

function PANEL:Paint()
	if not LocalPlayer():Alive() or GetConVar("tf_forcehl2hud"):GetBool() or gmod.GetGamemode() == "teamfortress_darkrp" or LocalPlayer():IsHL2() or GAMEMODE.ShowScoreboard or GetConVarNumber("cl_drawhud")==0 or LocalPlayer():Team() == TEAM_SPECTATOR or LocalPlayer():GetPlayerClass()=="" then if self.ClassPanel then self.ClassPanel:Remove() self.ClassPanel = nil end return end
		local t = LocalPlayer():Team()
		local tbl = LocalPlayer():GetPlayerClassTable()

		if LocalPlayer():GetObserverTarget() and LocalPlayer():GetObserverTarget():IsPlayer() then
			t = LocalPlayer():GetObserverTarget():Team()
			tbl = LocalPlayer():GetObserverTarget():GetPlayerClassTable()
		end

		--ht = ACT_MP_STAND_..LocalPlayer():GetActiveWeapon().HoldType
		--[[model = LocalPlayer():GetPlayerClass()

		if not self.ClassPanel then
			p = vgui.Create("ClassModelPanel")

			p:SetParent(self)
			p:SetPos(W/2-100*Scale, 20*Scale)
			p:SetSize(200*Scale, 360*Scale)
			p.FOV = 50
			p.spotlight = true

			--t:AddModel(3,"models/player/items/all_class/all_halo.mdl",{
				--Parent = 1,
			--})
		end

		if not LocalPlayer():GetPlayerClass() == model then
			self.ModelSet = false
		end

		if self.ClassPanel and not self.ModelSet then
			p:SetSkin( LocalPlayer():GetSkin() )

			if LocalPlayer():GetPlayerClass() == "demoman" then
				model = "demo"
			end
			
			p:AddModel(1, "models/player/"..model..".mdl",{
				Pos = Vector(220, 0, -36),
				Ang = Angle(0, 220, 0),
			})

			if model == LocalPlayer():GetPlayerClass() then
				self.ModelSet = true
			end
		end

			p:StartAnimation(1, LocalPlayer():GetSequenceActivity( LocalPlayer():GetSequence() ))

			--t:GetModelEntity(1):SetPoseParameter("move_x",1)
			--t:GetModelEntity(1):SetPoseParameter("body_pitch",90)
			self.ClassPanel = p

			--print("ACT_MP_STAND_"..LocalPlayer():GetActiveWeapon().HoldType)]]
		local w, h = self:LocalToScreen( self:GetWide(), self:GetTall() - 30 )
		local tex = character_bg[t] or character_bg[1]
		if (LocalPlayer():IsL4D()) then
			tex = surface.GetTextureID("vgui/hud/pz_charge_bg")
		end
			surface.SetTexture(tex)
			surface.SetDrawColor(255,255,255,255)
			if (LocalPlayer():IsL4D()) then
				surface.DrawTexturedRect(25*Scale, (480-88)*Scale-20, 75*Scale+30, 75*Scale+30)
			else
				surface.DrawTexturedRect(9*Scale, (480-60)*Scale, 100*Scale, 50*Scale)
			end
	if convar:GetBool() then
		local ply = LocalPlayer()
		if (!ply:Alive()) then
			if self.ClassModel then
				self.ClassModel:Remove()
			end
		else
			if !IsValid(self.ClassModel) then
				self.ClassModel = vgui.Create("DModelPanel", self, "TF_3DClassModel")
				self.ClassModel.PreDrawModel = function() render.SetScissorRect(0, 0, w, h, true) end
				self.ClassModel.PostDrawModel = function() render.SetScissorRect(0, 0, 0, 0, false) end
				self.ClassModel:SetAnimated(true)
				self.ClassModel.oldDrawModel = self.ClassModel.DrawModel
			end
			self.ClassModel:SetPos(9*Scale, (480-100)*Scale)
			self.ClassModel:SetSize(125*Scale, 100*Scale)
			self.ClassModel:SetFOV(70)
			if (ply:Team() == TEAM_BLU) then
				self.ClassModel:SetSkin(1)
			else
				self.ClassModel:SetSkin(ply:GetSkin())
			end
			self.ClassModel:SetLookAng(Angle(170, -30, 180))
			self.ClassModel:SetCamPos(Vector(75, -30, 60))
			if (self.ClassModel:GetModel() != LocalPlayer():GetModel()) then
				self.ClassModel:SetModel(LocalPlayer():GetModel())
			end
			if (self.ClassModel.Entity:GetSequence() != ply:GetSequence()) then
				self.ClassModel.Entity:SetCycle(0)
				self.ClassModel.Entity:SetSequence(LocalPlayer():GetSequence())
			end
			for i = 0, ply:GetNumPoseParameters() - 1 do
				local flMin, flMax = ply:GetPoseParameterRange(i)
				local sPose = ply:GetPoseParameterName(i)
				if !string.find(sPose,"body_yaw") and !string.find(sPose,"body_pitch") and !string.find(sPose,"aim_yaw") and !string.find(sPose,"aim_pitch") then
					self.ClassModel.Entity:SetPoseParameter(sPose, math.Remap(ply:GetPoseParameter(sPose), 0, 1, flMin, flMax))
				end
			end 
			local ent = self.ClassModel:GetEntity()
			
			if (!IsValid(ent.Weapon) and IsValid(ply:GetActiveWeapon())) then
				local wmodel
				wmodel = ply:GetActiveWeapon():GetWeaponWorldModel() or "models/empty.mdl"
				ent.Weapon = ClientsideModel(wmodel)
				ent.Weapon:SetParent(ent)
				ent.Weapon:AddEffects(EF_BONEMERGE)
				ent.Weapon:SetNoDraw(false)
			elseif (IsValid(ent.Weapon) and IsValid(ply:GetActiveWeapon())) then
				local wmodel
				
				wmodel = ply:GetActiveWeapon():GetWeaponWorldModel() or "models/empty.mdl"
				ent.Weapon:SetModel(wmodel)
				ent.Weapon:SetParent(ent)
				ent.Weapon:AddEffects(EF_BONEMERGE)
				ent.Weapon:SetNoDraw(false)
			end
			self.ClassModel.DrawModel = function(self)
				self:oldDrawModel()
				local ent = self:GetEntity()
				if IsValid(ent.Weapon) then
					ent.Weapon:DrawModel()
				end
		
				if IsValid(ent.Hat1) then
					ent.Hat1:DrawModel()
				end
		
				if IsValid(ent.Hat2) then
					ent.Hat2:DrawModel()
				end
			end
			self.ClassModel.OnClose = function(self)
				local ent = self:GetEntity()
				if IsValid(ent.Weapon) then
					ent.Weapon:Remove()
				end
		
				if IsValid(ent.Hat1) then
					ent.Hat1:Remove()
				end
		
				if IsValid(ent.Hat2) then
					ent.Hat2:Remove()
				end
			end
			self.ClassModel.OnRemove = self.ClassModel.OnClose
			self.ClassModel.LayoutEntity = function() 
				self.ClassModel:RunAnimation()
				ent:FrameAdvance()
				-- print(self.ClassModel:GetCamPos(), self.ClassModel:GetFOV(), self.ClassModel:GetLookAt(), self.ClassModel:GetLookAng())
			end
		end
	else
		if self.ClassModel then self.ClassModel:Remove() end
		tex = character_default
		if tbl and tbl.CharacterImage and tbl.CharacterImage[1] then
			tex = tbl.CharacterImage[t] or tbl.CharacterImage[1]
		end
		surface.SetTexture(tex)
		surface.SetDrawColor(255,255,255,255)
		surface.DrawTexturedRect(25*Scale, (480-88)*Scale, 75*Scale, 75*Scale)
	end
end

if HudPlayerClass then HudPlayerClass:Remove() end
HudPlayerClass = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DPanel"))
