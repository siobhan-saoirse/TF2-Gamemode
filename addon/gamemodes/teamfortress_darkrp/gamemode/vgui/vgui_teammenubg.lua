
local PANEL = vgui.Create( "DPanel" )

concommand.Add("teamsect", function()
	PANEL()
end)

function PANEL:Init()
	self:SetModel("models/vgui/UI_team01.mdl")
	self.Visible = true
	self:SetPos(0, 0)
	
	self:PerformLayout()
end

function PANEL:Think()
end

function PANEL:LayoutEntity(ent)
	if (!IsValid(LocalPlayer())) then return end
	
	self:SetCamPos(Vector(0, 0, -34))
	self:SetLookAt(Vector(0, 0, 0))
	
	ent:SetPos(Vector(290, 0, 0))
	ent:SetAngles(Angle(0, 180, 0))
end

function PANEL:PerformLayout()
	self:SetSize(ScrW(), ScrH())
end

if VGUI_TeamMenuBackground then VGUI_TeamMenuBackground:Remove() end
VGUI_TeamMenuBackground = vgui.CreateFromTable(vgui.RegisterTable(PANEL, "DModelPanel"))