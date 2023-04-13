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
	local TeamNeutral = vgui.Create( "DButton", teamframe )
	function TeamNeutral.DoClick() RunConsoleCommand( "changeteam", 5 ) teamframe:Close() end
	TeamNeutral:SetPos( 10, 85 )
	TeamNeutral:SetSize( 130, 20 )
	TeamNeutral:SetText( "Neutral Team" )
	local TeamFriendly = vgui.Create( "DButton", teamframe )
	function TeamFriendly.DoClick() RunConsoleCommand( "changeteam", 6 ) teamframe:Close() end
	TeamFriendly:SetPos( 10, 125 )
	TeamFriendly:SetSize( 130, 20 )
	TeamFriendly:SetText( "Friendly Team" )
	teamframe:SetSize(150,150) --set its size
	teamframe:Center() --position it at the center of the screen 
	teamframe:SetDraggable(false) --can you move it around
	teamframe:SetSizable(false) --can you resize it?
	teamframe:ShowCloseButton(true) --can you close it
	teamframe:MakePopup() --make it appear
	teamframe:SetKeyboardInputEnabled( false )
	
end


concommand.Add("tf_changeteam", TeamSelection)