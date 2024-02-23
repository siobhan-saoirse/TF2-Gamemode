
function TeamSelection()


	local ply = LocalPlayer()
	local teamframe = vgui.Create("DFrame") --create a frame
	teamframe:SetTitle("Pick Team") --set the title of the menu 
	local TeamRed = vgui.Create( "DButton", teamframe )
	function TeamRed.DoClick() RunConsoleCommand( "changeteam", 1 ) teamframe:Close() end
	TeamRed:SetPos( 10, 65 )
	TeamRed:SetSize( 130, 20 )
	TeamRed:SetText( "RED Team" )
	local TeamBlu = vgui.Create( "DButton", teamframe )
	function TeamBlu.DoClick() RunConsoleCommand( "changeteam", 2 ) teamframe:Close() end
	TeamBlu:SetPos( 10, 105 )
	TeamBlu:SetSize( 130, 20 )
	TeamBlu:SetText( "BLU Team" )
	
	local TeamSpectate = vgui.Create( "DButton", teamframe )
	function TeamSpectate.DoClick() RunConsoleCommand( "tf_spectate" ) teamframe:Close() end
	TeamSpectate:SetPos( 10, 45 )
	TeamSpectate:SetSize( 130, 20 )
	TeamSpectate:SetText( "Spectate Team" )
	TeamSpectate.OnCursorEntered = function()
		
		LocalPlayer():StopSound("TV.Tune")
		LocalPlayer():EmitSound("TV.Tune")
		
	end
	local TeamNeutral = vgui.Create( "DButton", teamframe )
	function TeamNeutral.DoClick() RunConsoleCommand( "changeteam", 5 ) teamframe:Close() end
	TeamNeutral:SetPos( 10, 85 )
	TeamNeutral:SetSize( 130, 20 )
	TeamNeutral:SetText( "Neutral Team" )
	local TeamFriendly = vgui.Create( "DButton", teamframe )
	function TeamFriendly.DoClick() RunConsoleCommand( "random_team" ) teamframe:Close() end
	TeamFriendly:SetPos( 10, 125 )
	TeamFriendly:SetSize( 130, 20 )
	TeamFriendly:SetText( "Random Team" )
	teamframe:SetSize(150,150) --set its size
	teamframe:Center() --position it at the center of the screen CheckUpdateItem
	teamframe:SetDraggable(false) --can you move it around
	teamframe:SetSizable(false) --can you resize it?
	teamframe:ShowCloseButton(false) --can you close it
	teamframe:MakePopup() --make it appear 
	teamframe:SetKeyboardInputEnabled( false )
	--[[
	
	local ClassFrame = vgui.Create("DFrame") --create a frame
	ClassFrame:SetSize(ScrW() * 1, ScrH() * 1 ) --set its size
	ClassFrame:Center() --position it at the center of the screen
	ClassFrame:SetTitle("Team Menu") --set the title of the menu 
	ClassFrame:SetDraggable(true) --can you move it around
	ClassFrame:SetSizable(false) --can you resize it?
	ClassFrame:ShowCloseButton(true) --can you close it
	ClassFrame:MakePopup()
	
	local iconC = vgui.Create( "DModelPanel", ClassFrame )
	iconC:SetSize( ScrW() * 1, ScrH() * 1 )
	
	iconC:SetCamPos( Vector( 90, 0, 40 ) )
	iconC:SetPos( 0, 0)
	iconC:SetModel( "models/vgui/ui_team01.mdl" ) -- you can only change colors on playermodels
	iconC:SetZPos(-4)
	
	local spectate = vgui.Create("DModelPanel", ClassFrame)
	spectate:SetPos( 0, 0 )
	spectate:SetModel( "models/vgui/ui_team01_spectate.mdl" )
	spectate:SetSize(ScrW(), ScrH())
	spectate:SetCamPos( Vector( 90, 0, 40 ) )
	spectate:SetZPos(0)
	
	function spectate:LayoutEntity()
		self:RunAnimation()
	end
	
	local teambutton3 = vgui.Create("DButton", iconC)
	teambutton3:SetPos(0 - 140, 232)
	teambutton3:SetZPos(3)
	teambutton3:SetSize(82,57)
	--teambutton3:SetAlpha(0)
	teambutton3.OnCursorEntered = function()
	
		spectate.Entity:SetBodygroup(1, 1)
		LocalPlayer():EmitSound("TV.Tune")
		
	end
	
	function teambutton3.DoClick() RunConsoleCommand( "tf_spectate" ) ClassFrame:Close() end
	
	function iconC:LayoutEntity( ent )
		return
	end]]
	
end


concommand.Add("tf_changeteam", TeamSelection)