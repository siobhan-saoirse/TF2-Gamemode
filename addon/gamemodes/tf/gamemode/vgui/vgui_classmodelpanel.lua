local PANEL = {}

local W = ScrW()
local H = ScrH()
local WScale = W/640
local Scale = H/480

local mat_MotionBlur	= Material("pp/motionblur")
local tex_MotionBlur	= render.GetMoBlurTex0()
local mat_white = Material("models/debug/debugwhite")
local pp_motionblur = surface.GetTextureID("pp/motionblur")
function PANEL:Init()
	self:SetVisible(true)
	self.Entities = {}
	
	self.LastPaint = 0
	self.FOV = 70
end

function PANEL:AddModel(id, mdl, keys)
	local ent = ClientsideModel(mdl)
	if not IsValid(ent) then return end
	
	ent:SetNoDraw(true)
	ent:SetPos(keys.Pos or Vector(0,0,0))
	ent:SetAngles(keys.Ang or Angle(0,0,0))
	
	if keys.Parent then
		if IsValid(self.Entities[keys.Parent]) then
			ent:SetParent(self.Entities[keys.Parent])
			ent:AddEffects(EF_BONEMERGE)
		end
	end

	if keys.Color then
		ent.ColorType = keys.Color
		print("Yes!")
	end
	
	if keys.LayoutEntity then
		ent.LayoutEntity = keys.LayoutEntity
	end
	
	if IsValid(self.Entities[id]) then
		self.Entities[id]:Remove()
	end
	
	self.Entities[id] = ent
	return ent
end

function PANEL:GetModelEntity(id)
	return self.Entities[id]
end

function PANEL:Paint()
	if table.Count(self.Entities)==0 then return end
	
	local x, y = self:LocalToScreen(0, 0)
	local w, h = self:GetSize()
	
	local fov = self.FOV
	
	if h<w then
		y = y + (h-w)/2
		h = w
	elseif w<h then
		x = x + (w-h)/2
		w = h
	end
	
	self:RunAnimation()
	for _,v in pairs(self.Entities) do
		if v.LayoutEntity then
			v:LayoutEntity()
		else
			v:SetAngles(v:GetAngles())
		end
	end
	
	cam.Start3D(Vector(0,0,0), Angle(0,0,0), fov, x, y, w, h)
	cam.IgnoreZ(true)
	
	render.SuppressEngineLighting(true)
	render.SetLightingOrigin(self.Entities[1]:GetPos() + Vector(0,0,68))
	
	render.ResetModelLighting(0.5, 0.5, 0.5)
	--render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
	--render.SetBlend( self.colColor.a/255 )
	
	if self.spotlight then
		render.SetModelLighting(BOX_TOP, 1, 1, 1)
	end
	
	for _,v in pairs(self.Entities) do
		v:DrawModel()
	end
	
	render.SuppressEngineLighting(false)
	cam.IgnoreZ(false)
	cam.End3D()
	
	self.LastPaint = RealTime()
	for k, v in pairs(self.Entities) do
		if v.ColorType == "hat" then
			print("Uhh..")
			print(v:GetModel())
			v:SetColor(string.ToColor(LocalPlayer():GetInfo("tf_hatcolor")))
			PrintTable(v:GetColor())
			print(string.ToColor(LocalPlayer():GetInfo("tf_hatcolor")))
		elseif v.ColorType == "person" and IsValid(LocalPlayer().NeutralModel) then
			v:SetColor(LocalPlayer().NeutralModel:GetColor())
		end
	end
end

function PANEL:RunAnimation()
	for _,v in pairs(self.Entities) do
		if v.animated then
			v:FrameAdvance(RealTime()-self.LastPaint)
		end
	end
end

function PANEL:StartAnimation(id, act)
	local ent = self.Entities[id]
	if not IsValid(ent) then return end
	
	local seq = ent:SelectWeightedSequence(act)
	if seq<=0 then return end
	
	ent:ResetSequence(seq)
	--ent:SetPoseParameter("move_x", 1)
	ent.animated = true
end

function PANEL:StopAnimation(id)
	local ent = self.Entities[id]
	if not IsValid(ent) then return end
	
	ent.animated = false
end

function PANEL:OnMousePressed(b)
	if self.disable_manipulation then return end
	if b==MOUSE_LEFT then
		self:MouseCapture(true)
		self.Drag = true
		self.LastX, self.LastY = self:CursorPos()
	end
end

function PANEL:OnMouseReleased(b)
	if b==MOUSE_LEFT then
		self:MouseCapture(false)
		self.Drag = false
	end
end

function PANEL:OnCursorMoved(x, y)
	if self.Drag and self.LastX and self.LastY then
		local dx, dy = x - self.LastX, y - self.LastY
		self.Entities[1]:SetAngles(self.Entities[1]:GetAngles() + Angle(0,dx/5,0))
		
		self.LastX, self.LastY = x, y
	end
end

vgui.Register("ClassModelPanel", PANEL, "EditablePanel")
