
if !IsMounted("tf") then
	ErrorNoHalt("TF2 is not mounted! Expect errors!")
	if CLIENT then
		local conflict_help_frame = vgui.Create( "DFrame" )
		conflict_help_frame:SetSize(200, 200)
		conflict_help_frame:Center()
		conflict_help_frame:SetTitle("!!TF2 IS NOT MOUNTED!!")
		conflict_help_frame:ShowCloseButton(false)
		conflict_help_frame:SetBackgroundBlur(true)
		conflict_help_frame:MakePopup()

		local conflicttext = vgui.Create("RichText", conflict_help_frame)
		conflicttext:Dock(FILL)
		conflicttext:InsertColorChange(255, 255, 255, 255)
		conflicttext:CenterHorizontal(0.5)
		conflicttext:SetVerticalScrollbarEnabled(false)
		conflicttext:AppendText("Unfortuntely, you cannot play this gamemode because you do not have Team Fortress 2 Mounted. Please get it from the steam store.")
		local conflictbut = vgui.Create("DButton", conflict_help_frame)
		conflictbut:SetSize(100, 30)
		conflictbut:SetPos(0, 145)
		conflictbut:CenterHorizontal(0.5)
		conflictbut:SetText("Ok") 

		function conflictbut.DoClick()
			RunConsoleCommand("disconnect")
			gui.OpenURL("https://store.steampowered.com/app/440")
		end
	end
end 